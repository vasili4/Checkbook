#!/bin/sh

# attach shard1
pcp_attach_node 10 web1 9898 pcpadmin d6Zj5Nkc 0
pcp_attach_node 10 web2 9898 pcpadmin d6Zj5Nkc 0
pcp_attach_node 10 web3 9898 pcpadmin d6Zj5Nkc 0

# attach shard2
pcp_attach_node 10 web1 9898 pcpadmin d6Zj5Nkc 1
pcp_attach_node 10 web2 9898 pcpadmin d6Zj5Nkc 1
pcp_attach_node 10 web3 9898 pcpadmin d6Zj5Nkc 1

# attach shard3
pcp_attach_node 10 web1 9898 pcpadmin d6Zj5Nkc 2
pcp_attach_node 10 web2 9898 pcpadmin d6Zj5Nkc 2
pcp_attach_node 10 web3 9898 pcpadmin d6Zj5Nkc 2

wait

echo "PGPool is now using all shards"

exit 0
