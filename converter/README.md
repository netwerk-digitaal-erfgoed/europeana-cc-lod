LOD-to-LOD conversion tool
==============================

Created for the Europeana Common Culture LOD aggregation pilot.

Setup based on SPARQL UPDATE queries on Virtuoso endpoint.

## Create the `.env` file

    cd ./converter
    cp env.dist .env

## Store your raw RDF dataset

Copy your dataset to the `data` directory, e.g.:

    cp /path/to/my_dataset.ttl ./data

## Create a SPARQL mapping query

Create a file with a SPARQL query that describes the mapping:

    touch ./mappings/my_mapping.rq

Replace `my_mapping.rq` with your preferred filename.

Use `./mappings/examples/template.rq` as a starting point. For inspiration, have a look at a mapping query of the National Library of the Netherlands (KB), `./mappings/examples/kb_schema2edm.rq`.

Make sure that your mapping query contains two graph names: a graph for storing the raw data (`http://example.org/raw/`)
and a graph for storing the converted data (`http://example.org/edm/`). The LOD conversion, later on, assumes these graphs exist.

## Create a shared volume (if none exists)

The volume is used by the applications that make up this project.

    docker volume create --name europeana_cc_lod_share

## Build the container

    docker-compose build --no-cache

## Start the container in background mode

    docker-compose up -d

Check `http://localhost:8890/sparql` or `http://localhost:8890/conductor` to see whether Virtuoso is alive.

## Run the conversion

This script loads the input file, runs the mapping and stores the data into an output file in the `data` directory:

    docker exec -it converter /bin/bash /opt/converter/scripts/convert.sh \
        --input-file /opt/converter/data/my_dataset.ttl \
        --mapping-file /opt/converter/mappings/my_mapping.rq \
        --output-dir /opt/converter/data/converted

Replace the command line arguments with the names of your files. Note that the paths to these files are relative to the Docker container, *not* your localhost.

Check file `./data/converted/run.log` if you would like to inspect the output of the run.

Alternatively, you can convert data that has been prepared by the crawler. This data resides in the shared directory `/opt/europeana_cc_lod_share/crawled`:

    docker exec -it converter /bin/bash /opt/converter/scripts/convert.sh \
        --input-file /opt/europeana_cc_lod_share/crawled/centsprenten.nt \
        --mapping-file /opt/converter/mappings/my_mapping.rq \
        --output-dir /opt/europeana_cc_lod_share/converted

## Stop the container

    docker-compose stop

## Troubleshooting and advanced configuration

### Remove cached database to do a clean start

    docker volume rm converter_virtuoso_db

NB: The volume keeps the data even after a rebuild, removing manually is neccessary to do a real clean start.

### Run a shell on the container for debugging

    docker exec -it converter /bin/bash

### Set the password for the sysadmin account in Virtuoso

    DBA_PASSWORD=myPassword # Default is DBA

### Optional additional parameters for tuning Virtuoso

NB: the current parameters are tuned for an 8Gb environment.

    VIRT_Parameters_DirsAllowed=.,../vad,/opt/converter,/opt/europeana_cc_lod_share

For more information about the possible settings: http://docs.openlinksw.com/virtuoso/dbadm/

## Test the converter

This script will read the directories in `tests` and attempt to convert each `dataset.ttl` with mapping `mapping.rq` to an output file that matches the contents of `expected.dataset.ttl`.

    docker exec -it converter /bin/bash /opt/converter/tests/test-conversion.sh
