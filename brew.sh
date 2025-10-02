#!/usr/bin/env zsh
# ==============================================================================
# Bootstrap: Homebrew + packages + casks + fonts + Git setup
# Usage:
#   ./brew-bootstrap.zsh [--dry-run]
# ==============================================================================

set -euo pipefail

# ------------------------------ flags & helpers ------------------------------
DRY_RUN=false
while (( $# )); do
  case "$1" in
    --dry-run|-n) DRY_RUN=true ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

run() { $DRY_RUN && echo "[dry-run] $*" || eval "$*"; }
log(){ print -P "%F{cyan}==>%f $*"; }
warn(){ print -P "%F{yellow}WARN:%f $*"; }

# ------------------------------ Homebrew setup -------------------------------
if ! command -v brew &>/dev/null; then
  log "Homebrew not installed. Installing…"
  run '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

  # Add to PATH (Apple Silicon or Linuxbrew)
  for brewpath in /opt/homebrew/bin /home/linuxbrew/.linuxbrew/bin; do
    if [[ -x "$brewpath/brew" && ":$PATH:" != *":$brewpath:"* ]]; then
      log "Adding $brewpath to PATH"
      export PATH="$brewpath:$PATH"
    fi
  done
else
  log "Homebrew already installed."
fi

if ! command -v brew &>/dev/null; then
  warn "Failed to configure Homebrew in PATH. Please add it manually."
  exit 1
fi

# ------------------------------ update Homebrew ------------------------------
run "brew update"
run "brew upgrade"
run "brew upgrade --cask"
run "brew cleanup"

# ------------------------------ install helpers ------------------------------
install_package() {
  local pkg="$1"
  if brew list --versions "$pkg" &>/dev/null; then
    log "$pkg already installed (formula)."
  else
    log "Installing package: $pkg"
    run "brew install \"$pkg\""
  fi
}

install_cask() {
  local app="$1"
  if brew list --cask --versions "$app" &>/dev/null; then
    log "$app already installed (cask)."
  else
    log "Installing cask: $app"
    run "brew install --cask \"$app\""
  fi
}

install_font() {
  local font="$1"
  brew tap | grep -q "^homebrew/cask-fonts$" || run "brew tap homebrew/cask-fonts"
  if brew list --cask --versions "$font" &>/dev/null; then
    log "Font $font already installed."
  else
    log "Installing font: $font"
    run "brew install --cask \"$font\""
  fi
}

# ------------------------------ formulae -------------------------------------
packages=(
  python
  bash
  zsh
  git
  lazygit
  tree
  node
  neovim
  starship
  ripgrep
  yarn   # for markdown preview in nvim
  # r
)
for p in "${packages[@]}"; do install_package "$p"; done

# ------------------------------ casks ----------------------------------------
apps=(
  google-chrome
  google-drive
  iterm2
  visual-studio-code
  rectangle
  macs-fan-control
  messenger
  # teamviewer
  # anaconda
  # microsoft-office
  # docker
  # rstudio
)
for a in "${apps[@]}"; do install_cask "$a"; done

# ------------------------------ font -----------------------------------------
install_font "font-jetbrains-mono-nerd-font"

# ------------------------------ shell setup ----------------------------------
log "Setting default shell to Homebrew zsh"
run "echo \"$(brew --prefix)/bin/zsh\" | sudo tee -a /etc/shells >/dev/null"
run "chsh -s \"$(brew --prefix)/bin/zsh\""

# ------------------------------ Git config -----------------------------------
if git config --global user.name &>/dev/null && git config --global user.email &>/dev/null; then
  log "Git global config already set."
else
  echo "Enter FULL NAME for Git:"
  read git_user_name
  echo "Enter EMAIL for Git:"
  read git_user_email
  run "$(brew --prefix)/bin/git config --global user.name \"$git_user_name\""
  run "$(brew --prefix)/bin/git config --global user.email \"$git_user_email\""
fi

# ------------------------------ npm global -----------------------------------
log "Installing Prettier globally via npm"
run "$(brew --prefix)/bin/npm install --global prettier"

# ------------------------------ post-install prompts -------------------------
cat <<EOF

Manual steps:
1. Import iTerm2 profile from: ${HOME}/dotfiles/settings/iterm2.json
2. Sign in to Google Chrome & Google Drive
3. Sign in to Messenger
4. Open Rectangle → grant permissions → import: ~/dotfiles/settings/RectangleConfig.json
5. Open Macs Fan Control and configure manually

EOF

read -k 1 -s -r "?Press any key to finish setup…"
log "Bootstrap complete!"
