#!/bin/bash

# start the Virtuoso commandline mode
isql 1111 -u dba -p $DBA_PASSWORD <<EOF
ld_dir('$data_dir','$input_file','$dest_graph');
rdf_loader_run(log_enable=>3);
checkpoint;
exit;
EOF