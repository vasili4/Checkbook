rm fix* -f
rm tmp/et* -f
rm -rf shards_refresh_log.out
time ./etl.pl > ./shards_refresh_log.out 2>&1
