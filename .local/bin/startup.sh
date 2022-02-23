#!/bin/bash
# Postgres
cd /home/fabio/.docker/postgres
docker-compose up -d

# Nginx
cd /home/fabio/.docker/nginx
docker-compose up -d
