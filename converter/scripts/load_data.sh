#!/bin/bash

set -e

scripts_dir=$(cd $(dirname $0) && pwd -P)
source $scripts_dir/utils.sh

# Parse command line arguments
while [[ "$#" > 1 ]]; do case $1 in
    --input-file) input_file="$2";;
    --graph-raw) graph_raw="$2";;
    *) break;;
    esac; shift; shift
done

check_arg_and_exit_on_error "input-file" $input_file
check_arg_and_exit_on_error "graph-raw" $graph_raw
check_env_and_exit_on_error "DBA_PASSWORD" $DBA_PASSWORD

print_progress "Loading data from '$input_file'..."

# Explicitly check file - isql does not report errors in case of missing files
if [ ! -f "$input_file" ]; then
    print_error_and_exit "Input file '$input_file' does not exist"
fi

input_dir=$(dirname "$input_file")
basename_input_file=$(basename "$input_file")

# First remove old data, if any, than load the new data
isql 1111 dba $DBA_PASSWORD <<EOF
SPARQL DROP SILENT GRAPH <$graph_raw>;
-- Delete previous loader list, if any
DELETE FROM DB.DBA.load_list;
ld_dir('$input_dir', '$basename_input_file', '$graph_raw');
rdf_loader_run(log_enable=>3);
checkpoint;
-- Check for errors in the loader list
SELECT * FROM DB.DBA.load_list WHERE ll_state <> 2;
EOF

print_progress "Loaded data into graph '$graph_raw'"
