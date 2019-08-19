#!/bin/bash

# output file to be dumped by the storedata.sh scripts
# produces a turtle (.ttl) file in the data directory
output_base_name=$(echo "$input_file" | cut -f 1 -d '.')"_edm"

# load a stored procedure for dumping a graph to a turtle file
isql 1111 dba $DBA_PASSWORD ${scripts_dir}/dump_one_graph.sql 

# use the stored procedure to dump the actual data (in multiple files if needed)
isql 1111 dba $DBA_PASSWORD << EOF
dump_one_graph('$edm_graph','$data_dir/$output_base_name',100000000);
EOF