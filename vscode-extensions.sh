echo "Installing vscode extensions..."
# Generate file with id of vscode installed extensions
# code --list-extensions > .vscode-extensions 

echo "CD ~/.dotfiles ..."
cd ~/.dotfiles

file=".vscode-extensions"
lines=`cat $file`
for plugin in ${lines}; do
  code --install-extension ${plugin}
done