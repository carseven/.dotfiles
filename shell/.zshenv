# Path

# Fix ghostty command error: "tmux command not found"
# https://github.com/ghostty-org/ghostty/discussions/7327
# For some reason the ghostty command is not able to find the tmux command
# even though it is in the PATH. This is a workaround to fix the issue.
# Check the zsh execution order for more details: https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout

# Explanation of zsh execution order:

source  ~/.path-functions-utils # Load addToPathFront functions
addToPathFront $HOME/go/bin
# Keep this as an early fallback; final PATH precedence is enforced in .zprofile.
if [[ "$OSTYPE" == darwin* ]]; then
	addToPathFront /opt/homebrew/bin
fi
addToPathFront $HOME/.local/bin