#!/bin/sh

export CLASSPATH=
for jar in `ls lib/*.jar`
do
  export CLASSPATH=$CLASSPATH:$jar
done
export CLASSPATH=$CLASSPATH

java -Djsse.enableSNIExtension=false -Dsun.net.inetaddr.ttl=0 -Xmx16G -cp classes:$CLASSPATH eu.europeana.commonculture.lod.crawler.CommandLineInterface $1 $2 $3 $4 $5 $6 $7 $8
