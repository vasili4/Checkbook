rm fix* -f
        if [ -f ./shards_refresh_log_fix.out ]
        then
                rm ./shards_refresh_log_fix.out
        fi

        time ./etl-fix.pl shards_refresh_log.out > ./shards_refresh_log_fix.out 2>&1
