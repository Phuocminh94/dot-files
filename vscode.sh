#!/usr/bin/env zsh
# ==============================================================================
# VS Code bootstrap: extensions + settings/keybindings (macOS & Linux)
# Usage:
#   ./vscode-setup.zsh [--dry-run] [--no-open]
# ==============================================================================

set -euo pipefail

# ------------------------------ flags & helpers ------------------------------
DRY_RUN=false
OPEN_VSCODE=true
while (( $# )); do
  case "$1" in
    --dry-run|-n) DRY_RUN=true ;;
    --no-open)    OPEN_VSCODE=false ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
  shift
done

OS="$(uname -s)"
run() { $DRY_RUN && echo "[dry-run] $*" || eval "$*"; }
log(){ print -P "%F{cyan}==>%f $*"; }
warn(){ print -P "%F{yellow}WARN:%f $*"; }
err(){ print -P "%F{red}ERROR:%f $*" >&2; }

# Resolve script directory (for relative settings files)
SCRIPT_DIR="${0:A:h}"

# ----------------------- ensure PATH / detect environments --------------------
# Homebrew (macOS Apple Silicon) and Linuxbrew optional PATH injection
if [[ -x "/opt/homebrew/bin/brew" && ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi
if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" && ":$PATH:" != *":/home/linuxbrew/.linuxbrew/bin:"* ]]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi

# VS Code CLI must exist
if ! command -v code >/dev/null 2>&1; then
  err "VS Code 'code' CLI not found."
  if [[ "$OS" == "Darwin" ]]; then
    echo "Tip: In VS Code, run: Command Palette → 'Shell Command: Install 'code' command in PATH'."
  else
    echo "Install VS Code and ensure 'code' is on PATH."
  fi
  exit 1
fi

# ---------------------- determine settings directory -------------------------
case "$OS" in
  Darwin)
    VSCODE_USER_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
    ;;
  Linux)
    # Standard path for VS Code (not Insiders)
    VSCODE_USER_SETTINGS_DIR="$HOME/.config/Code/User"
    ;;
  *)
    err "Unsupported OS: $OS"
    exit 1
    ;;
esac

# ----------------------------- extensions list --------------------------------
extensions=(
  ms-python.python
  ms-python.pylint
  ms-python.vscode-pylance
  ms-python.debugpy
  ms-toolsai.jupyter
  ms-python.black-formatter
  darianmorat.darian-theme
  CamilaMartinezBedoya.pro-hacker-theme
  vscodevim.vim
  miguelsolorio.fluent-icons
  naumovs.color-highlight
  formulahendry.code-runner
  esbenp.prettier-vscode
  albert.TabOut
)

# ------------------------------ install extensions ---------------------------
log "Installing VS Code extensions…"
installed_extensions="$(code --list-extensions || true)"

for ext in "${extensions[@]}"; do
  if print -r -- "$installed_extensions" | grep -qiE "^${ext}\$"; then
    log "$ext already installed (skipping)"
  else
    log "Installing $ext"
    run "code --install-extension \"$ext\""
  fi
done
log "Extension installation step complete."

# ------------------------------ settings linking ------------------------------
log "Configuring settings in: $VSCODE_USER_SETTINGS_DIR"
if [[ ! -d "$VSCODE_USER_SETTINGS_DIR" ]]; then
  warn "VS Code user settings directory does not exist. Creating it."
  run "mkdir -p \"$VSCODE_USER_SETTINGS_DIR\""
fi

# source files (relative to repo/script)
SRC_SETTINGS="${SCRIPT_DIR}/settings/VSCode-Settings.json"
SRC_KEYS="${SCRIPT_DIR}/settings/VSCode-Keybindings.json"

if [[ ! -f "$SRC_SETTINGS" ]]; then
  warn "Missing: $SRC_SETTINGS (settings not linked)"
else
  TS="$(date +%Y%m%d-%H%M%S)"
  if [[ -f "${VSCODE_USER_SETTINGS_DIR}/settings.json" || -L "${VSCODE_USER_SETTINGS_DIR}/settings.json" ]]; then
    log "Backing up existing settings.json -> settings.json.backup-${TS}"
    run "cp -f \"${VSCODE_USER_SETTINGS_DIR}/settings.json\" \"${VSCODE_USER_SETTINGS_DIR}/settings.json.backup-${TS}\" || true"
  fi
  log "Linking settings.json -> $SRC_SETTINGS"
  run "ln -sfn \"$SRC_SETTINGS\" \"${VSCODE_USER_SETTINGS_DIR}/settings.json\""
fi

if [[ ! -f "$SRC_KEYS" ]]; then
  warn "Missing: $SRC_KEYS (keybindings not linked)"
else
  TS="$(date +%Y%m%d-%H%M%S)"
  if [[ -f "${VSCODE_USER_SETTINGS_DIR}/keybindings.json" || -L "${VSCODE_USER_SETTINGS_DIR}/keybindings.json" ]]; then
    log "Backing up existing keybindings.json -> keybindings.json.backup-${TS}"
    run "cp -f \"${VSCODE_USER_SETTINGS_DIR}/keybindings.json\" \"${VSCODE_USER_SETTINGS_DIR}/keybindings.json.backup-${TS}\" || true"
  fi
  log "Linking keybindings.json -> $SRC_KEYS"
  run "ln -sfn \"$SRC_KEYS\" \"${VSCODE_USER_SETTINGS_DIR}/keybindings.json\""
fi

# ------------------------------ finalization ----------------------------------
if $OPEN_VSCODE; then
  log "Opening VS Code…"
  run "code ."
fi

if $DRY_RUN; then
  warn "Dry-run mode: no changes were actually made."
else
  log "VS Code setup completed."
fi
