# Demeter setup

This is my simple setup script for a new server

```bash
scp -r ./demeter-setup demeter:~
ssh demeter
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