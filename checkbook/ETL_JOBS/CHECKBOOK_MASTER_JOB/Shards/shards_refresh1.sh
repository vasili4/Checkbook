#!/bin/sh
#########################
#
# refresh_shards1.sh
#
# refresh the first set of shards
#########################

#Setup the environment
source /etc/profile

#reset the shards to have no latest values
psql -h mdw -U gpadmin --dbname checkbook -c "update etl.refresh_shards_status set latest_flag = 0"
#execute a SQL pull from mdw for sdw1
psql -h mdw -U gpadmin --dbname checkbook -c "insert into etl.refresh_shards_status (shard_name,latest_flag,refresh_start_date) values ('sdw1', 1, now())" 
gpssh  -h sdw1 -e "/home/gpadmin/ETL/refresh.sh"

#Check for any errors on the shards and fix them
gpssh -h sdw1 -e "/home/gpadmin/ETL/refresh_fix.sh"
gpssh -h sdw1 -e "/home/gpadmin/ETL/refresh_fix_log.sh"

#rsync the other shards sdw2
continue=`psql -A -t -h mdw -U gpadmin --dbname checkbook -c "select coalesce(sql_flag,0) + coalesce(fix_flag,0) from etl.refresh_shards_status where latest_flag = 1 and shard_name = 'sdw1'"`
if [ $continue != 0 ]
then
	ssh gpadmin@sdw1 gpstop -ia
	gpssh -h sdw2  -e "/home/gpadmin/ETL/sync.sh sdw1" &
else
	echo "we have a problem from the SQL/FIX update for sdw1 - can't continue"
fi

#wait for the rsyncs
wait

#Clean up the old directories
gpssh -h sdw2  -e "/home/gpadmin/ETL/clean_sync.sh"
