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