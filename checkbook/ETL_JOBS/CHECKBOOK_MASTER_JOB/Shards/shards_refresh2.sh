#!/bin/sh
#########################
#
# Jacque Istok
# jistok@greenplum.com
# refresh_shards2.sh
#
# refresh the second set of shards
#########################

#Setup the environment
source /etc/profile

#rsync the other data shards sdw54, sdw55
continue=`psql -A -t -h mdw -U gpadmin --dbname USASpending -c "select coalesce(sql_flag,0) + coalesce(fix_flag,0)  from refresh_shards_status where latest_flag = 1 and shard_name = 'sdw51'"`
if [ $continue != 0 ]
then
	gpssh  -h sdw54 -h sdw55 -e "/home/gpadmin/ETL/sync.sh sdw51" &
else
	echo "we have a problem from the SQL/FIX update for sdw51 - can't continue"
fi

#wait for the rsyncs
wait


#start up sdw51 if everything is done
continue=`psql -A -t -h mdw -U gpadmin --dbname USASpending -c "select count(*) from refresh_shards_status where latest_flag = 1 and refresh_end_date is not null and shard_name in ('sdw51','sdw52','sdw53','sdw54','sdw55')"`
if [ $continue != 5 ]
then
	echo "We have a problem - not all the shards are complete"
else
	ssh gpadmin@sdw51 gpstart -a
fi


#Clean up the old directories
gpssh  -h sdw54 -h sdw55  -e "/home/gpadmin/ETL/clean_sync.sh"
