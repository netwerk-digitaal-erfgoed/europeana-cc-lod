LOD-EDM validator tool  !! WORK IN PROGRESS !!
==============================================

Created for the Europeana Common Culture LOD aggregation pilot.

Validation of the harvested and converted LOD-EDM data using ShEx shape constraints.

See `./shapes/examples/edm_validation.shex` for more details or [Shape Expressions](https://book.validatingrdf.com/bookHtml010.html#sec69) for more information.

The Docker setup is based on the [PyShEx](https://github.com/hsolbrig/PyShEx) project.

## Create a ShEx definition

Create a ShEx shape expression definition in `./shapes` (or use `./shapes/examples/edm_validation.shex`):

    touch ./shapes/my_validation.shex

Replace `my_validation.shex` with your preferred filename.

## Build the container

    docker-compose build --no-cache

## Run the validator

This command runs the validator with the focus on all subjects (-A) in the RDF input file against the ShEx expressions described in the specified ShEx file (.shex).

Validation of a local input file (in Turtle) in `./data/examples`:

    docker-compose run --rm validator shexeval -A \
        /opt/validator/data/examples/edm_with_errors.ttl \
        /opt/validator/shapes/examples/edm_validation.shex

Validation of an input file (in Turtle) in the shared volume (see crawler/converter docs):

    docker-compose run --rm validator shexeval -A \
        /opt/europeana_cc_lod_share/converted/centsprenten_edm_000001.ttl \
        /opt/validator/shapes/examples/edm_validation.shex

The validator generates error messages when the data is not compliant with the defined constraints.

The default complaint about `ANTLR runtime and generated code versions disagree: 4.8!=4.7.1` can be ignored.
