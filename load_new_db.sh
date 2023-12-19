#!/bin/bash
#username 
DB_USER="root"
DB_PASSWORD="password"
FILE_NAME=$1
DB_NAME="${FILE_NAME%.*}" # Extracting the filename without extension
PWD_PATH=$(pwd)
FULL_FILE_NAME="$PWD_PATH/$FILE_NAME"

# Check if both arguments are provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file_name.sql>"
    exit 1
fi

# Log in to MySQL and execute commands
mysql -u $DB_USER -p$DB_PASSWORD <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
SET GLOBAL innodb_strict_mode=0;
USE $DB_NAME;
SET GLOBAL innodb_strict_mode=0;
source $FULL_FILE_NAME;
EOF

# Check the exit status of the MySQL command
if [ $? -eq 0 ]; then
    echo "Database $DB_NAME loaded successfully."
    
    # Execute the post-load SQL script
    mysql -u $DB_USER -p$DB_PASSWORD <<EOF
    USE $DB_NAME;
    source $PWD_PATH/pre_backup_script.sql;
EOF

    # Check the exit status of the second MySQL command
    if [ $? -eq 0 ]; then
        echo "Pre-backup script executed successfully."
    else
        echo "Error executing pre-backup script."
    fi
else
    echo "Error loading database. Please check."
fi
