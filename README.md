```markdown
# NeoVim 配置说明

![NeoVim Screenshot](./screenshot.png) <!-- 可替换为你的实际截图 -->

## 🚀 功能特性

- **现代化界面**：基于 OneDark 主题 + Lualine 状态栏
- **高效导航**：Telescope 模糊搜索 + NvimTree 文件树
- **智能开发**：LSP 支持 (coc.nvim) + Treesitter 语法高亮
- **便捷操作**：自动补全括号、快捷键映射、一键编译运行
- **模块化配置**：使用 Lazy.nvim 插件管理器

## 📦 安装要求

### 系统依赖
```bash
# Ubuntu/Debian
sudo apt install git make python3-pip nodejs npm ripgrep fd-find
# termux
pkg install git make clang python nodejs ripgrep fd
# macOS (Homebrew)
brew install git node ripgrep fd
```

### NeoVim 专用依赖
```bash
pip3 install pynvim        # Python 支持
npm install -g neovim      # Node.js 支持
```

### 字体安装（必须）
```bash
# 任选一款 Nerd Fonts 字体安装
# 推荐使用 FiraCode
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
```

## ⚙️ 安装步骤

1. **克隆配置仓库**
```bash
git clone https://github.com/yourusername/nvim-config ~/.config/nvim
```

2. **首次启动自动安装**
```bash
nvim +Lazy sync  # 自动安装插件
```

3. **安装 LSP 语言服务器**
```vim
:CocInstall coc-clangd coc-pyright coc-json coc-tsserver
```

## 🔌 核心插件列表

| 插件                          | 功能描述                     |
|-------------------------------|----------------------------|
| `navarasu/onedark.nvim`       | OneDark 主题               |
| `nvim-tree/nvim-tree.lua`     | 文件树资源管理器           |
| `nvim-telescope/telescope.nvim` | 模糊文件搜索             |
| `neoclide/coc.nvim`           | LSP 支持 + 智能补全       |
| `nvim-treesitter/nvim-treesitter` | 语法高亮增强         |
| `windwp/nvim-autopairs`       | 自动括号补全               |
| `akinsho/bufferline.nvim`     | 标签页式缓冲区管理         |

## ⌨️ 快捷键速查

### 通用操作
| 快捷键          | 功能描述                |
|-----------------|-----------------------|
| `<Leader>v`     | 垂直分屏              |
| `<Leader>s`     | 水平分屏              |
| `<C-h/j/k/l>`   | 窗口导航              |
| `<C-r>`         | 编译运行当前 C/C++ 文件 |

### 文件操作
| 快捷键          | 功能描述                |
|-----------------|-----------------------|
| `<C-b>`         | 切换文件树            |
| `<leader>e`     | 聚焦文件树            |
| `<leader>r`     | 定位当前文件          |

### 搜索操作
| 快捷键          | 功能描述                |
|-----------------|-----------------------|
| `<leader>ff`    | 文件搜索              |
| `<leader>fg`    | 内容搜索              |
| `<leader>fs`    | 高频文件搜索          |

### LSP 操作
| 快捷键          | 功能描述                |
|-----------------|-----------------------|
| `gd`            | 跳转到定义            |
| `gr`            | 查看引用              |
| `<leader>rn`    | 重命名符号            |

## 🛠️ 自定义配置

配置文件结构：
```
~/.config/nvim/
├── init.lua          # 主入口文件
├── lua/
│   ├── config/       # 基础配置
│   │   ├── options.lua
│   │   ├── keymaps.lua
│   │   └── indent.lua
│   └── plugins/      # 插件配置
│       ├── coc.lua
│       ├── nvimtree.lua
│       └── ...
```

## ❓ 常见问题

### Q1: 插件安装失败
```bash
# 删除插件缓存后重试
rm -rf ~/.local/share/nvim
nvim +Lazy sync
```

### Q2: 图标显示异常
- 确认已安装 [Nerd Fonts](https://www.nerdfonts.com/)
- 终端设置为 Nerd Font 字体

### Q3: LSP 未启动
1. 检查语言服务器是否安装成功
2. ���项目根目录添加配置文件（如 `.clangd` 等）
3. 执行 `:checkhealth` 查看诊断信息

## 🎯 推荐工作流

1. 使用 `<C-b>` 打开文件树浏览项目
2. 通过 `<leader>ff` 快速定位文件
3. 使用 `gd/gr` 进行代码导航
4. 通过 `<C-r>` 一键编译运行代码
5. 使用 `:CocCommand` 访问 LSP 功能

---
