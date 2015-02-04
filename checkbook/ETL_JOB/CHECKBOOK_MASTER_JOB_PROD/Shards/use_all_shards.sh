#!/bin/sh

# attach shard1
pcp_attach_node 10 web1 9898 pgpool pgpool 0
pcp_attach_node 10 web2 9898 pgpool pgpool 2
pcp_attach_node 10 web3 9898 pgpool pgpool 1

# attach shard2
pcp_attach_node 10 web1 9898 pgpool pgpool 1
pcp_attach_node 10 web2 9898 pgpool pgpool 0
pcp_attach_node 10 web3 9898 pgpool pgpool 2

# attach shard3
pcp_attach_node 10 web1 9898 pgpool pgpool 2
pcp_attach_node 10 web2 9898 pgpool pgpool 1
pcp_attach_node 10 web3 9898 pgpool pgpool 0

wait

echo "PGPool is now using all shards"

exit 0
