#!/usr/bin/env zsh

source "./dock_functions.sh"

declare -a apps=(
    '/System/Applications/Music.app'
    '/Applications/Google Chrome.app'
    '/System/Applications/Mail.app/'
    '/Applications/Visual Studio Code.app'
    '/Applications/Messenger.app'
    '/System/Applications/Utilities/Activity Monitor.app'
    '/Applications/iTerm.app'
    '/System/Applications/System Settings.app/'
);

declare -a folders=(
    ~/Downloads
);

clear_dock
disable_recent_apps_from_dock

for app in "${apps[@]}"; do
    add_app_to_dock "$app"
done

for folder in "${folders[@]}"; do
    add_folder_to_dock $folder
done

make_hidden_apps_gray
minimize_windows_in_their_icons

killall Dock
