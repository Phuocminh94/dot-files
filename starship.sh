
# Check if Homebrew's bin exists and if it's not already in the PATH
if [ -x "/opt/homebrew/bin/brew" ] && [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Define the path for starship settings on macOS
STARSHIP_PATH="${HOME}/.config/starship.toml"

if [ -f "$STARSHIP_PATH" ]; then
  echo "starship.toml already exists"
else
  ln -sf "${HOME}/dotfiles/settings/starship.toml" "$STARSHIP_PATH"
  echo "starship.toml linked to $STARSHIP_PATH"
fi
