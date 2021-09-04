echo "Setting ZSH as shell..."
chsh -s ($which zsh)

# Install Zsh & Oh My Zsh
echo "Installing Oh My ZSH..."
curl -L http://install.ohmyz.sh | sh

echo "Setting up Zsh plugins..."
cd ~/.oh-my-zsh/custom/plugins
git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-autosuggestions

# Alternative
# brew install zsh-syntax-highlighting
# To activate the syntax highlighting, add the following at the end of your .zshrc:
#     source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# If you receive "highlighters directory not found" error message,
# you may need to add the following to your .zshenv:
#     export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=$(brew --prefix)/share/zsh-syntax-highlighting/highlighters