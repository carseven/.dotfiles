if [[ -d "/usr/local/go/bin" ]]; then
    export PATH=$PATH:/usr/local/go/bin
  else 
    echo "Go is not installed!"
fi

# Only need for manual installation (Ubuntu)
if [[ -d "$HOME/.tfenv/bin" ]]; then
    export PATH="$HOME/.tfenv/bin:$PATH"
fi