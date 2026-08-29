#!/usr/bin/env bash
set -euo pipefail

echo "==> 1. Installing core dependencies..."
sudo apt update
sudo apt install -y git build-essential curl ripgrep fd-find appstream libgtk-4-dev libadwaita-1-dev

echo "==> 2. Installing Neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

# Add Neovim to PATH if not present
if ! grep -q '/opt/nvim-linux-x86_64/bin' "$HOME/.bashrc"; then
  echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> "$HOME/.bashrc"
fi
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

echo "==> 3. Setting up LazyVim..."
# Ensure config dir exists and backup any existing nvim folder
mkdir -p "$HOME/.config"
if [ -d "$HOME/.config/nvim" ]; then
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.bak$(date +%s)"
fi
rm -rf "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"

# Explicit clone with failure reporting
if git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"; then
  rm -rf "$HOME/.config/nvim/.git"
  echo "LazyVim starter successfully cloned to ~/.config/nvim!"
else
  echo "ERROR: Failed to clone LazyVim repository!" >&2
  exit 1
fi

echo "==> 4. Setting up Ghostty configuration structure..."
mkdir -p "$HOME/.config/ghostty"
if [ ! -f "$HOME/.config/ghostty/config" ]; then
  cat <<'EOF' > "$HOME/.config/ghostty/config"
# Ghostty Configuration
theme = dark
background-opacity = 0.90
EOF
  echo "Created initial Ghostty config at ~/.config/ghostty/config"
fi
# ----------------------------------------------------------------------
# Ghostty Installation (Debian / MX Linux)
# ----------------------------------------------------------------------
echo "==> Installing Ghostty..."

if command -v ghostty &>/dev/null; then
  echo "Ghostty is already installed!"
else
  # Install the community-maintained pre-built .deb helper for Debian/Ubuntu
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
fi
