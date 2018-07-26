#!/bin/bash

adduser leo
adduser leo sudo
mkdir /home/leo/.ssh
cp /root/.ssh/authorized_keys /home/leo/.ssh/authorized_keys
chown leo:leo /home/leo/.ssh/authorized_keys

echo "Replace the following in /etc/sudoers\n%sudo   ALL=(ALL:ALL) ALL\nwith\n%sudo  ALL=(ALL) NOPASSWD:ALL"
