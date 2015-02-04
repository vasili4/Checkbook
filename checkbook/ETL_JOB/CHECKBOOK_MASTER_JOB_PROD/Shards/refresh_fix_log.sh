continue=0
if [ $continue = 0 ]
then
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
fi
