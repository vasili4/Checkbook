cd /home/gpadmin/ETL
if [ -f ./final_refresh_log.out ]
then
rm -f ./final_refresh_log.out
fi
if [ -f ./shards_refresh_log_fix.out ]
then
chmod +x ./shards_refresh_log_fix.out
./shards_refresh_log_fix.out
fi
filespec='fix.*'
for file in $filespec
do
   if [ "$file" = "$filespec" ]
   then
      echo no files found....exiting
      exit 0
   fi
   cat $file >> ./final_refresh_log.out
done
if [ -f ./final_refresh_log.out ]
then
output=$(grep -ic "error" final_refresh_log.out)
output1=$(grep -ic "FATAL" final_refresh_log.out)
if  [ $output -gt 0 ] ||  [ $output1 -gt 0 ]
then
psql -h mdw -U gpadmin --dbname USASpending -c "insert into refresh_shards_status (shard_name,step_name, status_flag) values ( 'Shard sdw51', 'Step 3',0)"
else
psql -h mdw -U gpadmin --dbname USASpending -c "insert into refresh_shards_status (shard_name,step_name, status_flag) values ( 'Shard sdw51', 'Step 3',1)"
fi
else
psql -h mdw -U gpadmin --dbname USASpending -c "insert into refresh_shards_status (shard_name,step_name, status_flag) values ( 'Shard sdw51', 'Step 3',0)"
fi
