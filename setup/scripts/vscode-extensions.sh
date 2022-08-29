echo "Installing vscode extensions..."
# Generate file with id of vscode installed extensions
# code --list-extensions > ~/.dotfiles/.vscode-extensions 

echo "CD ~/.dotfiles ..."
cd ~/.dotfiles

filename=".vscode-extensions"
n=1
while read line; do
# reading each line
echo "Installing. $n : $line"
code --install-extension $line > /dev/null 2>&1
n=$((n+1))
done < $filename