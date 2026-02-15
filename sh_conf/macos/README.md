# macOS ZSH Development Environment Setup Guide

Complete guide for setting up a powerful development environment on macOS with zsh and neovim.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Prerequisites - Homebrew](#prerequisites---homebrew)
3. [Installing the .zshrc](#installing-the-zshrc)
4. [Essential Tools Installation](#essential-tools-installation)
5. [Neovim Setup](#neovim-setup)
6. [ZSH Enhancements](#zsh-enhancements)
7. [Advanced ZSH Completion](#advanced-zsh-completion)
8. [Welcome Message](#welcome-message)
9. [Optional: Oh My Zsh](#optional-oh-my-zsh)
10. [Testing Your Setup](#testing-your-setup)
11. [macOS-Specific Tips](#macos-specific-tips)
12. [Troubleshooting](#troubleshooting)
13. [Quick Reference](#quick-reference)

---

## Quick Start

```bash
# 1. Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Backup existing .zshrc
cp ~/.zshrc ~/.zshrc.backup

# 3. Install new .zshrc
cp .zshrc_recommended ~/.zshrc

# 4. Install essential tools
brew install neovim fzf ripgrep fd bat exa git

# 5. Setup fzf key bindings
$(brew --prefix)/opt/fzf/install

# 6. Reload shell
source ~/.zshrc
```

---

## Prerequisites - Homebrew

### Install Homebrew (Package Manager for macOS)

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Follow the instructions to add Homebrew to your PATH
# For Apple Silicon (M1/M2/M3):
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# For Intel Macs:
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/usr/local/bin/brew shellenv)"

# Verify installation
brew --version
```

---

## Installing the .zshrc

### Step 1: Backup Your Current Configuration

```bash
# Always backup first!
cp ~/.zshrc ~/.zshrc.backup

# Optional: backup other zsh files
cp ~/.zprofile ~/.zprofile.backup 2>/dev/null || true
```

### Step 2: Install the New Configuration

```bash
# Copy the recommended .zshrc
cp .zshrc_recommended ~/.zshrc

# Or manually edit
nvim ~/.zshrc
```

### Step 3: Reload Your Shell

```bash
source ~/.zshrc

# Or open a new terminal window
# Cmd+T for new tab
```

---

## Essential Tools Installation

### Core Development Tools

```bash
# Neovim - Modern vim
brew install neovim

# Git - Version control (usually pre-installed)
brew install git

# FZF - Fuzzy finder
brew install fzf
# Install key bindings
$(brew --prefix)/opt/fzf/install

# Ripgrep - Better grep
brew install ripgrep

# fd - Better find
brew install fd

# bat - Better cat with syntax highlighting
brew install bat

# exa - Better ls
brew install exa

# tree - Directory visualization (if not using exa)
brew install tree
```

### Additional Useful Tools

```bash
# htop - Better top
brew install htop

# ncdu - Disk usage analyzer
brew install ncdu

# tldr - Simplified man pages
brew install tldr

# jq - JSON processor
brew install jq

# wget - File downloader
brew install wget

# GNU coreutils (for gls, etc.)
brew install coreutils
```

### Programming Languages

```bash
# Python 3 (usually pre-installed on modern macOS)
brew install python3

# Node.js via NVM (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
source ~/.zshrc
nvm install --lts

# Or Node.js via Homebrew
brew install node

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Docker

```bash
# Docker Desktop for Mac (GUI + CLI)
brew install --cask docker

# Or use Colima (lightweight alternative)
brew install docker docker-compose colima
colima start
```

---

## Neovim Setup

The neovim configuration from the Raspberry Pi guide works identically on macOS!

### Step 1: Create Config Directory

```bash
mkdir -p ~/.config/nvim
```

### Step 2: Create init.lua

```bash
nvim ~/.config/nvim/init.lua
```

**Use the exact same `init.lua` from the Raspberry Pi setup guide.**

The configuration is 100% portable between Linux and macOS.

### Step 3: Create Undo Directory

```bash
mkdir -p ~/.config/nvim/undo
```

### Step 4: Test Neovim

```bash
nvim
# Should see: "Neovim config loaded successfully!"
```

### Optional: Install Neovim Plugin Manager

```bash
# lazy.nvim (modern, fast)
git clone --filter=blob:none \
  https://github.com/folke/lazy.nvim.git \
  --branch=stable \
  ~/.local/share/nvim/lazy/lazy.nvim
```

---

## ZSH Enhancements

### 1. ZSH Autosuggestions

Fish-like autosuggestions based on your history:

```bash
# Install
brew install zsh-autosuggestions

# Already configured in .zshrc!
# Just reload:
source ~/.zshrc

# Usage: Type a command, see suggestion in gray
# Press → (right arrow) to accept
```

### 2. ZSH Syntax Highlighting

Highlight commands as you type:

```bash
# Install
brew install zsh-syntax-highlighting

# Already configured in .zshrc!
# Just reload:
source ~/.zshrc

# Green = valid command
# Red = invalid command
```

### 3. Better Prompt (Optional)

#### Option A: Starship (Minimal, Fast)

```bash
# Install
brew install starship

# Add to .zshrc (before the prompt section)
echo 'eval "$(starship init zsh)"' >> ~/.zshrc

# Configure
mkdir -p ~/.config
starship preset nerd-font-symbols -o ~/.config/starship.toml
```

#### Option B: Powerlevel10k (Feature-Rich)

```bash
# Install
brew install powerlevel10k

# Add to .zshrc (before the prompt section)
echo 'source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# Reload and configure
source ~/.zshrc
# Follow the configuration wizard
```

---

## Advanced ZSH Completion

### Improving Completion Experience (Standalone Setup)

If you're experiencing issues with zsh completion in neovim terminal or want better completion UX without oh-my-zsh:

#### 1. Fix Neovim Terminal Key Conflicts

Add to your neovim config (`~/.config/nvim/init.lua`):

```lua
-- Pass completion keys to terminal
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    local opts = { buffer = 0, noremap = true }
    -- Pass these keys through to the terminal
    vim.keymap.set('t', '<C-e>', '<C-e>', opts)
    vim.keymap.set('t', '<C-n>', '<C-n>', opts)
    vim.keymap.set('t', '<C-p>', '<C-p>', opts)
  end,
})
```

#### 2. Enhanced Completion Configuration

Add to your `~/.zshrc`:

```bash
# Better completion system
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Better completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Alternative bindings for completion navigation
bindkey '^[[Z' reverse-menu-complete  # Shift-Tab for reverse
bindkey '^N' menu-complete            # Ctrl-N for forward
bindkey '^P' reverse-menu-complete    # Ctrl-P for backward

# Keep the default Ctrl-E behavior for end-of-line
bindkey '^E' end-of-line
```

#### 3. fzf-tab (Standalone - No oh-my-zsh Required)

Fuzzy completion with preview:

```bash
# Install
git clone https://github.com/Aloxaf/fzf-tab ~/.zsh/fzf-tab

# Add to ~/.zshrc
source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh

# Configure
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-space:accept'
zstyle ':fzf-tab:*' accept-line enter

# Reload
source ~/.zshrc
```

#### 4. Better Autosuggestions (Standalone)

Fish-like history-based suggestions:

```bash
# Install (if not using Homebrew version)
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# Add to ~/.zshrc
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Accept with Ctrl-F or Ctrl-Space
bindkey '^F' autosuggest-accept
bindkey '^ ' autosuggest-accept  # Ctrl-Space
```

#### 5. Complete Minimal Setup Example

Here's a complete standalone setup (no oh-my-zsh):

```bash
# ~/.zshrc minimal completion setup

# Basic completion
autoload -Uz compinit
compinit

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Key bindings
bindkey '^N' menu-complete
bindkey '^P' reverse-menu-complete
bindkey '^E' end-of-line

# fzf-tab (optional but recommended)
if [[ -f ~/.zsh/fzf-tab/fzf-tab.plugin.zsh ]]; then
  source ~/.zsh/fzf-tab/fzf-tab.plugin.zsh
fi

# autosuggestions (optional but recommended)
if [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  bindkey '^F' autosuggest-accept
fi

# Starship prompt
eval "$(starship init zsh)"
```

### Recommended Key Bindings Summary

| Key          | Action                          |
| ------------ | ------------------------------- |
| `Tab`        | Standard completion/menu cycle  |
| `Shift-Tab`  | Reverse menu cycle              |
| `Ctrl-N`     | Next completion                 |
| `Ctrl-P`     | Previous completion             |
| `Ctrl-E`     | End of line (standard behavior) |
| `Ctrl-F`     | Accept autosuggestion           |
| `Ctrl-Space` | Accept (fzf-tab/autosuggestion) |

---

## Welcome Message

Create `~/.zsh_welcome` with macOS-specific stats:

```bash
nvim ~/.zsh_welcome
```

**Content:**

```bash
#!/bin/zsh
# Welcome message for macOS development environment

echo ""
echo "================================================"
echo "  macOS Development Environment"
echo "================================================"
echo ""

# System info
echo "  Mac:         $(sysctl -n hw.model)"
echo "  CPU:         $(sysctl -n machdep.cpu.brand_string | sed 's/  */ /g')"
echo "  Memory:      $(echo "scale=1; $(sysctl -n hw.memsize)/1024/1024/1024" | bc)GB"

# Battery (if laptop)
BATTERY=$(pmset -g batt | grep -o "[0-9]*%" | head -1)
if [ ! -z "$BATTERY" ]; then
    echo "  Battery:     $BATTERY"
fi

# Disk usage
DISK_USAGE=$(df -h / | tail -1 | awk '{print $3" / "$2" ("$5")"}')
echo "  Disk:        $DISK_USAGE"

# Uptime
UPTIME=$(uptime | awk '{print $3,$4}' | sed 's/,//')
echo "  Uptime:      $UPTIME"

echo ""

# Neovim version
if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version | head -n1 | awk '{print $2}')
    echo "  Editor:      neovim $NVIM_VERSION"
fi

# Node version
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "  Node.js:     $NODE_VERSION"
fi

# Python version
if command -v python3 &> /dev/null; then
    PY_VERSION=$(python3 --version | awk '{print $2}')
    echo "  Python:      $PY_VERSION"
fi

echo ""
echo "  Type 'help-dev' for useful commands"
echo "================================================"
echo ""
```

**Make it executable:**

```bash
chmod +x ~/.zsh_welcome
```

---

## Optional: Oh My Zsh

If you prefer a framework with pre-configured plugins and themes:

### Install Oh My Zsh

```bash
# Install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# This will backup your .zshrc to .zshrc.pre-oh-my-zsh
```

### Configure Oh My Zsh

Edit `~/.zshrc` and uncomment the Oh My Zsh section:

```bash
nvim ~/.zshrc
```

```bash
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"  # or "agnoster", "powerlevel10k/powerlevel10k"
plugins=(
    git
    docker
    python
    brew
    macos
    colored-man-pages
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh
```

### Install Oh My Zsh Plugins

```bash
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Reload
source ~/.zshrc
```

**Note:** If using Oh My Zsh, you may want to merge custom aliases and functions from the recommended .zshrc into the Oh My Zsh config.

---

## Testing Your Setup

### Test ZSH Configuration

```bash
# 1. Test aliases
ll              # Should list files
macstat         # Should show macOS stats
battery         # Should show battery status

# 2. Test functions
help-dev        # Should show command reference
h git           # Should search history

# 3. Test neovim
v test.txt      # Opens neovim
echo $EDITOR    # Should output: nvim

# 4. Test git integration
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
echo $GIT_EDITOR  # Should be: nvim
```

### Test FZF Integration

```bash
# Press these key combinations:
# Ctrl + R   → Fuzzy search command history
# Ctrl + T   → Fuzzy file finder
# Option + C → Fuzzy directory finder (Alt+C on Windows keyboard)

# Try the vf function
vf             # Should open fuzzy finder, then edit selected file
```

### Test Neovim

```bash
# 1. Open neovim
nvim

# 2. Try key bindings
# Space + e  → File explorer
# Space + w  → Save
# jk         → Exit insert mode

# 3. Test man pages
man ls         # Should open in neovim
```

### Test ZSH Enhancements

```bash
# 1. Type a previous command partially
# You should see gray suggestion
# Press → to accept

# 2. Type: git status
# "git" should be highlighted green (valid command)

# 3. Type: invalidcommand
# Should be highlighted red
```

---

## macOS-Specific Tips

### 1. Terminal.app Configuration

```bash
# Preferences → Profiles → Text
# - Font: SF Mono, 14pt (or Menlo/Monaco)
# - Use bold fonts: ✓
# - Display ANSI colors: ✓

# Preferences → Profiles → Window
# - Columns: 120-140
# - Rows: 30-40
```

### 2. iTerm2 (Recommended Alternative)

```bash
# Install
brew install --cask iterm2

# Recommended settings:
# - Profiles → Text → Font: MesloLGS NF, 13pt
# - Profiles → Colors → Color Presets: Solarized Dark/Light
# - Profiles → Keys → Left Option Key: Esc+
# - Profiles → Terminal → Scrollback: 10000 lines
```

### 3. macOS Keyboard Shortcuts

Add these to iTerm2 or Terminal.app:

```
Cmd + T     → New tab
Cmd + N     → New window
Cmd + W     → Close tab
Cmd + 1-9   → Switch to tab 1-9
Cmd + ←/→   → Previous/next tab
Cmd + D     → Split pane vertically
Cmd + Shift+D → Split pane horizontally
```

### 4. Clipboard Integration

The `.zshrc` includes macOS clipboard functions:

```bash
# Copy current directory to clipboard
pwdc

# Copy file contents to clipboard
cpc filename.txt

# Paste from clipboard
pbpaste
```

### 5. Spotlight Indexing

Exclude build directories from Spotlight:

```bash
# Add to System Preferences → Spotlight → Privacy:
# - node_modules/
# - .git/
# - venv/
# - build/
# - dist/

# Or via command line:
sudo mdutil -i off /path/to/directory
```

### 6. macOS System Commands

```bash
# Flush DNS cache
flushdns

# Show/hide hidden files in Finder
showfiles
hidefiles

# Get local IP
localip

# Get public IP
myip

# Show listening ports
ports

# Kill process on specific port
killport 3000
```

---

## Troubleshooting

### Neovim Not Found

```bash
# Check if installed
which nvim

# If not, install via Homebrew
brew install neovim

# Or install latest from GitHub
brew install --HEAD neovim
```

### FZF Key Bindings Not Working

```bash
# Reinstall fzf with key bindings
$(brew --prefix)/opt/fzf/install

# Answer yes to all prompts
# Reload
source ~/.zshrc
```

### Slow Shell Startup

```bash
# Profile zsh startup
zsh -xv

# Common culprits:
# - Too many Homebrew packages (clean up)
# - Oh My Zsh with too many plugins
# - NVM loading (use lazy loading)

# Optimize NVM (add to .zshrc):
export NVM_LAZY_LOAD=true
```

### Command Not Found

```bash
# Check if Homebrew is in PATH
echo $PATH | grep brew

# If not, add Homebrew to PATH
# Apple Silicon:
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel:
eval "$(/usr/local/bin/brew shellenv)"
```

### Git Editor Still vim

```bash
# Set explicitly
git config --global core.editor "nvim"

# Verify
git config --global core.editor
```

### ZSH Completion Not Working

```bash
# Rebuild completion cache
rm -f ~/.zcompdump*
compinit

# Reload
source ~/.zshrc
```

### Completion Keys Not Working in Neovim Terminal

If `Ctrl-E` or other completion keys don't work in neovim's terminal:

```bash
# Add to ~/.config/nvim/init.lua
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    local opts = { buffer = 0, noremap = true }
    vim.keymap.set('t', '<C-e>', '<C-e>', opts)
    vim.keymap.set('t', '<C-n>', '<C-n>', opts)
    vim.keymap.set('t', '<C-p>', '<C-p>', opts)
  end,
})

# Then reload neovim
```

Alternatively, use different key bindings in zsh:

```bash
# Add to ~/.zshrc
bindkey '^N' menu-complete       # Use Ctrl-N instead
bindkey '^F' autosuggest-accept  # Use Ctrl-F for suggestions
```

See the [Advanced ZSH Completion](#advanced-zsh-completion) section for more details.

---

## Quick Reference

### Homebrew Commands

```bash
brew install <package>      # Install package
brew uninstall <package>    # Remove package
brew update                 # Update Homebrew
brew upgrade                # Upgrade all packages
brew upgrade <package>      # Upgrade specific package
brew list                   # List installed packages
brew search <package>       # Search for package
brew info <package>         # Show package info
brew doctor                 # Check for issues
brew cleanup                # Remove old versions
```

### Most Used Aliases

```bash
# Navigation
ll, la, l      # List files
..             # Go up directory
mkcd <dir>     # Create and enter

# Neovim
v, vim, nv     # Open neovim
nvimrc         # Edit config
vf             # Fuzzy find and edit

# Git
gs             # git status
gaa            # git add all
gcm "msg"      # git commit -m
gp             # git push
gl             # git log (pretty)

# macOS
macstat        # System stats
battery        # Battery info
myip           # Public IP
localip        # Local IP
killport <n>   # Kill on port

# Utilities
extract <file> # Extract archive
backup <file>  # Backup file
o <file>       # Open in default app
pwdc           # Copy pwd to clipboard
```

### ZSH-Specific Features

```bash
# Directory stack
d              # Show stack
1-9            # Jump to directory

# Auto-cd
/Users/...     # Just type path, no cd needed

# Globbing
ls **/*.txt    # Recursive search
ls *.{jpg,png} # Multiple extensions

# History
!!             # Repeat last command
!$             # Last argument
!*             # All arguments
```

---

## Differences from Raspberry Pi Setup

### What's Different:

1. **Package Manager**: Homebrew instead of apt
2. **System Monitoring**: macOS-specific commands (pmset, sysctl, etc.)
3. **No Raspberry Pi commands**: No vcgencmd, no Pi-specific aliases
4. **Clipboard**: pbcopy/pbpaste instead of xclip
5. **Terminal**: iTerm2/Terminal.app instead of x-terminal
6. **Paths**: Different Homebrew paths for Apple Silicon vs Intel

### What's the Same:

1. **Neovim config**: 100% portable, identical init.lua
2. **Most aliases**: Git, Docker, Python work identically
3. **Functions**: All custom functions work on both
4. **FZF integration**: Same keybindings and behavior
5. **Philosophy**: Same development workflow

---

## Backup and Restore

### Backup Your Configuration

```bash
# Create backup directory
mkdir -p ~/dotfile-backups/$(date +%Y%m%d)

# Backup configs
cp ~/.zshrc ~/dotfile-backups/$(date +%Y%m%d)/
cp ~/.zsh_welcome ~/dotfile-backups/$(date +%Y%m%d)/ 2>/dev/null
cp -r ~/.config/nvim ~/dotfile-backups/$(date +%Y%m%d)/

# Create archive
cd ~/dotfile-backups
tar -czf dotfiles-$(date +%Y%m%d).tar.gz $(date +%Y%m%d)
```

### Sync Between Machines

```bash
# Use a git repository
mkdir -p ~/dotfiles
cd ~/dotfiles
git init

# Add configs
ln -s ~/.zshrc ~/dotfiles/zshrc
ln -s ~/.config/nvim ~/dotfiles/nvim
# etc.

# Push to GitHub
git remote add origin git@github.com:yourusername/dotfiles.git
git push -u origin main

# On another Mac
git clone git@github.com:yourusername/dotfiles.git
cd dotfiles
# Create symlinks
ln -s ~/dotfiles/zshrc ~/.zshrc
# etc.
```

---

## Next Steps

### 1. Customize Your Setup

Edit `~/.zshrc.local` for personal customizations:

```bash
nvim ~/.zshrc.local
```

### 2. Explore Advanced Tools

```bash
# tmux - Terminal multiplexer
brew install tmux

# Alacritty - GPU-accelerated terminal
brew install --cask alacritty

# lazygit - Terminal UI for git
brew install lazygit

# gh - GitHub CLI
brew install gh
```

### 3. Learn More

- ZSH Documentation: https://zsh.sourceforge.io/Doc/
- Neovim Docs: https://neovim.io/doc/
- Homebrew Docs: https://docs.brew.sh/
- FZF GitHub: https://github.com/junegunn/fzf

---

## Done!

Your macOS development environment is now fully configured with:

- ✅ ZSH with intelligent completion and history
- ✅ Neovim as default editor
- ✅ FZF fuzzy finding
- ✅ Beautiful CLI tools (bat, exa, ripgrep, fd)
- ✅ Git integration
- ✅ macOS-specific utilities
- ✅ Clipboard integration
- ✅ Optional: Autosuggestions and syntax highlighting

Type `help-dev` anytime to see available commands!

---

**Last Updated**: February 2026  
**Tested On**: macOS Sonoma 14.x, macOS Sequoia 15.x (Apple Silicon & Intel)
