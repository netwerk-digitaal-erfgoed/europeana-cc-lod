#!/bin/sh

set -e

date=`date '+%Y%m%d%H%M%S'`

cd /usr/src/app/scripts

curl -v -H "Accept: text/ntriples" --data-urlencode "query@centsprenten.rq" http://data.bibliotheken.nl/sparql > /import/centsprenten.nt