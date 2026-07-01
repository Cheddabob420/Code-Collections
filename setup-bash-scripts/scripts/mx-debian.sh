#!/bin/bash

errorMsg() {
        echo "Error Installing Package!"
        exit 1
}

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

# --- 1. Package Installation ---
echo "Installing core tools..."

# Install the basics

sudo apt update && sudo apt dist-upgrade -y
sudo apt install -y micro nano tree cowsay shellcheck starship python3-pip ossp-uuid wget curl gh ssh || errorMsg
sudo apt install fastfetch -y || sudo apt install neofetch -y


# Add bash language server for kate
sudo apt install npm -y || errorMsg
sudo npm install -g bash-language-server || errorMsg

# Add Flatpak Repos
if ! flatpak remotes | grep -q "flathub"; then
    echo "Adding Flathub repository..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    echo "Flathub already configured. Skipping."
fi


# Create some needed directorys
mkdir -v $HOME/Projects
mkdir -v $HOME/Programs
mkdir -v $HOME/Projects/Lua
mkdir -v $HOME/Projects/Python
mkdir -v $HOME/Projects/MicroWorks
mkdir -v $HOME/Projects/HTML
mkdir -v $HOME/Projects/C
mkdir -v $HOME/Projects/Jupyter

# --- 2. Configuration Setup ---
BASHRC="$HOME/.bashrc"
echo "Configuring $BASHRC..."

# Create a backup with a timestamp
cp "$BASHRC" "$BASHRC.bak.$(date +%F_%T)"

# Note: Use 'EOF' to prevent the script from expanding $HOME or $PS1 now
cat << 'EOF' > "$BASHRC"
export EDITOR='nano'
export HISTSIZE=10000
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias h='history'
alias gst='git status'
alias gp='git pull'
alias updater='sudo apt update && sudo apt dist-upgrade -y && flatpak update'
alias autoremove='sudo apt autoremove -y'
alias pyven='source $HOME/.venv/bin/activate'
USER_NAME="$(whoami)"
SHELL_RC="$HOME/.shell_rc_content"
ALIASES="$HOME/.aliases"
[[ -f "$SHELL_RC" ]] && source "$SHELL_RC"
[[ -f "$ALIASES" ]] && source "$ALIASES"
eval "$(starship init bash)"
fastfetch
EOF

# --- 4. Setup Python Environment
cd "$HOME" || exit
python_env="$HOME/.venv"

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
source ~/.bashrc
wait
echo "Bashrc Setup Complete!"
