#!/bin/sh

echo "======== web1 ========"
echo -n "node 0: " && pcp_node_info 10 web1 9898 pgpool pgpool 0
echo -n "node 1: " && pcp_node_info 10 web1 9898 pgpool pgpool 1
echo -n "node 2: " && pcp_node_info 10 web1 9898 pgpool pgpool 2

echo "======== web2 ========"
echo -n "node 0: " && pcp_node_info 10 web2 9898 pgpool pgpool 0
echo -n "node 1: " && pcp_node_info 10 web2 9898 pgpool pgpool 1
echo -n "node 2: " && pcp_node_info 10 web2 9898 pgpool pgpool 2

echo "======== web3 ========"
echo -n "node 0: " && pcp_node_info 10 web3 9898 pgpool pgpool 0
echo -n "node 1: " && pcp_node_info 10 web3 9898 pgpool pgpool 1
echo -n "node 2: " && pcp_node_info 10 web3 9898 pgpool pgpool 2

wait

exit 0
