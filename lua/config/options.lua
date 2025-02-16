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


-- 一键运行（优化光标插入模式）
-- 定义一个编译并运行当前 C/C++ 文件的函数
local function compile_and_run()
  -- 获取当前文件名、无后缀文件名和文件扩展名
  local file = vim.fn.expand('%')
  local file_no_ext = vim.fn.expand('%:r')
  local ext = vim.fn.expand('%:e')
  local cmd = nil

  if ext == "c" then
    -- 对于 C 文件，使用 gcc 编译
    cmd = string.format("gcc %s -o %s && ./%s", file, file_no_ext, file_no_ext)
  elseif ext == "cpp" then
    -- 对于 C++ 文件，使用 g++ 编译
    cmd = string.format("g++ %s -o %s && ./%s", file, file_no_ext, file_no_ext)
  else
    -- 如果文件不是 C/C++ 文件，打印提示信息
    print("当前文件不是 C/C++ 文件！")
    return
  end

  -- 创建下方终端窗口
  vim.cmd("botright split | resize 10")  -- 向下分割并调整高度
  
  -- 创建新缓冲区并关联到窗口
  local buf = vim.api.nvim_create_buf(false, true)  -- 创建无列表的临时缓冲区
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  
  -- 在缓冲区中运行终端命令
  vim.fn.termopen(cmd, {
    on_exit = function(job_id, exit_code, event)
      -- 可选：程序退出时的处理逻辑
      -- 例如自动关闭窗口：vim.api.nvim_win_close(win, true)
    end
  })
  
  -- 自动进入插入模式（重要改进！）
  vim.cmd("startinsert")
end

-- 创建用户命令 RunCode 调用上面的函数
vim.api.nvim_create_user_command("RunCode", compile_and_run, {})

-- 绑定快捷键 F5 运行代码
vim.keymap.set("n", "<leader>r", ":RunCode<CR>", { noremap = true, silent = true, desc = "运行代码" })

-- Coc美化配置
vim.api.nvim_set_hl(0, 'CocMenuSel', { bg = '#3a3a3a', fg = 'white' })  -- 选中项背景色
vim.api.nvim_set_hl(0, 'CocFloating', { bg = '#262626' })              -- 补全窗口背景色

vim.g.coc_enable_highlight = 1  -- 启用高亮匹配项
vim.g.coc_snippet_next = '<TAB>' -- 代码片段跳转快捷键
vim.g.coc_snippet_prev = '<S-TAB>'

-- 浮动窗口透明效果（需Neovim 0.9+）
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#666666', bg = 'none' })

-- 配置补全窗口边框
vim.cmd([[ autocmd User CocOpenFloat call nvim_win_set_config(g:coc_last_float_win, {'border': 'rounded'}) ]])
-- 函数参数提示样式
vim.api.nvim_set_hl(0, 'CocHintSign', { fg = '#87af87' })
vim.api.nvim_set_hl(0, 'CocInlayHint', { fg = '#87875f', bg = '#1c1c1c' })

-- 签名帮助窗口透明化
vim.cmd([[ autocmd User CocOpenFloat call nvim_win_set_config(g:coc_last_float_win, { 'style': 'minimal', 'border': 'rounded' })]])
-- 调整补全窗口最大高度
vim.g.coc_pumdisplay = { 
  source = 'atcursor', 
  maxwidth = 80, 
  maxheight = 15 
}