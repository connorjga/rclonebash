#! /bin/bash
#
# Rclone backup bash script by github.com/connoravo
# Be sure to review each command and modify as appropriate.
#

# Modify config variables
email='me@email.com'
webdata_directory='/var/www/html/wp-content'
remote='remote'
remotedest='/rclone/webdata'
# Do not modify from this point

# Set date
today=`date +%d-%m-%Y-%H.%M`
humantoday=`date +"%d/%m/%y %X"`
month=`date +%m`

# Change dir to rclone sync directory
cd /rclone/webdata

# Tarball web data directory into /rclone/webdata
tar -jcvf webdata.${today}.tar.bz2 ${webdata_directory}

# Rclone sync directory to remote
rclone copy /rclone/webdata ${remote}:${remotedest}/${month}

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

# Delete the last backup from the server.
# Rclone copy was used so deleting the last backup is safe to do on the server.
# All previous files should have successfully uploaded to your remote.
# Any failures will have resulted in an email being sent to you. 
find /rclone/database/ -type f -name '*.bz2.gz' -cmin +120 -exec rm {} \;