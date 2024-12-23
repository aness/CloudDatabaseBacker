## Backup my database ##
#BackingdB----------------------------------------------------------------------
dbname="DatabaseNameHere"
dated_filename=$(date +'%m_%d_%Y')
fname1="/BackupFolder/${dbname}_${dated_filename}.sql"
#Saving
mysqldump --no-tablespaces -u DatabaseUsername -pDatabasePasswordHere ${dbname} > ${fname1}
#Uploading
rclone copy ${fname1} CloudRepository:${dbname}



#Add it into a cron like 
#19 22 * * * bash /backups/backer.sh