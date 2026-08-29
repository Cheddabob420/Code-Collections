#!/data/data/com.termux/files/usr/bin/bash

error-msg() {
	echo "Error installing package please remove it and rerun"
	sleep 3
	exit
}

echo " =========================================="
echo "         Termux New Install Setup Script"
echo " =========================================="
sleep 3

# <--- Core tools and other dependencies --->
echo "Installing core tools..."
sleep 2
pkg update && pkg upgrade -y
pkg i micro nano tree cowsay shellcheck starship ossp-uuid -y || error-msg
pkg i git wget curl gh openssh -y || error-msg
pkg i fastfetch -y || pkg i neofetch -y || error-msg
pkg i npm -y
npm install -g bash-language-server 
pkg i termux-api -y
termux-setup-storage
pkg i proot-distro x11-repo android-tools -y || error-msg


#   <---setup proot-distro--->
proot-distro install debian
echo "Executing internal desktop environment installation..."
proot-distro login debian -- bash -c "apt update && apt dist-upgrade -y"
proot-distro login debian -- bash -c "apt install xfce4 xfce4-goodies xterm dbus-x11 wget curl git micro nano tree cowsay shellcheck starship gh fastfetch -y"

wait

proot-distro login debian -- bash -c "wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null

rm -f packages.microsoft.gpg
apt update
apt install -y code

echo "VS Code installation complete! Run it by typing 'code' in your terminal.""

wait

proot-distro login debian -- bash -c "TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR" || exit

echo "--- Starting Google Chrome Installation ---"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt update && apt install ./google-chrome-stable_current_amd64.deb -y

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
rm -rf /usr/lib/firefox
rm -rf /etc/firefox

# 4. Cleanup temp files
cd ~
rm -rf "$TEMP_DIR"

echo "--- Migration Complete! Google Chrome is now your default. ---"
google-chrome --version"


# <---Setup Nerd Font--->
PREFIX='/data/data/com.termux/files/usr'
git clone https://github.com/arnavgr/termux-nf.git
cd termux-nf
bash install.sh
getnf -i Profont
if [ -z "$FONT_DIR" ]; then     
    FONT_DIR="$PREFIX/share/termux-nf/fonts"  
fi
cp "$FONT_DIR/ProFont/ProFontIIxNerdFontMono-Regular.ttf" "$HOME/.termux/font.ttf" || { echo "${RED}Failed to apply font${RESET}"; exit 1; }
echo "Nerd Font Installed"
sleep 2


# <---Configure Starship--->
cd "$HOME" || exit
mkdir -p ~/.config && touch ~/.config/starship.toml


# <---Setup Python Environment--->
cd "$HOME" || exit
python_env="$HOME/.venv"
create_venv() {
    echo "Creating python environment at $python_env..."
    if ! python3 -m venv "$python_env" 2>/dev/null; then
        echo "venv module missing. Attempting to install the required system package..."
        PY_VER=$(python3 -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
        VENV_PKG="python${PY_VER}-venv"
        echo "Running: sudo apt update && sudo apt install -y $VENV_PKG"
        if sudo apt update && sudo apt install -y "$VENV_PKG"; then
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


# <---Create some needed directories--->
mkdir -v $HOME/Projects
mkdir -v $HOME/Programs
mkdir -v $HOME/Projects/Lua
mkdir -v $HOME/Projects/Python/osrs
mkdir -v $HOME/Projects/MicroWorks
mkdir -v $HOME/Projects/HTML
mkdir -v $HOME/Projects/C
mkdir -v $HOME/Projects/Jupyter

# <---Setup .bashrc--->
BASHRC="$HOME/.bashrc"
echo "Configuring $BASHRC..."
cp "$BASHRC" "$BASHRC.bak.$(date +%F_%T)"
cat << 'EOF' > "$BASHRC"
# ~/.bashrc - Custom Environment

# UI/UX Improvements
export EDITOR='nano'
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
alias updater='sudo apt update && sudo apt dist-upgrade -y && flatpak update'
alias autoremove='sudo apt autoremove -y'

# Python aliases
alias pip='$HOME/.venv/bin/pip'
alias python='$HOME/.venv/bin/python3'
alias python3='$HOME/.venv/bin/python3'
alias pyven='source $HOME/.venv/bin/activate'


USER_NAME="$(whoami)"
# Desktop/Standard Linux paths
SHELL_RC="$HOME/.shell_rc_content"
ALIASES="$HOME/.aliases"

### Source Configs ###
[[ -f "$SHELL_RC" ]] && source "$SHELL_RC"
[[ -f "$ALIASES" ]] && source "$ALIASES"

eval "$(starship init bash)"


start_desktop(){
    # 1. Force kill any stuck X11 or Termux-X11 processes
    killall -9 termux-x11 Xwayland 2>/dev/null

    # 2. Aggressively clear out old X11 socket lock files
    rm -rf /tmp/.X11-unix
    rm -rf $PREFIX/tmp/.X11-unix
    rm -f /tmp/.X1-lock 2>/dev/null
    rm -f $PREFIX/tmp/.X1-lock 2>/dev/null
    rm -f /tmp/.X2-lock 2>/dev/null
    rm -f $PREFIX/tmp/.X2-lock 2>/dev/null

    # Re-create clean socket directories
    mkdir -p /tmp/.X11-unix
    mkdir -p $PREFIX/tmp/.X11-unix
    chmod 1777 /tmp/.X11-unix
    chmod 1777 $PREFIX/tmp/.X11-unix

    # 3. Start termux-x11 cleanly on display :2 (bypasses any cached lock issues)
    termux-x11 :2 &
    sleep 2

    # 4. Wake up the Android X11 App
    am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
    sleep 1.5

    # 5. Launch Debian XFCE explicitly pointing to :2
    proot-distro login debian --shared-tmp --user root -- bash -c "
        export DISPLAY=:2
        export PULSE_SERVER=127.0.0.1
        dbus-launch --exit-with-session xfce4-session
    "
}

fastfetch
EOF




#   <---this is for connecting to the phone through wierless adb--->

#adb pair IP_ADDRESS:PORT PAIRING_CODE
#adb connect IP_ADDRESS:CONNECTION_PORT
#   <---                --->

#   <---this is for using x11 to display applications running in native termux--->
# 1. Start the Termux-X11 display server in the background
#termux-x11 :1 &

# 2. Tell Termux to use this new display session
#export DISPLAY=:1

# 3. Launch your X11 application
#chrome &

####you can also use this function in a bashrc file to call it from the cli####
#start_x11() {
#    # Starts the server if it isn't running
#    if ! pgrep -x "termux-x11" > /dev/null; then
#        termux-x11 :1 &
#        sleep 1
#    fi
#    export DISPLAY=:1
#    # Launches whatever app you type after the command
#    "$@" &
#}
