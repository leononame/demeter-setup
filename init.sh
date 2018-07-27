#!/bin/bash

# first update
apt update && apt upgrade

# create user leo who can use nopasswd root
adduser leo --disabled-password
echo "leo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# generate ssh config
mkdir /home/leo/.ssh
cp /root/.ssh/authorized_keys /home/leo/.ssh/authorized_keys
chown -R leo:leo /home/leo/.ssh

# copy configuration
cp -arf data/. /

service ssh restart