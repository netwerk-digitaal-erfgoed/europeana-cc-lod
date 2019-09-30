#!/bin/bash

set -e

scripts_dir=$(cd $(dirname $0) && pwd -P)
source $scripts_dir/utils.sh

# Parse command line arguments
while [[ "$#" > 1 ]]; do case $1 in
    --data_dir) data_dir="$2";;
    --input_file) input_file="$2";;
    --graph_raw) graph_raw="$2";;
    *) break;;
    esac; shift; shift
done

checkArgAndExitOnError "data_dir" $data_dir
checkArgAndExitOnError "input_file" $input_file
checkArgAndExitOnError "graph_raw" $graph_raw
checkEnvAndExitOnError "DBA_PASSWORD" $DBA_PASSWORD

printProgress "Loading data from '$input_file' in directory '$data_dir'..."

# Start the Virtuoso commandline mode
isql 1111 dba $DBA_PASSWORD <<EOF
ld_dir('$data_dir','$input_file','$graph_raw');
rdf_loader_run(log_enable=>3);
checkpoint;
exit;
EOF

printProgress "Loaded data into graph '$graph_raw'"
