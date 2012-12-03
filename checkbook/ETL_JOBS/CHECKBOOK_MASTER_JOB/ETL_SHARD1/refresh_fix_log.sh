#!/bin/sh
#########################
#
# Jacque Istok
# jistok@greenplum.com
# refresh_fix_log.sh
#
# run the fixes from the refresh_fix.sh script from a failed sql run
#########################


host=`hostname`
#update shard table to know that we are starting a fix
continue=`psql -A -t -h mdw1 -U gpadmin --dbname mmnyccheckbook_athu -c "select fix_flag from refresh_shards_status where latest_flag = 1 and shard_name = '$host'"`

#only run this if we ran the last script
if [ $continue = 0 ]
then
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
                        echo "We have errors - not updating the table to move forward"
                else
                        psql -h mdw1 -U gpadmin --dbname mmnyccheckbook_athu -c "update refresh_shards_status set fix_flag = 1, fix_end_date = now(), refresh_end_date = now() where latest_flag = 1 and shard_name = '$host'"
                fi
        else
                echo "We have errors - not updating the table to move forward"
        fi
fi
