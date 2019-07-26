#!/bin/sh

set -e

date=`date '+%Y%m%d%H%M%S'`

curl -v -L http://www.w3.org/ns/prov.ttl > /import/prov_$date.ttl
