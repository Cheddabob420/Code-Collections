#!/usr/bin/env bash
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
