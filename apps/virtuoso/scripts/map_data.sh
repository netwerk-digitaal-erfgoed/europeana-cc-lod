#!/bin/bash

set -e

scripts_dir=$(cd $(dirname $0) && pwd -P)
source $scripts_dir/utils.sh

# Parse command line arguments
while [[ "$#" > 1 ]]; do case $1 in
    --mappings_dir) mappings_dir="$2";;
    --mapping_file) mapping_file="$2";;
    --graph_edm) graph_edm="$2";;
    *) break;;
    esac; shift; shift
done

checkArgAndExitOnError "mappings_dir" $mappings_dir
checkArgAndExitOnError "mapping_file" $mapping_file
checkArgAndExitOnError "graph_edm" $graph_edm
checkEnvAndExitOnError "DBA_PASSWORD", $DBA_PASSWORD

printProgress "Mapping data using '$mapping_file' in directory '$mappings_dir'..."

# For the mapping use the SPARQL insert query in the mapping file
isql 1111 dba $DBA_PASSWORD $mappings_dir/$mapping_file

printProgress "Mapped data into graph '$graph_edm'"
