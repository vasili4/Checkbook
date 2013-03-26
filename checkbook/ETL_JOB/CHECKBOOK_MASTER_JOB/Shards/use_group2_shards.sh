#!/bin/sh

# attach shard3
pcp_attach_node 10 web1 9898 pcpadmin d6Zj5Nkc 2
pcp_attach_node 10 web2 9898 pcpadmin d6Zj5Nkc 2
pcp_attach_node 10 web3 9898 pcpadmin d6Zj5Nkc 2

# detach shard1
pcp_detach_node 10 web1 9898 pcpadmin d6Zj5Nkc 0
pcp_detach_node 10 web2 9898 pcpadmin d6Zj5Nkc 0
pcp_detach_node 10 web3 9898 pcpadmin d6Zj5Nkc 0

# detach shard2
pcp_detach_node 10 web1 9898 pcpadmin d6Zj5Nkc 1
pcp_detach_node 10 web2 9898 pcpadmin d6Zj5Nkc 1
pcp_detach_node 10 web3 9898 pcpadmin d6Zj5Nkc 1

wait

echo "PGPool is now using shard3"

exit 0
