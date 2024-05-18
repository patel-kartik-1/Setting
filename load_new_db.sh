#!/bin/bash

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

DB_USER="root"
DB_PASSWORD="password"
FILE_NAME=$1
DB_NAME="${FILE_NAME%.*}" # Extracting the filename without extension
PWD_PATH="${2:-$(pwd)}"

echo $1 $0 $PWD_PATH

FULL_FILE_NAME="$PWD_PATH/$FILE_NAME"

# Check if filename argument is provided
if [ -z "$FILE_NAME" ]; then
    echo -e "${RED}Usage: $0 <file_name.sql> [path]${NC}"
    exit 1
fi

# Check if the input file exists
if [ ! -f "$FULL_FILE_NAME" ]; then
    echo -e "${RED}Error: File '$FULL_FILE_NAME' not found.${NC}"
    exit 1
fi

# Log in to MySQL and execute commands
mysql -u $DB_USER -p$DB_PASSWORD <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
USE $DB_NAME;
SET innodb_strict_mode=0;
source $FULL_FILE_NAME;
EOF

# Check the exit status of the MySQL command
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Database $DB_NAME loaded successfully.${NC}"

    echo -e "${YELLOW}Select an option:${NC}"
    options=("DSM" "MDJ" "Other(Without Password)")


    PS3=$(echo -e "${YELLOW}Enter the number corresponding to your System: ${NC}")
    select choice in "${options[@]}"; do
        case $REPLY in
        1)
            echo -e "${GREEN}You selected DSM${NC}"
            # Execute the post-load SQL script
            mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME <$PWD_PATH/pre_backup_script_dsm.sql
            break
            ;;
        2)
            echo -e "${GREEN}You selected MDJ${NC}"
            # Execute the post-load SQL script
            mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME <$PWD_PATH/pre_backup_script_mdj.sql
            break
            ;;
        3)
            echo -e "${GREEN}You selected Other System${NC}"
            break
            ;;
        *)
            echo -e "${RED}Invalid option, please try again.${NC}"
            ;;
        esac
    done

    # Check the exit status of the last MySQL command
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Pre-backup script executed successfully.${NC}"
    else
        echo -e "${RED}Error executing pre-backup script.${NC}"
    fi
else
    echo -e "${RED}Error loading database. Please check.${NC}"
fi
