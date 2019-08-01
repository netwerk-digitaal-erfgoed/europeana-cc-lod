!#/bin/bash
ENDPOINT=http://data.bibliotheken.nl/sparql
curl -H "Accept: text/ntriples" --data-urlencode "query@centsprenten.rq" $ENDPOINT