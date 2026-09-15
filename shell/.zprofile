source ~/.path-functions-utils

# macOS /etc/zprofile runs path_helper; apply final user PATH precedence here.
if [[ "$OSTYPE" == darwin* ]]; then
  addToPathFront /opt/homebrew/bin
fi

if [[ -d "$HOME/.local/bin" ]]; then
  addToPathFront "$HOME/.local/bin"
fi

if [[ -d "$HOME/go/bin" ]]; then
  addToPathFront "$HOME/go/bin"
fi

if [[ -d "/usr/local/go/bin" ]]; then
  addToPathFront /usr/local/go/bin
fi

# Only need for manual installation (Ubuntu)
if [[ -d "$HOME/.tfenv/bin" ]]; then
  addToPathFront "$HOME/.tfenv/bin"
fi