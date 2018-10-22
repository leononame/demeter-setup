#!/bin/bash

apt-get install -y nginx

# Docker
echo "Installing packages for docker"
apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
     borgbackup

echo ""
echo "Generating ssh key"
ssh-keygen -t ed25519 -N "" -f "/root/.ssh/id_ed25519"

echo ""
echo "Importing docker key"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce

curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

sudo apt-get install -y certbot python-certbot-nginx
mkdir -p /var/www/letsencrypt

echo "Don't forget to get your certificates. Run:"
echo "sudo certbot --authenticator webroot --installer nginx"
echo "Public ssh key, don't forget to add to storage box:"
cat /root/.ssh/id_ed25519.pub