# zmodload zsh/zprof # top of your .zshrc file

OS_UNAME=$(uname)

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Zinit plugins
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
if [[ OS_UNAME == "Darwin" ]]; then
    zinit light Aloxaf/fzf-tab
fi

# Colors
# type vivid &> /dev/null && export LS_COLORS="$(vivid generate catppuccin-macchiato)"

# Load completions
# TODO: Add cache ceck only once a day
autoload -Uz compinit 
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;
_comp_options+=(globdots) # add dotfiles to the zsh completion

# Add completions installed through Homebrew packages
# See: https://docs.brew.sh/Shell-Completion
if type brew &>/dev/null; then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi

# Aliases
source ~/.aliases

# Keybindings
# bindkey -v # TODO: try vim mode instead of emacs
bindkey -e # Emacs keybindings mode
# Use relanted history search. For example, if curl is written only show history that start with curl
bindkey '^p' history-search-backward 
bindkey '^n' history-search-forward
bindkey -s ^f "tmux-session\n" # Lauch script using keybindings

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

if [[ OS_UNAME == "Darwin" ]]; then
    zstyle ':completion:*' menu no # Disable completion menu, we will use Aloxaf/fzf-tab plugin instead for better expirience
    zstyle ':fzf-tab:complete:cd:*' fzf --preview 'ls $realpath'
    zstyle ':fzf-tab:complete:__zoxide_z:*' fzf --preview 'ls $realpath'
fi


# Shell integrations
type starship &> /dev/null && eval "$(starship init zsh)"
type zoxide &> /dev/null && eval "$(zoxide init zsh)"
# Fzf, older versions don't have --zsh flag. Check if it's available
# If not just launch fzf keybing and completion script directly
# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
if [ fzf --zsh &> /dev/null -q 0 ]; then
    type fzf &> /dev/null && eval "$(fzf --zsh)"
else
    source /usr/share/doc/fzf/examples/completion.zsh
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# Path
addToPathFront $HOME/go/bin
command -v brew >/dev/null 2>&1 && addToPathFront /opt/homebrew/bin # Homebrew, only for macos
addToPathFront $HOME/.local/bin

# zprof # bottom of .zshrc