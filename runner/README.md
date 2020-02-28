Runner
==============================

## Crawl and convert a dataset in one go

    ./runner.sh \
        --dataset-uri {uri_of_dataset_description} \
        --mapping-file /opt/converter/mappings/{your_mapping_file}.rq
        --output-dir {/path/to/converted/files/}

Note the path to your mapping file: `/opt/converter/mappings`. This path is relative to the Docker container, *not* your localhost. The `output-dir`, however, is a directory on your localhost.

For example:

    ./runner.sh \
        --dataset-uri http://data.bibliotheken.nl/id/dataset/rise-centsprenten \
        --mapping-file /opt/converter/mappings/examples/kb_schema2edm.rq \
        --output-dir /tmp
