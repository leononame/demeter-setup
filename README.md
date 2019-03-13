# Demeter setup

This repository contains a simple setup script for a fresh Debian server. First, upload the repository to the server running `upload.sh`, then ssh into the server and execute `./init.sh` inside `~/setup`.

# Manual installation of docker

Always keep this up to date
```bash
curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

# TODO

- Store certificates in /mnt/data or wherever the data folder is instead of /etc/mailucerts
- Only use it as a post hook for mailu