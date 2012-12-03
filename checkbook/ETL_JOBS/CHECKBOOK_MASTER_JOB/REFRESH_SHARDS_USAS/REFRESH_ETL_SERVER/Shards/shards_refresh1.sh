#!/bin/sh
#########################
#
# Jacque Istok
# jistok@greenplum.com
# refresh_shards1.sh
#
# refresh the first set of shards
#########################

#Setup the environment
source /etc/profile

#reset the shards to have no latest values
psql -h mdw -U gpadmin --dbname USASpending -c "update refresh_shards_status set latest_flag = 0"
#execute a SQL pull from MDW for 2 shards
psql -h mdw -U gpadmin --dbname USASpending -c "insert into refresh_shards_status (shard_name,latest_flag,refresh_start_date) values ('sdw51', 1, now())" 
gpssh  -h sdw51 -e "/home/gpadmin/ETL/refresh.sh"

#Check for any errors on the shards and fix them
gpssh -h sdw51 -e "/home/gpadmin/ETL/refresh_fix.sh"
gpssh -h sdw51 -e "/home/gpadmin/ETL/refresh_fix_log.sh"

#the next two could probably be a loop, however the data/feed stuff could end up being different at some point..
#rsync the other data shards
continue=`psql -A -t -h mdw -U gpadmin --dbname USASpending -c "select coalesce(sql_flag,0) + coalesce(fix_flag,0) from refresh_shards_status where latest_flag = 1 and shard_name = 'sdw51'"`
if [ $continue != 0 ]
then
	ssh gpadmin@sdw51 gpstop -ia
	gpssh -h sdw52 -h sdw53 -e "/home/gpadmin/ETL/sync.sh sdw51" &
else
	echo "we have a problem from the SQL/FIX update for sdw51 - can't continue"
fi

#wait for the rsyncs
wait

#rsync the sdw56 and sdw57 feed shards

#rsync the other feed shards
if [ $continue != 0 ]
then	
	gpssh -h sdw56  -e "/home/gpadmin/ETL/sync.sh sdw51" &
else
	echo "we have a problem from the SQL/FIX update for sdw51 - can't continue"
fi

#wait for the rsyncs
wait

#Clean up the old directories
gpssh -h sdw52 -h sdw53 -h sdw56  -e "/home/gpadmin/ETL/clean_sync.sh"
