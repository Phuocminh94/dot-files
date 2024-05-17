
# Check if Homebrew's bin exists and if it's not already in the PATH
if [ -x "/opt/homebrew/bin/brew" ] && [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi

# Define the path for starship settings on macOS
STARSHIP_PATH="${HOME}/.config/"

if [ -f "$STARSHIP_PATH" ]; then
  echo "starship.toml already exists"
else
  cp "${HOME}/dotfiles/settings/starship.toml" "$STARSHIP_PATH"
  echo "starship.toml copied to $STARSHIP_PATH"
fi
