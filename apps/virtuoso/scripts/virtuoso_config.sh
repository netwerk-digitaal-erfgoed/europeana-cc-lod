#!/bin/bash
cd scripts
docker cp ./loaddata.isql virtuoso:/opt/data/
docker cp ./loaddata.sh virtuoso:/opt/data