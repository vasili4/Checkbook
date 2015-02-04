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
psql -h mdw1 -U gpadmin --dbname checkbook -c "update etl.refresh_shards_status set latest_flag = 0"
#execute a SQL pull from MDW for 2 shards
psql -h mdw1 -U gpadmin --dbname checkbook -c "insert into etl.refresh_shards_status (shard_name,latest_flag,refresh_start_date) values ('mdw4', 1, now())" 
gpssh  -h mdw4 -e "/home/gpadmin/ETL/UAT/refresh.sh"

#Check for any errors on the shards and fix them
gpssh -h mdw4 -e "/home/gpadmin/ETL/UAT/refresh_fix.sh"
gpssh -h mdw4 -e "/home/gpadmin/ETL/UAT/refresh_fix_log.sh"

