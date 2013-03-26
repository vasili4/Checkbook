#!/bin/sh
#########################
#
# Jacque Istok
# jistok@greenplum.com
# clean_sync.sh
#
# clean up from the sync process
#########################

#cleanup OLD Directories
for dir in /data/gpdb_master /data/gpdb_p1 /data/gpdb_p2 /data/gpdb_p3 /data/gpdb_p4
do
	cd $dir
	#ignore EAP releases
	for gpdir in `ls -d gp*old | grep -v eap`
	do
		echo "removing $dir/$gpdir"
		rm -fr $dir/$gpdir 
	done
done
