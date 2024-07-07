# Path  
export PATH="$HOME/go/bin:$PATH" # Golang
command -v brew >/dev/null 2>&1 && export PATH="/opt/homebrew/bin:$PATH" # Homebrew, only for macos

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Zinit plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -U compinit && compinit
_comp_options+=(globdots) # add dotfiles to the zsh completions

# Aliases
source ~/.aliases

# Keybindings
bindkey -e # Emacs keybindings mode
# Use relanted history search. For example, if curl is written only show history that start with curl
bindkey '^p' history-search-backward 
bindkey '^n' history-search-forward

# History
HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt INC_APPEND_HISTORY # Immediately append to history file
setopt EXTENDED_HISTORY # Record timestamp in history
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history
setopt HIST_IGNORE_DUPS # Dont record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS # Do not display a line previously found
setopt HIST_IGNORE_SPACE # Dont record an entry starting with a space example: $ echo 'password'
setopt HIST_SAVE_NO_DUPS # Dont write duplicate entries in the history file
setopt SHARE_HISTORY # Share history between all sessions
unsetopt HIST_VERIFY # Execute commands using history (e.g.: using !$) immediatel

# Completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-Z}' # Make completions case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Add colors to completions. Similar to ls --colors
zstyle ':completion:*' menu no # Disable completion menu, we will use Aloxaf/fzf-tab plugin instead for better expirience
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -a $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'lsd -a $realpath'

# Shell integrations
eval "$(starship init zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"