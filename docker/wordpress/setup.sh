#!/bin/bash

mkdir -p /var/www/wordpress
cp docker-compose.yml /var/www/wordpress

# setup nginx
ln -s -T /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/wordpress
rm /etc/nginx/sites-enabled/default

echo "Launching docker containers for Wordpress. This operation may take a while."

sudo service nginx restart
cd /var/www/nextcloud
sudo docker-compose up -d