# Demeter setup

This is my simple setup script for a new server

```bash
scp -r ./demeter-setup demroot:~
ssh demroot
cd demeter-setup
./init.sh
```

# TODOs

- Unify setup and backup scripts with a template (working version so far in drone)
- Autocreate SSH dirs for Storage Boxes and copy ssh key over there
- Create Nginx configs dynamicalley (prompt for domain)

# Manual installation of docker

```bash
echo "Installing packages for docker"
apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common 
     
echo ""
echo "Importing docker key"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce
```

Always keep this up to date
```bash
curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```
