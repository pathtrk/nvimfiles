# ~/.bashrc: executed by bash(1) for non-login shells.
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ============================================
# HISTORY CONFIGURATION
# ============================================
export HISTSIZE=10000                           # Lines in memory
export HISTFILESIZE=20000                       # Lines in file
export HISTCONTROL=ignoredups:erasedups         # No duplicates
shopt -s histappend                             # Append to history, don't overwrite
export HISTTIMEFORMAT='%F %T '                  # Timestamp in history

# After each command, append to history and reread it
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# ============================================
# SHELL OPTIONS
# ============================================
shopt -s cdspell                # Autocorrect typos in cd
shopt -s checkwinsize           # Update LINES and COLUMNS after each command
shopt -s cmdhist                # Save multi-line commands in one history entry
shopt -s dotglob                # Include dotfiles in pathname expansion
shopt -s expand_aliases         # Expand aliases

# Enable programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ============================================
# ENVIRONMENT VARIABLES
# ============================================
export EDITOR=nvim              # Default editor (neovim)
export VISUAL=nvim              # Visual editor (neovim)
export PAGER=less
export MANPAGER='nvim +Man!'    # Use neovim as man pager
export GIT_EDITOR=nvim          # Use neovim for git commits, diffs, etc.

# Enable true color support in neovim
export TERM=xterm-256color

# Colorize less output
export LESS='-R'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# ============================================
# PATH ADDITIONS
# ============================================
# Add local bin to PATH if it exists
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Add cargo bin (Rust) if it exists
if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

# Add neovim path if installed in custom location
if [ -d "$HOME/neovim/bin" ]; then
    export PATH="$HOME/neovim/bin:$PATH"
fi

# Add Go bin if it exists
if [ -d "/usr/local/go/bin" ]; then
    export PATH="/usr/local/go/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ]; then
    export PATH="$HOME/go/bin:$PATH"
fi

# ============================================
# ENHANCED LS ALIASES
# ============================================
alias ll='ls -alF'           # Long format with hidden files
alias la='ls -A'             # All files except . and ..
alias l='ls -CF'             # Column format
alias lh='ls -lh'            # Long format with human-readable sizes
alias lt='ls -ltr'           # Sort by modification time (oldest first)
alias lS='ls -lSr'           # Sort by size (smallest first)

# Enable color support for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ============================================
# NAVIGATION SHORTCUTS
# ============================================
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'            # Go back to previous directory

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Make directory with parents
mkdirp() {
    mkdir -p "$1" && cd "$1"
}

# ============================================
# NEOVIM ALIASES
# ============================================
alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias nv='nvim'

# Quick config edit
alias nvimrc='nvim ~/.config/nvim/init.lua'  # If using Lua config
alias vimrc='nvim ~/.config/nvim/init.vim'   # If using VimScript config

# ============================================
# GIT ALIASES
# ============================================
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gpull='git pull'
alias glog='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Open changed files in nvim
alias gvim='nvim $(git diff --name-only --diff-filter=ACMR)'

# ============================================
# SYSTEM INFO
# ============================================
alias temp='vcgencmd measure_temp'
alias cpu='cat /proc/cpuinfo | grep "model name" | head -1'
alias mem='free -h'
alias disk='df -h'
alias ports='sudo netstat -tulanp'
alias myip='curl -s ifconfig.me'

# Raspberry Pi specific
alias fanspeed='cat /sys/class/hwmon/hwmon3/fan1_input 2>/dev/null || echo "Fan not detected"'
alias throttle='vcgencmd get_throttled'
alias pistat='echo "Temperature: $(vcgencmd measure_temp | cut -d= -f2)"; echo "Memory: $(free -h | awk "NR==2{printf \"%s / %s (%.0f%%)\", \$3,\$2,\$3*100/\$2}")"; echo "Disk: $(df -h / | awk "NR==2{printf \"%s / %s (%s)\", \$3,\$2,\$5}")"'

# ============================================
# DEVELOPMENT SHORTCUTS
# ============================================
alias py='python3'
alias pip='pip3'
alias ve='python3 -m venv'           # Create virtual env
alias va='source venv/bin/activate'  # Activate venv
alias vd='deactivate'                # Deactivate venv

# Docker
alias dps='docker ps'
alias dpsa='docker ps -a'
alias dimg='docker images'
alias dc='docker-compose'
alias dcu='docker-compose up'
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f'

# ============================================
# SAFETY NETS
# ============================================
alias rm='rm -i'      # Confirm before removing
alias cp='cp -i'      # Confirm before overwriting
alias mv='mv -i'      # Confirm before overwriting
alias ln='ln -i'      # Confirm before overwriting

