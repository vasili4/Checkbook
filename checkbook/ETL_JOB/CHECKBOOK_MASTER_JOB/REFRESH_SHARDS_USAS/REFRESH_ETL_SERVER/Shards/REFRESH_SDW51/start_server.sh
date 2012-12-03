#startup database - cross fingers
output=1
for ctr in 1 2 3
do
        echo $ctr;
        output=`psql -c "select version()" 2>&1 | grep -i "Is the server running locally" | wc -l`
        if  [ $output -eq 0 ]
        then
                echo "Started successfully in $ctr attempt "
        else
                sleep 60
                gpstart -a
        fi
done

#output=`psql -c "select version()" 2>&1 | grep -i "Is the server running locally" | wc -l`
