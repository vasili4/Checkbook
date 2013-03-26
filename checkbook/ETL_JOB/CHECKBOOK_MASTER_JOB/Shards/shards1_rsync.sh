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