# Make these safer
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# ============================================
# USEFUL FUNCTIONS
# ============================================

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
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

# Quick search in history
h() {
    history | grep "$1"
}

# Find process by name
psgrep() {
    ps aux | grep -v grep | grep -i -e VSZ -e "$1"
}

# Quick note taking with nvim
note() {
    local note_file="$HOME/notes/$(date +%Y-%m-%d).md"
    mkdir -p "$HOME/notes"
    nvim + "$note_file"  # Open at end of file
}

# Search and edit files with fzf + nvim (requires fzf)
vf() {
    if command -v fzf &> /dev/null; then
        local file
        if command -v batcat &> /dev/null; then
            file=$(fzf --preview 'batcat --color=always --style=numbers --line-range=:500 {}')
        else
            file=$(fzf --preview 'cat {}')
        fi
        [ -n "$file" ] && nvim "$file"
    else
        echo "fzf not installed. Install with: sudo apt install fzf"
    fi
}

# Backup a file
backup() {
    if [ -f "$1" ]; then
        cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
        echo "Backed up to: $1.backup-$(date +%Y%m%d-%H%M%S)"
    else
        echo "'$1' is not a valid file"
    fi
}

# Create a directory and cd into it
mcd() {
    mkdir -p "$1" && cd "$1"
}

# ============================================
# PROMPT CUSTOMIZATION
# ============================================

# Colored prompt with git branch info
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Color codes
COLOR_RESET='\[\033[00m\]'
COLOR_GREEN='\[\033[01;32m\]'
COLOR_BLUE='\[\033[01;34m\]'
COLOR_YELLOW='\[\033[01;33m\]'
COLOR_RED='\[\033[01;31m\]'

# Simple colored prompt: user@host:path (git-branch) $
export PS1="${COLOR_GREEN}\u@\h${COLOR_RESET}:${COLOR_BLUE}\w${COLOR_RESET}${COLOR_YELLOW}\$(parse_git_branch)${COLOR_RESET}\$ "

# ============================================
# FZF INTEGRATION
# ============================================
# FZF keybindings and completion
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Use fd instead of find for fzf (faster)
if command -v fdfind &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
    alias fd='fdfind'
fi

# Bat (better cat)
if command -v batcat &> /dev/null; then
    alias bat='batcat'
    alias cat='batcat --paging=never'
fi

# FZF color scheme
export FZF_DEFAULT_OPTS='
  --color=fg:#d0d0d0,bg:#121212,hl:#5f87af
  --color=fg+:#d0d0d0,bg+:#262626,hl+:#5fd7ff
  --color=info:#afaf87,prompt:#d7005f,pointer:#af5fff
  --color=marker:#87ff00,spinner:#af5fff,header:#87afaf
  --height 40% --layout=reverse --border
'

# ============================================
# HELP COMMAND
# ============================================
help-dev() {
    cat << 'EOF'

Development Server Quick Reference
===================================

Navigation:
  ll, la, l      - List files (various formats)
  ..             - Go up one directory
  ...            - Go up two directories
  mkcd <dir>     - Create directory and cd into it

Neovim:
  v, nv, vim     - Open neovim
  nvimrc         - Edit neovim config
  vf             - Fuzzy find and edit file (requires fzf)
  note           - Quick daily notes

Git:
  gs             - git status
  ga <file>      - git add
  gc             - git commit
  gp             - git push
  gl             - git log (pretty)
  gvim           - Edit changed files in neovim
  glog           - Beautiful git log
  
System:
  temp           - Show CPU temperature
  mem            - Show memory usage
  disk           - Show disk usage
  fanspeed       - Show fan RPM
  pistat         - Show Pi statistics
  
Python:
  py             - python3
  ve <name>      - Create virtual environment
  va             - Activate venv (venv/bin/activate)
  vd             - Deactivate venv
  
Docker:
  dps            - docker ps
  dimg           - docker images
  dc             - docker-compose
  dcu            - docker-compose up
  dcd            - docker-compose down

Utilities:
  extract <file> - Extract any archive
  backup <file>  - Backup file with timestamp
  h <pattern>    - Search command history
  psgrep <name>  - Find process by name

FZF (if installed):
  Ctrl+R         - Search command history
  Ctrl+T         - Find files
  Alt+C          - Find directories
  vf             - Fuzzy find and edit

EOF
}

# ============================================
# WELCOME MESSAGE
# ============================================
if [ -f ~/.bash_welcome ]; then
    . ~/.bash_welcome
fi

# ============================================
# LOAD LOCAL CUSTOMIZATIONS
# ============================================
# This allows you to have machine-specific configs
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
