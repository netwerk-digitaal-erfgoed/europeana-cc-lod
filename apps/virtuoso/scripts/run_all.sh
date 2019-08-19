#!/bin/bash

# assume:
# - the environment variabels are set correctly in .environment
# - virtuoso is up and running with fresh database volume

## would make sense to do some tests before continuing 

# empty log file
cat /dev/null >> run.log

# make sure Virtuoso is up
echo "Wait a while to be sure that Virtuoso is up and running..."
sleep 10

# load the data
echo -e "\nLoading input_file $input_file from directory $data_dir_host..."
$scripts_dir/loaddata.sh >> $data_dir/run.log
echo "Data loaded into graph $dest_graph"

# map the data
echo -e "\nCreating EDM data using $mapping_query from $mapping_dir_host..."
$scripts_dir/mapdata.sh >> $data_dir/run.log
echo "Data mapped into graph $edm_graph"

# store the convert data in a ttl file in the data dir
echo -e "\nDump the edm graph to file(s) ${output_base_name}*.ttl..."
$scripts_dir/storedata.sh >> $data_dir/run.log
echo "Data writen to outputfile in turtle format into directory $data_dir_host"
