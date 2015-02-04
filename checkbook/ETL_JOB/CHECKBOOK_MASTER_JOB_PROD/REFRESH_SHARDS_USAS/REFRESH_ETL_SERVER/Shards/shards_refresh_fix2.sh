source /etc/profile
#gpssh  -h gp-data-5.local -h gp-feed-2.local -h gp-feed-3.local -e "/home/gpadmin/ETL/refresh_fix.sh"
gpssh  -h sdw54 -h sdw55 -h sdw57 -h sdw58 -e "/home/gpadmin/ETL/refresh_fix.sh"
#gpssh  -h sdw58 -e "/home/gpadmin/ETL/refresh_fix.sh"
