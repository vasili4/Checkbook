output1=$(grep -ic "error" shards_refresh_log.out)
if  [ $output1 -gt 0 ]
then
psql -h mdw -U gpadmin --dbname USASpending -c "insert into refresh_shards_status (script_name, status_flag, latest_flag) values ( 'Refresh Shards', 0,1)"
fi

