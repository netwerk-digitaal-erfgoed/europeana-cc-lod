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

checkArgAndExitOnError "data_dir" $data_dir
checkArgAndExitOnError "input_file" $input_file
checkArgAndExitOnError "mappings_dir" $mappings_dir
checkArgAndExitOnError "mapping_file" $mapping_file
checkArgAndExitOnError "graph_raw" $graph_raw
checkArgAndExitOnError "graph_edm" $graph_edm

rm -rf $data_dir/run.log

$scripts_dir/load_data.sh --data_dir $data_dir --input_file $input_file --graph_raw $graph_raw >> $data_dir/run.log

$scripts_dir/map_data.sh --mappings_dir $mappings_dir --mapping_file $mapping_file --graph_edm $graph_edm >> $data_dir/run.log

$scripts_dir/store_data.sh --data_dir $data_dir --input_file $input_file --graph_edm $graph_edm >> $data_dir/run.log
