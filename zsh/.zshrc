# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"
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

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="sorin"

plugins=(
    # zsh-autosuggestions TODO: Se ha deactivado para evitar con las sugerencias de fig. Volver a habilitar cuando este el bug correguido
    zsh-syntax-highlighting
    history
    extract
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

# Aliases
source ~/.aliases

# Fzf key bindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"
