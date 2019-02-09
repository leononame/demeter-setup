#!/bin/bash

echo -n "IP Address of server: "
read IP
# Remove IP from known hosts as this is a new server
sed -i "" "/$IP/d" ~/.ssh/known_hosts
# Create archive
tar czf setup.tar.gz *
# Copy data
scp setup.tar.gz root@$IP:~
# Execute
ssh root@$IP 'mkdir setup; tar xzf setup.tar.gz -C ./setup; cd setup;'
# Done, cleanup
rm -f setup.tar.gz