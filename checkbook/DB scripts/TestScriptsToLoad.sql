insert into etl.etl_data_load(job_id,data_source_code)
values(1,'A');

insert into etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag)
values(1,'AID1_DLY_COA_DEPT_20110507013651_20110507041850.asc','20110507041850','D','Y','Y','N');

insert into etl.etl_data_load(job_id,data_source_code)
values(1,'D');

insert into etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag)
values(2,'MOD_AID2_DLY_COA_APPR_20110507013650_20110507041850.asc','20110507041850','D','Y','Y','N');

INSERT INTO ref_fund_class(fund_class_code,fund_class_name,created_date) VALUES ('001','General Fund',now()::timestamp),('400','Capital Fund',now()::timestamp);


insert into etl.etl_data_load(job_id,data_source_code)
values(1,'M');

insert into etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag)
values(3,'AIDP_DLY_PCO_MA_20110507015221_20110507041918.asc','20110507041918','D','Y','Y','N');

insert into etl.etl_data_load(job_id,data_source_code)
values(1,'V');

insert into etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag)
values(4,'AIV2_MTHLY_VEND_20110508015204_20110531111540.asc','20110531111540','M','Y','Y','N');
