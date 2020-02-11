#!/bin/bash

set -e

tests_dir=$(cd $(dirname $0) && pwd -P)
parent_dir="$(dirname "$tests_dir")"
scripts_dir=$parent_dir/scripts
source $scripts_dir/utils.sh

function test_file() {
    local test_dir=$1
    local input_file=$test_dir/dataset.ttl
    local mapping_file=$test_dir/mapping.rq
    local expected_file=$test_dir/expected.dataset.ttl
    local output_dir=/tmp
    local output_file=$output_dir/dataset_edm_000001.ttl

    # Remove the output file of a previous run, if any
    rm -f $output_file

    $scripts_dir/convert.sh --input-file $input_file --mapping-file $mapping_file --output-dir $output_dir

    # Strip lines with comments
    diff -u -B <(grep -vE '^\s*(#|$)' $expected_file) <(grep -vE '^\s*(#|$)' $output_file)
}

print_progress "Looking for test files in '$tests_dir'"

for file in $tests_dir/*; do
    if [ -d "$file" ]; then
        test_dir=`realpath $file`
        test_file $test_dir
    fi
done

print_progress "Tests completed"
