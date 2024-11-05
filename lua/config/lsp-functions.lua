local make_entry = require("telescope.make_entry")
local utils = require("telescope.utils")
local entry_display = require("telescope.pickers.entry_display")
local Path = require("plenary.path")

local get_filename_fn = function()
  local bufnr_name_cache = {}
  return function(bufnr)
    bufnr = vim.F.if_nil(bufnr, 0)
    local c = bufnr_name_cache[bufnr]
    if c then
      return c
    end

    local n = vim.api.nvim_buf_get_name(bufnr)
    bufnr_name_cache[bufnr] = n
    return n
  end
end

local lsp_type_highlight = {
  ["Class"] = "TelescopeResultsClass",
  ["Interface"] = "TelescopeResultsClass",
  ["Constant"] = "TelescopeResultsConstant",
  ["Field"] = "TelescopeResultsField",
  ["Function"] = "TelescopeResultsFunction",
  ["Method"] = "TelescopeResultsMethod",
  ["Property"] = "TelescopeResultsOperator",
  ["Object"] = "TelescopeResultsStruct",
  ["Variable"] = "TelescopeResultsVariable",
}

local lsp_symbol_equivalents = {
  ["Object"] = "Module",
  ["Package"] = "Folder",
}

local get_symbol_display = function(entry, type_highlight)
  local s = require("lspkind").symbolic(lsp_symbol_equivalents[entry.symbol_type] or entry.symbol_type)
  if s == "" then
    s = "?"
  end

  return { s, type_highlight[entry.symbol_type] }
end

local scala_path = function(filename)
  local transformed_path = Path:new(filename):make_relative(vim.loop.cwd())
  transformed_path = string.gsub(transformed_path, ".metals/readonly/dependencies/.+%.jar/", ".M/")
  transformed_path = string.gsub(transformed_path, "src/main/scala/", "../")
  transformed_path = string.gsub(transformed_path, "src/main/java/", "../")
  transformed_path = string.gsub(transformed_path, "src/test/scala/", "../")
  transformed_path = string.gsub(transformed_path, "src/test/java/", "../")
  return transformed_path
end

local displayer_fn = function(items)
  return entry_display.create({
    separator = " ",
    hl_chars = { ["["] = "TelescopeBorder", ["]"] = "TelescopeBorder" },
    items = items,
  })
end

local display_fn = function(display_maker, with_path)
  local get_filename = get_filename_fn()
  return function(entry)
    local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))
    local symbol_msg = entry.text
    local symbol_name = symbol_msg:match("%[.+%]%s+(.*)")
    local ordinal = ""
    if with_path and filename then
      ordinal = filename .. " "
    end
    ordinal = ordinal .. symbol_name .. " " .. (entry.symbol_type or "unknown")
    return make_entry.set_default_entry_mt({
      value = entry,
      ordinal = ordinal,
      display = display_maker,

      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      symbol_name = symbol_name,
      symbol_type = entry.kind or "<unknown>",
      start = entry.start,
      finish = entry.finish,
    }, {})
  end
end

local make_doc_lsp_symbol_entry = function(opts)
  opts = opts or {}

  local display_items = {
    { width = opts.symbol_type_width or 2 },
    { width = opts.symbol_type_width or 5 },
    { { width = opts.symbol_width or 120 }, { remaining = true } },
  }

  local displayer = displayer_fn(display_items)

  local type_highlight = vim.F.if_nil(opts.symbol_highlights or lsp_type_highlight)

  local make_display = function(entry)
    return displayer({
      get_symbol_display(entry, type_highlight),
      entry.lnum .. ":" .. entry.col,
      entry.symbol_name,
    })
  end

  return display_fn(make_display, false)
end

local make_ws_lsp_symbol_entry = function(opts)
  opts = opts or {}

  local display_items = {
    { width = opts.symbol_type_width or 2 },
    { { width = opts.symbol_width or 60 }, { remaining = true } },
    { { width = vim.F.if_nil(opts.fname_width, 120) }, { remaining = true } },
  }

  local displayer = displayer_fn(display_items)

  local type_highlight = vim.F.if_nil(opts.symbol_highlights or lsp_type_highlight)

  local make_display = function(entry)
    local isSearchInDeps = string.find(entry.symbol_name, "search library dependencies")

    if isSearchInDeps then
      return displayer({
        get_symbol_display(entry, type_highlight),
        { entry.symbol_name, "TelescopeCustomSymbolPath" },
        "",
      })
    else
      local path = ""
      if opts.is_scala then
        path = scala_path(entry.filename)
      else
        path = utils.transform_path(opts, entry.filename)
      end
      return displayer({
        get_symbol_display(entry, type_highlight),
        entry.symbol_name,
        { path, "TelescopeCustomSymbolPath" },
      })
    end
  end
  return display_fn(make_display, true)
