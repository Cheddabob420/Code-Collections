#!/bin/bash

# --- Configuration ---
BASE_URL="https://raw.githubusercontent.com/Cheddabob420/Code-Collections/master/setup-bash-scripts/scripts/"

# Create a secure temporary directory
# 'mktemp -d' creates a unique folder in /tmp/
DEST_DIR=$(mktemp -d -t tempdir-XXXXXX)

# --- Cleanup Logic ---
# This "trap" runs the rm command when the script exits (EXIT) 
# or is interrupted (INT/TERM)
cleanup() {
    echo -e "\n[!] Cleaning up temporary files..."
    rm -rf "$DEST_DIR"
}
trap cleanup EXIT INT TERM

# --- Functions ---
download_and_run() {
    local FILENAME=$1
    echo -e "\n[+] Downloading $FILENAME to temporary storage..."
    
    curl -f -sL "$BASE_URL/$FILENAME" -o "$DEST_DIR/$FILENAME"

    if [ $? -eq 0 ]; then
        chmod +x "$DEST_DIR/$FILENAME"
        echo "[+] Executing $FILENAME..."
        echo "------------------------------------------"
        
        # Execute the script from the temp directory
        "$DEST_DIR/$FILENAME"
        
        echo "------------------------------------------"
        echo "[+] Execution finished."
    else
        echo "Error: Could not download $FILENAME."
    fi
}

# Function to download multiple files (without executing the second one)
download_for_termux() {
    local PRIMARY=$1
    local COMPANION=$2
    
    # Download the companion script first
    echo -e "\n[+] Downloading $COMPANION to temporary storage..."
    curl -f -sL "$BASE_URL/$COMPANION" -o "$DEST_DIR/$COMPANION"
    if [ $? -eq 0 ]; then
        chmod +x "$DEST_DIR/$COMPANION"
        echo "[+] $COMPANION downloaded."
    else
        echo "Error: Could not download $COMPANION."
        return 1
    fi
    
    # Now download and run the primary script
    echo -e "\n[+] Downloading $PRIMARY to temporary storage..."
    curl -f -sL "$BASE_URL/$PRIMARY" -o "$DEST_DIR/$PRIMARY"

    if [ $? -eq 0 ]; then
        chmod +x "$DEST_DIR/$PRIMARY"
        echo "[+] Executing $PRIMARY..."
        echo "------------------------------------------"
        
        # Execute the script from the temp directory
        "$DEST_DIR/$PRIMARY"
        
        echo "------------------------------------------"
        echo "[+] Execution finished."
    else
        echo "Error: Could not download $PRIMARY."
    fi
}

# --- Menu ---
clear
echo "=========================================="
echo "             RC Script Runner             "
echo "=========================================="
echo "Select a Distro:"
echo "1) MX/Debian"
echo "2) Termux"
echo "3) Marjano"
echo "4) Fedora"
echo "5) Exit"
echo "------------------------------------------"
read -p "Enter choice [1-5]: " choice

case $choice in
    1) download_and_run "mx-debian.sh" ;;
    2) download_for_termux "termux.sh" "proot-setup.sh" ;;
    3) download_and_run "marjano.sh" ;;
    4) download_and_run "fedora.sh" ;;
    5) exit 0 ;;
    *) echo "Invalid option."; exit 1 ;;
esac
