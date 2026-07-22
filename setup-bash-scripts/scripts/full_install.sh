#!/usr/bin/env bash
set -euo pipefail
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

# ==============================================================================
# BASH COLOR & FORMATTING PALETTE
# ==============================================================================

# Reset / Special
NC='\033[0m'              # No Color / Reset (ALWAYS use at end of string)
BOLD='\033[1m'            # Bold / High Intensity
DIM='\033[2m'             # Dim / Faded
ITALIC='\033[3m'          # Italic (Terminal dependent)
UNDERLINE='\033[4m'       # Underlined
BLINK='\033[5m'           # Slow Blink
REVERSE='\033[7m'         # Invert Foreground & Background
HIDDEN='\033[8m'          # Conceal / Invisible

# Standard Foreground Colors (Dark / Normal)
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
MAGENTA='\033[0;35m'       # Alternative alias for Purple
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold / High Intensity Foreground Colors
BLACK_BOLD='\033[1;30m'
RED_BOLD='\033[1;31m'
GREEN_BOLD='\033[1;32m'
YELLOW_BOLD='\033[1;33m'
BLUE_BOLD='\033[1;34m'
PURPLE_BOLD='\033[1;35m'
CYAN_BOLD='\033[1;36m'
WHITE_BOLD='\033[1;37m'

# Bright / Light Foreground Colors
GRAY='\033[0;90m'         # Dark Gray / Charcoal
LIGHT_RED='\033[0;91m'
LIGHT_GREEN='\033[0;92m'
LIGHT_YELLOW='\033[0;93m'
LIGHT_BLUE='\033[0;94m'
LIGHT_PURPLE='\033[0;95m'
LIGHT_CYAN='\033[0;96m'
LIGHT_WHITE='\033[0;97m'

# Background Colors
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

# Modern 256-Color Extras (Vibrant & Custom Shades)
ORANGE='\033[38;5;208m'
PINK='\033[38;5;205m'
TEAL='\033[38;5;37m'
GOLD='\033[38;5;220m'
LIME='\033[38;5;118m'
CORAL='\033[38;5;203m'
INDIGO='\033[38;5;63m'
GRAY_DARK='\033[38;5;238m'

CONFIG_DIR="$HOME/.config/nvim/lua/plugins"
KEYMAP_DIR="$HOME/.config/nvim/lua/config"
GHOSTTY_DIR="$HOME/.config/ghostty"
STARSHIP_DIR="$HOME/.config/starship.toml"
COLORMAP="$CONFIG_DIR/colorscheme.lua"
HARPOON="$CONFIG_DIR/harpoon.lua"
KEYMAP="$KEYMAP_DIR/keymaps.lua"
GHOSTTY_CONFIG="$GHOSTTY_DIR/config"

# --- 1. Package Installation ---
echo -e "\033[0;36mInstalling core tools...\033[0m"

echo "==> Setting up Griffo APT repo..."
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc |
  sudo gpg --dearmor --yes -o /etc/apt/keyrings/debian.griffo.io.gpg

# Fallback codename check if lsb_release isn't installed
if command -v lsb_release &>/dev/null; then
    CODENAME=$(lsb_release -sc)
else
    CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME")
fi

echo "deb [signed-by=/etc/apt/keyrings/debian.griffo.io.gpg] https://debian.griffo.io/apt ${CODENAME} main" |
  sudo tee /etc/apt/sources.list.d/debian.griffo.io.list >/dev/null

# Install the basics

sudo apt update && sudo apt dist-upgrade -y
sudo apt install -y micro nano tree cowsay shellcheck python3-pip bat wget curl gh ssh flatpak|| errorMsg
sudo apt install zig ghostty lazygit yazi viu eza uv fzf zoxide bun tigerbeetle deno forgejo forgejo-runner helix jujutsu zellij starship atuin k9s headscale garage tree-sitter-cli fd-find -y || errorMsg
sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd

# Add bash language server for kate
sudo apt install npm -y || errorMsg
sudo npm install -g bash-language-server || errorMsg

# Add Flatpak Repos
if ! flatpak remotes | grep -q "flathub"; then
    echo -e "\033[0;35mAdding Flathub repository...\033[0m"
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    echo -e "\033[0;32mFlathub already configured. Skipping.\033[0m"
fi


# Create some needed directorys
mkdir -pv "$HOME/Projects"
mkdir -pv "$HOME/Programs"
mkdir -pv "$HOME/Projects/Lua"
mkdir -pv "$HOME/Projects/Python"
mkdir -pv "$HOME/Projects/MicroWorks"
mkdir -pv "$HOME/Projects/HTML"
mkdir -pv "$HOME/Projects/C"
mkdir -pv "$HOME/Projects/Jupyter"
mkdir -pv "$HOME/Projects/Bash"
mkdir -pv "$CONFIG_DIR" "$KEYMAP_DIR" "$GHOSTTY_DIR"

# --- 2. Configuration Setup ---
BASHRC="$HOME/.bashrc"
echo -e "\033[0;33mConfiguring $BASHRC...\033[0m"

