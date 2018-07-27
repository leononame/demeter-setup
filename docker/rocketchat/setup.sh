mkdir -p /var/www/rocket.chat/data/runtime/db
mkdir -p /var/www/rocket.chat/data/dump

cp docker-compose.yml /var/www/rocket.chat/
cp *.service /lib/systemd/system/

systemctl enable rocketchat-mongo.service
systemctl start rocketchat-mongo.service
systemctl enable rocketchat-chat.service
systemctl start rocketchat-chat.service

# setup nginx
ln -s -T /etc/nginx/sites-available/chat /etc/nginx/sites-enabled/chat
rm /etc/nginx/sites-enabled/default
systemctl restart nginx.service

echo "Launching docker containers for MongoDB and RocketChat. This operation may take a while."