set search_path=public;

/*
DROP SEQUENCE IF EXISTS seq_subvendor_vendor_id CASCADE;
DROP SEQUENCE IF EXISTS seq_subvendor_bus_type_vendor_bus_type_id CASCADE;
DROP SEQUENCE IF EXISTS seq_subvendor_history_vendor_history_id CASCADE;
DROP SEQUENCE IF EXISTS seq_sub_agreement_agreement_id CASCADE;

CREATE SEQUENCE seq_subvendor_vendor_id;
CREATE SEQUENCE seq_subvendor_bus_type_vendor_bus_type_id;
CREATE SEQUENCE seq_subvendor_history_vendor_history_id;
CREATE SEQUENCE seq_sub_agreement_agreement_id;
*/

-- only one time

DELETE FROM ref_industry_type WHERE industry_type_id in (6,7);
INSERT INTO ref_industry_type(industry_type_id, industry_type_name,created_date) VALUES(6,'Human Services',now()::timestamp),(7,'Arch and Engineerng',now()::timestamp);
UPDATE ref_industry_type SET created_date = now()::timestamp WHERE industry_type_id in (6,7);

DROP TABLE IF EXISTS sub_industry_mappings ;
CREATE TABLE sub_industry_mappings(
industry_type_id smallint, 
sub_industry_type_id smallint
)
DISTRIBUTED BY (industry_type_id);

INSERT INTO sub_industry_mappings(industry_type_id, sub_industry_type_id) values(1,1),(2,4),(3,2),(4,3),(5,7),(6,5),(7,6);



DROP  TABLE  IF EXISTS subcontract_vendor_business_type;	
CREATE TABLE subcontract_vendor_business_type (
	vendor_customer_code character varying(20),
	business_type_id smallint,
	status smallint,
    minority_type_id smallint,
    certification_start_date date,
    certification_end_date date, 
    initiation_date date,
    certification_no character varying(30),
    disp_certification_start_date date
)
DISTRIBUTED BY (vendor_customer_code);

DROP  TABLE  IF EXISTS subcontract_business_type;	
CREATE TABLE subcontract_business_type (
    contract_number varchar,
    subcontract_id character varying(20),
	prime_vendor_customer_code character varying(20),
	vendor_customer_code character varying(20),
	business_type_id smallint,
	status smallint,
    minority_type_id smallint,
    certification_start_date date,
    certification_end_date date, 
    initiation_date date,
    certification_no character varying(30),
    disp_certification_start_date date,
    load_id integer,
    created_date timestamp without time zone
)
DISTRIBUTED BY (contract_number);


