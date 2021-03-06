#!/bin/bash

set -e

scripts_dir=$(cd $(dirname $0) && pwd -P)
source $scripts_dir/utils.sh

# Parse command line arguments
while [[ "$#" > 1 ]]; do case $1 in
    --mapping-file) mapping_file="$2";;
    --graph-edm) graph_edm="$2";;
    *) break;;
    esac; shift; shift
done

check_arg_and_exit_on_error "mapping-file" $mapping_file
check_arg_and_exit_on_error "graph-edm" $graph_edm
check_env_and_exit_on_error "DBA_PASSWORD", $DBA_PASSWORD

print_progress "Mapping data using '$mapping_file'..."

# Explicitly check file - makes debugging a lot easier
if [ ! -f "$mapping_file" ]; then
    print_error_and_exit "Mapping file '$mapping_file' does not exist"
fi

# Explicitly remove old data in the graph before loading new data
isql 1111 dba $DBA_PASSWORD <<EOF
SPARQL DROP SILENT GRAPH <$graph_edm>;
EOF

# For the mapping use the SPARQL insert query in the mapping file
isql 1111 dba $DBA_PASSWORD $mapping_file

print_progress "Mapped data into graph '$graph_edm'"
