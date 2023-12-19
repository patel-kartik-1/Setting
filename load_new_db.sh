#!/bin/bash
# MySQL credentials
DB_USER="root"
DB_PASSWORD="password"

# Extract filename without extension
FILE_NAME=$1
DB_NAME="${FILE_NAME%.*}"
PWD_PATH=$(pwd)
FULL_FILE_NAME="$PWD_PATH/$FILE_NAME"

# Check if the filename argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <file_name.sql>"
    exit 1
fi

# Load SQL file into MySQL
mysql -u $DB_USER -p$DB_PASSWORD <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;  # Create DB if it doesn't exist
SET GLOBAL innodb_strict_mode=0;         # Disable strict mode globally
USE $DB_NAME;                            # Use the created database
SET GLOBAL innodb_strict_mode=0;         # Disable strict mode for the database
source $FULL_FILE_NAME;                  # Load SQL file into the database
EOF

# Check if the first MySQL command was successful
if [ $? -eq 0 ]; then
    echo "Database $DB_NAME loaded successfully."
    
    # Execute the pre-backup SQL script
    mysql -u $DB_USER -p$DB_PASSWORD <<EOF
    USE $DB_NAME;
    source $PWD_PATH/pre_backup_script.sql;
EOF

    # Check if the second MySQL command was successful
    if [ $? -eq 0 ]; then
        echo "Pre-backup script executed successfully."
    else
        echo "Error executing pre-backup script."
    fi
else
    echo "Error loading database. Please check."
fi
