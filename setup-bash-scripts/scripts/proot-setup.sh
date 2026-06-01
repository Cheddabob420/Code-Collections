cat << 'EOF' > ~/proot-setup.sh
#!/bin/bash
# ==========================================
# RUNS INSIDE THE PROOT CONTAINER
# ==========================================

echo " =========================================="
echo "         Debian Setup Script"
echo " =========================================="

sleep 3

echo "Updating Debian package lists..."
apt update && apt upgrade -y

echo "Installing XFCE4 and essential utilities..."
# DEBIAN_FRONTEND=noninteractive stops prompts from pausing your script
ENV DEBIAN_FRONTEND=noninteractive apt install -y \
    xfce4 \
    xfce4-goodies \
    xterm \
    dbus-x11 \
    wget \
    curl \
    git \
    micro \
    nano \
    tree \
    cowsay \
    shellcheck \
    starship \
    ossp-uuid \
    gh \
    gpg \
    apt-transport-https \
    openssh \
    fastfetch 

echo "Tweaking XFCE4 for performance..."
# Turn off screen blanking/power management which can crash PRoot displays
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/blank-on-ac -s 0 --create -t int
xfconf-query -c xfce4-power-manager -p /xfce4-power-manager/dpms-enabled -s false --create -t bool


# Install VS Code

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg

echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

rm -f packages.microsoft.gpg
apt update
apt install -y code

echo "VS Code installation complete! Run it by typing 'code' in your terminal."

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
update-alternatives --set x-www-browser /usr/bin/google-chrome-stable

# 3. Purge Firefox and Mozilla artifacts
echo "--- Removing Firefox and Mozilla leftovers ---"

# Remove Snap version (Common in Ubuntu)
if snap list | grep -q firefox; then
    snap remove firefox
fi

# Remove APT version (Common in Debian/Mint)
apt purge firefox-esr firefox -y

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

echo " =========================================="
echo "         Internal Debian setup complete!"
echo " =========================================="

sleep 3
EOF
chmod +x ~/proot-setup.sh
