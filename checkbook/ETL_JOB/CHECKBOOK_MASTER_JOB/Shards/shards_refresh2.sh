#!/bin/sh
#########################
#
# refresh_shards2.sh
#
# refresh the second set of shards
#########################

#Setup the environment
source /usr/local/greenplum-db-4.2.1.0/greenplum_path.sh

#rsync the other data shards shard3
continue=`psql -A -t -h mdw -U gpadmin --dbname checkbook -c "select coalesce(sql_flag,0) + coalesce(fix_flag,0)  from etl.refresh_shards_status where latest_flag = 1 and shard_name = 'shard1'"`
if [ $continue != 0 ]
then
	gpssh  -h shard3 -e "/home/gpadmin/ETL/sync.sh shard1" &
else
	echo "we have a problem from the SQL/FIX update for shard1 - can't continue"
fi

#wait for the rsyncs
wait


#start up shard1 if everything is done
continue=`psql -A -t -h mdw -U gpadmin --dbname checkbook -c "select count(*) from etl.refresh_shards_status where latest_flag = 1 and refresh_end_date is not null and shard_name in ('shard1','shard2','shard3')"`
if [ $continue != 3 ]
then
	echo "We have a problem - not all the shards are complete"
else
	ssh gpadmin@shard1 gpstart -a
fi


#Clean up the old directories
gpssh  -h shard3 -e "/home/gpadmin/ETL/clean_sync.sh"
