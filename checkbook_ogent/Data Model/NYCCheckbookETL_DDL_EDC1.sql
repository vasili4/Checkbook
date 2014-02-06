create schema etl;
set search_path=etl;
create sequence seq_etl_data_load_id;
create sequence seq_etl_data_load_file_id;
create sequence seq_stg_agency_uniq_id;
create sequence seq_stg_department_uniq_id;
create sequence seq_stg_mag_header_uniq_id;
create sequence seq_stg_mag_award_detail_uniq_id;
create sequence seq_stg_mag_vendor_uniq_id;
create sequence seq_stg_mag_commodity_uniq_id;
create sequence seq_stg_fmsv_vendor_uniq_id;
create sequence seq_stg_fmsv_business_type_uniq_id;
create sequence seq_stg_fmsv_address_uniq_id;
create sequence seq_stg_fmsv_address_type_uniq_id;
create sequence seq_stg_con_ct_header_uniq_id;
create sequence seq_stg_con_ct_award_detail_uniq_id;
create sequence seq_stg_con_ct_vendor_uniq_id;
create sequence seq_stg_con_ct_commodity_uniq_id;
create sequence seq_stg_con_ct_accounting_line_uniq_id;
create sequence seq_stg_con_po_header_uniq_id;
create sequence seq_stg_con_po_award_detail_uniq_id;
create sequence seq_stg_con_po_vendor_uniq_id;
create sequence seq_stg_con_po_commodity_uniq_id;
create sequence seq_stg_con_po_accounting_line_uniq_id;
create sequence seq_stg_con_do1_header_uniq_id;
create sequence seq_stg_con_do1_vendor_uniq_id;
create sequence seq_stg_con_do1_commodity_uniq_id;
create sequence seq_stg_con_do1_accounting_line_uniq_id;
create sequence seq_stg_fms_header_uniq_id;
create sequence seq_stg_fms_vendor_uniq_id;
create sequence seq_stg_fms_accounting_line_uniq_id;
create sequence seq_stg_expenditure_object_uniq_id;
create sequence seq_stg_location_uniq_id;
create sequence seq_stg_object_class_uniq_id;
create sequence seq_stg_budget_code_uniq_id;
create sequence seq_etl_job_id;
create sequence seq_stg_funding_class_uniq_id;
create sequence seq_stg_pending_contracts_uniq_id;

CREATE TABLE ref_data_source (
    data_source_code varchar(2),
    data_source_name character varying,
    document_type character varying,
    document_name character varying,
    record_identifier character(1),
    record_type_name character varying,
    staging_table_name character varying,
    archive_table_name character varying,
    invalid_table_name character varying,
    table_order smallint,
    data_source_order smallint
) distributed by (data_source_code);

CREATE TABLE ref_file_name_pattern (
	data_source_code varchar(2),
	directory_listing_pattern character varying,
	actual_pattern character varying,
	standard_file_name character varying)
distributed by (data_source_code);	
	
CREATE TABLE etl_data_load (
    job_id bigint,
    load_id bigint default nextval('seq_etl_data_load_id'),
    data_source_code varchar(2),
    publish_start_time timestamp,
    publish_end_time timestamp,
    files_available_flag char(1))
DISTRIBUTED BY (load_id);

CREATE TABLE etl_data_load_file (
    load_file_id bigint default nextval('seq_etl_data_load_file_id'),
    load_id bigint,
    file_name varchar,
    file_timestamp varchar,
    type_of_feed  char(1),
    display_type  char(1),
    consume_flag char(1),
    pattern_matched_flag char(1),
    processed_flag char(1),
    publish_start_time timestamp,
    publish_end_time timestamp)
DISTRIBUTED BY (load_file_id);
    
CREATE TABLE ref_column_mapping (
    data_feed_table_name character varying,
    data_feed_column_name character varying,
    data_feed_data_type character varying,
    staging_table_name character varying,
    staging_column_name character varying,
    staging_data_type character varying,
    column_order integer
) distributed by (staging_table_name);

    
CREATE TABLE ref_validation_rule (
    data_source_code varchar(2),
    record_identifier character(1),
    document_type character varying,
    rule_name character varying,
    parent_table_name character varying,
    component_table_name character varying,
    staging_column_name character varying,
    transaction_table_name character varying,
    ref_table_name character varying,
    ref_column_name character varying,
    invalid_condition character varying,
    rule_order smallint
) distributed by (data_source_code);

-- Start of COA related tables
CREATE EXTERNAL TABLE ext_stg_coa_agency_feed(
	agency_code VARCHAR,
	agency_name VARCHAR,
	col3	    VARCHAR,
	agency_short_name VARCHAR,
	col5	    VARCHAR,
	col6	    VARCHAR,
	col7	    VARCHAR,
	col8	    VARCHAR,
	col9	    VARCHAR,
	col10	    VARCHAR,
	col11	    VARCHAR,
	col12	    VARCHAR,
	col13	    VARCHAR,
	col14	    VARCHAR,
	col15	    VARCHAR,
	col16	    VARCHAR,
	col17	    VARCHAR,
	col18	    VARCHAR,
	col19	    VARCHAR,
	col20	    VARCHAR,
	col21	    VARCHAR,
	col22	    VARCHAR,
	col23	    VARCHAR,
	col24	    VARCHAR,
	col25	    VARCHAR,
	col26	    VARCHAR)
LOCATION (
	    'gpfdist://mdw1:8081/datafiles/COA_agency_feed.txt')
	    FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
ENCODING 'UTF8';
 
 
 CREATE EXTERNAL TABLE ext_stg_coa_department_feed(
 	agency_code VARCHAR,
 	fund_class_code VARCHAR,
 	fiscal_year	VARCHAR,
 	department_code	    VARCHAR,
 	department_name	 VARCHAR,
 	col6	    VARCHAR,
 	col7	    VARCHAR,
 	department_short_name    VARCHAR,
 	col9	    VARCHAR,
 	col10	    VARCHAR,
 	col11	    VARCHAR,
 	col12	    VARCHAR,
 	col13	    VARCHAR,
 	col14	    VARCHAR,
 	col15	    VARCHAR,
 	col16	    VARCHAR,
 	col17	    VARCHAR,
 	col18	    VARCHAR,
 	col19	    VARCHAR,
 	col20	    VARCHAR,
 	col21	    VARCHAR)
 LOCATION (
 	    'gpfdist://mdw1:8081/datafiles/COA_department_feed.txt')
 	    FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
 ENCODING 'UTF8';
 
 
CREATE EXTERNAL TABLE ext_stg_coa_expenditure_object_feed(
  	col1 VARCHAR,
  	fiscal_year varchar,
  	expenditure_object_code	varchar,
  	expenditure_object_name	    VARCHAR,
  	col5	 VARCHAR,
  	col6	    VARCHAR,
  	col7	    VARCHAR,
  	col8	    VARCHAR,
  	col9	    VARCHAR,
  	col10	    VARCHAR,
  	col11	    VARCHAR,
  	col12	    VARCHAR,
  	col13	    VARCHAR,
  	col14	    VARCHAR,
  	col15	    VARCHAR,
  	col16	    VARCHAR,
  	col17	    VARCHAR,
  	col18	    VARCHAR,
  	col19	    VARCHAR,
  	col20	    VARCHAR,
  	col21	    VARCHAR,
  	col22	    VARCHAR,
  	col23	    VARCHAR,
  	col24	    VARCHAR,
  	col25	    VARCHAR,
  	col26	    VARCHAR,
  	col27	    VARCHAR,
  	col28	    VARCHAR,
  	col29	    VARCHAR,
  	col30	    VARCHAR,
  	col31	    VARCHAR,
  	col32	    VARCHAR,
  	col33	    VARCHAR,
  	col34	    VARCHAR,
  	col35	    VARCHAR,
  	col36	    VARCHAR,
  	col37	    VARCHAR,
  	col38	    VARCHAR,
  	col39	    VARCHAR,
  	col40	    VARCHAR,
  	col41	    VARCHAR,
  	col42	    VARCHAR,
  	col43	    VARCHAR
  	)
  LOCATION (
  	    'gpfdist://mdw1:8081/datafiles/COA_expenditure_object_feed.txt')
  	    FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
 ENCODING 'UTF8';

 
 CREATE EXTERNAL TABLE etl.ext_stg_coa_location_feed(
   	agency_code varchar(20),location_code varchar(4),location_name varchar(60),location_short_name varchar(16),upper_case_name varchar(60),
	col6 varchar(100),col7 varchar(100),col8 varchar(100),col9 varchar(100),col10 varchar(100),
	col11 varchar(100),col12 varchar(100),col13 varchar(100),col14 varchar(100),col15 varchar(100),col16 varchar,col17 varchar(1)
   	)
   LOCATION (
   	    'gpfdist://mdw1:8081/datafiles/COA_location_object_feed.txt')
   	    FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
 ENCODING 'UTF8';
 
 CREATE EXTERNAL TABLE ext_stg_coa_object_class_feed(
 	doc_dept_cd varchar,
 	object_class_code varchar(3),
 	object_class_name varchar(100),
 	short_name varchar(100),
 	act_fl char(1),
 	effective_begin_date varchar(20),
 	effective_end_date varchar(20),
 	alw_bud_fl char(1),
 	description varchar(100),
 	cntac_cd varchar(100),
 	object_class_name_up varchar(100),
 	tbl_last_dt varchar(20),
 	intr_cty_fl char(1),
 	cntrc_pos_fl char(1),
 	pyrl_typ char(1),
 	dscr_ext varchar(100),
	rltd_ocls_cd varchar(3),
	col18 varchar)
LOCATION (
  	    'gpfdist://mdw1:8081/datafiles/COA_object_class_feed.txt')
  	    FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
 ENCODING 'UTF8';	



CREATE EXTERNAL TABLE ext_stg_coa_budget_code_feed
(
fy character varying,
fcls_cd character varying,
fcls_nm character varying,
dept_cd character varying,
dept_nm character varying,
func_cd character varying,
func_nm character varying,
func_attr_nm character varying,
func_attr_sh_nm character varying,
resp_ctr character varying,
func_anlys_unit  character varying,
cntrl_cat character varying,
local_svc_dist character varying,
ua_fund_fl character varying,
pyrl_dflt_fl character varying,
bud_cat_a character varying,
bud_cat_b character varying,
bud_func character varying,
dscr_ext character varying,
tbl_last_dt character varying,
func_attr_nm_up character varying,
fin_plan_sav_fl character varying,
col23 varchar
)
location 
(
'gpfdist://mdw1:8081/datafiles/COA_budget_code_feed.txt'
)
FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
encoding 'utf8';



CREATE TABLE ref_fund_class_id_seq(uniq_id bigint,fund_class_id int default nextval('public.seq_ref_fund_class_fund_class_id'))
DISTRIBUTED BY (uniq_id);


