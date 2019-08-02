Sample project for downloading, loading and mapping triples from a provider to CC-LOD's triplestore
==============================

## Development

### Set some configuration parameters

Adjust the following parameters in `run_cp.sh`, for example:

    VIRTUOSO_USERNAME=dba
    VIRTUOSO_PASSWORD=myPassword
    VIRTUOSO_ENDPOINT=http://localhost:8890

### Start download and mapping proces

    ./run_cp.sh

### See the results in the ./data dir

