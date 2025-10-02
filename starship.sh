#!/usr/bin/env zsh
# ==============================================================================
# Starship setup (symlink config into ~/.config/starship.toml)
# Usage:
#   ./starship-setup.zsh [--dry-run]
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

# ------------------------------ PATH for brew --------------------------------
# Add Homebrew (macOS ARM or Linuxbrew) to PATH if needed
for brewpath in /opt/homebrew/bin /home/linuxbrew/.linuxbrew/bin; do
  if [[ -x "$brewpath/brew" && ":$PATH:" != *":$brewpath:"* ]]; then
    export PATH="$brewpath:$PATH"
  fi
done

# ------------------------------ starship config ------------------------------
CONFIG_DIR="${HOME}/.config"
TARGET="${CONFIG_DIR}/starship.toml"
SOURCE="${HOME}/dotfiles/settings/starship.toml"

# Ensure ~/.config exists
[[ -d "$CONFIG_DIR" ]] || run "mkdir -p \"$CONFIG_DIR\""

if [[ -f "$TARGET" || -L "$TARGET" ]]; then
  if cmp -s "$SOURCE" "$TARGET"; then
    log "starship.toml already linked correctly."
  else
    TS="$(date +%Y%m%d-%H%M%S)"
    BACKUP="${TARGET}.backup-${TS}"
    log "Backing up existing starship.toml -> $BACKUP"
    run "mv -f \"$TARGET\" \"$BACKUP\""
    log "Linking $SOURCE -> $TARGET"
    run "ln -sfn \"$SOURCE\" \"$TARGET\""
  fi
else
  log "Linking $SOURCE -> $TARGET"
  run "ln -sfn \"$SOURCE\" \"$TARGET\""
fi

if $DRY_RUN; then
  warn "Dry-run mode: no changes were actually made."
else
  log "starship.toml setup complete!"
fi
