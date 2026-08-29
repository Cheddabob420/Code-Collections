#!/usr/bin/env bash
set -euo pipefail

echo "==> Installing system dependencies (git, build tools, ripgrep, fd)..."
sudo apt update
sudo apt install -y git build-essential curl ripgrep fd-find

echo "==> Downloading and installing Neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

# Ensure Neovim binary is in PATH
if ! grep -q '/opt/nvim-linux-x86_64/bin' "$HOME/.bashrc"; then
  echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> "$HOME/.bashrc"
fi

echo "==> Installing Ghostty terminal..."
# Check architecture and install official release binary bundle
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
  GHOSTTY_URL=$(curl -s https://api.github.com/repos/ghostty-org/ghostty/releases/latest | grep "browser_download_url.*linux-amd64.tar.gz" | cut -d '"' -f 4)
  if [ -n "$GHOSTTY_URL" ]; then
    curl -LO "$GHOSTTY_URL"
    sudo tar -C /usr/local -xzf ghostty-*.tar.gz
    rm ghostty-*.tar.gz
  else
    echo "Could not auto-fetch Ghostty binary tarball. Skipping Ghostty installation."
  fi
fi

echo "==> Backing up existing Neovim configs..."
[ -d ~/.config/nvim ] && mv ~/.config/nvim{,.bak"$(date +%s)"}
[ -d ~/.local/share/nvim ] && mv ~/.local/share/nvim{,.bak"$(date +%s)"}
[ -d ~/.local/state/nvim ] && mv ~/.local/state/nvim{,.bak"$(date +%s)"}
[ -d ~/.cache/nvim ] && mv ~/.cache/nvim{,.bak"$(date +%s)"}

echo "==> Cloning fresh LazyVim Starter..."
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

echo "==> Setup complete! Restart your shell or run 'source ~/.bashrc'."
