local colors = require("onedarkpro.helpers").get_colors()
local icons = require("config.icons")

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = "onedark",
      globalstatus = true,
      component_separators = "",
      section_separators = { left = "", right = "" },
      disabled_filetypes = { statusline = { "alpha", "neo-tree" } },
    },
    sections = {
      lualine_a = {
        {
          "mode",
          icon = icons.misc.vim,
          separator = { left = "", right = "" },
          color = { bg = colors.blue, fg = colors.bg },
        },
      },
      lualine_b = { { "branch", icon = icons.misc.branch } },
      lualine_c = { { "filename", path = 1 } }, -- Relative file path
      lualine_x = {
        {
          "diff",
          symbols = {
            added = icons.git.added .. " ",
            modified = icons.git.modified .. " ",
            removed = icons.git.removed .. " ",
          },
          diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed = { fg = colors.red },
          },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
        { "diagnostics", symbols = icons.diagnostics },
        { "encoding", fmt = string.upper }, -- File encoding (e.g., UTF-8)
      },
      lualine_y = { "filetype" },
      lualine_z = {
        {
          "progress",
          separator = { left = "", right = "" },
          color = { bg = colors.green, fg = colors.bg },
        },
      },
    },
    extensions = { "neo-tree" },
  },
}