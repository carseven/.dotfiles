# Stow use examples
# The structure inside example dir must be the same as ~
# Adopt local files and generatie symlinks
# stow --adopt -vSt ~ example

# Move files from example directory and generate symlinks
# stow -vSt ~ example

# Unlink
# stow -vDt ~ example
# stow -nvDt ~ example 

# Manually stow dir
#stow -nvSt ~ alfred alt-tab git iterm qmk rectangle vscode zsh

echo "CD ~/.dotfiles ..."
cd ~/.dotfiles

echo "Generate dotfiles symlinks with stow"
# Stow every directory from .dotfiles directory
for d in */ ; do
    echo "Stowing $d..."
    stow -nvSt ~ $d
done
echo "Verify symlinks"
echo "Press [Enter] key after this..."
read
for dir in */ ; do
    if [ -d ${dir} ]; then
        echo "Stowing $dir..."
        stow -nvSt ~ $dir
    fi    
done