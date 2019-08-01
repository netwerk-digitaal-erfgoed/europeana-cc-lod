#!/bin/bash
cd scripts
docker cp ./loaddata.isql virtuoso:/opt/data/
docker cp ./loaddata.sh virtuoso:/opt/data
docker cp ./mapping_cp.rq virtuoso:/opt/data
docker cp ./mapdata.sh virtuoso:/opt/data
docker cp ./mapping_out.sh virtuoso:/opt/data