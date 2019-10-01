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

check_arg_and_exit_on_error "data_dir" $data_dir
check_arg_and_exit_on_error "input_file" $input_file
check_arg_and_exit_on_error "graph_raw" $graph_raw
check_env_and_exit_on_error "DBA_PASSWORD" $DBA_PASSWORD

print_progress "Loading data from '$input_file' in directory '$data_dir'..."

# Check explicitly - isql does not report errors in case of missing files
if [ ! -f "$data_dir/$input_file" ]; then
    print_error_and_exit "File '$data_dir/$input_file' does not exist"
fi

# Start the Virtuoso commandline mode
isql 1111 dba $DBA_PASSWORD <<EOF
ld_dir('$data_dir','$input_file','$graph_raw');
rdf_loader_run(log_enable=>3);
checkpoint;
exit;
EOF

print_progress "Loaded data into graph '$graph_raw'"
