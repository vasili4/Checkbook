#!/bin/sh

let primary=`hostname | perl -pe "s/\D//g"`
let primary=${primary}+3
cd /data/gpdb_master
time rsync -a /data/gpslave${primary}/gpdb_master/gpshard-1 .

for seg in 1 2 3 4 5 6 7 8
do
	let shard=${seg}-1
	cd /data/gpdb_p${seg}
	time rsync -a /data/gpslave${primary}/gpdb_p${seg}/gpshard${shard} .
done
