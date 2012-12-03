echo "vcl.use etl-group-2" | nc varnish-prime.local 6082
gpssh  -f  /home/gpadmin/etl/gp-shard-batch1 –e "home/gpadmin/refresh.sh"