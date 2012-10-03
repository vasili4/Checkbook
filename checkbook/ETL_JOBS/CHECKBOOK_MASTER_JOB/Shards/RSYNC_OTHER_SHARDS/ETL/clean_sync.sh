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
for dir in /data /vol0 /vol1 /vol2 /vol3 /vol4 /vol5
do
	cd $dir
	#ignore EAP releases
	for gpdir in `ls -d gp*old | grep -v eap`
	do
		echo "removing $dir/$gpdir"
		rm -fr $dir/$gpdir 
	done
done
