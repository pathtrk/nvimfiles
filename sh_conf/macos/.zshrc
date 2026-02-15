# ============================================
# .zshrc - ZSH Configuration for macOS
# Adapted from Raspberry Pi bash configuration
# ============================================

# ============================================
# OH MY ZSH (Optional - uncomment if using)
# ============================================
# If you use Oh My Zsh, uncomment and configure:
# export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="robbyrussell"  # or your preferred theme
# plugins=(git docker python colored-man-pages zsh-autosuggestions zsh-syntax-highlighting)
# source $ZSH/oh-my-zsh.sh

# ============================================
# ENVIRONMENT VARIABLES
# ============================================

# Default editor (neovim)
export EDITOR=nvim
export VISUAL=nvim
export GIT_EDITOR=nvim

# Man pages in neovim
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# Terminal colors
export TERM=xterm-256color
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# History settings (zsh-specific)
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=20000
setopt EXTENDED_HISTORY          # Write timestamp to history
setopt INC_APPEND_HISTORY        # Add commands immediately
setopt SHARE_HISTORY             # Share history between sessions
setopt HIST_IGNORE_DUPS          # Ignore consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS      # Delete old duplicate entries
setopt HIST_FIND_NO_DUPS         # Don't display duplicates in search
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicates to history file
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks

# Directory navigation (zsh-specific)
setopt AUTO_CD                   # cd by typing directory name
setopt AUTO_PUSHD                # Push directories onto stack
setopt PUSHD_IGNORE_DUPS         # Don't push duplicates
setopt PUSHD_SILENT              # Don't print directory stack

# Completion settings
setopt COMPLETE_IN_WORD          # Complete from cursor position
setopt ALWAYS_TO_END             # Move cursor to end after completion
setopt AUTO_MENU                 # Show completion menu on tab
setopt AUTO_LIST                 # Automatically list choices
setopt MENU_COMPLETE             # Insert first match immediately

# Other useful options
setopt INTERACTIVE_COMMENTS      # Allow comments in interactive mode
setopt EXTENDED_GLOB             # Extended globbing
setopt PROMPT_SUBST              # Enable prompt substitution

# ============================================
# PATH CONFIGURATION
# ============================================

