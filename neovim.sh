#!/usr/bin/env zsh
# ==============================================================================
# Neovim config setup: symlink dotfiles/nvim → ~/.config/nvim
# Usage:
#   ./nvim-setup.zsh [--dry-run]
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

# ----------------------------- ensure Homebrew PATH --------------------------
for brewpath in /opt/homebrew/bin /home/linuxbrew/.linuxbrew/bin; do
  if [[ -x "$brewpath/brew" && ":$PATH:" != *":$brewpath:"* ]]; then
    export PATH="$brewpath:$PATH"
  fi
done

# ----------------------------- Neovim config link ----------------------------
CONFIG_ROOT="${HOME}/.config"
NVIM_DIR="${CONFIG_ROOT}/nvim"
SOURCE="${HOME}/dotfiles/nvim"

# Ensure ~/.config exists
[[ -d "$CONFIG_ROOT" ]] || run "mkdir -p \"$CONFIG_ROOT\""

if [[ -d "$NVIM_DIR" || -L "$NVIM_DIR" ]]; then
  if [[ "$(readlink "$NVIM_DIR" 2>/dev/null)" == "$SOURCE" ]]; then
    log "Neovim config already linked correctly → $NVIM_DIR"
  else
    TS="$(date +%Y%m%d-%H%M%S)"
    BACKUP="${NVIM_DIR}.backup-${TS}"
    log "Backing up existing nvim config to $BACKUP"
    run "mv \"$NVIM_DIR\" \"$BACKUP\""
    log "Linking $SOURCE → $NVIM_DIR"
    run "ln -sfn \"$SOURCE\" \"$NVIM_DIR\""
  fi
else
  log "Linking $SOURCE → $NVIM_DIR"
  run "ln -sfn \"$SOURCE\" \"$NVIM_DIR\""
fi

if $DRY_RUN; then
  warn "Dry-run mode: no changes were actually made."
else
  log "Neovim config setup complete!"
fi
