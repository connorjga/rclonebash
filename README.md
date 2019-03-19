# rclonebash
Bash scripts to use rclone as a backup method for database and web files. These scripts assume you already have rclone installed on your system and have set up a remote.
Modify the variables in the header of the script maintaining ` & ` at the start and end of your input.

Use db-backup.sh to backup a MySQL database using mysqldump.

Use webdata-backup.sh to backup the web directory of your website. The example given is to backup the wp-content folder of a wordpress website. This will include all of the themes, plugins and uploaded media of the wordpress website.
(Be sure to do a rclone copy of the entire web directory after each upgrade to the wordpress code, to maintain a copy in your remote location).
