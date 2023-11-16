#!/bin/bash

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
SAFFRON='\033[0;33m'  # Saffron color
NC='\033[0m' # No Color

# Function to display a message in a specific format
function display_message() {
    printf "${BLUE}*********************************************${NC}\n"
    printf "${YELLOW}$1${NC}\n"
    printf "${BLUE}*********************************************${NC}\n"
}

# Function to display a fun message
function display_fun_message() {
    printf "${GREEN}"
    cat << "EOF"
  _  __                 _     _   _        _____            _            _ 
 | |/ /                | |   (_) | |      |  __ \          | |          | |
 | ' /    __ _   _ __  | |_   _  | | __   | |__) |   __ _  | |_    ___  | |
 |  <    / _` | | '__| | __| | | | |/ /   |  ___/   / _` | | __|  / _ \ | |
 | . \  | (_| | | |    | |_  | | |   <    | |      | (_| | | |_  |  __/ | |
 |_|\_\  \__,_| |_|     \__| |_| |_|\_\   |_|       \__,_|  \__|  \___| |_|
                                                                                                                                                                       
EOF
    printf "${NC}"
}

# Function to display a fun message
function display_jay_swaminarayan_message() {
    printf "${SAFFRON}"
    cat << "EOF"
       _                      _____                                  _                                                        
      | |                    / ____|                                (_)                                                       
      | |   __ _   _   _    | (___   __      __   __ _   _ __ ___    _   _ __     __ _   _ __    __ _   _   _    __ _   _ __  
  _   | |  / _` | | | | |    \___ \  \ \ /\ / /  / _` | | '_ ` _ \  | | | '_ \   / _` | | '__|  / _` | | | | |  / _` | | '_ \ 
 | |__| | | (_| | | |_| |    ____) |  \ V  V /  | (_| | | | | | | | | | | | | | | (_| | | |    | (_| | | |_| | | (_| | | | | |
  \____/   \__,_|  \__, |   |_____/    \_/\_/    \__,_| |_| |_| |_| |_| |_| |_|  \__,_| |_|     \__,_|  \__, |  \__,_| |_| |_|
                    __/ |                                                                                __/ |                
                   |___/                                                                                |___/                 
                                                                                                                                                                       
EOF
    printf "${NC}"
}

# Function to check and install essential packages if missing
function install_essential_packages() {
    essential_packages=("git" "wget" "curl")

    for package in "${essential_packages[@]}"; do
        if ! dpkg -s "$package" >/dev/null 2>&1; then
            printf "${GREEN}Installing $package...${NC}\n"
            sudo apt install -y "$package"
        fi
    done
}

# Function to check for and install security updates
function install_security_updates() {
    printf "${BLUE}Checking for security updates...${NC}\n"
    sudo apt update && sudo apt list --upgradable | grep -i security
    if [ $? -eq 0 ]; then
        printf "${GREEN}Installing security updates...${NC}\n"
        sudo apt upgrade -y --only-upgrade
    else
        printf "${YELLOW}No security updates available.${NC}\n"
    fi
}

# Function to perform system updates and cleanup
function perform_system_updates() {
    printf "${BLUE}Updating repositories...${NC}\n"
    sudo apt update

    printf "${BLUE}Upgrading packages...${NC}\n"
    sudo apt upgrade -y

    printf "${BLUE}Running additional upgrade and cleanup commands...${NC}\n"
    sudo apt full-upgrade -y
    sudo apt dist-upgrade -y
    sudo apt-get check
    sudo apt -f install -y
    sudo apt -y clean
    sudo apt -y autoclean
    sudo apt autoremove -y
    sudo dpkg --configure -a
    sudo apt --fix-broken install -y
}

# Function to clear temporary files and caches
function clear_temporary_files() {
    printf "${BLUE}Clearing temporary files and caches...${NC}\n"
    
    # Clearing temporary files
    sudo rm -rf /tmp/*

    # Clearing cache and temporary folders
    sudo apt clean
    sudo apt autoclean

    # Clearing logs
    sudo rm -rf /var/log/*.log
    sudo rm -rf /var/log/**/*.log

    # Clearing thumbnails
    rm -rf ~/.cache/thumbnails/*

    display_message "Cleanup completed. Goodbye!"

}


# Main script execution starts here

# Update repositories and perform upgrades
display_fun_message
display_message "Updating system packages..."

perform_system_updates

# Install security updates
install_security_updates

# Check and install essential packages
install_essential_packages

# Clear temporary files and caches
clear_temporary_files

# Check the current time and display a greeting accordingly
now=$(date +"%H")
if [ "$now" -ge 12 ]; then
    display_message "Done. Good Afternoon! Created by Kartik."
else
    display_message "Done. Good Morning! Created by Kartik."
fi

#display jay swaminarayan
display_jay_swaminarayan_message
