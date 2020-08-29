#!/bin/bash
#/home/fabio/./preroute.sh

# Change max user watches
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

# Start Services
# service postgresql start
# service mysql start
/etc/init.d/docker start
sleep 2
#service nginx start

# Start Docker Containers 
# docker start pgadmin
# docker start myadmin
# Postgres
cd ~/.docker/postgres
docker-compose up -d

cd ~/.docker/nginx
docker-compose up -d
