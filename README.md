# rclonebash
Bash scripts to use rclone as a backup method for database and web files. These scripts assume you already have rclone installed on your system and have set up a remote.
Modify the variables in the header of the script maintaining ` & ` at the start and end of your input.

## MySQL Database Backup
Use db-backup.sh to backup a MySQL database using mysqldump. Ensure the user you are connecting to the database with has permission to lock the database in order to make a MySQL dump. Refer to MySQL documentation for permissions.

## Web Data Backup
Use webdata-backup.sh to backup the web directory of your website. 
The example given is to backup the wp-content folder of a wordpress website. This will include all of the themes, plugins and uploaded media of the wordpress website.

Be sure to do a rclone copy of the entire web directory after each upgrade to the wordpress code, to maintain a copy in your remote location.

### Crontab

To set up a cron job, to automatically run the backup scripts at specified intervals, edit your crontab and add the following code: crontab -e
```0 * * * * sh /rclone/db-backup.sh >/dev/null 2>&1```
