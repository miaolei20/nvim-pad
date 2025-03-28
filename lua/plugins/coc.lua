return {
  -- VSCode-like theme
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("onedark")
    end
  },

  -- Coc completion core optimized for C/C++
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = "yarn install",
    config = function()
      -- TAB mapping with inline backspace check for natural behavior
      vim.api.nvim_set_keymap("i", "<TAB>",
        [[coc#pum#visible() ? coc#pum#next(1) : (col('.') <= 1 || getline('.')[col('.')-2] =~ '\s' ? "\<TAB>" : coc#refresh())]],
        { noremap = true, silent = true, expr = true }
      )
      vim.api.nvim_set_keymap("i", "<S-TAB>",
        [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]],
        { noremap = true, silent = true, expr = true }
      )
      vim.api.nvim_set_keymap("i", "<CR>",
        [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
        { noremap = true, silent = true, expr = true }
      )

      -- Optimized Coc configuration for C/C++
      vim.g.coc_config = {
        suggest = {
          noselect = true,          -- Don't auto-select first item
          enablePreview = false,    -- Disable preview for performance
          enablePreselect = false,  -- Disable pre-selection
          debounce = 50,           -- Faster response for C/C++ typing
          minInput = 1,            -- Trigger after 1 char
          timeout = 500,           -- Completion timeout
          maxMenuWidth = 80        -- Limit menu width
        },
        signature = {
          enable = true,           -- Enable signature help for C/C++ functions
          autoTrigger = "trigger"  -- Trigger only on explicit request
        },
        coc = {
          enableTriggerCompletion = false, -- Disable auto-trigger
          lazyLoad = true                  -- Enable lazy loading
        },
        -- C/C++ specific settings
        ["clangd.arguments"] = {
          "--background-index",          -- Index in background
          "--suggest-missing-includes",  -- Suggest includes
          "--clang-tidy",                -- Enable clang-tidy
          "--header-insertion=iwyu"      -- Include-what-you-use style
        }
      }

      -- Extensions optimized for C/C++
      vim.g.coc_global_extensions = {
        'coc-clangd',       -- C/C++ language server
        'coc-cmake',        -- CMake support
        'coc-json',         -- JSON support (useful for config files)
        'coc-snippets',     -- Snippet support
        'coc-pairs'         -- Auto-pair brackets, useful for C/C++
      }

      -- C/C++ specific completion triggers and diagnostics
      vim.api.nvim_create_autocmd("User", {
        pattern = "CocSetup",
        callback = function()
          vim.fn.CocAddConfig("suggest.triggerAfterInsertEnter", false)
          vim.fn.CocAddConfig("suggest.triggerCharacters", {".", ":", ">", "(", "*"}) -- C++ specific triggers
          vim.fn.CocAddConfig("suggest.acceptSuggestionOnTrigger", true)
          vim.fn.CocAddConfig("suggest.snippetIndicator", " ►")
          -- Filetype-specific settings
          vim.fn.CocAddConfig("languageserver.ccls.enable", false) -- Ensure only clangd is used
        end
      })

      -- Snippet and navigation mappings
      vim.api.nvim_set_keymap("i", "<C-j>", "<Plug>(coc-snippets-expand-jump)", {})
      vim.api.nvim_set_keymap("s", "<C-j>", "<Plug>(coc-snippets-expand-jump)", {})
      vim.api.nvim_set_keymap("s", "<C-k>", "<Plug>(coc-snippets-expand-jump-prev)", {})

      -- Additional C/C++ productivity mappings
      vim.api.nvim_set_keymap("n", "gd", "<Plug>(coc-definition)", { silent = true })
      vim.api.nvim_set_keymap("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
      vim.api.nvim_set_keymap("n", "gi", "<Plug>(coc-implementation)", { silent = true })
      vim.api.nvim_set_keymap("n", "gr", "<Plug>(coc-references)", { silent = true })
    end
  },

  -- Optional: Disable conflicting completion plugins
  -- { "nvim-cmp", enabled = false },
}