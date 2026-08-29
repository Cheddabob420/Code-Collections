#!/usr/bin/env bash

# ----------------------------------------------------------------------
# Flatpak & Ghostty Setup
# ----------------------------------------------------------------------
echo "Setting up Flatpak and Flathub repository..."

# Install flatpak package if not present
if ! command -v flatpak &> /dev/null; then
    sudo apt update && sudo apt install -y flatpak
fi

# Add Flathub repository (system-wide)
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Refresh local Flatpak package data
flatpak update --appstream

echo "Installing Ghostty via Flatpak..."
# Install Ghostty non-interactively
flatpak install -y flathub com.mitchellh.ghostty

# Export Flatpak bin paths for the current shell session so it runs immediately
export PATH="$PATH:/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin"
