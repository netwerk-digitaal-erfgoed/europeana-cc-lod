#!/bin/bash

set -e

scripts_dir=$(cd $(dirname $0) && pwd -P)
source $scripts_dir/utils.sh

# Parse command line arguments
while [[ "$#" > 1 ]]; do case $1 in
    --data_dir) data_dir="$2";;
    --input_file) input_file="$2";;
    --mappings_dir) mappings_dir="$2";;
    --mapping_file) mapping_file="$2";;
    --graph_raw) graph_raw="$2";;
    --graph_edm) graph_edm="$2";;
    *) break;;
    esac; shift; shift
done

check_arg_and_exit_on_error "data_dir" $data_dir
check_arg_and_exit_on_error "input_file" $input_file
check_arg_and_exit_on_error "mappings_dir" $mappings_dir
check_arg_and_exit_on_error "mapping_file" $mapping_file
check_arg_and_exit_on_error "graph_raw" $graph_raw
check_arg_and_exit_on_error "graph_edm" $graph_edm

log_file=$data_dir/run.log
rm -f $log_file
mkdir -p $data_dir

$scripts_dir/load_data.sh --data_dir $data_dir --input_file $input_file --graph_raw $graph_raw >> $log_file

$scripts_dir/map_data.sh --mappings_dir $mappings_dir --mapping_file $mapping_file --graph_edm $graph_edm >> $log_file

$scripts_dir/store_data.sh --data_dir $data_dir --input_file $input_file --graph_edm $graph_edm >> $log_file
