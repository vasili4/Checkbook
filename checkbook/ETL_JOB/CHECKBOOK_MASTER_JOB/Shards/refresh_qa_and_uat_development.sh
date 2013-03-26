#!/bin/sh
#########################
#
# regresh qa and uat databases in development
#
#########################

#Setup the environment
source /etc/profile

gpssh  -h mdw4 -e "/home/gpadmin/TREDDY/dumps/refresh_dev_qa_and_uat_databases.sh"



