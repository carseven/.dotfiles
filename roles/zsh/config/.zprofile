if [[ -d "/usr/local/go/bin" ]]; then
    export PATH=$PATH:/usr/local/go/bin
  else 
    echo "Go is not installed!"
fi
