#!/bin/bash

cp mailu.env "/var/www/${APP_NAME}/"

echo -n "IPv4 to bind mail service to: "
read IPV4_ADDRESS
echo -n "IPv6 to bind mail service to: "
read IPV6_ADDRESS

echo "IPV4_ADDRESS=${IPV4_ADDRESS}" >> "/var/www/${APP_NAME}/.env"
echo "IPV6_ADDRESS=${IPV6_ADDRESS}" >> "/var/www/${APP_NAME}/.env"

if [ ! -f "${DATA_DIR}/webmail/roundcube/config/config.php" ]; then
    mkdir -p "${DATA_DIR}/webmail/roundcube/config/"
    cp config/config.php "${DATA_DIR}/webmail/roundcube/config/"
fi

if [! -f "${DATA_DIR}/overrides/dovecot.conf" ]; then
    mkdir -p "${DATA_DIR}/overrides/"
    cp config/dovecot.conf "${DATA_DIR}/overrides/"
fi