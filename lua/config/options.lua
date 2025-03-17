-- 显示行号
vim.opt.number = true
-- 显示相对行号
vim.opt.relativenumber = true
-- 将 Tab 转换为空格
vim.opt.expandtab = true
-- Tab 显示为 4 空格
vim.opt.tabstop = 4
-- 自动缩进时每级缩进 4 空格
vim.opt.shiftwidth = 4
-- 智能缩进
vim.opt.smartindent = true
-- 启用终端真彩色
vim.opt.termguicolors = true
-- 忽略大小写
vim.opt.ignorecase = true
-- 智能大小写
vim.opt.smartcase = true
-- 启用终端真彩色（重复设置，保留以防止遗漏）
vim.opt.termguicolors = true
-- 不显示模式（因为 lualine 已经显示模式）
vim.opt.showmode = false
-- 补全选项
vim.opt.completeopt = { "menu", "menuone", "noselect" }
-- 缩短消息显示时间
vim.opt.shortmess:append("c")
-- 设置更新间隔为 300 毫秒
vim.opt.updatetime = 300

-- 创建自动命令，在文本复制后高亮显示
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yanked text", -- 添加描述（最佳实践）
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }), -- 创建独立组
  callback = function()
    vim.highlight.on_yank { timeout = 300 } -- 高亮显示复制的文本，持续 300 毫秒
  end
})


-- 一键运行（优化版：编译文件存放至build目录）
local function compile_and_run()
    -- 获取文件信息（带路径处理）
    local file_name = vim.fn.expand('%:t')           -- 带后缀的文件名
    local file_name_no_ext = vim.fn.expand('%:t:r')  -- 无后缀文件名
    local ext = vim.fn.expand('%:e'):lower()         -- 扩展名（强制小写）
    local current_dir = vim.fn.expand('%:p:h')       -- 当前文件绝对路径目录
    local build_dir = current_dir .. '/build'        -- 构建目录路径

    -- 仅支持 C/C++ 文件
    if ext ~= 'c' and ext ~= 'cpp' then
        print('[Error] Not a C/C++ file: ' .. file_name)
        return
    end

    -- 创建构建目录（如果不存在）
    if vim.fn.isdirectory(build_dir) == 0 then
        local success = vim.fn.mkdir(build_dir, 'p')
        if success == 0 then
            print('[Error] Failed to create build directory: ' .. build_dir)
            return
        end
    end

    -- 动态选择编译器
    local compiler = (ext == 'c') and 'gcc' or 'g++'
    local output_path = 'build/' .. file_name_no_ext  -- 相对路径写法更安全

    -- 构建完整编译命令（带错误检测）
    local compile_cmd = string.format(
        'cd "%s" && %s "%s" -o "%s" && ./"%s"',      -- 引号包裹防空格路径
        current_dir, compiler, file_name, output_path, output_path
    )

    -- 创建浮动终端（更现代的风格）
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = 85,
        height = 15,
        col = (vim.o.columns - 85) / 2,              -- 居中显示
        row = (vim.o.lines - 15) / 2,
        style = 'minimal',
        border = 'rounded'
    })

    -- 异步运行并实时显示输出
    vim.fn.termopen(compile_cmd, {
        on_exit = function(_, code, _)
            if code ~= 0 then
                vim.api.nvim_buf_set_lines(buf, -1, -1, true,
                    {'[Exit Code] '..code..' | 编译失败，请检查错误信息！'})
            end
        end
    })

    -- 自动进入终端模式（支持 Neovim 0.9+ 的改进方式）
    vim.schedule(function()
        vim.cmd.startinsert({ bang = true })
    end)
end

-- 注册命令和快捷键
vim.api.nvim_create_user_command('RunCode', compile_and_run, { desc = '编译运行当前C/C++文件' })
vim.keymap.set('n', '<C-r>', ':RunCode<CR>', { noremap = true, silent = true, desc = '运行代码' })
