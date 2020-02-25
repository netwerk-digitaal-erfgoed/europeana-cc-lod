LOD-EDM validator tool  !! WORK IN PROGRESS !!
==============================================

Created for the Europeana Common Culture LOD aggregation pilot.

Validation of the harvested and converted LOD-EDM data use ShEx shape constraints. 

See ./scripts/edm_validation.shex for more details or https://book.validatingrdf.com/bookHtml010.html#sec69 for more background information.  

The docker setup is based on the https://github.com/hsolbrig/PyShEx project. 

## Create a SPARQL mapping query

Create a ShEx shape expressions defintion (or use the default `edm_validation.shex`) in ./scripts:

    touch ./scripts/my_validation.shex

Replace `my_validation.shex` with your preferred filename.


## Build the container

    docker-compose build --no-cache


## Run the validator

This command runs the validator on with the focus on all subject (-A) in the RDF input file 
against the ShEx expressions described in the specified ShEx (.shex) file:

Validation off a local input file (in turtle) in ./scripts:

    docker-compose run --rm validator shexeval -A \ 
        /opt/scripts/my_inputfile.ttl \
        /opt/scripts/edm_validation.shex

Validation off an input file (in turtle) in the shared volume (see crawler/converter docs):

    docker-compose run --rm validator shexeval -A \ 
        /opt/europeana_cc_lod_share/converted/centsprenten_edm_000001.ttl \
        /opt/scripts/edm_validation.shex

The validator generates error messages when the data is not compliant with the defined constraints.

The default complaint about
`ANTLR runtime and generated code versions disagree: 4.8!=4.7.1`
can be ignored.