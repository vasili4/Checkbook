#!/bin/sh
#########################
#
# Jacque Istok
# jistok@greenplum.com
# refresh_fix.sh
#
# fix anything wrong from the sql refresh
#########################


host=`hostname`
#update shard table to know that we are starting a fix
continue=`psql -A -t -h mdw1 -U gpadmin --dbname mmnyccheckbook_athu -c "select sql_flag from refresh_shards_status where latest_flag = 1 and shard_name = '$host'"`

if [ $continue = 1 ]
then
        echo "SQL Ran successfully - nothing to do"
        exit;
else
        psql -h mdw1 -U gpadmin --dbname mmnyccheckbook_athu -c "update refresh_shards_status set fix_flag = 0, fix_start_date = now() where latest_flag = 1 and shard_name = '$host'"

        cd /home/gpadmin/ETL
        rm fix* -f
        if [ -f ./shards_refresh_log_fix.out ]
        then
                rm ./shards_refresh_log_fix.out
        fi

        time ./etl-fix.pl shards_refresh_log.out > ./shards_refresh_log_fix.out 2>&1

        #Dont run the fix_flag = 1 stuff because this is a 2 step process, after the next script we will run it
fi

