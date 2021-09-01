echo "Installing vscode extensions..."
# Generate file with id of vscode installed extensions
# code --list-extensions > .vscode-extensions 
file=".vscode-extensions"
lines=`cat $file`
for line in $lines; do
        echo "$line"
done
for plugin in ${lines}; do
  code --install-extension ${plugin}
done