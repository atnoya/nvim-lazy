local funcs = require("config/lsp-functions")

return {
  {
    "onsails/lspkind.nvim",
    opts = {
      mode = "symbol",
      preset = "default",
      symbol_map = {
        Text = "󰀬",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰊄",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        metals = {
          keys = {
            { "<leader>me", funcs.metals_cmds, desc = "Metals commands" },
            { "<leader>mc", funcs.metals_compile_cascade, desc = "Metals compile cascade" },
            { "K", funcs.lsp_hover, desc = "LSP Hover", remap = false },
            { "<leader>cD", funcs.lsp_definitions_custom, desc = "LSP Definitions", remap = false },
            { "<leader>cR", "<cmd>Trouble lsp_references<cr>", desc = "LSP References (Trouble)", remap = false },
            { "<leader>cds", funcs.lsp_document_symbols_custom, desc = "LSP Doc Symbols", remap = false },
            { "<leader>ci", funcs.lsp_implementations_custom, desc = "LSP Implementations", remap = false },
            { "<leader>cr", funcs.lsp_references_custom, desc = "LSP References", remap = false },
            { "<leader>cws", funcs.lsp_dynamic_workspace_symbols_custom, desc = "LSP WS Symbols", remap = false },
            { "<leader>xtd", funcs.diagnostics_current_buf_t, desc = "Current buffer diagnostics" },
            { "<leader>xtw", funcs.diagnostics_errors_t, desc = "All workspace errors" },
            { "<leader>xtx", funcs.diagnostics_all_t, desc = "All workspace diagnostics" },
            { "<leader>cc", funcs.show_diagnostic_popup, desc = "Diagnostic popup current line" },
            { "<leader>ch", funcs.lsp_hover, desc = "Hover" },
            { "<leader>csh", funcs.signature_help, desc = "Signature Help" },
            { "<leader>mtc", funcs.metals_reveal_treeview, desc = "Reveal file in LSP Tree view" },
            { "<leader>mtv", funcs.metals_toggle_treeview, desc = "Toggle LSP Tree view" },
          },
          init_options = {
            statusBarProvider = "off",
          },
          settings = {
            showImplicitArguments = true,
            excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl", "--com.oracle" },
          },
        },
      },
      setup = {
        metals = function(_, opts)
          local metals = require("metals")
          local metals_config = vim.tbl_deep_extend("force", metals.bare_config(), opts)
          metals_config.on_attach = LazyVim.has("nvim-dap") and metals.setup_dap or nil

          local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "scala", "sbt" },
            callback = function()
              metals.initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group,
          })
          return true
        end,
      },
    },
  },
}
