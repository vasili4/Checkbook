SET search_path = public;

DROP TABLE IF EXISTS vendor_min_bus_type;
CREATE TABLE vendor_min_bus_type
( vendor_id integer,
  vendor_history_id integer,
  business_type_id smallint,
  minority_type_id smallint,
  business_type_code character varying(4),
  business_type_name character varying(50),
  minority_type_name character varying(50)
)
DISTRIBUTED BY (vendor_history_id);


DROP TABLE IF EXISTS agreement_snapshot ;
CREATE TABLE agreement_snapshot  (
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
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying(20),
   vendor_name character varying,
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
   job_id bigint
 )WITH(appendonly=true,orientation=column)  
 DISTRIBUTED BY (original_agreement_id);
 

 

DROP TABLE IF EXISTS agreement_snapshot_cy ;
CREATE TABLE agreement_snapshot_cy  (
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
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying(20),
   vendor_name character varying,
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
   job_id bigint
 )WITH(appendonly=true,orientation=column)  
 DISTRIBUTED BY (original_agreement_id);
 
 
  DROP TABLE IF EXISTS agreement_snapshot_expanded ;
 CREATE TABLE agreement_snapshot_expanded(
	original_agreement_id bigint,
	agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	vendor_id int,
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
	master_agreement_id bigint,
	minority_type_id smallint,
 	minority_type_name character varying(50),
	master_agreement_yn character(1),
	status_flag char(1)
	)WITH(appendonly=true)
DISTRIBUTED BY (original_agreement_id);	


DROP TABLE IF EXISTS agreement_snapshot_expanded_cy ;
CREATE TABLE agreement_snapshot_expanded_cy(
	original_agreement_id bigint,
	agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	vendor_id int,
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
	master_agreement_id bigint,
	minority_type_id smallint,
 	minority_type_name character varying(50),
	master_agreement_yn character(1),
	status_flag char(1)
	)WITH(appendonly=true)
DISTRIBUTED BY (original_agreement_id);	
 


 DROP TABLE IF EXISTS disbursement_line_item_details ;
 CREATE TABLE disbursement_line_item_details(
	disbursement_line_item_id bigint,
	disbursement_id integer,
	line_number integer,
	disbursement_number character varying(40),
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
	master_contract_number character varying,
	master_child_contract_number character varying,
  	contract_vendor_id integer,
  	contract_vendor_id_cy integer,
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
	job_id bigint
	)WITH(appendonly=true,orientation=column)
DISTRIBUTED BY (disbursement_line_item_id)
PARTITION BY RANGE (fiscal_year) 
(START (2010) END (2015) EVERY (1),
DEFAULT PARTITION outlying_years);


 
 DROP TABLE IF EXISTS pending_contracts ;
CREATE TABLE pending_contracts(
 	document_code_id smallint,
 	document_agency_id  smallint,
 	document_id  varchar,
  	parent_document_code_id smallint,
  	parent_document_agency_id  smallint,
 	parent_document_id  varchar,
 	encumbrance_amount_original numeric(15,2),
 	encumbrance_amount numeric(15,2),
 	original_maximum_amount_original numeric(15,2),
 	original_maximum_amount numeric(15,2),
 	revised_maximum_amount_original numeric(15,2),
 	revised_maximum_amount numeric(15,2),
 	registered_contract_max_amount numeric(15,2),
 	vendor_legal_name varchar(80),
 	vendor_customer_code varchar(20),
 	vendor_id int,
 	description varchar(78),
 	submitting_agency_id  smallint,
 	oaisis_submitting_agency_desc	 varchar(50),
 	submitting_agency_code	 varchar(4),
 	awarding_agency_id  smallint,
 	oaisis_awarding_agency_desc	 varchar(50),
 	awarding_agency_code	 varchar(4),
 	contract_type_name varchar(40),
 	cont_type_code  varchar(2),
 	award_method_name varchar(50),
 	award_method_code varchar(3),
 	award_method_id smallint,
 	start_date date,
 	end_date date,
 	revised_start_date date,
 	revised_end_date date,
 	cif_received_date date,
 	cif_fiscal_year smallint,
 	cif_fiscal_year_id smallint,
 	tracking_number varchar(30),
 	board_award_number varchar(15),
 	oca_number varchar(10),
	version_number varchar(5),
	fms_contract_number varchar,
	contract_number varchar,
	fms_parent_contract_number varchar,
	submitting_agency_name varchar,
	submitting_agency_short_name varchar,
	awarding_agency_name varchar,
	awarding_agency_short_name varchar,
	start_date_id int,
	end_date_id int,	
	revised_start_date_id int,
	revised_end_date_id int,	
	cif_received_date_id int,
	document_agency_code varchar, 
	document_agency_name varchar, 
	document_agency_short_name varchar ,
	funding_agency_id  smallint,
	funding_agency_code varchar, 
	funding_agency_name varchar, 
	funding_agency_short_name varchar ,
	original_agreement_id bigint,
	original_master_agreement_id bigint,
	dollar_difference numeric(16,2),
  	percent_difference numeric(17,4),
	original_or_modified varchar,
	original_or_modified_desc varchar,
	award_size_id smallint,
	award_category_id smallint,
	industry_type_id smallint,
	document_version smallint,
	minority_type_id smallint,
 	minority_type_name character varying(50),
 	is_prime_or_sub character(1),
  is_minority_vendor character(1),
  vendor_type character(2),
	latest_flag char(1)
 ) DISTRIBUTED BY (document_code_id);


	
-- aggregate tables Scripts

 DROP TABLE IF EXISTS aggregateon_mwbe_spending_coa_entities ;
CREATE TABLE aggregateon_mwbe_spending_coa_entities (
	department_id integer,
	agency_id smallint,
	spending_category_id smallint,
	expenditure_object_id integer,
	vendor_id integer,
	minority_type_id smallint,
	industry_type_id smallint,
	month_id int,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2),
	total_disbursements integer
	)WITH(appendonly=true)
DISTRIBUTED BY (department_id);


 DROP TABLE IF EXISTS aggregateon_mwbe_spending_contract ;
CREATE TABLE aggregateon_mwbe_spending_contract (
    agreement_id bigint,
    document_id character varying(20),
    document_code character varying(8),
	vendor_id integer,
	minority_type_id smallint,
	industry_type_id smallint,
	agency_id smallint,
	description character varying(60),
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2), 
	total_contract_amount numeric(16,2)
	)WITH(appendonly=true) 
	DISTRIBUTED BY (agreement_id) ;


 DROP TABLE IF EXISTS aggregateon_mwbe_spending_vendor ;	
CREATE TABLE aggregateon_mwbe_spending_vendor (
	vendor_id integer,
	minority_type_id smallint,
	industry_type_id smallint,
	agency_id smallint,
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2), 
	total_contract_amount numeric(16,2),
	is_all_categories char(1)
	)WITH(appendonly=true) 
	DISTRIBUTED BY (vendor_id) ;


 DROP TABLE IF EXISTS aggregateon_mwbe_spending_vendor_exp_object ;
CREATE TABLE aggregateon_mwbe_spending_vendor_exp_object(
	vendor_id integer,
	minority_type_id smallint,
	industry_type_id smallint,
	expenditure_object_id integer,
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2) 
	)WITH(appendonly=true)
