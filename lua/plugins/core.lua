return {
  -- add gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    opts = function()
      local light_black = "#3D3D3D"
      local col_bg_black = "#3c3836"
      local dark_black = "#222222"
      local dark_white = "#BBBBBB"
      local white = "#ebdbb2"
      return {
        overrides = {
          TelescopeNormal = { bg = dark_black },
          TelescopeTitle = { fg = dark_black, bg = dark_black },
          TelescopeBorder = { fg = dark_black, bg = dark_black },

          TelescopePromptBorder = { fg = light_black, bg = light_black },
          TelescopePromptPrefix = { fg = white, bg = light_black, bold = true },
          TelescopePromptTitle = { fg = white, bg = "#BB3333" },
          TelescopePromptNormal = { fg = white, bg = light_black },
          TelescopePromptCounter = { fg = white, bg = light_black },

          TelescopePreviewBorder = { fg = dark_black, bg = dark_black },
          TelescopePreviewTitle = { fg = white, bg = "#338833" },
          TelescopePreviewNormal = { fg = dark_white, bg = dark_black },

          TelescopeResultsBorder = { fg = dark_black, bg = dark_black },
          TelescopeResultsTitle = { fg = dark_black, bg = dark_black },
          TelescopeResultsNormal = { fg = dark_white, bg = dark_black },

          TelescopeSelection = { fg = white, bg = dark_black, bold = true },
          TelescopeSelectionCaret = { fg = "#BB4444", bold = true },
          TelescopeCustomSymbolPath = { fg = "#666666" },

          -- Noice, Notify, StatusCol
          NotifyBackground = { bg = light_black },
          NoicePopupBorder = { fg = dark_black, bg = dark_black },
          NoicePopupmenuBorder = { fg = dark_black, bg = dark_black },
          NoiceCmdlinePopupBorder = { fg = dark_black, bg = dark_black },
          NoiceCmdlinePopupBorderSearch = { fg = dark_black, bg = dark_black },
          NoiceCmdlinePopupBorderFilter = { fg = dark_black, bg = dark_black },
          NoiceCmdlinePopupBorderHelp = { fg = dark_black, bg = dark_black },
          NoiceCmdlinePopupBorderIncRename = { fg = dark_black, bg = dark_black },
          NoiceCmdlinePopupBorderInput = { fg = dark_black, bg = dark_black },
          NoiceCmdlinePopupBorderLua = { fg = dark_black, bg = dark_black },
          NoiceCmdlineIcon = { bg = dark_black },
          NoiceCmdlineIconSearch = { bg = dark_black },
          NoiceCmdlinePopup = { bg = dark_black },
          NoiceCmdline = { fg = white, bg = dark_black },
          NoiceCmdlinePrompt = { fg = white, bg = dark_black },
          NoicePopup = { fg = white, bg = dark_black },
          NormalFloat = { fg = white, bg = dark_black },
          FloatBorder = { fg = dark_black, bg = dark_black },
          DiagnosticFloatingError = { fg = white },
          DiagnosticFloatingWarn = { fg = white },
          DiagnosticFloatingInfo = { fg = white },
          DiagnosticFloatingHint = { fg = white },
          DiagnosticFloatingOk = { fg = white },
          -- utils.link("DiagnosticSignError", "GruvboxRed")
          -- utils.link("DiagnosticSignWarn", "GruvboxOrange")
          -- utils.link("DiagnosticSignInfo", "GruvboxBlue")
          -- utils.link("DiagnosticSignHint", "GruvboxAqua")
          -- utils.link("DiagnosticSignOk", "DiagnosticOk")

          TroubleText = { fg = white },
          TroubleNormal = { fg = white },

          SignColumn = { bg = col_bg_black },
          FoldColumn = { bg = col_bg_black },
          TroubleFoldIcon = { fg = "#fabd2f" },
        },
      }
    end,
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    keys = {
      { "<leader>fh", "<cmd>Telescope heading<cr>", desc = "Telescope Headings", remap = false },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Telescope Keymaps", remap = false },
      { "<leader>fp", require("config.lsp-functions").find_projects, desc = "Open project", remap = false },
    },
    opts = {
      colorscheme = "gruvbox",
    }
  },
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        patterns = { ".git", "Makefile", "*.sln", "build/env.sh" },
      })
    end,
    dependencies = {
      { "nvim-telescope/telescope.nvim" },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        group_empty_dirs = true,
      },
    },
  },
}
