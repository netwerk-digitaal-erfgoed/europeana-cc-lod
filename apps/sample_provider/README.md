Sample project for downloading, loading and mapping triples from a provider to CC-LOD's triplestore
==============================

## Development

### Create .env file

    vi .env

Put your settings in `.env`. For example:

    VIRTUOSO_USERNAME=dba
    VIRTUOSO_PASSWORD=myPassword
    VIRTUOSO_ENDPOINT=http://localhost:8890

### Build container

    docker-compose build --no-cache

### Download, load and map triples

    docker-compose run --rm provider ./scripts/run_cp.sh

### Logon to container

    docker-compose run --rm provider /bin/sh
