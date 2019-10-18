Crawler
==============================

## Development

## Create a shared volume (if none exists)

The volume is used by the applications that make up this project.

    docker volume create --name europeana_cc_lod_share

### Build

    docker-compose build

### Login to non-running container

    docker-compose run --rm crawler /bin/bash

### Test call (should execute Java and write a test file to the shared volume)

    ./ScriptTestDocker.sh
