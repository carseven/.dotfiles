# Stow creates symlinks of files inside a folder.
# By default, creates the symlinks to ../ from the dir stow is exceuted

# Before

# PARENT DIR
#     ├── aliases
#     ├── EXECUTION DIR
#     │   └── DIR TO STOW
#     |       └──  starship.toml

# After 
# PARENT DIR
#     ├── aliases
#     ├── starship.toml -> .EXECUTION DIR/.starship.toml
#     ├── EXECUTION DIR
#     │   └── DIR TO STOW
#     |       └──  starship.toml

# Stow genera problemas cuando los archivos ya existen en el directorio padre
# una buena idea para evitar este problema es usar el flag --adopt o directamente
# borrar estos ficheros. 


# Test 
# stow -n DIR

# Move files from example directory and generate symlinks
# stow -vSt ~ example

# Unlink
# stow -vDt ~ example

# Manually stow dir
#stow -nvSt ~ alfred alt-tab git iterm qmk rectangle vscode zsh

# Sto
# stow --adopt -vSt ~ example

cd ~/.dotfiles
if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="git,iterm,karabiner,qmk,raycast,vscode,zsh"
fi

for dir in $(echo $STOW_FOLDERS | sed "s/,/ /g") ; do
    if [ -d ${dir} ]; then
        echo "Stowing $dir..."
        stow -vSt ~ $dir
    fi    
done