DISTRIBUTED BY (expenditure_object_id);	


 DROP TABLE IF EXISTS aggregateon_mwbe_contracts_cumulative_spending ;
CREATE TABLE aggregateon_mwbe_contracts_cumulative_spending(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	master_agreement_yn character(1),
	description varchar,
	contract_number varchar,
	vendor_id int,
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
)WITH(appendonly=true) 
DISTRIBUTED BY (vendor_id);	


 DROP TABLE IF EXISTS aggregateon_mwbe_contracts_spending_by_month ;
CREATE TABLE aggregateon_mwbe_contracts_spending_by_month(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	month_id integer,
	vendor_id int,
	minority_type_id smallint,
	award_method_id smallint,
	agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	spending_amount numeric(16,2),
	status_flag char(1),
	type_of_year char(1)	
)WITH(appendonly=true) 
DISTRIBUTED BY (vendor_id);	


 DROP TABLE IF EXISTS aggregateon_mwbe_total_contracts ;
CREATE TABLE aggregateon_mwbe_total_contracts(
	fiscal_year smallint,
	fiscal_year_id smallint,
	vendor_id int,
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
)WITH(appendonly=true) 
DISTRIBUTED BY (fiscal_year);	


 DROP TABLE IF EXISTS aggregateon_mwbe_contracts_department ;
CREATE TABLE aggregateon_mwbe_contracts_department(
	document_code_id smallint,
	document_agency_id smallint,
	agency_id smallint,
	department_id integer,
	fiscal_year smallint,
	fiscal_year_id smallint,
	award_method_id smallint,
	vendor_id int,
	minority_type_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	total_contracts integer,
	status_flag char(1),
	type_of_year char(1)
)WITH(appendonly=true)
 DISTRIBUTED BY (department_id);	


 DROP TABLE IF EXISTS contracts_mwbe_spending_transactions ;
CREATE TABLE contracts_mwbe_spending_transactions(
	disbursement_line_item_id bigint,
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	vendor_id int,
	minority_type_id smallint,
	award_method_id smallint,
	document_agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	disb_document_id  character varying(20),
	disb_vendor_name  character varying,
	disb_check_eft_issued_date  date,
	disb_agency_name  character varying(100),
	disb_department_short_name  character varying(15),
	disb_check_amount  numeric(16,2),
	disb_expenditure_object_name  character varying(40),
	disb_budget_name  character varying(60),
	disb_contract_number  character varying,
	disb_purpose  character varying,
	disb_reporting_code  character varying(15),
	disb_spending_category_name  character varying,
	disb_agency_id  smallint,
	disb_vendor_id  integer,
	disb_expenditure_object_id  integer,
	disb_department_id  integer,
	disb_spending_category_id  smallint,
	disb_agreement_id  bigint,
	disb_contract_document_code  character varying(8),
	disb_master_agreement_id  bigint,
	disb_fiscal_year_id  smallint,
	disb_check_eft_issued_cal_month_id integer,
	disb_disbursement_number character varying(40),
	status_flag char(1),
	type_of_year char(1)
)WITH (appendonly=true,orientation=column)
DISTRIBUTED BY (disbursement_line_item_id)
PARTITION BY RANGE (fiscal_year) 
(START (2010) END (2015) EVERY (1),
DEFAULT PARTITION outlying_years);


 DROP TABLE IF EXISTS contract_vendor_latest_mwbe_category ;
CREATE TABLE contract_vendor_latest_mwbe_category (
	vendor_id integer,
	vendor_history_id integer,
	agency_id smallint,
	minority_type_id smallint,
	is_prime_or_sub character(1),
	year_id smallint,
	type_of_year char(1)
	) DISTRIBUTED BY (vendor_id) ;
	

DROP TABLE IF EXISTS spending_vendor_latest_mwbe_category ;
CREATE TABLE spending_vendor_latest_mwbe_category (
	vendor_id integer,
	vendor_history_id integer,
	agency_id smallint,
	minority_type_id smallint,
	is_prime_or_sub character(1),
	year_id smallint,
	type_of_year char(1)
	) DISTRIBUTED BY (vendor_id) ;

-- Indexes

CREATE INDEX idx_agreement_id_disb_line_item_dets ON disbursement_line_item_details(agreement_id); 
CREATE INDEX idx_agency_id_disb_line_item_dets ON disbursement_line_item_details USING btree (agency_id);
CREATE INDEX idx_nyc_year_id_disb_line_item_dets ON disbursement_line_item_details USING btree (check_eft_issued_nyc_year_id);
CREATE INDEX idx_ma_agreement_id_disb_line_item_dets ON disbursement_line_item_details(master_agreement_id);
  
 
 CREATE INDEX idx_orig_agr_id_aggon_mwbe_contracts_cumulative_spending ON aggregateon_mwbe_contracts_cumulative_spending(original_agreement_id);
 
 CREATE INDEX idx_disb_agr_id_cont_mw_spen_trans ON contracts_mwbe_spending_transactions(disb_agreement_id);
 CREATE INDEX idx_fiscal_year_id_cont_mw_spen_trans ON contracts_mwbe_spending_transactions(fiscal_year_id);
 CREATE INDEX idx_disb_fis_year_id_cont_mw_spen_trans ON contracts_mwbe_spending_transactions(disb_fiscal_year_id);
 CREATE INDEX idx_disb_cont_doc_code_cont_mw_spen_trans ON contracts_mwbe_spending_transactions(disb_contract_document_code);
 CREATE INDEX idx_document_agency_id_cont_mw_spen_trans ON contracts_mwbe_spending_transactions(document_agency_id);
 CREATE INDEX idx_disb_cal_month_id_cont_mw_spen_trans ON contracts_mwbe_spending_transactions(disb_check_eft_issued_cal_month_id);
 CREATE INDEX idx_document_code_id_cont_mw_spen_trans ON contracts_mwbe_spending_transactions(document_code_id);
 
 
 SET search_path = staging;
 
DROP VIEW IF EXISTS vendor_min_bus_type;
DROP EXTERNAL WEB TABLE IF EXISTS vendor_min_bus_type__0 ;

