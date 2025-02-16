return{
      {
        "neoclide/coc.nvim",
        branch = "release",
        config = function()
            -- Coc基本配置
            vim.g.coc_global_extensions = {
                'coc-clangd',     -- C++语言支持
                'coc-snippets'    -- 代码片段支持
            }

            -- 快捷键配置
            vim.api.nvim_set_keymap('i', '<TAB>', 'coc#pum#visible() ? coc#pum#next(1) : "<TAB>"', {expr = true, noremap = true})
            vim.api.nvim_set_keymap('i', '<S-TAB>', 'coc#pum#visible() ? coc#pum#prev(1) : "<C-h>"', {expr = true, noremap = true})
            vim.api.nvim_set_keymap('i', '<CR>', 'coc#pum#visible() ? coc#pum#confirm() : "<C-G>u<CR>"', {expr = true, noremap = true})

            -- 自动补全括号配置
            vim.api.nvim_set_keymap('i', '<leader>]', 'coc#_insert_parentheses()', {expr = true, noremap = true})

        end
    },
  { 
    "garymjr/nvim-snippets",  -- 更美观的代码片段展示
    dependencies = "rafamadriz/friendly-snippets"
  },
  { 
    "kevinhwang91/nvim-bqf",  -- 优化QuickFix窗口
    ft = "qf"
  },
{ 'rcarriga/nvim-notify', config = function() vim.notify = require("notify") end }
}