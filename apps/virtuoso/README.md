LOD-to-LOD mapping tool
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

Your conversion query will contain two graph names: a graph for storing the raw, unconverted data (e.g. `http://example.org/raw/`)
and a graph for storing the converted data (e.g. `http://example.org/edm/`).
Please remember the names of these graphs: you'll need them later on (see underneath).

## Build the Virtuoso image

    docker-compose build --no-cache

## Start Virtuoso in background mode

    docker-compose up -d

Check `http://localhost:8890/sparql` or `http://localhost:8890/conductor` to see whether Virtuoso is alive.

## Run the conversion script

This script loads the input file, runs the mapping and stores the data into an output file in the `data/example` directory:

    docker exec -it virtuoso /bin/bash /opt/scripts/run_all.sh \
        --data_dir /opt/data/example \
        --input_file my_dataset.ttl \
        --mappings_dir /opt/mappings/example \
        --mapping_file my_mapping.rq \
        --graph_raw http://example.org/raw/ \
        --graph_edm http://example.org/edm/

Replace the command line arguments with the names of your directories and files.

Check file `./data/example/run.log` if you would like to inspect the output of the run.

## Stop the Virtuoso container

    docker-compose down

## Remove cached database to do a clean start

    docker volume rm virtuoso_virtuoso_db

NB: The volume keeps the data even after a rebuild, removing manually is neccessary to do a real clean start.

## Run a shell on the container for debugging

    docker exec -it virtuoso /bin/bash

## Set the password for the sysadmin account in Virtuoso

    DBA_PASSWORD=myPassword (default is DBA)

## Optional additional parameters for tuning Virtuoso

NB: the current parameters are tuned for an 8Gb environment.

    VIRT_Parameters_DirsAllowed=.,../vad,/opt/data,/opt/mappings

For more information about the possible settings: http://docs.openlinksw.com/virtuoso/dbadm/
