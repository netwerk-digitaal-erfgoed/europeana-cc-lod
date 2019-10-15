#!/bin/bash

set -e

scripts_dir=$(cd $(dirname $0) && pwd -P)
source $scripts_dir/utils.sh

# Parse command line arguments
while [[ "$#" > 1 ]]; do case $1 in
    --input-file) input_file="$2";;
    --mapping-file) mapping_file="$2";;
    --output-dir) output_dir="$2";;
    --graph-raw) graph_raw="$2";;
    --graph-edm) graph_edm="$2";;
    *) break;;
    esac; shift; shift
done

check_arg_and_exit_on_error "input-file" $input_file
check_arg_and_exit_on_error "mapping-file" $mapping_file
check_arg_and_exit_on_error "output-dir" $output_dir

if [ -z $graph_raw ]; then
    graph_raw="http://example.org/raw/"
fi

if [ -z $graph_edm ]; then
    graph_edm="http://example.org/edm/"
fi

log_file=$output_dir/run.log
rm -f $log_file
mkdir -p $output_dir

$scripts_dir/load_data.sh --input-file $input_file --graph-raw $graph_raw >> $log_file

$scripts_dir/map_data.sh --mapping-file $mapping_file --graph-edm $graph_edm >> $log_file

$scripts_dir/store_data.sh --input-file $input_file --output-dir $output_dir --graph-edm $graph_edm >> $log_file
