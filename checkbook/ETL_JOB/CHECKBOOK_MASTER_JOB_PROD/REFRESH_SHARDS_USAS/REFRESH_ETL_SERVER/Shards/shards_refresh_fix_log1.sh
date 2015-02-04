source /etc/profile
#gpssh -h gp-data-1.local -h gp-data-2.local -h gp-data-3.local -h gp-feed-1.local  -e "/home/gpadmin/ETL/refresh_fix_log.sh" 
gpssh -h sdw51 -h sdw52 -h sdw53 -h sdw56 -e "/home/gpadmin/ETL/refresh_fix_log.sh" 
#gpssh -h sdw51 -e "/home/gpadmin/ETL/refresh_fix_log.sh" 
