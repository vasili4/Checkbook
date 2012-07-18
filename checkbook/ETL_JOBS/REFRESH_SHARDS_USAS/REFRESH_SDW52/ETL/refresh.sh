#!/bin/sh
#########################
#
# Jacque Istok
# jistok@greenplum.com
# refresh.sh
#
# do a sql refresh from mdw
#########################


host=`hostname`
#update shard table to know that we are starting
psql -h mdw -U gpadmin --dbname USASpending -c "update refresh_shards_status set sql_flag = 0, sql_start_date = now() where latest_flag = 1 and shard_name = '$host'"

#cleanup old runs
cd /home/gpadmin/ETL
rm fix* -f
rm tmp/et* -f
if [ -f ./shards_refresh_log.out ]
then
	rm ./shards_refresh_log.out
fi

#run the etl process
time ./etl.pl > ./shards_refresh_log.out 2>&1
wait

#look for errors
output=$(grep -ic "error" shards_refresh_log.out)
output1=$(grep -ic "FATAL" shards_refresh_log.out)
if  [ $output -gt 0 ] ||  [ $output1 -gt 0 ]
then
	echo "We have errors - not updating the table to move forward"
else
	psql -h mdw -U gpadmin --dbname USASpending -c "update refresh_shards_status set sql_flag = 1, sql_end_date = now(), refresh_end_date = now() where latest_flag = 1 and shard_name = '$host'"
fi
