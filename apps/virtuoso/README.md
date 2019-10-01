LOD-to-LOD conversion tool
==============================

Created for the Europeana Common Culture LOD aggregation pilot.

Setup based on SPARQL UPDATE queries on Virtuoso endpoint.

## Install the `.env` file

    cd ./apps/virtuoso
    cp env.dist .env

## Store your raw RDF dataset

Create a directory for storing your raw RDF dataset:

    mkdir -p ./data/example

Replace `example` with your identifier, e.g. the name of your organisation.

Copy your dataset to the above directory, e.g.:

    cp /path/to/my_dataset.ttl ./data/example

## Create a SPARQL conversion query

Create a directory for storing your mappings:

    mkdir -p ./mappings/example

Replace `example` with your identifier, e.g. the name of your organisation.

Create a file with a SPARQL query that describes the conversion:

    touch ./mappings/example/my_mapping.rq

Replace `my_conversion.rq` with your preferred filename.

Use `./mappings/template.rq` as a starting point. Have a look at `./mappings/KB/schema2edm.rq` for inspiration.

Make sure that your conversion query contains two graph names: a graph for storing the raw data (`http://example.org/raw/`)
and a graph for storing the converted data (`http://example.org/edm/`). The LOD conversion, later on, assumes these graphs exist.

## Build the Virtuoso image

    docker-compose build --no-cache

## Start Virtuoso in background mode

    docker-compose up -d

Check `http://localhost:8890/sparql` or `http://localhost:8890/conductor` to see whether Virtuoso is alive.

## Run the conversion

This script loads the input file, runs the mapping and stores the data into an output file in the `data/example` directory:

    docker exec -it virtuoso /bin/bash /opt/scripts/convert.sh \
        --input_file /opt/data/example/my_dataset.ttl \
        --mapping_file /opt/mappings/example/my_mapping.rq

Replace the command line arguments with the names of your files. Note that the paths to these files are relative to the Docker container, *not* your localhost.

Check file `./data/example/run.log` if you would like to inspect the output of the run, e.g. `cat ./data/example/run.log`

## Stop the Virtuoso container

    docker-compose down

## Troubleshooting and advanced configuration

### Remove cached database to do a clean start

    docker volume rm virtuoso_virtuoso_db

NB: The volume keeps the data even after a rebuild, removing manually is neccessary to do a real clean start.

### Run a shell on the container for debugging

    docker exec -it virtuoso /bin/bash

### Set the password for the sysadmin account in Virtuoso

    DBA_PASSWORD=myPassword # Default is DBA

### Optional additional parameters for tuning Virtuoso

NB: the current parameters are tuned for an 8Gb environment.

    VIRT_Parameters_DirsAllowed=.,../vad,/opt/data,/opt/mappings

For more information about the possible settings: http://docs.openlinksw.com/virtuoso/dbadm/