DROP  TABLE  IF EXISTS subvendor;	
CREATE TABLE subvendor (
    vendor_id integer PRIMARY KEY DEFAULT nextval('seq_vendor_vendor_id'::regclass) NOT NULL,
    vendor_customer_code character varying(20),
    legal_name character varying(60),
    display_flag CHAR(1) DEFAULT 'Y',
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (vendor_id);


DROP  TABLE  IF EXISTS subvendor_history;	
CREATE TABLE subvendor_history (
    vendor_history_id integer PRIMARY KEY DEFAULT nextval('seq_vendor_history_vendor_history_id'::regclass) NOT NULL,
    vendor_id integer,   
    legal_name character varying(60),
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (vendor_history_id);


INSERT INTO subvendor(vendor_id,vendor_customer_code,legal_name,display_flag) values(nextval('seq_vendor_vendor_id'),'N/A','N/A (PRIVACY/SECURITY)','N');

INSERT INTO vendor_history(vendor_history_id,vendor_id,legal_name) 
SELECT nextval('seq_vendor_history_vendor_history_id'),vendor_id,legal_name
FROM vendor WHERE vendor_customer_code='N/A'
AND legal_name='N/A (PRIVACY/SECURITY)';


DROP  TABLE  IF EXISTS subvendor_business_type;
CREATE TABLE subvendor_business_type (
    vendor_business_type_id bigint PRIMARY KEY DEFAULT nextval('seq_vendor_bus_type_vendor_bus_type_id') NOT NULL,
    vendor_history_id integer,
    business_type_id smallint,
    status smallint,
    minority_type_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (vendor_business_type_id);


DROP  TABLE  IF EXISTS subvendor_min_bus_type ;
CREATE TABLE subvendor_min_bus_type
( vendor_id integer,
  vendor_history_id integer,
  business_type_id smallint,
  minority_type_id smallint,
  business_type_code character varying(4),
  business_type_name character varying(50),
  minority_type_name character varying(50)
)
DISTRIBUTED BY (vendor_history_id);


DROP  TABLE  IF EXISTS subcontract_status;
CREATE TABLE subcontract_status (
    contract_number varchar,
	vendor_customer_code character varying(20), 
	scntrc_status smallint, 
	agreement_type_id smallint, 
	total_scntrc_max_am numeric(16,2),
	total_scntrc_pymt_am numeric(16,2),
    created_load_id integer,
    created_date timestamp without time zone,
    updated_load_id integer,
    updated_date timestamp without time zone
)
DISTRIBUTED BY (contract_number);


DROP  TABLE  IF EXISTS subcontract_details;
CREATE  TABLE subcontract_details
(
  agreement_id bigint NOT NULL DEFAULT nextval('seq_agreement_agreement_id'::regclass),
  contract_number varchar,
  sub_contract_id character varying(20),
  agency_history_id smallint,
  document_id character varying(20),
  document_code_id smallint,
  document_version integer,
  vendor_history_id integer,
  prime_vendor_id integer,
  agreement_type_id smallint,  
  aprv_sta smallint,
  aprv_reas_id character varying(3),
  aprv_reas_nm character varying(30),
  description character varying(256),
  is_mwbe_cert smallint,
  industry_type_id smallint,
  effective_begin_date_id integer,
  effective_end_date_id integer,
  registered_date_id integer,
  source_updated_date_id integer,
  maximum_contract_amount_original numeric(16,2),
  maximum_contract_amount  numeric(16,2),
  original_contract_amount_original numeric(16,2),
  original_contract_amount numeric(16,2),
  rfed_amount_original numeric(16,2), 
  rfed_amount numeric(16,2),
  total_scntrc_pymt numeric(16,2),
  is_scntrc_pymt_complete smallint,
  scntrc_mode smallint,
  tracking_number character varying(30),
  award_method_id smallint,
  award_category_id smallint,
  brd_awd_no character varying,
  number_responses integer,
  number_solicitation integer,
  doc_ref character varying(75),
  registered_fiscal_year smallint,
  registered_fiscal_year_id smallint,
  registered_calendar_year smallint,
  registered_calendar_year_id smallint,
  effective_end_fiscal_year smallint,
  effective_end_fiscal_year_id smallint,
  effective_end_calendar_year smallint,
  effective_end_calendar_year_id smallint,
  effective_begin_fiscal_year smallint,
  effective_begin_fiscal_year_id smallint,
  effective_begin_calendar_year smallint,
  effective_begin_calendar_year_id smallint,
  source_updated_fiscal_year smallint,
  source_updated_fiscal_year_id smallint,
  source_updated_calendar_year smallint,
  source_updated_calendar_year_id smallint,
  original_agreement_id bigint,
  original_version_flag character(1),
  master_agreement_id bigint,
  latest_flag character(1),
  privacy_flag character(1),
  created_load_id integer,
  updated_load_id integer,
  created_date timestamp without time zone,
  updated_date timestamp without time zone
)
DISTRIBUTED BY (agreement_id);


DROP  TABLE  IF EXISTS subcontract_spending;
CREATE TABLE subcontract_spending (
    disbursement_line_item_id bigint  PRIMARY KEY DEFAULT nextval('seq_disbursement_line_item_id'::regclass) NOT NULL,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying(20),
    document_version integer,
    payment_id character varying(10),
    disbursement_number character varying(40),
    check_eft_amount_original numeric(16,2),
    check_eft_amount numeric(16,2),
    check_eft_issued_date_id int,
    check_eft_issued_nyc_year_id smallint,
    payment_description character varying(256),
    payment_proof character varying(256),
    is_final_payment varchar(3),
    doc_ref character varying(75),
    contract_number varchar,
  	sub_contract_id character varying(20),
    agreement_id bigint,
    vendor_history_id integer,
    prime_vendor_id integer,     
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (disbursement_line_item_id);


DROP  TABLE  IF EXISTS sub_agreement_snapshot;
CREATE TABLE sub_agreement_snapshot
 (
   original_agreement_id bigint,
   document_version smallint,
   document_code_id smallint,
   agency_history_id smallint,
   agency_id smallint,
   agency_code character varying(20),
   agency_name character varying(100),
   agreement_id bigint,
   starting_year smallint,
   starting_year_id smallint,
   ending_year smallint,
   ending_year_id smallint,
   registered_year smallint,
   registered_year_id smallint,
   contract_number character varying,
   sub_contract_id character varying(20),
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying(20),
   vendor_name character varying,
   prime_vendor_id integer,
   dollar_difference numeric(16,2),
   percent_difference numeric(17,4),
   agreement_type_id smallint,
   agreement_type_code character varying(2),
   agreement_type_name character varying,
   award_category_id smallint,
   award_category_code character varying(10),
   award_category_name character varying,
   award_method_id smallint,
   award_method_code character varying(10) ,
   award_method_name character varying,
   expenditure_object_codes character varying,
   expenditure_object_names character varying,
   industry_type_id smallint,
   industry_type_name character varying(50),
   award_size_id smallint,
   effective_begin_date date,
   effective_begin_date_id integer,
   effective_begin_year smallint,
   effective_begin_year_id smallint,
   effective_end_date date,
   effective_end_date_id integer,
   effective_end_year smallint,
   effective_end_year_id smallint,
   registered_date date,
   registered_date_id integer,
   brd_awd_no character varying,
   tracking_number character varying,
   rfed_amount numeric(16,2),
   minority_type_id smallint,
   minority_type_name character varying(50),
   original_version_flag character(1),
   master_agreement_id bigint,  
   master_contract_number character varying,
   latest_flag character(1),
   load_id integer,
   last_modified_date timestamp without time zone,
   job_id bigint
 ) DISTRIBUTED BY (original_agreement_id);
 
 
 DROP  TABLE  IF EXISTS sub_agreement_snapshot_cy;
 CREATE TABLE sub_agreement_snapshot_cy (LIKE sub_agreement_snapshot) DISTRIBUTED BY (original_agreement_id);
 
 
 DROP  TABLE  IF EXISTS sub_agreement_snapshot_expanded;
 CREATE TABLE sub_agreement_snapshot_expanded(
	original_agreement_id bigint,
	agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	sub_contract_id character varying(20),
	vendor_id int,
	prime_vendor_id int,
	agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	original_contract_amount numeric(16,2) ,
	maximum_contract_amount numeric(16,2),
	rfed_amount numeric(16,2),
	starting_year smallint,	
	ending_year smallint,
	dollar_difference numeric(16,2), 
	percent_difference numeric(17,4),
	award_method_id smallint,
	document_code_id smallint,	
	minority_type_id smallint,
 	minority_type_name character varying(50),
	status_flag char(1)
	)
DISTRIBUTED BY (original_agreement_id);	


DROP  TABLE  IF EXISTS sub_agreement_snapshot_expanded_cy;
CREATE TABLE sub_agreement_snapshot_expanded_cy(
	original_agreement_id bigint,
	agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	sub_contract_id character varying(20),
	vendor_id int,
	prime_vendor_id int,
	agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	original_contract_amount numeric(16,2) ,
	maximum_contract_amount numeric(16,2),
	rfed_amount numeric(16,2),
	starting_year smallint,	
	ending_year smallint,
	dollar_difference numeric(16,2), 
	percent_difference numeric(17,4),
	award_method_id smallint,
	document_code_id smallint,	
	minority_type_id smallint,
 	minority_type_name character varying(50),
	status_flag char(1)
	)
DISTRIBUTED BY (original_agreement_id);	


DROP  TABLE  IF EXISTS sub_agreement_snapshot_deleted;
CREATE TABLE sub_agreement_snapshot_deleted (
  agreement_id bigint NOT NULL,
  original_agreement_id bigint NOT NULL,
  starting_year smallint,
  load_id integer,
  deleted_date timestamp without time zone,
  job_id bigint
) DISTRIBUTED BY (agreement_id);


DROP  TABLE  IF EXISTS sub_agreement_snapshot_cy_deleted;
CREATE TABLE sub_agreement_snapshot_cy_deleted (
  agreement_id bigint NOT NULL,
  original_agreement_id bigint NOT NULL,
  starting_year smallint,
  load_id integer,
  deleted_date timestamp without time zone,
  job_id bigint
) DISTRIBUTED BY (agreement_id);


DROP  TABLE  IF EXISTS subcontract_spending_details;
CREATE TABLE subcontract_spending_details(
	disbursement_line_item_id bigint,
	disbursement_number character varying(40),
	payment_id character varying(10),
	check_eft_issued_date_id int,
	check_eft_issued_nyc_year_id smallint,
	fiscal_year smallint,
	check_eft_issued_cal_month_id int,
	agreement_id bigint,
	check_amount numeric(16,2),
	agency_id smallint,
	agency_history_id smallint,
	agency_code varchar(20),
	vendor_id integer,
	prime_vendor_id integer,
	maximum_contract_amount numeric(16,2),
	maximum_contract_amount_cy numeric(16,2),	
	document_id varchar(20),
	vendor_name varchar,
	vendor_customer_code varchar(20), 
	check_eft_issued_date date,
	agency_name varchar(100),	
	agency_short_name character varying(15),  	
	expenditure_object_name varchar(40),
	expenditure_object_code varchar(4),
	contract_number varchar,
	sub_contract_id character varying(20),
	contract_vendor_id integer,
  	contract_vendor_id_cy integer,
	contract_prime_vendor_id integer,
  	contract_prime_vendor_id_cy integer,
  	contract_agency_id smallint,
  	contract_agency_id_cy smallint,
  	purpose varchar,
	purpose_cy varchar,
	reporting_code varchar(15),
	spending_category_id smallint,
	spending_category_name varchar,
	calendar_fiscal_year_id smallint,
	calendar_fiscal_year smallint,
	reference_document_number character varying,
	reference_document_code varchar(8),
	contract_document_code varchar(8),
	minority_type_id smallint,
 	minority_type_name character varying(50),
 	industry_type_id smallint,
   	industry_type_name character varying(50),
   	agreement_type_code character varying(2),
   	award_method_code character varying(10),
   	contract_industry_type_id smallint,
	contract_industry_type_id_cy smallint,
	contract_minority_type_id smallint,
	contract_minority_type_id_cy smallint,	
	master_agreement_id bigint,  
    master_contract_number character varying,
	file_type char(1),
	load_id integer,
	last_modified_date timestamp without time zone,
	job_id bigint
)
DISTRIBUTED BY (disbursement_line_item_id);

DROP TABLE IF EXISTS subcontract_spending_deleted;
CREATE TABLE subcontract_spending_deleted (
  disbursement_line_item_id bigint NOT NULL,
  agency_id smallint,
  load_id integer,
  deleted_date timestamp without time zone,
  job_id bigint
) DISTRIBUTED BY (disbursement_line_item_id);



DROP TABLE IF EXISTS all_agreement_transactions;
CREATE TABLE all_agreement_transactions
 (
   original_agreement_id bigint,
   document_version smallint,
   document_code_id smallint,
   agency_history_id smallint,
   agency_id smallint,
   agency_code character varying(20),
   agency_name character varying(100),
   agreement_id bigint,
   starting_year smallint,
   starting_year_id smallint,
   ending_year smallint,
   ending_year_id smallint,
   registered_year smallint,
   registered_year_id smallint,
   contract_number character varying,
   sub_contract_id character varying(20),
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying(20),
   vendor_name character varying,
   prime_vendor_id integer,
   prime_vendor_name character varying,
   dollar_difference numeric(16,2),
   percent_difference numeric(17,4),
   master_agreement_id bigint,
   master_contract_number character varying,
   agreement_type_id smallint,
   agreement_type_code character varying(2),
   agreement_type_name character varying,
   award_category_id smallint,
   award_category_code character varying(10),
   award_category_name character varying,
   award_method_id smallint,
   award_method_code character varying(10) ,
   award_method_name character varying,
   expenditure_object_codes character varying,
   expenditure_object_names character varying,
   industry_type_id smallint,
   industry_type_name character varying(50),
   award_size_id smallint,
   effective_begin_date date,
   effective_begin_date_id integer,
   effective_begin_year smallint,
   effective_begin_year_id smallint,
   effective_end_date date,
   effective_end_date_id integer,
   effective_end_year smallint,
   effective_end_year_id smallint,
   registered_date date,
   registered_date_id integer,
   brd_awd_no character varying,
   tracking_number character varying,
   rfed_amount numeric(16,2),
    minority_type_id smallint,
 	minority_type_name character varying(50),
   master_agreement_yn character(1),  
   has_children character(1),
   original_version_flag character(1),
   latest_flag character(1),
   load_id integer,
   last_modified_date timestamp without time zone,
   last_modified_year_id smallint,
   is_prime_or_sub character(1),
   is_minority_vendor character(1), 
   vendor_type character(2),
   contract_original_agreement_id bigint,
   job_id bigint
 ) DISTRIBUTED BY (original_agreement_id);
 
 
 
 DROP TABLE IF EXISTS all_agreement_transactions_cy;
 CREATE TABLE all_agreement_transactions_cy (LIKE all_agreement_transactions) DISTRIBUTED BY (original_agreement_id);
 
 
 
 DROP TABLE IF EXISTS all_disbursement_transactions;
 CREATE TABLE all_disbursement_transactions(
	disbursement_line_item_id bigint,
	disbursement_id integer,
	line_number integer,
	disbursement_number character varying(40),
	payment_id character varying(10),
	check_eft_issued_date_id int,
	check_eft_issued_nyc_year_id smallint,
	fiscal_year smallint,
	check_eft_issued_cal_month_id int,
	agreement_id bigint,
	master_agreement_id bigint,
	fund_class_id smallint,
	check_amount numeric(16,2),
	agency_id smallint,
	agency_history_id smallint,
	agency_code varchar(20),
	expenditure_object_id integer,
	vendor_id integer,
	prime_vendor_id integer,
	prime_vendor_name character varying,
	department_id integer,
	maximum_contract_amount numeric(16,2),
	maximum_contract_amount_cy numeric(16,2),
	maximum_spending_limit numeric(16,2),
	maximum_spending_limit_cy numeric(16,2),
	document_id varchar(20),
	vendor_name varchar,
	vendor_customer_code varchar(20), 
	check_eft_issued_date date,
	agency_name varchar(100),	
	agency_short_name character varying(15),  	
	location_name varchar,
	location_code varchar(4),
	department_name varchar(100),
	department_short_name character varying(15),
	department_code varchar(20),
	expenditure_object_name varchar(40),
	expenditure_object_code varchar(4),
	budget_code_id integer,
	budget_code varchar(10),
	budget_name varchar(60),
	contract_number varchar,
	sub_contract_id character varying(20),
	master_contract_number character varying,
	master_child_contract_number character varying,
  	contract_vendor_id integer,
  	contract_vendor_id_cy integer,
	contract_prime_vendor_id integer,
  	contract_prime_vendor_id_cy integer,
  	master_contract_vendor_id integer,
  	master_contract_vendor_id_cy integer,
  	contract_agency_id smallint,
  	contract_agency_id_cy smallint,
  	master_contract_agency_id smallint,
  	master_contract_agency_id_cy smallint,
  	master_purpose character varying,
  	master_purpose_cy character varying,
	purpose varchar,
	purpose_cy varchar,
	master_child_contract_agency_id smallint,
	master_child_contract_agency_id_cy smallint,
	master_child_contract_vendor_id integer,
	master_child_contract_vendor_id_cy integer,
	reporting_code varchar(15),
	location_id integer,
	fund_class_name varchar(50),
	fund_class_code varchar(5),
	spending_category_id smallint,
	spending_category_name varchar,
	calendar_fiscal_year_id smallint,
	calendar_fiscal_year smallint,
	agreement_accounting_line_number integer,
	agreement_commodity_line_number integer,
	agreement_vendor_line_number integer, 
	reference_document_number character varying,
	reference_document_code varchar(8),
	contract_document_code varchar(8),
	master_contract_document_code varchar(8),
	minority_type_id smallint,
 	minority_type_name character varying(50),
 	industry_type_id smallint,
   	industry_type_name character varying(50),
   	agreement_type_code character varying(2),
   	award_method_code character varying(10),
   	contract_industry_type_id smallint,
	contract_industry_type_id_cy smallint,
	master_contract_industry_type_id smallint,
	master_contract_industry_type_id_cy smallint,
	contract_minority_type_id smallint,
	contract_minority_type_id_cy smallint,
	master_contract_minority_type_id smallint,
	master_contract_minority_type_id_cy smallint,
	file_type char(1),
	load_id integer,
	last_modified_date timestamp without time zone,
	last_modified_fiscal_year_id smallint,
	last_modified_calendar_year_id smallint,
	is_prime_or_sub character(1),
	is_minority_vendor character(1), 
    vendor_type character(2),
    contract_original_agreement_id bigint,
	job_id bigint
)
DISTRIBUTED BY (disbursement_line_item_id);


INSERT INTO all_agreement_transactions(original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, dollar_difference, percent_difference, 
            master_agreement_id, master_contract_number, agreement_type_id, 
            agreement_type_code, agreement_type_name, award_category_id, 
            award_category_code, award_category_name, award_method_id, award_method_code, 
            award_method_name, expenditure_object_codes, expenditure_object_names, 
            industry_type_id, industry_type_name, award_size_id, effective_begin_date, 
            effective_begin_date_id, effective_begin_year, effective_begin_year_id, 
            effective_end_date, effective_end_date_id, effective_end_year, 
            effective_end_year_id, registered_date, registered_date_id, brd_awd_no, 
            tracking_number, rfed_amount, minority_type_id, minority_type_name, 
            master_agreement_yn, has_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, last_modified_year_id, is_prime_or_sub, 
            is_minority_vendor, vendor_type, contract_original_agreement_id, job_id)
    SELECT  original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, dollar_difference, percent_difference, 
            master_agreement_id, master_contract_number, agreement_type_id, 
            agreement_type_code, agreement_type_name, award_category_id, 
            award_category_code, award_category_name, award_method_id, award_method_code, 
            award_method_name, expenditure_object_codes, expenditure_object_names, 
            industry_type_id, industry_type_name, award_size_id, effective_begin_date, 
            effective_begin_date_id, effective_begin_year, effective_begin_year_id, 
            effective_end_date, effective_end_date_id, effective_end_year, 
            effective_end_year_id, registered_date, registered_date_id, brd_awd_no, 
            tracking_number, rfed_amount, minority_type_id, minority_type_name, 
            master_agreement_yn, has_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, b.nyc_year_id as last_modified_year_id, 'P' as is_prime_or_sub, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'Y' ELSE 'N' END) as is_minority_vendor, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'PM' ELSE 'P' END) as vendor_type,
            original_agreement_id as contract_original_agreement_id, job_id
       FROM agreement_snapshot a LEFT JOIN ref_date b ON a.last_modified_date::date = b.date;


INSERT INTO all_agreement_transactions_cy(original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, dollar_difference, percent_difference, 
            master_agreement_id, master_contract_number, agreement_type_id, 
            agreement_type_code, agreement_type_name, award_category_id, 
            award_category_code, award_category_name, award_method_id, award_method_code, 
            award_method_name, expenditure_object_codes, expenditure_object_names, 
            industry_type_id, industry_type_name, award_size_id, effective_begin_date, 
            effective_begin_date_id, effective_begin_year, effective_begin_year_id, 
            effective_end_date, effective_end_date_id, effective_end_year, 
            effective_end_year_id, registered_date, registered_date_id, brd_awd_no, 
            tracking_number, rfed_amount, minority_type_id, minority_type_name, 
            master_agreement_yn, has_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, last_modified_year_id, is_prime_or_sub, 
            is_minority_vendor, vendor_type, contract_original_agreement_id, job_id)
    SELECT  original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, dollar_difference, percent_difference, 
            master_agreement_id, master_contract_number, agreement_type_id, 
            agreement_type_code, agreement_type_name, award_category_id, 
            award_category_code, award_category_name, award_method_id, award_method_code, 
            award_method_name, expenditure_object_codes, expenditure_object_names, 
            industry_type_id, industry_type_name, award_size_id, effective_begin_date, 
            effective_begin_date_id, effective_begin_year, effective_begin_year_id, 
            effective_end_date, effective_end_date_id, effective_end_year, 
            effective_end_year_id, registered_date, registered_date_id, brd_awd_no, 
            tracking_number, rfed_amount, minority_type_id, minority_type_name, 
            master_agreement_yn, has_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, c.year_id as last_modified_year_id, 'P' as is_prime_or_sub, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'Y' ELSE 'N' END) as is_minority_vendor, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'PM' ELSE 'P' END) as vendor_type,
            original_agreement_id as contract_original_agreement_id, job_id
       FROM agreement_snapshot_cy a LEFT JOIN ref_date b ON a.last_modified_date::date = b.date
        LEFT JOIN ref_month c ON b.calendar_month_id = c.month_id;
       
       
   INSERT INTO all_disbursement_transactions(disbursement_line_item_id, disbursement_id, line_number, disbursement_number, 
            check_eft_issued_date_id, check_eft_issued_nyc_year_id, fiscal_year, 
            check_eft_issued_cal_month_id, agreement_id, master_agreement_id, 
            fund_class_id, check_amount, agency_id, agency_history_id, agency_code, 
            expenditure_object_id, vendor_id, department_id, maximum_contract_amount, 
            maximum_contract_amount_cy, maximum_spending_limit, maximum_spending_limit_cy, 
            document_id, vendor_name, vendor_customer_code, check_eft_issued_date, 
            agency_name, agency_short_name, location_name, location_code, 
            department_name, department_short_name, department_code, expenditure_object_name, 
            expenditure_object_code, budget_code_id, budget_code, budget_name, 
            contract_number, master_contract_number, master_child_contract_number, 
            contract_vendor_id, contract_vendor_id_cy, master_contract_vendor_id, 
            master_contract_vendor_id_cy, contract_agency_id, contract_agency_id_cy, 
            master_contract_agency_id, master_contract_agency_id_cy, master_purpose, 
            master_purpose_cy, purpose, purpose_cy, master_child_contract_agency_id, 
            master_child_contract_agency_id_cy, master_child_contract_vendor_id, 
            master_child_contract_vendor_id_cy, reporting_code, location_id, 
            fund_class_name, fund_class_code, spending_category_id, spending_category_name, 
            calendar_fiscal_year_id, calendar_fiscal_year, agreement_accounting_line_number, 
            agreement_commodity_line_number, agreement_vendor_line_number, 
            reference_document_number, reference_document_code, contract_document_code, 
            master_contract_document_code, minority_type_id, minority_type_name, 
            industry_type_id, industry_type_name, agreement_type_code, award_method_code, 
            contract_industry_type_id, contract_industry_type_id_cy, master_contract_industry_type_id, 
            master_contract_industry_type_id_cy, contract_minority_type_id, 
            contract_minority_type_id_cy, master_contract_minority_type_id, 
            master_contract_minority_type_id_cy, file_type, load_id, last_modified_date,
            last_modified_fiscal_year_id, last_modified_calendar_year_id,
            is_prime_or_sub, is_minority_vendor, vendor_type, contract_original_agreement_id, job_id)
     SELECT disbursement_line_item_id, disbursement_id, line_number, disbursement_number, 
            check_eft_issued_date_id, check_eft_issued_nyc_year_id, fiscal_year, 
            check_eft_issued_cal_month_id, agreement_id, master_agreement_id, 
            fund_class_id, check_amount, agency_id, agency_history_id, agency_code, 
            expenditure_object_id, vendor_id, department_id, maximum_contract_amount, 
            maximum_contract_amount_cy, maximum_spending_limit, maximum_spending_limit_cy, 
            document_id, vendor_name, vendor_customer_code, check_eft_issued_date, 
            agency_name, agency_short_name, location_name, location_code, 
            department_name, department_short_name, department_code, expenditure_object_name, 
            expenditure_object_code, budget_code_id, budget_code, budget_name, 
            contract_number, master_contract_number, master_child_contract_number, 
            contract_vendor_id, contract_vendor_id_cy, master_contract_vendor_id, 
            master_contract_vendor_id_cy, contract_agency_id, contract_agency_id_cy, 
            master_contract_agency_id, master_contract_agency_id_cy, master_purpose, 
            master_purpose_cy, purpose, purpose_cy, master_child_contract_agency_id, 
            master_child_contract_agency_id_cy, master_child_contract_vendor_id, 
            master_child_contract_vendor_id_cy, reporting_code, location_id, 
            fund_class_name, fund_class_code, spending_category_id, spending_category_name, 
            calendar_fiscal_year_id, calendar_fiscal_year, agreement_accounting_line_number, 
            agreement_commodity_line_number, agreement_vendor_line_number, 
            reference_document_number, reference_document_code, contract_document_code, 
            master_contract_document_code, minority_type_id, minority_type_name, 
            industry_type_id, industry_type_name, agreement_type_code, award_method_code, 
            contract_industry_type_id, contract_industry_type_id_cy, master_contract_industry_type_id, 
            master_contract_industry_type_id_cy, contract_minority_type_id, 
            contract_minority_type_id_cy, master_contract_minority_type_id, 
            master_contract_minority_type_id_cy, file_type, load_id, last_modified_date, 
            b.nyc_year_id as last_modified_fiscal_year_id, c.year_id as last_modified_calendar_year_id,
            'P' as is_prime_or_sub,
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'Y' ELSE 'N' END) as is_minority_vendor, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'PM' ELSE 'P' END) as vendor_type, agreement_id as contract_original_agreement_id, job_id
    FROM disbursement_line_item_details a LEFT JOIN ref_date b ON a.last_modified_date::date = b.date
        LEFT JOIN ref_month c ON b.calendar_month_id = c.month_id;
    
    
