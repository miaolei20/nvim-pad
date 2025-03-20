-- 极简图标系统（全平台兼容）
local icons = {
  modified = "●",   -- 修改标识（实心圆）
  save     = "",   -- 保存（简约软盘）
  quit     = "󰈆",   -- 退出（门图标）
  alert    = "!",    -- 警告
  success  = "✓",    -- 成功
  error    = "✗",    -- 失败
  file     = ""     -- 文件标识
}

-- 核心性能配置 --------------------------------------------
vim.opt.updatetime = 2000      -- 优化事件触发间隔
vim.opt.title = true           -- 在终端标题显示文件信息
vim.opt.swapfile = false       -- 完全禁用交换文件
vim.opt.shadafile = "NONE"     -- 关闭共享数据文件
vim.opt.hidden = true          -- 允许后台缓冲区

-- 智能退出系统 3.0 ----------------------------------------
local function has_unsaved_changes()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_option(buf, 'modified') then
      return true
    end
  end
  return false
end

local function minimalist_quit()
  if has_unsaved_changes() then
    vim.ui.select(
      { 'save_all', 'discard_all', 'cancel' },
      {
        prompt = icons.alert .. ' Unsaved Changes:',
        format_item = function(item)
          return ({
            save_all    = icons.save .. ' Save & Exit',
            discard_all = icons.error .. ' Discard All',
            cancel      = icons.quit .. ' Cancel'
          })[item]
        end
      },
      function(choice)
        if choice == 'save_all' then
          vim.schedule(function()
            vim.cmd('silent! wall')
            vim.notify(icons.success .. ' Saved all files', vim.log.levels.INFO)
            vim.cmd('qa!')
          end)
        elseif choice == 'discard_all' then
          vim.cmd('qa!')
        end
      end)
  else
    vim.cmd('qa!')
  end
end

vim.api.nvim_create_user_command('Q', minimalist_quit, {})

-- 高效自动保存系统 ----------------------------------------
local autosave_group = vim.api.nvim_create_augroup('AutoSaveX', {})

vim.api.nvim_create_autocmd({'TextChanged', 'InsertLeave'}, {
  group = autosave_group,
  pattern = '*',
  callback = function(args)
    if vim.bo[args.buf].buftype == '' and vim.bo[args.buf].modified then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.api.nvim_buf_call(args.buf, function()
            vim.cmd('silent! write')
            vim.notify(icons.save .. ' Auto-saved: ' .. vim.fn.expand('%:t'), vim.log.levels.INFO)
          end)
        end
      end)
    end
  end,
  desc = 'Smart autosave'
})

-- 极简状态栏 ----------------------------------------------
vim.opt.statusline = table.concat({
  '%<%f',                     -- 文件名
  ' %(%h%m%r%)',              -- 状态标识 (help/modified/readonly)
  '%=',                       -- 右对齐
  '%{&fileencoding}',         -- 文件编码
  ' | %{&fileformat}',        -- 文件格式
  ' | %4l:%-2c'               -- 行号:列号
})

-- 大文件优化策略 -------------------------------------------
vim.api.nvim_create_autocmd('BufReadPre', {
  group = vim.api.nvim_create_augroup('LargeFileOpt', {}),
  callback = function(args)
    local size = vim.fn.getfsize(args.file)
    if size > 1024 * 1024 * 5 then -- 5MB 阈值
      vim.bo[args.buf].swapfile = false
      vim.bo[args.buf].syntax = 'off'
      vim.wo[args.buf].number = false
      vim.wo[args.buf].relativenumber = false
    end
  end
})

-- 快捷键系统 ----------------------------------------------
vim.keymap.set('n', '<leader>qq', '<cmd>Q<cr>', { desc = 'Smart quit' })
vim.keymap.set('n', '<leader>ww', '<cmd>silent! wall<cr>', { desc = 'Save all' })

-- 缓冲区保护系统 ------------------------------------------
vim.api.nvim_create_autocmd('BufLeave', {
  group = vim.api.nvim_create_augroup('BufferGuard', {}),
  callback = function(args)
    if vim.bo[args.buf].modified and vim.bo[args.buf].buftype == '' then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          vim.api.nvim_buf_call(args.buf, function()
            vim.cmd('silent! write')
          end)
        end
      end)
    end
  end
})