#!/usr/bin/env bash
set -euo pipefail

echo "==> 1. Installing core build dependencies & CLI tools..."
sudo apt update
sudo apt install -y git build-essential curl ripgrep fd-find

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