# Create a backup with a timestamp
cp "$BASHRC" "$BASHRC.bak.$(date +%F_%T)"

# Note: Use 'EOF' to prevent the script from expanding $HOME or $PS1 now
cat << 'EOF' > "$BASHRC"
export EDITOR='nvim'
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
alias cat='batcat'
USER_NAME="$(whoami)"
SHELL_RC="$HOME/.shell_rc_content"
ALIASES="$HOME/.aliases"
eval "$(starship init bash)"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
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
echo -e "\033[0;34mVS Code installation complete! Run it by typing 'code' in your terminal.\033[0m"

wait

# Install Google Chrome/Remove Firefox

# 1. Create a secure temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit

echo -e "\033[0;33m--- Starting Google Chrome Installation ---\033[0m"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt update && sudo apt install ./google-chrome-stable_current_amd64.deb -y

# 2. Set Chrome as the Default Browser
echo -e "\033[0;37m--- Setting Google Chrome as Default ---\033[0m"
# Sets the default for the XDG system (Desktop environments)
xdg-settings set default-web-browser google-chrome.desktop
# Sets the symbolic link for the 'x-www-browser' command
sudo update-alternatives --set x-www-browser /usr/bin/google-chrome-stable

# 3. Purge Firefox and Mozilla artifacts
echo -e "\033[0;31m--- Removing Firefox and Mozilla leftovers ---\033[0m"

# Remove Snap version (Common in Ubuntu)
if command -v snap &>/dev/null && snap list 2>/dev/null | grep -q firefox; then
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

echo -e "\033[0;32m--- Migration Complete! Google Chrome is now your default. ---\033[0m"
google-chrome --version

# Setup chrome before gh auth
echo -e "\033[0;35mPlease open chrome and sign in before going any further to make github auth much easier.\033[0m"
read -n 1 -s -p "Press any key to continue..."
echo ""

# Configure Github
gh auth login
source ~/.bashrc
wait

echo "==> Downloading and installing Neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

echo "==> Backing up existing Neovim configs..."
[ -d ~/.config/nvim ] && mv ~/.config/nvim{,.bak"$(date +%s)"} || true
[ -d ~/.local/share/nvim ] && mv ~/.local/share/nvim{,.bak"$(date +%s)"} || true
[ -d ~/.local/state/nvim ] && mv ~/.local/state/nvim{,.bak"$(date +%s)"} || true
[ -d ~/.cache/nvim ] && mv ~/.cache/nvim{,.bak"$(date +%s)"} || true

echo "==> Cloning LazyVim Starter..."
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

echo "==> NeoVim Setup Complete!"

# Harpoon 2 setup
cat <<'EOF' > "$HARPOON"
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
  keys = function()
    local harpoon = require("harpoon")
    local conf = require("telescope.config").values

    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
          results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
      }):find()
    end

    return {
      { "<leader>A", function() harpoon:list():add() end, desc = "Harpoon Add File" },
      { "<leader>H", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon Menu" },
      { "<leader>fH", function() toggle_telescope(harpoon:list()) end, desc = "Harpoon List (Telescope)" },

      { "<C-1>", function() harpoon:list():select(1) end, desc = "Harpoon File 1" },
      { "<C-2>", function() harpoon:list():select(2) end, desc = "Harpoon File 2" },
      { "<C-3>", function() harpoon:list():select(3) end, desc = "Harpoon File 3" },
      { "<C-4>", function() harpoon:list():select(4) end, desc = "Harpoon File 4" },
    }
  end,
  config = function()
    require("harpoon"):setup()
  end,
}
EOF

# Custom keymaps
cat <<'EOF' > "$KEYMAP"
vim.keymap.set("n", "<leader>fd", function()
  require("telescope.builtin").find_files({
    find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git" },
    prompt_title = "Find Directories",
  })
end, { desc = "Find Directories" })
EOF

# Theme / Colorscheme setup
cat <<'EOF' > "$COLORMAP"
return {
  {
    "audibleblink/hackthebox.vim",
    lazy = false,
    priority = 1000,
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {
      extra_groups = { "NormalFloat", "NvimTreeNormal" },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "hackthebox",
    },
  },
}
EOF

# Ghostty terminal config
cat <<'EOF' > "$GHOSTTY_CONFIG"
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


cat <<'EOF' > "$STARSHIP_DIR"
# Get editor completions based on the config schema
"$schema" = 'https://starship.rs/config-schema.json'

# Keep everything on a single line
add_newline = false

# Set the primary command character to an HTB theme color
[character]
success_symbol = '[➜](bold #99cc33)'
error_symbol = '[✗](bold #cc0000)'

# Customize the Directory block to look clean
[directory]
format = '[$path](bold #99cc33) '
truncation_length = 3
truncation_symbol = '…/'

# Disable unneeded modules for a clean, hacker-style terminal
[package]
disabled = true
[git_branch]
disabled = true
[git_status]
disabled = true
[nodejs]
disabled = true
[python]
disabled = true
[golang]
disabled = true
EOF
echo "==> Configuration applied successfully!"

