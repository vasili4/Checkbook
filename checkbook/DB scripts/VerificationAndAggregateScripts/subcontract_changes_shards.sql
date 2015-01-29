SET search_path = public;


DROP  TABLE  IF EXISTS subcontract_vendor_business_type;	
CREATE TABLE subcontract_vendor_business_type (
	vendor_customer_code character varying,
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
    subcontract_id character varying,
	prime_vendor_customer_code character varying,
	vendor_customer_code character varying,
	business_type_id smallint,
	status smallint,
    minority_type_id smallint,
    certification_start_date date,
    certification_end_date date, 
    initiation_date date,
    certification_no character varying,
    disp_certification_start_date date,
    load_id integer,
    created_date timestamp without time zone
)
DISTRIBUTED BY (contract_number);


DROP  TABLE  IF EXISTS subvendor;	
CREATE TABLE subvendor (
    vendor_id integer ,
    vendor_customer_code character varying,
    legal_name character varying,
    display_flag CHAR(1) ,
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (vendor_id);


DROP  TABLE  IF EXISTS subvendor_history;	
CREATE TABLE subvendor_history (
    vendor_history_id integer,
    vendor_id integer,   
    legal_name character varying,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (vendor_history_id);


DROP  TABLE  IF EXISTS subvendor_business_type;
CREATE TABLE subvendor_business_type (
    vendor_business_type_id bigint ,
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
  business_type_name character varying,
  minority_type_name character varying
)
DISTRIBUTED BY (vendor_history_id);


DROP  TABLE  IF EXISTS subcontract_status;
CREATE TABLE subcontract_status (
    contract_number varchar,
	vendor_customer_code character varying, 
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
  agreement_id bigint ,
  contract_number varchar,
  sub_contract_id character varying,
  agency_history_id smallint,
  document_id character varying,
  document_code_id smallint,
  document_version integer,
  vendor_history_id integer,
  prime_vendor_id integer,
  agreement_type_id smallint,  
  aprv_sta smallint,
  aprv_reas_id character varying(3),
  aprv_reas_nm character varying,
  description character varying,
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
  tracking_number character varying,
  award_method_id smallint,
  award_category_id smallint,
  brd_awd_no character varying,
  number_responses integer,
  number_solicitation integer,
  doc_ref character varying,
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
    disbursement_line_item_id bigint ,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying,
    document_version integer,
    payment_id character varying,
    disbursement_number character varying,
    check_eft_amount_original numeric(16,2),
    check_eft_amount numeric(16,2),
    check_eft_issued_date_id int,
    check_eft_issued_nyc_year_id smallint,
    payment_description character varying,
    payment_proof character varying,
    is_final_payment varchar(3),
    doc_ref character varying,
    contract_number varchar,
  	sub_contract_id character varying,
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
   agency_code character varying,
   agency_name character varying,
   agreement_id bigint,
   starting_year smallint,
   starting_year_id smallint,
   ending_year smallint,
   ending_year_id smallint,
   registered_year smallint,
   registered_year_id smallint,
   contract_number character varying,
   sub_contract_id character varying,
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying,
   vendor_name character varying,
   prime_vendor_id integer,
   prime_minority_type_id smallint,
   prime_minority_type_name character varying(50),
   dollar_difference numeric(16,2),
   percent_difference numeric(17,4),
   agreement_type_id smallint,
   agreement_type_code character varying(2),
   agreement_type_name character varying,
   award_category_id smallint,
   award_category_code character varying,
   award_category_name character varying,
   award_method_id smallint,
   award_method_code character varying ,
   award_method_name character varying,
   expenditure_object_codes character varying,
   expenditure_object_names character varying,
   industry_type_id smallint,
   industry_type_name character varying,
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
   original_version_flag character(1),
   master_agreement_id bigint,  
   master_contract_number character varying,
   latest_flag character(1),
   load_id integer,
   last_modified_date timestamp without time zone,
   job_id bigint
 ) DISTRIBUTED BY (original_agreement_id);
 
 
 DROP  TABLE  IF EXISTS sub_agreement_snapshot_cy;
CREATE TABLE sub_agreement_snapshot_cy
 (
   original_agreement_id bigint,
   document_version smallint,
   document_code_id smallint,
   agency_history_id smallint,
   agency_id smallint,
   agency_code character varying,
   agency_name character varying,
   agreement_id bigint,
   starting_year smallint,
   starting_year_id smallint,
   ending_year smallint,
   ending_year_id smallint,
   registered_year smallint,
   registered_year_id smallint,
   contract_number character varying,
   sub_contract_id character varying,
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying,
   vendor_name character varying,
   prime_vendor_id integer,
   prime_minority_type_id smallint,
   prime_minority_type_name character varying(50),
   dollar_difference numeric(16,2),
   percent_difference numeric(17,4),
   agreement_type_id smallint,
   agreement_type_code character varying(2),
   agreement_type_name character varying,
   award_category_id smallint,
   award_category_code character varying,
   award_category_name character varying,
   award_method_id smallint,
   award_method_code character varying ,
   award_method_name character varying,
   expenditure_object_codes character varying,
   expenditure_object_names character varying,
   industry_type_id smallint,
   industry_type_name character varying,
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
   original_version_flag character(1),
   master_agreement_id bigint,  
   master_contract_number character varying,   
   latest_flag character(1),
   load_id integer,
   last_modified_date timestamp without time zone,
   job_id bigint
 ) DISTRIBUTED BY (original_agreement_id);
 
 
 DROP  TABLE  IF EXISTS sub_agreement_snapshot_expanded;
 CREATE TABLE sub_agreement_snapshot_expanded(
	original_agreement_id bigint,
	agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	sub_contract_id character varying,
	vendor_id int,
	prime_vendor_id int,
	prime_minority_type_id smallint,
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
 	minority_type_name character varying,
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
	sub_contract_id character varying,
	vendor_id int,
	prime_vendor_id int,
	prime_minority_type_id smallint,
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
 	minority_type_name character varying,
	status_flag char(1)
	)
DISTRIBUTED BY (original_agreement_id);	


DROP  TABLE  IF EXISTS subcontract_spending_details;
CREATE TABLE subcontract_spending_details(
	disbursement_line_item_id bigint,
	disbursement_number character varying,
	payment_id character varying,
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
	prime_minority_type_id smallint,
    prime_minority_type_name character varying(50),
	maximum_contract_amount numeric(16,2),
	maximum_contract_amount_cy numeric(16,2),	
	document_id varchar,
	vendor_name varchar,
	vendor_customer_code varchar, 
	check_eft_issued_date date,
	agency_name varchar,	
	agency_short_name character varying,  	
	expenditure_object_name varchar,
	expenditure_object_code varchar(4),
	contract_number character varying,
	sub_contract_id character varying,
	contract_vendor_id integer,
  	contract_vendor_id_cy integer,
	contract_prime_vendor_id integer,
  	contract_prime_vendor_id_cy integer,
  	contract_agency_id smallint,
  	contract_agency_id_cy smallint,
  	purpose varchar,
	purpose_cy character varying,
	reporting_code character varying,
	spending_category_id smallint,
	spending_category_name character varying,
	calendar_fiscal_year_id smallint,
	calendar_fiscal_year smallint,
	reference_document_number character varying,
	reference_document_code varchar(8),
	contract_document_code varchar(8),
	minority_type_id smallint,
 	minority_type_name character varying,
 	industry_type_id smallint,
   	industry_type_name character varying,
   	agreement_type_code character varying(2),
   	award_method_code character varying,
   	contract_industry_type_id smallint,
	contract_industry_type_id_cy smallint,
	contract_minority_type_id smallint,
	contract_minority_type_id_cy smallint,	
	contract_prime_minority_type_id smallint,
    contract_prime_minority_type_id_cy smallint,
	master_agreement_id bigint,  
    master_contract_number character varying,
	file_type char(1),
	load_id integer,
	last_modified_date timestamp without time zone,
	job_id bigint
)
DISTRIBUTED BY (disbursement_line_item_id);

-- aggregate tables

DROP TABLE IF EXISTS aggregateon_subven_spending_coa_entities;
CREATE TABLE aggregateon_subven_spending_coa_entities (
	agency_id smallint,
	spending_category_id smallint,
	vendor_id integer,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
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
    document_id character varying,
    sub_contract_id character varying,
    document_code character varying(8),
	vendor_id integer,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
	minority_type_id smallint,
	industry_type_id smallint,
	agency_id smallint,
	description character varying,	
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
	prime_minority_type_id smallint,
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
	
	

DROP TABLE IF EXISTS aggregateon_subven_contracts_cumulative_spending;
CREATE TABLE aggregateon_subven_contracts_cumulative_spending(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	description varchar,
	contract_number varchar,
	sub_contract_id character varying,
	vendor_id int,
	prime_vendor_id int,
	prime_minority_type_id smallint,
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
 prime_minority_type_id smallint,
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
 prime_minority_type_id smallint,
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
prime_minority_type_id smallint,
minority_type_id smallint,
award_method_id smallint,
document_agency_id smallint,
industry_type_id smallint,
award_size_id smallint,
disb_document_id  character varying,
disb_vendor_name  character varying,
disb_check_eft_issued_date  date,
disb_agency_name  character varying,
disb_check_amount  numeric(16,2),
disb_contract_number  character varying,
disb_sub_contract_id  character varying,
disb_purpose  character varying,
disb_reporting_code  character varying,
disb_spending_category_name  character varying,
disb_agency_id  smallint,
disb_vendor_id  integer,
disb_spending_category_id  smallint,
disb_agreement_id  bigint,
disb_contract_document_code  character varying,
disb_fiscal_year_id  smallint,
disb_check_eft_issued_cal_month_id integer,
disb_disbursement_number character varying,
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
	prime_minority_type_id smallint,
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


DROP TABLE IF EXISTS all_agreement_transactions ;
CREATE TABLE all_agreement_transactions  (
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
   sub_contract_id character varying,
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying(20),
   vendor_name character varying,
   prime_vendor_id integer,
   prime_vendor_name character varying,
   prime_minority_type_id smallint,
   prime_minority_type_name character varying(50),
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
   has_mwbe_children character(1),
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
 )WITH(appendonly=true,orientation=column)  
 DISTRIBUTED BY (original_agreement_id);
 

 DROP TABLE IF EXISTS all_agreement_transactions_cy ;
CREATE TABLE all_agreement_transactions_cy  (
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
   sub_contract_id character varying,
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying(20),
   vendor_name character varying,
   prime_vendor_id integer,
   prime_vendor_name character varying,
   prime_minority_type_id smallint,
   prime_minority_type_name character varying(50),
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
   has_mwbe_children character(1),
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
 )WITH(appendonly=true,orientation=column)  
 DISTRIBUTED BY (original_agreement_id);
 
 
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
	prime_minority_type_id smallint,
    prime_minority_type_name character varying(50),
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
	)WITH(appendonly=true,orientation=column)
DISTRIBUTED BY (disbursement_line_item_id)
PARTITION BY RANGE (fiscal_year) 
(START (2010) END (2015) EVERY (1),
DEFAULT PARTITION outlying_years);


DROP TABLE IF EXISTS contracts_all_spending_transactions ;
CREATE TABLE contracts_all_spending_transactions(
	disbursement_line_item_id bigint,
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	vendor_id int,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
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
	disb_sub_contract_id character varying,
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
	disb_minority_type_id smallint,
	disb_minority_type_name character varying(50),
	disb_vendor_type character(2),
	status_flag char(1),
	type_of_year char(1),
	is_prime_or_sub character(1)
)WITH (appendonly=true,orientation=column)
DISTRIBUTED BY (disbursement_line_item_id)
PARTITION BY RANGE (fiscal_year) 
(START (2010) END (2015) EVERY (1),
DEFAULT PARTITION outlying_years);


-- indexes

CREATE INDEX idx_agreement_id_all_disb_trans ON all_disbursement_transactions(agreement_id); 
CREATE INDEX idx_agency_id_all_disb_trans ON all_disbursement_transactions USING btree (agency_id);
CREATE INDEX idx_nyc_year_id_all_disb_trans ON all_disbursement_transactions USING btree (check_eft_issued_nyc_year_id);
CREATE INDEX idx_ma_agreement_id_all_disb_trans ON all_disbursement_transactions(master_agreement_id);


 CREATE INDEX idx_disb_agr_id_cont_all_spen_trans ON contracts_all_spending_transactions(disb_agreement_id);
 CREATE INDEX idx_fiscal_year_id_cont_all_spen_trans ON contracts_all_spending_transactions(fiscal_year_id);
 CREATE INDEX idx_disb_fis_year_id_cont_all_spen_trans ON contracts_all_spending_transactions(disb_fiscal_year_id);
 CREATE INDEX idx_disb_cont_doc_code_cont_all_spen_trans ON contracts_all_spending_transactions(disb_contract_document_code);
 CREATE INDEX idx_document_agency_id_cont_all_spen_trans ON contracts_all_spending_transactions(document_agency_id);
 CREATE INDEX idx_disb_cal_month_id_cont_all_spen_trans ON contracts_all_spending_transactions(disb_check_eft_issued_cal_month_id);
 CREATE INDEX idx_document_code_id_cont_all_spen_trans ON contracts_all_spending_transactions(document_code_id);
 

CREATE INDEX idx_vendor_id_all_disb_trans ON all_disbursement_transactions(vendor_id);
CREATE INDEX idx_vendor_name_all_disb_trans ON all_disbursement_transactions(vendor_name);
CREATE INDEX idx_pri_vendor_id_all_disb_trans ON all_disbursement_transactions(prime_vendor_id);
CREATE INDEX idx_pr_vendor_name_all_disb_trans ON all_disbursement_transactions(prime_vendor_name);
CREATE INDEX idx_department_id_all_disb_trans ON all_disbursement_transactions(department_id);
CREATE INDEX idx_department_name_all_disb_trans ON all_disbursement_transactions(department_name);
CREATE INDEX idx_exp_object_name_all_disb_trans ON all_disbursement_transactions(expenditure_object_name);
CREATE INDEX idx_chk_eft_iss_date_all_disb_trans ON all_disbursement_transactions(check_eft_issued_date);

CREATE INDEX idx_vendor_id_all_agreement_trans ON all_agreement_transactions(vendor_id);
CREATE INDEX idx_vendor_name_all_agreement_trans ON all_agreement_transactions(vendor_name);
CREATE INDEX idx_pri_vendor_id_all_agreement_trans ON all_agreement_transactions(prime_vendor_id);
CREATE INDEX idx_pri_vendor_name_all_agreement_trans ON all_agreement_transactions(prime_vendor_name);
CREATE INDEX idx_agency_id_all_agreement_trans ON all_agreement_transactions(agency_id);
CREATE INDEX idx_award_method_id_all_agreement_trans ON all_agreement_transactions(award_method_id);
CREATE INDEX idx_award_category_id_all_agreement_trans ON all_agreement_transactions(award_category_id);

CREATE INDEX idx_vendor_id_all_agreement_trans_cy ON all_agreement_transactions_cy(vendor_id);
CREATE INDEX idx_vendor_name_all_agreement_trans_cy ON all_agreement_transactions_cy(vendor_name);
CREATE INDEX idx_pri_vendor_id_all_agreement_trans_cy ON all_agreement_transactions_cy(prime_vendor_id);
CREATE INDEX idx_pri_vendor_name_all_agreement_trans_cy ON all_agreement_transactions_cy(prime_vendor_name);
CREATE INDEX idx_agency_id_all_agreement_trans_cy ON all_agreement_transactions_cy(agency_id);
CREATE INDEX idx_award_method_id_all_agreement_trans_cy ON all_agreement_transactions_cy(award_method_id);
CREATE INDEX idx_award_category_id_all_agreement_trans_cy ON all_agreement_transactions_cy(award_category_id);

CREATE INDEX idx_vendor_id_cont_all_spen_trans ON contracts_all_spending_transactions(vendor_id);
CREATE INDEX idx_award_method_id_cont_all_spen_trans ON contracts_all_spending_transactions(award_method_id);


 SET search_path = staging;
 
DROP  VIEW  IF EXISTS subcontract_vendor_business_type;
DROP EXTERNAL WEB TABLE IF EXISTS subcontract_vendor_business_type__0 ;

CREATE EXTERNAL WEB TABLE subcontract_vendor_business_type__0 (
	vendor_customer_code character varying,
	business_type_id smallint,
	status smallint,
    minority_type_id smallint,
    certification_start_date date,
    certification_end_date date, 
    initiation_date date,
    certification_no character varying(30),
    disp_certification_start_date date
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_vendor_business_type to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  

CREATE VIEW subcontract_vendor_business_type AS
    SELECT subcontract_vendor_business_type__0.vendor_customer_code, subcontract_vendor_business_type__0.business_type_id, subcontract_vendor_business_type__0.status, subcontract_vendor_business_type__0.minority_type_id,  
    subcontract_vendor_business_type__0.certification_start_date, subcontract_vendor_business_type__0.certification_end_date, subcontract_vendor_business_type__0.initiation_date, subcontract_vendor_business_type__0.certification_no, subcontract_vendor_business_type__0.disp_certification_start_date 
    FROM ONLY subcontract_vendor_business_type__0;
 
    
    
DROP  VIEW  IF EXISTS subcontract_business_type;
DROP EXTERNAL WEB TABLE IF EXISTS subcontract_business_type__0 ;

CREATE EXTERNAL WEB TABLE subcontract_business_type__0 (
    contract_number varchar,
    subcontract_id character varying,
	prime_vendor_customer_code character varying,
	vendor_customer_code character varying,
	business_type_id smallint,
	status smallint,
    minority_type_id smallint,
    certification_start_date date,
    certification_end_date date, 
    initiation_date date,
    certification_no character varying,
    disp_certification_start_date date,
    load_id integer,
    created_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_business_type to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  

  CREATE VIEW subcontract_business_type AS
    SELECT subcontract_business_type__0.contract_number, subcontract_business_type__0.subcontract_id, subcontract_business_type__0.prime_vendor_customer_code, subcontract_business_type__0.vendor_customer_code,  
    subcontract_business_type__0.business_type_id, subcontract_business_type__0.status, subcontract_business_type__0.minority_type_id, subcontract_business_type__0.certification_start_date, 
    subcontract_business_type__0.certification_end_date, subcontract_business_type__0.initiation_date, subcontract_business_type__0.certification_no, subcontract_business_type__0.disp_certification_start_date,
    subcontract_business_type__0.load_id,subcontract_business_type__0.created_date
    FROM ONLY subcontract_business_type__0;
    

DROP  VIEW  IF EXISTS subvendor;	
DROP EXTERNAL WEB TABLE IF EXISTS subvendor__0 ;

CREATE EXTERNAL WEB TABLE subvendor__0 (
    vendor_id integer ,
    vendor_customer_code character varying,
    legal_name character varying,
    display_flag CHAR(1) ,
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subvendor to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';

  
CREATE VIEW subvendor AS
    SELECT subvendor__0.vendor_id, subvendor__0.vendor_customer_code, subvendor__0.legal_name, 
    subvendor__0.display_flag, subvendor__0.created_load_id, subvendor__0.updated_load_id, subvendor__0.created_date, subvendor__0.updated_date 
    FROM ONLY subvendor__0;
 
    
    
DROP  VIEW  IF EXISTS subvendor_history;
DROP EXTERNAL WEB TABLE IF EXISTS subvendor_history__0 ;

CREATE EXTERNAL WEB TABLE subvendor_history__0 (
    vendor_history_id integer,
    vendor_id integer,   
    legal_name character varying,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subvendor_history to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  CREATE VIEW subvendor_history AS
    SELECT subvendor_history__0.vendor_history_id, subvendor_history__0.vendor_id, subvendor_history__0.legal_name,  
    subvendor_history__0.load_id, subvendor_history__0.created_date, subvendor_history__0.updated_date 
    FROM ONLY subvendor_history__0;

    
DROP  VIEW  IF EXISTS subvendor_business_type;
DROP EXTERNAL WEB TABLE IF EXISTS subvendor_business_type__0 ;

CREATE EXTERNAL WEB TABLE subvendor_business_type__0 (
    vendor_business_type_id bigint ,
    vendor_history_id integer,
    business_type_id smallint,
    status smallint,
    minority_type_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subvendor_business_type to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


CREATE VIEW subvendor_business_type AS
    SELECT subvendor_business_type__0.vendor_business_type_id, subvendor_business_type__0.vendor_history_id, subvendor_business_type__0.business_type_id, subvendor_business_type__0.status, 
    subvendor_business_type__0.minority_type_id, subvendor_business_type__0.load_id, subvendor_business_type__0.created_date, subvendor_business_type__0.updated_date 
    FROM ONLY subvendor_business_type__0;

    
DROP  VIEW  IF EXISTS subvendor_min_bus_type ;
DROP EXTERNAL WEB TABLE IF EXISTS subvendor_min_bus_type__0 ;

CREATE EXTERNAL WEB TABLE subvendor_min_bus_type__0
( vendor_id integer,
  vendor_history_id integer,
  business_type_id smallint,
  minority_type_id smallint,
  business_type_code character varying(4),
  business_type_name character varying,
  minority_type_name character varying
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subvendor_min_bus_type to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


CREATE VIEW subvendor_min_bus_type AS
    SELECT subvendor_min_bus_type__0.vendor_id, subvendor_min_bus_type__0.vendor_history_id, subvendor_min_bus_type__0.business_type_id, subvendor_min_bus_type__0.minority_type_id, 
    subvendor_min_bus_type__0.business_type_code, subvendor_min_bus_type__0.business_type_name, subvendor_min_bus_type__0.minority_type_name
    FROM ONLY subvendor_min_bus_type__0;
    
    
DROP  VIEW  IF EXISTS subcontract_status;
DROP EXTERNAL WEB TABLE IF EXISTS subcontract_status__0 ;

CREATE EXTERNAL WEB TABLE subcontract_status__0 (
    contract_number varchar,
	vendor_customer_code character varying, 
	scntrc_status smallint, 
	agreement_type_id smallint, 
	total_scntrc_max_am numeric(16,2),
	total_scntrc_pymt_am numeric(16,2),
    created_load_id integer,
    created_date timestamp without time zone,
    updated_load_id integer,
    updated_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_status to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  
CREATE VIEW subcontract_status AS
    SELECT subcontract_status__0.contract_number, subcontract_status__0.vendor_customer_code, subcontract_status__0.scntrc_status, subcontract_status__0.agreement_type_id,
    subcontract_status__0.total_scntrc_max_am, subcontract_status__0.total_scntrc_pymt_am, subcontract_status__0.created_load_id, 
    subcontract_status__0.created_date, subcontract_status__0.updated_load_id, subcontract_status__0.updated_date
    FROM ONLY subcontract_status__0;
    
    
DROP  VIEW  IF EXISTS subcontract_details;
DROP EXTERNAL WEB TABLE IF EXISTS subcontract_details__0 ;

CREATE  EXTERNAL WEB TABLE subcontract_details__0
(
  agreement_id bigint ,
  contract_number varchar,
  sub_contract_id character varying,
  agency_history_id smallint,
  document_id character varying,
  document_code_id smallint,
  document_version integer,
  vendor_history_id integer,
  prime_vendor_id integer,
  agreement_type_id smallint,  
  aprv_sta smallint,
  aprv_reas_id character varying(3),
  aprv_reas_nm character varying,
  description character varying,
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
  tracking_number character varying,
  award_method_id smallint,
  award_category_id smallint,
  brd_awd_no character varying,
  number_responses integer,
  number_solicitation integer,
  doc_ref character varying,
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
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_details to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  
CREATE VIEW subcontract_details AS
    SELECT subcontract_details__0.agreement_id, subcontract_details__0.contract_number, subcontract_details__0.sub_contract_id, subcontract_details__0.agency_history_id, 
     subcontract_details__0.document_id, subcontract_details__0.document_code_id, subcontract_details__0.document_version,     subcontract_details__0.vendor_history_id, 
     subcontract_details__0.prime_vendor_id,    subcontract_details__0.agreement_type_id, subcontract_details__0.aprv_sta,      subcontract_details__0.aprv_reas_id, 
     subcontract_details__0.aprv_reas_nm, subcontract_details__0.description,  subcontract_details__0.is_mwbe_cert, subcontract_details__0.industry_type_id, 
     subcontract_details__0.effective_begin_date_id, subcontract_details__0.effective_end_date_id, subcontract_details__0.registered_date_id,
     subcontract_details__0.source_updated_date_id,     subcontract_details__0.maximum_contract_amount_original, subcontract_details__0.maximum_contract_amount,  
     subcontract_details__0.original_contract_amount_original, subcontract_details__0.original_contract_amount,     subcontract_details__0.rfed_amount_original,
     subcontract_details__0.rfed_amount, subcontract_details__0.total_scntrc_pymt,subcontract_details__0.is_scntrc_pymt_complete,     subcontract_details__0.scntrc_mode, 
     subcontract_details__0.tracking_number,    subcontract_details__0.award_method_id,    subcontract_details__0.award_category_id, subcontract_details__0.brd_awd_no, 
     subcontract_details__0.number_responses,     subcontract_details__0.number_solicitation, subcontract_details__0.doc_ref, 
    subcontract_details__0.registered_fiscal_year, subcontract_details__0.registered_fiscal_year_id, subcontract_details__0.registered_calendar_year, 
    subcontract_details__0.registered_calendar_year_id,    subcontract_details__0.effective_end_fiscal_year, subcontract_details__0.effective_end_fiscal_year_id, 
    subcontract_details__0.effective_end_calendar_year, subcontract_details__0.effective_end_calendar_year_id,    subcontract_details__0.effective_begin_fiscal_year, 
    subcontract_details__0.effective_begin_fiscal_year_id, subcontract_details__0.effective_begin_calendar_year, subcontract_details__0.effective_begin_calendar_year_id,
    subcontract_details__0.source_updated_fiscal_year, subcontract_details__0.source_updated_fiscal_year_id, subcontract_details__0.source_updated_calendar_year, 
    subcontract_details__0.source_updated_calendar_year_id,    subcontract_details__0.original_agreement_id, subcontract_details__0.original_version_flag, 
    subcontract_details__0.master_agreement_id, subcontract_details__0.latest_flag,    subcontract_details__0.privacy_flag, subcontract_details__0.created_load_id, 
    subcontract_details__0.updated_load_id, subcontract_details__0.created_date,    subcontract_details__0.updated_date
    FROM ONLY subcontract_details__0;
    
    
DROP  VIEW  IF EXISTS subcontract_spending;
DROP EXTERNAL WEB TABLE IF EXISTS subcontract_spending__0 ;

CREATE EXTERNAL WEB TABLE subcontract_spending__0 (
    disbursement_line_item_id bigint ,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying,
    document_version integer,
    payment_id character varying,
    disbursement_number character varying,
    check_eft_amount_original numeric(16,2),
    check_eft_amount numeric(16,2),
    check_eft_issued_date_id int,
    check_eft_issued_nyc_year_id smallint,
    payment_description character varying,
    payment_proof character varying,
    is_final_payment varchar(3),
    doc_ref character varying,
    contract_number varchar,
  	sub_contract_id character varying,
    agreement_id bigint,
    vendor_history_id integer,
    prime_vendor_id integer,     
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_spending to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


CREATE VIEW subcontract_spending AS
    SELECT subcontract_spending__0.disbursement_line_item_id, subcontract_spending__0.document_code_id,subcontract_spending__0.agency_history_id,
    subcontract_spending__0.document_id,subcontract_spending__0.document_version, subcontract_spending__0.payment_id,
    subcontract_spending__0.disbursement_number, subcontract_spending__0.check_eft_amount_original, subcontract_spending__0.check_eft_amount,  
    subcontract_spending__0.check_eft_issued_date_id,subcontract_spending__0.check_eft_issued_nyc_year_id,subcontract_spending__0.payment_description,
    subcontract_spending__0.payment_proof,subcontract_spending__0.is_final_payment,subcontract_spending__0.doc_ref,
    subcontract_spending__0.contract_number,subcontract_spending__0.sub_contract_id,subcontract_spending__0.agreement_id,
    subcontract_spending__0.vendor_history_id,subcontract_spending__0.prime_vendor_id,
    subcontract_spending__0.created_load_id,subcontract_spending__0.updated_load_id,
    subcontract_spending__0.created_date, subcontract_spending__0.updated_date  
    FROM ONLY subcontract_spending__0;




DROP  VIEW  IF EXISTS sub_agreement_snapshot;
DROP EXTERNAL WEB TABLE IF EXISTS sub_agreement_snapshot__0 ;

CREATE EXTERNAL WEB TABLE sub_agreement_snapshot__0
 (
   original_agreement_id bigint,
   document_version smallint,
   document_code_id smallint,
   agency_history_id smallint,
   agency_id smallint,
   agency_code character varying,
   agency_name character varying,
   agreement_id bigint,
   starting_year smallint,
   starting_year_id smallint,
   ending_year smallint,
   ending_year_id smallint,
   registered_year smallint,
   registered_year_id smallint,
   contract_number character varying,
   sub_contract_id character varying,
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying,
   vendor_name character varying,
   prime_vendor_id integer,
   prime_minority_type_id smallint,
   prime_minority_type_name character varying(50),
   dollar_difference numeric(16,2),
   percent_difference numeric(17,4),
   agreement_type_id smallint,
   agreement_type_code character varying(2),
   agreement_type_name character varying,
   award_category_id smallint,
   award_category_code character varying,
   award_category_name character varying,
   award_method_id smallint,
   award_method_code character varying ,
   award_method_name character varying,
   expenditure_object_codes character varying,
   expenditure_object_names character varying,
   industry_type_id smallint,
   industry_type_name character varying,
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
   original_version_flag character(1),
   master_agreement_id bigint,  
   master_contract_number character varying,
   latest_flag character(1),
   load_id integer,
   last_modified_date timestamp without time zone,
   job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.sub_agreement_snapshot to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
 
  CREATE VIEW sub_agreement_snapshot AS
  	SELECT sub_agreement_snapshot__0.original_agreement_id,sub_agreement_snapshot__0.document_version,sub_agreement_snapshot__0.document_code_id,
  		sub_agreement_snapshot__0.agency_history_id,sub_agreement_snapshot__0.agency_id,sub_agreement_snapshot__0.agency_code,sub_agreement_snapshot__0.agency_name,
  		sub_agreement_snapshot__0.agreement_id,sub_agreement_snapshot__0.starting_year,sub_agreement_snapshot__0.starting_year_id,sub_agreement_snapshot__0.ending_year,
  		sub_agreement_snapshot__0.ending_year_id,sub_agreement_snapshot__0.registered_year,sub_agreement_snapshot__0.registered_year_id,sub_agreement_snapshot__0.contract_number,
  		sub_agreement_snapshot__0.sub_contract_id,sub_agreement_snapshot__0.original_contract_amount,sub_agreement_snapshot__0.maximum_contract_amount,sub_agreement_snapshot__0.description,
  		sub_agreement_snapshot__0.vendor_history_id,sub_agreement_snapshot__0.vendor_id,sub_agreement_snapshot__0.vendor_code,sub_agreement_snapshot__0.vendor_name,sub_agreement_snapshot__0.prime_vendor_id,
  		sub_agreement_snapshot__0.prime_minority_type_id,sub_agreement_snapshot__0.prime_minority_type_name,sub_agreement_snapshot__0.dollar_difference,sub_agreement_snapshot__0.percent_difference,
  		sub_agreement_snapshot__0.agreement_type_id,sub_agreement_snapshot__0.agreement_type_code,sub_agreement_snapshot__0.agreement_type_name,sub_agreement_snapshot__0.award_category_id,sub_agreement_snapshot__0.award_category_code,
  		sub_agreement_snapshot__0.award_category_name,sub_agreement_snapshot__0.award_method_id,sub_agreement_snapshot__0.award_method_code,sub_agreement_snapshot__0.award_method_name,
  		sub_agreement_snapshot__0.expenditure_object_codes,sub_agreement_snapshot__0.expenditure_object_names,sub_agreement_snapshot__0.industry_type_id,sub_agreement_snapshot__0.industry_type_name,sub_agreement_snapshot__0.award_size_id,
  		sub_agreement_snapshot__0.effective_begin_date,sub_agreement_snapshot__0.effective_begin_date_id,
  		sub_agreement_snapshot__0.effective_begin_year,sub_agreement_snapshot__0.effective_begin_year_id,sub_agreement_snapshot__0.effective_end_date,
  		sub_agreement_snapshot__0.effective_end_date_id,sub_agreement_snapshot__0.effective_end_year,sub_agreement_snapshot__0.effective_end_year_id,
  		sub_agreement_snapshot__0.registered_date,sub_agreement_snapshot__0.registered_date_id,sub_agreement_snapshot__0.brd_awd_no,sub_agreement_snapshot__0.tracking_number,sub_agreement_snapshot__0.rfed_amount,
  		sub_agreement_snapshot__0.minority_type_id,sub_agreement_snapshot__0.minority_type_name,
  		sub_agreement_snapshot__0.original_version_flag,sub_agreement_snapshot__0.master_agreement_id,
  		sub_agreement_snapshot__0.master_contract_number,sub_agreement_snapshot__0.latest_flag,
  		sub_agreement_snapshot__0.load_id,sub_agreement_snapshot__0.last_modified_date,sub_agreement_snapshot__0.job_id
  	FROM  sub_agreement_snapshot__0;
  	
  	
  
 DROP  VIEW  IF EXISTS sub_agreement_snapshot_cy;
 DROP EXTERNAL WEB TABLE IF EXISTS sub_agreement_snapshot_cy__0 ;
 
CREATE EXTERNAL WEB TABLE sub_agreement_snapshot_cy__0
 (
   original_agreement_id bigint,
   document_version smallint,
   document_code_id smallint,
   agency_history_id smallint,
   agency_id smallint,
   agency_code character varying,
   agency_name character varying,
   agreement_id bigint,
   starting_year smallint,
   starting_year_id smallint,
   ending_year smallint,
   ending_year_id smallint,
   registered_year smallint,
   registered_year_id smallint,
   contract_number character varying,
   sub_contract_id character varying,
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying,
   vendor_name character varying,
   prime_vendor_id integer,
   prime_minority_type_id smallint,
   prime_minority_type_name character varying(50),
   dollar_difference numeric(16,2),
   percent_difference numeric(17,4),
   agreement_type_id smallint,
   agreement_type_code character varying(2),
   agreement_type_name character varying,
   award_category_id smallint,
   award_category_code character varying,
   award_category_name character varying,
   award_method_id smallint,
   award_method_code character varying ,
   award_method_name character varying,
   expenditure_object_codes character varying,
   expenditure_object_names character varying,
   industry_type_id smallint,
   industry_type_name character varying,
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
   original_version_flag character(1),
   master_agreement_id bigint,  
   master_contract_number character varying,
   latest_flag character(1),
   load_id integer,
   last_modified_date timestamp without time zone,
   job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.sub_agreement_snapshot_cy to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
 
  CREATE VIEW sub_agreement_snapshot_cy AS
  	SELECT sub_agreement_snapshot_cy__0.original_agreement_id,sub_agreement_snapshot_cy__0.document_version,sub_agreement_snapshot_cy__0.document_code_id,
  		sub_agreement_snapshot_cy__0.agency_history_id,sub_agreement_snapshot_cy__0.agency_id,sub_agreement_snapshot_cy__0.agency_code,sub_agreement_snapshot_cy__0.agency_name,
  		sub_agreement_snapshot_cy__0.agreement_id,sub_agreement_snapshot_cy__0.starting_year,sub_agreement_snapshot_cy__0.starting_year_id,sub_agreement_snapshot_cy__0.ending_year,
  		sub_agreement_snapshot_cy__0.ending_year_id,sub_agreement_snapshot_cy__0.registered_year,sub_agreement_snapshot_cy__0.registered_year_id,sub_agreement_snapshot_cy__0.contract_number,
  		sub_agreement_snapshot_cy__0.sub_contract_id,sub_agreement_snapshot_cy__0.original_contract_amount,sub_agreement_snapshot_cy__0.maximum_contract_amount,sub_agreement_snapshot_cy__0.description,
  		sub_agreement_snapshot_cy__0.vendor_history_id,sub_agreement_snapshot_cy__0.vendor_id,sub_agreement_snapshot_cy__0.vendor_code,sub_agreement_snapshot_cy__0.vendor_name,sub_agreement_snapshot_cy__0.prime_vendor_id,
  		sub_agreement_snapshot_cy__0.prime_minority_type_id,sub_agreement_snapshot_cy__0.prime_minority_type_name,sub_agreement_snapshot_cy__0.dollar_difference,sub_agreement_snapshot_cy__0.percent_difference,
  		sub_agreement_snapshot_cy__0.agreement_type_id,sub_agreement_snapshot_cy__0.agreement_type_code,sub_agreement_snapshot_cy__0.agreement_type_name,sub_agreement_snapshot_cy__0.award_category_id,sub_agreement_snapshot_cy__0.award_category_code,
  		sub_agreement_snapshot_cy__0.award_category_name,sub_agreement_snapshot_cy__0.award_method_id,sub_agreement_snapshot_cy__0.award_method_code,sub_agreement_snapshot_cy__0.award_method_name,
   		sub_agreement_snapshot_cy__0.expenditure_object_codes,sub_agreement_snapshot_cy__0.expenditure_object_names,sub_agreement_snapshot_cy__0.industry_type_id,sub_agreement_snapshot_cy__0.industry_type_name,sub_agreement_snapshot_cy__0.award_size_id,
   		sub_agreement_snapshot_cy__0.effective_begin_date,sub_agreement_snapshot_cy__0.effective_begin_date_id,
  		sub_agreement_snapshot_cy__0.effective_begin_year,sub_agreement_snapshot_cy__0.effective_begin_year_id,sub_agreement_snapshot_cy__0.effective_end_date,
  		sub_agreement_snapshot_cy__0.effective_end_date_id,sub_agreement_snapshot_cy__0.effective_end_year,sub_agreement_snapshot_cy__0.effective_end_year_id,
  		sub_agreement_snapshot_cy__0.registered_date,sub_agreement_snapshot_cy__0.registered_date_id,sub_agreement_snapshot_cy__0.brd_awd_no,sub_agreement_snapshot_cy__0.tracking_number,sub_agreement_snapshot_cy__0.rfed_amount,
  		sub_agreement_snapshot_cy__0.minority_type_id,sub_agreement_snapshot_cy__0.minority_type_name,
  		sub_agreement_snapshot_cy__0.original_version_flag,sub_agreement_snapshot_cy__0.master_agreement_id,
  		sub_agreement_snapshot_cy__0.master_contract_number,sub_agreement_snapshot_cy__0.latest_flag,
  		sub_agreement_snapshot_cy__0.load_id,sub_agreement_snapshot_cy__0.last_modified_date,sub_agreement_snapshot_cy__0.job_id
  	FROM  sub_agreement_snapshot_cy__0; 
  	
  	
 DROP  VIEW  IF EXISTS sub_agreement_snapshot_expanded;
 DROP EXTERNAL WEB TABLE IF EXISTS sub_agreement_snapshot_expanded__0 ;
 
 CREATE EXTERNAL WEB TABLE sub_agreement_snapshot_expanded__0 (
	original_agreement_id bigint,
	agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	sub_contract_id character varying,
	vendor_id int,
	prime_vendor_id int,
	prime_minority_type_id smallint,
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
 	minority_type_name character varying,
	status_flag char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.sub_agreement_snapshot_expanded to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';	

CREATE VIEW sub_agreement_snapshot_expanded AS
	 SELECT sub_agreement_snapshot_expanded__0.original_agreement_id,sub_agreement_snapshot_expanded__0.agreement_id,sub_agreement_snapshot_expanded__0.fiscal_year,sub_agreement_snapshot_expanded__0.description,
	 	sub_agreement_snapshot_expanded__0.contract_number,sub_agreement_snapshot_expanded__0.sub_contract_id,sub_agreement_snapshot_expanded__0.vendor_id,sub_agreement_snapshot_expanded__0.prime_vendor_id,
	 	sub_agreement_snapshot_expanded__0.prime_minority_type_id,sub_agreement_snapshot_expanded__0.agency_id,sub_agreement_snapshot_expanded__0.industry_type_id,sub_agreement_snapshot_expanded__0.award_size_id,
	 	sub_agreement_snapshot_expanded__0.original_contract_amount,sub_agreement_snapshot_expanded__0.maximum_contract_amount,sub_agreement_snapshot_expanded__0.rfed_amount,
	 	sub_agreement_snapshot_expanded__0.starting_year,sub_agreement_snapshot_expanded__0.ending_year,sub_agreement_snapshot_expanded__0.dollar_difference,
	 	sub_agreement_snapshot_expanded__0.percent_difference,sub_agreement_snapshot_expanded__0.award_method_id,sub_agreement_snapshot_expanded__0.document_code_id,
	 	sub_agreement_snapshot_expanded__0.minority_type_id,sub_agreement_snapshot_expanded__0.minority_type_name,
	 	sub_agreement_snapshot_expanded__0.status_flag
	 FROM 	sub_agreement_snapshot_expanded__0;
 
	 
DROP  VIEW  IF EXISTS sub_agreement_snapshot_expanded_cy;
DROP EXTERNAL WEB TABLE IF EXISTS sub_agreement_snapshot_expanded_cy__0 ;

CREATE EXTERNAL WEB TABLE sub_agreement_snapshot_expanded_cy__0 (
	original_agreement_id bigint,
	agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	sub_contract_id character varying,
	vendor_id int,
	prime_vendor_id int,
	prime_minority_type_id smallint,
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
 	minority_type_name character varying,
	status_flag char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.sub_agreement_snapshot_expanded_cy to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';

  CREATE VIEW sub_agreement_snapshot_expanded_cy AS
  	SELECT sub_agreement_snapshot_expanded_cy__0.original_agreement_id,sub_agreement_snapshot_expanded_cy__0.agreement_id,sub_agreement_snapshot_expanded_cy__0.fiscal_year,sub_agreement_snapshot_expanded_cy__0.description,
  		sub_agreement_snapshot_expanded_cy__0.contract_number,sub_agreement_snapshot_expanded_cy__0.sub_contract_id,sub_agreement_snapshot_expanded_cy__0.vendor_id,sub_agreement_snapshot_expanded_cy__0.prime_vendor_id,
  		sub_agreement_snapshot_expanded_cy__0.prime_minority_type_id,sub_agreement_snapshot_expanded_cy__0.agency_id,sub_agreement_snapshot_expanded_cy__0.industry_type_id,sub_agreement_snapshot_expanded_cy__0.award_size_id,
  		sub_agreement_snapshot_expanded_cy__0.original_contract_amount,sub_agreement_snapshot_expanded_cy__0.maximum_contract_amount,sub_agreement_snapshot_expanded_cy__0.rfed_amount,
  		sub_agreement_snapshot_expanded_cy__0.starting_year,sub_agreement_snapshot_expanded_cy__0.ending_year,sub_agreement_snapshot_expanded_cy__0.dollar_difference,
  		sub_agreement_snapshot_expanded_cy__0.percent_difference,sub_agreement_snapshot_expanded_cy__0.award_method_id,sub_agreement_snapshot_expanded_cy__0.document_code_id,
  		sub_agreement_snapshot_expanded_cy__0.minority_type_id,sub_agreement_snapshot_expanded_cy__0.minority_type_name,
  		sub_agreement_snapshot_expanded_cy__0.status_flag
  	FROM sub_agreement_snapshot_expanded_cy__0;	
  	
  	
DROP  VIEW  IF EXISTS subcontract_spending_details;
DROP EXTERNAL WEB TABLE IF EXISTS subcontract_spending_details__0 ;

CREATE EXTERNAL WEB TABLE subcontract_spending_details__0 (
	disbursement_line_item_id bigint,
	disbursement_number character varying,
	payment_id character varying,
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
	prime_minority_type_id smallint,
    prime_minority_type_name character varying(50),
	maximum_contract_amount numeric(16,2),
	maximum_contract_amount_cy numeric(16,2),	
	document_id varchar,
	vendor_name varchar,
	vendor_customer_code varchar, 
	check_eft_issued_date date,
	agency_name varchar,	
	agency_short_name character varying,  	
	expenditure_object_name varchar,
	expenditure_object_code varchar(4),
	contract_number character varying,
	sub_contract_id character varying,
	contract_vendor_id integer,
  	contract_vendor_id_cy integer,
	contract_prime_vendor_id integer,
  	contract_prime_vendor_id_cy integer,
  	contract_agency_id smallint,
  	contract_agency_id_cy smallint,
  	purpose varchar,
	purpose_cy character varying,
	reporting_code character varying,
	spending_category_id smallint,
	spending_category_name character varying,
	calendar_fiscal_year_id smallint,
	calendar_fiscal_year smallint,
	reference_document_number character varying,
	reference_document_code varchar(8),
	contract_document_code varchar(8),
	minority_type_id smallint,
 	minority_type_name character varying,
 	industry_type_id smallint,
   	industry_type_name character varying,
   	agreement_type_code character varying(2),
   	award_method_code character varying,
   	contract_industry_type_id smallint,
	contract_industry_type_id_cy smallint,
	contract_minority_type_id smallint,
	contract_minority_type_id_cy smallint,	
	contract_prime_minority_type_id smallint,
    contract_prime_minority_type_id_cy smallint,
	master_agreement_id bigint,  
    master_contract_number character varying,
	file_type char(1),
	load_id integer,
	last_modified_date timestamp without time zone,
	job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_spending_details to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';

  
CREATE VIEW subcontract_spending_details AS
    SELECT subcontract_spending_details__0.disbursement_line_item_id, 
    subcontract_spending_details__0.disbursement_number, subcontract_spending_details__0.payment_id, subcontract_spending_details__0.check_eft_issued_date_id, 
    subcontract_spending_details__0.check_eft_issued_nyc_year_id, subcontract_spending_details__0.fiscal_year, subcontract_spending_details__0.check_eft_issued_cal_month_id, subcontract_spending_details__0.agreement_id,
    subcontract_spending_details__0.check_amount, subcontract_spending_details__0.agency_id,
    subcontract_spending_details__0.agency_history_id,subcontract_spending_details__0.agency_code,  subcontract_spending_details__0.vendor_id, subcontract_spending_details__0.prime_vendor_id,
    subcontract_spending_details__0.prime_minority_type_id,subcontract_spending_details__0.prime_minority_type_name,subcontract_spending_details__0.maximum_contract_amount, subcontract_spending_details__0.maximum_contract_amount_cy,
    subcontract_spending_details__0.document_id, subcontract_spending_details__0.vendor_name,subcontract_spending_details__0.vendor_customer_code, subcontract_spending_details__0.check_eft_issued_date, 
    subcontract_spending_details__0.agency_name,subcontract_spending_details__0.agency_short_name,
    subcontract_spending_details__0.expenditure_object_name,subcontract_spending_details__0.expenditure_object_code, 
    subcontract_spending_details__0.contract_number,  subcontract_spending_details__0.sub_contract_id,
    subcontract_spending_details__0.contract_vendor_id,subcontract_spending_details__0.contract_vendor_id_cy,subcontract_spending_details__0.contract_prime_vendor_id,
    subcontract_spending_details__0.contract_prime_vendor_id_cy,subcontract_spending_details__0.contract_agency_id,subcontract_spending_details__0.contract_agency_id_cy,
    subcontract_spending_details__0.purpose,subcontract_spending_details__0.purpose_cy,
    subcontract_spending_details__0.reporting_code,
    subcontract_spending_details__0.spending_category_id,subcontract_spending_details__0.spending_category_name,subcontract_spending_details__0.calendar_fiscal_year_id,subcontract_spending_details__0.calendar_fiscal_year,
    subcontract_spending_details__0.reference_document_number,subcontract_spending_details__0.reference_document_code,subcontract_spending_details__0.contract_document_code,
    subcontract_spending_details__0.minority_type_id,subcontract_spending_details__0.minority_type_name,subcontract_spending_details__0.industry_type_id,
    subcontract_spending_details__0.industry_type_name,subcontract_spending_details__0.agreement_type_code,subcontract_spending_details__0.award_method_code,
    subcontract_spending_details__0.contract_industry_type_id,subcontract_spending_details__0.contract_industry_type_id_cy,
    subcontract_spending_details__0.contract_minority_type_id,subcontract_spending_details__0.contract_minority_type_id_cy,
    subcontract_spending_details__0.contract_prime_minority_type_id,subcontract_spending_details__0.contract_prime_minority_type_id_cy,
    subcontract_spending_details__0.master_agreement_id,subcontract_spending_details__0.master_contract_number,
    subcontract_spending_details__0.file_type,subcontract_spending_details__0.load_id, subcontract_spending_details__0.last_modified_date, subcontract_spending_details__0.job_id
FROM ONLY subcontract_spending_details__0;


-- aggregate tables

DROP VIEW IF EXISTS aggregateon_subven_spending_coa_entities;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_subven_spending_coa_entities__0 ;

CREATE EXTERNAL WEB TABLE aggregateon_subven_spending_coa_entities__0 (
	agency_id smallint,
	spending_category_id smallint,
	vendor_id integer,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
	minority_type_id smallint,
	industry_type_id smallint,
	month_id int,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2),
	total_disbursements integer
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_spending_coa_entities to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
	

CREATE VIEW aggregateon_subven_spending_coa_entities AS
    SELECT aggregateon_subven_spending_coa_entities__0.agency_id, aggregateon_subven_spending_coa_entities__0.spending_category_id, 
    	aggregateon_subven_spending_coa_entities__0.vendor_id, aggregateon_subven_spending_coa_entities__0.prime_vendor_id, aggregateon_subven_spending_coa_entities__0.prime_minority_type_id,
    	aggregateon_subven_spending_coa_entities__0.minority_type_id, aggregateon_subven_spending_coa_entities__0.industry_type_id, 
    	aggregateon_subven_spending_coa_entities__0.month_id, aggregateon_subven_spending_coa_entities__0.year_id, 
    	aggregateon_subven_spending_coa_entities__0.type_of_year, aggregateon_subven_spending_coa_entities__0.total_spending_amount,aggregateon_subven_spending_coa_entities__0.total_disbursements 
    	FROM ONLY aggregateon_subven_spending_coa_entities__0;


    	
DROP VIEW IF EXISTS aggregateon_subven_spending_contract;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_subven_spending_contract__0 ;

CREATE EXTERNAL WEB TABLE aggregateon_subven_spending_contract__0 (
    agreement_id bigint,
    document_id character varying,
    sub_contract_id character varying,
    document_code character varying(8),
	vendor_id integer,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
	minority_type_id smallint,
	industry_type_id smallint,
	agency_id smallint,
	description character varying,	
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2), 
	total_contract_amount numeric(16,2)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_spending_contract to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
	

CREATE VIEW aggregateon_subven_spending_contract AS
    SELECT aggregateon_subven_spending_contract__0.agreement_id, aggregateon_subven_spending_contract__0.document_id, aggregateon_subven_spending_contract__0.sub_contract_id, 
    aggregateon_subven_spending_contract__0.document_code,aggregateon_subven_spending_contract__0.vendor_id, aggregateon_subven_spending_contract__0.prime_vendor_id,
    aggregateon_subven_spending_contract__0.prime_minority_type_id,aggregateon_subven_spending_contract__0.minority_type_id, aggregateon_subven_spending_contract__0.industry_type_id,
    aggregateon_subven_spending_contract__0.agency_id, aggregateon_subven_spending_contract__0.description, aggregateon_subven_spending_contract__0.spending_category_id, 
    aggregateon_subven_spending_contract__0.year_id,aggregateon_subven_spending_contract__0.type_of_year, 
    aggregateon_subven_spending_contract__0.total_spending_amount, aggregateon_subven_spending_contract__0.total_contract_amount 
    FROM ONLY aggregateon_subven_spending_contract__0;

    
DROP VIEW IF EXISTS aggregateon_subven_spending_vendor;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_subven_spending_vendor__0 ;

CREATE EXTERNAL WEB TABLE aggregateon_subven_spending_vendor__0 (
	vendor_id integer,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
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
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_spending_vendor to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
	

CREATE VIEW aggregateon_subven_spending_vendor AS
    SELECT aggregateon_subven_spending_vendor__0.vendor_id, aggregateon_subven_spending_vendor__0.prime_vendor_id, aggregateon_subven_spending_vendor__0.prime_minority_type_id,
    aggregateon_subven_spending_vendor__0.minority_type_id, aggregateon_subven_spending_vendor__0.industry_type_id,
    aggregateon_subven_spending_vendor__0.agency_id, aggregateon_subven_spending_vendor__0.spending_category_id, aggregateon_subven_spending_vendor__0.year_id,
    aggregateon_subven_spending_vendor__0.type_of_year, aggregateon_subven_spending_vendor__0.total_spending_amount, 
    aggregateon_subven_spending_vendor__0.total_contract_amount, aggregateon_subven_spending_vendor__0.total_sub_contracts, aggregateon_subven_spending_vendor__0.is_all_categories 
    FROM ONLY aggregateon_subven_spending_vendor__0;

  

DROP VIEW IF EXISTS aggregateon_subven_contracts_cumulative_spending;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_subven_contracts_cumulative_spending__0 ;

CREATE EXTERNAL WEB TABLE aggregateon_subven_contracts_cumulative_spending__0 (
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	description varchar,
	contract_number varchar,
	sub_contract_id character varying,
	vendor_id int,
	prime_vendor_id int,
	prime_minority_type_id smallint,
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
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_contracts_cumulative_spending to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  CREATE VIEW aggregateon_subven_contracts_cumulative_spending AS
  	SELECT aggregateon_subven_contracts_cumulative_spending__0.original_agreement_id,aggregateon_subven_contracts_cumulative_spending__0.fiscal_year,
  		aggregateon_subven_contracts_cumulative_spending__0.fiscal_year_id,
  		aggregateon_subven_contracts_cumulative_spending__0.document_code_id,
  		aggregateon_subven_contracts_cumulative_spending__0.description,aggregateon_subven_contracts_cumulative_spending__0.contract_number,aggregateon_subven_contracts_cumulative_spending__0.sub_contract_id,
  		aggregateon_subven_contracts_cumulative_spending__0.vendor_id,aggregateon_subven_contracts_cumulative_spending__0.prime_vendor_id,aggregateon_subven_contracts_cumulative_spending__0.prime_minority_type_id,
  		aggregateon_subven_contracts_cumulative_spending__0.minority_type_id,aggregateon_subven_contracts_cumulative_spending__0.award_method_id,
  		aggregateon_subven_contracts_cumulative_spending__0.agency_id,aggregateon_subven_contracts_cumulative_spending__0.industry_type_id,aggregateon_subven_contracts_cumulative_spending__0.award_size_id,
  		aggregateon_subven_contracts_cumulative_spending__0.original_contract_amount,aggregateon_subven_contracts_cumulative_spending__0.maximum_contract_amount,aggregateon_subven_contracts_cumulative_spending__0.spending_amount_disb,
  		aggregateon_subven_contracts_cumulative_spending__0.spending_amount,aggregateon_subven_contracts_cumulative_spending__0.current_year_spending_amount,
  		aggregateon_subven_contracts_cumulative_spending__0.dollar_difference,aggregateon_subven_contracts_cumulative_spending__0.percent_difference,
  		aggregateon_subven_contracts_cumulative_spending__0.status_flag,aggregateon_subven_contracts_cumulative_spending__0.type_of_year
  	FROM 	  aggregateon_subven_contracts_cumulative_spending__0;  

  
DROP VIEW IF EXISTS aggregateon_subven_contracts_spending_by_month;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_subven_contracts_spending_by_month__0 ;

CREATE EXTERNAL WEB TABLE aggregateon_subven_contracts_spending_by_month__0 (
 original_agreement_id bigint,
 fiscal_year smallint,
 fiscal_year_id smallint,
 document_code_id smallint,
 month_id integer,
 vendor_id int,
 prime_vendor_id int,
 prime_minority_type_id smallint,
 minority_type_id smallint,
 award_method_id smallint,
 agency_id smallint,
 industry_type_id smallint,
 award_size_id smallint,
 spending_amount numeric(16,2),
 status_flag char(1),
 type_of_year char(1) 
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_contracts_spending_by_month to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


   CREATE VIEW aggregateon_subven_contracts_spending_by_month AS
  	SELECT aggregateon_subven_contracts_spending_by_month__0.original_agreement_id,aggregateon_subven_contracts_spending_by_month__0.fiscal_year,aggregateon_subven_contracts_spending_by_month__0.fiscal_year_id,
  		aggregateon_subven_contracts_spending_by_month__0.document_code_id,aggregateon_subven_contracts_spending_by_month__0.month_id,aggregateon_subven_contracts_spending_by_month__0.vendor_id,
  		aggregateon_subven_contracts_spending_by_month__0.prime_vendor_id,aggregateon_subven_contracts_spending_by_month__0.prime_minority_type_id,aggregateon_subven_contracts_spending_by_month__0.minority_type_id,aggregateon_subven_contracts_spending_by_month__0.award_method_id,
  		aggregateon_subven_contracts_spending_by_month__0.agency_id,aggregateon_subven_contracts_spending_by_month__0.industry_type_id, aggregateon_subven_contracts_spending_by_month__0.award_size_id,
  		aggregateon_subven_contracts_spending_by_month__0.spending_amount,	aggregateon_subven_contracts_spending_by_month__0.status_flag,aggregateon_subven_contracts_spending_by_month__0.type_of_year
  	FROM  aggregateon_subven_contracts_spending_by_month__0;
  
 
DROP VIEW IF EXISTS aggregateon_subven_total_contracts;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_subven_total_contracts__0 ;

CREATE EXTERNAL WEB TABLE aggregateon_subven_total_contracts__0
(
fiscal_year smallint,
fiscal_year_id smallint,
vendor_id int,
 prime_vendor_id int,
 prime_minority_type_id smallint,
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
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_total_contracts to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  CREATE VIEW aggregateon_subven_total_contracts AS
  	SELECT aggregateon_subven_total_contracts__0.fiscal_year,aggregateon_subven_total_contracts__0.fiscal_year_id,aggregateon_subven_total_contracts__0.vendor_id, aggregateon_subven_total_contracts__0.prime_vendor_id, aggregateon_subven_total_contracts__0.prime_minority_type_id,
  	aggregateon_subven_total_contracts__0.minority_type_id,  	aggregateon_subven_total_contracts__0.award_method_id,  	aggregateon_subven_total_contracts__0.agency_id, aggregateon_subven_total_contracts__0.industry_type_id, 
  	aggregateon_subven_total_contracts__0.award_size_id,   	aggregateon_subven_total_contracts__0.total_contracts,aggregateon_subven_total_contracts__0.total_commited_contracts,	aggregateon_subven_total_contracts__0.total_master_agreements,
  	aggregateon_subven_total_contracts__0.total_standalone_contracts,aggregateon_subven_total_contracts__0.total_revenue_contracts,aggregateon_subven_total_contracts__0.total_revenue_contracts_amount,
  	aggregateon_subven_total_contracts__0.total_commited_contracts_amount,aggregateon_subven_total_contracts__0.total_contracts_amount,aggregateon_subven_total_contracts__0.total_spending_amount_disb,
  	aggregateon_subven_total_contracts__0.total_spending_amount,aggregateon_subven_total_contracts__0.status_flag,aggregateon_subven_total_contracts__0.type_of_year
  	FROM   aggregateon_subven_total_contracts__0;
  	

DROP VIEW IF EXISTS contracts_subven_spending_transactions;
DROP EXTERNAL WEB TABLE IF EXISTS contracts_subven_spending_transactions__0 ;

CREATE EXTERNAL WEB TABLE contracts_subven_spending_transactions__0
(
disbursement_line_item_id bigint,
original_agreement_id bigint,
fiscal_year smallint,
fiscal_year_id smallint,
document_code_id smallint,
vendor_id int,
prime_vendor_id int,
prime_minority_type_id smallint,
minority_type_id smallint,
award_method_id smallint,
document_agency_id smallint,
industry_type_id smallint,
award_size_id smallint,
disb_document_id  character varying,
disb_vendor_name  character varying,
disb_check_eft_issued_date  date,
disb_agency_name  character varying,
disb_check_amount  numeric(16,2),
disb_contract_number  character varying,
disb_sub_contract_id  character varying,
disb_purpose  character varying,
disb_reporting_code  character varying,
disb_spending_category_name  character varying,
disb_agency_id  smallint,
disb_vendor_id  integer,
disb_spending_category_id  smallint,
disb_agreement_id  bigint,
disb_contract_document_code  character varying,
disb_fiscal_year_id  smallint,
disb_check_eft_issued_cal_month_id integer,
disb_disbursement_number character varying,
disb_minority_type_id smallint,
disb_minority_type_name character varying(50),
disb_vendor_type character(2),
disb_master_contract_number character varying,
status_flag char(1),
type_of_year char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.contracts_subven_spending_transactions to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  CREATE VIEW contracts_subven_spending_transactions AS
  	SELECT contracts_subven_spending_transactions__0.disbursement_line_item_id,contracts_subven_spending_transactions__0.original_agreement_id,contracts_subven_spending_transactions__0.fiscal_year,
  	contracts_subven_spending_transactions__0.fiscal_year_id,contracts_subven_spending_transactions__0.document_code_id, contracts_subven_spending_transactions__0.vendor_id, contracts_subven_spending_transactions__0.prime_vendor_id, contracts_subven_spending_transactions__0.prime_minority_type_id, 
  	contracts_subven_spending_transactions__0.minority_type_id,  	contracts_subven_spending_transactions__0.award_method_id, contracts_subven_spending_transactions__0.document_agency_id, contracts_subven_spending_transactions__0.industry_type_id, 
  	contracts_subven_spending_transactions__0.award_size_id, 	contracts_subven_spending_transactions__0.disb_document_id,contracts_subven_spending_transactions__0.disb_vendor_name,contracts_subven_spending_transactions__0.disb_check_eft_issued_date,
  	contracts_subven_spending_transactions__0.disb_agency_name,  	contracts_subven_spending_transactions__0.disb_check_amount,  contracts_subven_spending_transactions__0.disb_contract_number,contracts_subven_spending_transactions__0.disb_sub_contract_id,
  	contracts_subven_spending_transactions__0.disb_purpose, contracts_subven_spending_transactions__0.disb_reporting_code,   	contracts_subven_spending_transactions__0.disb_spending_category_name,contracts_subven_spending_transactions__0.disb_agency_id,
  	contracts_subven_spending_transactions__0.disb_vendor_id, contracts_subven_spending_transactions__0.disb_spending_category_id,contracts_subven_spending_transactions__0.disb_agreement_id,contracts_subven_spending_transactions__0.disb_contract_document_code,
  	contracts_subven_spending_transactions__0.disb_fiscal_year_id,contracts_subven_spending_transactions__0.disb_check_eft_issued_cal_month_id,contracts_subven_spending_transactions__0.disb_disbursement_number,
  	contracts_subven_spending_transactions__0.disb_minority_type_id,contracts_subven_spending_transactions__0.disb_minority_type_name,contracts_subven_spending_transactions__0.disb_vendor_type,
  	contracts_subven_spending_transactions__0.disb_master_contract_number,contracts_subven_spending_transactions__0.status_flag,contracts_subven_spending_transactions__0.type_of_year
  	FROM   contracts_subven_spending_transactions__0;	

  	
  	
  	
DROP VIEW IF EXISTS aggregateon_all_contracts_cumulative_spending;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_all_contracts_cumulative_spending__0 ;

CREATE EXTERNAL WEB TABLE aggregateon_all_contracts_cumulative_spending__0 (
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	master_agreement_yn character(1),
	description varchar,
	contract_number varchar,
	sub_contract_id character varying,
	vendor_id int,
	prime_vendor_id int,
	prime_minority_type_id smallint,
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
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_all_contracts_cumulative_spending to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  CREATE VIEW aggregateon_all_contracts_cumulative_spending AS
  	SELECT aggregateon_all_contracts_cumulative_spending__0.original_agreement_id,aggregateon_all_contracts_cumulative_spending__0.fiscal_year,
  		aggregateon_all_contracts_cumulative_spending__0.fiscal_year_id,
  		aggregateon_all_contracts_cumulative_spending__0.document_code_id, aggregateon_all_contracts_cumulative_spending__0.master_agreement_yn,
  		aggregateon_all_contracts_cumulative_spending__0.description,aggregateon_all_contracts_cumulative_spending__0.contract_number,aggregateon_all_contracts_cumulative_spending__0.sub_contract_id,
  		aggregateon_all_contracts_cumulative_spending__0.vendor_id,aggregateon_all_contracts_cumulative_spending__0.prime_vendor_id,aggregateon_all_contracts_cumulative_spending__0.prime_minority_type_id,
  		aggregateon_all_contracts_cumulative_spending__0.minority_type_id,aggregateon_all_contracts_cumulative_spending__0.award_method_id,
  		aggregateon_all_contracts_cumulative_spending__0.agency_id,aggregateon_all_contracts_cumulative_spending__0.industry_type_id,aggregateon_all_contracts_cumulative_spending__0.award_size_id,
  		aggregateon_all_contracts_cumulative_spending__0.original_contract_amount,aggregateon_all_contracts_cumulative_spending__0.maximum_contract_amount,aggregateon_all_contracts_cumulative_spending__0.spending_amount_disb,
  		aggregateon_all_contracts_cumulative_spending__0.spending_amount,aggregateon_all_contracts_cumulative_spending__0.current_year_spending_amount,
  		aggregateon_all_contracts_cumulative_spending__0.dollar_difference,aggregateon_all_contracts_cumulative_spending__0.percent_difference,
  		aggregateon_all_contracts_cumulative_spending__0.status_flag,aggregateon_all_contracts_cumulative_spending__0.type_of_year
  	FROM 	  aggregateon_all_contracts_cumulative_spending__0;  
  	
  	
DROP VIEW IF EXISTS all_agreement_transactions;
DROP EXTERNAL WEB TABLE IF EXISTS all_agreement_transactions__0 ;

CREATE EXTERNAL WEB TABLE all_agreement_transactions__0(
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
	   sub_contract_id character varying,
	   original_contract_amount numeric(16,2),
	   maximum_contract_amount numeric(16,2),	   
	   description character varying,
	   vendor_history_id integer,
	   vendor_id integer,
	   vendor_code character varying(20),
	   vendor_name character varying,
	   prime_vendor_id integer,
	   prime_vendor_name character varying,
	   prime_minority_type_id smallint,
       prime_minority_type_name character varying(50),
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
	   has_mwbe_children character(1),
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
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.all_agreement_transactions to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW all_agreement_transactions AS
  	SELECT all_agreement_transactions__0.original_agreement_id,all_agreement_transactions__0.document_version,all_agreement_transactions__0.document_code_id,
  		all_agreement_transactions__0.agency_history_id,all_agreement_transactions__0.agency_id,all_agreement_transactions__0.agency_code,all_agreement_transactions__0.agency_name,
  		all_agreement_transactions__0.agreement_id,all_agreement_transactions__0.starting_year,all_agreement_transactions__0.starting_year_id,all_agreement_transactions__0.ending_year,
  		all_agreement_transactions__0.ending_year_id,all_agreement_transactions__0.registered_year,all_agreement_transactions__0.registered_year_id,all_agreement_transactions__0.contract_number,all_agreement_transactions__0.sub_contract_id,
  		all_agreement_transactions__0.original_contract_amount,all_agreement_transactions__0.maximum_contract_amount,all_agreement_transactions__0.description,
  		all_agreement_transactions__0.vendor_history_id,all_agreement_transactions__0.vendor_id,all_agreement_transactions__0.vendor_code,all_agreement_transactions__0.vendor_name,all_agreement_transactions__0.prime_vendor_id,all_agreement_transactions__0.prime_vendor_name,
  		all_agreement_transactions__0.prime_minority_type_id, all_agreement_transactions__0.prime_minority_type_name,all_agreement_transactions__0.dollar_difference,all_agreement_transactions__0.percent_difference,all_agreement_transactions__0.master_agreement_id,all_agreement_transactions__0.master_contract_number,
  		all_agreement_transactions__0.agreement_type_id,all_agreement_transactions__0.agreement_type_code,all_agreement_transactions__0.agreement_type_name,all_agreement_transactions__0.award_category_id,all_agreement_transactions__0.award_category_code,
  		all_agreement_transactions__0.award_category_name,all_agreement_transactions__0.award_method_id,all_agreement_transactions__0.award_method_code,all_agreement_transactions__0.award_method_name,
  		all_agreement_transactions__0.expenditure_object_codes,all_agreement_transactions__0.expenditure_object_names,all_agreement_transactions__0.industry_type_id,all_agreement_transactions__0.industry_type_name,all_agreement_transactions__0.award_size_id,
  		all_agreement_transactions__0.effective_begin_date,all_agreement_transactions__0.effective_begin_date_id,
  		all_agreement_transactions__0.effective_begin_year,all_agreement_transactions__0.effective_begin_year_id,all_agreement_transactions__0.effective_end_date,
  		all_agreement_transactions__0.effective_end_date_id,all_agreement_transactions__0.effective_end_year,all_agreement_transactions__0.effective_end_year_id,
  		all_agreement_transactions__0.registered_date,all_agreement_transactions__0.registered_date_id,all_agreement_transactions__0.brd_awd_no,all_agreement_transactions__0.tracking_number,all_agreement_transactions__0.rfed_amount,
  		all_agreement_transactions__0.minority_type_id,all_agreement_transactions__0.minority_type_name,
  		all_agreement_transactions__0.master_agreement_yn,all_agreement_transactions__0.has_children,all_agreement_transactions__0.has_mwbe_children,all_agreement_transactions__0.original_version_flag,all_agreement_transactions__0.latest_flag,
  		all_agreement_transactions__0.load_id,all_agreement_transactions__0.last_modified_date,all_agreement_transactions__0.last_modified_year_id,all_agreement_transactions__0.is_prime_or_sub,
  		all_agreement_transactions__0.is_minority_vendor, all_agreement_transactions__0.vendor_type, all_agreement_transactions__0.contract_original_agreement_id, all_agreement_transactions__0.job_id
  	FROM  all_agreement_transactions__0;


DROP VIEW IF EXISTS all_agreement_transactions_cy;
DROP EXTERNAL WEB TABLE IF EXISTS all_agreement_transactions_cy__0 ;	

CREATE EXTERNAL WEB TABLE all_agreement_transactions_cy__0(
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
	  sub_contract_id character varying, 
	  original_contract_amount numeric(16,2),
	  maximum_contract_amount numeric(16,2),
	  description character varying,
	  vendor_history_id integer,
	  vendor_id integer,
	  vendor_code character varying(20),
	  vendor_name character varying,
	  prime_vendor_id integer,
	  prime_vendor_name character varying,
	  prime_minority_type_id smallint,
      prime_minority_type_name character varying(50),
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
	  has_mwbe_children character(1),
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
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.all_agreement_transactions_cy to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW all_agreement_transactions_cy AS
  	SELECT all_agreement_transactions_cy__0.original_agreement_id,all_agreement_transactions_cy__0.document_version,all_agreement_transactions_cy__0.document_code_id,
  		all_agreement_transactions_cy__0.agency_history_id,all_agreement_transactions_cy__0.agency_id,all_agreement_transactions_cy__0.agency_code,all_agreement_transactions_cy__0.agency_name,
  		all_agreement_transactions_cy__0.agreement_id,all_agreement_transactions_cy__0.starting_year,all_agreement_transactions_cy__0.starting_year_id,all_agreement_transactions_cy__0.ending_year,
  		all_agreement_transactions_cy__0.ending_year_id,all_agreement_transactions_cy__0.registered_year,all_agreement_transactions_cy__0.registered_year_id,all_agreement_transactions_cy__0.contract_number,all_agreement_transactions_cy__0.sub_contract_id,
  		all_agreement_transactions_cy__0.original_contract_amount,all_agreement_transactions_cy__0.maximum_contract_amount,all_agreement_transactions_cy__0.description,
  		all_agreement_transactions_cy__0.vendor_history_id,all_agreement_transactions_cy__0.vendor_id,all_agreement_transactions_cy__0.vendor_code,all_agreement_transactions_cy__0.vendor_name,all_agreement_transactions_cy__0.prime_vendor_id, all_agreement_transactions_cy__0.prime_vendor_name,
  		all_agreement_transactions_cy__0.prime_minority_type_id, all_agreement_transactions_cy__0.prime_minority_type_name,all_agreement_transactions_cy__0.dollar_difference,all_agreement_transactions_cy__0.percent_difference,all_agreement_transactions_cy__0.master_agreement_id,all_agreement_transactions_cy__0.master_contract_number,
  		all_agreement_transactions_cy__0.agreement_type_id,all_agreement_transactions_cy__0.agreement_type_code,all_agreement_transactions_cy__0.agreement_type_name,all_agreement_transactions_cy__0.award_category_id,all_agreement_transactions_cy__0.award_category_code,
  		all_agreement_transactions_cy__0.award_category_name,all_agreement_transactions_cy__0.award_method_id,all_agreement_transactions_cy__0.award_method_code,all_agreement_transactions_cy__0.award_method_name,
   		all_agreement_transactions_cy__0.expenditure_object_codes,all_agreement_transactions_cy__0.expenditure_object_names,all_agreement_transactions_cy__0.industry_type_id,all_agreement_transactions_cy__0.industry_type_name,all_agreement_transactions_cy__0.award_size_id,
   		all_agreement_transactions_cy__0.effective_begin_date,all_agreement_transactions_cy__0.effective_begin_date_id,
  		all_agreement_transactions_cy__0.effective_begin_year,all_agreement_transactions_cy__0.effective_begin_year_id,all_agreement_transactions_cy__0.effective_end_date,
  		all_agreement_transactions_cy__0.effective_end_date_id,all_agreement_transactions_cy__0.effective_end_year,all_agreement_transactions_cy__0.effective_end_year_id,
  		all_agreement_transactions_cy__0.registered_date,all_agreement_transactions_cy__0.registered_date_id,all_agreement_transactions_cy__0.brd_awd_no,all_agreement_transactions_cy__0.tracking_number,all_agreement_transactions_cy__0.rfed_amount,
  		all_agreement_transactions_cy__0.minority_type_id,all_agreement_transactions_cy__0.minority_type_name,
  		all_agreement_transactions_cy__0.master_agreement_yn,all_agreement_transactions_cy__0.has_children,all_agreement_transactions_cy__0.has_mwbe_children,all_agreement_transactions_cy__0.original_version_flag,all_agreement_transactions_cy__0.latest_flag,
  		all_agreement_transactions_cy__0.load_id,all_agreement_transactions_cy__0.last_modified_date,all_agreement_transactions_cy__0.last_modified_year_id,all_agreement_transactions_cy__0.is_prime_or_sub,
  		all_agreement_transactions_cy__0.is_minority_vendor, all_agreement_transactions_cy__0.vendor_type, all_agreement_transactions_cy__0.contract_original_agreement_id, all_agreement_transactions_cy__0.job_id
  	FROM  all_agreement_transactions_cy__0; 
  	
  	
  	
 DROP VIEW IF EXISTS all_disbursement_transactions;
DROP EXTERNAL WEB TABLE IF EXISTS all_disbursement_transactions__0 ;	

 CREATE EXTERNAL WEB TABLE all_disbursement_transactions__0 (
    disbursement_line_item_id bigint,
	disbursement_id integer,
	line_number integer,
	disbursement_number character varying(40),
	payment_id character varying,
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
	prime_minority_type_id smallint,
    prime_minority_type_name character varying(50),
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
	sub_contract_id character varying,
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
	last_modified_fiscal_year_id smallint,
	last_modified_calendar_year_id smallint,
	is_prime_or_sub character(1),
	is_minority_vendor character(1), 
    vendor_type character(2),
    contract_original_agreement_id bigint,
	job_id bigint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.all_disbursement_transactions to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';



CREATE VIEW all_disbursement_transactions AS
    SELECT all_disbursement_transactions__0.disbursement_line_item_id, all_disbursement_transactions__0.disbursement_id, all_disbursement_transactions__0.line_number,
    all_disbursement_transactions__0.disbursement_number ,all_disbursement_transactions__0.payment_id, all_disbursement_transactions__0.check_eft_issued_date_id, 
    all_disbursement_transactions__0.check_eft_issued_nyc_year_id, all_disbursement_transactions__0.fiscal_year, all_disbursement_transactions__0.check_eft_issued_cal_month_id, all_disbursement_transactions__0.agreement_id,
    all_disbursement_transactions__0.master_agreement_id, all_disbursement_transactions__0.fund_class_id, all_disbursement_transactions__0.check_amount, all_disbursement_transactions__0.agency_id,
    all_disbursement_transactions__0.agency_history_id,all_disbursement_transactions__0.agency_code, all_disbursement_transactions__0.expenditure_object_id, all_disbursement_transactions__0.vendor_id, 
    all_disbursement_transactions__0.prime_vendor_id, all_disbursement_transactions__0.prime_vendor_name,all_disbursement_transactions__0.prime_minority_type_id, all_disbursement_transactions__0.prime_minority_type_name,
    all_disbursement_transactions__0.department_id,all_disbursement_transactions__0.maximum_contract_amount, all_disbursement_transactions__0.maximum_contract_amount_cy,
    all_disbursement_transactions__0.maximum_spending_limit,all_disbursement_transactions__0.maximum_spending_limit_cy,
    all_disbursement_transactions__0.document_id, all_disbursement_transactions__0.vendor_name,all_disbursement_transactions__0.vendor_customer_code, all_disbursement_transactions__0.check_eft_issued_date, 
    all_disbursement_transactions__0.agency_name,all_disbursement_transactions__0.agency_short_name,
    all_disbursement_transactions__0.location_name,all_disbursement_transactions__0.location_code, all_disbursement_transactions__0.department_name,
    all_disbursement_transactions__0.department_short_name,all_disbursement_transactions__0.department_code, all_disbursement_transactions__0.expenditure_object_name,all_disbursement_transactions__0.expenditure_object_code, 
    all_disbursement_transactions__0.budget_code_id,all_disbursement_transactions__0.budget_code,
    all_disbursement_transactions__0.budget_name, all_disbursement_transactions__0.contract_number,  all_disbursement_transactions__0.sub_contract_id, all_disbursement_transactions__0.master_contract_number,all_disbursement_transactions__0.master_child_contract_number,
    all_disbursement_transactions__0.contract_vendor_id,all_disbursement_transactions__0.contract_vendor_id_cy,all_disbursement_transactions__0.contract_prime_vendor_id,all_disbursement_transactions__0.contract_prime_vendor_id_cy,
    all_disbursement_transactions__0.master_contract_vendor_id,    all_disbursement_transactions__0.master_contract_vendor_id_cy,all_disbursement_transactions__0.contract_agency_id,all_disbursement_transactions__0.contract_agency_id_cy,
    all_disbursement_transactions__0.master_contract_agency_id,all_disbursement_transactions__0.master_contract_agency_id_cy,all_disbursement_transactions__0.master_purpose,
    all_disbursement_transactions__0.master_purpose_cy, all_disbursement_transactions__0.purpose,all_disbursement_transactions__0.purpose_cy,
    all_disbursement_transactions__0.master_child_contract_agency_id, all_disbursement_transactions__0.master_child_contract_agency_id_cy,all_disbursement_transactions__0.master_child_contract_vendor_id,all_disbursement_transactions__0.master_child_contract_vendor_id_cy,
    all_disbursement_transactions__0.reporting_code,all_disbursement_transactions__0.location_id,all_disbursement_transactions__0.fund_class_name,all_disbursement_transactions__0.fund_class_code,
    all_disbursement_transactions__0.spending_category_id,all_disbursement_transactions__0.spending_category_name,all_disbursement_transactions__0.calendar_fiscal_year_id,all_disbursement_transactions__0.calendar_fiscal_year,
    all_disbursement_transactions__0.agreement_accounting_line_number, all_disbursement_transactions__0.agreement_commodity_line_number, all_disbursement_transactions__0.agreement_vendor_line_number, 
    all_disbursement_transactions__0.reference_document_number,all_disbursement_transactions__0.reference_document_code,all_disbursement_transactions__0.contract_document_code,
    all_disbursement_transactions__0.master_contract_document_code, 
    all_disbursement_transactions__0.minority_type_id,all_disbursement_transactions__0.minority_type_name,all_disbursement_transactions__0.industry_type_id,
    all_disbursement_transactions__0.industry_type_name,all_disbursement_transactions__0.agreement_type_code,all_disbursement_transactions__0.award_method_code,
    all_disbursement_transactions__0.contract_industry_type_id,all_disbursement_transactions__0.contract_industry_type_id_cy,all_disbursement_transactions__0.master_contract_industry_type_id,
    all_disbursement_transactions__0.master_contract_industry_type_id_cy,all_disbursement_transactions__0.contract_minority_type_id,all_disbursement_transactions__0.contract_minority_type_id_cy,
    all_disbursement_transactions__0.master_contract_minority_type_id,all_disbursement_transactions__0.master_contract_minority_type_id_cy,
    all_disbursement_transactions__0.file_type,all_disbursement_transactions__0.load_id, all_disbursement_transactions__0.last_modified_date, 
    all_disbursement_transactions__0.last_modified_fiscal_year_id, all_disbursement_transactions__0.last_modified_calendar_year_id, all_disbursement_transactions__0.is_prime_or_sub, 
    all_disbursement_transactions__0.is_minority_vendor, all_disbursement_transactions__0.vendor_type, all_disbursement_transactions__0.contract_original_agreement_id, all_disbursement_transactions__0.job_id
FROM ONLY all_disbursement_transactions__0; 



DROP VIEW IF EXISTS contracts_all_spending_transactions;
DROP EXTERNAL WEB TABLE IF EXISTS contracts_all_spending_transactions__0 ;
	
   CREATE EXTERNAL WEB TABLE contracts_all_spending_transactions__0(
 	disbursement_line_item_id bigint,
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	vendor_id int,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
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
	disb_sub_contract_id character varying,
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
	disb_minority_type_id smallint,
	disb_minority_type_name character varying(50),
	disb_vendor_type character(2),
	status_flag char(1),
	type_of_year char(1),
	is_prime_or_sub character(1)
) 	
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.contracts_all_spending_transactions to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  

  CREATE VIEW contracts_all_spending_transactions AS
  	SELECT contracts_all_spending_transactions__0.disbursement_line_item_id,contracts_all_spending_transactions__0.original_agreement_id,contracts_all_spending_transactions__0.fiscal_year,
  	contracts_all_spending_transactions__0.fiscal_year_id,contracts_all_spending_transactions__0.document_code_id, contracts_all_spending_transactions__0.vendor_id, 
  	contracts_all_spending_transactions__0.prime_vendor_id,contracts_all_spending_transactions__0.prime_minority_type_id,contracts_all_spending_transactions__0.minority_type_id,
  	contracts_all_spending_transactions__0.award_method_id, contracts_all_spending_transactions__0.document_agency_id, contracts_all_spending_transactions__0.industry_type_id, contracts_all_spending_transactions__0.award_size_id,
  	contracts_all_spending_transactions__0.disb_document_id,contracts_all_spending_transactions__0.disb_vendor_name,contracts_all_spending_transactions__0.disb_check_eft_issued_date,contracts_all_spending_transactions__0.disb_agency_name,
  	contracts_all_spending_transactions__0.disb_department_short_name,contracts_all_spending_transactions__0.disb_check_amount,contracts_all_spending_transactions__0.disb_expenditure_object_name,
  	contracts_all_spending_transactions__0.disb_budget_name,contracts_all_spending_transactions__0.disb_contract_number,contracts_all_spending_transactions__0.disb_sub_contract_id,contracts_all_spending_transactions__0.disb_purpose,contracts_all_spending_transactions__0.disb_reporting_code,
  	contracts_all_spending_transactions__0.disb_spending_category_name,contracts_all_spending_transactions__0.disb_agency_id,contracts_all_spending_transactions__0.disb_vendor_id,contracts_all_spending_transactions__0.disb_expenditure_object_id,
  	contracts_all_spending_transactions__0.disb_department_id,contracts_all_spending_transactions__0.disb_spending_category_id,contracts_all_spending_transactions__0.disb_agreement_id,contracts_all_spending_transactions__0.disb_contract_document_code,
  	contracts_all_spending_transactions__0.disb_master_agreement_id,contracts_all_spending_transactions__0.disb_fiscal_year_id,contracts_all_spending_transactions__0.disb_check_eft_issued_cal_month_id,contracts_all_spending_transactions__0.disb_disbursement_number,
  	contracts_all_spending_transactions__0.disb_minority_type_id,contracts_all_spending_transactions__0.disb_minority_type_name,contracts_all_spending_transactions__0.disb_vendor_type,
  	contracts_all_spending_transactions__0.status_flag,contracts_all_spending_transactions__0.type_of_year,contracts_all_spending_transactions__0.is_prime_or_sub
  	FROM   contracts_all_spending_transactions__0;