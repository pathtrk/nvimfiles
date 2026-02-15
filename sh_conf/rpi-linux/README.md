# Raspberry Pi 5 Development Environment Setup Guide

Complete guide for setting up a powerful development environment on Raspberry Pi 5 with neovim and optimized bash configuration.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Installing the .bashrc](#installing-the-bashrc)
3. [Setting Up Welcome Message](#setting-up-welcome-message)
4. [Neovim Configuration](#neovim-configuration)
5. [Installing Recommended Packages](#installing-recommended-packages)
6. [Testing Your Setup](#testing-your-setup)
7. [Optional Enhancements](#optional-enhancements)
8. [Troubleshooting](#troubleshooting)
9. [Quick Reference](#quick-reference)

---

## Quick Start

```bash
# 1. Backup existing .bashrc
cp ~/.bashrc ~/.bashrc.backup

# 2. Install new .bashrc
cp .bashrc_recommended ~/.bashrc

# 3. Create welcome message
nvim ~/.bash_welcome
# (paste the welcome message content from below)

# 4. Reload bash
source ~/.bashrc

# 5. Install recommended packages
sudo apt update
sudo apt install -y fzf ripgrep fd-find bat tree htop ncdu tldr
```

---

## Installing the .bashrc

### Step 1: Backup Your Current Configuration

```bash
# Always backup first!
cp ~/.bashrc ~/.bashrc.backup
```

### Step 2: Install the New Configuration

```bash
# Copy the recommended .bashrc
cp .bashrc_recommended ~/.bashrc

# Or manually edit
nvim ~/.bashrc
```

### Step 3: Reload Your Shell

```bash
source ~/.bashrc

# Or open a new terminal window
```

### Step 4: Verify Installation

```bash
# Check that neovim is the default editor
echo $EDITOR
# Should output: nvim

# Test an alias
ll

# Check help
help-dev
```

---

## Setting Up Welcome Message

Create `~/.bash_welcome` with the following content:

```bash
nvim ~/.bash_welcome
```

**Content:**

```bash
s
```

**Make it executable:**

```bash
chmod +x ~/.bash_welcome
```

---

## Neovim Configuration

### Step 1: Create Config Directory

```bash
mkdir -p ~/.config/nvim
```

### Step 2: Basic Configuration (init.lua)

Create `~/.config/nvim/init.lua`:

```bash
nvim ~/.config/nvim/init.lua
```

**Minimal Configuration:**

```lua
-- ============================================
-- BASIC SETTINGS
-- ============================================
vim.opt.number = true                    -- Show line numbers
vim.opt.relativenumber = true            -- Relative line numbers
vim.opt.mouse = 'a'                      -- Enable mouse
vim.opt.ignorecase = true                -- Case insensitive search
vim.opt.smartcase = true                 -- Unless uppercase in search
vim.opt.expandtab = true                 -- Use spaces instead of tabs
vim.opt.shiftwidth = 4                   -- Indent by 4 spaces
vim.opt.tabstop = 4                      -- Tab = 4 spaces
vim.opt.softtabstop = 4                  -- Backspace deletes 4 spaces
vim.opt.autoindent = true                -- Auto indent new lines
vim.opt.smartindent = true               -- Smart indenting
vim.opt.clipboard = 'unnamedplus'        -- System clipboard
vim.opt.termguicolors = true             -- True color support
vim.opt.cursorline = true                -- Highlight current line
vim.opt.wrap = false                     -- No line wrapping
vim.opt.scrolloff = 8                    -- Keep 8 lines visible when scrolling
vim.opt.sidescrolloff = 8                -- Keep 8 columns visible
vim.opt.signcolumn = 'yes'               -- Always show sign column
vim.opt.updatetime = 250                 -- Faster completion
vim.opt.timeoutlen = 300                 -- Faster key sequence completion
vim.opt.backup = false                   -- No backup files
vim.opt.writebackup = false              -- No backup when writing
vim.opt.swapfile = false                 -- No swap files
vim.opt.undofile = true                  -- Persistent undo
vim.opt.undodir = vim.fn.expand('~/.config/nvim/undo')  -- Undo directory

-- Create undo directory if it doesn't exist
vim.fn.mkdir(vim.fn.expand('~/.config/nvim/undo'), 'p')

-- ============================================
-- LEADER KEY
-- ============================================
vim.g.mapleader = ' '                    -- Space as leader key
vim.g.maplocalleader = ' '

-- ============================================
-- KEY MAPPINGS
-- ============================================
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Easy escape from insert mode
keymap('i', 'jk', '<ESC>', opts)
keymap('i', 'kj', '<ESC>', opts)

-- Save file
keymap('n', '<leader>w', ':w<CR>', opts)
keymap('n', '<leader>W', ':wa<CR>', opts)      -- Save all

-- Quit
keymap('n', '<leader>q', ':q<CR>', opts)
keymap('n', '<leader>Q', ':qa<CR>', opts)      -- Quit all

-- Save and quit
keymap('n', '<leader>x', ':x<CR>', opts)

-- Split navigation
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- Resize splits
keymap('n', '<C-Up>', ':resize +2<CR>', opts)
keymap('n', '<C-Down>', ':resize -2<CR>', opts)
keymap('n', '<C-Left>', ':vertical resize -2<CR>', opts)
keymap('n', '<C-Right>', ':vertical resize +2<CR>', opts)

-- Buffer navigation
keymap('n', '<Tab>', ':bnext<CR>', opts)
keymap('n', '<S-Tab>', ':bprevious<CR>', opts)
keymap('n', '<leader>bd', ':bdelete<CR>', opts)    -- Close buffer

-- Clear search highlight
keymap('n', '<leader>h', ':nohl<CR>', opts)

-- Better indenting (stay in visual mode)
keymap('v', '<', '<gv', opts)
keymap('v', '>', '>gv', opts)

-- Move text up and down
keymap('v', 'J', ":m '>+1<CR>gv=gv", opts)
keymap('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered when scrolling
keymap('n', '<C-d>', '<C-d>zz', opts)
keymap('n', '<C-u>', '<C-u>zz', opts)
keymap('n', 'n', 'nzzzv', opts)
keymap('n', 'N', 'Nzzzv', opts)

-- Better paste (don't replace clipboard)
keymap('v', 'p', '"_dP', opts)

-- Quick list navigation
keymap('n', '<leader>j', ':cnext<CR>', opts)
keymap('n', '<leader>k', ':cprev<CR>', opts)

-- File explorer (netrw)
keymap('n', '<leader>e', ':Explore<CR>', opts)

-- ============================================
-- NETRW (FILE EXPLORER) SETTINGS
-- ============================================
vim.g.netrw_banner = 0                   -- Hide banner
vim.g.netrw_liststyle = 3                -- Tree view
vim.g.netrw_browse_split = 4             -- Open in previous window
vim.g.netrw_altv = 1                     -- Split to the right
vim.g.netrw_winsize = 25                 -- 25% width

-- ============================================
-- AUTO COMMANDS
-- ============================================
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight on yank
augroup('YankHighlight', { clear = true })
autocmd('TextYankPost', {
  group = 'YankHighlight',
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
augroup('TrimWhitespace', { clear = true })
autocmd('BufWritePre', {
  group = 'TrimWhitespace',
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

-- Auto-create parent directories when saving
autocmd('BufWritePre', {
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

-- Return to last edit position when opening files
autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ============================================
-- CUSTOM COMMANDS
-- ============================================
-- Trim trailing whitespace
vim.api.nvim_create_user_command('TrimWhitespace', [[%s/\s\+$//e]], {})

-- Toggle line numbers
vim.api.nvim_create_user_command('ToggleNumbers', function()
  vim.opt.number = not vim.opt.number:get()
  vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, {})

-- ============================================
-- COLORSCHEME
-- ============================================
-- Set colorscheme (using built-in schemes)
vim.cmd.colorscheme('habamax')  -- or 'slate', 'desert', 'pablo'

-- ============================================
-- STATUS LINE
-- ============================================
vim.opt.laststatus = 2
vim.opt.showmode = false

-- Simple custom statusline
vim.opt.statusline = table.concat({
  ' %f',              -- File path
  ' %m',              -- Modified flag
  ' %r',              -- Readonly flag
  '%=',               -- Right align
  ' %y',              -- File type
  ' %p%%',            -- Percentage through file
  ' %l:%c ',          -- Line:Column
})

print("Neovim config loaded successfully!")
```

### Step 3: Create Undo Directory

```bash
mkdir -p ~/.config/nvim/undo
```

### Step 4: Test Neovim Config

```bash
# Open neovim
nvim

# Should see: "Neovim config loaded successfully!"
# Try some key bindings:
# Space + w  -> Save
# Space + e  -> File explorer
# jk         -> Exit insert mode
```

---

## Installing Recommended Packages

### Essential Development Tools

```bash
sudo apt update
sudo apt install -y \
  build-essential \
  git \
  curl \
  wget \
  vim \
  tmux \
  htop \
  tree \
  ncdu \
  zip \
  unzip \
  python3 \
  python3-pip \
  python3-venv
```

### Enhanced CLI Tools

```bash
# FZF - Fuzzy finder (Ctrl+R for history search)
sudo apt install -y fzf

# Ripgrep - Better grep
sudo apt install -y ripgrep

# fd - Better find
sudo apt install -y fd-find

# bat - Better cat with syntax highlighting
sudo apt install -y bat

# tldr - Simplified man pages
sudo apt install -y tldr

# Update tldr cache
tldr --update
```

### Node.js (via NVM - Recommended)

```bash
# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Reload shell
source ~/.bashrc

# Install Node.js LTS
nvm install --lts
nvm alias default lts/*

# Verify
node --version
npm --version
```

### Docker (Optional)

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Reload group membership (or log out and back in)
newgrp docker

# Test Docker
docker run hello-world
```

### Tailscale (for remote access)

```bash
# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Start Tailscale with SSH enabled
sudo tailscale up --ssh

# Set a friendly hostname
sudo tailscale up --hostname=dev-server

# Get your Tailscale IP
tailscale ip -4
```

---

## Testing Your Setup

### Test Bash Configuration

```bash
# 1. Test aliases
ll              # Should list files with details
temp            # Should show CPU temperature
mem             # Should show memory usage
pistat          # Should show Pi statistics

# 2. Test functions
help-dev        # Should show command reference
h git           # Should search history for "git"

# 3. Test neovim aliases
v test.txt      # Opens neovim
vim test.txt    # Opens neovim
vi test.txt     # Opens neovim

# 4. Test git integration
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
echo $GIT_EDITOR  # Should be: nvim
```

### Test Neovim

```bash
# 1. Open neovim
nvim

# 2. Try key bindings
# In normal mode:
# Space + e  -> Open file explorer
# Space + h  -> Clear search highlight
# jk         -> Exit insert mode (when in insert mode)

# 3. Test man page reading
man ls         # Should open in neovim with syntax highlighting

# 4. Test git commit
git init /tmp/test-repo
cd /tmp/test-repo
git commit --allow-empty -m "test"
# Should open neovim for commit message
```

### Test FZF Integration

```bash
# Press these key combinations:
# Ctrl + R   -> Fuzzy search command history
# Ctrl + T   -> Fuzzy file finder
# Alt + C    -> Fuzzy directory finder

# Try the vf function
vf             # Should open fuzzy finder, then edit selected file
```

---

## Optional Enhancements

### 1. Install Neovim Plugin Manager (lazy.nvim)

```bash
git clone --filter=blob:none \
  https://github.com/folke/lazy.nvim.git \
  --branch=stable \
  ~/.local/share/nvim/lazy/lazy.nvim
```

Then add to your `~/.config/nvim/init.lua` (at the top):

```lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Add plugins here
  -- Example: { "folke/tokyonight.nvim" }
})
```

### 2. Create Note-Taking Directory

```bash
mkdir -p ~/notes

# Try the note function
note           # Opens today's note in neovim
```

### 3. Setup Git Aliases

Add these to `~/.gitconfig`:

```bash
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.visual 'log --oneline --graph --decorate'
```

### 4. Install Additional Aliases (Optional)

Add to `~/.bashrc.local` (for local customizations):

```bash
# Create local config file
nvim ~/.bashrc.local
```

```bash
# Project-specific aliases
alias myproject='cd ~/projects/myproject'
alias startserver='cd ~/projects && npm start'

# Custom shortcuts
alias update='sudo apt update && sudo apt upgrade -y'
alias clean='sudo apt autoremove -y && sudo apt autoclean'

# Add more as needed...
```

### 5. Setup Tmux (Terminal Multiplexer)

```bash
# Install tmux
sudo apt install -y tmux

# Create basic tmux config
cat > ~/.tmux.conf << 'EOF'
# Remap prefix to Ctrl-a
unbind C-b
set-prefix C-a

# Enable mouse
set -g mouse on

# Start windows at 1
set -g base-index 1

# Split panes with | and -
bind | split-window -h
bind - split-window -v

# Reload config
bind r source-file ~/.tmux.conf
EOF

# Test tmux
tmux
```

---

## Troubleshooting

### Neovim Not Found

```bash
# Check if neovim is installed
which nvim

# If not, install it
sudo apt install neovim

# Or compile from source (latest version)
# See: https://github.com/neovim/neovim/wiki/Building-Neovim
```

### FZF Commands Not Working

```bash
# Reinstall fzf with keybindings
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Reload bash
source ~/.bashrc

# Test
# Ctrl + R should work now
```

### Git Editor Not Neovim

```bash
# Set git editor manually
git config --global core.editor "nvim"

# Verify
git config --global core.editor
```

### Aliases Not Working

```bash
# Check if .bashrc is sourced
echo $EDITOR
# Should output: nvim

# If not, reload
source ~/.bashrc

# Check if running interactive shell
echo $-
# Should contain 'i'
```

### Welcome Message Not Showing

```bash
# Check if file exists
ls -la ~/.bash_welcome

# Make it executable
chmod +x ~/.bash_welcome

# Test manually
~/.bash_welcome
```

### Permission Denied Errors

```bash
# For Docker
sudo usermod -aG docker $USER
newgrp docker

# For general file permissions
chmod +x <file>
```

---

## Quick Reference

### Most Used Commands

```bash
# Navigation
ll              # List files with details
..              # Go up one directory
mkcd <dir>      # Create and enter directory

# Neovim
v <file>        # Edit file
nvimrc          # Edit neovim config
vf              # Fuzzy find and edit
note            # Daily notes

# Git
gs              # git status
ga .            # git add all
gc -m "msg"     # git commit
gp              # git push
gl              # git log (pretty)

# System
temp            # CPU temperature
mem             # Memory usage
disk            # Disk usage
pistat          # All Pi stats

# Python
ve venv         # Create virtual env
va              # Activate venv
vd              # Deactivate venv

# Utilities
extract <file>  # Extract any archive
backup <file>   # Backup with timestamp
h <pattern>     # Search history
help-dev        # Show all commands
```

### Neovim Key Bindings

```
Normal Mode:
  Space + w     - Save file
  Space + q     - Quit
  Space + e     - File explorer
  Space + h     - Clear search highlight
  Tab           - Next buffer
  Shift + Tab   - Previous buffer
  jk or kj      - Exit insert mode

Split Navigation:
  Ctrl + h/j/k/l - Navigate between splits

Visual Mode:
  <  / >        - Indent/unindent (stays in visual)
  J / K         - Move selected lines up/down
```

### FZF Key Bindings

```bash
Ctrl + R        # Search command history
Ctrl + T        # Find files
Alt + C         # Find directories
vf              # Fuzzy find and edit file
```

---

## Additional Resources

- **Neovim Documentation**: https://neovim.io/doc/
- **FZF GitHub**: https://github.com/junegunn/fzf
- **Bash Guide**: https://mywiki.wooledge.org/BashGuide
- **Tmux Cheat Sheet**: https://tmuxcheatsheet.com/
- **Git Documentation**: https://git-scm.com/doc

---

## Backup and Restore

### Backup Your Configuration

```bash
# Create backup directory
mkdir -p ~/dotfile-backups/$(date +%Y%m%d)

# Backup important configs
cp ~/.bashrc ~/dotfile-backups/$(date +%Y%m%d)/
cp ~/.bash_welcome ~/dotfile-backups/$(date +%Y%m%d)/
cp -r ~/.config/nvim ~/dotfile-backups/$(date +%Y%m%d)/

# Create archive
cd ~/dotfile-backups
tar -czf dotfiles-$(date +%Y%m%d).tar.gz $(date +%Y%m%d)
```

### Restore Configuration

```bash
# Extract backup
cd ~/dotfile-backups
tar -xzf dotfiles-YYYYMMDD.tar.gz

# Restore files
cp YYYYMMDD/.bashrc ~/
cp YYYYMMDD/.bash_welcome ~/
cp -r YYYYMMDD/nvim ~/.config/

# Reload
source ~/.bashrc
```

---

## Done!

Your Raspberry Pi 5 development environment is now fully configured with:
- ✅ Optimized bash configuration with helpful aliases
- ✅ Neovim as default editor with productive keybindings
- ✅ FZF for fuzzy finding
- ✅ Beautiful command-line tools (bat, fd, ripgrep)
- ✅ Git integration
- ✅ System monitoring aliases
- ✅ Development shortcuts for Python, Docker, and more

Type `help-dev` anytime to see available commands!

---

**Last Updated**: January 2026  
**Tested On**: Raspberry Pi 5 (8GB), Raspberry Pi OS Bookworm (64-bit)
