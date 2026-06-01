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
pkg i git wget curl gh apt-transport-https openssh -y || error-msg
pkg i fastfetch -y || pkg i neofetch -y || error-msg
pkg i npm -y
npm install -g bash-language-server 
pkg i termux-api -y
termux-setup-storage
pkg i proot-distro x11-repo android-tools -y || error-msg


#   <---setup proot-distro--->
proot-distro install debian
echo "Executing internal desktop environment installation..."
proot-distro login debian --shared-tmp -- bash /data/data/com.termux/files/home/proot-setup.sh
wait
echo "Cleaning up setup scripts..."
sleep 2
rm ~/proot-setup.sh


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
mkdir -v $HOME/Projects/Python
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
    # Starup
    killall -9 termux-x11 Xwayland 2>/dev/null
    rm -rf /tmp/.X11-unix/X1 2>/dev/null
    
    termux-x11 :1 -xstartup "echo launcher" &
    sleep 1.5
    
    am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
    
    proot-distro login debian --shared-tmp --env DISPLAY=:1 -- dbus-launch --exit-with-session xfce4-session
    
    # Shutdown
    echo "XFCE4 session closed. Initiating container shutdown..."
    
    killall -9 termux-x11 Xwayland 2>/dev/null
    
    kill -9 $(pgrep -f "proot") 2>/dev/null
    
    rm -rf /tmp/.X11-unix/X1 2>/dev/null
    
    echo "Container and X11 server stopped successfully. Safe to close Termux."
}

stop_desktop() {
    echo "Force shutting down PRoot and X11..."
    killall -9 termux-x11 Xwayland 2>/dev/null
    kill -9 $(pgrep -f "proot") 2>/dev/null
    rm -rf /tmp/.X11-unix/X1 2>/dev/null
    echo "Done."
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