-- aggregate tables

DROP TABLE IF EXISTS aggregateon_subven_spending_coa_entities;
CREATE TABLE aggregateon_subven_spending_coa_entities (
	agency_id smallint,
	spending_category_id smallint,
	vendor_id integer,
	prime_vendor_id integer,
	minority_type_id smallint,
	industry_type_id smallint,
	month_id int,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2),
	total_disbursements integer
	) DISTRIBUTED BY (vendor_id);
	

DROP TABLE IF EXISTS aggregateon_subven_spending_contract;
CREATE TABLE aggregateon_subven_spending_contract (
    agreement_id bigint,
    document_id character varying(20),
    sub_contract_id character varying(20),
    document_code character varying(8),
	vendor_id integer,
	prime_vendor_id integer,
	minority_type_id smallint,
	industry_type_id smallint,
	agency_id smallint,
	description character varying(256),	
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2), 
	total_contract_amount numeric(16,2)
	) DISTRIBUTED BY (agreement_id);
	
	
DROP TABLE IF EXISTS aggregateon_subven_spending_vendor;
CREATE TABLE aggregateon_subven_spending_vendor (
	vendor_id integer,
	prime_vendor_id integer,
	minority_type_id smallint,
	industry_type_id smallint,
	agency_id smallint,
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2), 
	total_contract_amount numeric(16,2),
	total_sub_contracts integer,
	is_all_categories char(1)
	) DISTRIBUTED BY (vendor_id);
	
	
