#!/bin/bash

mkdir -p /var/www/drone
cp docker-compose.yml /var/www/drone
cp .env /var/www/drone
cp backupdrone.sh /usr/local/bin

# setup nginx
ln -s -T /etc/nginx/sites-available/drone /etc/nginx/sites-enabled/drone
rm /etc/nginx/sites-enabled/default

echo "Launching docker containers for Drone.io. This operation may take a while."

sudo service nginx restart
cd /var/www/drone
sudo docker-compose up -d

echo "Docker containers up and running"


echo "================================"
echo "================================"
echo "Preparing backup data"
echo -n "User for storage box: "
read user
echo -n "Folder in storage box: ./"
read folder
echo -n "Borg Passphrase: "
read pass
echo "export BACKUP_USER=$user" >> ~/.backupdronerc
echo "export BACKUP_FOLDER=./$folder" >> ~/.backupdronerc
echo "export BORG_PASSPHRASE=$pass" >> ~/.backupdronerc

echo ""
echo -n "Please manually create the .ssh/ directory in the user's root and press enter"
read ignore_me
echo "Initializing SSH"
scp -P 23 /root/.ssh/id_ed25519.pub "${BACKUP_USER}@${BACKUP_USER}.your-storagebox.de:.ssh/"

echo ""
echo "Initializing borg repository"
source ~/.backupdronerc
REPOSITORY="ssh://${BACKUP_USER}@${BACKUP_USER}.your-storagebox.de:23/${BACKUP_FOLDER}"
borg init --encryption=repokey "$REPOSITORY"

echo "Add the following line to crontab -e"
echo "0 0 * * * /usr/local/bin/backupdrone.sh > /dev/null 2>&1"