#!/bin/sh
#########################
#
# refresh_shards2.sh
#
# refresh the second set of shards
#########################

#Setup the environment
source /etc/profile

#rsync the other data shards sdw3
continue=`psql -A -t -h mdw -U gpadmin --dbname checkbook -c "select coalesce(sql_flag,0) + coalesce(fix_flag,0)  from etl.refresh_shards_status where latest_flag = 1 and shard_name = 'sdw1'"`
if [ $continue != 0 ]
then
	gpssh  -h sdw3 -e "/home/gpadmin/ETL/sync.sh sdw1" &
else
	echo "we have a problem from the SQL/FIX update for sdw1 - can't continue"
fi

#wait for the rsyncs
wait


#start up sdw1 if everything is done
continue=`psql -A -t -h mdw -U gpadmin --dbname checkbook -c "select count(*) from etl.refresh_shards_status where latest_flag = 1 and refresh_end_date is not null and shard_name in ('sdw1','sdw2','sdw3')"`
if [ $continue != 3 ]
then
	echo "We have a problem - not all the shards are complete"
else
	ssh gpadmin@sdw1 gpstart -a
fi


#Clean up the old directories
gpssh  -h sdw3 -e "/home/gpadmin/ETL/clean_sync.sh"
