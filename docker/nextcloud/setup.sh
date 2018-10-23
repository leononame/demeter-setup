#!/bin/bash

mkdir -p /var/www/nextcloud
cp docker-compose.yml /var/www/nextcloud

# setup nginx
ln -s -T /etc/nginx/sites-available/nextcloud /etc/nginx/sites-enabled/nextcloud
rm /etc/nginx/sites-enabled/default

echo "Launching docker containers for Nextcloud. This operation may take a while."

sudo service nginx restart
cd /var/www/nextcloud
sudo docker-compose up -d

echo "Docker containers up and running"


echo "================================"
echo "================================"
echo "Preparing backup data"
echo -n "User for storage box: "
read user
echo -n "Folder in storage box: ./"
read folder
echo -n "Passphrase: "
read pass
echo "export BACKUP_USER=$user" >> ~/.backupncrc
echo "export BACKUP_FOLDER=./$folder" >> ~/.backupncrc
echo "export BORG_PASSPHRASE=$pass" >> ~/.backupncrc

echo ""
echo "Initializing borg repository"
source ~/.backupncrc
REPOSITORY="ssh://${BACKUP_USER}@${BACKUP_USER}.your-storagebox.de:23/${BACKUP_FOLDER}"
borg init --encryption=repokey "$REPOSITORY"

cp backupnc.sh /usr/local/bin
echo "Add the following line to crontab -e"
echo "0 0 * * * /usr/local/bin/backupnc.sh > /dev/null 2>&1"