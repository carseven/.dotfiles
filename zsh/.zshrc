# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"

# Add go install binaries to PATH
export PATH="$HOME/go/bin:$PATH"

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"

# Use homebrew installed git and zsh
# /opt/homebrew/pot/git
source $(brew --prefix git)
source $(brew --prefix zsh)

# Nvm
source $(brew --prefix nvm)/nvm.sh

# Oh my zsh
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    zsh-autosuggestions
    zsh-syntax-highlighting
    history
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

# Aliases
source ~/.aliases

# Fzf key bindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
