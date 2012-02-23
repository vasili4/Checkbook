source /etc/profile
#gpssh  -h gp-data-4.local -h gp-data-5.local -h gp-feed-2.local -h gp-feed-3.local  -e "psql -p 6432 pgpool -c 'truncate table pgpool_catalog.query_cache'"
#gpssh  -h sdw54 -h sdw55 -h sdw57 -h sdw58 -e "psql -p 6432 pgpool -c 'truncate table pgpool_catalog.query_cache'"
gpssh -h sdw51 -h sdw54 -h sdw55  -h sdw58 -e "psql -p 6432 pgpool -c 'truncate table pgpool_catalog.query_cache'"
