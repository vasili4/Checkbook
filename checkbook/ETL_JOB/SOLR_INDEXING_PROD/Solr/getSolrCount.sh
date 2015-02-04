cd /vol2share/NYC/NYC_ETL_JOBS/SOLR_INDEXING/Solr/

wget -O solr_count.xml "http://shard1:8080/solr/select/?q=*%3A*&version=2.2&start=0&rows=10&indent=on"

wget -O solr_count_di.xml "http://shard1:8080/solr/dataimport/"