LOD to LOD mapping tool 
==============================

Created for the Europeana Common Culture LOD aggregation pilot.

Setup based on SPARQL UPDATE queries on Virtuoso endpoint.

## Install the `.env` file

    cp env.dist .env

## Configure `.env` for your mapping task

    set the following parameters:

    ## name of the source file in to convert 
    ## ntriples is expected as input format

    filename=nbt.nt

    ## name of the graph to load the data into (will be created if necessary)
    
    dest_graph=http://data.bibliotheken.nl/raw/
    edm_graph=http://data.bibliotheken.nl/edm/

    ## mapping query 
    
    mapping_query=schema2edm.rq

    ## host / container directories should align to docker-compose.yml
    
    data_dir_host=./data
    mappings_dir_host=./data
    
    ## changing these require also to change the VIRT_DIRS_ALLOW parameter

    data_dir=/opt/data
    mappings_dir=/opt/mappings
    scripts_dir=/opt/scripts


## Create a SPARQL conversion query

    Create a file with SPARQL query that describes the conversion.
    Use the 'template.rq' in the mappings directory as a starting point.

    Have a look at the schema2edm.rq in the KB dir for inspiration.


## Build the Virtuoso image

    $ docker-compose build --no-cache



## Start Virtuoso in background mode

    $ docker-compose up -d 
    
    Check `http://localhost:8890/sparql` or `http://localhost:8890/conductor` to Virtuoso alive!



## Run the conversion script. 
    
    This script loads the inputfile, runs the conversion and 
    writes the EDM data into an outputfile in de the data dir, all in one run...

    $ docker exec -it virtuoso /opt/scripts/run_all.sh 



## Stop the Virtuoso container

    docker-compose down



## Remove cached datatbase to do a clean start

    docker volume rm virtuoso_virtuoso_db

    NB: The volume keeps the data even after a rebuild, 
        removing manually is neccessary to do a real clean start 
    



### Run a shell on the container for debugging

    docker exec -it virtuoso /bin/bash



## Set the password for the sysadmin account in Virtuoso

    DBA_PASSWORD=myPassword (default is DBA)



## Optional additional parameters for tuning Virtuoso. 

    NB: the current parameters are tuned for an 8Gb environment.

    VIRT_Parameters_DirsAllowed=.,../vad,/opt/data,/opt/mappings

    For more information about the possible settings: http://docs.openlinksw.com/virtuoso/dbadm/