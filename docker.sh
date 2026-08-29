#!/usr/bin/env bash

# Create the directory tree
mkdir -p ~/Docker/{compose,shared,volumes}

# Ensure your current user explicitly owns all subdirectories
chown -R $USER:$USER ~/Docker

# Set standard permissions (read/write/execute for owner, read/execute for group)
chmod -R 755 ~/Docker
