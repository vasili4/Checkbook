source /etc/profile

gpssh  -h shard1 -e "/home/gpadmin/ETL/refresh.sh"

#Check for any errors on the shards and fix them
gpssh -h shard1 -e "/home/gpadmin/ETL/refresh_fix.sh"
gpssh -h shard1 -e "/home/gpadmin/ETL/refresh_fix_log.sh"

