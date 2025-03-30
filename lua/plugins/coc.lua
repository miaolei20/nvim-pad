local M = {}

function M:setup()
  -- 键位映射
  vim.keymap.set("i", "<TAB>",
    [[coc#pum#visible() ? coc#pum#next(1) : (col('.') <= 1 || getline('.')[col('.')-2] =~ '\s' ? "\<TAB>" : coc#refresh())]],
    { expr = true, silent = true })
  vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], { expr = true, silent = true })
  vim.keymap.set("i", "<CR>",
    [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
    { expr = true, silent = true })
  vim.keymap.set({ "i", "s" }, "<C-j>", "<Plug>(coc-snippets-expand-jump)", {})
  vim.keymap.set("s", "<C-k>", "<Plug>(coc-snippets-expand-jump-prev)", {})
  vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true })
  vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
  vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true })
  vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true })

  -- Coc 配置
  vim.g.coc_config = {
    suggest = {
      noselect = true,
      debounce = 50,
      minInput = 1,
    },
    signature = { enable = true, autoTrigger = "trigger" },
    coc = { lazyLoad = true },
    ["clangd.arguments"] = {
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu",
    },
  }

  -- Coc 扩展
  vim.g.coc_global_extensions = {
    "coc-clangd",
    "coc-cmake",
    "coc-json",
    "coc-snippets",
    "coc-pairs",
  }

  -- C/C++ 特定设置
  vim.api.nvim_create_autocmd("User", {
    pattern = "CocSetup",
    callback = function()
      vim.fn.CocAddConfig("suggest.triggerCharacters", { ".", ":", ">", "(", "*" })
      vim.fn.CocAddConfig("suggest.snippetIndicator", " ►")
    end,
  })
end

return {
  {
    "neoclide/coc.nvim",
    branch = "release",
    build = "yarn install",
    config = M["setup"],
  },
}