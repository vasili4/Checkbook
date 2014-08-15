TODAY=$(date)
SCRIPT_DIR=/home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE
export SCRIPT_DIR
EXEC_TIME=`date +%m%d%Y:%T`
export EXEC_TIME
DB_NAME=checkbook_mwbe
export DB_NAME
echo "--------------------CREATE TABLES STRUCTURES---------------------"

psql -d $DB_NAME -f $SCRIPT_DIR/subcontract_changes.sql



echo "--------------------Creating Procedures-----------------------------"

psql -d $DB_NAME -f $SCRIPT_DIR/Scripts.sql 
psql -d $DB_NAME -f $SCRIPT_DIR/SubCONScripts.sql
psql -d $DB_NAME -f $SCRIPT_DIR/SubContractStatusScripts.sql 
psql -d $DB_NAME -f $SCRIPT_DIR/SubContractVendorBusTypeScripts.sql 
psql -d $DB_NAME -f $SCRIPT_DIR/SubFMSScripts.sql
psql -d $DB_NAME -f $SCRIPT_DIR/SubVendorScripts.sql