CREATE TABLE stg_agency(
	agency_code varchar(20),
	agency_name varchar(100),
	agency_short_name varchar(15),
	uniq_id bigint default nextval('seq_stg_agency_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar)
DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_agency (LIKE stg_agency) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_agency ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_agency (LIKE archive_agency) DISTRIBUTED BY (uniq_id);

CREATE TABLE ref_agency_id_seq(uniq_id bigint,agency_id int default nextval('public.seq_ref_agency_agency_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE ref_agency_history_id_seq(uniq_id bigint,agency_history_id int default nextval('public.seq_ref_agency_history_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE stg_department(
	agency_code varchar(20) ,
	fund_class_code varchar(5) ,
	fiscal_year smallint,
	department_code varchar(20) ,
	department_name varchar(100),
	department_short_name varchar(15),
	uniq_id bigint default nextval('seq_stg_department_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar)
DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_department (LIKE stg_department) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_department ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_department (LIKE archive_department) DISTRIBUTED BY (uniq_id);

CREATE TABLE ref_department_id_seq(uniq_id bigint,department_id int default nextval('public.seq_ref_department_department_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE ref_department_history_id_seq(uniq_id bigint,department_history_id int default nextval('public.seq_ref_department_history_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE stg_expenditure_object(col1 varchar(100),fiscal_year smallint,expenditure_object_code varchar(4),expenditure_object_name varchar(40),
col5 varchar(100),col6 varchar(100),col7 varchar(100),col8 varchar(100),col9 varchar(100),col10 varchar(100),
col11 varchar(100),col12 varchar(100),col13 varchar(100),col14 varchar(100),col15 varchar(100),col16 varchar(100),
col17 varchar(100),col18 varchar(100),col19 varchar(100),col20 varchar(100),col21 varchar(100),col22 varchar(100),
col23 varchar(100),col24 varchar(100),col25 varchar(100),col26 varchar(100),col27 varchar(100),col28 varchar(100),
col29 varchar(100),col30 varchar(100),col31 varchar(100),col32 varchar(100),col33 varchar(100),col34 varchar(100),
col35 varchar(100),col36 varchar(100),col37 varchar(100),col38 varchar(100),col39 varchar(100),col40 varchar(100),
col41 timestamp,col42 varchar(100),col43 varchar(1),uniq_id bigint default nextval('seq_stg_expenditure_object_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar)
DISTRIBUTED BY (uniq_id);


CREATE TABLE archive_expenditure_object (LIKE stg_expenditure_object) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_expenditure_object ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_expenditure_object (LIKE archive_expenditure_object) DISTRIBUTED BY (uniq_id);

CREATE TABLE ref_expenditure_object_id_seq(uniq_id bigint,expenditure_object_id int default nextval('public.seq_ref_expenditure_object_expendtiure_object_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE ref_expenditure_object_history_id_seq(uniq_id bigint,expenditure_object_history_id int default nextval('public.seq_ref_expenditure_object_history_id'))
DISTRIBUTED BY (uniq_id);


 CREATE TABLE stg_location(
   	agency_code varchar(20),location_code varchar(4),location_name varchar(60),location_short_name varchar(16),upper_case_name varchar(60),
	col6 varchar(100),col7 varchar(100),col8 varchar(100),col9 varchar(100),col10 varchar(100),
	col11 varchar(100),col12 varchar(100),col13 varchar(100),col14 varchar(100),col15 varchar(100),col16 timestamp,col17 varchar(1),
	uniq_id bigint default nextval('seq_stg_location_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar
   	) DISTRIBUTED BY (uniq_id);
  
CREATE TABLE archive_location (LIKE stg_location) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_location ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_location (LIKE archive_location) DISTRIBUTED BY (uniq_id); 
  
 CREATE TABLE ref_location_id_seq(uniq_id bigint,location_id int default nextval('public.seq_ref_location_location_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE ref_location_history_id_seq(uniq_id bigint,location_history_id int default nextval('public.seq_ref_location_history_id'))
DISTRIBUTED BY (uniq_id);

 CREATE  TABLE stg_object_class(
 	object_class_code varchar(3),
 	object_class_name varchar(100),
 	short_name varchar(100),
 	act_fl bit,
 	effective_begin_date date,
 	effective_end_date date,
 	alw_bud_fl bit,
 	description varchar(100),
 	cntac_cd varchar(100),
 	object_class_name_up varchar(100),
 	tbl_last_dt timestamp,
 	intr_cty_fl bit,
 	cntrc_pos_fl bit,
 	pyrl_typ integer,
 	dscr_ext varchar(100),
	rltd_ocls_cd varchar(3),
	uniq_id bigint default nextval('seq_stg_object_class_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar
   	) DISTRIBUTED BY (uniq_id);	
	
CREATE TABLE archive_object_class (LIKE stg_object_class) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_object_class ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_object_class (LIKE archive_object_class) DISTRIBUTED BY (uniq_id); 


 CREATE TABLE ref_object_class_id_seq(uniq_id bigint,object_class_id int default nextval('public.seq_ref_object_class_object_class_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE ref_object_class_history_id_seq(uniq_id bigint,object_class_history_id int default nextval('public.seq_ref_object_class_history_id'))
DISTRIBUTED BY (uniq_id);




CREATE TABLE etl.stg_budget_code
(
		fy integer,
		fcls_cd	character varying(4),
		fcls_nm	character varying(60),
		dept_cd	character varying(4),
		dept_nm	character varying(60),
		func_cd	character varying(10),
		func_nm	character varying(60),
		func_attr_nm character varying(60),
		func_attr_sh_nm character varying(15),
		resp_ctr character varying(4),
		func_anlys_unit character varying(4),
		cntrl_cat character varying(4),
		local_svc_dist character varying(4),
		ua_fund_fl bit(1),
		pyrl_dflt_fl bit(1),
		bud_cat_a character varying(4),
		bud_cat_b character varying(4),
		bud_func character varying(5),
		dscr_ext character varying(1500),
		tbl_last_dt date,	
		func_attr_nm_up character varying(50),
		fin_plan_sav_fl bit(1),
		uniq_id bigint DEFAULT nextval('etl.seq_stg_budget_code_uniq_id'::regclass),
		invalid_flag character(1),
		invalid_reason character varying
		
) DISTRIBUTED BY (uniq_id);

---archive and invalid tables

CREATE TABLE archive_budget_code (LIKE etl.stg_budget_code) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_budget_code ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_budget_code (LIKE archive_budget_code) DISTRIBUTED BY (uniq_id);

CREATE TABLE etl.ref_budget_code_id_seq
(
  uniq_id bigint,
  budget_code_id integer DEFAULT nextval('public.seq_ref_budget_code_budget_code_id'::regclass)
)


DISTRIBUTED BY (uniq_id);



CREATE EXTERNAL table etl.ext_stg_funding_class
(
 doc_dept_cd varchar,
fy varchar,
funding_class_code varchar,
funding_class_name varchar,
short_name varchar,
category_name varchar,
cty_fund_fl varchar,
intr_cty_fl varchar,
fund_aloc_req_fl varchar,
tbl_last_dt varchar,
ams_row_vers_no varchar,
rsfcls_nm_up varchar,
fund_category varchar
)location
(
'gpfdist://mdw1:8081/datafiles/COA_funding_class_feed.txt'
)
FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
encoding 'utf8';

CREATE TABLE etl.stg_funding_class 
(
fy int,
 funding_class_code varchar(5),
 funding_class_name varchar(52),
 short_name varchar(50),
 category_name varchar(52),
 cty_fund_fl varchar,
 intr_cty_fl varchar,
 fund_aloc_req_fl varchar,
 tbl_last_dt varchar(20),
 ams_row_vers_no char(1),
 rsfcls_nm_up  varchar(52),
 fund_category  varchar(50),
 uniq_id bigint DEFAULT nextval('etl.seq_stg_funding_class_uniq_id'::regclass),
 invalid_flag character(1),
 invalid_reason character varying
)
WITH (
  OIDS=FALSE
)
DISTRIBUTED BY (uniq_id);



CREATE TABLE etl.archive_funding_class (LIKE etl.stg_funding_class)DISTRIBUTED BY (uniq_id);
ALTER TABLE etl.archive_funding_class ADD COLUMN load_file_id bigint;


CREATE TABLE etl.invalid_funding_class (LIKE etl.archive_funding_class) DISTRIBUTED BY (uniq_id);

CREATE TABLE etl.ref_funding_class_id_seq
(
  uniq_id bigint,
  funding_class_id integer DEFAULT nextval('public.seq_ref_funding_class_funding_class_id'::regclass)
)
DISTRIBUTED BY (uniq_id);


-- End of COA related tables
 
-- Start of MAG feed related tables

 
 CREATE EXTERNAL TABLE ext_stg_mag_data_feed(
record_type char(1),doc_cd varchar(8),doc_dept_cd varchar(20), doc_id varchar(20),doc_vers_no varchar,
	col6 varchar(100),col7 varchar(100),col8 varchar(100),col9 varchar(100),col10 varchar(100),
	col11 varchar,col12 varchar(100),col13 varchar,col14 varchar(100),col15 varchar(100),
	col16 varchar(255),col17 varchar(100),col18 varchar(100),col19 varchar(100),col20 varchar(255),
	col21 varchar(100),col22 varchar(100),col23 varchar(100),col24 varchar(100),col25 varchar(100),
	col26 varchar(100),col27 varchar(100),col28 varchar(100),col29 varchar(100),col30 varchar(100),
	col31 varchar(100),col32 varchar,col33 varchar,col34 varchar(100),col35 varchar(100),
	col36 varchar(100),col37 varchar(100),col38 varchar(100),col39 varchar(100),col40 varchar(255),
	col41 varchar(100),col42 varchar(100),col43 varchar(100),col44 varchar(100),col45 varchar(100),
	col46 varchar,col47 varchar(100),col48 varchar(100),col49 varchar(100),col50 varchar(100),
	col51 varchar(100),col52 varchar(100),col53 varchar(100),col54 varchar(100),col55 varchar(100),
	col56 varchar(100),col57 varchar,col58 varchar(100),col59 varchar,col60 varchar,
	col61 varchar,col62 varchar,col63 varchar,col64 varchar,col65 varchar(100),
	col66 varchar(100),col67 varchar(100),col68 varchar(100),col69 varchar(100),col70 varchar(100),
	col71 varchar(100),col72 varchar,col73 varchar(100),col74 varchar(100),col75 varchar(100),
	col76 varchar(100),col77 varchar(100),col78 varchar,col79 varchar(100),col80 varchar,
	col81 varchar(100),col82 varchar(100),col83 varchar(100),col84 varchar(100),col85 varchar(100),
	col86 varchar(100),col87 varchar(100),col88 varchar(100),col89 varchar(100),col90 varchar(100),
	col91 varchar(100),col92 varchar(100),col93 varchar(100),col94 varchar(100),col95 varchar(100),
	col96 varchar(100),col97 varchar(100),col98 varchar(100),col99 varchar(100),col100 varchar(100),
	col101 varchar(100),col102 varchar(100),col103 varchar(100),col104 varchar(100),col105 varchar(100),
	col106 varchar(100),col107 varchar(100),col108 varchar(100),col109 varchar(100)
  	)
  LOCATION (
  	    'gpfdist://mdw1:8081/datafiles/MAG_feed.txt')
  	    FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
 ENCODING 'UTF8';
 
CREATE TABLE etl.stg_mag_header
(
  doc_cd character varying(8),
  doc_dept_cd character varying(4),
  doc_id character varying(20),
  doc_vers_no integer,
  trkg_no character varying(30),
  doc_nm character varying(60),
  doc_rec_dt_dc date,
  doc_bfy integer,
  doc_fy_dc integer,
  doc_per_dc character(2),
  doc_dscr character varying(60),
  doc_actu_am numeric(16,2),
  ord_tot_am numeric(16,2),
  doc_clsd_am numeric(16,2),
  po_repl_doc_cd character varying(8),
  po_repl_id character varying(20),
  po_repl_by_dept_cd character varying(4),
  po_repl_by_id character varying(20),
  cntrc_sta integer,
  prcu_id character varying(20),
  prcu_typ_nm character varying(30),
  prcu_typ_id integer,
  cited_auth character varying(20),
  efbgn_dt date,
  efend_dt date,
  hear_dt timestamp without time zone,
  psr_req_dt timestamp without time zone,
  proc_ini_dt timestamp without time zone,
  brd_awd_no character varying(15),
  brd_awd_dt timestamp without time zone,
  tc_tmpl character varying(4),
  part_pymt_inv_alwd character(1),
  part_rect_alw_fl character(1),
  prnt_job_cd character varying(50),
  obj_att_sg_tot integer,
  obj_att_pg_tot integer,
  pc_chng_max_am numeric(16,2),
  wf_pc_chng_max_am numeric(16,2),
  wf_tot_max_am numeric(16,2),
  orig_max_ct_amt numeric(16,2),
  oca_no character varying(20),
  orig_strt_dt date,
  orig_end_dt date,
  reg_dt date,
  reas_mod_dc character varying,
  issr_id character varying(16),
  issr_nm character varying(61),
  issr_ph_no character varying(30),
  issr_ph_ext character varying(6),
  issr_email_ad character varying(100),
  rqstr_id character varying(16),
  rqstr_nm character varying(61),
  rqstr_ph_no character varying(30),
  rqstr_ph_ext character varying(6),
  rqstr_email_ad character varying(100),
  rqstr_dept_cd character varying(4),
  team_id character varying(16),
  buyr_nm character varying(61),
  buyr_ph_no character varying(30),
  buyr_ph_ext character varying(6),
  ofcr_nm character varying(30),
  ofcr_ph_no character varying(30),
  ofcr_ph_ext character varying(6),
  ofcr_email_ad character varying(60),
  ord_min_am numeric(16,2),
  ord_max_am numeric(16,2),
  ma_prch_lmt_am numeric(16,2),
  ord_min_fl character(1),
  ord_max_fl character(1),
  ma_prch_lmt_fl character(1),
  dscr_ext character varying,
  ship_loc_cd character varying(6),
  ship_meth_cd character varying(3),
  free_brd_cd character varying(3),
  dlvr_typ integer,
  dlvr_dy integer,
  ship_info character varying,
  bill_loc_cd character varying(6),
  bill_info character varying,
  gnrc_po_rpt_1 character varying(10),
  gnrc_po_rpt_2 character varying(10),
  gnrc_po_rpt_3 character varying(10),
  dept_report_1 character varying(25),
  dept_report_2 character varying(25),
  dept_report_3 character varying(25),
  dept_report_4 character varying(25),
  doc_crea_usid character varying(20),
  doc_appl_crea_dt date,
  doc_appl_last_usid character varying(20),
  doc_appl_last_dt date,
  po_repl_dept_cd character varying(4),
  po_repl_by_doc_cd character varying(8),
  doc_func_cd integer,
  document_code_id smallint,
  agency_history_id smallint,
  award_status_id smallint,
  document_function_code_id smallint,
  record_date_id int,
  procurement_type_id smallint,
  effective_begin_date_id int,
  effective_end_date_id int,
  source_created_date_id int,
  source_updated_date_id int,
  registered_date_id int,
  original_term_begin_date_id int,
  original_term_end_date_id int,
  board_approved_award_date_id int,
  registered_fiscal_year smallint,
  registered_fiscal_year_id smallint,
  registered_calendar_year smallint,
  registered_calendar_year_id smallint,
  effective_begin_fiscal_year smallint,
  effective_begin_fiscal_year_id smallint,
  effective_begin_calendar_year smallint,
  effective_begin_calendar_year_id smallint,
  effective_end_fiscal_year smallint,
  effective_end_fiscal_year_id smallint,
  effective_end_calendar_year smallint,
  effective_end_calendar_year_id smallint,
  source_updated_calendar_year smallint,
  source_updated_calendar_year_id smallint,
  source_updated_fiscal_year_id smallint,
  source_updated_fiscal_year smallint,
  uniq_id bigint DEFAULT nextval('etl.seq_stg_mag_header_uniq_id'::regclass),
  invalid_flag character(1),
  invalid_reason character varying
)
DISTRIBUTED BY (uniq_id);
 
CREATE TABLE stg_mag_award_detail(doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_awddet_ln_no integer,
	awd_meth_cd varchar(3),
	awd_lvl_cd varchar(2),
	cttyp_cd varchar(2),
	ctcls_cd varchar(2),
	clsd_typ_cd varchar(2),
	ctcat_cd_1 varchar(10),
	multi_cat_fl char(1),
	ctcat_cd_2 varchar(10),
	ctcat_cd_3 varchar(10),
	ctcat_cd_4 varchar(10),
	ctcat_cd_5 varchar(10),
	resp_no integer,
	out_of_no_so integer,
	loc_serv varchar(255),
	loc_zip varchar(10),
	brgh_cd varchar(10),
	blck_cd varchar(10),
	lot_cd varchar(10),
	coun_dist_cd varchar(10),
	rnew_cd varchar(2),
	cntrc_mwbe_fl char(1),
	tar_utl_pc integer,
	tar_utl_am decimal(18,2),
	comp_crt_cd_1 varchar(10),
	comp_cri_resp_1 integer,
	comp_crt_cd_2 varchar(10),
	comp_cri_resp_2 integer,
	comp_crt_cd_3 varchar(10),
	comp_cri_resp_3 integer,
	comp_crt_cd_4 varchar(10),
	comp_cri_resp_4 integer,
	comp_crt_cd_5 varchar(10),
	comp_cri_resp_5 integer ,
	non_comp_reas varchar(255),
	cons_reas_cd_1 varchar(2),
	cons_reas_cd_2 varchar(2),
	red_adv integer,
	constr_rel_fl char(1),
	extrn_so_no varchar(16),
	liq_dmg_chrg decimal(18,2),
	req_perf_py_bnd_fl char(1),
	reas_no_perf_bnd integer,
	wk_site_cd_01 varchar(3),
	wk_site_cd_02 varchar(3),
	wk_site_cd_03 varchar(3),
	wk_site_cd_04 varchar(3),
	wk_site_cd_05 varchar(3),
	wk_site_cd_06 varchar(3),
	wk_site_cd_07 varchar(3),
	wk_site_cd_08 varchar(3),
	wk_site_cd_09 varchar(3),
	wk_site_cd_10 varchar(3),
	percent_01 decimal(17,4),
	percent_02 decimal(17,4),
	percent_03 decimal(17,4),
	percent_04 decimal(17,4),
	percent_05 decimal(17,4),
	percent_06 decimal(17,4),
	percent_07 decimal(17,4),
	percent_08 decimal(17,4),
	percent_09 decimal(17,4),
	percent_10 decimal(17,4),
	award_method_id smallint,
	award_level_id smallint,
	agreement_type_id smallint,
	award_category_id_1 smallint,
	award_category_id_2 smallint, 
	award_category_id_3 smallint, 
	award_category_id_4 smallint,
	award_category_id_5 smallint,		
	uniq_id bigint default nextval('seq_stg_mag_award_detail_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
DISTRIBUTED BY (uniq_id)	;	
	
CREATE TABLE stg_mag_vendor(doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	vend_cust_cd varchar(20),
	lgl_nm varchar(60),
	alias_nm varchar(60),
	ad_id varchar(20),
	ad_ln_1 varchar(75),
	ad_ln_2 varchar(75),
	city varchar(60),
	st varchar(2),
	zip varchar(10),
	ctry varchar(3),
	vend_pref_lvl integer,
	cntac_id varchar(20),
	prin_cntac varchar(60),
	voice_ph_no varchar(30),
	voice_ph_ext varchar(6),
	email_ad varchar(100),
	ma_vend_typ integer,
	ma_doc_cd varchar(8),
	ma_doc_dept_cd varchar(4),
	ma_doc_id varchar(20),
	email_ad_dup varchar(100),
	tin_ein varchar(9),
	tin_ssn varchar(9),
	disc_1_dy integer,
	disc_2_dy integer,
	disc_3_dy integer,
	disc_4_dy integer,
	disc_1_pc decimal(17,4),
	disc_2_pc decimal(17,4),
	disc_3_pc decimal(17,4),
	disc_4_pc decimal(17,4),
	disc_alw_1_fl char(1),
	disc_alw_2_fl char(1),
	disc_alw_3_fl char(1),
	disc_alw_4_fl char(1),
	vendor_history_id bigint,
	uniq_id bigint default nextval('seq_stg_mag_vendor_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
DISTRIBUTED BY (uniq_id)	;	
	
CREATE TABLE stg_mag_commodity(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	doc_comm_ln_no integer,
	cl_dscr varchar(60),
	comm_cd varchar(14),
	ln_typ integer,
	qty decimal(27,5),
	unit_meas_cd varchar(4),
	unit_price decimal(28,6),
	ctlg varchar(60),
	ord_disc_pc decimal(28,6),
	lst_unit_price decimal(28,6),
	disc_unit_price decimal(28,6),
	disc_efbgn_dt date,
	disc_efend_dt date,
	cntrc_am decimal(20,2),
	svc_strt_dt date,
	svc_end_dt date,
	tax_prfl_cd varchar(10),
	comm_maint integer,
	tc_tmpl varchar(4),
	fa_fl char(1),
	lck_ord_fl char(1),
	alw_promo_price char(1),
	lck_ctlg_price integer,
	vend_pref_lvl integer,
	mrk_del_fl char(1),
	comm_cd_spfn text,
	dscr_ext text,
	itm_s_tot_am decimal(20,2),
	tax_tot_am decimal(20,2),
	itm_tot_am decimal(20,2),
	obj_att_sg_tot integer,
	rf_doc_cd varchar(8),
	rf_doc_dept_cd varchar(4),
	rf_doc_id varchar(20),
	rf_doc_vend_ln_no integer,
	rf_doc_comm_ln_no integer,
	rf_typ integer,
	so_doc_cd varchar(8),
	so_doc_dept_cd varchar(4),
	so_doc_id varchar(20),
	so_commgp_ln_no integer,
	so_commln_ln_no integer,
	invd_qty decimal(27,5),
	invd_cntrc_am decimal(20,2),
	lapsed_fl char(1),
	ship_loc_cd varchar(6),
	ship_meth_cd varchar(3),
	free_brd_cd varchar(3),
	dlvr_dy integer,
	dlvr_typ integer,
	ship_info text,
	bill_loc_cd varchar(6),
	bill_info text,
	det_inst text,
	pkg_inst text,
	haz_mat text,
	handl_spec_inst text,
	addl_hndl_info text,
	manfr_nm varchar(25),
	manfr_part_no varchar(25),
	prod_cat_no varchar(25),
	mdl_no varchar(25),
	drw_no varchar(25),
	piece_no varchar(25),
	ser_no varchar(25),
	spen_no varchar(25),
	sz varchar(25),
	color varchar(25),
	msds_fl char(1),
	wty_typ integer,
	tol_ovrg_qty decimal(27,5),
	tol_undg_qty decimal(27,5),
	tol_ovrg_cntrc_am decimal(20,2),
	tol_undg_cntrc_am decimal(20,2),
	tol_am_ovr_dol decimal(20,2),
	tol_am_undr_dol decimal(20,2),
	tol_am_undr_pc decimal(17,4),
	tol_am_ovr_pc decimal(17,4),
	undr_unit_price decimal(28,6),
	ovr_unit_price decimal(28,6),
	undr_unit_price_pc decimal(17,4),
	ovr_unit_price_pc decimal(17,4),
	wk_site_cd_01 varchar(3),
	percent_01 decimal(17,4),
	wk_site_cd_02 varchar(3),
	percent_02 decimal(17,4),
	wk_site_cd_03 varchar(3),
	percent_03 decimal(17,4),
	wk_site_cd_04 varchar(3),
	percent_04 decimal(17,4),
	wk_site_cd_05 varchar(3),
	percent_05 decimal(17,4),
	wk_site_cd_06 varchar(3),
	percent_06 decimal(17,4),
	wk_site_cd_07 varchar(3),
	percent_07 decimal(17,4),
	wk_site_cd_08 varchar(3),
	percent_08 decimal(17,4),
	wk_site_cd_09 varchar(3),
	percent_09 decimal(17,4),
	wk_site_cd_10 varchar(3),
	percent_10 decimal(17,4),
	commodity_type_id smallint,
	uniq_id bigint default nextval('seq_stg_mag_commodity_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
DISTRIBUTED BY (uniq_id)	;	

CREATE TABLE archive_mag_header (LIKE stg_mag_header) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_mag_header ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_mag_header (LIKE archive_mag_header) DISTRIBUTED BY (uniq_id);


CREATE TABLE archive_mag_award_detail (LIKE stg_mag_award_detail) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_mag_award_detail ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_mag_award_detail (LIKE archive_mag_award_detail) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_mag_vendor (LIKE stg_mag_vendor) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_mag_vendor ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_mag_vendor (LIKE archive_mag_vendor) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_mag_commodity (LIKE stg_mag_commodity) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_mag_commodity ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_mag_commodity (LIKE archive_mag_commodity) DISTRIBUTED BY (uniq_id);

-- End of MAG feed related tables

-- Start of FMSV related tables

 CREATE EXTERNAL TABLE ext_stg_fmsv_data_feed(record_type char(1),doc_dept_cd varchar,vend_cust_cd varchar,
					      bus_typ varchar,bus_typ_sta varchar,min_typ varchar,disp_cert_strt_dt varchar,
					      cert_end_dt varchar,init_dt varchar,col10 varchar )
 LOCATION (
  	    'gpfdist://mdw1:8081/datafiles/FMSV_feed.txt')
  	    FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
 ENCODING 'UTF8';

CREATE TABLE stg_fmsv_business_type(
	vend_cust_cd varchar(20),	
	bus_typ varchar(4),
	bus_typ_sta integer,
	min_typ integer,
	disp_cert_strt_dt date,
	cert_end_dt date,
	init_dt date,
	uniq_id bigint default nextval('seq_stg_fmsv_business_type_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar		)
DISTRIBUTED BY (uniq_id)	;

CREATE TABLE archive_fmsv_business_type (LIKE stg_fmsv_business_type) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_fmsv_business_type ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_fmsv_business_type (LIKE archive_fmsv_business_type) DISTRIBUTED BY (uniq_id);

CREATE TABLE vendor_id_seq(uniq_id bigint,vendor_id int DEFAULT nextval('public.seq_vendor_vendor_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE vendor_id_seq_pending(vendor_customer_code character varying(20), vendor_id int DEFAULT nextval('public.seq_vendor_vendor_id'))
DISTRIBUTED BY (vendor_customer_code);

CREATE TABLE vendor_history_id_seq(uniq_id bigint,vendor_history_id int DEFAULT nextval('public.seq_vendor_history_vendor_history_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE address_id_seq(uniq_id bigint,address_id int DEFAULT nextval('public.seq_address_address_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE vendor_address_id_seq(uniq_id bigint,vendor_address_id int DEFAULT nextval('public.seq_vendor_address_vendor_address_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE vendor_business_id_seq(uniq_id bigint,vendor_business_type_id int DEFAULT nextval('public.seq_vendor_bus_type_vendor_bus_type_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE ref_business_type_id_seq(uniq_id bigint,business_type_id int DEFAULT nextval('public.seq_ref_business_type_business_type_id'))
DISTRIBUTED BY (uniq_id);


-----------------------------------------------------------------------------------------------------------------------------------

/* CON data feed */

CREATE EXTERNAL TABLE ext_stg_con_data_feed(
	record_type char(1),
	doc_cd varchar(8),
	doc_dept_cd varchar(20),
	doc_id varchar(20),
	doc_vers_no varchar,
	col6 varchar(100),
	col7 varchar(100),
	col8 varchar(100),
	col9 varchar(100),
	col10 varchar(100),
	col11 varchar,
	col12 varchar(100),
	col13 varchar(100),
	col14 varchar,
	col15 varchar(100),
	col16 varchar(100),
	col17 varchar(100),
	col18 varchar(255),
	col19 varchar(255),
	col20 varchar(100),
	col21 varchar(100),
	col22 varchar(100),
	col23 varchar(100),
	col24 varchar,
	col25 varchar(100),
	col26 varchar(100),
	col27 varchar(100),
	col28 varchar(100),
	col29 varchar(100),
	col30 varchar(100),
	col31 varchar,
	col32 varchar,
	col33 varchar(500),
	col34 varchar(100),
	col35 varchar(100),
	col36 varchar(100),
	col37 varchar(100),
	col38 varchar(100),
	col39 varchar(255),
	col40 varchar(100),
	col41 varchar(100),
	col42 varchar(100),
	col43 varchar(100),
	col44 varchar(100),
	col45 varchar(100),
	col46 varchar(100),
	col47 varchar(100),
	col48 varchar(100),
	col49 varchar(100),
	col50 varchar(100),
	col51 varchar(100),
	col52 varchar(100),
	col53 varchar(100),
	col54 varchar(100),
	col55 varchar(100),
	col56 varchar(100),
	col57 varchar(100),
	col58 varchar(100),
	col59 varchar(100),
	col60 varchar(100),
	col61 varchar(100),
	col62 varchar(100),
	col63 varchar(100),
	col64 varchar(100),
	col65 varchar(100),
	col66 varchar(100),
	col67 varchar(100),
	col68 varchar(100),
	col69 varchar(100),
	col70 varchar,
	col71 varchar(100),
	col72 varchar,
	col73 varchar,
	col74 varchar,
	col75 varchar,
	col76 varchar,
	col77 varchar,
	col78 varchar(100),
	col79 varchar(100),
	col80 varchar(100),
	col81 varchar(100),
	col82 varchar(100),
	col83 varchar(100),
	col84 varchar(100),
	col85 varchar(100),
	col86 varchar(100),
	col87 varchar(100),
	col88 varchar(100),
	col89 varchar(100),
	col90 varchar(100),
	col91 varchar,
	col92 varchar(100),
	col93 varchar(100),
	col94 varchar(100),
	col95 varchar,
	col96 varchar(100),
	col97 varchar(100),
	col98 varchar(100),
	col99 varchar(100),
	col100 varchar(100),
	col101 varchar,
	col102 varchar(100),
	col103 varchar,
	col104 varchar(100),
	col105 varchar(100),
	col106 varchar(100),
	col107 varchar(100),
	col108 varchar(100),
	col109 varchar(100),
	col110 varchar(100),
	col111 varchar(100),
	col112 varchar(100),
	col113 varchar(100),
	col114 varchar(100),
	col115 varchar(100),
	col116 varchar(100),
	col117 varchar(100),
	col118 varchar(100),
	col119 varchar(100),
	col120 varchar(100),
	col121 varchar(100),
	col122 varchar(100),
	col123 varchar(100),
	col124 varchar(100),
	col125 varchar(100),
	col126 varchar(100),
	col127 varchar(100),
	col128 varchar(100),
	col129 varchar(100),
	col130 varchar(100),
	col131 varchar(100),
	col132 varchar(100),
	col133 varchar(100),
	col134 varchar(100),
	col135 varchar(100),
	col136 varchar(100),
	col137 varchar(100),
	col138 varchar(100),
	col139 varchar(100),
	col140 varchar(100),
	col141 varchar(100),
	col142 varchar(100),
	col143 varchar(100),
	col144 varchar(100),
	col145 varchar(100),
	col146 varchar(100),
	col147 varchar(100),
	col148 varchar(100),
	col149 varchar(100),
	col150 varchar(100),
	col151 varchar(100),
	col152 varchar(100),
	col153 varchar(100),
	col154 varchar(100),
	col155 varchar(100),
	col156 varchar(100),
	col157 varchar(100),
	col158 varchar(100),
	col159 varchar(100),
	col160 varchar(100),
	col161 varchar(100),
	col162 varchar(100),
	col163 varchar(100),
	col164 varchar(100),
	col165 varchar(100),
	col166 varchar(100),
	col167 varchar(100),
	col168 varchar(100),
	col169 varchar(100),
	col170 varchar(100),
	col171 varchar(100),
	col172 varchar(100))
LOCATION (
	    'gpfdist://mdw1:8081/datafiles/CON_feed.txt')
	    FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
ENCODING 'UTF8';

CREATE TABLE stg_con_ct_header (
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_nm varchar(60),
	doc_rec_dt_dc date,
	doc_bfy integer,
	doc_fy_dc integer,
	doc_per_dc char(2),
	doc_dscr varchar(60),
	doc_actu_am decimal(18,2),
	doc_clsd_am decimal(18,2),
	doc_clsd_dt date,
	open_am decimal(18,2),
	max_cntrc_am decimal(18,2),
	open_acrl_am decimal(18,2),
	amend_no varchar(19),
	cntrc_sta integer,
	pcard_rec_id varchar(20),
	pcard_expr_dt date,
	prcu_id varchar(20),
	prcu_typ_nm varchar(30),
	prcu_typ_id integer,
	cntrct_strt_dt date,
	cntrct_end_dt date,
	hear_dt date,
	psr_req_dt date,
	proc_ini_dt date,
	cited_auth varchar(20),
	actg_prfl_id varchar(6),
	tc_tmpl varchar(4),
	cnfrm_ord char(1),
	prnt_job_cd varchar(50),
	clsd_am decimal(18,2),
	last_prn_dt date,
	obj_att_sg_tot integer,
	obj_att_pg_tot integer,
	pc_chng_max_am decimal(18,2),
	wf_pc_chng_max_am decimal(18,2),
	wf_tot_max_am decimal(18,2),
	orig_max_am decimal(18,2),
	enc_am decimal(18,2),
	out_am decimal(18,2),
	rfed_am decimal(18,2),
	rfed_lqd_am decimal(18,2),
	oca_no varchar(20),
	orig_cntrc_strt_dt date,
	orig_cntrc_end_dt date,
	reg_dt date,
	oblg_adj_outyr_am decimal(18,2),
	avail_oblg_am decimal(18,2),
	outyr_adj_am decimal(18,2),
	part_rect_alw_fl char(1),
	agree_doc_cd varchar(8),
	agree_doc_dept_cd varchar(4),
	agree_doc_id varchar(20),
	agree_vend_ln_no integer,
	brd_awd_no varchar(15),
	brd_awd_dt date,
	trkg_no varchar(30),
	po_repl_doc_cd varchar(8),
	po_repl_dept_cd varchar(4),
	po_repl_id varchar(20),
	po_repl_by_doc_cd varchar(8),
	po_repl_by_dept_cd varchar(4),
	po_repl_by_id varchar(20),
	issr_id varchar(16),
	issr_nm varchar(61),
	issr_ph_no varchar(30),
	issr_email_ad varchar(100),
	rqstr_id varchar(16),
	rqstr_nm varchar(61),
	rqstr_ph_no varchar(30),
	rqstr_ph_ext varchar(6),
	rqstr_email_ad varchar(100),
	rqstr_dept_cd varchar(4),
	team_id varchar(16),
	buyr_id varchar(16),
	buyr_nm varchar(61),
	buyr_ph_no varchar(30),
	buyr_ph_ext varchar(6),
	buyr_email_ad varchar(100),
	cntrct_ofcr varchar(30),
	cntrct_ofcr_ph varchar(30),
	ofcr_ph_ext varchar(6),
	cntrct_ofcr_eml varchar(30),
	track_chgs char(1),
	chg_ord_no integer,
	mod_fl char(1),
	reas_mod_dc varchar,
	cmr_doc_cd varchar(8),
	cmr_doc_dept_cd varchar(4),
	cmr_doc_id varchar(20),
	dscr_ext varchar,
	ship_loc_cd varchar(6),
	ship_meth_cd varchar(3),
	free_brd_cd varchar(3),
	dlvr_dt date,
	dlvr_typ integer,
	ship_info varchar,
	bill_loc_cd varchar(6),
	bill_info varchar,
	gnrc_po_rpt_1 varchar(10),
	gnrc_po_rpt_2 varchar(10),
	gnrc_po_rpt_3 varchar(10),
	doc_crea_usid varchar(20),
	doc_appl_crea_dt date,
	doc_appl_last_usid varchar(20),
	doc_appl_last_dt date,
	rl_fl_1 char(1),
	doc_func_cd  integer,
	document_code_id smallint,
	agency_history_id smallint,
	record_date_id int,
	effective_begin_date_id int,
	effective_end_date_id int,
	source_created_date_id int,
	source_updated_date_id int,
	registered_date_id int, 
	original_term_begin_date_id int,
	original_term_end_date_id int,	
	master_agreement_id bigint,
	registered_fiscal_year smallint,
	registered_fiscal_year_id smallint, 
	registered_calendar_year smallint,
	registered_calendar_year_id smallint,
	effective_begin_fiscal_year smallint,
	effective_begin_fiscal_year_id smallint, 
	effective_begin_calendar_year smallint,
	effective_begin_calendar_year_id smallint,
	effective_end_fiscal_year smallint,
	effective_end_fiscal_year_id smallint, 
	effective_end_calendar_year smallint,
	effective_end_calendar_year_id smallint,
	source_updated_calendar_year smallint,
	source_updated_calendar_year_id smallint,
	source_updated_fiscal_year_id smallint,
	source_updated_fiscal_year smallint,
	uniq_id bigint default nextval('seq_stg_con_ct_header_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar)
DISTRIBUTED BY (uniq_id)	;	
	
CREATE TABLE stg_con_ct_award_detail(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	awd_meth_cd varchar(3),
	awd_lvl_cd varchar(2),
	cttyp_cd varchar(2),
	ctcls_cd varchar(2),
	clsd_typ_cd varchar(2),
	ctcat_cd_1 varchar(10),
	multi_cat_fl char(1),
	ctcat_cd_2 varchar(10),
	ctcat_cd_3 varchar(10),
	ctcat_cd_4 varchar(10),
	ctcat_cd_5 varchar(10),
	resp_ct integer,
	out_of_no_so integer,
	loc_serv varchar(255),
	loc_zip varchar(10),
	brgh_cd varchar(10),
	blck_cd varchar(10),
	lot_cd varchar(10),
	coun_dist_cd varchar(10),
	rnew_cd varchar(2),
	cntrc_mwbe_fl char(1),
	tar_utl_pc integer,
	tar_utl_am decimal(18,2),
	comp_crt_cd_1 varchar(10),
	comp_cri_resp_1 integer,
	comp_crt_cd_2 varchar(10),
	comp_cri_resp_2 integer,
	comp_crt_cd_3 varchar(10),
	comp_cri_resp_3 integer,
	comp_crt_cd_4 varchar(10),
	comp_cri_resp_4 integer,
	comp_crt_cd_5 varchar(10),
	comp_cri_resp_5 integer,
	non_comp_reas varchar(255),
	cons_reas_cd_1 varchar(2),
	cons_reas_cd_2 varchar(2),
	red_adv integer,
	constr_rel_fl char(1),
	extrn_so_no varchar(16),
	liq_dmg_chrg decimal(18,2),
	req_prf_pay_bnd_fl char(1),
	res_no_per_bnd integer,
	cnt_req_ins_pol_fl char(1),
	wk_site_cd_01 varchar(3),
	wk_site_cd_02 varchar(3),
	wk_site_cd_03 varchar(3),
	wk_site_cd_04 varchar(3),
	wk_site_cd_05 varchar(3),
	wk_site_cd_06 varchar(3),
	wk_site_cd_07 varchar(3),
	wk_site_cd_08 varchar(3),
	wk_site_cd_09 varchar(3),
	wk_site_cd_10 varchar(3),
	percent_01 decimal(17,4),
	percent_02 decimal(17,4),
	percent_03 decimal(17,4),
	percent_04 decimal(17,4),
	percent_05 decimal(17,4),
	percent_06 decimal(17,4),
	percent_07 decimal(17,4),
	percent_08 decimal(17,4),
	percent_09 decimal(17,4),
	percent_10 decimal(17,4),
	award_method_id smallint,
	award_level_id smallint,
	agreement_type_id smallint,
	award_category_id_1 smallint,
	award_category_id_2 smallint, 
	award_category_id_3 smallint, 
	award_category_id_4 smallint,
	award_category_id_5 smallint,	
	uniq_id bigint default nextval('seq_stg_con_ct_award_detail_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
DISTRIBUTED BY (uniq_id)	;	
	
CREATE TABLE stg_con_ct_vendor(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	vend_cust_cd varchar(20),
	ad_id varchar(20),
	ad_ln_1 varchar(75),
	ad_ln_2 varchar(75),
	city varchar(60),
	st varchar(2),
	zip varchar(10),
	ctry varchar(3),
	web_ad varchar(100),
	cntac_id varchar(20),
	vend_pref_lvl integer,
	alias_nm varchar(60),
	lgl_nm varchar(60),
	prin_cntac varchar(60),
	voice_ph_no varchar(30),
	voice_ph_ext varchar(6),
	email_ad varchar(100),
	vend_reas varchar,
	tin_ein varchar(9),
	tin_ssn varchar(9),
	mod_fl char(1),
	disc_1_dy integer,
	disc_2_dy integer,
	disc_3_dy integer,
	disc_4_dy integer,
	disc_1_pc decimal(17,4),
	disc_2_pc decimal(17,4),
	disc_3_pc decimal(17,4),
	disc_4_pc decimal(17,4),
	disc_alw_1_fl char(1),
	disc_alw_2_fl char(1),
	disc_alw_3_fl char(1),
	disc_alw_4_fl char(1),
	vendor_history_id bigint,
	uniq_id bigint default nextval('seq_stg_con_ct_vendor_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
DISTRIBUTED BY (uniq_id)	;	
	
CREATE TABLE stg_con_ct_commodity(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	doc_comm_ln_no integer,
	cl_dscr varchar(60),
	comm_cd varchar(14),
	stk_itm_sfx varchar(3),
	supp_part_no varchar(32),
	ln_typ integer,
	qty decimal(27,5),
	unit_meas_cd varchar(4),
	unit_price decimal(28,6),
	disc_unit_price decimal(28,6),
	lst_unit_price decimal(28,6),
	cntrc_am decimal(16,2),
	svc_strt_dt date,
	svc_end_dt date,
	actg_prfl_id varchar(6),
	actg_tmpl_id varchar(6),
	tax_prfl_cd varchar(10),
	comm_maint integer,
	tc_tmpl_id varchar(4),
	fa_fl character(1),
	lck_ord_fl character(1),
	lck_ctlg_price integer,
	vend_pref_lvl integer,
	mrk_del_fl character(1),
	comm_cd_spfn varchar,
	dscr_ext varchar,
	nrs_fndg_tot decimal(16,2),
	itm_s_tot_am decimal(16,2),
	tax_tot_am decimal(16,2),
	itm_tot_am decimal(16,2),
	comm_clsd_am decimal(16,2),
	open_am decimal(16,2),
	clsd_qty decimal(27,5),
	open_qty decimal(27,5),
	clsd_cntrc_am decimal(16,2),
	open_cntrc_am decimal(16,2),
	mod_fl character(1),
	obj_att_sg_tot integer,
	rf_doc_cd varchar(8),
	rf_doc_dept_cd varchar(4),
	rf_doc_id varchar(20),
	rf_doc_comm_ln_no integer,
	rf_typ integer,
	trkg_no varchar(30),
	agree_doc_cd varchar(8),
	agree_doc_dept_cd varchar(4),
	agree_doc_id varchar(20),
	agree_comm_ln_no integer,
	so_doc_cd varchar(8),
	so_doc_dept_cd varchar(4),
	so_doc_id varchar(20),
	so_commgp_ln_no integer,
	so_commln_ln_no integer,
	ur_doc_cd varchar(8),
	ur_doc_dept_cd varchar(4),
	ur_doc_id varchar(20),
	ur_commgp_ln_no integer,
	ur_comm_ln_no integer,
	ship_loc_cd varchar(6),
	ship_meth_cd varchar(3),
	free_brd_cd varchar(3),
	dlvr_dt date,
	dlvr_typ integer,
	ship_info varchar,
	bill_loc_cd varchar(6),
	bill_info varchar,
	det_inst varchar,
	pkg_inst varchar,
	haz_mat varchar,
	handl_spec_inst varchar,
	addl_hndl_info varchar,
	manfr_nm varchar(25),
	manfr_part_no varchar(25),
	prod_cat_no varchar(25),
	mdl_no varchar(25),
	drw_no varchar(25),
	piece_no varchar(25),
	ser_no varchar(25),
	spen_no varchar(25),
	sz varchar(25),
	color varchar(25),
	msds_fl character(1),
	wty_typ integer,
	invd_qty decimal(27,5),
	invd_cntrc_am decimal(16,2),
	invd_am decimal(16,2),
	invd_fnl_fl character(1),
	rcvd_qty decimal(27,5),
	rcvd_cntrc_am decimal(16,2),
	rcvd_fnl_fl character(1),
	pd_qty decimal(27,5),
	pd_cntrc_am decimal(16,2),
	rfed_am decimal(16,2),
	mtch_ind integer,
	pd_fnl_fl character(1),
	rtg_lwr_lmt_am_1 decimal(16,2),
	rtg_upr_lmt_am_1 decimal(16,2),
	rtg_am_1 decimal(16,2),
	rtg_lwr_lmt_pc_1 decimal(11,2),
	rtg_upr_lmt_pc_1 decimal(11,2),
	rtg_pc_1 decimal(11,2),
	rtg_lwr_lmt_am_2 decimal(16,2),
	rtg_upr_lmt_am_2 decimal(16,2),
	rtg_am_2 decimal(16,2),
	rtg_lwr_lmt_pc_2 decimal(11,2),
	rtg_upr_lmt_pc_2 decimal(11,2),
	rtg_pc_2 decimal(11,2),
	rtg_lwr_lmt_am_3 decimal(16,2),
	rtg_upr_lmt_am_3 decimal(16,2),
	rtg_am_3 decimal(16,2),
	rtg_lwr_lmt_pc_3 decimal(11,2),
	rtg_upr_lmt_pc_3 decimal(11,2),
	rtg_pc_3 decimal(11,2),
	rtg_lwr_lmt_am_4 decimal(16,2),
	rtg_upr_lmt_am_4 decimal(16,2),
	rtg_am_4 decimal(16,2),
	rtg_lwr_lmt_pc_4 decimal(11,2),
	rtg_upr_lmt_pc_4 decimal(11,2),
	rtg_pc_4 decimal(11,2),
	rtg_lwr_lmt_am_5 decimal(16,2),
	rtg_upr_lmt_am_5 decimal(16,2),
	rtg_am_5 decimal(16,2),
	rtg_lwr_lmt_pc_5 decimal(11,2),
	rtg_upr_lmt_pc_5 decimal(11,2),
	rtg_pc_5 decimal(11,2),
	tol_ovrg_qty decimal(27,5),
	tol_undg_qty decimal(27,5),
	tol_ovrg_cntrc_am decimal(16,2),
	tol_undg_cntrc_am decimal(16,2),
	tol_am_undr_dol decimal(16,2),
	tol_am_undr_pc decimal(17,4),
	tol_am_ovr_dol decimal(16,2),
	tol_am_ovr_pc decimal(17,4),
	disc_1_pc decimal(17,4),
	disc_1_dy integer,
	disc_alw_1_fl character(1),
	disc_2_pc decimal(17,4),
	disc_2_dy integer,
	disc_alw_2_fl character(1),
	disc_3_pc decimal(17,4),
	disc_3_dy integer,
	disc_alw_3_fl character(1),
	disc_4_pc decimal(17,4),
	disc_4_dy integer,
	disc_alw_4_fl character(1),
	wk_site_cd_01 varchar(3),
	percent_01 decimal(17,4),
	wk_site_cd_02 varchar(3),
	percent_02 decimal(17,4),
	wk_site_cd_03 varchar(3),
	percent_03 decimal(17,4),
	wk_site_cd_04 varchar(3),
	percent_04 decimal(17,4),
	wk_site_cd_05 varchar(3),
	percent_05 decimal(17,4),
	wk_site_cd_06 varchar(3),
	percent_06 decimal(17,4),
	wk_site_cd_07 varchar(3),
	percent_07 decimal(17,4),
	wk_site_cd_08 varchar(3),
	percent_08 decimal(17,4),
	wk_site_cd_09 varchar(3),
	percent_09 decimal(17,4),
	wk_site_cd_10 varchar(3),
	percent_10 decimal(17,4),
	commodity_type_id smallint,
	uniq_id bigint default nextval('seq_stg_con_ct_commodity_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
DISTRIBUTED BY (uniq_id)	;	
	
CREATE TABLE stg_con_ct_accounting_line(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	doc_comm_ln_no integer,
	doc_actg_ln_no integer,
	evnt_typ_id varchar(4),
	actg_tmpl_id varchar(6),
	actg_ln_dscr varchar(100),
	ln_am decimal(16,2),
	rs_fndg_ind integer,
	bfy integer,
	fy_dc integer,
	per_dc char(2),
	frght_pc decimal(17,4),
	mod_fl char,
	obj_att_sg_tot integer,
	al_clsd_am decimal(16,2),
	al_clsd_dt date,
	ln_open_am decimal(16,2),
	rfed_ln_am decimal(16,2),
	outyr_adj_am decimal(16,2),
	oblg_adj_outyr_am decimal(16,2),
	rel_actg_ln integer,
	rfed_doc_cd varchar(8),
	rfed_doc_dept_cd varchar(4),
	rfed_doc_id varchar(20),
	rfed_vend_ln_no integer,
	rfed_comm_ln_no integer,
	rfed_actg_ln_no integer,
	rf_typ integer,
	fund_cd varchar(4),
	sfund_cd varchar(4),
	dept_cd varchar(4),
	unit_cd varchar(8),
	sunit_cd varchar(4),
	appr_cd varchar(9),
	obj_cd varchar(4),
	sobj_cd varchar(4),
	rsrc_cd varchar(5),
	srsrc_cd varchar(5),
	bsa_cd varchar(4),
	sbsa_cd varchar(4),
	obsa_cd varchar(4),
	osbsa_cd varchar(4),
	dobj_cd varchar(5),
	drsrc_cd varchar(4),
	loc_cd varchar(4),
	sloc_cd varchar(4),
	actv_cd varchar(10),
	sactv_cd varchar(4),
	func_cd varchar(10),
	sfunc_cd varchar(4),
	rpt_cd varchar(15),
	srpt_cd varchar(4),
	task_cd varchar(4),
	stask_cd varchar(4),
	task_ord_cd varchar(6),
	mjr_prog_cd varchar(6),
	prog_cd varchar(10),
	phase_cd varchar(6),
	ppc_cd varchar(6),
	fn_doc_cd varchar(8),
	fn_doc_dept_cd varchar(4),
	fn_doc_id varchar(20),
	sp_inst_cd varchar(4),
	rl_fl_1 char,
	rl_fl_2 char,
	event_type_id smallint, 
	fund_class_id smallint,
	agency_history_id smallint,
	department_history_id int, 
	expenditure_object_history_id integer,
	budget_code_id integer,
	uniq_id bigint default nextval('seq_stg_con_ct_accounting_line_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
DISTRIBUTED BY (uniq_id)	;

CREATE TABLE stg_con_po_header(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_nm varchar(60),
	doc_rec_dt_dc date,
	doc_bfy integer,
	doc_fy_dc integer,
	doc_per_dc character(2),
	doc_dscr varchar(60),
	doc_actu_am decimal(18,2),
	doc_clsd_am decimal(18,2),
	doc_clsd_dt date,
	open_am decimal(18,2),
	open_acrl_am decimal(18,2),
	max_cntrc_am decimal(18,2),
	amend_no varchar(19),
	pcard_rec_id varchar(20),
	pcard_expr_dt date,
	prcu_id varchar(20),
	prcu_typ_nm varchar(30),
	prcu_typ_id integer,
	cited_auth varchar(20),
	cntrct_strt_dt timestamp,
	cntrct_end_dt timestamp,
	psr_req_dt timestamp,
	actg_prfl_id varchar(6),
	tc_tmpl varchar(4),
	cnfrm_ord character(1),
	prnt_job_cd varchar(50),
	last_prn_dt date,
	obj_att_sg_tot integer,
	obj_att_pg_tot integer,
	oblg_adj_outyr_am decimal(18,2),
	avail_oblg_am decimal(18,2),
	outyr_adj_am decimal(18,2),
	ma_prch_lmt_am decimal(18,2),
	part_rect_alw_fl character(1),
	agree_doc_cd varchar(8),
	agree_doc_dept_cd varchar(4),
	agree_doc_id varchar(20),
	agree_vend_ln_no integer,
	trkg_no varchar(30),
	brd_awd_no varchar(15),
	brd_awd_dt timestamp,
	po_repl_doc_cd varchar(8),
	po_repl_dept_cd varchar(4),
	po_repl_id varchar(20),
	po_repl_by_doc_cd varchar(8),
	po_repl_by_dept_cd varchar(4),
	po_repl_by_id varchar(20),
	rfed_am decimal(18,2),
	rfed_lqd_am decimal(18,2),
	issr_id varchar(16),
	issr_ph_no varchar(30),
	issr_ph_ext varchar(6),
	issr_email_ad varchar(100),
	rqstr_id varchar(16),
	rqstr_nm varchar(61),
	rqstr_ph_no varchar(30),
	rqstr_email_ad varchar(100),
	rqstr_dept_cd varchar(4),
	team_id varchar(16),
	buyr_id varchar(16),
	cntrct_ofcr varchar(30),
	cntrct_ofcr_ph varchar(30),
	ofcr_ph_ext varchar(6),
	cntrct_ofcr_eml varchar(30),
	track_chgs character(1),
	chg_ord_no integer,
	mod_fl character(1),
	reas_mod_dc text,
	dscr_ext text,
	ship_loc_cd varchar(6),
	ship_meth_cd varchar(3),
	free_brd_cd varchar(3),
	dlvr_dt date,
	dlvr_typ integer,
	ship_info text,
	bill_loc_cd varchar(6),
	bill_info text,
	gnrc_po_rpt_1 varchar(10),
	gnrc_po_rpt_2 varchar(10),
	gnrc_po_rpt_3 varchar(10),
	fn_doc_cd varchar(8),
	fn_doc_dept_cd varchar(4),
	fn_doc_id varchar(20),
	doc_crea_usid varchar(20),
	doc_appl_crea_dt date,
	doc_appl_last_usid varchar(20),
	doc_appl_last_dt date,
	rl_fl_1 character(1),
	doc_func_cd  integer,
	document_code_id smallint,
	agency_history_id smallint,
	document_function_code_id smallint, 
	record_date_id int,
	procurement_type_id smallint,
	effective_begin_date_id int,
	effective_end_date_id int,
	source_created_date_id int,
	source_updated_date_id int,
	master_agreement_id bigint,
	effective_begin_fiscal_year smallint,
  	effective_begin_fiscal_year_id smallint,
  	effective_begin_calendar_year smallint,
  	effective_begin_calendar_year_id smallint,
  	effective_end_fiscal_year smallint,
  	effective_end_fiscal_year_id smallint,
  	effective_end_calendar_year smallint,
  	effective_end_calendar_year_id smallint,
  	source_updated_calendar_year smallint,
  	source_updated_calendar_year_id smallint,
  	source_updated_fiscal_year_id smallint,
  	source_updated_fiscal_year smallint,
	uniq_id bigint default nextval('seq_stg_con_po_header_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
	DISTRIBUTED BY (uniq_id);
	
CREATE TABLE stg_con_po_award_detail(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	awd_meth_cd varchar(3),
	awd_lvl_cd varchar(2),
	cttyp_cd varchar(2),
	ctcls_cd varchar(2),
	ctcat_cd_1 varchar(10),
	resp_ct integer,
	out_of_no_so integer,
	constr_rel_fl character(1),
	extrn_so_no varchar(16),
	wk_site_cd_01 varchar(3),
	percent_01 decimal(17,4),
	wk_site_cd_02 varchar(3),
	percent_02 decimal(17,4),
	wk_site_cd_03 varchar(3),
	percent_03 decimal(17,4),
	wk_site_cd_04 varchar(3),
	percent_04 decimal(17,4),
	wk_site_cd_05 varchar(3),
	percent_05 decimal(17,4),
	wk_site_cd_06 varchar(3),
	percent_06 decimal(17,4),
	wk_site_cd_07 varchar(3),
	percent_07 decimal(17,4),
	wk_site_cd_08 varchar(3),
	percent_08 decimal(17,4),
	wk_site_cd_09 varchar(3),
	percent_09 decimal(17,4),
	wk_site_cd_10 varchar(3),
	percent_10 decimal(17,4),
	award_method_id smallint,
	award_level_id smallint,
	agreement_type_id smallint,
	award_category_id_1 smallint,
	uniq_id bigint default nextval('seq_stg_con_po_award_detail_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
	DISTRIBUTED BY (uniq_id);	

CREATE TABLE stg_con_po_vendor(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	vend_cust_cd varchar(20),
	lgl_nm varchar(60),
	alias_nm varchar(60),
	ad_id varchar(20),
	ad_ln_1 varchar(75),
	ad_ln_2 varchar(75),
	city varchar(60),
	st varchar(2),
	zip varchar(10),
	ctry varchar(3),
	vend_pref_lvl integer,
	web_ad varchar(100),
	cntac_id varchar(20),
	prin_cntac varchar(60),
	voice_ph_no varchar(30),
	voice_ph_ext varchar(6),
	email_ad varchar(100),
	vend_reas text,
	mod_fl character(1),
	disc_1_pc decimal(17,4),
	disc_1_dy integer,
	disc_alw_1_fl character(1),
	disc_2_pc decimal(17,4),
	disc_2_dy integer,
	disc_alw_2_fl character(1),
	disc_3_pc decimal(17,4),
	disc_3_dy integer,
	disc_alw_3_fl character(1),
	disc_4_pc decimal(17,4),
	disc_4_dy integer,
	disc_alw_4_fl character(1),
	vendor_history_id bigint,
	uniq_id bigint default nextval('seq_stg_con_po_vendor_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
	DISTRIBUTED BY (uniq_id);	
	
CREATE TABLE stg_con_po_commodity (
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	doc_comm_ln_no integer,
	cl_dscr varchar(60),
	whse_cd varchar(8),
	comm_cd varchar(14),
	stk_itm_sfx varchar(3),
	supp_part_no varchar(32),
	ln_typ integer,
	qty decimal(27,5),
	unit_meas_cd varchar(4),
	unit_price decimal(28,6),
	disc_unit_price decimal(28,6),
	lst_unit_price decimal(28,6),
	cntrc_am decimal(18,2),
	svc_strt_dt date,
	svc_end_dt date,
	actg_tmpl_id varchar(6),
	tax_prfl_cd varchar(10),
	tc_tmpl_id varchar(4),
	fa_fl character(1),
	lck_ord_fl character(1),
	alw_promo_price character(1),
	lck_ctlg_price integer,
	vend_pref_lvl integer,
	mrk_del_fl character(1),
	comm_cd_spfn varchar,
	dscr_ext varchar,
	nrs_fndg_tot decimal(18,2),
	itm_s_tot_am decimal(18,2),
	tax_tot_am decimal(18,2),
	itm_tot_am decimal(18,2),
	comm_clsd_am decimal(18,2),
	open_am decimal(18,2),
	open_acrl_am decimal(18,2),
	clsd_qty decimal(27,5),
	open_qty decimal(27,5),
	clsd_cntrc_am decimal(18,2),
	open_cntrc_am decimal(18,2),
	mod_fl character(1),
	obj_att_sg_tot integer,
	rf_doc_cd varchar(8),
	rf_doc_dept_cd varchar(4),
	rf_doc_id varchar(20),
	rf_doc_comm_ln_no integer,
	rf_typ integer,
	so_doc_cd varchar(8),
	so_doc_dept_cd varchar(4),
	so_doc_id varchar(20),
	so_commgp_ln_no integer,
	ur_doc_cd varchar(8),
	ur_doc_dept_cd varchar(4),
	ur_doc_id varchar(20),
	ur_commgp_ln_no integer,
	ur_comm_ln_no integer,
	fn_doc_cd varchar(8),
	fn_doc_dept_cd varchar(4),
	fn_doc_id varchar(20),
	ship_loc_cd varchar(6),
	ship_meth_cd varchar(3),
	free_brd_cd varchar(3),
	dlvr_dt date,
	dlvr_typ integer,
	ship_info varchar,
	bill_loc_cd varchar(6),
	bill_info varchar,
	det_inst varchar,
	pkg_inst varchar,
	haz_mat varchar,
	handl_spec_inst varchar,
	addl_hndl_info varchar,
	manfr_nm varchar(25),
	manfr_part_no varchar(25),
	prod_cat_no varchar(25),
	mdl_no varchar(25),
	drw_no varchar(25),
	piece_no varchar(25),
	ser_no varchar(25),
	spen_no varchar(25),
	sz varchar(25),
	color varchar(25),
	msds_fl character(1),
	wty_typ integer,
	invd_qty decimal(27,5),
	invd_cntrc_am decimal(18,2),
	invd_am decimal(18,2),
	invd_fnl_fl character(1),
	rcvd_qty decimal(27,5),
	rcvd_cntrc_am decimal(18,2),
	rcvd_fnl_fl character(1),
	pd_qty decimal(27,5),
	pd_cntrc_am decimal(18,2),
	mtch_ind integer,
	pd_fnl_fl character(1),
	rfed_am decimal(18,2),
	rtg_lwr_lmt_am_1 decimal(18,2),
	rtg_upr_lmt_am_1 decimal(18,2),
	rtg_am_1 decimal(18,2),
	rtg_lwr_lmt_pc_1 decimal(11,2),
	rtg_upr_lmt_pc_1 decimal(11,2),
	rtg_pc_1 decimal(11,2),
	rtg_lwr_lmt_am_2 decimal(18,2),
	rtg_upr_lmt_am_2 decimal(18,2),
	rtg_am_2 decimal(18,2),
	rtg_lwr_lmt_pc_2 decimal(11,2),
	rtg_upr_lmt_pc_2 decimal(11,2),
	rtg_pc_2 decimal(11,2),
	rtg_lwr_lmt_am_3 decimal(18,2),
	rtg_upr_lmt_am_3 decimal(18,2),
	rtg_am_3 decimal(18,2),
	rtg_lwr_lmt_pc_3 decimal(11,2),
	rtg_upr_lmt_pc_3 decimal(11,2),
	rtg_pc_3 decimal(11,2),
	rtg_lwr_lmt_am_4 decimal(18,2),
	rtg_upr_lmt_am_4 decimal(18,2),
	rtg_am_4 decimal(18,2),
	rtg_lwr_lmt_pc_4 decimal(11,2),
	rtg_upr_lmt_pc_4 decimal(11,2),
	rtg_pc_4 decimal(11,2),
	rtg_lwr_lmt_am_5 decimal(18,2),
	rtg_upr_lmt_am_5 decimal(18,2),
	rtg_am_5 decimal(18,2),
	rtg_lwr_lmt_pc_5 decimal(11,2),
	rtg_upr_lmt_pc_5 decimal(11,2),
	rtg_pc_5 decimal(11,2),
	tol_ovrg_qty decimal(27,5),
	tol_undg_qty decimal(27,5),
	tol_am_ovr_dol decimal(18,2),
	tol_am_undr_dol decimal(18,2),
	tol_am_undr_dol_dup decimal(18,2),
	tol_am_undr_pc decimal(17,4),
	tol_am_ovr_dol_dup decimal(18,2),
	tol_am_ovr_pc decimal(17,4),
	disc_1_pc decimal(17,4),
	disc_1_dy integer,
	disc_alw_1_fl character(1),
	disc_2_pc decimal(17,4),
	disc_2_dy integer,
	disc_alw_2_fl character(1),
	disc_3_pc decimal(17,4),
	disc_3_dy integer,
	disc_alw_3_fl character(1),
	disc_4_pc decimal(17,4),
	disc_4_dy integer,
	disc_alw_4_fl character(1),
	wk_site_cd_01 varchar(3),
	percent_01 decimal(17,4),
	wk_site_cd_02 varchar(3),
	percent_02 decimal(17,4),
	wk_site_cd_03 varchar(3),
	percent_03 decimal(17,4),
	wk_site_cd_04 varchar(3),
	percent_04 decimal(17,4),
	wk_site_cd_05 varchar(3),
	percent_05 decimal(17,4),
	wk_site_cd_06 varchar(3),
	percent_06 decimal(17,4),
	wk_site_cd_07 varchar(3),
	percent_07 decimal(17,4),
	wk_site_cd_08 varchar(3),
	percent_08 decimal(17,4),
	wk_site_cd_09 varchar(3),
	percent_09 decimal(17,4),
	wk_site_cd_10 varchar(3),
	percent_10 decimal(17,4),
	commodity_type_id smallint,
	uniq_id bigint default nextval('seq_stg_con_po_commodity_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
	DISTRIBUTED BY (uniq_id);	
	
CREATE TABLE stg_con_po_accounting_line(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	doc_comm_ln_no integer,
	doc_actg_ln_no integer,
	evnt_typ_id varchar(4),
	actg_tmpl_id varchar(6),
	actg_ln_dscr varchar(100),
	ln_am decimal(18,2),
	rs_fndg_ind integer,
	bfy integer,
	fy_dc integer,
	per_dc character(2),
	frght_pc decimal(17,4),
	mod_fl character(1),
	obj_att_sg_tot integer,
	al_clsd_am decimal(18,2),
	al_clsd_dt date,
	ln_open_am decimal(18,2),
	rfed_ln_am decimal(18,2),
	outyr_adj_am decimal(18,2),
	oblg_adj_outyr_am decimal(18,2),
	rfed_doc_cd varchar(8),
	rfed_doc_dept_cd varchar(4),
	rfed_doc_id varchar(20),
	rfed_vend_ln_no integer,
	rfed_comm_ln_no integer,
	rfed_actg_ln_no integer,
	rf_typ integer,
	fn_doc_cd varchar(8),
	fn_doc_dept_cd varchar(4),
	fn_doc_id varchar(20),
	fund_cd varchar(4),
	sfund_cd varchar(4),
	dept_cd varchar(4),
	unit_cd varchar(8),
	sunit_cd varchar(4),
	appr_cd varchar(9),
	obj_cd varchar(4),
	sobj_cd varchar(4),
	rsrc_cd varchar(5),
	srsrc_cd varchar(5),
	bsa_cd varchar(4),
	sbsa_cd varchar(4),
	obsa_cd varchar(4),
	osbsa_cd varchar(4),
	dobj_cd varchar(5),
	drsrc_cd varchar(4),
	loc_cd varchar(4),
	sloc_cd varchar(4),
	actv_cd varchar(10),
	sactv_cd varchar(4),
	func_cd varchar(10),
	sfunc_cd varchar(4),
	rpt_cd varchar(15),
	srpt_cd varchar(4),
	task_cd varchar(4),
	stask_cd varchar(4),
	task_ord_cd varchar(6),
	mjr_prog_cd varchar(6),
	prog_cd varchar(10),
	phase_cd varchar(6),
	ppc_cd varchar(6),
	sp_inst_cd varchar(4),
	chk_dscr varchar(250),
	rl_fl_1 character(1),
	rl_fl_2 character(1),
	event_type_id smallint, 
	fund_class_id smallint,
	agency_history_id smallint,
	department_history_id int, 
	expenditure_object_history_id integer,
	budget_code_id integer,	
	uniq_id bigint default nextval('seq_stg_con_po_accounting_line_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
	DISTRIBUTED BY (uniq_id);	
	
CREATE TABLE stg_con_do1_header(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_nm varchar(60),
	doc_rec_dt_dc date,
	doc_bfy integer,
	doc_fy_dc integer,
	doc_per_dc char(2),
	doc_dscr varchar(60),
	doc_actu_am decimal(20,2),
	doc_clsd_am decimal(20,2),
	doc_clsd_dt date,
	open_am decimal(20,2),
	open_acrl_am decimal(20,2),
	amend_no varchar(4),
	pcard_rec_id varchar(20),
	pcard_expr_dt date,
	actg_prfl_id varchar(6),
	prcu_id varchar(20),
	prcu_typ_nm varchar(30),
	prcu_typ_id integer,
	cited_auth varchar(20),
	cnfrm_ord char(1),
	blkt_agr_fl char(1),
	prnt_job_cd varchar(50),
	last_prn_dt date,
	obj_att_sg_tot integer,
	obj_att_pg_tot integer,
	oblg_adj_outyr_am decimal(20,2),
	avail_oblg_am decimal(20,2),
	outyr_adj_am decimal(20,2),
	ma_prch_lmt_am decimal(20,2),
	part_rect_alw_fl char(1),
	agree_doc_cd varchar(8),
	agree_doc_dept_cd varchar(4),
	agree_doc_id varchar(20),
	agree_vend_ln_no integer,
	brd_awd_no varchar(15),
	brd_awd_dt date,
	trkg_no varchar(30),
	po_repl_doc_cd varchar(8),
	po_repl_dept_cd varchar(4),
	po_repl_id varchar(20),
	po_repl_by_doc_cd varchar(8),
	po_repl_by_dept_cd varchar(4),
	po_repl_by_id varchar(20),
	rfed_am decimal(20,2),
	rfed_lqd_am decimal(20,2),
	issr_id varchar(16),
	issr_ph_no varchar(30),
	issr_email_ad varchar(100),
	rqstr_id varchar(16),
	rqstr_nm varchar(61),
	rqstr_ph_no varchar(30),
	rqstr_email_ad varchar(100),
	rqstr_dept_cd varchar(4),
	team_id varchar(16),
	buyr_id varchar(16),
	buyr_nm varchar(61),
	buyr_ph_no varchar(30),
	buyr_ph_ext varchar(6),
	buyr_email_ad varchar(100),
	track_chgs char(1),
	chg_ord_no integer,
	mod_fl char(1),
	reas_mod_dc varchar,
	dscr_ext varchar,
	ship_loc_cd varchar(6),
	ship_meth_cd varchar(3),
	free_brd_cd varchar(3),
	dlvr_dt date,
	dlvr_typ integer,
	ship_info varchar,
	bill_loc_cd varchar(6),
	bill_info varchar,
	gnrc_po_rpt_1 varchar(10),
	gnrc_po_rpt_2 varchar(10),
	gnrc_po_rpt_3 varchar(10),
	fn_doc_cd varchar(8),
	fn_doc_dept_cd varchar(4),
	fn_doc_id varchar(20),
	doc_crea_usid varchar(20),
	doc_appl_crea_dt date,
	doc_appl_last_usid varchar(20),
	doc_appl_last_dt date,
	rl_fl_1 char(1),
	doc_func_cd  integer,	
	document_code_id smallint,
	agency_history_id smallint,
	document_function_code_id smallint, 
	record_date_id int,
	procurement_type_id smallint,
	source_created_date_id int,
	source_updated_date_id int,
	original_term_begin_date_id int,
	original_term_end_date_id int,
	master_agreement_id bigint,
	source_updated_calendar_year smallint,
	source_updated_calendar_year_id smallint,
	source_updated_fiscal_year_id smallint,
	source_updated_fiscal_year smallint,	
	uniq_id bigint default nextval('seq_stg_con_do1_header_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
	DISTRIBUTED BY (uniq_id);
	
CREATE TABLE stg_con_do1_vendor(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	vend_cust_cd varchar(20),
	lgl_nm varchar(60),
	ad_id varchar(20),
	ad_ln_1 varchar(75),
	ad_ln_2 varchar(75),
	city varchar(60),
	st varchar(2),
	zip varchar(10),
	ctry varchar(3),
	vend_pref_lvl integer,
	web_ad varchar(100),
	cntac_id varchar(20),
	prin_cntac varchar(60),
	voice_ph_no varchar(30),
	voice_ph_ext varchar(6),
	email_ad varchar(100),
	vend_reas varchar,
	mod_fl char(1),
	disc_1_pc decimal(17,4),
	disc_1_dy integer,
	disc_alw_1_fl char(1),
	disc_2_pc decimal(17,4),
	disc_2_dy integer,
	disc_alw_2_fl char(1),
	disc_3_pc decimal(17,4),
	disc_3_dy integer,
	disc_alw_3_fl char(1),
	disc_4_pc decimal(17,4),
	disc_4_dy integer,
	disc_alw_4_fl char(1),
	alias_nm varchar,
	vendor_history_id bigint,
	uniq_id bigint default nextval('seq_stg_con_do1_vendor_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
	DISTRIBUTED BY (uniq_id);	
	
CREATE TABLE stg_con_do1_commodity(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	doc_comm_ln_no integer,
	cl_dscr varchar(60),
	whse_cd varchar(8),
	comm_cd varchar(14),
	stk_itm_sfx varchar(3),
	supp_part_no varchar(32),
	ln_typ integer,
	qty decimal(27,5),
	unit_meas_cd varchar(4),
	unit_price decimal(28,6),
	disc_unit_price decimal(28,6),
	lst_unit_price decimal(28,6),
	cntrc_am decimal(20,2),
	svc_strt_dt date,
	svc_end_dt date,
	actg_prfl_id varchar(6),
	actg_tmpl_id varchar(6),
	tax_prfl_cd varchar(10),
	fa_fl char(1),
	lck_ord_fl char(1),
	alw_promo_price char(1),
	lck_ctlg_price integer,
	alw_promo_price_dup char(1),
	vend_pref_lvl integer,
	mrk_del_fl char(1),
	comm_cd_spfn varchar,
	dscr_ext varchar,
	nrs_fndg_tot decimal(20,2),
	itm_s_tot_am decimal(20,2),
	tax_tot_am decimal(20,2),
	itm_tot_am decimal(20,2),
	tot_actg_am decimal(20,2),
	comm_clsd_am decimal(20,2),
	open_am decimal(20,2),
	open_acrl_am decimal(20,2),
	clsd_qty decimal(27,5),
	open_qty decimal(27,5),
	clsd_cntrc_am decimal(20,2),
	open_cntrc_am decimal(20,2),
	mod_fl char(1),
	obj_att_sg_tot integer,
	rf_doc_cd varchar(8),
	rf_doc_dept_cd varchar(4),
	rf_doc_id varchar(20),
	rf_doc_comm_ln_no integer,
	rf_typ integer,
	rfed_lqd_am decimal(20,2),
	trkg_no varchar(30),
	agree_doc_cd varchar(8),
	agree_doc_dept_cd varchar(4),
	agree_doc_id varchar(20),
	agree_comm_ln_no integer,
	so_doc_cd varchar(8),
	so_doc_dept_cd varchar(4),
	so_doc_id varchar(20),
	so_commgp_ln_no integer,
	so_commln_ln_no integer,
	ur_doc_cd varchar(8),
	ur_doc_dept_cd varchar(4),
	ur_doc_id varchar(20),
	ur_commgp_ln_no integer,
	ur_comm_ln_no integer,
	fn_doc_cd varchar(8),
	fn_doc_dept_cd varchar(4),
	fn_doc_id varchar(20),
	ship_loc_cd varchar(6),
	ship_meth_cd varchar(3),
	free_brd_cd varchar(3),
	dlvr_dt date,
	dlvr_typ integer,
	ship_info varchar,
	bill_loc_cd varchar(6),
	bill_info varchar,
	det_inst varchar,
	pkg_inst varchar,
	haz_mat varchar,
	handl_spec_inst varchar,
	addl_hndl_info varchar,
	manfr_nm varchar(25),
	manfr_part_no varchar(25),
	prod_cat_no varchar(25),
	mdl_no varchar(25),
	drw_no varchar(25),
	piece_no varchar(25),
	ser_no varchar(25),
	spen_no varchar(25),
	sz varchar(25),
	color varchar(25),
	msds_fl char(1),
	wty_typ integer,
	invd_qty decimal(27,5),
	invd_cntrc_am decimal(20,2),
	invd_am decimal(20,2),
	invd_fnl_fl char(1),
	rcvd_qty decimal(27,5),
	rcvd_cntrc_am decimal(20,2),
	rcvd_fnl_fl char(1),
	pd_qty decimal(27,5),
	pd_cntrc_am decimal(20,2),
	rfed_am decimal(20,2),
	mtch_ind integer,
	pd_fnl_fl char(1),
	rtg_lwr_lmt_am_1 decimal(20,2),
	rtg_upr_lmt_am_1 decimal(20,2),
	rtg_am_1 decimal(20,2),
	rtg_lwr_lmt_pc_1 decimal(11,2),
	rtg_upr_lmt_pc_1 decimal(11,2),
	rtg_pc_1 decimal(11,2),
	rtg_lwr_lmt_am_2 decimal(20,2),
	rtg_upr_lmt_am_2 decimal(20,2),
	rtg_am_2 decimal(20,2),
	rtg_lwr_lmt_pc_2 decimal(11,2),
	rtg_upr_lmt_pc_2 decimal(11,2),
	rtg_pc_2 decimal(11,2),
	rtg_lwr_lmt_am_3 decimal(20,2),
	rtg_upr_lmt_am_3 decimal(20,2),
	rtg_am_3 decimal(20,2),
	rtg_lwr_lmt_pc_3 decimal(11,2),
	rtg_upr_lmt_pc_3 decimal(11,2),
	rtg_pc_3 decimal(11,2),
	rtg_lwr_lmt_am_4 decimal(20,2),
	rtg_upr_lmt_am_4 decimal(20,2),
	rtg_am_4 decimal(20,2),
	rtg_lwr_lmt_pc_4 decimal(11,2),
	rtg_upr_lmt_pc_4 decimal(11,2),
	rtg_pc_4 decimal(11,2),
	rtg_lwr_lmt_am_5 decimal(20,2),
	rtg_upr_lmt_am_5 decimal(20,2),
	rtg_am_5 decimal(20,2),
	rtg_lwr_lmt_pc_5 decimal(11,2),
	rtg_upr_lmt_pc_5 decimal(11,2),
	rtg_pc_5 decimal(11,2),
	tol_ovrg_qty decimal(27,5),
	tol_undg_qty decimal(27,5),
	tol_am_ovr_dol decimal(20,2),
	tol_am_undr_dol decimal(20,2),
	tol_am_undr_pc decimal(17,4),
	tol_am_ovr_pc decimal(17,4),
	disc_1_pc decimal(17,4),
	disc_1_dy integer,
	disc_alw_1_fl char(1),
	disc_2_pc decimal(17,4),
	disc_2_dy integer,
	disc_alw_2_fl char(1),
	disc_3_pc decimal(17,4),
	disc_3_dy integer,
	disc_alw_3_fl char(1),
	disc_4_pc decimal(17,4),
	disc_4_dy integer,
	disc_alw_4_fl char(1),
	commodity_type_id smallint,
	uniq_id bigint default nextval('seq_stg_con_do1_commodity_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
	DISTRIBUTED BY (uniq_id);	
	
CREATE TABLE stg_con_do1_accounting_line(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	doc_comm_ln_no integer,
	doc_actg_ln_no integer,
	evnt_typ_id varchar(4),
	actg_tmpl_id varchar(6),
	actg_ln_dscr varchar(100),
	ln_am decimal(20,2),
	rs_fndg_ind integer,
	bfy integer,
	fy_dc integer,
	per_dc char(2),
	frght_pc decimal(17,4),
	mod_fl char(1),
	obj_att_sg_tot integer,
	al_clsd_am decimal(20,2),
	al_clsd_dt date,
	ln_open_am decimal(20,2),
	rfed_ln_am decimal(20,2),
	outyr_adj_am decimal(20,2),
	oblg_adj_outyr_am decimal(20,2),
	rfed_doc_cd varchar(8),
	rfed_doc_dept_cd varchar(4),
	rfed_doc_id varchar(20),
	rfed_vend_ln_no integer,
	rfed_comm_ln_no integer,
	rfed_actg_ln_no integer,
	fn_doc_cd varchar(8),
	fn_doc_dept_cd varchar(4),
	fn_doc_id varchar(20),
	fund_cd varchar(4),
	sfund_cd varchar(4),
	dept_cd varchar(4),
	unit_cd varchar(8),
	sunit_cd varchar(4),
	appr_cd varchar(9),
	obj_cd varchar(4),
	sobj_cd varchar(4),
	rsrc_cd varchar(5),
	srsrc_cd varchar(5),
	bsa_cd varchar(4),
	sbsa_cd varchar(4),
	obsa_cd varchar(4),
	osbsa_cd varchar(4),
	dobj_cd varchar(5),
	drsrc_cd varchar(4),
	loc_cd varchar(4),
	sloc_cd varchar(4),
	actv_cd varchar(10),
	sactv_cd varchar(4),
	func_cd varchar(10),
	sfunc_cd varchar(4),
	rpt_cd varchar(15),
	srpt_cd varchar(4),
	task_cd varchar(4),
	stask_cd varchar(4),
	task_ord_cd varchar(6),
	prog_cd varchar(10),
	phase_cd varchar(6),
	ppc_cd varchar(6),
	sp_inst_cd varchar(4),
	chk_dscr varchar(250),
	rl_fl_1 char(1),
	rl_fl_2 char(1),
	event_type_id smallint, 
	fund_class_id smallint,
	agency_history_id smallint,
	department_history_id int, 
	expenditure_object_history_id integer,
	budget_code_id integer	,
	uniq_id bigint default nextval('seq_stg_con_do1_accounting_line_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
	DISTRIBUTED BY (uniq_id);	
	
CREATE TABLE archive_con_ct_header (LIKE stg_con_ct_header) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_ct_header ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_ct_header (LIKE archive_con_ct_header) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_ct_award_detail (LIKE stg_con_ct_award_detail) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_ct_award_detail ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_ct_award_detail (LIKE archive_con_ct_award_detail) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_ct_vendor (LIKE stg_con_ct_vendor) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_ct_vendor ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_ct_vendor (LIKE archive_con_ct_vendor) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_ct_commodity (LIKE stg_con_ct_commodity) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_ct_commodity ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_ct_commodity (LIKE archive_con_ct_commodity) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_ct_accounting_line (LIKE stg_con_ct_accounting_line) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_ct_accounting_line ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_ct_accounting_line (LIKE archive_con_ct_accounting_line) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_po_header (LIKE stg_con_po_header) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_po_header ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_po_header (LIKE archive_con_po_header) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_po_award_detail (LIKE stg_con_po_award_detail) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_po_award_detail ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_po_award_detail (LIKE archive_con_po_award_detail) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_po_vendor (LIKE stg_con_po_vendor) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_po_vendor ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_po_vendor (LIKE archive_con_po_vendor) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_po_commodity (LIKE stg_con_po_commodity) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_po_commodity ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_po_commodity (LIKE archive_con_po_commodity) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_po_accounting_line (LIKE stg_con_po_accounting_line) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_po_accounting_line ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_po_accounting_line (LIKE archive_con_po_accounting_line) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_do1_header (LIKE stg_con_do1_header) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_do1_header ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_do1_header (LIKE archive_con_do1_header) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_do1_vendor (LIKE stg_con_do1_vendor) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_do1_vendor ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_do1_vendor (LIKE archive_con_do1_vendor) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_do1_commodity (LIKE stg_con_do1_commodity) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_do1_commodity ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_do1_commodity (LIKE archive_con_do1_commodity) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_con_do1_accounting_line (LIKE stg_con_do1_accounting_line) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_con_do1_accounting_line ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_con_do1_accounting_line (LIKE archive_con_do1_accounting_line) DISTRIBUTED BY (uniq_id);

CREATE TABLE agreement_id_seq(uniq_id bigint, agreement_id bigint default nextval('public.seq_agreement_agreement_id'))
DISTRIBUTED BY (uniq_id);

------------------------------------------------------------------------------------------------------------------------------------
/* FMS data feed */

CREATE EXTERNAL TABLE ext_stg_fms_data_feed(
	record_type char(1),
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no varchar,
	col6 varchar(100),
	col7 varchar(100),
	col8 varchar(100),
	col9 varchar(250),
	col10 varchar(100),
	col11 varchar(100),
	col12 varchar(100),
	col13 varchar(100),
	col14 varchar(100),
	col15 varchar(100),
	col16 varchar(100),
	col17 varchar(100),
	col18 varchar(100),
	col19 varchar(100),
	col20 varchar(100),
	col21 varchar(100),
	col22 varchar(100),
	col23 varchar(100),
	col24 varchar(100),
	col25 varchar(100),
	col26 varchar(100),
	col27 varchar(100),
	col28 varchar(100),
	col29 varchar(100),
	col30 varchar(100),
	col31 varchar(100),
	col32 varchar(100),
	col33 varchar(100),
	col34 varchar(100),
	col35 varchar(100),
	col36 varchar(100),
	col37 varchar(100),
	col38 varchar(100),
	col39 varchar(100),
	col40 varchar(100),
	col41 varchar(100),
	col42 varchar(100),
	col43 varchar(100),
	col44 varchar(100),
	col45 varchar(100),
	col46 varchar(100),
	col47 varchar(100),
	col48 varchar(100),
	col49 varchar(100))
 LOCATION (
  	    'gpfdist://mdw1:8081/datafiles/FMS_feed.txt')
  	    FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
 ENCODING 'UTF8';	
	
CREATE TABLE stg_fms_header(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_rec_dt_dc date,
	doc_bfy integer,
	doc_fy_dc integer,
	doc_per_dc char(2),
	chk_eft_am decimal(24,2),
	chk_eft_iss_dt date,
	chk_eft_rec_dt date,
	chk_eft_sta integer,
	can_typ_cd integer,
	can_reas_cd_dc integer,
	ln_am decimal(24,2),
	disc_am decimal(24,2),
	intr_am decimal(24,2),
	bkup_whld_am decimal(24,2),
	inct_am decimal(24,2),
	rtg_am decimal(24,2),
	document_code_id smallint,
	agency_history_id smallint,
	record_date_id int,
	check_eft_issued_date_id int,
	check_eft_record_date_id int, 	
	check_eft_issued_nyc_year_id smallint,
	uniq_id bigint default nextval('seq_stg_fms_header_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar		)
DISTRIBUTED BY (uniq_id)	;	
	
CREATE TABLE stg_fms_vendor(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	vend_cust_cd varchar(25),
	lgl_nm varchar(60),
	alias_nm varchar(60),
	ad_id varchar(25),
	org_cls varchar(25),
	misc_acct_fl integer,
	ad_ln_1 varchar(75),
	ad_ln_2 varchar(75),
	ctry varchar(25),
	st varchar(25),
	zip varchar(25),
	city varchar(60),
	bustype_mnrt varchar(4),
	bustype_mnrt_status smallint,
	minority_type_id smallint,
	bustype_wmno varchar(4),
	bustype_wmno_status smallint,
	bustype_locb varchar(4),
	bustype_locb_status smallint,
	bustype_eent varchar(4),
	bustype_eent_status smallint,
	bustype_exmp varchar(4),
	bustype_exmp_status smallint,
	vendor_history_id integer,
	uniq_id bigint default nextval('seq_stg_fms_vendor_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	)
DISTRIBUTED BY (uniq_id)	;	
	
CREATE TABLE stg_fms_accounting_line(
	doc_cd varchar(8),
	doc_dept_cd varchar(4),
	doc_id varchar(20),
	doc_vers_no integer,
	doc_vend_ln_no integer,
	doc_actg_ln_no integer,
	dept_cd varchar(4),
	bfy integer,
	fy_dc integer,
	per_dc char(2),
	rfed_doc_cd varchar(25),
	rfed_doc_dept_cd varchar(25),
	rfed_doc_id varchar(25),
	rfed_doc_vers_no integer,
	rfed_vend_ln_no integer,
	rfed_comm_ln_no integer,
	rfed_actg_ln_no integer,
	rqporf_doc_cd varchar(25),
	rqporf_doc_dept_cd varchar(25),
	rqporf_doc_id varchar(25),
	rqporf_vend_ln_no varchar(25),
	rqporf_comm_ln_no varchar(25),
	rqporf_actg_ln_no varchar(25),
	disc_ln_am decimal(24,2),
	intr_ln_am decimal(24,2),
	bkup_whld_ln_am decimal(24,2),
	inct_ln_am decimal(24,2),
	rtg_ln_am decimal(24,2),
	chk_amt decimal(24,2),
	fcls_cd varchar(4),
	fund_cd varchar(4),
	sfund_cd varchar(4),
	unit_cd varchar(8),
	sunit_cd varchar(4),
	appr_cd varchar(9),
	obj_cd varchar(4),
	sobj_cd varchar(4),
	rsrc_cd varchar(5),
	srsrc_cd varchar(5),
	bsa_cd varchar(4),
	dobj_cd varchar(5),
	drsrc_cd varchar(5),
	loc_cd varchar(4),
	sloc_cd varchar(4),
	actv_cd varchar(10),
	func_cd varchar(10),
	rpt_cd varchar(15),
	fund_class_id smallint,
	agency_history_id smallint,
	department_history_id int, 
	expenditure_object_history_id integer,
	budget_code_id integer,
	fund_id smallint, 
	location_history_id int,
	agreement_id bigint,
	masked_agency_history_id smallint,
	masked_department_history_id int,
	file_type char(1) default 'F',
	uniq_id bigint default nextval('seq_stg_fms_accounting_line_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar		
	) DISTRIBUTED BY (uniq_id)	;
	
CREATE TABLE archive_fms_header (LIKE stg_fms_header) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_fms_header ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_fms_header (LIKE archive_fms_header) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_fms_vendor (LIKE stg_fms_vendor) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_fms_vendor ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_fms_vendor (LIKE archive_fms_vendor) DISTRIBUTED BY (uniq_id);

CREATE TABLE archive_fms_accounting_line (LIKE stg_fms_accounting_line) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_fms_accounting_line ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_fms_accounting_line (LIKE archive_fms_accounting_line) DISTRIBUTED BY (uniq_id);	

CREATE TABLE seq_expenditure_expenditure_id(uniq_id bigint,disbursement_id integer default nextval('public.seq_expenditure_expenditure_id'))
DISTRIBUTED BY (uniq_id);

CREATE TABLE seq_disbursement_line_item_id(uniq_id bigint,disbursement_line_item_id bigint default nextval('public.seq_disbursement_line_item_id'))
DISTRIBUTED BY (uniq_id);



-----------------------------------------------------------------------------------------------------------------------------

/* verification and execution status tables */

CREATE TABLE etl.etl_script_execution_status
(
  load_file_id bigint,
  job_id bigint,
  script_name character varying,
  completed_flag integer,
  start_time timestamp without time zone,
  end_time timestamp without time zone,
  errno character varying,
  errmsg character varying
)
DISTRIBUTED BY (load_file_id);

CREATE TABLE etl.etl_data_load_verification
(
  load_file_id bigint,
  job_id bigint,
  data_source_code varchar(2),
  record_identifier character(1),
  document_type character varying,
  num_transactions bigint,
  description character varying
)
DISTRIBUTED BY (load_file_id);

CREATE TABLE  job_verification
(record_count int,
table_name varchar(60),
job_id int,
recorded_date timestamp
)
DISTRIBUTED BY (job_id);

---------------------------------------------------------------------------------------------------------------------------
/* Refreshing shards status */

CREATE TABLE etl.refresh_shards_status
(
  shard_name character(10),
  latest_flag smallint,
  sql_flag smallint,
  sql_start_date timestamp without time zone,
  sql_end_date timestamp without time zone,
  fix_flag smallint,
  fix_start_date timestamp without time zone,
  fix_end_date timestamp without time zone,
  rsync_flag smallint,
  rsync_start_date timestamp without time zone,
  rsync_end_date timestamp without time zone,
  refresh_start_date timestamp without time zone,
  refresh_end_date timestamp without time zone
)
DISTRIBUTED BY (shard_name);


--------------------------------------------------------------------------------------------------------------------------------
/* Reference tables from SQL server */

CREATE TABLE stg_agreement_type (
  agreement_type_code varchar(2),
  name varchar(60));
  
  
CREATE TABLE stg_award_category (
  award_category_code varchar(10) ,
  award_method_name varchar(50) 
);

CREATE TABLE stg_award_method (
  award_method_code varchar(3),
  award_method_name varchar(60)); 


-----------------------------------------------------------------------------------------------------------------------------------

 ----------------------------------------------------------------------------------------------------------------------------------------
 
 /* aggregate tables  */
 
 CREATE TABLE etl.aggregate_tables
(
  widget_name character varying(150),
  aggregate_table_name character varying(150),
  create_table text,
  query1 text,
  query2 text,
  execution_order smallint
)
DISTRIBUTED BY (aggregate_table_name);

-------------------------------------------------------------------------------------------------------------------------------------------
-- Tables to capture malformed records
CREATE TABLE malformed_coa_agency_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_coa_department_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_coa_expenditure_object_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_coa_location_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_coa_object_class_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_coa_budget_code_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_fmsv_data_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_mag_data_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_con_data_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_fms_data_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_pms_data_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_funding_class(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);

CREATE TABLE malformed_pms_summary_data_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);


CREATE TABLE malformed_oaisis_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);



--------------------------------------------------------------------------------------------------------------------------------------------------

CREATE EXTERNAL TABLE ext_stg_oaisis_feed(
	con_trans_code varchar,
	con_trans_ad_code  varchar,
	con_no  varchar,
	con_par_trans_code varchar,
	con_par_ad_code	varchar,
	con_par_reg_num	varchar,
	con_cur_encumbrance varchar,
	con_original_max varchar,
	con_rev_max varchar,
	vc_legal_name varchar,
	con_vc_code varchar,
	con_purpose varchar,
	submitting_agency_desc	 varchar,
	submitting_agency_code	 varchar,
	awarding_agency_desc	 varchar,
	awarding_agency_code	 varchar,
	cont_desc varchar,
	cont_code  varchar,
	am_desc varchar,
	am_code varchar,
	con_term_from varchar,
	con_term_to varchar,
	con_rev_start_dt varchar,
	con_rev_end_dt varchar,
	con_cif_received_date varchar,
	con_pin	 varchar,
	con_internal_pin varchar,
	con_batch_suffix varchar,
	con_version varchar,
	original_or_modified varchar,
	award_category_code character varying)
 LOCATION (
  	    'gpfdist://mdw1:8081/datafiles/OAISIS_feed.txt')
  	    FORMAT 'text' (delimiter '|' escape '~' fill missing fields)
 ENCODING 'UTF8';	

 CREATE TABLE stg_pending_contracts( 	
 	con_trans_code varchar(4),
 	con_trans_ad_code  varchar(4),
 	con_no  varchar(11),
 	con_par_trans_code varchar(4),
 	con_par_ad_code	varchar(4),
 	con_par_reg_num	varchar(11),
 	con_cur_encumbrance numeric(15,2),
 	con_original_max numeric(15,2),
 	con_rev_max numeric(15,2),
 	vc_legal_name varchar(80),
 	con_vc_code varchar(20),
 	con_purpose varchar(78),
 	submitting_agency_desc	 varchar(50),
 	submitting_agency_code	 varchar(4),
 	awarding_agency_desc	 varchar(50),
 	awarding_agency_code	 varchar(4),
 	cont_desc varchar(40),
 	cont_code  varchar(2),
 	am_desc varchar(50),
 	am_code varchar(3),
 	con_term_from date,
 	con_term_to date,
 	con_rev_start_dt date,
 	con_rev_end_dt date,
 	con_cif_received_date date,
 	con_pin	 varchar(30),
 	con_internal_pin varchar(15),
 	con_batch_suffix varchar(10),
	con_version varchar(5),
	submitting_agency_id  smallint,
	submitting_agency_name varchar,
	submitting_agency_short_name varchar,
	awarding_agency_id  smallint,
	awarding_agency_name varchar,
	awarding_agency_short_name varchar,
	start_date_id int,
	end_date_id int,	
	revised_start_date_id int,
	revised_end_date_id int,	
	cif_received_date_id int,
	cif_fiscal_year smallint, 
	cif_fiscal_year_id smallint,
 	document_code_id smallint,
 	document_agency_id  smallint,
  	parent_document_code_id smallint,
  	parent_document_agency_id  smallint, 	
	document_agency_code varchar, 
	document_agency_name varchar, 
	document_agency_short_name varchar ,
	funding_agency_id  smallint,
	funding_agency_code varchar, 
	funding_agency_name varchar, 
	funding_agency_short_name varchar ,
	original_agreement_id bigint,
	dollar_difference numeric(16,2),
  	percent_difference numeric(17,4),
  	fms_contract_number varchar,
  	original_or_modified varchar,
  	award_category_code varchar(3),
  	award_category_id smallint,
 	uniq_id bigint default nextval('seq_stg_pending_contracts_uniq_id'),
	invalid_flag char(1),
	invalid_reason varchar	
 ) DISTRIBUTED BY (uniq_id);
 
 CREATE TABLE archive_pending_contracts (LIKE stg_pending_contracts) DISTRIBUTED BY (uniq_id);
 ALTER TABLE archive_pending_contracts ADD COLUMN load_file_id bigint;
 
 CREATE TABLE invalid_pending_contracts (LIKE archive_pending_contracts) DISTRIBUTED BY (uniq_id);	
 
 
 -- temporary tables for Vendor Processing
 
 CREATE TABLE tmp_stg_vendor(
 	vend_cust_cd varchar(20),	
 	lgl_nm varchar(60), 
 	alias_nm varchar(60), 
 	ad_id varchar(25), 					     
 	org_cls varchar(25), 
 	misc_acct_fl integer, 
 	ad_ln_1 varchar(75),
 	ad_ln_2 varchar(75), 
 	ctry varchar(25), 					     
 	st varchar(25), 
 	zip varchar(25), 
 	city varchar(60),	
 	vendor_history_id integer, 
 	uniq_id bigint, 
 	address_type_code varchar(2) 
 	)	DISTRIBUTED BY (uniq_id);
 	
 	
 		
	
CREATE TABLE tmp_all_vendors(
	uniq_id bigint,
	vendor_customer_code varchar, 
	vendor_history_id integer, 
	vendor_id integer, 
	misc_acct_fl integer,					
	is_new_vendor char(1), 
	is_name_changed char(1), 
	is_vendor_address_changed char(1), 
	is_address_new char(1), 
	is_bus_type_changed char(1), 					
	lgl_nm varchar(60), 
	alias_nm varchar(60), 
	ad_ln_1 varchar(75),
	ad_ln_2 varchar(75), 
	ctry varchar(25),
	st varchar(25), 
	zip varchar(25), 					
	city varchar(60), 
	address_type_code varchar(2)
	)	DISTRIBUTED BY (uniq_id);
	
CREATE TABLE tmp_all_vendors_uniq_id(
	uniq_id bigint
	)	DISTRIBUTED BY (uniq_id);

CREATE TABLE tmp_vendor_update (
     	vendor_id integer,
     	legal_name varchar(60), 
		alias_name varchar(60)
		)	DISTRIBUTED BY (vendor_id);	
		
	-- for contracts by indutry and size
	
 CREATE TABLE stg_award_category_industry (
  award_category_code varchar(10) ,
  industry_type_id smallint 
);



-- Create Indexes
 -- payroll indexes on 12/08/2012
CREATE INDEX idx_load_id_etl_data_load_file ON etl.etl_data_load_file(load_id);
