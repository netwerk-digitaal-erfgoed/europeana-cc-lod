#!/bin/bash

set -e

scripts_dir=$(cd $(dirname $0) && pwd -P)
source $scripts_dir/utils.sh

# Parse command line arguments
while [[ "$#" > 1 ]]; do case $1 in
    --data_dir) data_dir="$2";;
    --input_file) input_file="$2";;
    --graph_edm) graph_edm="$2";;
    *) break;;
    esac; shift; shift
done

checkArgAndExitOnError "data_dir" $data_dir
checkArgAndExitOnError "input_file" $input_file
checkArgAndExitOnError "graph_edm" $graph_edm
checkEnvAndExitOnError "DBA_PASSWORD", $DBA_PASSWORD

output_base_name=$(echo "$input_file" | cut -f 1 -d '.')"_edm"

printProgress "Storing data in graph '$graph_edm' into files ${output_base_name}*.ttl..."

# Load a stored procedure for dumping a graph to a Turtle file
isql 1111 dba $DBA_PASSWORD ${scripts_dir}/dump_one_graph.sql

# Use the stored procedure to dump the data (in multiple Turtle files if needed)
isql 1111 dba $DBA_PASSWORD << EOF
dump_one_graph('$graph_edm','$data_dir/$output_base_name',100000000);
EOF

printProgress "Stored data in graph '$graph_edm' into files in directory '$data_dir'"