CREATE EXTERNAL WEB TABLE vendor_min_bus_type__0 (
	vendor_id integer,
  vendor_history_id integer,
  business_type_id smallint,
  minority_type_id smallint,
  business_type_code character varying,
  business_type_name character varying,
  minority_type_name character varying
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.vendor_min_bus_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

CREATE VIEW vendor_min_bus_type AS
    SELECT vendor_min_bus_type__0.vendor_id, vendor_min_bus_type__0.vendor_history_id, vendor_min_bus_type__0.business_type_id, vendor_min_bus_type__0.minority_type_id, 
    vendor_min_bus_type__0.business_type_code, vendor_min_bus_type__0.business_type_name, vendor_min_bus_type__0.minority_type_name
    FROM ONLY vendor_min_bus_type__0;
    


DROP VIEW IF EXISTS agreement_snapshot;
DROP EXTERNAL WEB TABLE IF EXISTS agreement_snapshot__0 ;

CREATE EXTERNAL WEB TABLE agreement_snapshot__0(
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
	   original_contract_amount numeric(16,2),
	   maximum_contract_amount numeric(16,2),	   
	   description character varying,
	   vendor_history_id integer,
	   vendor_id integer,
	   vendor_code character varying(20),
	   vendor_name character varying,
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
 	   minority_type_name character varying,
	   master_agreement_yn character(1),
	   has_children character(1),
	   original_version_flag character(1),
   	   latest_flag character(1),
   	  load_id integer,
      last_modified_date timestamp without time zone,
      job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement_snapshot to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW agreement_snapshot AS
  	SELECT agreement_snapshot__0.original_agreement_id,agreement_snapshot__0.document_version,agreement_snapshot__0.document_code_id,
  		agreement_snapshot__0.agency_history_id,agreement_snapshot__0.agency_id,agreement_snapshot__0.agency_code,agreement_snapshot__0.agency_name,
  		agreement_snapshot__0.agreement_id,agreement_snapshot__0.starting_year,agreement_snapshot__0.starting_year_id,agreement_snapshot__0.ending_year,
  		agreement_snapshot__0.ending_year_id,agreement_snapshot__0.registered_year,agreement_snapshot__0.registered_year_id,agreement_snapshot__0.contract_number,
  		agreement_snapshot__0.original_contract_amount,agreement_snapshot__0.maximum_contract_amount,agreement_snapshot__0.description,
  		agreement_snapshot__0.vendor_history_id,agreement_snapshot__0.vendor_id,agreement_snapshot__0.vendor_code,agreement_snapshot__0.vendor_name,
  		agreement_snapshot__0.dollar_difference,agreement_snapshot__0.percent_difference,agreement_snapshot__0.master_agreement_id,agreement_snapshot__0.master_contract_number,
  		agreement_snapshot__0.agreement_type_id,agreement_snapshot__0.agreement_type_code,agreement_snapshot__0.agreement_type_name,agreement_snapshot__0.award_category_id,agreement_snapshot__0.award_category_code,
  		agreement_snapshot__0.award_category_name,agreement_snapshot__0.award_method_id,agreement_snapshot__0.award_method_code,agreement_snapshot__0.award_method_name,
  		agreement_snapshot__0.expenditure_object_codes,agreement_snapshot__0.expenditure_object_names,agreement_snapshot__0.industry_type_id,agreement_snapshot__0.industry_type_name,agreement_snapshot__0.award_size_id,
  		agreement_snapshot__0.effective_begin_date,agreement_snapshot__0.effective_begin_date_id,
  		agreement_snapshot__0.effective_begin_year,agreement_snapshot__0.effective_begin_year_id,agreement_snapshot__0.effective_end_date,
  		agreement_snapshot__0.effective_end_date_id,agreement_snapshot__0.effective_end_year,agreement_snapshot__0.effective_end_year_id,
  		agreement_snapshot__0.registered_date,agreement_snapshot__0.registered_date_id,agreement_snapshot__0.brd_awd_no,agreement_snapshot__0.tracking_number,agreement_snapshot__0.rfed_amount,
  		agreement_snapshot__0.minority_type_id,agreement_snapshot__0.minority_type_name,
  		agreement_snapshot__0.master_agreement_yn,agreement_snapshot__0.has_children,agreement_snapshot__0.original_version_flag,agreement_snapshot__0.latest_flag,
  		agreement_snapshot__0.load_id,agreement_snapshot__0.last_modified_date,agreement_snapshot__0.job_id
  	FROM  agreement_snapshot__0;


DROP VIEW IF EXISTS agreement_snapshot_cy;
DROP EXTERNAL WEB TABLE IF EXISTS agreement_snapshot_cy__0 ;	

CREATE EXTERNAL WEB TABLE agreement_snapshot_cy__0(
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
	  original_contract_amount numeric(16,2),
	  maximum_contract_amount numeric(16,2),
	  description character varying,
	  vendor_history_id integer,
	  vendor_id integer,
	  vendor_code character varying(20),
	  vendor_name character varying,
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
	  award_method_code character varying(10),
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
 	minority_type_name character varying,
	  master_agreement_yn character(1),
	  has_children character(1),
	  original_version_flag character(1),
  	  latest_flag character(1),
  	  load_id integer,
      last_modified_date timestamp without time zone,
      job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement_snapshot_cy to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW agreement_snapshot_cy AS
  	SELECT agreement_snapshot_cy__0.original_agreement_id,agreement_snapshot_cy__0.document_version,agreement_snapshot_cy__0.document_code_id,
  		agreement_snapshot_cy__0.agency_history_id,agreement_snapshot_cy__0.agency_id,agreement_snapshot_cy__0.agency_code,agreement_snapshot_cy__0.agency_name,
  		agreement_snapshot_cy__0.agreement_id,agreement_snapshot_cy__0.starting_year,agreement_snapshot_cy__0.starting_year_id,agreement_snapshot_cy__0.ending_year,
  		agreement_snapshot_cy__0.ending_year_id,agreement_snapshot_cy__0.registered_year,agreement_snapshot_cy__0.registered_year_id,agreement_snapshot_cy__0.contract_number,
  		agreement_snapshot_cy__0.original_contract_amount,agreement_snapshot_cy__0.maximum_contract_amount,agreement_snapshot_cy__0.description,
  		agreement_snapshot_cy__0.vendor_history_id,agreement_snapshot_cy__0.vendor_id,agreement_snapshot_cy__0.vendor_code,agreement_snapshot_cy__0.vendor_name,
  		agreement_snapshot_cy__0.dollar_difference,agreement_snapshot_cy__0.percent_difference,agreement_snapshot_cy__0.master_agreement_id,agreement_snapshot_cy__0.master_contract_number,
  		agreement_snapshot_cy__0.agreement_type_id,agreement_snapshot_cy__0.agreement_type_code,agreement_snapshot_cy__0.agreement_type_name,agreement_snapshot_cy__0.award_category_id,agreement_snapshot_cy__0.award_category_code,
  		agreement_snapshot_cy__0.award_category_name,agreement_snapshot_cy__0.award_method_id,agreement_snapshot_cy__0.award_method_code,agreement_snapshot_cy__0.award_method_name,
   		agreement_snapshot_cy__0.expenditure_object_codes,agreement_snapshot_cy__0.expenditure_object_names,agreement_snapshot_cy__0.industry_type_id,agreement_snapshot_cy__0.industry_type_name,agreement_snapshot_cy__0.award_size_id,
   		agreement_snapshot_cy__0.effective_begin_date,agreement_snapshot_cy__0.effective_begin_date_id,
  		agreement_snapshot_cy__0.effective_begin_year,agreement_snapshot_cy__0.effective_begin_year_id,agreement_snapshot_cy__0.effective_end_date,
  		agreement_snapshot_cy__0.effective_end_date_id,agreement_snapshot_cy__0.effective_end_year,agreement_snapshot_cy__0.effective_end_year_id,
  		agreement_snapshot_cy__0.registered_date,agreement_snapshot_cy__0.registered_date_id,agreement_snapshot_cy__0.brd_awd_no,agreement_snapshot_cy__0.tracking_number,agreement_snapshot_cy__0.rfed_amount,
  		agreement_snapshot_cy__0.minority_type_id,agreement_snapshot_cy__0.minority_type_name,
  		agreement_snapshot_cy__0.master_agreement_yn,agreement_snapshot_cy__0.has_children,agreement_snapshot_cy__0.original_version_flag,agreement_snapshot_cy__0.latest_flag,
  		agreement_snapshot_cy__0.load_id,agreement_snapshot_cy__0.last_modified_date,agreement_snapshot_cy__0.job_id
  	FROM  agreement_snapshot_cy__0;  



DROP VIEW IF EXISTS agreement_snapshot_expanded;
DROP EXTERNAL WEB TABLE IF EXISTS agreement_snapshot_expanded__0 ;	

CREATE EXTERNAL WEB TABLE agreement_snapshot_expanded__0(
 	original_agreement_id bigint,
 	agreement_id bigint,
 	fiscal_year smallint,
 	description varchar,
 	contract_number varchar,
 	vendor_id int,
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
 	master_agreement_id bigint,
 	minority_type_id smallint,
 	minority_type_name character varying,
 	master_agreement_yn character(1),
 	status_flag char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement_snapshot_expanded to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';

CREATE VIEW agreement_snapshot_expanded AS
	 SELECT agreement_snapshot_expanded__0.original_agreement_id,agreement_snapshot_expanded__0.agreement_id,agreement_snapshot_expanded__0.fiscal_year,agreement_snapshot_expanded__0.description,
	 	agreement_snapshot_expanded__0.contract_number,agreement_snapshot_expanded__0.vendor_id,agreement_snapshot_expanded__0.agency_id,agreement_snapshot_expanded__0.industry_type_id,agreement_snapshot_expanded__0.award_size_id,
	 	agreement_snapshot_expanded__0.original_contract_amount,agreement_snapshot_expanded__0.maximum_contract_amount,agreement_snapshot_expanded__0.rfed_amount,
	 	agreement_snapshot_expanded__0.starting_year,agreement_snapshot_expanded__0.ending_year,agreement_snapshot_expanded__0.dollar_difference,
	 	agreement_snapshot_expanded__0.percent_difference,agreement_snapshot_expanded__0.award_method_id,agreement_snapshot_expanded__0.document_code_id,
	 	agreement_snapshot_expanded__0.master_agreement_id,agreement_snapshot_expanded__0.minority_type_id,agreement_snapshot_expanded__0.minority_type_name,
	 	agreement_snapshot_expanded__0.master_agreement_yn,agreement_snapshot_expanded__0.status_flag
	 FROM 	agreement_snapshot_expanded__0;


DROP VIEW IF EXISTS agreement_snapshot_expanded_cy;
DROP EXTERNAL WEB TABLE IF EXISTS agreement_snapshot_expanded_cy__0 ;	

CREATE EXTERNAL WEB TABLE agreement_snapshot_expanded_cy__0(
	original_agreement_id bigint,
	agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	vendor_id int,
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
	master_agreement_id bigint,
	minority_type_id smallint,
 	minority_type_name character varying,
	master_agreement_yn character(1),
	status_flag char(1)
	)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement_snapshot_expanded_cy to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';	 
  
  CREATE VIEW agreement_snapshot_expanded_cy AS
  	SELECT agreement_snapshot_expanded_cy__0.original_agreement_id,agreement_snapshot_expanded_cy__0.agreement_id,agreement_snapshot_expanded_cy__0.fiscal_year,agreement_snapshot_expanded_cy__0.description,
  		agreement_snapshot_expanded_cy__0.contract_number,agreement_snapshot_expanded_cy__0.vendor_id,agreement_snapshot_expanded_cy__0.agency_id,agreement_snapshot_expanded_cy__0.industry_type_id,agreement_snapshot_expanded_cy__0.award_size_id,
  		agreement_snapshot_expanded_cy__0.original_contract_amount,agreement_snapshot_expanded_cy__0.maximum_contract_amount,agreement_snapshot_expanded_cy__0.rfed_amount,
  		agreement_snapshot_expanded_cy__0.starting_year,agreement_snapshot_expanded_cy__0.ending_year,agreement_snapshot_expanded_cy__0.dollar_difference,
  		agreement_snapshot_expanded_cy__0.percent_difference,agreement_snapshot_expanded_cy__0.award_method_id,agreement_snapshot_expanded_cy__0.document_code_id,
  		agreement_snapshot_expanded_cy__0.master_agreement_id,agreement_snapshot_expanded_cy__0.minority_type_id,agreement_snapshot_expanded_cy__0.minority_type_name,
  		agreement_snapshot_expanded_cy__0.master_agreement_yn,agreement_snapshot_expanded_cy__0.status_flag
  	FROM agreement_snapshot_expanded_cy__0;	
 
 
 
 DROP VIEW IF EXISTS disbursement_line_item_details;
DROP EXTERNAL WEB TABLE IF EXISTS disbursement_line_item_details__0 ;	

 CREATE EXTERNAL WEB TABLE disbursement_line_item_details__0 (
    disbursement_line_item_id bigint,
	disbursement_id integer,
	line_number integer,
	disbursement_number character varying(40),
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
	master_contract_number character varying,
	master_child_contract_number character varying,
  	contract_vendor_id integer,
  	contract_vendor_id_cy integer,
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
 	minority_type_name character varying,
 	industry_type_id smallint,
   	industry_type_name character varying,
   	agreement_type_code character varying,
   	award_method_code character varying,
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
	job_id bigint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.disbursement_line_item_details to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';



CREATE VIEW disbursement_line_item_details AS
    SELECT disbursement_line_item_details__0.disbursement_line_item_id, disbursement_line_item_details__0.disbursement_id, disbursement_line_item_details__0.line_number,
    disbursement_line_item_details__0.disbursement_number ,disbursement_line_item_details__0.check_eft_issued_date_id, 
    disbursement_line_item_details__0.check_eft_issued_nyc_year_id, disbursement_line_item_details__0.fiscal_year, disbursement_line_item_details__0.check_eft_issued_cal_month_id, disbursement_line_item_details__0.agreement_id,
    disbursement_line_item_details__0.master_agreement_id, disbursement_line_item_details__0.fund_class_id, disbursement_line_item_details__0.check_amount, disbursement_line_item_details__0.agency_id,
    disbursement_line_item_details__0.agency_history_id,disbursement_line_item_details__0.agency_code, disbursement_line_item_details__0.expenditure_object_id, disbursement_line_item_details__0.vendor_id, 
    disbursement_line_item_details__0.department_id,disbursement_line_item_details__0.maximum_contract_amount, disbursement_line_item_details__0.maximum_contract_amount_cy,
    disbursement_line_item_details__0.maximum_spending_limit,disbursement_line_item_details__0.maximum_spending_limit_cy,
    disbursement_line_item_details__0.document_id, disbursement_line_item_details__0.vendor_name,disbursement_line_item_details__0.vendor_customer_code, disbursement_line_item_details__0.check_eft_issued_date, 
    disbursement_line_item_details__0.agency_name,disbursement_line_item_details__0.agency_short_name,
    disbursement_line_item_details__0.location_name,disbursement_line_item_details__0.location_code, disbursement_line_item_details__0.department_name,
    disbursement_line_item_details__0.department_short_name,disbursement_line_item_details__0.department_code, disbursement_line_item_details__0.expenditure_object_name,disbursement_line_item_details__0.expenditure_object_code, 
    disbursement_line_item_details__0.budget_code_id,disbursement_line_item_details__0.budget_code,
    disbursement_line_item_details__0.budget_name, disbursement_line_item_details__0.contract_number,  disbursement_line_item_details__0.master_contract_number,disbursement_line_item_details__0.master_child_contract_number,
    disbursement_line_item_details__0.contract_vendor_id,disbursement_line_item_details__0.contract_vendor_id_cy,disbursement_line_item_details__0.master_contract_vendor_id,
    disbursement_line_item_details__0.master_contract_vendor_id_cy,disbursement_line_item_details__0.contract_agency_id,disbursement_line_item_details__0.contract_agency_id_cy,
    disbursement_line_item_details__0.master_contract_agency_id,disbursement_line_item_details__0.master_contract_agency_id_cy,disbursement_line_item_details__0.master_purpose,
    disbursement_line_item_details__0.master_purpose_cy, disbursement_line_item_details__0.purpose,disbursement_line_item_details__0.purpose_cy,
    disbursement_line_item_details__0.master_child_contract_agency_id, disbursement_line_item_details__0.master_child_contract_agency_id_cy,disbursement_line_item_details__0.master_child_contract_vendor_id,disbursement_line_item_details__0.master_child_contract_vendor_id_cy,
    disbursement_line_item_details__0.reporting_code,disbursement_line_item_details__0.location_id,disbursement_line_item_details__0.fund_class_name,disbursement_line_item_details__0.fund_class_code,
    disbursement_line_item_details__0.spending_category_id,disbursement_line_item_details__0.spending_category_name,disbursement_line_item_details__0.calendar_fiscal_year_id,disbursement_line_item_details__0.calendar_fiscal_year,
    disbursement_line_item_details__0.agreement_accounting_line_number, disbursement_line_item_details__0.agreement_commodity_line_number, disbursement_line_item_details__0.agreement_vendor_line_number, 
    disbursement_line_item_details__0.reference_document_number,disbursement_line_item_details__0.reference_document_code,disbursement_line_item_details__0.contract_document_code,
    disbursement_line_item_details__0.master_contract_document_code, 
    disbursement_line_item_details__0.minority_type_id,disbursement_line_item_details__0.minority_type_name,disbursement_line_item_details__0.industry_type_id,
    disbursement_line_item_details__0.industry_type_name,disbursement_line_item_details__0.agreement_type_code,disbursement_line_item_details__0.award_method_code,
    disbursement_line_item_details__0.contract_industry_type_id,disbursement_line_item_details__0.contract_industry_type_id_cy,disbursement_line_item_details__0.master_contract_industry_type_id,
    disbursement_line_item_details__0.master_contract_industry_type_id_cy,disbursement_line_item_details__0.contract_minority_type_id,disbursement_line_item_details__0.contract_minority_type_id_cy,
    disbursement_line_item_details__0.master_contract_minority_type_id,disbursement_line_item_details__0.master_contract_minority_type_id_cy,
    disbursement_line_item_details__0.file_type,disbursement_line_item_details__0.load_id, disbursement_line_item_details__0.last_modified_date, disbursement_line_item_details__0.job_id
FROM ONLY disbursement_line_item_details__0;



 DROP VIEW IF EXISTS pending_contracts;
DROP EXTERNAL WEB TABLE IF EXISTS pending_contracts__0 ;	

CREATE EXTERNAL WEB TABLE pending_contracts__0(
 	document_code_id smallint,
 	document_agency_id  smallint,
 	document_id  varchar,
  	parent_document_code_id smallint,
  	parent_document_agency_id  smallint,
 	parent_document_id  varchar,
 	encumbrance_amount_original numeric(15,2),
 	encumbrance_amount numeric(15,2),
 	original_maximum_amount_original numeric(15,2),
 	original_maximum_amount numeric(15,2),
 	revised_maximum_amount_original numeric(15,2),
 	revised_maximum_amount numeric(15,2),
 	registered_contract_max_amount numeric(15,2),
 	vendor_legal_name varchar(80),
 	vendor_customer_code varchar(20),
 	vendor_id int,
 	description varchar(78),
 	submitting_agency_id  smallint,
 	oaisis_submitting_agency_desc	 varchar(50),
 	submitting_agency_code	 varchar(4),
 	awarding_agency_id  smallint,
 	oaisis_awarding_agency_desc	 varchar(50),
 	awarding_agency_code	 varchar(4),
 	contract_type_name varchar(40),
 	cont_type_code  varchar(2),
 	award_method_name varchar(50),
 	award_method_code varchar(3),
 	award_method_id smallint,
 	start_date date,
 	end_date date,
 	revised_start_date date,
 	revised_end_date date,
 	cif_received_date date,
 	cif_fiscal_year smallint,
 	cif_fiscal_year_id smallint,
 	tracking_number varchar(30),
 	board_award_number varchar(15),
 	oca_number varchar(10),
	version_number varchar(5),
	fms_contract_number varchar,
	contract_number varchar,
	fms_parent_contract_number varchar,
	submitting_agency_name varchar,
	submitting_agency_short_name varchar,
	awarding_agency_name varchar,
	awarding_agency_short_name varchar,
	start_date_id int,
	end_date_id int,	
	revised_start_date_id int,
	revised_end_date_id int,	
	cif_received_date_id int,
	document_agency_code varchar, 
	document_agency_name varchar, 
	document_agency_short_name varchar ,
	funding_agency_id  smallint,
	funding_agency_code varchar, 
	funding_agency_name varchar, 
	funding_agency_short_name varchar ,
	original_agreement_id bigint,
	original_master_agreement_id bigint,
	dollar_difference numeric(16,2),
  	percent_difference numeric(17,4),
  	original_or_modified varchar,
  	original_or_modified_desc varchar,
  	award_size_id smallint,
  	award_category_id smallint,
  	industry_type_id smallint,
  	document_version smallint,
  	minority_type_id smallint,
 	minority_type_name character varying,
 	  is_prime_or_sub character(1),
  is_minority_vendor character(1),
  vendor_type character(2),
  	latest_flag char(1)
	
 )
 EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.pending_contracts to stdout csv"' ON SEGMENT 0 
      FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
   ENCODING 'UTF8';
   

 
 CREATE VIEW pending_contracts AS 
 	SELECT pending_contracts__0.document_code_id,pending_contracts__0.document_agency_id,pending_contracts__0.document_id,
 		pending_contracts__0.parent_document_code_id,pending_contracts__0.parent_document_agency_id,pending_contracts__0.parent_document_id,
 		pending_contracts__0.encumbrance_amount_original,pending_contracts__0.encumbrance_amount,pending_contracts__0.original_maximum_amount_original,
 		pending_contracts__0.original_maximum_amount,pending_contracts__0.revised_maximum_amount_original,pending_contracts__0.revised_maximum_amount,pending_contracts__0.registered_contract_max_amount,
 		pending_contracts__0.vendor_legal_name,pending_contracts__0.vendor_customer_code,pending_contracts__0.vendor_id,pending_contracts__0.description,
 		pending_contracts__0.submitting_agency_id,pending_contracts__0.oaisis_submitting_agency_desc,pending_contracts__0.submitting_agency_code,
 		pending_contracts__0.awarding_agency_id,pending_contracts__0.oaisis_awarding_agency_desc,pending_contracts__0.awarding_agency_code,
 		pending_contracts__0.contract_type_name,pending_contracts__0.cont_type_code,pending_contracts__0.award_method_name,pending_contracts__0.award_method_code,pending_contracts__0.award_method_id,
 		pending_contracts__0.start_date,pending_contracts__0.end_date,pending_contracts__0.revised_start_date,pending_contracts__0.revised_end_date,
 		pending_contracts__0.cif_received_date,pending_contracts__0.cif_fiscal_year,pending_contracts__0.cif_fiscal_year_id,
 		pending_contracts__0.tracking_number,pending_contracts__0.board_award_number,pending_contracts__0.oca_number,
 		pending_contracts__0.version_number,pending_contracts__0.fms_contract_number,pending_contracts__0.contract_number,pending_contracts__0.fms_parent_contract_number,
 		pending_contracts__0.submitting_agency_name,pending_contracts__0.submitting_agency_short_name,pending_contracts__0.awarding_agency_name,
 		pending_contracts__0.awarding_agency_short_name,pending_contracts__0.start_date_id,pending_contracts__0.end_date_id,
 		pending_contracts__0.revised_start_date_id,pending_contracts__0.revised_end_date_id,pending_contracts__0.cif_received_date_id,
 		pending_contracts__0.document_agency_code,pending_contracts__0.document_agency_name,pending_contracts__0.document_agency_short_name, 		
 		pending_contracts__0.funding_agency_id,pending_contracts__0.funding_agency_code,pending_contracts__0.funding_agency_name,
 		pending_contracts__0.funding_agency_short_name,pending_contracts__0.original_agreement_id,pending_contracts__0.original_master_agreement_id,pending_contracts__0.dollar_difference,
 		pending_contracts__0.percent_difference, pending_contracts__0.original_or_modified, pending_contracts__0.original_or_modified_desc, pending_contracts__0.award_size_id, 
 		pending_contracts__0.award_category_id, pending_contracts__0.industry_type_id, pending_contracts__0.document_version,	
 		pending_contracts__0.minority_type_id, pending_contracts__0.minority_type_name, 
 		pending_contracts__0.is_prime_or_sub, pending_contracts__0.is_minority_vendor, pending_contracts__0.vendor_type, pending_contracts__0.latest_flag 		
 	FROM pending_contracts__0;
 	
 	

DROP VIEW IF EXISTS aggregateon_mwbe_spending_coa_entities;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_mwbe_spending_coa_entities__0 ;
	
CREATE EXTERNAL WEB TABLE aggregateon_mwbe_spending_coa_entities__0 (
    department_id integer,
    agency_id smallint,
    spending_category_id smallint,
    expenditure_object_id integer,
    vendor_id integer,
    minority_type_id smallint,
	industry_type_id smallint,
    month_id int,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric,
    total_disbursements integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_spending_coa_entities to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


CREATE VIEW aggregateon_mwbe_spending_coa_entities AS
    SELECT aggregateon_mwbe_spending_coa_entities__0.department_id, aggregateon_mwbe_spending_coa_entities__0.agency_id, aggregateon_mwbe_spending_coa_entities__0.spending_category_id, 
    	aggregateon_mwbe_spending_coa_entities__0.expenditure_object_id, aggregateon_mwbe_spending_coa_entities__0.vendor_id,
    	aggregateon_mwbe_spending_coa_entities__0.minority_type_id, aggregateon_mwbe_spending_coa_entities__0.industry_type_id, 
    	aggregateon_mwbe_spending_coa_entities__0.month_id, aggregateon_mwbe_spending_coa_entities__0.year_id, 
    	aggregateon_mwbe_spending_coa_entities__0.type_of_year, 	aggregateon_mwbe_spending_coa_entities__0.total_spending_amount,aggregateon_mwbe_spending_coa_entities__0.total_disbursements FROM ONLY aggregateon_mwbe_spending_coa_entities__0;


 DROP VIEW IF EXISTS aggregateon_mwbe_spending_contract;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_mwbe_spending_contract__0 ;

CREATE EXTERNAL WEB TABLE aggregateon_mwbe_spending_contract__0 (
    agreement_id bigint,
    document_id character varying,
    document_code character varying,
    vendor_id integer,
    minority_type_id smallint,
	industry_type_id smallint,
    agency_id smallint,
    description character varying,
    spending_category_id smallint,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric,
    total_contract_amount numeric
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_spending_contract to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';



CREATE VIEW aggregateon_mwbe_spending_contract AS
    SELECT aggregateon_mwbe_spending_contract__0.agreement_id, aggregateon_mwbe_spending_contract__0.document_id, aggregateon_mwbe_spending_contract__0.document_code,aggregateon_mwbe_spending_contract__0.vendor_id, 
    aggregateon_mwbe_spending_contract__0.minority_type_id, aggregateon_mwbe_spending_contract__0.industry_type_id,
    aggregateon_mwbe_spending_contract__0.agency_id, aggregateon_mwbe_spending_contract__0.description, aggregateon_mwbe_spending_contract__0.spending_category_id, aggregateon_mwbe_spending_contract__0.year_id,aggregateon_mwbe_spending_contract__0.type_of_year, 
    aggregateon_mwbe_spending_contract__0.total_spending_amount, aggregateon_mwbe_spending_contract__0.total_contract_amount FROM ONLY aggregateon_mwbe_spending_contract__0;


 DROP VIEW IF EXISTS aggregateon_mwbe_spending_vendor;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_mwbe_spending_vendor__0 ;

CREATE EXTERNAL WEB TABLE aggregateon_mwbe_spending_vendor__0 (
    vendor_id integer,
    minority_type_id smallint,
	industry_type_id smallint,
    agency_id smallint,
    spending_category_id smallint,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric,
    total_contract_amount numeric,
    is_all_categories char(1)
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_spending_vendor to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


CREATE VIEW aggregateon_mwbe_spending_vendor AS
    SELECT aggregateon_mwbe_spending_vendor__0.vendor_id, 
    aggregateon_mwbe_spending_vendor__0.minority_type_id, aggregateon_mwbe_spending_vendor__0.industry_type_id,
    aggregateon_mwbe_spending_vendor__0.agency_id, aggregateon_mwbe_spending_vendor__0.spending_category_id, aggregateon_mwbe_spending_vendor__0.year_id,
    aggregateon_mwbe_spending_vendor__0.type_of_year, aggregateon_mwbe_spending_vendor__0.total_spending_amount, aggregateon_mwbe_spending_vendor__0.total_contract_amount, aggregateon_mwbe_spending_vendor__0.is_all_categories FROM ONLY aggregateon_mwbe_spending_vendor__0;



 DROP VIEW IF EXISTS aggregateon_mwbe_spending_vendor_exp_object;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_mwbe_spending_vendor_exp_object__0 ;

CREATE EXTERNAL WEB TABLE aggregateon_mwbe_spending_vendor_exp_object__0(
	vendor_id integer,
	minority_type_id smallint,
	industry_type_id smallint,
	expenditure_object_id integer,
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2) 
)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_spending_vendor_exp_object to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

CREATE VIEW aggregateon_mwbe_spending_vendor_exp_object AS
	SELECT aggregateon_mwbe_spending_vendor_exp_object__0.vendor_id, 
	aggregateon_mwbe_spending_vendor_exp_object__0.minority_type_id, aggregateon_mwbe_spending_vendor_exp_object__0.industry_type_id,
	aggregateon_mwbe_spending_vendor_exp_object__0.expenditure_object_id, aggregateon_mwbe_spending_vendor_exp_object__0.spending_category_id,
		aggregateon_mwbe_spending_vendor_exp_object__0.year_id ,aggregateon_mwbe_spending_vendor_exp_object__0.type_of_year ,
		aggregateon_mwbe_spending_vendor_exp_object__0.total_spending_amount FROM aggregateon_mwbe_spending_vendor_exp_object__0;
		
		

 DROP VIEW IF EXISTS aggregateon_mwbe_contracts_cumulative_spending;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_mwbe_contracts_cumulative_spending__0 ;

CREATE EXTERNAL WEB TABLE aggregateon_mwbe_contracts_cumulative_spending__0(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	master_agreement_yn character(1),
	description varchar,
	contract_number varchar,
	vendor_id int,
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
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_contracts_cumulative_spending to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';	 
  
  CREATE VIEW aggregateon_mwbe_contracts_cumulative_spending AS
  	SELECT aggregateon_mwbe_contracts_cumulative_spending__0.original_agreement_id,aggregateon_mwbe_contracts_cumulative_spending__0.fiscal_year,
  	aggregateon_mwbe_contracts_cumulative_spending__0.fiscal_year_id,
  		aggregateon_mwbe_contracts_cumulative_spending__0.document_code_id,aggregateon_mwbe_contracts_cumulative_spending__0.master_agreement_yn,
  		aggregateon_mwbe_contracts_cumulative_spending__0.description,aggregateon_mwbe_contracts_cumulative_spending__0.contract_number,
  		aggregateon_mwbe_contracts_cumulative_spending__0.vendor_id,aggregateon_mwbe_contracts_cumulative_spending__0.minority_type_id,aggregateon_mwbe_contracts_cumulative_spending__0.award_method_id,
  		aggregateon_mwbe_contracts_cumulative_spending__0.agency_id,aggregateon_mwbe_contracts_cumulative_spending__0.industry_type_id,aggregateon_mwbe_contracts_cumulative_spending__0.award_size_id,
  		aggregateon_mwbe_contracts_cumulative_spending__0.original_contract_amount,aggregateon_mwbe_contracts_cumulative_spending__0.maximum_contract_amount,aggregateon_mwbe_contracts_cumulative_spending__0.spending_amount_disb,
  		aggregateon_mwbe_contracts_cumulative_spending__0.spending_amount,aggregateon_mwbe_contracts_cumulative_spending__0.current_year_spending_amount,
  		aggregateon_mwbe_contracts_cumulative_spending__0.dollar_difference,aggregateon_mwbe_contracts_cumulative_spending__0.percent_difference,
  		aggregateon_mwbe_contracts_cumulative_spending__0.status_flag,aggregateon_mwbe_contracts_cumulative_spending__0.type_of_year
  	FROM 	  aggregateon_mwbe_contracts_cumulative_spending__0;
 
 
 
  DROP VIEW IF EXISTS aggregateon_mwbe_contracts_spending_by_month;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_mwbe_contracts_spending_by_month__0 ;
 	
  CREATE EXTERNAL WEB TABLE aggregateon_mwbe_contracts_spending_by_month__0
  (
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	month_id integer,
	vendor_id int,
	minority_type_id smallint,
	award_method_id smallint,
	agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	spending_amount numeric(16,2),
	status_flag char(1),
	type_of_year char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_contracts_spending_by_month to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW aggregateon_mwbe_contracts_spending_by_month AS
  	SELECT aggregateon_mwbe_contracts_spending_by_month__0.original_agreement_id,aggregateon_mwbe_contracts_spending_by_month__0.fiscal_year,aggregateon_mwbe_contracts_spending_by_month__0.fiscal_year_id,
  		aggregateon_mwbe_contracts_spending_by_month__0.document_code_id,aggregateon_mwbe_contracts_spending_by_month__0.month_id,
  		aggregateon_mwbe_contracts_spending_by_month__0.vendor_id,aggregateon_mwbe_contracts_spending_by_month__0.minority_type_id,aggregateon_mwbe_contracts_spending_by_month__0.award_method_id,
  		aggregateon_mwbe_contracts_spending_by_month__0.agency_id,aggregateon_mwbe_contracts_spending_by_month__0.industry_type_id, aggregateon_mwbe_contracts_spending_by_month__0.award_size_id,
  		aggregateon_mwbe_contracts_spending_by_month__0.spending_amount,	aggregateon_mwbe_contracts_spending_by_month__0.status_flag,aggregateon_mwbe_contracts_spending_by_month__0.type_of_year
  	FROM  aggregateon_mwbe_contracts_spending_by_month__0;
 
 
 
  DROP VIEW IF EXISTS aggregateon_mwbe_total_contracts;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_mwbe_total_contracts__0 ;
 	
 CREATE EXTERNAL WEB TABLE aggregateon_mwbe_total_contracts__0
(
	fiscal_year smallint,
	fiscal_year_id smallint,
	vendor_id int,
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
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_total_contracts to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
 
 

 
  CREATE VIEW aggregateon_mwbe_total_contracts AS
  	SELECT aggregateon_mwbe_total_contracts__0.fiscal_year,aggregateon_mwbe_total_contracts__0.fiscal_year_id,aggregateon_mwbe_total_contracts__0.vendor_id, aggregateon_mwbe_total_contracts__0.minority_type_id,
  	aggregateon_mwbe_total_contracts__0.award_method_id,  	aggregateon_mwbe_total_contracts__0.agency_id, aggregateon_mwbe_total_contracts__0.industry_type_id, aggregateon_mwbe_total_contracts__0.award_size_id,
  	aggregateon_mwbe_total_contracts__0.total_contracts,aggregateon_mwbe_total_contracts__0.total_commited_contracts,	aggregateon_mwbe_total_contracts__0.total_master_agreements,
  	aggregateon_mwbe_total_contracts__0.total_standalone_contracts,aggregateon_mwbe_total_contracts__0.total_revenue_contracts,aggregateon_mwbe_total_contracts__0.total_revenue_contracts_amount,
  	aggregateon_mwbe_total_contracts__0.total_commited_contracts_amount,aggregateon_mwbe_total_contracts__0.total_contracts_amount,aggregateon_mwbe_total_contracts__0.total_spending_amount_disb,
  	aggregateon_mwbe_total_contracts__0.total_spending_amount,aggregateon_mwbe_total_contracts__0.status_flag,aggregateon_mwbe_total_contracts__0.type_of_year
  	FROM   aggregateon_mwbe_total_contracts__0;
 
  	
  	 
  DROP VIEW IF EXISTS aggregateon_mwbe_contracts_department;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_mwbe_contracts_department__0 ;

 CREATE EXTERNAL WEB TABLE aggregateon_mwbe_contracts_department__0(
 	document_code_id smallint,
 	document_agency_id smallint,
	agency_id smallint,
	department_id integer,
	fiscal_year smallint,
	fiscal_year_id smallint,
	award_method_id smallint,
	vendor_id int,
	minority_type_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	total_contracts integer,
	status_flag char(1),
	type_of_year char(1)
) 	
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_contracts_department to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  


  CREATE VIEW aggregateon_mwbe_contracts_department AS
  	SELECT aggregateon_mwbe_contracts_department__0.document_code_id,aggregateon_mwbe_contracts_department__0.document_agency_id,aggregateon_mwbe_contracts_department__0.agency_id,aggregateon_mwbe_contracts_department__0.department_id,aggregateon_mwbe_contracts_department__0.fiscal_year,
  	aggregateon_mwbe_contracts_department__0.fiscal_year_id,aggregateon_mwbe_contracts_department__0.award_method_id,aggregateon_mwbe_contracts_department__0.vendor_id,
  	aggregateon_mwbe_contracts_department__0.minority_type_id,aggregateon_mwbe_contracts_department__0.industry_type_id, aggregateon_mwbe_contracts_department__0.award_size_id,
  	aggregateon_mwbe_contracts_department__0.spending_amount_disb,aggregateon_mwbe_contracts_department__0.spending_amount,aggregateon_mwbe_contracts_department__0.total_contracts,aggregateon_mwbe_contracts_department__0.status_flag,aggregateon_mwbe_contracts_department__0.type_of_year
  	FROM   aggregateon_mwbe_contracts_department__0;
  	
  	
  	
   DROP VIEW IF EXISTS contracts_mwbe_spending_transactions;
DROP EXTERNAL WEB TABLE IF EXISTS contracts_mwbe_spending_transactions__0 ;
	
   CREATE EXTERNAL WEB TABLE contracts_mwbe_spending_transactions__0(
 	disbursement_line_item_id bigint,
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	vendor_id int,
	minority_type_id smallint,
	award_method_id smallint,
	document_agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	disb_document_id  character varying(20),
	disb_vendor_name  character varying,
	disb_check_eft_issued_date  date,
	disb_agency_name  character varying(100),
	disb_department_short_name  character varying(15),
	disb_check_amount  numeric(16,2),
	disb_expenditure_object_name  character varying(40),
	disb_budget_name  character varying(60),
	disb_contract_number  character varying,
	disb_purpose  character varying,
	disb_reporting_code  character varying(15),
	disb_spending_category_name  character varying,
	disb_agency_id  smallint,
	disb_vendor_id  integer,
	disb_expenditure_object_id  integer,
	disb_department_id  integer,
	disb_spending_category_id  smallint,
	disb_agreement_id  bigint,
	disb_contract_document_code  character varying(8),
	disb_master_agreement_id  bigint,
	disb_fiscal_year_id  smallint,
	disb_check_eft_issued_cal_month_id integer,
	disb_disbursement_number character varying(40),
	status_flag char(1),
	type_of_year char(1)
) 	
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.contracts_mwbe_spending_transactions to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  

  CREATE VIEW contracts_mwbe_spending_transactions AS
  	SELECT contracts_mwbe_spending_transactions__0.disbursement_line_item_id,contracts_mwbe_spending_transactions__0.original_agreement_id,contracts_mwbe_spending_transactions__0.fiscal_year,
  	contracts_mwbe_spending_transactions__0.fiscal_year_id,contracts_mwbe_spending_transactions__0.document_code_id, contracts_mwbe_spending_transactions__0.vendor_id, contracts_mwbe_spending_transactions__0.minority_type_id,
  	contracts_mwbe_spending_transactions__0.award_method_id, contracts_mwbe_spending_transactions__0.document_agency_id, contracts_mwbe_spending_transactions__0.industry_type_id, contracts_mwbe_spending_transactions__0.award_size_id,
  	contracts_mwbe_spending_transactions__0.disb_document_id,contracts_mwbe_spending_transactions__0.disb_vendor_name,contracts_mwbe_spending_transactions__0.disb_check_eft_issued_date,contracts_mwbe_spending_transactions__0.disb_agency_name,
  	contracts_mwbe_spending_transactions__0.disb_department_short_name,contracts_mwbe_spending_transactions__0.disb_check_amount,contracts_mwbe_spending_transactions__0.disb_expenditure_object_name,
  	contracts_mwbe_spending_transactions__0.disb_budget_name,contracts_mwbe_spending_transactions__0.disb_contract_number,contracts_mwbe_spending_transactions__0.disb_purpose,contracts_mwbe_spending_transactions__0.disb_reporting_code,
  	contracts_mwbe_spending_transactions__0.disb_spending_category_name,contracts_mwbe_spending_transactions__0.disb_agency_id,contracts_mwbe_spending_transactions__0.disb_vendor_id,contracts_mwbe_spending_transactions__0.disb_expenditure_object_id,
  	contracts_mwbe_spending_transactions__0.disb_department_id,contracts_mwbe_spending_transactions__0.disb_spending_category_id,contracts_mwbe_spending_transactions__0.disb_agreement_id,contracts_mwbe_spending_transactions__0.disb_contract_document_code,
  	contracts_mwbe_spending_transactions__0.disb_master_agreement_id,contracts_mwbe_spending_transactions__0.disb_fiscal_year_id,contracts_mwbe_spending_transactions__0.disb_check_eft_issued_cal_month_id,contracts_mwbe_spending_transactions__0.disb_disbursement_number,
  	contracts_mwbe_spending_transactions__0.status_flag,contracts_mwbe_spending_transactions__0.type_of_year
  	FROM   contracts_mwbe_spending_transactions__0;	
  	


DROP VIEW IF EXISTS contract_vendor_latest_mwbe_category;
DROP EXTERNAL WEB TABLE IF EXISTS contract_vendor_latest_mwbe_category__0 ; 

CREATE EXTERNAL WEB TABLE contract_vendor_latest_mwbe_category__0 (
	vendor_id integer,
	vendor_history_id integer,
	agency_id smallint,
	minority_type_id smallint,
	is_prime_or_sub character(1),
	year_id smallint,
	type_of_year char(1)
	) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.contract_vendor_latest_mwbe_category to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
	
  CREATE VIEW contract_vendor_latest_mwbe_category AS
  	SELECT contract_vendor_latest_mwbe_category__0.vendor_id,contract_vendor_latest_mwbe_category__0.vendor_history_id,
  	contract_vendor_latest_mwbe_category__0.agency_id,contract_vendor_latest_mwbe_category__0.minority_type_id,contract_vendor_latest_mwbe_category__0.is_prime_or_sub,
  	contract_vendor_latest_mwbe_category__0.year_id, contract_vendor_latest_mwbe_category__0.type_of_year
  	FROM   contract_vendor_latest_mwbe_category__0;	
  	
  	
DROP VIEW IF EXISTS spending_vendor_latest_mwbe_category;
DROP EXTERNAL WEB TABLE IF EXISTS spending_vendor_latest_mwbe_category__0 ;  

CREATE EXTERNAL WEB TABLE spending_vendor_latest_mwbe_category__0 (
	vendor_id integer,
	vendor_history_id integer,
	agency_id smallint,
	minority_type_id smallint,
	is_prime_or_sub character(1),
	year_id smallint,
	type_of_year char(1)
	) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.spending_vendor_latest_mwbe_category to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
 	

 CREATE VIEW spending_vendor_latest_mwbe_category AS
  	SELECT spending_vendor_latest_mwbe_category__0.vendor_id,spending_vendor_latest_mwbe_category__0.vendor_history_id,
  	spending_vendor_latest_mwbe_category__0.agency_id,spending_vendor_latest_mwbe_category__0.minority_type_id, spending_vendor_latest_mwbe_category__0.is_prime_or_sub,
  	spending_vendor_latest_mwbe_category__0.year_id, spending_vendor_latest_mwbe_category__0.type_of_year
  	FROM   spending_vendor_latest_mwbe_category__0;	