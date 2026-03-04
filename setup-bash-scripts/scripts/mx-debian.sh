#!/bin/bash

# --- 1. Package Installation ---
echo "Installing core tools..."

# Install the basics

sudo apt update && sudo apt dist-upgrade -y
sudo apt install -y fastfetch git nano wget curl tree gh gpg apt-transport-https cowsay ssh shellcheck

# Add bash language server for kate
sudo apt install npm -y
sudo npm install -g bash-language-server

# Add Flatpak Repos
if ! flatpak remotes | grep -q "flathub"; then
    echo "Adding Flathub repository..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    echo "Flathub already configured. Skipping."
fi

# Installing nerd font
# 1. Define variables
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/ProFont.zip"
FONT_DIR="$HOME/.local/share/fonts/ProFont"
TEMP_DIR=$(mktemp -d)

echo "Downloading and installing ProFont Nerd Font..."

# 2. Create the font directory if it doesn't exist
mkdir -p "$FONT_DIR"

# 3. Download the zip to the temporary directory
wget -O "$TEMP_DIR/ProFont.zip" "$FONT_URL"

# 4. Unzip only the font files (.ttf and .otf) into the font folder
unzip "$TEMP_DIR/ProFont.zip" -d "$TEMP_DIR"
mv "$TEMP_DIR"/*.{ttf,otf} "$FONT_DIR/" 2>/dev/null

# 5. Update the system font cache
fc-cache -fv

# 6. Cleanup: Remove the temporary directory and all its contents
rm -rf "$TEMP_DIR"

# --- 2. Configuration Setup ---
BASHRC="$HOME/.bashrc"
echo "Configuring $BASHRC..."

# Create a backup with a timestamp
cp "$BASHRC" "$BASHRC.bak.$(date +%F_%T)"

# Create some needed directorys
mkdir -v $HOME/Projects
mkdir -v $HOME/Programs
mkdir -v $HOME/Projects/Lua
mkdir -v $HOME/Projects/Python
mkdir -v $HOME/Projects/MicroWorks
mkdir -v $HOME/Projects/HTML

# Note: Use 'EOF' to prevent the script from expanding $HOME or $PS1 now
cat << 'EOF' > "$BASHRC"
# ~/.bashrc - Custom Environment

# UI/UX Improvements
export EDITOR='nano'
export HISTSIZE=10000
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Navigation Shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias h='history'

# Git Shortcuts
alias gst='git status'
alias gp='git pull'

# Update command alias
alias updater='sudo apt update && sudo apt dist-upgrade -y && flatpak update'
alias autoremove='sudo apt autoremove -y'

# Python aliases
alias pip='$HOME/.venv/bin/pip'
alias python='$HOME/.venv/bin/python3'
alias python3='$HOME/.venv/bin/python3'
alias pyven='source $HOME/.venv/bin/activate'

### Detect Linux Distro ###
if command -v grep &> /dev/null && [ -f /etc/os-release ]; then
    distro_id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d'"')
else
    distro_id="unknown"
fi

### Set Distro Icon ###
case "$distro_id" in
  kali) DISTRO_ICON="<U+F327>" ;;   # Kali Linux
  arch*) DISTRO_ICON="<U+E732>" ;;   # Arch Linux
  ubuntu) DISTRO_ICON="<U+F31B>" ;; # Ubuntu
  debian) DISTRO_ICON="<U+F306>" ;; # Debian
  fedora) DISTRO_ICON="<U+F30A>" ;; # Fedora
  alpine) DISTRO_ICON="<U+F300>" ;; # Alpine
  void) DISTRO_ICON="<U+F32E>" ;;   # Void Linux
  opensuse*|sles) DISTRO_ICON="<U+F314>" ;; # openSUSE
  gentoo) DISTRO_ICON="<U+F30D>" ;; # Gentoo
  nixos) DISTRO_ICON="<U+F313>" ;; # NixOS
  linuxmint) DISTRO_ICON="<U+F17C>" ;;  # Mint
  *) DISTRO_ICON=" " ;;                
esac

### Username & Path Logic ###

USER_NAME="$(whoami)"
# Desktop/Standard Linux paths
SHELL_RC="$HOME/.shell_rc_content"
ALIASES="$HOME/.aliases"

### Build PS1 with proper escaping ###
PS1='\[\e[1;32m\]╭─\[\e[1;34m\][\[\e[1;36m\]'"${USER_NAME}"'\[\e[1;33m\] '"${DISTRO_ICON}"' \[\e[1;36m\]\h\[\e[1;34m\]] [\[\e[1;33m\]\w\[\e[1;34m\]]\[\e[0m\]
\[\e[1;32m\]╰─❯\[\e[0m\] '

### Source Configs ###
[[ -f "$SHELL_RC" ]] && source "$SHELL_RC"
[[ -f "$ALIASES" ]] && source "$ALIASES"


# Add fastfetch to the bottom for the sys info art
fastfetch
EOF

# --- 3. Finalization ---
echo "Success! Your environment is ready."

# --- 4. Setup Python Environment
cd "$HOME" || exit
python_env="$HOME/.venv"

create_venv() {
    echo "Creating python environment at $python_env..."
    
    # Try creating the venv
    if ! python3 -m venv "$python_env" 2>/dev/null; then
        echo "venv module missing. Attempting to install the required system package..."
        
        # 1. Get the version (e.g., "3.11")
        PY_VER=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
        VENV_PKG="python${PY_VER}-venv"
        
        # 2. Attempt to install the specific package
        echo "Running: sudo apt update && sudo apt install -y $VENV_PKG"
        if sudo apt update && sudo apt install -y "$VENV_PKG"; then
            # 3. Retry the venv creation
            python3 -m venv "$python_env"
        else
            echo "Error: Failed to install $VENV_PKG. Please install it manually."
            exit 1
        fi
    fi
}

if [[ -d "$python_env" ]]; then
    echo "Python environment exists at $python_env"
    read -rp "Would you like to reinstall it? (y/n): " yn
    case $yn in
        [Yy]* ) 
            echo "Proceeding with the installation..."
            rm -Rf "$python_env"
            create_venv
            ;;
        [Nn]* ) 
            echo "Operation canceled by user."
            ;;
    esac
else
    create_venv
fi
# Install VS Code

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

rm -f packages.microsoft.gpg
sudo apt update
sudo apt install -y code

echo "VS Code installation complete! Run it by typing 'code' in your terminal."

wait

# Install Google Chrome/Remove Firefox

# 1. Create a secure temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit

echo "--- Starting Google Chrome Installation ---"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt update && sudo apt install ./google-chrome-stable_current_amd64.deb -y

# 2. Set Chrome as the Default Browser
echo "--- Setting Google Chrome as Default ---"
# Sets the default for the XDG system (Desktop environments)
xdg-settings set default-web-browser google-chrome.desktop
# Sets the symbolic link for the 'x-www-browser' command
sudo update-alternatives --set x-www-browser /usr/bin/google-chrome-stable

# 3. Purge Firefox and Mozilla artifacts
echo "--- Removing Firefox and Mozilla leftovers ---"

# Remove Snap version (Common in Ubuntu)
if snap list | grep -q firefox; then
    sudo snap remove firefox
fi

# Remove APT version (Common in Debian/Mint)
sudo apt purge firefox-esr firefox -y

# Deep clean local configuration folders
rm -rf ~/.mozilla
rm -rf ~/.cache/mozilla
sudo rm -rf /usr/lib/firefox
sudo rm -rf /etc/firefox

# 4. Cleanup temp files
cd ~
rm -rf "$TEMP_DIR"

echo "--- Migration Complete! Google Chrome is now your default. ---"
google-chrome --version

# Setup chrome before gh auth
echo "Please open chrome and sign in before going any further to make github auth much easier."
read -n 1 -s -p "Press any key to continue..."
echo ""
# Configure Github
gh auth login

echo "Bashrc Setup Complete!"




#           ---Cowsay random cow headder---
#date +"%I:%M %P | %A, %B %d, %Y" | cowsay -f dragon-and-cow
# 1. Get the list of cows
# 2. Use 'grep -v' to remove the header line
# 3. Use 'xargs' to turn the grid into a single column (removes extra spaces)
# 4. Use 'shuf' to pick one
#RANDOM_COW=$(cowsay -l | grep -v "Cow files in" | xargs -n 1 | shuf -n 1)

# Only run cowsay if RANDOM_COW is not empty to avoid errors
#if [ -n "$RANDOM_COW" ]; then
#    date +"%I:%M %P | %A, %B %d, %Y" | cowsay -f "$RANDOM_COW"
#fi
