time ./etl.pl > ./shards_refresh_log.out 2>&1
output=$(grep -ic "error" shards_refresh_log.out)
if  [ $output -gt 0 ]
then
#psql -h 10.2.3.201 -U gpadmin --dbname USASpending_mtr -c "insert into refresh_shards_status (script_name, status_flag, latest_flag) values ( 'Refresh Shards', 0,1)"
psql -h mdw -U gpadmin --dbname USASpending_mtr -c "insert into refresh_shards_status (script_name, status_flag, latest_flag) values ( 'Refresh Shards', 0,1)"
fi

