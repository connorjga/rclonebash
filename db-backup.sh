#! /bin/bash
#
# Rclone backup bash script by github.com/connoravo
# Be sure to review each command and modify as appropriate.
#

# Modify config variables
email='me@email.com'
mysql_user='root'
mysql_password='password'
mysql_table='table'
mysql_host='localhost'
remote='remote'
remotedest='/rclone/database'
# Do not modify from this point

# Set date
today=`date +%d-%m-%Y-%H.%M`
humantoday=`date +"%d/%m/%y %X"`
month=`date +%m`

# Change dir to rclone sync directory
cd /rclone/database

# Mysql dump database table to bz2 file
mysqldump -u ${mysql_user} -p${mysql_password} -h ${mysql_host} ${mysql_table} | bzip2 > ${mysql_table}.${today}.sql.bz2

# Rclone sync directory to remote
rclone copy /rclone/database ${remote}:${remotedest}/${month}
echo exit code = $?

# Checking Rclone success or failure, sends email
if [[ $? -gt 0 ]]; 
then
    subject="Backup Failed ${humantoday}"
    body="The scheduled backup has failed. The job ran ${humantoday}."
    echo -e "Subject:${subject}\n${body}" | sendmail -t "${email}"
else
    subject="Backup Succeeded ${today}"
    body="The scheduled backup has succeeded in transferring to ${remote} at location ${remotedest}. The job ran ${humantoday}."
    echo -e "Subject:${subject}\n${body}" | sendmail -t "${email}"
fi

# Delete backup file from 12 hours ago.
# Rclone copy was used so deleting backups older than 11 hours 59 mins is safe to do on the server.
# All previous files should have successfully uploaded to your remote.
# Any failures will have resulted in an email being sent to you. 
find /rclone/database/ -type f -name '*.bz2' -cmin +719 -exec rm {} \;