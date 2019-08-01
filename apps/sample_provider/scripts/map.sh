#!/bin/bash
url="http://localhost:8890/sparql-auth"
user="cclod"
password="cclod2019"
curl_opts=(
    --digest
    --insecure
    --user $user:$password
    --data-urlencode "query@mapping_cp.rq"
)

curl "${curl_opts[@]}" "$url"