# Homebrew (Apple Silicon)
if [[ -d /opt/homebrew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Homebrew (Intel)
if [[ -d /usr/local/Homebrew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# User binaries
export PATH="$HOME/.local/bin:$PATH"

# Neovim (if installed in custom location)
if [ -d "$HOME/neovim/bin" ]; then
    export PATH="$HOME/neovim/bin:$PATH"
fi

# Python user base
if [ -d "$HOME/Library/Python/3.11/bin" ]; then
    export PATH="$HOME/Library/Python/3.11/bin:$PATH"
fi

# Cargo (Rust)
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ============================================
# ZSH COMPLETION SYSTEM
# ============================================

# Initialize completion system
autoload -Uz compinit
# Only check once a day for performance
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # Colored completion
zstyle ':completion:*' group-name ''                        # Group by category
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# ============================================
# PROMPT CONFIGURATION
# ============================================

# Git branch in prompt
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%F{yellow}(%b)%f'
zstyle ':vcs_info:*' enable git

# Prompt configuration
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f${vcs_info_msg_0_}%# '

# Right prompt with time (optional)
# RPROMPT='%F{gray}%*%f'

# ============================================
# ALIASES - BASIC NAVIGATION
# ============================================

# Enhanced ls (using macOS ls or gls from coreutils)
if command -v gls &> /dev/null; then
    # Use GNU ls if available (brew install coreutils)
    alias ls='gls --color=auto'
    alias ll='gls -alF --color=auto'
    alias la='gls -A --color=auto'
    alias l='gls -CF --color=auto'
else
    # Use macOS ls
    alias ll='ls -alFG'
    alias la='ls -AG'
    alias l='ls -CFG'
fi

alias lh='ls -lh'
alias lt='ls -ltr'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Quick directory access
alias ~='cd ~'
alias -- -='cd -'  # Go to previous directory

# Directory stack
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# ============================================
# ALIASES - GIT
# ============================================

alias gs='git status'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gdc='git diff --cached'
alias gb='git branch'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gf='git fetch'
alias gm='git merge'
alias gr='git remote -v'
alias gst='git stash'
alias gstp='git stash pop'

# Git with neovim
alias gvim='nvim $(git diff --name-only --diff-filter=ACMR)'

# ============================================
# ALIASES - SYSTEM MONITORING (macOS)
# ============================================

# System info
alias mem='top -l 1 -s 0 | grep PhysMem'
alias cpu='top -l 1 -s 0 | grep "CPU usage"'
alias disk='df -h'
alias battery='pmset -g batt'
alias temp='sudo powermetrics --samplers smc | grep -i "CPU die temperature"'  # Requires sudo

# macOS specific
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'

# Network
alias myip='curl -s ifconfig.me'
alias localip='ipconfig getifaddr en0'
alias ports='sudo lsof -iTCP -sTCP:LISTEN -n -P'

# Process management
alias psa='ps aux'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias top='top -o cpu'
alias memtop='top -o mem'

# Quick statistics
alias macstat='echo "=== System Stats ==="; \
    echo "CPU: $(sysctl -n machdep.cpu.brand_string)"; \
    echo "Cores: $(sysctl -n hw.ncpu)"; \
    echo "Memory: $(sysctl -n hw.memsize | awk "{print \$1/1024/1024/1024\" GB\"}")"; \
    echo "Disk:"; df -h / | tail -1; \
    echo "Uptime: $(uptime | awk "{print \$3,\$4}" | sed "s/,//")"; \
    echo "Battery:"; pmset -g batt | grep -o "[0-9]*%"'

# ============================================
# ALIASES - DEVELOPMENT
# ============================================

# Python
alias py='python3'
alias pip='pip3'
alias ve='python3 -m venv'
alias va='source venv/bin/activate'
alias vd='deactivate'
alias pipi='pip3 install'
alias pipu='pip3 install --upgrade'

# Node.js / npm
alias ni='npm install'
alias nid='npm install --save-dev'
alias nu='npm uninstall'
alias nup='npm update'
alias nr='npm run'
alias ns='npm start'
alias nt='npm test'

# Docker
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -q)'

# ============================================
# ALIASES - NEOVIM
# ============================================

alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias nv='nvim'
alias nvimrc='nvim ~/.config/nvim/init.lua'
alias vimrc='nvim ~/.config/nvim/init.vim'

# ============================================
# ALIASES - UTILITIES
# ============================================

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Better defaults
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias wget='wget -c'

# Quick edits
alias zshrc='nvim ~/.zshrc'
alias zshreload='source ~/.zshrc'
alias hosts='sudo nvim /etc/hosts'

# Use bat if available
if command -v bat &> /dev/null; then
    alias cat='bat'
fi

# Use exa if available (better ls)
if command -v exa &> /dev/null; then
    alias ls='exa'
    alias ll='exa -alF'
    alias la='exa -a'
    alias lt='exa -alF --sort=modified'
    alias tree='exa --tree'
fi

# ============================================
# FUNCTIONS
# ============================================

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Backup file with timestamp
backup() {
    if [ -f "$1" ]; then
        cp "$1" "${1}.backup-$(date +%Y%m%d-%H%M%S)"
        echo "Backed up $1"
    else
        echo "File $1 not found"
    fi
}

# Search history
h() {
    if [ -z "$1" ]; then
        history
    else
        history | grep "$1"
    fi
}

# Find process by name
psgrep() {
    ps aux | grep -v grep | grep -i -e VSZ -e "$1"
}

# Quick daily notes
note() {
    local note_dir="$HOME/notes"
    local note_file="$note_dir/$(date +%Y-%m-%d).md"
    mkdir -p "$note_dir"
    nvim + "$note_file"
}

# Fuzzy find and edit with fzf
vf() {
    local file
    if command -v bat &> /dev/null; then
        file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}' 2>/dev/null)
    else
        file=$(fzf --preview 'cat {}' 2>/dev/null)
    fi
    [ -n "$file" ] && nvim "$file"
}

# Git quick commit
gcq() {
    git add -A && git commit -m "$*" && git push
}

# Open in default app (macOS)
o() {
    if [ $# -eq 0 ]; then
        open .
    else
        open "$@"
    fi
}

# Copy current directory path to clipboard
pwdc() {
    pwd | pbcopy
    echo "Current directory path copied to clipboard"
}

# Copy file contents to clipboard
cpc() {
    if [ -f "$1" ]; then
        cat "$1" | pbcopy
        echo "Contents of $1 copied to clipboard"
    else
        echo "File $1 not found"
    fi
}

# Quick weather (requires curl)
weather() {
    local location="${1:-}"
    curl -s "wttr.in/${location}?format=3"
}

# Find large files
findlarge() {
    local size="${1:-100M}"
    find . -type f -size +${size} -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'
}

# Kill process by port (macOS)
killport() {
    if [ -z "$1" ]; then
        echo "Usage: killport <port>"
        return 1
    fi
    local pid=$(lsof -ti:$1)
    if [ -n "$pid" ]; then
        kill -9 $pid
        echo "Killed process on port $1"
    else
        echo "No process found on port $1"
    fi
}

# Help command - show useful commands
help-dev() {
    cat << 'EOF'
╔════════════════════════════════════════════════════════════╗
║              ZSH Development Environment Help              ║
╚════════════════════════════════════════════════════════════╝

Navigation:
  ll, la, l      - List files with different options
  lt             - List by time (newest last)
  ..             - Go up one directory
  mkcd <dir>     - Create and enter directory
  d              - Show directory stack
  1-9            - Jump to directory in stack

Git:
  gs             - git status
  ga / gaa       - git add / git add all
  gc / gcm       - git commit / git commit -m
  gp / gpl       - git push / git pull
  gl             - git log (pretty graph)
  gco / gcb      - git checkout / checkout -b
  gcq <msg>      - Quick: add all, commit, push

Neovim:
  v, nv, vim     - Open neovim
  nvimrc         - Edit neovim config
  vf             - Fuzzy find and edit file
  note           - Quick daily notes
  gvim           - Edit changed files in neovim

System (macOS):
  mem            - Memory usage
  cpu            - CPU usage
  disk           - Disk usage
  battery        - Battery status
  macstat        - All system stats
  myip / localip - IP addresses
  ports          - List listening ports
  killport <n>   - Kill process on port

Python:
  ve venv        - Create virtual env
  va / vd        - Activate / deactivate venv
  pipi / pipu    - pip install / upgrade

Docker:
  dps / dpsa     - Show containers
  dex <id> bash  - Execute bash in container
  dlog <id>      - Follow logs

Utilities:
  extract <file> - Extract any archive
  backup <file>  - Backup with timestamp
  h <pattern>    - Search history
  psgrep <name>  - Find process
  o <file>       - Open in default app
  pwdc           - Copy pwd to clipboard
  cpc <file>     - Copy file to clipboard
  weather [loc]  - Show weather
  findlarge [sz] - Find large files (default: >100M)

Configuration:
  zshrc          - Edit this config
  zshreload      - Reload configuration

FZF (if installed):
  Ctrl+R         - Search history
  Ctrl+T         - Find files
  Alt+C          - Find directories
  vf             - Fuzzy find and edit

╚════════════════════════════════════════════════════════════╝
EOF
}

# ============================================
# FZF INTEGRATION
# ============================================

# FZF configuration
if command -v fzf &> /dev/null; then
    # Set up fzf key bindings (Homebrew)
    if [ -f ~/.fzf.zsh ]; then
        source ~/.fzf.zsh
    elif [ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ]; then
        source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
        source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
    fi

    # FZF default command (use fd if available)
    if command -v fd &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi

    # FZF theme
    export FZF_DEFAULT_OPTS='
    --color=fg:#d0d0d0,bg:#121212,hl:#5f87af
    --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
    --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
    --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
    --height 40% --layout=reverse --border
    --preview-window=right:60%:wrap'
fi

# ============================================
# ZSH PLUGINS (Manual)
# ============================================

# zsh-autosuggestions (if installed via Homebrew)
if [ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    # Customize suggestion color
    export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
fi

# zsh-syntax-highlighting (must be last)
if [ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ============================================
# WELCOME MESSAGE
# ============================================

# Show welcome on new terminal
if [ -f ~/.zsh_welcome ]; then
    source ~/.zsh_welcome
fi

# ============================================
# LOCAL CUSTOMIZATIONS
# ============================================

# Load local settings (not version controlled)
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# ============================================
# FINAL SETUP
# ============================================

# Add Homebrew completions
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

# Enable command-not-found on macOS (if Homebrew)
if brew command command-not-found-init > /dev/null 2>&1; then
    eval "$(brew command-not-found-init)"
fi
eval "$(starship init zsh)"
