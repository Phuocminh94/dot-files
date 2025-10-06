#!/usr/bin/env zsh
# ==============================================================================
# Dotfiles bootstrap (platform-aware):
#   - Symlinks dotfiles from ~/dotfiles → $HOME
#   - Runs setup scripts depending on OS (macOS/Linux)
# Usage:
#   ./bootstrap.zsh [--dry-run]
# ==============================================================================

set -euo pipefail

# ------------------------------ flags & helpers ------------------------------
DRY_RUN=false
while (( $# )); do
  case "$1" in
    -n|--dry-run) DRY_RUN=true ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

run() { $DRY_RUN && echo "[dry-run] $*" || eval "$*"; }
log(){ print -P "%F{cyan}==>%f $*"; }
warn(){ print -P "%F{yellow}WARN:%f $*"; }
err(){ print -P "%F{red}ERROR:%f $*"; exit 1; }

# ------------------------------ OS detection ---------------------------------
OS="$(uname -s)"
IS_MACOS=false
IS_LINUX=false
case "$OS" in
  Darwin) IS_MACOS=true ;;
  Linux)  IS_LINUX=true ;;
  *) warn "Unsupported OS: $OS";;
esac

# ------------------------------ config ---------------------------------------
DOTFILES_DIR="${HOME}/dotfiles"

# Common files to be symlinked on both platforms
COMMON_FILES=( zshrc zprofile bashrc bash_profile aliases hushlogin )

# Add OS-specific files here (optional)
MAC_FILES=( )     # e.g. "yabairc"
LINUX_FILES=( )   # e.g. "xprofile"

# Merge file lists
FILES=( "${COMMON_FILES[@]}" )
$IS_MACOS && FILES+=( "${MAC_FILES[@]}" )
$IS_LINUX && FILES+=( "${LINUX_FILES[@]}" )

# Script sets per platform
COMMON_SCRIPTS=( starship.sh neovim.sh )
MAC_SCRIPTS=( mac.sh brew.sh dock.sh )
LINUX_SCRIPTS=( arch.sh )

SCRIPTS=( "${COMMON_SCRIPTS[@]}" )
$IS_MACOS && SCRIPTS+=( "${MAC_SCRIPTS[@]}" )
$IS_LINUX && SCRIPTS+=( "${LINUX_SCRIPTS[@]}" )

# ------------------------------ sanity checks --------------------------------
[[ -d "$DOTFILES_DIR" ]] || err "Dotfiles directory not found: $DOTFILES_DIR"

# ------------------------------ symlinks -------------------------------------
log "Changing to ${DOTFILES_DIR}"
cd "${DOTFILES_DIR}"

for file in "${FILES[@]}"; do
  src="${DOTFILES_DIR}/.${file}"
  dst="${HOME}/.${file}"

  if [[ ! -e "$src" ]]; then
    warn "Source missing: $src (skipping)"
    continue
  fi

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    log "Symlink already correct: $dst"
    continue
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    TS="$(date +%Y%m%d-%H%M%S)"
    backup="${dst}.backup-${TS}"
    log "Backing up $dst → $backup"
    run "mv \"$dst\" \"$backup\""
  fi

  log "Linking $src → $dst"
  run "ln -sfn \"$src\" \"$dst\""
done

# ------------------------------ run scripts ----------------------------------
for script in "${SCRIPTS[@]}"; do
  path="$DOTFILES_DIR/$script"
  if [[ -x "$path" ]]; then
    log "Running $script"
    $DRY_RUN && echo "[dry-run] $path" || "$path"
  elif [[ -f "$path" ]]; then
    warn "Script not executable: $script (run: chmod +x \"$path\")"
  else
    warn "Script not found: $script"
  fi
done

log "Installation complete!"
$DRY_RUN && warn "This was a dry run; no changes were applied."
