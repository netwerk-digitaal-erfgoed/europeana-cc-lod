Virtuoso for the Europeana Common Culture LOD aggregation pilot
==============================

## Development

### Create a shared volume (if none exists)

    docker volume create --name shared

### Create .env file

    vi .env

Put your preferred Virtuoso settings in `.env`. For example:

    DBA_PASSWORD=myPassword
    DEFAULT_GRAPH=http://example.org/#
    SPARQL_UPDATE=true
    VIRT_Parameters_DirsAllowed=/data, ., /dumps, /usr/local/virtuoso-opensource/share/virtuoso/vad

For more information about the possible settings: https://github.com/tenforce/docker-virtuoso/blob/master/virtuoso.ini

### Build and start container

    docker-compose build --no-cache
    docker-compose up

Go to `http://localhost:8890/` for the web interface.

### Logon to container

    docker exec -it -u root $(docker ps --filter name=virtuoso -q) /bin/bash

Now you can do the usual Virtuoso stuff. For example:

    isql-v -U dba
    SPARQL LOAD "http://www.w3.org/ns/prov.ttl" INTO GRAPH <http://example.org/#>;
    SPARQL SELECT * FROM <http://example.org/#> WHERE {?s ?p ?o} LIMIT 10;
    SPARQL CLEAR GRAPH <http://example.org/#>;

    # Bulk load RDF files (http://vos.openlinksw.com/owiki/wiki/VOS/VirtBulkRDFLoader)
    echo 'http://example.org/#' > /dumps/global.graph
    ld_dir('/dumps', '*.ttl', 'http://example.org/#');
    select * from DB.DBA.load_list;
    rdf_loader_run(log_enable=>3);
    checkpoint;

    # Or per file
    ttlp(file_to_string_output('/dumps/someFile.ttl'), '', 'http://example.org/#', 0);

### API

For example:

    # Load Turtle file into graph
    curl -v -L http://www.w3.org/ns/prov.ttl > prov.ttl
    curl -v --user {username}:{password} --url "http://localhost:8890/sparql-graph-crud-auth?graph-uri=http%3A%2F%2Fexample.org%2F%23" -T prov.ttl

    # Query the graph
    curl -v --url "http://localhost:8890/sparql-graph-crud?graph-uri=http%3A%2F%2Fexample.org%2F%23"

For more information about the API: http://vos.openlinksw.com/owiki/wiki/VOS/VirtGraphProtocolCURLExamples
