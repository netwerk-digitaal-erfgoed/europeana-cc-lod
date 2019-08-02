#!/bin/bash
set -e
docker-compose up -d 
docker exec -it virtuoso /opt/scripts/create_user.sh