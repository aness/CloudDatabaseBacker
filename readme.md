# README: Database Backup and Cloud Upload Script

## Overview
This script automates the backup of a MySQL database using `mysqldump` and uploads the backup to a cloud repository configured with `rclone`. The backup is saved locally in a specified folder and then sent to the cloud for secure storage.

---

## Prerequisites
- Linux environment with `bash` shell.
- MySQL installed and configured.
- `mysqldump` available in the system.
- `rclone` installed and configured with at least one cloud repository.

---

## Steps to Install MySQL and Use `mysqldump`

### 1. Install MySQL
1. Update your package index:
   ```bash
   sudo apt update
   ```
2. Install MySQL server:
   ```bash
   sudo apt install mysql-server
   ```
3. Start and enable MySQL service:
   ```bash
   sudo systemctl start mysql
   sudo systemctl enable mysql
   ```
4. Secure the MySQL installation:
   ```bash
   sudo mysql_secure_installation
   ```

### 2. Use `mysqldump`
- `mysqldump` is used to export the database to a `.sql` file.
- Basic usage:
  ```bash
  mysqldump -u [username] -p[password] [database_name] > [output_file.sql]
  ```
- Example:
  ```bash
  mysqldump -u root -p my_database > /backups/my_database.sql
  ```
  Replace `[username]`, `[password]`, `[database_name]`, and `[output_file.sql]` with your details.

---

## Steps to Set Up `rclone`

### 1. Install `rclone`
1. Download the latest `rclone` binary:
   ```bash
   curl -O https://downloads.rclone.org/rclone-current-linux-amd64.deb
   ```
2. Install the downloaded package:
   ```bash
   sudo dpkg -i rclone-current-linux-amd64.deb
   ```

### 2. Configure `rclone`
1. Run the configuration command:
   ```bash
   rclone config
   ```
2. Follow the interactive setup to:
   - Create a new remote.
   - Specify the cloud storage type (e.g., Google Drive, AWS S3, Dropbox).
   - Authenticate `rclone` with your cloud account.
   - Name the remote (e.g., `CloudRepository`).
3. Test the connection:
   ```bash
   rclone ls CloudRepository:
   ```

---

## Script Usage

### 1. Set Up the Backup Script
1. Save the script with a meaningful name, e.g., `backer.sh`:
   ```bash
   #!/bin/bash

   # Database backup script
   dbname="DatabaseNameHere"
   dated_filename=$(date +'%m_%d_%Y')
   fname1="/BackupFolder/${dbname}_${dated_filename}.sql"

   # Dump the database
   mysqldump --no-tablespaces -u DatabaseUsername -pDatabasePasswordHere ${dbname} > ${fname1}

   # Upload the backup
   rclone copy ${fname1} CloudRepository:${dbname}
   ```
2. Make the script executable:
   ```bash
   chmod +x backer.sh
   ```

### 2. Schedule the Script with Cron
1. Open the cron editor:
   ```bash
   crontab -e
   ```
2. Add an entry to run the script at a specific time (e.g., 0:1 AM daily):
   ```bash
   0 1 * * * bash /backups/backer.sh
   ```
3. Save and exit.
4. Verify the cron job:
   ```bash
   crontab -l
   ```

---

## Notes
- Replace placeholders in the script (e.g., `DatabaseNameHere`, `DatabaseUsername`, `DatabasePasswordHere`, `/BackupFolder`) with actual values.
- Ensure the backup folder (`/BackupFolder`) exists and has proper permissions.
- Confirm the `rclone` configuration and ensure the remote repository is accessible.
- Test the script manually before scheduling it with `cron`:
  ```bash
  bash /path/to/backer.sh
  ```

