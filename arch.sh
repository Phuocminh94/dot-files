#!/bin/zsh

# ----- Safety options ----
set -e      # exit if a command fails
set -u      # exit if an unset variable is used

echo "🔄 Updating system..."
sudo pacman -Syu --noconfirm

# ----- Package groups -----
core_pkgs=(
  base-devel     # build tools
  git curl wget  # version control + download tools
  xclip wl-clipboard # clipboard support (X11 + Wayland)
)

kde_pkgs=(
  plasma-desktop plasma-workspace   # KDE Plasma environment
  sddm                              # login manager
  dolphin konsole spectacle kate kcalc # file manager, terminal, screenshot, editor, calculator
  plasma-pa                         # volume control + OSD
  pipewire pipewire-pulse wireplumber pavucontrol # audio stack + mixer
  bluez bluez-utils                 # bluetooth core + CLI tools
  bluez-qt bluedevil kdeconnect     # KDE Bluetooth support (Qt bindings + tray/applet + phone integration)
  networkmanager plasma-nm          # network management daemon + KDE applet
  kio-gdrive                        # google drive client
)

util_pkgs=(
  htop tree        # system + directory tools
  tmux             # terminal multiplexer
  openbsd-netcat
  starship
  ripgrep
)

lang_pkgs=(
    r
    )

install_group() {
    local group_name=$1
    shift
    local packages=($@)
    echo "📦 Installing $group_name..."
    sudo pacman -S --needed --noconfirm $packages
}

# install_group "Core Packages" $core_pkgs
# install_group "KDE Essentials" $kde_pkgs
install_group "Utilities" $util_pkgs
# install_group "Lang" $lang_pkgs

echo "✅ All done!"
