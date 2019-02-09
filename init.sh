#!/bin/bash

# Exit on error
set -e

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

echo "export LC_ALL=C" >> ~/.bashrc
echo "export LANGUAGE=en_US" >> ~/.bashrc
source ~/.bashrc

LOG="init.log"
KEY="/root/.ssh/id_ed25519"

aapt() {
    DEBIAN_FRONTEND=noninteractive apt-get -yq "$@" >> $LOG
}

# First update
echo -n "Updating system... "
aapt update
aapt upgrade
aapt install software-properties-common
echo "Done"

# Generate ssh key for root
echo -n "Generating ssh key... "
ssh-keygen -t ed25519 -N "" -f $KEY >> $LOG
echo "Done"

# Create user leo who can use nopasswd root
echo -n "Creating user leo... "
adduser leo --disabled-password --quiet --gecos ""
echo "leo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

## Copy key
mkdir /home/leo/.ssh
cp /root/.ssh/authorized_keys /home/leo/.ssh/authorized_keys
chown -R leo:leo /home/leo/.ssh
echo "Done"

# Import docker key
echo -n "Importing docker key: "
curl -fsSL https://download.docker.com/linux/debian/gpg | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=y apt-key add -

# Add docker repository
echo -n "Adding docker repository... "
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
echo "Done"

# Install packages
echo "Installing packages..."
aapt update
aapt install $(cat packages)
echo "Done"

# Install docker-compose
echo -n "Installing docker-compose... "
curl --silent -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
echo "Done"

# Install borgmatic
echo -n "Installing borgmatic and j2... "
pip3 -q install borgmatic j2cli
mkdir -p /etc/borgmatic.d/
echo "Done"

# SSH config
echo -n "Copying ssh config... "
cp ./data/ssh/sshd_config /etc/ssh/
service ssh restart
echo "Done"

# For each dir in service, generate options for whiptail,
# e.g. "nextcloud" "" off => service nextcloud, no description, off by default
opts=()
for i in services/*; do
    opts+=( ${i#"services/"} "" off)
done
# Show dialog to user
whiptail --separate-output --title "Please select the services to install:" --checklist "" 20 60 10 "${opts[@]}" 2>results

# Iterate over results
choices=`<results`
PORT_NUM=8080
for choice in $choices; do
    PORT_NUM=$PORT_NUM ./setup.sh $choice
    PORT_NUM=$((PORT_NUM+1))
done

echo ""
echo "================================"
echo "Configuration is ready"
echo "================================"

echo -n "Restarting nginx... "
if [ -f /etc/nginx/sites-enabled/default ]; then
    rm -f /etc/nginx/sites-enabled/default
fi
service nginx restart
echo "Done"

echo "================================"
echo "Finished"
echo "================================"
echo "Consider creating a swapfile"
echo "Don't forget to get your certificates. Run:"
echo "certbot --authenticator nginx --installer nginx --post-hook /usr/local/bin/copycerts"
echo "Your public ssh key is: "
cat /root/.ssh/id_ed25519.pub