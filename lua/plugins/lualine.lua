local M = {}

local colors = {
  bg     = "#282C34",
  mode   = { n = "#61AFEF", i = "#98C379", v = "#E5C07B", c = "#E06C75", V = "#E5C07B", [""] = "#E5C07B" },
  white  = "#ABB2BF",
  cyan   = "#56B6C2",
  blue   = "#61AFEF",
  green  = "#98C379",
  yellow = "#E5C07B",
  red    = "#E06C75",
  black  = "#000000"
}

local icons = {
  mode        = " ",
  branch      = " ",
  file        = " ",
  clock       = " ",
  diagnostics = { Error = " ", Warn = " ", Info = " " },
  git         = { added = " ", modified = " ", removed = " " }
}

function M.setup()
  vim.opt.laststatus = 3
  vim.opt.showmode   = false

  require("lualine").setup({
    options = {
      theme              = "onedark",
      globalstatus       = true,
      component_separators = "",
      section_separators   = "",
      disabled_filetypes = { "alpha", "dashboard", "NvimTree", "neo-tree", "TelescopePrompt" },
      refresh            = { statusline = 200 },
    },
    sections = {
      lualine_a = {
        {
          "mode",
          icon = icons.mode,
          color = function()
            local mode = vim.fn.mode()
            return { fg = colors.bg, bg = colors.mode[mode] or colors.mode.n, gui = "bold" }
          end,
          padding = { left = 1, right = 1 }
        }
      },
      lualine_b = {
        { "branch", icon = icons.branch, color = { fg = colors.white } }
      },
      lualine_c = {
        { "diagnostics", symbols = icons.diagnostics, update_in_insert = false }
      },
      lualine_x = {
        {
          require("lazy.status").updates,
          cond  = require("lazy.status").has_updates,
          color = { fg = colors.cyan }
        },
        {
          "diff",
          symbols = icons.git,
          source  = function() return vim.b.gitsigns_status_dict or {} end,
          diff_color = {
            added    = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed  = { fg = colors.red }
          }
        }
      },
      lualine_y = {
        { "encoding", fmt = function() return icons.file .. " " .. vim.bo.fenc:upper() end, color = { fg = colors.blue } },
        { "progress", fmt = function() return " %p%%" end, color = { fg = colors.cyan } },
        { "location", padding = { right = 1 } }
      },
      lualine_z = {
        { "datetime", fmt = function() return icons.clock .. os.date("%H:%M") end, color = { fg = colors.black } }
      }
    },
    extensions = { "neo-tree", "toggleterm" }
  })
end

return {
  { "nvim-lualine/lualine.nvim", event = "VeryLazy", dependencies = { "nvim-web-devicons" }, config = M.setup }
}
