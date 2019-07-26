Sample project for creating and sharing data between apps
==============================

## Development

### Create a shared volume (if none exists)

    docker volume create --name shared

### Build container

    docker-compose build --no-cache

### Download some data, write to shared volume

    docker-compose run --rm provider ./scripts/download.sh

### Logon to container

    docker-compose run --rm provider /bin/sh
