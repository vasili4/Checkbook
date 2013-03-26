cd /home/gpadmin/ETL
rm fix* -f
rm tmp/et* -f
if [ -f ./shards_refresh_log.out ]
then
rm ./shards_refresh_log.out
fi
time ./etl.pl > ./shards_refresh_log.out 2>&1
output=$(grep -ic "error" shards_refresh_log.out)
output1=$(grep -ic "FATAL" shards_refresh_log.out)
if  [ $output -gt 0 ] ||  [ $output1 -gt 0 ]
then
psql -h mdw -U gpadmin --dbname USASpending -c "insert into refresh_shards_status (shard_name,step_name, status_flag) values ( 'Shard sdw52', 'Step 1',0)"
else
psql -h mdw -U gpadmin --dbname USASpending -c "insert into refresh_shards_status (shard_name,step_name, status_flag) values ( 'Shard sdw52', 'Step 1',1)"
fi

