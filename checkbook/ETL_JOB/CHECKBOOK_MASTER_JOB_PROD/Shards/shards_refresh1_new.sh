#!/bin/sh
#########################
#
# refresh_shards1.sh
#
# refresh the first set of shards
#########################

#Setup the environment
source /usr/local/greenplum-db-4.2.1.0/greenplum_path.sh

#reset the shards to have no latest values
psql -h mdw -U gpadmin --dbname checkbook -c "update etl.refresh_shards_status set latest_flag = 0"
#execute a SQL pull from mdw for shard1
psql -h mdw -U gpadmin --dbname checkbook -c "insert into etl.refresh_shards_status (shard_name,latest_flag,refresh_start_date) values ('shard1', 1, now())" 



#reset the shards to have no latest values in checkbook_ogent
psql -h mdw -U gpadmin --dbname checkbook_ogent -c "update etl.refresh_shards_status set latest_flag = 0"
#execute a SQL pull from mdw for shard1
psql -h mdw -U gpadmin --dbname checkbook_ogent -c "insert into etl.refresh_shards_status (shard_name,latest_flag,refresh_start_date) values ('shard1', 1, now())"



ssh gpadmin@shard1 gpstop -ia
sleep 30
ssh gpadmin@shard1 gpstart -a
sleep 30

gpssh  -h shard1 -e "/home/gpadmin/ETL/refresh.sh"

#Check for any errors on the shards and fix them
gpssh -h shard1 -e "/home/gpadmin/ETL/refresh_fix.sh"
gpssh -h shard1 -e "/home/gpadmin/ETL/refresh_fix_log.sh"


#For refreshing checkbook_ogent in shard1

gpssh  -h shard1 -e "/home/gpadmin/OGE_ETL/refresh.sh"

#Check for any errors on the shards and fix them
gpssh -h shard1 -e "/home/gpadmin/OGE_ETL/refresh_fix.sh"
gpssh -h shard1 -e "/home/gpadmin/OGE_ETL/refresh_fix_log.sh"



#rsync the other shards shard2
continue=`psql -A -t -h mdw -U gpadmin --dbname checkbook -c "select coalesce(sql_flag,0) + coalesce(fix_flag,0) from etl.refresh_shards_status where latest_flag = 1 and shard_name = 'shard1'"`

continue_oge=`psql -A -t -h mdw -U gpadmin --dbname checkbook_ogent -c "select coalesce(sql_flag,0) + coalesce(fix_flag,0) from etl.refresh_shards_status where latest_flag = 1 and shard_name = 'shard1'"`


if [ $continue != 0 ] && [ $continue_oge != 0 ]
then
	ssh gpadmin@shard1 gpstop -ia
	gpssh -h shard2  -e "/home/gpadmin/ETL/sync.sh shard1" &
else
	echo "we have a problem from the SQL/FIX update for shard1 - can't continue"
fi

#wait for the rsyncs
wait

#Clean up the old directories
gpssh -h shard2  -e "/home/gpadmin/ETL/clean_sync.sh"

