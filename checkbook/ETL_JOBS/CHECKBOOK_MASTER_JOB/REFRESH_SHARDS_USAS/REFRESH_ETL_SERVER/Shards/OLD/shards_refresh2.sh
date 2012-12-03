echo "vcl.use etl-group-1" | nc varnish-prime.local 6082
gpssh  -f  /home/gpadmin/etl/gp-shard-batch2 –e "home/gpadmin/refresh.sh"