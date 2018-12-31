#!/bin/bash

mkdir -p /var/www/wordpress
cp docker-compose.yml /var/www/wordpress
cp .env /var/www/wordpress
cp backupwp.sh /usr/local/bin
mkdir -p /mnt/data/wordpress/nginx/conf.d
cp wordpress.conf /mnt/data/wordpress/nginx/conf.d/

# setup nginx
ln -s -T /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress
rm /etc/nginx/sites-enabled/default

echo "Launching docker containers for Wordpress. This operation may take a while."

sudo service nginx restart
cd /var/www/wordpress
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
echo "export BACKUP_USER=$user" >> ~/.backupwprc
echo "export BACKUP_FOLDER=./$folder" >> ~/.backupwprc
echo "export BORG_PASSPHRASE=$pass" >> ~/.backupwprc

echo ""
echo "Initializing borg repository"
source ~/.backupwprc
REPOSITORY="ssh://${BACKUP_USER}@${BACKUP_USER}.your-storagebox.de:23/${BACKUP_FOLDER}"
borg init --encryption=repokey "$REPOSITORY"

echo "Add the following line to crontab -e"
echo "0 0 * * * /usr/local/bin/backupwp.sh > /dev/null 2>&1"