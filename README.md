# Demeter setup

This is my simple setup script for a new server

```bash
scp -r ./demeter-setup demroot:~
ssh demroot
cd demeter-setup
./init.sh
```

# Manual installation of docker

```bash
echo "Installing packages for docker"
apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common \
     sysvinit-core

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
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
```

# Rocket chat

* [Click here](https://rocket.chat/docs/installation/docker-containers/index.htmlzs)
