# Check if Homebrew's bin exists and if it's not already in the PATH
if [ -x "/opt/homebrew/bin/brew" ] && [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

NVIM_DIR="$HOME/.config/nvim"

if [ -d "$NVIM_DIR" ]; then
  echo "Config directory for Neovim already exists"
else
  mkdir -p "$NVIM_DIR"
  ln -sf "${HOME}/dotfiles/nvim" "$NVIM_DIR"
  echo "nvim config linked to $NVIM_DIR"
fi
