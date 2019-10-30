Crawler
==============================

## Create a shared volume (if none exists)

The volume is used by the applications that make up this project.

    docker volume create --name europeana_cc_lod_share

## Build

    docker-compose build

## Run container

    docker-compose run --rm crawler /bin/bash

## Make test call inside container

This should execute Java and write a test file to the shared volume

    ./ScriptTestDocker.sh