DROP TABLE IF EXISTS mid_aggregateon_subven_disbursement_spending_year;
CREATE TABLE mid_aggregateon_subven_disbursement_spending_year(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	check_amount numeric(16,2),
	type_of_year char(1))
DISTRIBUTED BY (original_agreement_id);


DROP TABLE IF EXISTS aggregateon_subven_contracts_cumulative_spending;
CREATE TABLE aggregateon_subven_contracts_cumulative_spending(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	description varchar,
	contract_number varchar,
	sub_contract_id character varying(20),
	vendor_id int,
	prime_vendor_id int,
	minority_type_id smallint,
	award_method_id smallint,
	agency_id smallint,
	industry_type_id smallint,
	award_size_id smallint,
	original_contract_amount numeric(16,2),
	maximum_contract_amount numeric(16,2),
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	current_year_spending_amount numeric(16,2),
	dollar_difference numeric(16,2),
	percent_difference numeric(16,2),
	status_flag char(1),
	type_of_year char(1)	
) DISTRIBUTED BY (vendor_id);


DROP TABLE IF EXISTS aggregateon_subven_contracts_spending_by_month;
CREATE TABLE aggregateon_subven_contracts_spending_by_month(
 original_agreement_id bigint,
 fiscal_year smallint,
 fiscal_year_id smallint,
 document_code_id smallint,
 month_id integer,
 vendor_id int,
 prime_vendor_id int,
 minority_type_id smallint,
 award_method_id smallint,
 agency_id smallint,
 industry_type_id smallint,
 award_size_id smallint,
 spending_amount numeric(16,2),
 status_flag char(1),
 type_of_year char(1) 
) DISTRIBUTED BY (vendor_id);


