return {
  -- 类 VSCode 主题
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("onedark")
    end
  },

  -- Coc 智能补全核心
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = "yarn install",
    config = function()
      -- 更精确的补全控制 -------------------------------------------------------
      -- 检查是否是Coc的补全菜单
      local function check_back_space()
        local col = vim.fn.col('.') - 1
        return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
      end

      -- 改进的快捷键映射
      vim.api.nvim_set_keymap("i", "<TAB>", [[coc#pum#visible() ? coc#pum#next(1) : (check_back_space() ? "<TAB>" : coc#refresh())]], {noremap = true, silent = true, expr = true})
      vim.api.nvim_set_keymap("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "<C-h>"]], {noremap = true, silent = true, expr = true})
      vim.api.nvim_set_keymap("i", "<CR>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], {noremap = true, silent = true, expr = true})

      -- 性能优化配置 ----------------------------------------------------------
      vim.g.coc_config = {
        suggest = {
          noselect = true,          -- 不自动选择第一个补全项
          enablePreview = false,   -- 关闭预览提升性能
          enablePreselect = false, -- 关闭预选
          debounce = 100,          -- 降低输入延迟
          minInput = 1             -- 输入1个字符后触发补全
        },
        signature = {
          enable = false           -- 暂时关闭签名帮助
        },
        coc = {
          enableTriggerCompletion = false, -- 禁用自动触发
          lazyLoad = true          -- 启用懒加载
        }
      }

      -- 精简扩展列表（按需加载）
      vim.g.coc_global_extensions = {
        'coc-tsserver', 
        'coc-json', 
        'coc-html', 
        'coc-css',
        'coc-prettier',
        'coc-eslint',
        'coc-snippets'
      }

      -- 优化补全触发逻辑
      vim.api.nvim_create_autocmd("User", {
        pattern = "CocSetup",
        callback = function()
          vim.fn.CocAddConfig("suggest.triggerAfterInsertEnter", false)
          vim.fn.CocAddConfig("suggest.triggerCharacters", {".", ":", "/", "("})
        end
      })

      -- Snippets 优化配置
      vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>(coc-snippets-expand-jump)", {})
      vim.api.nvim_set_keymap("s", "<C-j>", "<Plug>(coc-snippets-expand-jump)", {})
      vim.api.nvim_set_keymap("s", "<C-k>", "<Plug>(coc-snippets-expand-jump)", {})

    end
  },

  -- 可选：如果存在其他补全插件需要禁用
  -- { "nvim-cmp", enabled = false },  -- 示例：禁用 nvim-cmp
}