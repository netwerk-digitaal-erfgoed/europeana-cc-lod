#!/bin/bash

set -e

runner_dir=$(cd $(dirname $0) && pwd -P)
source $runner_dir/utils.sh

root_dir="$(dirname "$runner_dir")"
storage_volume=europeana_cc_lod_share
base_dir_data=/opt/$storage_volume

# Parse command line arguments
while [[ "$#" > 1 ]]; do case $1 in
    --dataset-uri) dataset_uri="$2";;
    --mapping-file) mapping_file="$2";;
    --output-dir) output_dir="$2";;
    *) break;;
    esac; shift; shift
done

check_arg_and_exit_on_error "dataset-uri" $dataset_uri
check_arg_and_exit_on_error "mapping-file" $mapping_file
check_arg_and_exit_on_error "output-dir" $output_dir

runId=`date '+%Y%m%d%H%M%S'`

##################

print_progress "Creating storage volume '$storage_volume'..."

docker volume create --name $storage_volume

##################

print_progress "Starting crawler with URI '$dataset_uri'..."

cd $root_dir/crawler

output_dir_crawler=$base_dir_data/crawled/run_$runId
output_file_crawler=$output_dir_crawler/dataset.nt

docker-compose run --rm crawler /bin/bash ./crawler.sh \
    -dataset_uri $dataset_uri \
    -output_file $output_file_crawler \
    -log_file run.log

##################

print_progress "Starting converter..."

cd $root_dir/converter

docker-compose --log-level ERROR up -d

# Virtuoso isn't instantly available, so wait a bit...
sleep 10

output_dir_converter=$base_dir_data/converted/run_$runId

docker exec -it converter /bin/bash /opt/converter/scripts/convert.sh \
    --input-file $output_file_crawler \
    --mapping-file $mapping_file \
    --output-dir $output_dir_converter

print_progress "Copying converted files to directory '${output_dir}'"

mkdir -p $$output_dir

docker cp converter:$output_dir_converter/. $output_dir

docker-compose down

##################

# Back to the directory where the script started
cd $runner_dir
