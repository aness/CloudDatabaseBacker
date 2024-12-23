#!/bin/bash

# Database Backup and Cloud Upload Script
# This script backs up a specified MySQL database using mysqldump,
# saves the backup locally, and uploads it to a cloud repository using rclone.

# --- Configuration Section ---
# Name of the database to back up
dbname="DatabaseNameHere"

# MySQL credentials
db_user="DatabaseUsername"
db_password="DatabasePasswordHere"

# Backup directory
backup_dir="/BackupFolder"

# Rclone remote configuration name
cloud_remote="CloudRepository"

# --- Script Execution ---

# Generate a filename based on the current date
current_date=$(date +'%m_%d_%Y')
backup_file="${backup_dir}/${dbname}_${current_date}.sql"

# Ensure the backup directory exists
if [ ! -d "$backup_dir" ]; then
    echo "Backup directory does not exist. Creating: $backup_dir"
    mkdir -p "$backup_dir"
fi

# Dump the database into the backup file
echo "Starting database backup for: $dbname"
mysqldump --no-tablespaces -u "$db_user" -p"$db_password" "$dbname" > "$backup_file"

if [ $? -eq 0 ]; then
    echo "Database backup successful: $backup_file"
else
    echo "Error occurred during database backup. Exiting."
    exit 1
fi

# Upload the backup file to the cloud repository
echo "Uploading backup to cloud repository: $cloud_remote"
rclone copy "$backup_file" "$cloud_remote:$dbname"

if [ $? -eq 0 ]; then
    echo "Backup successfully uploaded to cloud repository."
else
    echo "Error occurred during upload to cloud repository."
    exit 1
fi

# Completion message
echo "Database backup and upload completed successfully."

