cd /vol2share/NYC/NYC_ETL_JOBS/CHECKBOOK_MASTER_JOB/Solr/

wget -O solr_count.xml "http://172.30.0.31:8080/solr/select/?q=*%3A*&version=2.2&start=0&rows=10&indent=on"

wget -O solr_count_di.xml "http://172.30.0.31:8080/solr/dataimport/"
