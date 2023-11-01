#!/bin/bash

# Function to display a message in a specific format
function display_message() {
    echo "*********************************************"
    echo "$1"
    echo "*********************************************"
}

# Function to check and install essential packages if missing
function install_essential_packages() {
    essential_packages=("git" "wget" "curl")

    for package in "${essential_packages[@]}"; do
        if ! dpkg -s "$package" >/dev/null 2>&1; then
            echo "Installing $package..."
            sudo apt install -y "$package"
        fi
    done
}

# Function to check for and install security updates
function install_security_updates() {
    security_updates=$(sudo unattended-upgrade --dry-run -d 2>&1 | grep 'upgraded,')
    if [ -n "$security_updates" ]; then
        display_message "Installing security updates..."
        sudo unattended-upgrade -d
    else
        display_message "No security updates available."
    fi
}

# Update repositories and perform upgrades
display_message "Updating repositories..."
sudo apt update

display_message "Upgrading packages..."
sudo apt upgrade -y

# Install security updates
install_security_updates

# Additional commands for upgrading and cleaning
display_message "Running additional upgrade and cleanup commands..."
sudo apt full-upgrade -y
sudo apt dist-upgrade -y
sudo apt-get check
sudo apt -f install -y
sudo apt -y clean
sudo apt -y autoclean
sudo apt autoremove -y
sudo dpkg --configure -a
sudo apt --fix-broken install -y

# Check and install essential packages
display_message "Checking and installing essential packages..."
install_essential_packages

# Check the current time and display a greeting accordingly
now=$(date +"%H")

if [ "$now" -ge 12 ]; then
    display_message "Done. Good Afternoon!"
else
    display_message "Done. Good Morning!"
fi
