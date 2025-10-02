#!/usr/bin/env zsh
# ==============================================================================
# macos — one-stop macOS setup (Finder, Dock, hot corners, desktop wallpaper)
# Usage: ./macos [--dry-run|-n]
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

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
run() { $DRY_RUN && echo "[dry-run] $*" || eval "$*"; }
log() { print -P "%F{cyan}==>%f $*"; }
warn() { print -P "%F{yellow}WARN:%f $*"; }
err() { print -P "%F{red}ERROR:%f $*" >&2; }

if ! is_macos; then
  err "This script is for macOS only."
  exit 1
fi

# ------------------------------- configuration -------------------------------
# Desktop wallpaper image (adjust if needed)
IMAGE_PATH="${HOME}/dotfiles/settings/Desktop.png"

# Dock apps and folders you want pinned (edit these to taste)
typeset -a DOCK_APPS=(
  '/System/Applications/Music.app'
  '/Applications/Google Chrome.app'
  '/System/Applications/Mail.app'
  '/Applications/Visual Studio Code.app'
  '/Applications/Messenger.app'
  '/System/Applications/Utilities/Activity Monitor.app'
  '/Applications/iTerm.app'
  '/System/Applications/System Settings.app'
)

typeset -a DOCK_FOLDERS=(
  "${HOME}/Downloads"
)

# ----------------------------- system preferences ----------------------------
setup_hot_corners() {
  # Bottom-left -> Launchpad (11); modifier 0 = none
  log "Configuring Hot Corners (bottom-left -> Launchpad)…"
  run "defaults write com.apple.dock wvous-bl-corner -int 11"
  run "defaults write com.apple.dock wvous-bl-modifier -int 0"
}

setup_finder() {
  log "Configuring Finder preferences…"
  # Allow Finder quit (Cmd+Q) => hides desktop icons
  run "defaults write com.apple.finder QuitMenuItem -bool true"
  # Show ~/Library
  run "chflags nohidden ~/Library"
  # New windows open to Desktop
  run "defaults write com.apple.finder NewWindowTarget -string PfDe"
  run "defaults write com.apple.finder NewWindowTargetPath -string 'file://${HOME}/Desktop/'"
  # Status & path bar
  run "defaults write com.apple.finder ShowStatusBar -bool true"
  run "defaults write com.apple.finder ShowPathbar -bool true"
  # Disable warn on empty trash
  run 'defaults write com.apple.finder WarnOnEmptyTrash -bool false'
  # Default list view
  run 'defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"'
}

setup_terminal_iterm() {
  log "Configuring Terminal/iTerm & Activity Monitor…"
  # Activity Monitor dock icon: 4 = CPU
  run "defaults write com.apple.ActivityMonitor IconType -int 4"
  # iTerm2: no quit prompt
  run "defaults write com.googlecode.iterm2 PromptOnQuit -bool false"
  # Global window-drag gesture (Ctrl+Cmd drag)
  run "defaults write -g NSWindowShouldDragOnGesture -bool true"
}

install_clt_prompt() {
  log "Ensuring Xcode Command Line Tools…"
  if xcode-select -p >/dev/null 2>&1; then
    log "Xcode Command Line Tools already installed."
    return
  fi
  run "xcode-select --install" || true
  echo
  echo "Complete the installation of Xcode Command Line Tools before proceeding."
  echo "Press Enter to continue..."
  $DRY_RUN || read -r _
}

set_scroll_direction() {
  log "Setting scroll direction to traditional (not natural)…"
  run "defaults write -g com.apple.swipescrolldirection -bool NO"
}

set_wallpaper() {
  if [[ ! -f "$IMAGE_PATH" ]]; then
    warn "Wallpaper not found: $IMAGE_PATH (skipping)"
    return
  fi
  if ! command -v osascript >/dev/null; then
    warn "osascript not found; skipping wallpaper."
    return
  fi
  log "Setting desktop wallpaper for all spaces…"
  $DRY_RUN && {
    echo "[dry-run] osascript to set picture to '$IMAGE_PATH'"
    return
  }
  /usr/bin/osascript <<EOF
tell application "System Events"
  set desktopCount to count of desktops
  repeat with desktopNumber from 1 to desktopCount
    tell desktop desktopNumber
      set picture to "$IMAGE_PATH"
    end tell
  end repeat
end tell
EOF
}

