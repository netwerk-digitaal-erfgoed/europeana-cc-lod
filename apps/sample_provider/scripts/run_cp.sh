#!/bin/sh

set -e

if [ -z $VIRTUOSO_USERNAME ] || [ -z $VIRTUOSO_PASSWORD ] || [ -z $VIRTUOSO_ENDPOINT ]; then
    echo "Error: missing environment variables 'VIRTUOSO_USERNAME', 'VIRTUOSO_PASSWORD', 'VIRTUOSO_ENDPOINT'"
    exit 1
fi

function urlencode() {
    local url
    url="$(curl -s -o /dev/null -w %{url_effective} --get --data-urlencode "$1" "")"
    echo ${url:1} # Omit leading slash
    return 0
}

scriptsDir="$(dirname "$(readlink -f "$0")")"
providerGraphUri="http://data.bibliotheken.nl/centsprenten/"
providerEndpoint="http://data.bibliotheken.nl/sparql"
queryString="$(urlencode "graph-uri=$providerGraphUri")"

mkdir -p /import/kb

echo "====================="
echo "Downloading triples from $providerEndpoint"
echo "====================="

curl -H "Accept: text/ntriples" --data-urlencode "query@$scriptsDir/centsprenten.rq" $providerEndpoint > /import/kb/centsprenten.nt

echo "====================="
echo "Loading triples into graph $providerGraphUri of $VIRTUOSO_ENDPOINT"
echo "====================="

curl --digest --user $VIRTUOSO_USERNAME:$VIRTUOSO_PASSWORD --url "$VIRTUOSO_ENDPOINT/sparql-graph-crud-auth$queryString" -T /import/kb/centsprenten.nt

echo "====================="
echo "Mapping triples in graph $providerGraphUri of $VIRTUOSO_ENDPOINT"
echo "====================="

curl --digest --user $VIRTUOSO_USERNAME:$VIRTUOSO_PASSWORD --url "$VIRTUOSO_ENDPOINT/sparql-auth" --data-urlencode "query@$scriptsDir/mapping_cp.rq" --show-error --output /dev/null
