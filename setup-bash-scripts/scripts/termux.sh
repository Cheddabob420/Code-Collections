#!/bin/bash

echo "<----Termux New Install Setup Script---->"

# --- 1. Package Installation ---
echo "Installing core tools..."

#update
pkg update && pkg upgrade -y
#Install Text editor and tools
pkg i micro nano tree cowsay shellcheck starship ossp-uuid -y
#IOT and git
pkg i git wget curl gh gpg apt-transport-https ssh  -y
#vnc and other tools
pkg i tigervnc-standalone-server -y
#Fastfetch or neofetch 
pkg i fastfetch -y || pkg i neofetch -y
# Add bash language server for kate
pkg i npm -y
npm install -g bash-language-server 


# Setup Get Nerd Font
PREFIX='/data/data/com.termux/files/usr'
git clone https://github.com/arnavgr/termux-nf.git
cd termux-nf
bash install.sh
getnf -i Profont
             
# Check if FONT_DIR is set
if [ -z "$FONT_DIR" ]; then     
    FONT_DIR="$PREFIX/share/termux-nf/fonts"  
fi
cp "$FONT_DIR/ProFont/ProFontIIxNerdFontMono-Regular.ttf" "$HOME/.termux/font.ttf" || { echo "${RED}Failed to apply font${RESET}"; exit 1; }

echo "Nerd Font Installed"

#Configure Starship
cd "$HOME" || exit
mkdir -p ~/.config && touch ~/.config/starship.toml

# --- Setup Python Environment
cd "$HOME" || exit
python_env="$HOME/.venv"

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

# --- Configuration Setup ---
BASHRC="$HOME/.bashrc"
echo "Configuring $BASHRC..."

# Create a backup with a timestamp
cp "$BASHRC" "$BASHRC.bak.$(date +%F_%T)"

# Create some needed directorys
mkdir -v $HOME/Projects
mkdir -v $HOME/Programs
mkdir -v $HOME/Projects/Lua
mkdir -v $HOME/Projects/Python
mkdir -v $HOME/Projects/MicroWorks
mkdir -v $HOME/Projects/HTML

# Note: Use 'EOF' to prevent the script from expanding $HOME or $PS1 now
cat << 'EOF' > "$BASHRC"
# ~/.bashrc - Custom Environment

# UI/UX Improvements
export EDITOR='micro'
export HISTSIZE=10000
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Navigation Shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias h='history'

# Git Shortcuts
alias gst='git status'
alias gp='git pull'

# Update command alias
alias updater='sudo apt update && sudo apt dist-upgrade -y && sudo apt autoremove -y'
alias autoremove='sudo apt autoremove -y'

# Python aliases
alias pip='$HOME/.venv/bin/pip'
alias python='$HOME/.venv/bin/python3'
alias python3='$HOME/.venv/bin/python3'
alias pyven='source $HOME/.venv/bin/activate'



### Detection Function ###
# Returns 0 (true) if running in Termux, 1 (false) otherwise
is_termux() {
    [[ -n "$PREFIX" && "$PREFIX" == */com.termux/* ]]
}

### Username & Path Logic ###
if is_termux; then
    USER_NAME="cogy"
    # Termux specific paths
    SHELL_RC="/data/data/com.termux/files/home/.shell_rc_content"
    ALIASES="/data/data/com.termux/files/home/.aliases"
else
    USER_NAME="$(whoami)"
    # Desktop/Standard Linux paths
    SHELL_RC="$HOME/.shell_rc_content"
    ALIASES="$HOME/.aliases"
fi


alias pyven='source ~/.venv/bin/activate'
alias python='python3'
source ~/.aliases
eval "$(starship init bash)"
# Add fastfetch to the bottom for the sys info art
fastfetch
EOF

# ---  Finalization ---
echo "Success! Your environment is ready."

echo "Bashrc Setup Complete!"




#           ---Cowsay random cow headder---
#date +"%I:%M %P | %A, %B %d, %Y" | cowsay -f dragon-and-cow
# 1. Get the list of cows
# 2. Use 'grep -v' to remove the header line
# 3. Use 'xargs' to turn the grid into a single column (removes extra spaces)
# 4. Use 'shuf' to pick one
#RANDOM_COW=$(cowsay -l | grep -v "Cow files in" | xargs -n 1 | shuf -n 1)

# Only run cowsay if RANDOM_COW is not empty to avoid errors
#if [ -n "$RANDOM_COW" ]; then
#    date +"%I:%M %P | %A, %B %d, %Y" | cowsay -f "$RANDOM_COW"
#fi
