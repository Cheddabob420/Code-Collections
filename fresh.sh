#!/usr/bin/env bash
set -euo pipefail
############################################
#            Functions                     #
############################################
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME=$NAME
        OS_ID=$ID
    elif type os-release >/dev/null 2>&1; then
        OS_ID=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
        OS_NAME=$(lsb_release -ds)
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        OS_ID=$DISTRIB_ID
        OS_NAME=$DISTRIB_DESCRIPTION
    else
        OS_ID=$(uname -s | tr '[:upper:]' '[:lower:]')
        OS_NAME=$(uname -s)
    fi
    OS_ID=$(echo "$OS_ID" | tr '[:upper:]' '[:lower:]')
}

errorMsg() {
        echo -e "\033[0;31mError Installing Package!\033[0m"
        exit 1
}

create_venv() {
    echo -e "\033[0;32mCreating python environment at $python_env...\033[0m"
    
    # Try creating the venv
    if ! python3 -m venv "$python_env" 2>/dev/null; then
        echo -e "\033[0;33mVenv module missing. Attempting to install the required system package...\033[0m"
        
        # 1. Get the version (e.g., "3.11")
        PY_VER=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
        VENV_PKG="python${PY_VER}-venv"
        
        # 2. Attempt to install the specific package
        echo -e "\033[0;36mRunning: sudo apt update && sudo apt install -y $VENV_PKG\033[0m"
        if sudo apt update && sudo apt install -y "$VENV_PKG"; then
            # 3. Retry the venv creation
            python3 -m venv "$python_env"
        else
            echo -e "\033[0;31mError: Failed to install $VENV_PKG. Please install it manually.\033[0m"
            exit 1
        fi
    fi
}

##############################################
#             Variables                      #
##############################################

CONFIG_DIR="$HOME/.config/nvim/lua/plugins"
KEYMAP_DIR="$HOME/.config/nvim/lua/config"
GHOSTTY_DIR="$HOME/.config/ghostty"
STARSHIP_DIR="$HOME/.config/starship.toml"
COLORMAP="$CONFIG_DIR/colorscheme.lua"
HARPOON="$CONFIG_DIR/harpoon.lua"
KEYMAP="$KEYMAP_DIR/keymaps.lua"
GHOSTTY_CONFIG="$GHOSTTY_DIR/config"

##############################################
#             Main Logic                     #
##############################################

detect_os

echo "Detected OS: $OS_NAME ($OS_ID)"
echo "----------------------------------------"

# Dispatch commands based on detected OS
case "$OS_ID" in
    *debian*|*ubuntu*|*raspbian*|*pop*)
        echo "Running Debian/Ubuntu-specific commands..."

        echo "==> 1. Installing core build dependencies & CLI tools..."
        sudo apt update
        sudo apt install -y git build-essential curl ripgrep fd-find
        echo "==> 2. Installing Neovim..."
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim-linux-x86_64
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
        rm nvim-linux-x86_64.tar.gz
        if ! grep -q '/opt/nvim-linux-x86_64/bin' "$HOME/.bashrc"; then
          echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> "$HOME/.bashrc"
        fi
        export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
        echo "==> 3. Setting up LazyVim starter..."
        mkdir -p "$HOME/.config"
        if [ -d "$HOME/.config/nvim" ]; then
          mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak$(date +%s)"
        fi
        rm -rf "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"
        git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
        rm -rf "$HOME/.config/nvim/.git"
        echo "==> 4. Creating Ghostty configuration file..."
        mkdir -p "$HOME/.config/ghostty"
        if [ ! -f "$HOME/.config/ghostty/config" ]; then
          cat <<'EOF' > "$HOME/.config/ghostty/config"
# Ghostty Configuration
background = 000000
foreground = e1e6ef
cursor-color = 9fef00
selection-background = 293b51
selection-foreground = 9fef00

# 16-Color Palette (HTB Hex Codes)
palette = 0=#101a26
palette = 1=#ff5252
palette = 2=#9fef00
palette = 3=#ffb454
palette = 4=#5cb2ff
palette = 5=#d38aea
palette = 6=#50e3c2
palette = 7=#e1e6ef
palette = 8=#334b68
palette = 9=#ff6e6e
palette = 10=#aef226
palette = 11=#ffc777
palette = 12=#70beff
palette = 13=#de9df2
palette = 14=#6beac9
palette = 15=#ffffff

# Transparency level
background-opacity = 0.60
maximize = true
EOF
        fi

        echo "==> 5. Installing Ghostty..."
        if command -v ghostty &>/dev/null; then
          echo "Ghostty is already installed!"
        else
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
        fi
        echo "==> Setup complete! Restart your shell or run 'source ~/.bashrc'."
        ;;
    *arch*|*cachyos*|*manjaro*)
        echo "Running Arch-based commands..."
        # sudo pacman -Syu --noconfirm
        ;;
    *rhel*|*centos*|*fedora*|*rocky*|*almalinux*)
        echo "Running RHEL/Fedora-specific commands..."
        # sudo dnf update -y
        ;;
    *alpine*)
        echo "Running Alpine-specific commands..."
        # apk update
        ;;
    *darwin*)
        echo "Running macOS-specific commands..."
        # brew update
        ;;
    *)
        echo "Unsupported or unknown OS: $OS_ID"
        exit 1
        ;;
esac