# ------------------------------ dock functions -------------------------------
dock_add_app() {
  local app="$1"
  if [[ ! -d "$app" ]]; then
    warn "App not found: $app"
    return
  fi
  # Validate the bundle by trying to open (no launch)
  if ! /usr/bin/open -Ra "$app" 2>/dev/null; then
    warn "Cannot register app: $app"
    return
  fi
  log "Adding app to Dock: $app"
  run "defaults write com.apple.dock persistent-apps -array-add \
    '<dict>
       <key>tile-data</key>
       <dict>
         <key>file-data</key>
         <dict>
           <key>_CFURLString</key>
           <string>${app}</string>
           <key>_CFURLStringType</key>
           <integer>0</integer>
         </dict>
       </dict>
     </dict>'"
}

# add_folder_to_dock <folder> [-a n] [-d n] [-v n]
#   -a/--arrangement: 1 Name, 2 Date Added, 3 Date Modified, 4 Date Created, 5 Kind
#   -d/--displayAs: 0 Stack, 1 Folder
#   -v/--showAs:    0 Auto, 1 Fan, 2 Grid, 3 List
dock_add_folder() {
  local folder="$1"; shift || true
  local arrangement=1 displayAs=0 showAs=0

  while (( $# )); do
    case "$1" in
      -a|--arrangement) arrangement="${2:-1}"; shift ;;
      -d|--displayAs)   displayAs="${2:-0}";   shift ;;
      -v|--showAs)      showAs="${2:-0}";      shift ;;
    esac
    shift
  done

  if [[ ! -d "$folder" ]]; then
    warn "Folder not found: $folder"
    return
  fi
  log "Adding folder to Dock: $folder"
  run "defaults write com.apple.dock persistent-others -array-add \
    '<dict>
       <key>tile-data</key>
       <dict>
         <key>arrangement</key><integer>${arrangement}</integer>
         <key>displayas</key><integer>${displayAs}</integer>
         <key>file-data</key>
         <dict>
           <key>_CFURLString</key>
           <string>file://${folder}</string>
           <key>_CFURLStringType</key><integer>15</integer>
         </dict>
         <key>file-type</key><integer>2</integer>
         <key>showas</key><integer>${showAs}</integer>
       </dict>
       <key>tile-type</key><string>directory-tile</string>
     </dict>'"
}

dock_clear_apps()   { log "Clearing Dock apps…";   run "defaults delete com.apple.dock persistent-apps"   || true; }
dock_clear_others() { log "Clearing Dock folders…";run "defaults delete com.apple.dock persistent-others" || true; }
dock_clear_all()    { dock_clear_apps; dock_clear_others; }

dock_show_recents_disable() { log "Disabling recent apps in Dock…"; run "defaults write com.apple.dock show-recents -bool false"; }
dock_show_recents_enable()  { log "Enabling recent apps in Dock…";  run "defaults write com.apple.dock show-recents -bool true"; }

dock_hidden_apps_gray() { log "Making hidden apps appear dimmed in Dock…"; run "defaults write com.apple.dock showhidden -bool true"; }
dock_minimize_to_icon() { log "Minimizing windows into application icon…"; run "defaults write com.apple.dock minimize-to-application -bool true"; }

dock_reload() { log "Reloading Dock…"; run "killall Dock" || true; }
finder_reload() { log "Relaunching Finder…"; run "killall Finder" || true; }

# ---------------------------------- run all ----------------------------------
main() {
  install_clt_prompt
  set_scroll_direction
  setup_hot_corners
  setup_finder
  setup_terminal_iterm
  set_wallpaper

  # Dock layout
  dock_clear_all
  dock_show_recents_disable
  for app in "${DOCK_APPS[@]}"; do dock_add_app "$app"; done
  for folder in "${DOCK_FOLDERS[@]}"; do dock_add_folder "$folder" -a 2 -d 0 -v 2; done
  dock_hidden_apps_gray
  dock_minimize_to_icon

  # Apply changes
  finder_reload
  dock_reload

  log "macOS setup complete!"
  $DRY_RUN && warn "This was a dry run. Re-run without -n to apply changes."
}

main