end

local make_qf_lsp_entry = function(opts)
  opts = opts or {}

  local display_items = {
    { width = opts.filename_width or 120 },
  }

  local displayer = displayer_fn(display_items)

  -- local type_highlight = vim.F.if_nil(opts.symbol_highlights or lsp_type_highlight)

  local make_display = function(entry)
    local path = ""
    if opts.is_scala then
      path = scala_path(entry.filename)
    else
      path = utils.transform_path(opts, entry.filename)
    end
    return displayer({
      { path .. ":" .. entry.lnum .. ":" .. entry.col },
    })
  end

  local get_filename = get_filename_fn()

  return function(entry)
    local filename = vim.F.if_nil(entry.filename, get_filename(entry.bufnr))
    local ordinal = filename .. ":" .. entry.lnum

    return make_entry.set_default_entry_mt({
      value = entry,
      ordinal = ordinal,
      display = make_display,
      filename = filename,
      lnum = entry.lnum,
      col = entry.col,
      text = entry.text,
      start = entry.start,
      finish = entry.finish,
    }, opts)
  end
end

local M = {}

M.lsp_definitions_custom = function()
  require("telescope.builtin").lsp_definitions({
    entry_maker = make_qf_lsp_entry({
      is_scala = vim.g["metals_status"] ~= nil,
    }),
  })
end

M.lsp_implementations_custom = function()
  require("telescope.builtin").lsp_implementations({
    entry_maker = make_qf_lsp_entry({
      is_scala = vim.g["metals_status"] ~= nil,
    }),
  })
end

M.lsp_references_custom = function()
  require("telescope.builtin").lsp_references({
    entry_maker = make_qf_lsp_entry({
      is_scala = vim.g["metals_status"] ~= nil,
    }),
  })
end

M.lsp_document_symbols_custom = function()
  require("telescope.builtin").lsp_document_symbols({
    entry_maker = make_doc_lsp_symbol_entry({
      is_scala = vim.g["metals_status"] ~= nil,
    }),
  })
end

M.lsp_dynamic_workspace_symbols_custom = function()
  require("telescope.builtin").lsp_dynamic_workspace_symbols({
    entry_maker = make_ws_lsp_symbol_entry({
      is_scala = vim.g["metals_status"] ~= nil,
    }),
  })
end

local signs = {}

signs[vim.diagnostic.severity.ERROR] = ""
signs[vim.diagnostic.severity.WARN] = ""
signs[vim.diagnostic.severity.HINT] = ""
signs[vim.diagnostic.severity.INFO] = ""

local sign_hls = {}
sign_hls[vim.diagnostic.severity.ERROR] = "DiagnosticSignError"
sign_hls[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn"
sign_hls[vim.diagnostic.severity.HINT] = "DiagnosticSignHint"
sign_hls[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo"

M.show_diagnostic_popup = function(_)
  vim.diagnostic.open_float({
    border = "single",
    format = function(diag)
      -- local sign = signs[diag.severity]
      return diag.message
    end,
    prefix = function(diag, _, _)
      local sign = signs[diag.severity]
      local sign_hl = sign_hls[diag.severity]
      return sign .. " ", sign_hl
    end,
    suffix = "",
    header = nil,
  })
end

M.metals_cmds = function()
  require("telescope").extensions.metals.commands()
end

M.metals_compile_cascade = function()
  require("metals").compile_cascade()
end

M.lsp_hover = function()
  vim.lsp.buf.hover()
end

M.diagnostics_current_buf_t = function()
  require("telescope.builtin").diagnostics({ bufnr = 0 })
end

M.diagnostics_errors_t = function()
  require("telescope.builtin").diagnostics({ severity = "E" })
end

M.diagnostics_all_t = function()
  require("telescope.builtin").diagnostics()
end

M.signature_help = function()
  vim.lsp.buf.signature_help()
end

M.metals_reveal_treeview = function()
  require("metals.tvp").reveal_in_tree()
end

M.metals_toggle_treeview = function()
  require("metals.tvp").toggle_tree_view()
end

M.find_projects = function()
  require("telescope").extensions.projects.projects({})
end

return M
