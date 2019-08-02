#!/bin/bash
$data_dir=/opt/data
$dest_graph=http://data.bibliotheken.nl/centsprenten/

cd $data_dir

# start the Virtuoso commandline mode
isql 1111 -u dba << EOF
ld_dir($data_dir,'*.nt',$dest_graph);
rdf_loader_run(log_enable=>3);
checkpoint;
EOF