#!/bin/sh

echo "====== web1 ======"
pcp_node_info 10 web1 9898 pcpadmin d6Zj5Nkc 0
pcp_node_info 10 web1 9898 pcpadmin d6Zj5Nkc 1
pcp_node_info 10 web1 9898 pcpadmin d6Zj5Nkc 2

echo "====== web2 ======"
pcp_node_info 10 web2 9898 pcpadmin d6Zj5Nkc 0
pcp_node_info 10 web2 9898 pcpadmin d6Zj5Nkc 1
pcp_node_info 10 web2 9898 pcpadmin d6Zj5Nkc 2

echo "====== web3 ======"
pcp_node_info 10 web3 9898 pcpadmin d6Zj5Nkc 0
pcp_node_info 10 web3 9898 pcpadmin d6Zj5Nkc 1
pcp_node_info 10 web3 9898 pcpadmin d6Zj5Nkc 2

wait

exit 0
