
#Setup the environment
source /etc/profile

#reset the shards to have no latest values
psql -h mdw4 -U gpadmin --dbname mmnyccheckbook_athu -c "update refresh_shards_status set latest_flag = 0"
#execute a SQL pull from MDW for 2 shards
psql -h mdw4 -U gpadmin --dbname mmnyccheckbook_athu -c "insert into refresh_shards_status (shard_name,latest_flag,refresh_start_date) values ('mdw4', 1, now())" 
gpssh  -h mdw4 -e "/home/gpadmin/ETL/refresh.sh"

#Check for any errors on the shards and fix them
gpssh -h mdw4 -e "/home/gpadmin/ETL/refresh_fix.sh"
gpssh -h mdw4 -e "/home/gpadmin/ETL/refresh_fix_log.sh"

