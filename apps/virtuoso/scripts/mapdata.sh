#!/bin/bash

# perform the actual mapping use the sparql insert query in the mapping query file
isql 1111 dba $DBA_PASSWORD $mappings_dir/$mapping_query