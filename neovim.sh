# Check if Homebrew's bin exists and if it's not already in the PATH
if [ -x "/opt/homebrew/bin/brew" ] && [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Define the target directory for Neovim on macOS
NVIM_DIR="$HOME/.config/nvim"

if [ -d "$NVIM_DIR" ]; then
  echo "Config directory for Neovim already exists"
else
  mkdir -p "$NVIM_DIR"
  git clone https://github.com/Phuocminh94/Neovim.git "$NVIM_DIR"
  echo "config copied to $NVIM_DIR"
fi
