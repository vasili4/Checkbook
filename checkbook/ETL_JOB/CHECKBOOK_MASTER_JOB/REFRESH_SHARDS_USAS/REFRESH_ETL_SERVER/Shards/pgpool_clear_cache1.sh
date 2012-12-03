source /etc/profile
#gpssh  -h gp-data-1.local -h gp-data-2.local -h gp-data-3.local -h gp-feed-1.local  -e "psql -p 6432 pgpool -c 'truncate table pgpool_catalog.query_cache'"
#gpssh  -h sdw51 -h sdw52 -h sdw53 -h sdw56 -e "psql -p 6432 pgpool -c 'truncate table pgpool_catalog.query_cache'"
gpssh  -h sdw52 -h sdw53 -h sdw56  -e "psql -p 6432 pgpool -c 'truncate table pgpool_catalog.query_cache'"
