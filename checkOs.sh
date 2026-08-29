#!/usr/bin/env bash

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

detect_os

echo "Detected OS: $OS_NAME ($OS_ID)"
echo "----------------------------------------"

# Dispatch commands based on detected OS
case "$OS_ID" in
    *debian*|*ubuntu*|*raspbian*|*pop*)
        echo "Running Debian/Ubuntu-specific commands..."
        # sudo apt update && sudo apt install -y package
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
