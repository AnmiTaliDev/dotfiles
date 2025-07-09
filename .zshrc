# =============================================================================
# ZSH Configuration
# =============================================================================

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# =============================================================================
# Theme & UI Configuration
# =============================================================================

ZSH_THEME="fino"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"
COMPLETION_WAITING_DOTS="true"

# =============================================================================
# Plugin Configuration
# =============================================================================

plugins=(
    git
    fzf
    zsh-syntax-highlighting
    zsh-autosuggestions
    colorize
    command-not-found
    history-substring-search
    rust
    golang
    npm
    yarn
)

# =============================================================================
# History Configuration
# =============================================================================

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# History options
setopt HIST_IGNORE_ALL_DUPS     # Remove older duplicate entries from history
setopt HIST_FIND_NO_DUPS        # Don't display duplicates during searches
setopt HIST_IGNORE_SPACE        # Don't save commands that start with space
setopt HIST_SAVE_NO_DUPS        # Don't save duplicate entries
setopt SHARE_HISTORY            # Share history between sessions
setopt EXTENDED_HISTORY         # Save timestamp and duration
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicates first
setopt HIST_VERIFY              # Show command before executing from history

# =============================================================================
# Environment Variables
# =============================================================================

export EDITOR='micro'
export VISUAL='micro'
export PAGER='less'
export BROWSER='firefox'

# =============================================================================
# PATH Configuration
# =============================================================================

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.4.0/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

# =============================================================================
# Source Oh My Zsh
# =============================================================================

source "$ZSH/oh-my-zsh.sh"

# =============================================================================
# Shell Options
# =============================================================================

# Directory navigation
setopt AUTO_CD              # Auto change to directory without cd
setopt AUTO_PUSHD           # Push directories to stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt PUSHD_MINUS          # Use - instead of +
setopt PUSHD_SILENT         # Don't print directory stack

# Other useful options
setopt CORRECT              # Correct commands
setopt CORRECT_ALL          # Correct all arguments
setopt NO_CASE_GLOB         # Case insensitive globbing
setopt NUMERIC_GLOB_SORT    # Sort globs numerically
setopt EXTENDED_GLOB        # Enable extended globbing

# =============================================================================
# Completion System
# =============================================================================

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zcompcache"
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# =============================================================================
# Aliases
# =============================================================================

# System aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cat='meow'
alias grep='rg'
alias fgrep='rg'
alias egrep='rg'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Configuration editing
alias zshconfig="$EDITOR ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"



# System information
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps aux'
alias top='htop'
alias ports='netstat -tuln'

# Package management (Arch Linux)
alias pac='sudo pacman'
alias pacs='pacman -Ss'
alias paci='sudo pacman -S'
alias pacr='sudo pacman -R'
alias pacu='sudo pacman -Syu'
alias pacq='pacman -Q'
alias pacqi='pacman -Qi'
alias pacql='pacman -Ql'
alias yay-update='yay -Syu'
alias yay-search='yay -Ss'
alias yay-install='yay -S'

# Development aliases
alias py='python3'
alias pip='pip3'
alias json='python3 -m json.tool'
alias urlencode='python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.argv[1]))"'

# Utility aliases
alias h='history'
alias c='clear'
alias e='exit'
alias q='exit'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'
alias week='date +%V'
alias myip='curl -s http://checkip.dyndns.org | grep -o "[0-9.]*"'
alias localip='ip route get 1.1.1.1 | grep -oP "src \K\S+"'

# Safety aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'
alias mkdir='mkdir -p'

# =============================================================================
# FZF Configuration
# =============================================================================

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS="
    --height 40% 
    --layout=reverse 
    --border
    --preview 'head -100 {}'
    --preview-window=right:50%:wrap
    --bind 'ctrl-y:execute-silent(echo {} | xclip -selection clipboard)'
    --bind 'ctrl-e:execute(echo {} | xargs -o $EDITOR)'
    --color=bg+:#343d46,bg:#1e1e1e,spinner:#f4bf75,hl:#65737e
    --color=fg:#c0c5ce,header:#65737e,info:#f4bf75,pointer:#bf616a
    --color=marker:#bf616a,fg+:#c0c5ce,prompt:#65737e,hl+:#bf616a
"

export FZF_CTRL_T_OPTS="
    --preview 'bat --style=numbers --color=always --line-range :500 {}'
    --preview-window=right:50%:wrap
"

export FZF_CTRL_R_OPTS="
    --preview 'echo {}' 
    --preview-window=down:3:hidden:wrap 
    --bind '?:toggle-preview'
"

export FZF_ALT_C_OPTS="
    --preview 'tree -C {} | head -200'
    --preview-window=right:50%:wrap
"

# =============================================================================
# Auto-suggestions Configuration
# =============================================================================

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# =============================================================================
# Key Bindings
# =============================================================================

# History substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# =============================================================================
# Functions
# =============================================================================

# Weather function
weather() {
    curl "wttr.in/${1:-}"
}

# =============================================================================
# Load Custom Configurations
# =============================================================================

# Load custom functions if they exist
[ -f ~/.zsh_functions ] && source ~/.zsh_functions

# Load work-specific configuration
[ -f ~/.zshrc.work ] && source ~/.zshrc.work

# Load local configuration if it exists
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# =============================================================================
# Final Setup
# =============================================================================

# Enable command completion
autoload -U compinit
compinit
