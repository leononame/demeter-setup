#!/bin/bash

if [ -z $LOG ]; then
    LOG=setup.log
fi

name=$1
folder="services/$name"

if [ -z "$name" ]; then
    >&2 echo "No service specified"
    exit 1
fi

if [ ! -d "$folder" ]; then
    >&2 echo "Service $name does not exist"
    exit 1
fi

if [ ! -f "$folder/docker-compose.yml" ]; then
    >&2 echo "Service $name doesn't specify a docker-compose file"
    exit 1
fi

if [ ! -f "$folder/.env" ]; then
    >&2 echo "Service $name doesn't specify a .env file"
    exit 1
fi

# Service can specify some options (like NGINX_OPTIONS)
if [ -f "$folder/options" ]; then
    source "$folder/options"
fi

# =====================
# Read env
# =====================
echo ""
echo "================================"
echo "Service $name"
echo "================================"
# Application name and domain
echo -n "Application name: "
read APP_NAME
echo -n "Domain: "
read DOMAIN_NAME
# All application data will be mounted here as a docker volume
echo -n "Data directory: [/mnt/data/${APP_NAME}] "
read DATA_DIR
if [ -z $DATA_DIR ]; then
    DATA_DIR=/mnt/data/${APP_NAME}
fi
mkdir -p $DATA_DIR
# Backup data for borg
echo -n "User for storage box backups: "
read BACKUP_USER
echo -n "Passphrase: "
read BACKUP_PASSPHRASE
# Target directory in storage box defaults to data
if [ -z "$TARGET_DIR" ]; then
    TARGET_DIR=data
fi

# =====================
# Create templates
# =====================
echo ""
echo "Creating templates"
export APP_NAME
export DOMAIN_NAME
export DATA_DIR
export BACKUP_USER
export BACKUP_PASSPHRASE
# We have to specify NGINX_OPTIONS separately in case it's not defined
export NGINX_OPTIONS=$NGINX_OPTIONS
# docker-compose
echo "Template docker-compose"
mkdir -p "/var/www/${APP_NAME}"
j2 -f env "$folder/docker-compose.yml" > "/var/www/${APP_NAME}/docker-compose.yml"
cp "$folder/.env" "/var/www/${APP_NAME}"
# nginx
echo "Template nginx"
j2 -f env "templates/nginx" > "/etc/nginx/sites-available/${APP_NAME}"
ln -s -T "/etc/nginx/sites-available/${APP_NAME}" "/etc/nginx/sites-enabled/${APP_NAME}"
unset NGINX_OPTIONS

if [ -f "$folder/setup.sh" ]; then
    pushd $folder
    source setup.sh
    popd
fi

# =====================
# Backup
# =====================
echo ""
echo "Initializing backups"
# backup current dir
pushd ./
# create temporary dir and mirror structure
mkdir -p ~/tmp/.ssh
cp ~/.ssh/id_ed25519.pub ~/tmp/.ssh/authorized_keys
cd ~/tmp
# copy to backup location
echo "Upload ssh dir to storage box"
scp -q -P 23 -r .ssh ${BACKUP_USER}@${BACKUP_USER}.your-storagebox.de:./
# remove temp dir
cd ~
rm -rf tmp
# Go back to where you were before
popd

# Substitute templates
echo "Create systemd timer"
SOURCE_DIR="$DATA_DIR" j2 -f env templates/borgmatic.yaml > "${APP_NAME}.yaml"
j2 -f env templates/backup.service > "backup-${APP_NAME}.service"
j2 -f env templates/backup.timer > "backup-${APP_NAME}.timer"
# Move templates to target
echo "Moving data"
mv "${APP_NAME}.yaml" /etc/borgmatic.d
mv "backup-${APP_NAME}.service" "backup-${APP_NAME}.timer" /etc/systemd/system/

echo -n "Initialize borg with new repository? [y/N]"
read init
if [ "$init" == "y" ]; then
    # Initialize Backup repository
    echo "Initializing borg repository: "
    borgmatic -c "/etc/borgmatic.d/${APP_NAME}.yaml" -v1 -I -e repokey >> $LOG
fi

# Enable backup timer
echo "Enabling backup timer"
systemctl enable "backup-${APP_NAME}.timer"
systemctl start "backup-${APP_NAME}.timer"
