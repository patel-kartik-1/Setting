#!/bin/bash

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

FILE_NAME=$1
SQL_NAME="${FILE_NAME%.*}" # Extracting the filename without extension

# Check if filename argument is provided
if [ -z "$FILE_NAME" ]; then
    echo -e "${RED}Error: No filename provided.${NC}"
    exit 1
fi

# Check if file exists
if [ ! -f "$FILE_NAME" ]; then
    echo -e "${RED}Error: File '$FILE_NAME' not found.${NC}"
    exit 1
fi

echo "$FILE_NAME found."

echo -e "${YELLOW}Select an option:${NC}"
options=("DSM" "MDJ" "AVK" "Other(Without Password)")

PS3=$(echo -e "${YELLOW}Enter the number corresponding to your System: ${NC}")
select choice in "${options[@]}"; do
    case $REPLY in
    1)
        MESSAGE="You selected DSM"
        PASSWORD="5h0l@yDSM"
        break
        ;;
    2)
        MESSAGE="You selected MDJ"
        PASSWORD="5h0l@yMDJ"
        break
        ;;
    3)
        MESSAGE="You selected AVK"
        PASSWORD="5h0l@yAVK"
        break
        ;;
    4)
        MESSAGE="You selected Other System"
        PASSWORD=""
        break
        ;;
    *)
        echo -e "${RED}Invalid option, please try again.${NC}"
        ;;
    esac
done

echo $MESSAGE

# Ensure Load directory exists
if [ ! -d "Load" ]; then
    mkdir Load
fi

# Extract the file
if ! 7z x "$FILE_NAME" -p"$PASSWORD" -o$(pwd)/Load; then
    echo -e "${RED}Error: File extraction failed.${NC}"
    exit 1
fi

# Check if extraction was successful
if [ -f "Load/$SQL_NAME" ]; then
    echo -e "${GREEN}File Extracted Successfully${NC}"

    # Set permissions
    if chmod 777 "Load/$SQL_NAME"; then
        echo -e "${GREEN}Permissions set on $SQL_NAME${NC}"

        # Run load script
        if ./Load/load_db.sh "$SQL_NAME" "$(pwd)/Load"; then
            echo -e "${GREEN}$SQL_NAME loaded successfully.${NC}"
        else
            echo -e "${RED}Error: Loading script execution failed.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Error: Failed to change permissions.${NC}"
        exit 1
    fi
else
    echo -e "${RED}Error: Extracted file '$SQL_NAME' not found.${NC}"
    exit 1
fi
