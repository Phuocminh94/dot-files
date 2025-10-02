# Development Environment Setup

This repository contains scripts and configuration files for setting up a
development environment on **macOS** (with partial Linux support planned).  
It’s designed for my own workflow: clean, minimal, and efficient — with all
common tools automated.

---

## ⚠️ Important Disclaimer

These scripts are **highly opinionated** and tailored to **my personal setup**.  
If you choose to run them:

- They will **modify your system**, including shell configs, default shell, Dock
  layout, and app installations.
- Some changes may be **irreversible** without reinstalling your OS.
- Backups are created **once per run** with timestamps, but repeated runs may
  overwrite configs.
- Review the scripts before running them to fully understand the changes.

If you like this setup, I recommend **forking** the repo and customizing it for
your needs rather than running my scripts unmodified.

Proceed at your own risk.

---

## Overview

The setup is split into modular scripts so you can run only what you need:

- **Symlinks:** Links dotfiles (`.zshrc`, `.bashrc`, etc.) into `$HOME`
- **macOS config:** Finder, Dock, Hot Corners, wallpaper, etc.
- **Homebrew:** Installs brew, formulas, casks, and fonts
- **VS Code:** Installs extensions + links custom settings/keybindings
- **Starship:** Links `starship.toml` config
- **Neovim:** Links config from `dotfiles/nvim` to `~/.config/nvim`
- **Dock:** Clears and rebuilds Dock layout with my apps/folders

Most scripts support a **`--dry-run`** mode so you can preview changes before applying.

---

## Prerequisites

- macOS (tested on Apple Silicon)
- [Xcode Command Line Tools](https://developer.apple.com/download/all/)  
  (`xcode-select --install`)

Linux users: some scripts may work (e.g. symlinks, starship, neovim), but
Homebrew and macOS-specific scripts will be skipped.

---

## Installation

1. Clone the repository into your home directory:

   ```sh
   git clone https://github.com/Phuocminh94/dot-files.git ~/dotfiles
   cd ~/dotfiles
   ```

2.	Ensure scripts are executable:

    ```sh
    chmod +x *.sh
    ```

3.	Run the bootstrap installer:
    ```sh
    ./bootstrap.zsh
    ```

This will:

- Symlink dotfiles into your home directory

- Run each setup script in sequence:

    - macOS.sh

	- brew.sh

	- vscode.sh

	- starship.sh

	- neovim.sh

	- dock.sh

## Configuration Files

- `.zshrc / .bashrc` – Shell startup files
- `.bash_profile / .zprofile` – Environment variables
- `.aliases` – Command shortcuts (personalized)
- `.shared_prompt` – Shared prompt style
- `.bash_prompt / .zprompt` – Prompt configs
- settings/ – Editor/terminal configs:
	- VS Code settings & keybindings
	- Starship prompt config
	- iTerm2 and Rectangle JSON profiles

## Post-Install Manual Steps

Some (macOS) apps require manual setup:

- Import `iTerm2` profile: `~/dotfiles/settings/iTerm2.json

- Import `Rectangle` config: `~/dotfiles/settings/RectangleConfig.json'

- Sign in to: Chrome, Google Drive

- Configure Macs Fan Control manually

## Contributing

Pull requests are not expected, since this repo is for my personal setup.
However, I welcome corrections to obvious errors or portability improvements. 
