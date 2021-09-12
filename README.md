# Demeter setup

This repository contains a simple setup script for a fresh Debian server. First, upload the repository to the server running `upload.sh`, then ssh into the server and execute `./init.sh` inside `~/setup`.

# Manual installation of docker

Always keep this up to date
```bash
curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```
