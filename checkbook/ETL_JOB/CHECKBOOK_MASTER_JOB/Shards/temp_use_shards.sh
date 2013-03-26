#!/bin/sh

cd /vol2share/NYC/NYC_ETL_JOBS/CHECKBOOK_MASTER_JOB/Shards
source ./pcp_init.sh

shard_attach shard3
shard_attach shard2
shard_detach shard1

wait

echo "pgpool is now using shard3 and shard2"
