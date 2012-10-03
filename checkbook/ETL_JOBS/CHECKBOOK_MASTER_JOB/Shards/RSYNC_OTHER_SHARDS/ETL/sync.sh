#!/bin/sh
#########################
#
# Jacque Istok
# jistok@greenplum.com
# sync.sh
#
# do a sync from a given host
#########################

if [[ $1 = "" ]]; then
	echo "Usage: sync.pl <sync host from>"
	exit;
fi

host=`hostname -s`
#update shard table to know that we are starting
psql -h mdw -U gpadmin --dbname USASpending -c "insert into refresh_shards_status (shard_name,latest_flag,rsync_flag, rsync_start_date, refresh_start_date) values ('$host', 1, 0, now(), now())" 


#stop the database
gpstop -ia

#Rename Current/OLD Directories
nic=1
for dir in /data /vol0 /vol1 /vol2 /vol3 /vol4 /vol5
do
	cd $dir
	#ignore EAP and old releases
	for gpdir in `ls -d gp* | grep -v eap | grep -v old`
	do
		echo "mv $dir/$gpdir $dir/$gpdir.old"
		echo "rsync -a $1-$nic:$dir/$gpdir $dir"
		mv $dir/$gpdir $dir/$gpdir.old
		rsync -a $1-$nic:$dir/$gpdir $dir &
	done
	let nic=$nic+1
	if [[ $nic -gt 4 ]]; then
		nic=1
	fi
done

#wait for all the rsyncs to finish
sleep 10
sync
wait

#startup database - cross fingers
#gpstart -a

#output=`psql -c "select version()" 2>&1 | grep -i "Is the server running locally" | wc -l`


#startup database - cross fingers
output=1
for ctr in 1 2 3
do
        echo $ctr;
        output=`psql -c "select version()" 2>&1 | grep -i "Is the server running locally" | wc -l`
        if  [ $output -eq 0 ]
        then
                echo "Started successfully in $ctr attempt "
        else
                sleep 60
                gpstart -a
        fi
done

output=`psql -c "select version()" 2>&1 | grep -i "Is the server running locally" | wc -l`


if  [ $output -gt 0 ] 
then
	echo "We have errors - not updating the table to move forward"
else
	psql -h mdw -U gpadmin --dbname USASpending -c "update refresh_shards_status set rsync_flag = 1, rsync_end_date = now(), refresh_end_date = now() where latest_flag = 1 and shard_name = '$host'"
fi

