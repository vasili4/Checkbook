#!/bin/bash

PCP_DETACH_NODE="/usr/bin/pcp_detach_node"
PCP_ATTACH_NODE="/usr/bin/pcp_attach_node"
PCP_NODE_INFO="/usr/bin/pcp_node_info"
PCP_HOSTNAME=(web1 web2 web3)
PCP_USERNAME="pcpadmin"
PCP_PASSWORD="d6Zj5Nkc"
PCP_PORT="9898"
PCP_TIMEOUT="1"

shard_attach () {

	NODEID=$(get_node_id $1)

	for HOST in ${PCP_HOSTNAME[*]}
	do
		NODE_STATUS=$(get_node_status $HOST $NODEID)
		if [[ $NODE_STATUS == "3" ]]; then
			echo -n "Attaching $1 to $HOST..."
			$PCP_ATTACH_NODE $PCP_TIMEOUT $HOST $PCP_PORT $PCP_USERNAME $PCP_PASSWORD $NODEID
			echo "done!"
		else
			echo "Skipping $HOST because $1 is already attached!"
		fi
	done

}

shard_detach () {

	NODEID=$(get_node_id $1)

	for HOST in ${PCP_HOSTNAME[*]}
	do
		NODE_STATUS=$(get_node_status $HOST $NODEID)
		if [[ $NODE_STATUS == "1" || $NODE_STATUS == "2" ]]; then
			echo -n "Detaching $1 from $HOST..."
			$PCP_DETACH_NODE $PCP_TIMEOUT $HOST $PCP_PORT $PCP_USERNAME $PCP_PASSWORD $NODEID
			echo "done!"
		else
			echo "Skipping $HOST because $1 is already detached!"
		fi
	done

}

get_node_status () {

	STATUS=`$PCP_NODE_INFO $PCP_TIMEOUT $1 $PCP_PORT $PCP_USERNAME $PCP_PASSWORD $2 | /bin/awk '{ print $3 }'`

	echo $STATUS

}

get_node_id () {

	case $1 in
		"shard1" )
			echo "0";;
		"shard2" )
			echo "1";;
		"shard3" )
			echo "2";;
	esac

}
