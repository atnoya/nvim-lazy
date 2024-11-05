-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local cmd = vim.cmd

local utils = {}

-- Highlights functions

-- Define bg color
-- @param group Group
-- @param color Color
-- @param gui bold or other

utils.bg = function(group, col, gui)
  local resolved = gui or "NONE"
  cmd("hi " .. group .. " guibg=" .. col .. " gui=" .. resolved)
end

-- Define fg color
-- @param group Group
-- @param color Color
-- @param gui bold or other
utils.fg = function(group, col, gui)
  local resolved = gui or "NONE"
  cmd("hi " .. group .. " guifg=" .. col .. " gui=" .. resolved)
end

-- Define bg and fg color
-- @param group Group
-- @param fgcol Fg Color
-- @param bgcol Bg Color
-- @param gui bold or other
utils.fg_bg = function(group, fgcol, bgcol, gui)
  local resolved = gui or "NONE"
  cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol .. " gui=" .. resolved)
end

utils.link = function(group, target_group)
  cmd("hi link " .. group .. " " .. target_group)
end

local light_black = "#3D3D3D"
local col_bg_black = "#3c3836"
local dark_black = "#222222"
local dark_white = "#BBBBBB"
local white = "#ebdbb2"

utils.set_telescope_custom_colors_gruvbox = function()
  -- Telescope
  utils.bg("TelescopeNormal", dark_black)
  utils.fg_bg("TelescopeTitle", dark_black, dark_black)
  utils.fg_bg("TelescopeBorder", dark_black, dark_black)

  utils.fg_bg("TelescopePromptBorder", light_black, light_black)
  utils.fg_bg("TelescopePromptPrefix", white, light_black, "bold")
  utils.fg_bg("TelescopePromptTitle", white, "#BB3333")
  utils.fg_bg("TelescopePromptNormal", white, light_black)
  utils.fg_bg("TelescopePromptCounter", white, light_black)

  utils.fg_bg("TelescopePreviewBorder", dark_black, dark_black)
  utils.fg_bg("TelescopePreviewTitle", white, "#338833")
  utils.fg_bg("TelescopePreviewNormal", dark_white, dark_black)

  utils.fg_bg("TelescopeResultsBorder", dark_black, dark_black)
  utils.fg_bg("TelescopeResultsTitle", dark_black, dark_black)
  utils.fg_bg("TelescopeResultsNormal", dark_white, dark_black)

  utils.fg_bg("TelescopeSelection", white, dark_black, "bold")
  utils.fg("TelescopeSelectionCaret", "#BB4444", "bold")

  -- Telescope custom LSP entries
  utils.fg("TelescopeCustomSymbolPath", "#666666")

  -- Noice, Notify, StatusCol
  utils.bg("NotifyBackground", light_black)
  utils.fg_bg("NoicePopupBorder", dark_black, dark_black)
  utils.fg_bg("NoicePopupmenuBorder", dark_black, dark_black)
  utils.fg_bg("NoiceCmdlinePopupBorder", dark_black, dark_black)
  utils.fg_bg("NoiceCmdlinePopupBorderSearch", dark_black, dark_black)
  utils.fg_bg("NoiceCmdlinePopupBorderFilter", dark_black, dark_black)
  utils.fg_bg("NoiceCmdlinePopupBorderHelp", dark_black, dark_black)
  utils.fg_bg("NoiceCmdlinePopupBorderIncRename", dark_black, dark_black)
  utils.fg_bg("NoiceCmdlinePopupBorderInput", dark_black, dark_black)
  utils.fg_bg("NoiceCmdlinePopupBorderLua", dark_black, dark_black)
  utils.bg("NoiceCmdlineIcon", dark_black)
  utils.bg("NoiceCmdlineIconSearch", dark_black)
  utils.bg("NoiceCmdlinePopup", dark_black)
  utils.fg_bg("NoiceCmdline", white, dark_black)
  utils.fg_bg("NoiceCmdlinePrompt", white, dark_black)
  utils.fg_bg("NoicePopup", white, dark_black)
  utils.fg_bg("NormalFloat", white, dark_black)
  utils.fg_bg("FloatBorder", dark_black, dark_black)
  utils.fg("DiagnosticFloatingError", white)
  utils.fg("DiagnosticFloatingWarn", white)
  utils.fg("DiagnosticFloatingInfo", white)
  utils.fg("DiagnosticFloatingHint", white)
  utils.fg("DiagnosticFloatingOk", white)
  utils.link("DiagnosticSignError", "GruvboxRed")
  utils.link("DiagnosticSignWarn", "GruvboxOrange")
  utils.link("DiagnosticSignInfo", "GruvboxBlue")
  utils.link("DiagnosticSignHint", "GruvboxAqua")
  utils.link("DiagnosticSignOk", "DiagnosticOk")

  utils.fg("TroubleText", white)
  utils.fg("TroubleNormal", white)

  utils.bg("SignColumn", col_bg_black)
  utils.bg("FoldColumn", col_bg_black)
  utils.fg("TroubleFoldIcon", "#fabd2f")
end

utils.set_indent_blank_line_custom_colors = function()
  -- Blank line
  utils.fg("IndentBlanklineContextPattern", "#DDDDDD", "nocombine")
  utils.fg("IndentBlanklineContextChar", "#CCCCCC", "nocombine")
end

return utils