DROP TABLE IF EXISTS aggregateon_subven_total_contracts;
CREATE TABLE aggregateon_subven_total_contracts
(
fiscal_year smallint,
fiscal_year_id smallint,
vendor_id int,
 prime_vendor_id int,
 minority_type_id smallint,
award_method_id smallint,
agency_id smallint,
industry_type_id smallint,
award_size_id smallint,
total_contracts bigint,
total_commited_contracts bigint,
total_master_agreements bigint,
total_standalone_contracts bigint,
total_revenue_contracts bigint,
total_revenue_contracts_amount numeric(16,2),
total_commited_contracts_amount numeric(16,2),
total_contracts_amount numeric(16,2),
total_spending_amount_disb numeric(16,2), 
total_spending_amount numeric(16,2), 
status_flag char(1),
type_of_year char(1)
) DISTRIBUTED BY (fiscal_year);



DROP TABLE IF EXISTS contracts_subven_spending_transactions;
CREATE TABLE contracts_subven_spending_transactions
(
disbursement_line_item_id bigint,
original_agreement_id bigint,
fiscal_year smallint,
fiscal_year_id smallint,
document_code_id smallint,
vendor_id int,
prime_vendor_id int,
minority_type_id smallint,
award_method_id smallint,
document_agency_id smallint,
industry_type_id smallint,
award_size_id smallint,
disb_document_id  character varying(20),
disb_vendor_name  character varying,
disb_check_eft_issued_date  date,
disb_agency_name  character varying(100),
disb_check_amount  numeric(16,2),
disb_contract_number  character varying,
disb_sub_contract_id  character varying,
disb_purpose  character varying,
disb_reporting_code  character varying(15),
disb_spending_category_name  character varying,
disb_agency_id  smallint,
disb_vendor_id  integer,
disb_spending_category_id  smallint,
disb_agreement_id  bigint,
disb_contract_document_code  character varying(8),
disb_fiscal_year_id  smallint,
disb_check_eft_issued_cal_month_id integer,
disb_disbursement_number character varying(40),
disb_minority_type_id smallint,
disb_minority_type_name character varying(50),
disb_vendor_type character(2),
disb_master_contract_number  character varying,
status_flag char(1),
type_of_year char(1)
) DISTRIBUTED BY (disbursement_line_item_id);


DROP TABLE IF EXISTS aggregateon_all_contracts_cumulative_spending;
CREATE TABLE aggregateon_all_contracts_cumulative_spending(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	master_agreement_yn character(1),
	description varchar,
	contract_number varchar,
	sub_contract_id character varying(20),
	vendor_id int,
	prime_vendor_id int,
	minority_type_id smallint,
	award_method_id smallint,
	agency_id smallint,
	industry_type_id smallint,
	award_size_id smallint,
	original_contract_amount numeric(16,2),
	maximum_contract_amount numeric(16,2),
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	current_year_spending_amount numeric(16,2),
	dollar_difference numeric(16,2),
	percent_difference numeric(16,2),
	status_flag char(1),
	type_of_year char(1)	
) DISTRIBUTED BY (vendor_id) ;


-- external and staging tables


set search_path=etl;

DROP SEQUENCE IF EXISTS seq_stg_scntrc_details_uniq_id CASCADE;
DROP SEQUENCE IF EXISTS seq_stg_scntrc_status_uniq_id CASCADE;
DROP SEQUENCE IF EXISTS seq_stg_scntrc_bus_type_uniq_id CASCADE;
DROP SEQUENCE IF EXISTS seq_stg_scntrc_pymt_uniq_id CASCADE;

create sequence   seq_stg_scntrc_details_uniq_id;
create sequence   seq_stg_scntrc_status_uniq_id;
create sequence   seq_stg_scntrc_bus_type_uniq_id;
create sequence   seq_stg_scntrc_pymt_uniq_id;

DROP EXTERNAL TABLE IF EXISTS ext_stg_scntrc_details_data_feed;

