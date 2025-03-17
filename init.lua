-- 加载配置选项
require("config.options")
-- 加载键映射配置
require("config.keymaps")
require("config.indent")
-- 定义 lazy.nvim 插件的路径
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 如果路径不存在，则克隆 lazy.nvim 插件
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- 克隆最新的稳定版本
        lazypath,
    })
end

-- 将 lazy.nvim 插件路径添加到运行时路径中
vim.opt.rtp:prepend(lazypath)

-- 配置并加载 lazy.nvim 插件
require("lazy").setup({
    spec = {
        {import = "plugins/impatient"},
        { import = "plugins/onedark" }, -- 主题优先加载
        { import = "plugins/navigation" }, -- 导航
        { import = "plugins/lualine" }, -- 状态栏
        { import = "plugins/bufferline" }, -- 标签栏
        { import = "plugins/nvimtree" }, -- 文件树
        { import = "plugins/telescope" }, -- 模糊搜索
        { import = "plugins/which-key" }, -- 快捷键提示
        { import = "plugins/autopairs" }, -- 括号补全
        { import = "plugins/rainbow" }, -- 彩虹括号
        { import = "plugins/comment" }, -- 注释
        { import = "plugins/treesitter" },
        { import = "plugins/treesitter-context" },
        { import = "plugins/coc" },
        -- 其他模块...
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "netrw",     -- 禁用 netrw 插件
                "netrwPlugin", -- 禁用 netrw 插件
                "netrwSettings", -- 禁用 netrw 插件
                "netrwFileHandlers", -- 禁用 netrw 插件
            },
        },
    },
})