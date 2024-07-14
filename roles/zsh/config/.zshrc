# zmodload zsh/zprof # Always top of your .zshrc file, uncomment to profile zsh shell

# Zinit # On macos takes 10ms to load
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Zinit plugins
# Lazy load the plugin and lucid meaning no prompt message when finish
zinit ice wait lucid
zinit light Aloxaf/fzf-tab # On macos m1 takes 10ms to load

zinit ice wait lucid 
zinit light zdharma-continuum/fast-syntax-highlighting # On macos m1 takes 20ms to load

zinit ice wait lucid
zinit light zsh-users/zsh-completions

# does not load properly with lazy load. But no worries, is not a slow plugin...
zinit light zsh-users/zsh-autosuggestions

zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Completions
# zsh doc: https://zsh.sourceforge.io/Doc/Release/Completion-System.html
# snippet original source, read the thread: https://gist.github.com/ctechols/ca1035271ad134841284 
autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
  compinit
done
compinit -C

# Aliases
source ~/.aliases

# Keybindings
# bindkey -v # TODO: try vim mode instead of emacs
bindkey -e # Emacs keybindings mode
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -s ^f "tmux-session\n" # Lauch script using keybindings

# Shell settings
setopt autocd # If match a directory cd

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

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-Z}' # Make completions case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Add colors to completions. Similar to ls --colors
zstyle ':completion:*' menu no # Disable completion menu, we will use Aloxaf/fzf-tab plugin instead for better expirience
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:complete:cd:*' fzf --preview 'ls $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf --preview 'ls $realpath'


# Shell integrations
type zoxide &> /dev/null && eval "$(zoxide init zsh)"
type fzf &> /dev/null && eval "$(fzf --zsh)" # On macos m1 takes 10ms to load

# Path
addToPathFront $HOME/go/bin
type brew &> /dev/null && addToPathFront /opt/homebrew/bin # Homebrew, only for macos
addToPathFront $HOME/.local/bin

# zprof # Always bottom of .zshrc, uncomment to profile zsh shell