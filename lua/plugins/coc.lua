return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    config = function()
      vim.g.coc_global_extensions = {
        'coc-clangd',
        'coc-snippets',
        'coc-json',
        'coc-tsserver',
        'coc-pyright'
      }

      -- IDE风格键位映射
      local map = vim.keymap.set
      local opts = { silent = true, noremap = true, expr = true }

      -- 智能导航
      map('i', '<TAB>', [[coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"]], opts)
      map('i', '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
      map('i', '<CR>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

      -- 代码操作
      map('n', 'gd', '<Plug>(coc-definition)', { desc = '跳转到定义' })
      map('n', 'gr', '<Plug>(coc-references)', { desc = '查找引用' })
      map('n', '<leader>rn', '<Plug>(coc-rename)', { desc = '重命名符号' })
      map('x', '<leader>f', '<Plug>(coc-format-selected)', { desc = '格式化选中区域' })
    end
  },
  {
    "L3MON4D3/LuaSnip",  -- 添加必要的snippet引擎
    dependencies = "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      preview = { winblend = 10 }
    }
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        stages = "slide",
        timeout = 1500,
        background_colour = "#1e2030",
        fps = 60  -- 提高渲染性能
      })
      vim.notify = require("notify")
    end
  },
  {
    "nvim-lualine/lualine.nvim",  -- 极简状态栏
    opts = {
      options = {
        theme = "tokyonight",
        component_separators = '|',
        section_separators = ''
      }
    }
  }
}