CREATE EXTERNAL TABLE ext_stg_scntrc_details_data_feed
(
  doc_cd character varying(8),
  doc_dept_cd character varying(4),
  doc_id character varying(20),
  vendor_cust_cd character varying(20),
  cntrc_typ character varying,
  scntrc_id character varying,
  aprv_sta character varying,
  aprv_reas_id character varying,
  aprv_reas_nm character varying,
  aprv_reas_nm_up character varying,
  scntrc_dscr character varying,
  scntrc_dscr_up character varying,
  scntrc_mwbe_cert character varying,
  indus_cls character varying,
  scntrc_strt_dt character varying(100),
  scntrc_end_dt character varying(100),
  scntrc_max_am character varying(100),
  tot_scntrc_pymt character varying(100),
  scntrc_pymt_act character varying,
  scntrc_mode character varying,
  scntrc_vers_no character varying,
  scntrc_vend_cd character varying(20),
  scntrc_lgl_nm character varying(100),
  scntrc_lgl_nm_up character varying(100),
  scntrc_trkg_no character varying,
  scntrc_trkg_no_up character varying,
  lgl_nm character varying(100),
  lgl_nm_up character varying(100),
  doc_ref character varying,
  col30 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/scntrc_details_data_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';

DROP  TABLE  IF EXISTS stg_scntrc_details;
DROP  TABLE  IF EXISTS archive_scntrc_details;
DROP  TABLE  IF EXISTS invalid_scntrc_details;

CREATE  TABLE stg_scntrc_details
(
  doc_cd character varying(8),
  doc_dept_cd character varying(4),
  doc_id character varying(20),
  vendor_cust_cd character varying(20),
  cntrc_typ smallint,
  scntrc_id character varying(20),
  aprv_sta smallint,
  aprv_reas_id character varying(3),
  aprv_reas_nm character varying(30),
  aprv_reas_nm_up character varying(30),
  scntrc_dscr character varying(256),
  scntrc_dscr_up character varying(256),
  scntrc_mwbe_cert smallint,
  indus_cls smallint,
  scntrc_strt_dt date,
  scntrc_end_dt date,
  scntrc_max_am numeric(16,2),
  tot_scntrc_pymt numeric(16,2),
  scntrc_pymt_act smallint,
  scntrc_mode smallint,
  scntrc_vers_no integer,
  scntrc_vend_cd character varying(20),
  scntrc_lgl_nm character varying(60),
  scntrc_lgl_nm_up character varying(60),
  scntrc_trkg_no character varying(30),
  scntrc_trkg_no_up character varying(30),
  lgl_nm character varying(60),
  lgl_nm_up character varying(60),
  doc_ref character varying(75),
  doc_appl_last_dt date,
  reg_dt date,
  document_code_id smallint,
  agency_history_id smallint,
  vendor_history_id integer,
	effective_begin_date_id int,
	effective_end_date_id int,
	source_updated_date_id int,
	registered_date_id int,
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
  uniq_id bigint DEFAULT nextval('etl.seq_stg_scntrc_details_uniq_id'::regclass),
  invalid_flag character(1),
  invalid_reason character varying
)
DISTRIBUTED BY (uniq_id);


CREATE TABLE archive_scntrc_details (LIKE stg_scntrc_details) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_scntrc_details ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_scntrc_details (LIKE archive_scntrc_details) DISTRIBUTED BY (uniq_id);


DROP  EXTERNAL TABLE  IF EXISTS ext_stg_scntrc_status_data_feed;
CREATE EXTERNAL TABLE ext_stg_scntrc_status_data_feed
(
  doc_cd character varying(8),
  doc_dept_cd character varying(4),
  doc_id character varying(20),
  vendor_cust_cd character varying(20),
  scntrc_sta character varying,
  cntrc_typ character varying,
  tot_scntrc_max_am character varying(100),
  tot_scntrc_pymt character varying(100),
  col9 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/scntrc_status_data_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';

DROP  TABLE  IF EXISTS stg_scntrc_status;
DROP  TABLE  IF EXISTS archive_scntrc_status;
DROP  TABLE  IF EXISTS invalid_scntrc_status;

CREATE  TABLE stg_scntrc_status
(
  doc_cd character varying(8),
  doc_dept_cd character varying(4),
  doc_id character varying(20),
  vendor_cust_cd character varying(20),
  scntrc_sta smallint,
  cntrc_typ smallint,
  tot_scntrc_max_am numeric(16,2),
  tot_scntrc_pymt numeric(16,2),
  uniq_id bigint DEFAULT nextval('etl.seq_stg_scntrc_status_uniq_id'::regclass),
  invalid_flag character(1),
  invalid_reason character varying
) DISTRIBUTED BY (uniq_id);


CREATE TABLE archive_scntrc_status (LIKE stg_scntrc_status) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_scntrc_status ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_scntrc_status (LIKE archive_scntrc_status) DISTRIBUTED BY (uniq_id);


DROP  EXTERNAL TABLE  IF EXISTS ext_stg_scntrc_bus_type_data_feed;
CREATE EXTERNAL TABLE ext_stg_scntrc_bus_type_data_feed
(
  doc_cd character varying(8),
  doc_dept_cd character varying(4),
  doc_id character varying(20),
  vendor_cust_cd character varying(20),
  scntrc_id character varying,
  scntrc_vend_cd character varying(20),
  bus_typ character varying,
  bus_typ_sta character varying,
  cert_strt_dt character varying(100),
  init_dt character varying(100),
  disp_cert_strt_dt character varying(100),
  cert_end_dt character varying(100),
  cert_no character varying(30),
  min_typ character varying(10),
  col15 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/scntrc_bus_type_data_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';


DROP  TABLE  IF EXISTS stg_scntrc_bus_type;
DROP  TABLE  IF EXISTS archive_scntrc_bus_type;
DROP  TABLE  IF EXISTS invalid_scntrc_bus_type;

CREATE  TABLE stg_scntrc_bus_type
(
  doc_cd character varying(8),
  doc_dept_cd character varying(4),
  doc_id character varying(20),
  vendor_cust_cd character varying(20),
  scntrc_id character varying(20),
  scntrc_vend_cd character varying(20),
  bus_typ character varying(10),
  bus_typ_sta integer,
  cert_strt_dt date,
  init_dt date,
  disp_cert_strt_dt date,
  cert_end_dt date,
  cert_no character varying(30),
  min_typ integer,
  uniq_id bigint DEFAULT nextval('etl.seq_stg_scntrc_bus_type_uniq_id'::regclass),
  invalid_flag character(1),
  invalid_reason character varying
) DISTRIBUTED BY (uniq_id);


CREATE TABLE archive_scntrc_bus_type (LIKE stg_scntrc_bus_type) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_scntrc_bus_type ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_scntrc_bus_type (LIKE archive_scntrc_bus_type) DISTRIBUTED BY (uniq_id);



DROP  EXTERNAL TABLE  IF EXISTS ext_stg_scntrc_pymt_data_feed;
CREATE EXTERNAL TABLE ext_stg_scntrc_pymt_data_feed
(
  doc_cd character varying(8),
  doc_dept_cd character varying(4),
  doc_id character varying(20),
  vendor_cust_cd character varying(20),
  scntrc_id character varying,
  scntrc_pymt_id character varying,
  lgl_nm character varying,
  lgl_nm_up character varying,
  scntrc_lgl_nm character varying,
  scntrc_vend_cd character varying(20),
  scntrc_lgl_nm_up character varying,
  scntrc_pymt_dt character varying(100),
  scntrc_pymt_am character varying(100),
  scntrc_pymt_dscr character varying,
  scntrc_pymt_dscr_up character varying,
  scntrc_prf_pymt character varying,
  scntrc_prf_pymt_up character varying,
  scntrc_fnl_pymt_fl character varying,
  doc_ref character varying,
  col20 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/scntrc_pymt_data_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';



DROP  TABLE  IF EXISTS stg_scntrc_pymt;
DROP  TABLE  IF EXISTS archive_scntrc_pymt;
DROP  TABLE  IF EXISTS invalid_scntrc_pymt;

CREATE  TABLE stg_scntrc_pymt
(
  doc_cd character varying(8),
  doc_dept_cd character varying(4),
  doc_id character varying(20),
  vendor_cust_cd character varying(20),
  scntrc_id character varying(20),
  scntrc_pymt_id character varying(20),
  lgl_nm character varying(60),
  lgl_nm_up character varying(60),
  scntrc_lgl_nm character varying(60),
  scntrc_vend_cd character varying(20),
  scntrc_lgl_nm_up character varying(60),
  scntrc_pymt_dt date,
  scntrc_pymt_am numeric(16,2),
  scntrc_pymt_dscr character varying(256),
  scntrc_pymt_dscr_up character varying(256),
  scntrc_prf_pymt character varying(256),
  scntrc_prf_pymt_up character varying(256),
  scntrc_fnl_pymt_fl character varying(3),
  doc_ref character varying(75),
  agreement_id bigint,
  document_code_id smallint,
  agency_history_id smallint,
  vendor_history_id integer,
  check_eft_issued_date_id int,
  check_eft_issued_nyc_year_id smallint,  
  uniq_id bigint DEFAULT nextval('etl.seq_stg_scntrc_pymt_uniq_id'::regclass),
  invalid_flag character(1),
  invalid_reason character varying
) DISTRIBUTED BY (uniq_id);


CREATE TABLE archive_scntrc_pymt (LIKE stg_scntrc_pymt) DISTRIBUTED BY (uniq_id);
ALTER TABLE archive_scntrc_pymt ADD COLUMN load_file_id bigint;

CREATE TABLE invalid_scntrc_pymt (LIKE archive_scntrc_pymt) DISTRIBUTED BY (uniq_id);



DROP  TABLE  IF EXISTS tmp_stg_scntrc_vendor;
CREATE TABLE tmp_stg_scntrc_vendor(
 	vend_cust_cd varchar(20),	
 	lgl_nm varchar(60),
 	vendor_history_id integer, 
 	uniq_id bigint
 	)	DISTRIBUTED BY (uniq_id);
 	
 	
DROP  TABLE  IF EXISTS tmp_scntrc_all_vendors;		
CREATE TABLE tmp_scntrc_all_vendors(
	uniq_id bigint,
	vendor_customer_code varchar, 
	vendor_history_id integer, 
	vendor_id integer, 					
	is_new_vendor char(1), 
	is_name_changed char(1), 
	is_bus_type_changed char(1), 					
	lgl_nm varchar(60)
	)	DISTRIBUTED BY (uniq_id);
	
	
DROP  TABLE  IF EXISTS tmp_scntrc_all_vendors_uniq_id;		 
CREATE TABLE tmp_scntrc_all_vendors_uniq_id(
	uniq_id bigint
	)	DISTRIBUTED BY (uniq_id);

	
DROP  TABLE  IF EXISTS tmp_scntrc_vendor_update;		 
CREATE TABLE tmp_scntrc_vendor_update (
     	vendor_id integer,
     	legal_name varchar(60)
		)	DISTRIBUTED BY (vendor_id);	
		
/*
DROP  TABLE  IF EXISTS scntrc_vendor_id_seq;	 
CREATE TABLE scntrc_vendor_id_seq(uniq_id bigint,vendor_id int DEFAULT nextval('public.seq_subvendor_vendor_id'))
DISTRIBUTED BY (uniq_id);

 DROP  TABLE  IF EXISTS scntrc_vendor_history_id_seq; 
CREATE TABLE scntrc_vendor_history_id_seq(uniq_id bigint,vendor_history_id int DEFAULT nextval('public.seq_subvendor_history_vendor_history_id'))
DISTRIBUTED BY (uniq_id);

 DROP  TABLE  IF EXISTS scntrc_vendor_business_id_seq;	 
CREATE TABLE scntrc_vendor_business_id_seq(uniq_id bigint,vendor_business_type_id int DEFAULT nextval('public.seq_subvendor_bus_type_vendor_bus_type_id'))
DISTRIBUTED BY (uniq_id);	

 DROP  TABLE  IF EXISTS sub_agreement_id_seq; 
CREATE TABLE sub_agreement_id_seq(uniq_id bigint, agreement_id bigint default nextval('public.seq_sub_agreement_agreement_id'))
DISTRIBUTED BY (uniq_id);
*/

DROP TABLE IF EXISTS malformed_scntrc_details_data_feed;
CREATE TABLE malformed_scntrc_details_data_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);


DROP TABLE IF EXISTS malformed_scntrc_status_data_feed;
CREATE TABLE malformed_scntrc_status_data_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);


DROP TABLE IF EXISTS malformed_scntrc_bus_type_data_feed;
CREATE TABLE malformed_scntrc_bus_type_data_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);


DROP TABLE IF EXISTS malformed_scntrc_pymt_data_feed;
CREATE TABLE malformed_scntrc_pymt_data_feed(
	record varchar,
	load_file_id integer)
DISTRIBUTED BY (load_file_id);


-- scripts to run

set search_path=public;

TRUNCATE  etl.ref_data_source;
COPY etl.ref_data_source FROM '/home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/ref_data_source.csv' CSV HEADER QUOTE as '"';

TRUNCATE  etl.ref_column_mapping;
COPY etl.ref_column_mapping FROM '/home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/ref_column_mapping.csv' CSV HEADER QUOTE as '"';

TRUNCATE  etl.ref_validation_rule;
COPY etl.ref_validation_rule FROM '/home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/ref_validation_rule.csv' CSV HEADER QUOTE as '"';

TRUNCATE  etl.ref_file_name_pattern;
COPY etl.ref_file_name_pattern FROM '/home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/ref_file_name_pattern.csv' CSV HEADER QUOTE as '"';

TRUNCATE etl.aggregate_tables;
COPY etl.aggregate_tables FROM '/home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/widget_aggregate_tables.csv' CSV HEADER QUOTE as '"';
COPY etl.aggregate_tables FROM '/home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/widget_aggregate_tables_mwbe.csv' CSV HEADER QUOTE as '"';
COPY etl.aggregate_tables FROM '/home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/widget_aggregate_tables_subcontracts.csv' CSV HEADER QUOTE as '"';

/*

psql -d checkbook_mwbe -f /home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/Scripts.sql 1>1.out 2>2.err
psql -d checkbook_mwbe -f /home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/SubCONScripts.sql 1>1.out 2>2.err
psql -d checkbook_mwbe -f /home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/SubContractStatusScripts.sql 1>1.out 2>2.err
psql -d checkbook_mwbe -f /home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/SubContractVendorBusTypeScripts.sql 1>1.out 2>2.err
psql -d checkbook_mwbe -f /home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/SubFMSScripts.sql 1>1.out 2>2.err
psql -d checkbook_mwbe -f /home/gpadmin/TREDDY/SUB_CONTRACTS/CREATE_NEW_DATABASE/SubVendorScripts.sql 1>1.out 2>2.err

*/




/* Testing the script changes
 
 -- UPDATE etl.etl_data_load_file set processed_flag = 'N' where load_file_id in (11020, 11021, 11022, 11023);
 
 UPDATE etl.etl_data_load_file set processed_flag = 'N' where load_file_id in (11481, 11482, 11483, 11484);
 
-- For business types

select max(job_id) from etl.etl_data_load;
insert into etl.etl_data_load(job_id,data_source_code,publish_start_time,files_available_flag) values(600, 'SV','2014-07-31 23:00:07.773','Y');
insert into etl.etl_data_load_file(load_id, file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag,publish_start_time) values(11981,'AIEG_DLY_SCNTRC_BTY_20140515103710.txt','20140515103710','D','Y','Y','N','2014-08-25 11:36:22.03305');
load_file_id ===> 11481

select etl.stageandarchivedata(11481);
select etl.validatedata(11481);
select etl.processdata(11481);

select count(*) from etl.stg_scntrc_bus_type; 
select count(*) from subcontract_vendor_business_type;
select count(*) from subcontract_business_type ;
select distinct scntrc_vend_cd, bus_typ, bus_typ_sta, min_typ from etl.stg_scntrc_bus_type  order by scntrc_vend_cd;
SELECT scntrc_vend_cd, count(*) from (select distinct scntrc_vend_cd, bus_typ, bus_typ_sta, min_typ from etl.stg_scntrc_bus_type order by scntrc_vend_cd) X group by 1 having count(*) > 1;

select distinct scntrc_vend_cd, bus_typ, bus_typ_sta, min_typ from etl.stg_scntrc_bus_type where scntrc_vend_cd in (SELECT scntrc_vend_cd FROM (SELECT scntrc_vend_cd, count(*) from (select distinct scntrc_vend_cd, bus_typ, bus_typ_sta, min_typ from etl.stg_scntrc_bus_type order by scntrc_vend_cd) X group by 1 having count(*) > 1) X) order by scntrc_vend_cd;


-- For Sub Contracts status

insert into etl.etl_data_load(job_id,data_source_code,publish_start_time,files_available_flag) values(600, 'SS','2014-08-25 23:00:07.773','Y');
insert into etl.etl_data_load_file(load_id, file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag,publish_start_time) values(11982,'AIEG_DLY_SCNTRC_STA_20140515103710.txt','20140515103710','D','Y','Y','N','2014-08-25 11:36:22.03305');
load_file_id ===> 11482


select etl.stageandarchivedata(11482);

select count(*) from etl.stg_scntrc_status ;
wc -l /vol2share/NYC/FEEDS/GPFDIST_DIR/datafiles/scntrc_status_data_feed.txt


select etl.validatedata(11482);

select count(*) from etl.stg_scntrc_status ;


select etl.processdata(11482);

select count(*) from subcontract_status ;
select distinct doc_cd, doc_dept_cd, doc_id from etl.stg_scntrc_status;
select contract_number, count(*) from subcontract_status group by 1 having count(*)>1;

-- For SubContract Contracts


insert into etl.etl_data_load(job_id,data_source_code,publish_start_time,files_available_flag) values(600, 'SC','2014-08-25 23:00:07.773','Y');
insert into etl.etl_data_load_file(load_id, file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag,publish_start_time) values(11983,'AIEG_DLY_SCNTRC_DET_20140515103710.txt','20140515103710','D','Y','Y','N','2014-08-25 11:36:22.03305');
load_file_id ===> 11483


select etl.stageandarchivedata(11483);

select count(*) from etl.stg_scntrc_details;
 wc -l /vol2share/NYC/FEEDS/GPFDIST_DIR/datafiles/scntrc_details_data_feed.txt

select etl.validatedata(11483);
select count(*) from etl.stg_scntrc_details;

select etl.processdata(11483);  


select count(*) from subcontract_details;
select * from subcontract_details where agreement_id = original_agreement_id OR original_version_flag = 'Y' OR latest_flag = 'Y' ;
select distinct doc_cd, doc_dept_cd, doc_id, scntrc_vers_no, scntrc_id from etl.stg_scntrc_details 


-- For SubContract Spending

insert into etl.etl_data_load(job_id,data_source_code,publish_start_time,files_available_flag) values(600, 'SF','2014-08-25 23:00:07.773','Y');
insert into etl.etl_data_load_file(load_id, file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag,publish_start_time) values(11984,'AIEG_DLY_SCNTRC_PMT_20140515103710.txt','20140515103710','D','Y','Y','N','2014-08-25 11:36:22.03305');
load_file_id ===> 11484


select etl.stageandarchivedata(11484);
select count(*) from etl.stg_scntrc_pymt ;
 wc -l /vol2share/NYC/FEEDS/GPFDIST_DIR/datafiles/scntrc_pymt_data_feed.txt
 
 select etl.validatedata(11484);
select count(*) from etl.stg_scntrc_pymt;

select etl.processdata(11484);

select count(*) from subcontract_spending;



-- post process sub contracts and sub contract spending

select etl.postProcessSubContracts(733);
select count(*) from sub_agreement_snapshot;
select count(*) from sub_agreement_snapshot_cy;


select etl.refreshFactsForSubPayments(733);
select count(*) from subcontract_spending_details ;
select * from subcontract_spending_details order by vendor_customer_code;

select etl.refreshSubContractsPreAggregateTables(733); 
select count(*) from sub_agreement_snapshot_expanded;
select count(*) from sub_agreement_snapshot_expanded_cy;
select count(*), status_flag from sub_agreement_snapshot_expanded group by 2;
select count(*), status_flag from sub_agreement_snapshot_expanded_cy group by 2;
select count(*), status_flag, fiscal_year from sub_agreement_snapshot_expanded group by 2,3 order by 2,3;
select count(*), status_flag, fiscal_year from sub_agreement_snapshot_expanded_cy group by 2,3 order by 2,3;

select etl.refreshCommonTransactionTables(733);
select count(*) from all_agreement_transactions where is_prime_or_sub = 'P';
select count(*) from all_agreement_transactions where is_prime_or_sub = 'S';
select count(*) from agreement_snapshot;
select count(*) from sub_agreement_snapshot;

select count(*) from all_disbursement_transactions where is_prime_or_sub = 'P';
select count(*) from all_disbursement_transactions where is_prime_or_sub = 'S';
select count(*) from disbursement_line_item_details;
select count(*) from subcontract_spending_details;
  



select etl.temprefreshsubvenaggregates(733);

select etl.grantaccess('webuser1','SELECT');

select count(*) from aggregateon_subven_spending_coa_entities;
select type_of_year, count(*) from aggregateon_subven_spending_coa_entities group by 1;
select type_of_year, year_value, count(*) from aggregateon_subven_spending_coa_entities a JOIN ref_year b ON a.year_id = b.year_id group by 1,2 order by 2;
select spending_category_id, agency_id,  vendor_id, prime_vendor_id, count(*) from subcontract_spending_details group by 1,2,3,4;

select count(*) from aggregateon_subven_spending_contract ;
select type_of_year, count(*) from aggregateon_subven_spending_contract group by 1;
select count(*), type_of_year, year_id, agreement_id from aggregateon_subven_spending_contract group by 2,3,4 having count(*) > 1

select count(*) from aggregateon_subven_spending_vendor ;

select * from ref_year where year_id = 115 ;
select * from aggregateon_subven_spending_vendor where is_all_categories = 'N' and type_of_year = 'B' order by vendor_id ;
select sum(check_amount), prime_vendor_id, agency_id from subcontract_spending_details where vendor_id = 136743 and fiscal_year = 2014 group by 2,3 ;
select * from subcontract_spending where check_eft_issued_nyc_year_id = 115 and vendor_history_id in (select distinct vendor_history_id from subvendor_history where vendor_id = 136743);
select * from subvendor_history where vendor_id = 136743 ;
select * from subvendor where vendor_id = 136743;
select * from etl.stg_scntrc_pymt where scntrc_vend_cd  = '0002984581' order by doc_id;

select vendor_id, year_id, type_of_year, count(distinct prime_vendor_id) from aggregateon_subven_spending_vendor group by 1,2,3 having count(distinct prime_vendor_id) > 1 order by 4 desc limit 10
select * from aggregateon_subven_spending_vendor where is_all_categories = 'N' and type_of_year = 'B' and vendor_id = 136888
136064;17735;7;197;1;115;"B";53379.00;1276000.00;"N"
136064;17735;7;197;1;114;"B";1149210.00;1276000.00;"N"
136064;18555;7;197;1;115;"B";224154.00;1717000.00;"N"
136064;18555;7;197;1;114;"B";1321901.00;1717000.00;"N"

select * from aggregateon_subven_spending_contract where type_of_year = 'B'  and vendor_id = 136162
select sum(check_amount) from subcontract_spending_details where vendor_id = 136888

select * from subvendor where vendor_id = 136064
select * from vendor where vendor_id = 17264  -- "0000798150"
select * from subvendor where vendor_customer_code = '0002313868'

select * from etl.stg_scntrc_details where scntrc_vend_cd = '0002313868'  order by vendor_cust_cd

select scntrc_vend_cd, vendor_cust_cd, count(*) from etl.stg_scntrc_details group by 1,2 having count(*) > 1 order by 3 desc 


select count(*) from mid_aggregateon_subven_disbursement_spending_year;
select count(*) from subcontract_spending_details WHERE agreement_id IS NULL;
select count(*), type_of_year, year_value from mid_aggregateon_subven_disbursement_spending_year a JOIN ref_year b ON a.fiscal_year_id = b.year_id group by 2,3 order by 2,3;

select count(*) from aggregateon_subven_contracts_cumulative_spending;
select status_flag,type_of_year,fiscal_year, count(*) from aggregateon_subven_contracts_cumulative_spending group by 1,2,3 order by 1,2,3;

select count(*) from aggregateon_subven_contracts_spending_by_month;
select count(*) from aggregateon_subven_total_contracts;
 select fiscal_year, type_of_year, status_flag, sum(total_contracts), sum(total_master_agreements), sum(total_contracts_amount), sum(total_spending_amount) from aggregateon_subven_total_contracts group by 1,2,3 order by 1,2,3;

*/