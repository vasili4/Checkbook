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


insert into etl.etl_data_load(job_id,data_source_code)
values(1,'C');

insert into etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag)
values(5,'AIDP_DLY_PCO_PO_20110507015221_20110507041911.ASC.asc','20110507041911','D','Y','Y','N');

insert into etl.etl_data_load(job_id,data_source_code)
values(1,'F');

insert into etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag)
values(6,'AIDM_DLY_MMDSB_AD_20110507013651_20110507041921.ASC','20110507041921','D','Y','Y','N');

insert into etl.etl_data_load(job_id,data_source_code)
values(1,'P');

insert into etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag)
values(7,'PAYROLL_A015_BTDVI680_20110507014154_20110507041946.ASC','20110507041946','D','Y','Y','N');

insert into etl.etl_data_load(job_id,data_source_code)
values(1,'R');

insert into etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag)
values(8,'AIDJ_DLY_JL_JL_032311015417.ASC','032311015417','D','Y','Y','N');

insert into etl.etl_data_load(job_id,data_source_code)
values(1,'E');

insert into etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag)
values(9,'AID3_DLY_COA_OBJ_20110507013649_20110507041850.ASC','20110507041850','D','Y','Y','N');

insert into etl.etl_data_load(job_id,data_source_code)
values(1,'L');

insert into etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag)
values(10,'AID4_DLY_COA_LOC_20110507013650_20110507041850.ASC','20110507041850','D','Y','Y','N');

insert into etl.etl_data_load(job_id,data_source_code)
values(1,'O');

insert into etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag)
values(11,'ObjectClass.txt','20110507041850','D','Y','Y','N');