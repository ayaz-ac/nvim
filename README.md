# Neovim Configuration

> A modern, modular Neovim setup built for professional Ruby on Rails development

![Neovim](https://img.shields.io/badge/Neovim-0.9+-green.svg)
![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)

*Screenshot placeholder: Main editing view*

## Features

- **Modular Plugin Architecture** - Clean organization with lazy.nvim for fast startup times
- **Full LSP Integration** - Ruby LSP with Mason for intelligent code navigation and completion
- **Git-Aware Session Management** - Auto-saves sessions only in git repositories, preventing pollution
- **Production-Ready Rubocop** - Auto-formatting via `bundle exec rubocop`, respecting project configurations
- **Integrated LaTeX Workflow** - VimTeX with Skim previewer for seamless document editing
- **Disciplined Keybindings** - Arrow keys disabled to build proper Vim muscle memory
- **Smart Code Intelligence** - Treesitter-powered syntax highlighting for Ruby, ERB, and JavaScript
- **macOS Optimized** - Native keyboard shortcuts and application integrations

## Plugin Ecosystem

### Core Development

#### LSP & Completion
| Plugin | Purpose |
|--------|---------|
| [mason.nvim](https://github.com/williamboman/mason.nvim) | Automated LSP server installation and management |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | Seamless integration between Mason and nvim-lspconfig |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | Ruby LSP integration with intelligent go-to-definition and hover docs |
| [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) | Rubocop diagnostics and formatting via bundle exec |

#### Code Intelligence
| Plugin | Purpose |
|--------|---------|
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax-aware highlighting and navigation for Ruby, ERB, and JavaScript |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder with live grep args for advanced code searching |
| [telescope-live-grep-args.nvim](https://github.com/nvim-telescope/telescope-live-grep-args.nvim) | Enhanced grep functionality with argument support |
| [which-key.nvim](https://github.com/folke/which-key.nvim) | Discoverable keybindings with popup hints |

### Editor Enhancement

#### Navigation & Interface
| Plugin | Purpose |
|--------|---------|
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | Right-aligned file explorer with git status indicators |
| [neoscroll.nvim](https://github.com/karb94/neoscroll.nvim) | Smooth scrolling animations for better visual tracking |
| [mini.indentscope](https://github.com/echasnovski/mini.nvim) | Visual indent guides to show code scope |
| [mini.cursorword](https://github.com/echasnovski/mini.nvim) | Highlights all occurrences of word under cursor |

#### Editing
| Plugin | Purpose |
|--------|---------|
| [mini.pairs](https://github.com/echasnovski/mini.nvim) | Auto-close brackets, quotes, and parentheses |
| [mini.comment](https://github.com/echasnovski/mini.nvim) | Smart commenting with motion support |
| [vim-endwise](https://github.com/tpope/vim-endwise) | Auto-close Ruby blocks with `end` keyword |

### Ruby/Rails Workflow

| Plugin | Purpose |
|--------|---------|
| [vim-rails](https://github.com/tpope/vim-rails) | Rails-aware navigation between models, views, and controllers |
| [vim-endwise](https://github.com/tpope/vim-endwise) | Intelligent `end` completion for Ruby blocks |

### Git Integration

| Plugin | Purpose |
|--------|---------|
| [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim) | Full-featured git UI within Neovim |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | Inline git blame and change indicators in sign column |
| [neovim-session-manager](https://github.com/Shatur/neovim-session-manager) | Git-aware session persistence with auto-save |

### Document Editing

| Plugin | Purpose |
|--------|---------|
| [vimtex](https://github.com/lervag/vimtex) | LaTeX compilation with Skim PDF previewer integration |

### UI & Theme

| Plugin | Purpose |
|--------|---------|
| [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) | Modern, low-eye-strain color scheme |
| [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) | Informative statusline with git branch and file info |

## Prerequisites

- **Neovim** >= 0.9.0
- **Git** (for lazy.nvim plugin management)
- **Node.js** (for LSP servers via Mason)
- **Ruby** with bundler (for Rubocop integration)
- **ripgrep** (for Telescope live grep)
- **fd** (optional, improves Telescope file finding)
- **lazygit** (for git UI integration)
- **LaTeX distribution** (for VimTeX, e.g., MacTeX)
- **Skim** PDF viewer (for LaTeX preview on macOS)

### macOS Installation

```bash
# Core dependencies
brew install neovim ripgrep fd lazygit

# PDF viewer for LaTeX
brew install --cask skim

# LaTeX distribution (large download)
# Visit https://www.tug.org/mactex/ or use:
brew install --cask mactex
```

## Installation

1. **Backup existing configuration** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Clone this repository**:
   ```bash
   git clone https://github.com/yourusername/nvim-config.git ~/.config/nvim
   ```

3. **Launch Neovim**:
   ```bash
   nvim
   ```
   Lazy.nvim will automatically install all plugins on first launch. This may take a few minutes.

4. **Install LSP servers** (after plugins are installed):
   ```
   :MasonInstall ruby-lsp
   ```

5. **Verify installation**:
   - Open a Ruby file
   - Test LSP with `K` (hover documentation)
   - Test Telescope with `<Space>ff` (find files)
   - Test Neo-tree with `<Space>e` (file explorer)

## Keybindings Reference

**Note:** Leader key is `<Space>`. Use `<Space>` followed by any key to see available keybindings via which-key.

### General Navigation

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `Ctrl+h` | Normal | Move left | Navigate to left split |
| `Ctrl+j` | Normal | Move down | Navigate to split below |
| `Ctrl+k` | Normal | Move up | Navigate to split above |
| `Ctrl+l` | Normal | Move right | Navigate to right split |
| `Ctrl+s` | Normal | Vertical split | Create new vertical split |
| `Esc` | Normal/Insert | Clear search | Clear search highlighting |

### Buffer Management

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `bd` | Normal | Close buffer | Close current buffer |
| `bdo` | Normal | Close others | Close all buffers except current |
| `Cmd+s` | Normal/Insert | Save | Save current buffer (macOS) |

### Telescope (Fuzzy Finding)

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>ff` | Normal | Find files | Fuzzy file finder |
| `<leader>fg` | Normal | Live grep | Search in files with arguments |
| `<leader>fb` | Normal | Buffers | List open buffers |
| `<leader>fh` | Normal | Help tags | Search help documentation |
| `<leader><leader>` | Normal | Quick buffers | Quick buffer switcher |

### LSP

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `K` | Normal | Hover | Show documentation for symbol under cursor |
| `<leader>gd` | Normal | Go to definition | Jump to symbol definition |
| `<leader>gr` | Normal | References | Show all references (via Telescope) |
| `<leader>ca` | Normal | Code actions | Show available code actions |
| `<leader>rn` | Normal | Rename | Rename symbol across project |

### File Explorer

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>e` | Normal | Toggle Neo-tree | Toggle file explorer (right-aligned) |

### Git

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `<leader>gg` | Normal | LazyGit | Open LazyGit UI in floating window |

### Editing

| Keybinding | Mode | Action | Description |
|------------|------|--------|-------------|
| `Tab` | Visual | Indent | Indent selected lines and reselect |
| `Shift+Tab` | Visual | Unindent | Unindent selected lines and reselect |
| `Tab` | Insert | Indent | Indent current line |
| `Shift+Tab` | Insert | Unindent | Unindent current line |

### Disabled for Discipline

| Keybinding | Mode | Status | Reason |
|------------|------|--------|--------|
| `Arrow keys` | Normal | Disabled | Forces hjkl navigation muscle memory |
| `q` | Normal | Disabled | Prevents accidental macro recording |

## Configuration Structure

```
~/.config/nvim/
├── init.lua                    # Entry point, lazy.nvim bootstrap
├── lazy-lock.json              # Plugin version lockfile
├── lua/
│   ├── vim-options.lua         # Editor options and settings
│   ├── vim-keymaps.lua         # Core keybindings
│   ├── plugins.lua             # Plugin manager entry point
│   └── plugins/                # Individual plugin configurations (auto-loaded)
│       ├── lsp-config.lua      # LSP and Mason setup
│       ├── null-ls.lua         # Rubocop integration via bundle exec
│       ├── telescope.lua       # Fuzzy finder configuration
│       ├── neo-tree.lua        # File explorer settings
│       ├── treesitter.lua      # Syntax highlighting
│       ├── gitsigns.lua        # Git decorations
│       ├── lazygit.lua         # Git UI integration
│       ├── session-manager.lua # Session persistence
│       ├── ruby.lua            # Ruby/Rails specific plugins
│       ├── vimtex.lua          # LaTeX support
│       ├── lualine.lua         # Statusline
│       ├── tokyonight.lua      # Color scheme
│       ├── mini.lua            # Mini.nvim modules
│       ├── neoscroll.lua       # Smooth scrolling
│       └── which-key.lua       # Keybinding hints
└── .luarc.json                 # Lua LSP configuration
```

Each plugin is configured in its own file for easy customization and maintenance. The modular structure allows you to enable/disable plugins by simply adding/removing files.

## Customization

### Adding a New Plugin

Create a new file in `lua/plugins/`:

```lua
-- lua/plugins/your-plugin.lua
return {
  "username/plugin-name",
  config = function()
    require("plugin-name").setup({
      -- your configuration here
    })
  end
}
```

Lazy.nvim will automatically detect and load the plugin on next restart.

### Modifying Keybindings

Edit `lua/vim-keymaps.lua` for core keybindings, or add plugin-specific bindings in the respective plugin configuration file.

```lua
-- Example: Adding a keybinding
vim.keymap.set('n', '<leader>x', ':YourCommand<CR>', { desc = 'Description' })
```

### Changing Color Scheme

1. Add your preferred theme plugin in `lua/plugins/`
2. Update `lua/plugins/lualine.lua` to use the new theme
3. Remove or comment out `lua/plugins/tokyonight.lua`

## Screenshots

### Main Editing View
*Screenshot placeholder: Ruby file with LSP hover documentation, gitsigns indicators, and lualine statusline showing git branch and file info*

### Telescope Fuzzy Finder
*Screenshot placeholder: Telescope dropdown showing file search results with live grep preview*

### Neo-tree File Explorer
*Screenshot placeholder: Right-aligned file explorer with git status indicators (added/modified/deleted files)*

### LazyGit Integration
*Screenshot placeholder: LazyGit UI in floating window showing commit history and diff*

### LSP in Action
*Screenshot placeholder: Code actions popup, go-to-definition, or inline diagnostics from Rubocop*

## Workflow Highlights

### Ruby/Rails Development
- **Bundle-aware Rubocop**: Uses `bundle exec rubocop` to respect project-specific gem versions and configurations
- **Conditional Formatting**: Only runs Rubocop in projects with `.rubocop.yml`, preventing errors in non-Ruby projects
- **Auto-format on Save**: Maintains consistent code style automatically across the team
- **Rails-aware Navigation**: Quick jumping between models, views, and controllers with vim-rails

### Git-Centric Sessions
- **Smart Session Persistence**: Sessions auto-save only in git repositories
- **Clean Temporary Work**: Prevents session pollution in temporary directories and scratch work
- **Restore Exact Layouts**: Automatically restores window splits and buffer positions per project

### Disciplined Editing
- **No Arrow Keys**: Disabled in normal mode to build muscle memory for hjkl navigation
- **No Macro Recording**: `q` key disabled for cleaner workflow (personal preference)
- **Intuitive Indentation**: Tab/Shift+Tab work in both visual and insert modes for consistent indentation control

## Troubleshooting

### LSP not working in Ruby files
- Ensure `ruby-lsp` is installed: Open Neovim and run `:Mason`, then install `ruby-lsp`
- Verify you're in a directory with `Gemfile` or `.git` (Ruby LSP requires project detection)
- Check LSP status: `:LspInfo`

### Rubocop formatting not working
- Verify `.rubocop.yml` exists in your project root
- Ensure rubocop is in your Gemfile: `bundle exec rubocop --version`
- Check null-ls status: `:NullLsInfo`

### LazyGit not opening
- Install lazygit: `brew install lazygit`
- Verify it's in your PATH: `which lazygit`

### Skim preview not working for LaTeX
- Install Skim: `brew install --cask skim`
- Set Skim as default PDF viewer for LaTeX files
- Verify VimTeX can find Skim: `:VimtexInfo`

### Plugins not loading on first startup
- Wait for lazy.nvim to finish installation (check bottom of screen)
- Restart Neovim after installation completes
- Check for errors: `:Lazy`

## License

MIT License - Feel free to use and modify this configuration for your own needs.

---

**Note**: This configuration is optimized for macOS and Ruby/Rails development. Adapt keybindings and tool paths as needed for your environment.
