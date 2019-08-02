#!/bin/sh

set -e

if [ -z $VIRTUOSO_USERNAME ] || [ -z $VIRTUOSO_PASSWORD ] || [ -z $VIRTUOSO_ENDPOINT ]; then
    echo "Error: missing environment variables 'VIRTUOSO_USERNAME', 'VIRTUOSO_PASSWORD', 'VIRTUOSO_ENDPOINT'"
    exit 1
fi

dirWithRawFiles="/opt/data/kb/raw"
dirWithEdmFiles="/opt/data/kb/edm"
filename="centsprenten.nt"
graphUriRaw="http://data.bibliotheken.nl/centsprenten/"
graphUriEdm="http://data.bibliotheken.nl/centsprenten_edm/"
providerEndpoint="http://data.bibliotheken.nl/sparql"

mkdir -p $dirWithRawFiles
mkdir -p $dirWithEdmFiles

scriptsDir="$(dirname "$(readlink -f "$0")")"

echo "====================="
echo "Downloading triples from $providerEndpoint"
echo "====================="

curl --data-urlencode "query@$scriptsDir/centsprenten.rq" \
     --url $providerEndpoint \
     --header "Accept: text/ntriples" \
     > $dirWithRawFiles/$filename

echo "====================="
echo "Loading triples into graph $graphUriRaw of $VIRTUOSO_ENDPOINT"
echo "====================="

curl --digest --user $VIRTUOSO_USERNAME:$VIRTUOSO_PASSWORD \
     --url "$VIRTUOSO_ENDPOINT/sparql-graph-crud-auth" \
     --get --data-urlencode "graph-uri=$graphUriRaw" \
     --upload-file $dirWithRawFiles/$filename

echo "====================="
echo "Mapping triples from graph $graphUriRaw to graph $graphUriEdm of $VIRTUOSO_ENDPOINT"
echo "====================="

curl --digest --user $VIRTUOSO_USERNAME:$VIRTUOSO_PASSWORD \
     --url "$VIRTUOSO_ENDPOINT/sparql-auth" \
     --data-urlencode "query@$scriptsDir/mapping_cp.rq" \
     --show-error --output /dev/null

echo "====================="
echo "Downloading triples in graph $graphUriEdm from $VIRTUOSO_ENDPOINT"
echo "====================="

curl --digest --user $VIRTUOSO_USERNAME:$VIRTUOSO_PASSWORD \
     --url "$VIRTUOSO_ENDPOINT/sparql-graph-crud-auth" \
     --get --data-urlencode "graph-uri=$graphUriEdm" \
     --header "Accept: text/ntriples" \
     > $dirWithEdmFiles/$filename
