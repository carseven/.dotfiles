zmodload zsh/zprof

# Add go install binaries to PATH
export PATH="$HOME/go/bin:$PATH"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Use homebrew installed git and zsh
source /opt/homebrew/opt/git # source $(brew --prefix git)
source /opt/homebrew/opt/zsh # source $(brew --prefix zsh)

# Fnm
# TODO: Lazy load
# eval "$(fnm env --use-on-cd)"

# Oh my zsh
# Path to your oh-my-zsh installation.
# TODO: Find ways to replace oh-my-zsh plugins (To slow, adds 60ms of start up delay)
export ZSH="$HOME/.oh-my-zsh"
plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
)
DISABLE_AUTO_UPDATE="true"
source $ZSH/oh-my-zsh.sh

# Starship
eval "$(starship init zsh)"

# Aliases
source ~/.aliases

# Fzf key bindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh