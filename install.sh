#!/usr/bin/env zsh
# ==============================================================================
# Dotfiles bootstrap:
#   - Symlinks dotfiles from ~/dotfiles → $HOME
#   - Runs setup scripts: macOS, brew, VS Code, starship, Neovim, Dock
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

# ------------------------------ config ---------------------------------------
DOTFILES_DIR="${HOME}/dotfiles"
FILES=( zshrc zprofile bashrc bash_profile aliases hushlogin )
SCRIPTS=( macOS.sh brew.sh vscode.sh starship.sh neovim.sh dock.sh )

# ------------------------------ symlinks -------------------------------------
log "Changing to ${DOTFILES_DIR}"
cd "${DOTFILES_DIR}" || { warn "dotfiles directory not found"; exit 1; }

for file in "${FILES[@]}"; do
  src="${DOTFILES_DIR}/.${file}"
  dst="${HOME}/.${file}"

  if [[ ! -e "$src" ]]; then
    warn "Source missing: $src (skipping)"
    continue
  fi

  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    log "Symlink already correct: $dst"
  else
    if [[ -e "$dst" ]]; then
      TS="$(date +%Y%m%d-%H%M%S)"
      backup="${dst}.backup-${TS}"
      log "Backing up $dst → $backup"
      run "mv \"$dst\" \"$backup\""
    fi
    log "Linking $src → $dst"
    run "ln -sfn \"$src\" \"$dst\""
  fi
done

# ------------------------------ run scripts ----------------------------------
for script in "${SCRIPTS[@]}"; do
  if [[ -x "$DOTFILES_DIR/$script" ]]; then
    log "Running $script"
    $DRY_RUN && echo "[dry-run] $DOTFILES_DIR/$script" || "$DOTFILES_DIR/$script"
  else
    warn "Script not found or not executable: $script"
  fi
done

log "Installation complete!"
$DRY_RUN && warn "This was a dry run; no changes were applied."
