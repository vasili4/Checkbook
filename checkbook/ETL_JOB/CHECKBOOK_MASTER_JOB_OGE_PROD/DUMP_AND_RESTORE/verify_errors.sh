cd /vol2share/NYC/NYC_ETL_JOBS/CHECKBOOK_MASTER_JOB_OGE/DUMP_AND_RESTORE
rm -rf errors_analysys.txt
grep -Ric "ERROR" *.err > errors_analysys.txt
output=$(grep -ic ".err:0" errors_analysys.txt)
if [[ $output = 8 ]]; then
    echo "Success"
 else
    echo "Fail"
 fi
