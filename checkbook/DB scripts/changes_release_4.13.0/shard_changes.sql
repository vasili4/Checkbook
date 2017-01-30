-- to shards history_agreement
SET search_path = public;

DROP TABLE IF EXISTS history_agreement;

CREATE TABLE history_agreement
(
    agreement_id bigint,
    master_agreement_id bigint,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying,
    document_version integer,
    tracking_number character varying,
    record_date_id int,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period bpchar,
    description character varying,
    actual_amount_original numeric,
    actual_amount numeric,
    obligated_amount_original numeric,
    obligated_amount numeric,
    maximum_contract_amount_original numeric,
    maximum_contract_amount numeric,
    amendment_number character varying,
    replacing_agreement_id bigint,
    replaced_by_agreement_id bigint,
    award_status_id smallint,
    procurement_id character varying,
    procurement_type_id smallint,
    effective_begin_date_id int,
    effective_end_date_id int,
    reason_modification character varying,
    source_created_date_id int,
    source_updated_date_id int,
    document_function_code varchar,
    award_method_id smallint,
    award_level_code varchar,
    agreement_type_id smallint,
    contract_class_code character varying,
    award_category_id_1 smallint,
    award_category_id_2 smallint,
    award_category_id_3 smallint,
    award_category_id_4 smallint,
    award_category_id_5 smallint,
    number_responses integer,
    location_service character varying,
    location_zip character varying,
    borough_code character varying,
    block_code character varying,
    lot_code character varying,
    council_district_code character varying,
    vendor_history_id integer,
    vendor_preference_level integer,
    original_contract_amount_original numeric,
    original_contract_amount numeric,
    registered_date_id int,
    oca_number character varying,
    number_solicitation integer,
    document_name character varying,
    original_term_begin_date_id int,
    original_term_end_date_id int,
    brd_awd_no varchar,
    rfed_amount_original numeric,
    rfed_amount numeric,
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
    contract_number varchar,
    original_agreement_id bigint,
    original_version_flag char(1),
    latest_flag char(1),
    scntrc_status smallint,
    privacy_flag char(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
)DISTRIBUTED BY (agreement_id);

SET search_path = staging;
DROP  VIEW  IF EXISTS history_agreement;
DROP EXTERNAL WEB TABLE IF EXISTS history_agreement__0;

CREATE EXTERNAL WEB TABLE history_agreement__0 (
    agreement_id bigint,
    master_agreement_id bigint,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying,
    document_version integer,
    tracking_number character varying,
    record_date_id int,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period bpchar,
    description character varying,
    actual_amount_original numeric,
    actual_amount numeric,
    obligated_amount_original numeric,
    obligated_amount numeric,
    maximum_contract_amount_original numeric,
    maximum_contract_amount numeric,
    amendment_number character varying,
    replacing_agreement_id bigint,
    replaced_by_agreement_id bigint,
    award_status_id smallint,
    procurement_id character varying,
    procurement_type_id smallint,
    effective_begin_date_id int,
    effective_end_date_id int,
    reason_modification character varying,
    source_created_date_id int,
    source_updated_date_id int,
    document_function_code varchar,
    award_method_id smallint,
    award_level_code varchar,
    agreement_type_id smallint,
    contract_class_code character varying,
    award_category_id_1 smallint,
    award_category_id_2 smallint,
    award_category_id_3 smallint,
    award_category_id_4 smallint,
    award_category_id_5 smallint,
    number_responses integer,
    location_service character varying,
    location_zip character varying,
    borough_code character varying,
    block_code character varying,
    lot_code character varying,
    council_district_code character varying,
    vendor_history_id integer,
    vendor_preference_level integer,
    original_contract_amount_original numeric,
    original_contract_amount numeric,
    registered_date_id int,
    oca_number character varying,
    number_solicitation integer,
    document_name character varying,
    original_term_begin_date_id int,
    original_term_end_date_id int,
    brd_awd_no varchar,
    rfed_amount_original numeric,
    rfed_amount numeric,
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
    contract_number varchar,
    original_agreement_id bigint,
    original_version_flag char(1),
    latest_flag char(1),
    scntrc_status smallint,
    privacy_flag char(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.history_agreement to stdout csv"' ON SEGMENT 0
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


CREATE VIEW history_agreement AS
    SELECT history_agreement__0.agreement_id, history_agreement__0.master_agreement_id, history_agreement__0.document_code_id, history_agreement__0.agency_history_id,
    history_agreement__0.document_id, history_agreement__0.document_version, history_agreement__0.tracking_number, history_agreement__0.record_date_id,
    history_agreement__0.budget_fiscal_year, history_agreement__0.document_fiscal_year, history_agreement__0.document_period, history_agreement__0.description,
    history_agreement__0.actual_amount_original, history_agreement__0.actual_amount,history_agreement__0.obligated_amount_original, history_agreement__0.obligated_amount,
    history_agreement__0.maximum_contract_amount_original, history_agreement__0.maximum_contract_amount,history_agreement__0.amendment_number,
    history_agreement__0.replacing_agreement_id, history_agreement__0.replaced_by_agreement_id, history_agreement__0.award_status_id, history_agreement__0.procurement_id,
    history_agreement__0.procurement_type_id, history_agreement__0.effective_begin_date_id, history_agreement__0.effective_end_date_id, history_agreement__0.reason_modification,
    history_agreement__0.source_created_date_id, history_agreement__0.source_updated_date_id, history_agreement__0.document_function_code,
    history_agreement__0.award_method_id, history_agreement__0.award_level_code, history_agreement__0.agreement_type_id, history_agreement__0.contract_class_code,
    history_agreement__0.award_category_id_1, history_agreement__0.award_category_id_2, history_agreement__0.award_category_id_3, history_agreement__0.award_category_id_4,
    history_agreement__0.award_category_id_5, history_agreement__0.number_responses, history_agreement__0.location_service, history_agreement__0.location_zip,
    history_agreement__0.borough_code, history_agreement__0.block_code, history_agreement__0.lot_code, history_agreement__0.council_district_code,
    history_agreement__0.vendor_history_id, history_agreement__0.vendor_preference_level, history_agreement__0.original_contract_amount_original, history_agreement__0.original_contract_amount,
    history_agreement__0.registered_date_id, history_agreement__0.oca_number, history_agreement__0.number_solicitation, history_agreement__0.document_name,
    history_agreement__0.original_term_begin_date_id, history_agreement__0.original_term_end_date_id, history_agreement__0.brd_awd_no, history_agreement__0.rfed_amount_original,history_agreement__0.rfed_amount,
    history_agreement__0.registered_fiscal_year, history_agreement__0.registered_fiscal_year_id, history_agreement__0.registered_calendar_year, history_agreement__0.registered_calendar_year_id,
    history_agreement__0.effective_end_fiscal_year, history_agreement__0.effective_end_fiscal_year_id, history_agreement__0.effective_end_calendar_year, history_agreement__0.effective_end_calendar_year_id,
    history_agreement__0.effective_begin_fiscal_year, history_agreement__0.effective_begin_fiscal_year_id, history_agreement__0.effective_begin_calendar_year, history_agreement__0.effective_begin_calendar_year_id,
    history_agreement__0.source_updated_fiscal_year, history_agreement__0.source_updated_fiscal_year_id, history_agreement__0.source_updated_calendar_year, history_agreement__0.source_updated_calendar_year_id,
    history_agreement__0.contract_number, history_agreement__0.original_agreement_id, history_agreement__0.original_version_flag, history_agreement__0.latest_flag,history_agreement__0.scntrc_status,
    history_agreement__0.privacy_flag, history_agreement__0.created_load_id, history_agreement__0.updated_load_id, history_agreement__0.created_date,
    history_agreement__0.updated_date
    FROM ONLY history_agreement__0;


-- to shards agreement_snapshot
SET search_path = public;

DROP TABLE IF EXISTS agreement_snapshot;

CREATE TABLE agreement_snapshot
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
	   has_mwbe_children character(1),
	   original_version_flag character(1),
   	   latest_flag character(1),
   	   scntrc_status smallint,
   	  load_id integer,
      last_modified_date timestamp without time zone,
      job_id bigint
)DISTRIBUTED BY (original_agreement_id);

SET search_path = staging;
DROP  VIEW  IF EXISTS agreement_snapshot;
DROP EXTERNAL WEB TABLE IF EXISTS agreement_snapshot__0;

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
	   has_mwbe_children character(1),
	   original_version_flag character(1),
   	   latest_flag character(1),
   	   scntrc_status smallint,
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
  		agreement_snapshot__0.master_agreement_yn,agreement_snapshot__0.has_children,agreement_snapshot__0.has_mwbe_children,agreement_snapshot__0.original_version_flag,agreement_snapshot__0.latest_flag,
  		agreement_snapshot__0.scntrc_status,agreement_snapshot__0.load_id,agreement_snapshot__0.last_modified_date,agreement_snapshot__0.job_id
  	FROM  agreement_snapshot__0;



  -- to shards 
SET search_path = public;

DROP TABLE IF EXISTS agreement_snapshot_cy;

CREATE TABLE agreement_snapshot_cy(
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
  minority_type_name character varying(50),
  master_agreement_yn character(1),
  has_children character(1),
  has_mwbe_children character(1),
  original_version_flag character(1),
  latest_flag character(1),
  scntrc_status smallint,
  load_id integer,
  last_modified_date timestamp without time zone,
  job_id bigint
)DISTRIBUTED BY (original_agreement_id);

SET search_path = staging;
DROP  VIEW  IF EXISTS agreement_snapshot_cy;
DROP EXTERNAL WEB TABLE IF EXISTS agreement_snapshot_cy__0;


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
	  has_mwbe_children character(1),
	  original_version_flag character(1),
  	  latest_flag character(1),
  	  scntrc_status smallint,
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
  		agreement_snapshot_cy__0.master_agreement_yn,agreement_snapshot_cy__0.has_children,agreement_snapshot_cy__0.has_mwbe_children,agreement_snapshot_cy__0.original_version_flag,agreement_snapshot_cy__0.latest_flag,agreement_snapshot_cy__0.scntrc_status,
  		agreement_snapshot_cy__0.load_id,agreement_snapshot_cy__0.last_modified_date,agreement_snapshot_cy__0.job_id
  	FROM  agreement_snapshot_cy__0;

-- agreement_snapshot_expanded
SET search_path = public;

DROP TABLE IF EXISTS agreement_snapshot_expanded;

CREATE TABLE agreement_snapshot_expanded
(
  original_agreement_id bigint,
  agreement_id bigint,
  fiscal_year smallint,
  description character varying,
  contract_number character varying,
  vendor_id integer,
  agency_id smallint,
  industry_type_id smallint,
  award_size_id smallint,
  original_contract_amount numeric(16,2),
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
  status_flag character(1), 
  scntrc_status smallint
)DISTRIBUTED BY (original_agreement_id);

SET search_path = staging;
DROP  VIEW  IF EXISTS agreement_snapshot_expanded;
DROP EXTERNAL WEB TABLE IF EXISTS agreement_snapshot_expanded__0;


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
 	status_flag char(1),
 	scntrc_status smallint
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
	 	agreement_snapshot_expanded__0.master_agreement_yn,agreement_snapshot_expanded__0.status_flag,agreement_snapshot_expanded__0.scntrc_status
	 FROM 	agreement_snapshot_expanded__0;


-- agreement_snapshot_expanded_cy
SET search_path = public;

DROP TABLE IF EXISTS agreement_snapshot_expanded_cy;

CREATE TABLE agreement_snapshot_expanded_cy
(
  original_agreement_id bigint,
  agreement_id bigint,
  fiscal_year smallint,
  description character varying,
  contract_number character varying,
  vendor_id integer,
  agency_id smallint,
  industry_type_id smallint,
  award_size_id smallint,
  original_contract_amount numeric(16,2),
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
  status_flag character(1),
  scntrc_status smallint
)DISTRIBUTED BY (original_agreement_id);

SET search_path = staging;
DROP  VIEW  IF EXISTS agreement_snapshot_expanded_cy;
DROP EXTERNAL WEB TABLE IF EXISTS agreement_snapshot_expanded_cy__0;

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
	status_flag char(1),
	scntrc_status smallint
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
  		agreement_snapshot_expanded_cy__0.master_agreement_yn,agreement_snapshot_expanded_cy__0.status_flag,agreement_snapshot_expanded_cy__0.scntrc_status
  	FROM agreement_snapshot_expanded_cy__0;	
  	


  	-- sub_agreement_snapshot

  	SET search_path = public;

    DROP TABLE IF EXISTS sub_agreement_snapshot;

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
		prime_minority_type_id smallint,
		prime_minority_type_name character varying(50),
		dollar_difference numeric(16,2),
		percent_difference numeric(17,4),
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
		minority_type_name character varying(50),
		original_version_flag character(1),
		master_agreement_id bigint,
		master_contract_number character varying,
		latest_flag character(1),
		aprv_sta smallint,
		load_id integer,
		last_modified_date timestamp without time zone,
		job_id bigint
	)DISTRIBUTED BY (original_agreement_id);


	SET search_path = staging;
	DROP  VIEW  IF EXISTS sub_agreement_snapshot;
	DROP EXTERNAL WEB TABLE IF EXISTS sub_agreement_snapshot__0;


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
		aprv_sta smallint,
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
  		sub_agreement_snapshot__0.master_contract_number,sub_agreement_snapshot__0.latest_flag,sub_agreement_snapshot__0.aprv_sta,
  		sub_agreement_snapshot__0.load_id,sub_agreement_snapshot__0.last_modified_date,sub_agreement_snapshot__0.job_id
  	FROM  sub_agreement_snapshot__0;

  	-- all_agreement_transactions

  	SET search_path = public;

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
  minority_type_name character varying(50),
  master_agreement_yn character(1),
  has_children character(1),
  has_mwbe_children character(1),
  original_version_flag character(1),
  latest_flag character(1),
  scntrc_status smallint,
  scntrc_status_name character varying(100),
  aprv_sta smallint,
  aprv_sta_name character varying(100),
  load_id integer,
  last_modified_date timestamp without time zone,
  last_modified_year_id smallint,
  is_prime_or_sub character(1),
  is_minority_vendor character(1),
  vendor_type character(2),
  contract_original_agreement_id bigint,
  is_subvendor character varying(3),
  associated_prime_vendor_name character varying,
  mwbe_category_ui character varying,
  job_id bigint
)DISTRIBUTED BY (original_agreement_id);

SET search_path = staging;
DROP  VIEW  IF EXISTS all_agreement_transactions;
DROP EXTERNAL WEB TABLE IF EXISTS all_agreement_transactions__0;

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
		scntrc_status smallint,
		scntrc_status_name character varying(100),
		aprv_sta smallint,
		aprv_sta_name character varying(100),
		load_id integer,
		last_modified_date timestamp without time zone,
		last_modified_year_id smallint,
		is_prime_or_sub character(1),
		is_minority_vendor character(1), 
		vendor_type character(2),
		contract_original_agreement_id bigint,
		is_subvendor character varying(3),
		associated_prime_vendor_name character varying,
		mwbe_category_ui character varying,
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
  		all_agreement_transactions__0.prime_minority_type_id, all_agreement_transactions__0.prime_minority_type_name,	all_agreement_transactions__0.dollar_difference,all_agreement_transactions__0.percent_difference,all_agreement_transactions__0.master_agreement_id,all_agreement_transactions__0.master_contract_number,
  		all_agreement_transactions__0.agreement_type_id,all_agreement_transactions__0.agreement_type_code,all_agreement_transactions__0.agreement_type_name,all_agreement_transactions__0.award_category_id,all_agreement_transactions__0.award_category_code,
  		all_agreement_transactions__0.award_category_name,all_agreement_transactions__0.award_method_id,all_agreement_transactions__0.award_method_code,all_agreement_transactions__0.award_method_name,
  		all_agreement_transactions__0.expenditure_object_codes,all_agreement_transactions__0.expenditure_object_names,all_agreement_transactions__0.industry_type_id,all_agreement_transactions__0.industry_type_name,all_agreement_transactions__0.award_size_id,
  		all_agreement_transactions__0.effective_begin_date,all_agreement_transactions__0.effective_begin_date_id,
  		all_agreement_transactions__0.effective_begin_year,all_agreement_transactions__0.effective_begin_year_id,all_agreement_transactions__0.effective_end_date,
  		all_agreement_transactions__0.effective_end_date_id,all_agreement_transactions__0.effective_end_year,all_agreement_transactions__0.effective_end_year_id,
  		all_agreement_transactions__0.registered_date,all_agreement_transactions__0.registered_date_id,all_agreement_transactions__0.brd_awd_no,all_agreement_transactions__0.tracking_number,all_agreement_transactions__0.rfed_amount,
  		all_agreement_transactions__0.minority_type_id,all_agreement_transactions__0.minority_type_name,
  		all_agreement_transactions__0.master_agreement_yn,all_agreement_transactions__0.has_children,all_agreement_transactions__0.has_mwbe_children,all_agreement_transactions__0.original_version_flag,all_agreement_transactions__0.latest_flag,all_agreement_transactions__0.scntrc_status,all_agreement_transactions__0.scntrc_status_name,
  		all_agreement_transactions__0.aprv_sta,all_agreement_transactions__0.aprv_sta_name,
  		all_agreement_transactions__0.load_id,all_agreement_transactions__0.last_modified_date,all_agreement_transactions__0.last_modified_year_id,all_agreement_transactions__0.is_prime_or_sub,
  		all_agreement_transactions__0.is_minority_vendor, all_agreement_transactions__0.vendor_type, all_agreement_transactions__0.contract_original_agreement_id, 
  		all_agreement_transactions__0.is_subvendor, all_agreement_transactions__0.associated_prime_vendor_name, all_agreement_transactions__0.mwbe_category_ui, 
  		all_agreement_transactions__0.job_id
  	FROM  all_agreement_transactions__0;

-- all_agreement_transactions_cy

	SET search_path = public;

    DROP TABLE IF EXISTS all_agreement_transactions_cy;

    CREATE TABLE all_agreement_transactions_cy
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
  minority_type_name character varying(50),
  master_agreement_yn character(1),
  has_children character(1),
  has_mwbe_children character(1),
  original_version_flag character(1),
  latest_flag character(1),
  scntrc_status smallint,
  scntrc_status_name character varying(100),
  load_id integer,
  last_modified_date timestamp without time zone,
  last_modified_year_id smallint,
  is_prime_or_sub character(1),
  is_minority_vendor character(1),
  vendor_type character(2),
  contract_original_agreement_id bigint,
  is_subvendor character varying(3),
  associated_prime_vendor_name character varying,
  mwbe_category_ui character varying,
  job_id bigint
)DISTRIBUTED BY (original_agreement_id);


SET search_path = staging;
DROP  VIEW  IF EXISTS all_agreement_transactions_cy;
DROP EXTERNAL WEB TABLE IF EXISTS all_agreement_transactions_cy__0;

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
  	  scntrc_status smallint,
  	  scntrc_status_name character varying(100),
  	  load_id integer,
      last_modified_date timestamp without time zone,
      last_modified_year_id smallint,
      is_prime_or_sub character(1),
      is_minority_vendor character(1), 
      vendor_type character(2),
      contract_original_agreement_id bigint,
      is_subvendor character varying(3),
      associated_prime_vendor_name character varying,
      mwbe_category_ui character varying,
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
  		all_agreement_transactions_cy__0.vendor_history_id,all_agreement_transactions_cy__0.vendor_id,all_agreement_transactions_cy__0.vendor_code,all_agreement_transactions_cy__0.vendor_name,all_agreement_transactions_cy__0.prime_vendor_id,all_agreement_transactions_cy__0.prime_vendor_name,
  		all_agreement_transactions_cy__0.prime_minority_type_id, all_agreement_transactions_cy__0.prime_minority_type_name,	all_agreement_transactions_cy__0.dollar_difference,all_agreement_transactions_cy__0.percent_difference,all_agreement_transactions_cy__0.master_agreement_id,all_agreement_transactions_cy__0.master_contract_number,
  		all_agreement_transactions_cy__0.agreement_type_id,all_agreement_transactions_cy__0.agreement_type_code,all_agreement_transactions_cy__0.agreement_type_name,all_agreement_transactions_cy__0.award_category_id,all_agreement_transactions_cy__0.award_category_code,
  		all_agreement_transactions_cy__0.award_category_name,all_agreement_transactions_cy__0.award_method_id,all_agreement_transactions_cy__0.award_method_code,all_agreement_transactions_cy__0.award_method_name,
   		all_agreement_transactions_cy__0.expenditure_object_codes,all_agreement_transactions_cy__0.expenditure_object_names,all_agreement_transactions_cy__0.industry_type_id,all_agreement_transactions_cy__0.industry_type_name,all_agreement_transactions_cy__0.award_size_id,
   		all_agreement_transactions_cy__0.effective_begin_date,all_agreement_transactions_cy__0.effective_begin_date_id,
  		all_agreement_transactions_cy__0.effective_begin_year,all_agreement_transactions_cy__0.effective_begin_year_id,all_agreement_transactions_cy__0.effective_end_date,
  		all_agreement_transactions_cy__0.effective_end_date_id,all_agreement_transactions_cy__0.effective_end_year,all_agreement_transactions_cy__0.effective_end_year_id,
  		all_agreement_transactions_cy__0.registered_date,all_agreement_transactions_cy__0.registered_date_id,all_agreement_transactions_cy__0.brd_awd_no,all_agreement_transactions_cy__0.tracking_number,all_agreement_transactions_cy__0.rfed_amount,
  		all_agreement_transactions_cy__0.minority_type_id,all_agreement_transactions_cy__0.minority_type_name,
  		all_agreement_transactions_cy__0.master_agreement_yn,all_agreement_transactions_cy__0.has_children,all_agreement_transactions_cy__0.has_mwbe_children,all_agreement_transactions_cy__0.original_version_flag,all_agreement_transactions_cy__0.latest_flag,
  		all_agreement_transactions_cy__0.scntrc_status, all_agreement_transactions_cy__0.scntrc_status_name,
  		all_agreement_transactions_cy__0.load_id,all_agreement_transactions_cy__0.last_modified_date,all_agreement_transactions_cy__0.last_modified_year_id,all_agreement_transactions_cy__0.is_prime_or_sub,
  		all_agreement_transactions_cy__0.is_minority_vendor, all_agreement_transactions_cy__0.vendor_type, all_agreement_transactions_cy__0.contract_original_agreement_id, 
  		all_agreement_transactions_cy__0.is_subvendor, all_agreement_transactions_cy__0.associated_prime_vendor_name, all_agreement_transactions_cy__0.mwbe_category_ui, all_agreement_transactions_cy__0.job_id
  	FROM  all_agreement_transactions_cy__0; 


    SET search_path = public;

    
DROP TABLE IF EXISTS subcontract_status_by_prime_contract_id;
            CREATE TABLE subcontract_status_by_prime_contract_id (
            original_agreement_id bigint,
            contract_number character varying,
            description character varying(256),
            agency_id integer,
            agency_name character varying,
            prime_vendor_type character varying,
            prime_sub_vendor_code character varying,
            prime_sub_vendor_code_by_type character varying,
            prime_sub_minority_type_id character varying,
            prime_sub_vendor_minority_type_by_name_code character varying,
            prime_vendor_id integer,
            prime_vendor_code character varying,
            prime_vendor_name character varying,
            prime_minority_type_id smallint,
            prime_minority_type_name character varying(50),
            sub_vendor_type character varying,
            sub_vendor_id integer,
            sub_vendor_code character varying,
            sub_vendor_name character varying,
            sub_minority_type_id smallint,
            sub_minority_type_name character varying(50),
            sub_contract_id character varying(20),
            aprv_sta_id smallint,
            aprv_sta_value character varying(50),
            starting_year_id smallint,
            ending_year_id smallint,
            effective_begin_year_id smallint,
            effective_end_year_id smallint,
            sort_order smallint,
            latest_flag char(1),
            award_method_id smallint,
            award_method_name character varying,
            industry_type_id smallint,
            industry_type_name character varying(50),
            award_size_id smallint
            )
            DISTRIBUTED BY (original_agreement_id);

            SET search_path = staging;
            DROP  VIEW  IF EXISTS subcontract_status_by_prime_contract_id;
            DROP EXTERNAL WEB TABLE IF EXISTS subcontract_status_by_prime_contract_id__0;

            CREATE EXTERNAL WEB TABLE subcontract_status_by_prime_contract_id__0 (
            original_agreement_id bigint,
            contract_number character varying,
            description character varying(256),
            agency_id integer,
            agency_name character varying,
            prime_vendor_type character varying,
            prime_sub_vendor_code character varying,
            prime_sub_vendor_code_by_type character varying,
            prime_sub_minority_type_id character varying,
            prime_sub_vendor_minority_type_by_name_code character varying,
            prime_vendor_id integer,
            prime_vendor_code character varying,
            prime_vendor_name character varying,
            prime_minority_type_id smallint,
            prime_minority_type_name character varying(50),
            sub_vendor_type character varying,
            sub_vendor_id integer,
            sub_vendor_code character varying,
            sub_vendor_name character varying,
            sub_minority_type_id smallint,
            sub_minority_type_name character varying(50),
            sub_contract_id character varying(20),
            aprv_sta_id smallint,
            aprv_sta_value character varying(50),
            starting_year_id smallint,
            ending_year_id smallint,
            effective_begin_year_id smallint,
            effective_end_year_id smallint,
            sort_order smallint,
            latest_flag char(1),
            award_method_id smallint,
            award_method_name character varying,
            industry_type_id smallint,
            industry_type_name character varying(50),
            award_size_id smallint
            )
            EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_status_by_prime_contract_id to stdout csv"' ON SEGMENT 0 
            FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
            ENCODING 'UTF8';

            CREATE VIEW subcontract_status_by_prime_contract_id AS
            SELECT subcontract_status_by_prime_contract_id__0.original_agreement_id,
            subcontract_status_by_prime_contract_id__0.contract_number,
            subcontract_status_by_prime_contract_id__0.description,
            subcontract_status_by_prime_contract_id__0.agency_id,
            subcontract_status_by_prime_contract_id__0.agency_name,
            subcontract_status_by_prime_contract_id__0.prime_vendor_type,
            subcontract_status_by_prime_contract_id__0.prime_sub_vendor_code,
            subcontract_status_by_prime_contract_id__0.prime_sub_vendor_code_by_type,
            subcontract_status_by_prime_contract_id__0.prime_sub_minority_type_id,
            subcontract_status_by_prime_contract_id__0.prime_sub_vendor_minority_type_by_name_code,
            subcontract_status_by_prime_contract_id__0.prime_vendor_id,
            subcontract_status_by_prime_contract_id__0.prime_vendor_code,
            subcontract_status_by_prime_contract_id__0.prime_vendor_name,
            subcontract_status_by_prime_contract_id__0.prime_minority_type_id,
            subcontract_status_by_prime_contract_id__0.prime_minority_type_name,
            subcontract_status_by_prime_contract_id__0.sub_vendor_type,
            subcontract_status_by_prime_contract_id__0.sub_vendor_id,
            subcontract_status_by_prime_contract_id__0.sub_vendor_code,
            subcontract_status_by_prime_contract_id__0.sub_vendor_name ,
            subcontract_status_by_prime_contract_id__0.sub_minority_type_id,
            subcontract_status_by_prime_contract_id__0.sub_minority_type_name,
            subcontract_status_by_prime_contract_id__0.sub_contract_id,
            subcontract_status_by_prime_contract_id__0.aprv_sta_id,
            subcontract_status_by_prime_contract_id__0.aprv_sta_value ,
            subcontract_status_by_prime_contract_id__0.starting_year_id,
            subcontract_status_by_prime_contract_id__0.ending_year_id,
            subcontract_status_by_prime_contract_id__0.effective_begin_year_id,
            subcontract_status_by_prime_contract_id__0.effective_end_year_id,
            subcontract_status_by_prime_contract_id__0.sort_order,
            subcontract_status_by_prime_contract_id__0.latest_flag,
            subcontract_status_by_prime_contract_id__0.award_method_id,
            subcontract_status_by_prime_contract_id__0.award_method_name,
            subcontract_status_by_prime_contract_id__0.industry_type_id,
            subcontract_status_by_prime_contract_id__0.industry_type_name,
            subcontract_status_by_prime_contract_id__0.award_size_id
            FROM  subcontract_status_by_prime_contract_id__0;

    SET search_path = public;

DROP TABLE IF EXISTS all_agreement_transactions_by_prime_sub_vendor;

CREATE TABLE all_agreement_transactions_by_prime_sub_vendor (
    agreement_id bigint,
    original_agreement_id bigint,
    contract_original_agreement_id bigint,
    contract_number varchar, 
    scntrc_status bigint, -- contract_include_subvendor
    scntrc_status_name character varying(50),
    agreement_type_id smallint,
    agreement_type_code character varying(2),
    agreement_type_name character varying, -- contract_type
    master_agreement_yn character(1),  
    master_agreement_id bigint,
    master_contract_number character varying, -- Parent_ contract_id
    master_contract_number_export character varying,
    has_children character(1),
    has_mwbe_children character(1),
    document_code_id bigint,
    document_code character varying(8),
    agency_id bigint,
    agency_name character varying,
    agency_code character varying,
    vendor_record_type character varying, -- is_prime_or_sub
    award_method_id bigint,
    award_method_code character varying(10),
    award_method_name character varying,
    award_size_id bigint,
    expenditure_object_codes character varying, -- expense_category
    expenditure_object_names character varying,
    industry_type_id bigint,
    industry_type_name character varying(50),
    brd_awd_no character varying, -- apt_pin
    tracking_number character varying, -- pin
    registered_year bigint,
    registered_year_id smallint,
    registered_date date,
    registered_date_id bigint,
    starting_year_id bigint,
    ending_year_id bigint,
    effective_begin_year_id bigint,
    effective_end_year_id bigint,
    latest_flag character(1),
    version bigint,
    prime_apt_pin character varying,
    prime_pin character varying,
    prime_vendor_type character varying,
    prime_purpose character varying(256), 
    prime_original_contract_amount numeric(16,2), 
    prime_maximum_contract_amount numeric(16,2), -- prime_current_amount
    prime_amount_id integer,
    prime_amount_name character varying,
    prime_dollar_difference numeric(16,2),
    prime_percent_difference numeric(17,4),
    prime_document_version bigint,
    prime_vendor_id bigint,
    prime_vendor_code character varying,
    prime_vendor_name character varying,
    associated_prime_vendor_code character varying,
    associated_prime_vendor_name character varying,
    prime_minority_type_id integer,
    prime_minority_type_name character varying(50),
    prime_mwbe_adv_search_id integer,
    prime_mwbe_adv_search character varying(50),
    prime_rfed_amount numeric(16,2), -- prime_spent_to_date
    prime_starting_year bigint,
    prime_starting_year_id bigint,
    prime_ending_year bigint,
    prime_ending_year_id bigint,
    prime_effective_begin_date date,
    prime_effective_begin_date_id bigint,
    prime_effective_begin_year bigint,
    prime_effective_begin_year_id bigint,
    prime_effective_end_date date,
    prime_effective_end_date_id bigint,
    prime_effective_end_year bigint,
    prime_effective_end_year_id bigint,
    prime_industry_type_id bigint,
    prime_industry_type_name character varying(50),
    sub_vendor_type character varying,
    sub_vendor_id bigint,
    sub_vendor_code character varying,
    sub_vendor_name character varying,
    sub_vendor_name_export character varying,
    sub_minority_type_id bigint,
    sub_minority_type_name character varying(50),
    sub_minority_type_name_export character varying(50),
    sub_purpose character varying(256),
    sub_purpose_export character varying(256),
    sub_apt_pin character varying,
    sub_pin character varying,
    aprv_sta bigint, -- subcontract_status_in_pip
    aprv_sta_name character varying(50),
    aprv_sta_name_export character varying(50),
    sub_original_contract_amount numeric(16,2),
    sub_maximum_contract_amount numeric(16,2),
    sub_amount_id integer,
    sub_amount_name character varying,
    sub_dollar_difference numeric(16,2),
    sub_percent_difference numeric(17,4),
    sub_rfed_amount numeric(16,2),
    sub_starting_year bigint,
    sub_starting_year_id bigint,
    sub_ending_year bigint,
    sub_ending_year_id bigint,
    sub_effective_begin_date date,
    sub_effective_begin_date_export character varying,
    sub_effective_begin_date_id bigint,
    sub_effective_begin_year bigint,
    sub_effective_begin_year_id bigint,
    sub_effective_end_date date,
    sub_effective_end_date_export character varying,
    sub_effective_end_date_id bigint,
    sub_effective_end_year bigint,
    sub_effective_end_year_id bigint,
    sub_document_version bigint,
    sub_contract_id character varying(20),
    sub_contract_id_export character varying(20),
    sub_industry_type_id bigint,
    sub_industry_type_name character varying(50),
    sub_industry_type_name_export character varying(50),
    sub_latest_flag character(1)
)
DISTRIBUTED BY(agreement_id);

SET search_path = staging;
DROP  VIEW  IF EXISTS all_agreement_transactions_by_prime_sub_vendor;
DROP EXTERNAL WEB TABLE IF EXISTS all_agreement_transactions_by_prime_sub_vendor__0;

CREATE EXTERNAL WEB TABLE all_agreement_transactions_by_prime_sub_vendor__0 (
    agreement_id bigint,
    original_agreement_id bigint,
    contract_original_agreement_id bigint,
    contract_number varchar, 
    scntrc_status bigint, -- contract_include_subvendor
    scntrc_status_name character varying(50),
    agreement_type_id smallint,
    agreement_type_code character varying(2),
    agreement_type_name character varying, -- contract_type
    master_agreement_yn character(1),  
    master_agreement_id bigint,
    master_contract_number character varying, -- Parent_ contract_id
    master_contract_number_export character varying,
    has_children character(1),
    has_mwbe_children character(1),
    document_code_id bigint,
    document_code character varying(8),
    agency_id bigint,
    agency_name character varying,
    agency_code character varying,
    vendor_record_type character varying, -- is_prime_or_sub
    award_method_id bigint,
    award_method_code character varying(10),
    award_method_name character varying,
    award_size_id bigint,
    expenditure_object_codes character varying, -- expense_category
    expenditure_object_names character varying,
    industry_type_id bigint,
    industry_type_name character varying(50),
    brd_awd_no character varying, -- apt_pin
    tracking_number character varying, -- pin
    registered_year bigint,
    registered_year_id smallint,
    registered_date date,
    registered_date_id bigint,
    starting_year_id bigint,
    ending_year_id bigint,
    effective_begin_year_id bigint,
    effective_end_year_id bigint,
    latest_flag character(1),
    version bigint,
    prime_apt_pin character varying,
    prime_pin character varying,
    prime_vendor_type character varying,
    prime_purpose character varying(256), 
    prime_original_contract_amount numeric(16,2), 
    prime_maximum_contract_amount numeric(16,2), -- prime_current_amount
    prime_amount_id integer,
    prime_amount_name character varying,
    prime_dollar_difference numeric(16,2),
    prime_percent_difference numeric(17,4),
    prime_document_version bigint,
    prime_vendor_id bigint,
    prime_vendor_code character varying,
    prime_vendor_name character varying,
    associated_prime_vendor_code character varying,
    associated_prime_vendor_name character varying,
    prime_minority_type_id integer,
    prime_minority_type_name character varying(50),
    prime_mwbe_adv_search_id integer,
    prime_mwbe_adv_search character varying(50),
    prime_rfed_amount numeric(16,2), -- prime_spent_to_date
    prime_starting_year bigint,
    prime_starting_year_id bigint,
    prime_ending_year bigint,
    prime_ending_year_id bigint,
    prime_effective_begin_date date,
    prime_effective_begin_date_id bigint,
    prime_effective_begin_year bigint,
    prime_effective_begin_year_id bigint,
    prime_effective_end_date date,
    prime_effective_end_date_id bigint,
    prime_effective_end_year bigint,
    prime_effective_end_year_id bigint,
    prime_industry_type_id bigint,
    prime_industry_type_name character varying(50),
    sub_vendor_type character varying,
    sub_vendor_id bigint,
    sub_vendor_code character varying,
    sub_vendor_name character varying,
    sub_vendor_name_export character varying,
    sub_minority_type_id bigint,
    sub_minority_type_name character varying(50),
    sub_minority_type_name_export character varying(50),
    sub_purpose character varying(256),
    sub_purpose_export character varying(256),
    sub_apt_pin character varying,
    sub_pin character varying,
    aprv_sta bigint, -- subcontract_status_in_pip
    aprv_sta_name character varying(50),
    aprv_sta_name_export character varying(50),
    sub_original_contract_amount numeric(16,2),
    sub_maximum_contract_amount numeric(16,2),
    sub_amount_id integer,
    sub_amount_name character varying,
    sub_dollar_difference numeric(16,2),
    sub_percent_difference numeric(17,4),
    sub_rfed_amount numeric(16,2),
    sub_starting_year bigint,
    sub_starting_year_id bigint,
    sub_ending_year bigint,
    sub_ending_year_id bigint,
    sub_effective_begin_date date,
    sub_effective_begin_date_export character varying,
    sub_effective_begin_date_id bigint,
    sub_effective_begin_year bigint,
    sub_effective_begin_year_id bigint,
    sub_effective_end_date date,
    sub_effective_end_date_export character varying,
    sub_effective_end_date_id bigint,
    sub_effective_end_year bigint,
    sub_effective_end_year_id bigint,
    sub_document_version bigint,
    sub_contract_id character varying(20),
    sub_contract_id_export character varying(20),
    sub_industry_type_id bigint,
    sub_industry_type_name character varying(50),
    sub_industry_type_name_export character varying(50),
    sub_latest_flag character(1)
)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.all_agreement_transactions_by_prime_sub_vendor to stdout csv"' ON SEGMENT 0 
FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

CREATE VIEW all_agreement_transactions_by_prime_sub_vendor AS
    SELECT  all_agreement_transactions_by_prime_sub_vendor__0.agreement_id,
    all_agreement_transactions_by_prime_sub_vendor__0.original_agreement_id,
    all_agreement_transactions_by_prime_sub_vendor__0.contract_original_agreement_id,
    all_agreement_transactions_by_prime_sub_vendor__0.contract_number, 
    all_agreement_transactions_by_prime_sub_vendor__0.scntrc_status, -- contract_include_subvendor
    all_agreement_transactions_by_prime_sub_vendor__0.scntrc_status_name, 
    all_agreement_transactions_by_prime_sub_vendor__0.agreement_type_id,
    all_agreement_transactions_by_prime_sub_vendor__0.agreement_type_code,
    all_agreement_transactions_by_prime_sub_vendor__0.agreement_type_name, -- contract_type
    all_agreement_transactions_by_prime_sub_vendor__0.master_agreement_yn,  
    all_agreement_transactions_by_prime_sub_vendor__0.master_agreement_id,
    all_agreement_transactions_by_prime_sub_vendor__0.master_contract_number, -- Parent_ contract_id
    all_agreement_transactions_by_prime_sub_vendor__0.master_contract_number_export,
    all_agreement_transactions_by_prime_sub_vendor__0.has_children,
    all_agreement_transactions_by_prime_sub_vendor__0.has_mwbe_children,
    all_agreement_transactions_by_prime_sub_vendor__0.document_code_id,
    all_agreement_transactions_by_prime_sub_vendor__0.document_code,
    all_agreement_transactions_by_prime_sub_vendor__0.agency_id,
    all_agreement_transactions_by_prime_sub_vendor__0.agency_name,
    all_agreement_transactions_by_prime_sub_vendor__0.agency_code,
    all_agreement_transactions_by_prime_sub_vendor__0.vendor_record_type, -- is_prime_or_sub
    all_agreement_transactions_by_prime_sub_vendor__0.award_method_id,
    all_agreement_transactions_by_prime_sub_vendor__0.award_method_code ,
    all_agreement_transactions_by_prime_sub_vendor__0.award_method_name,
    all_agreement_transactions_by_prime_sub_vendor__0.award_size_id,
    all_agreement_transactions_by_prime_sub_vendor__0.expenditure_object_codes, -- expense_category
    all_agreement_transactions_by_prime_sub_vendor__0.expenditure_object_names,
    all_agreement_transactions_by_prime_sub_vendor__0.industry_type_id,
    all_agreement_transactions_by_prime_sub_vendor__0.industry_type_name,
    all_agreement_transactions_by_prime_sub_vendor__0.brd_awd_no, -- apt_pin
    all_agreement_transactions_by_prime_sub_vendor__0.tracking_number, -- pin
    all_agreement_transactions_by_prime_sub_vendor__0.registered_year,
    all_agreement_transactions_by_prime_sub_vendor__0.registered_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.registered_date,
    all_agreement_transactions_by_prime_sub_vendor__0.registered_date_id,
    all_agreement_transactions_by_prime_sub_vendor__0.starting_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.ending_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.effective_begin_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.effective_end_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.latest_flag,
    all_agreement_transactions_by_prime_sub_vendor__0.version,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_apt_pin,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_pin,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_vendor_type,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_purpose, 
    all_agreement_transactions_by_prime_sub_vendor__0.prime_original_contract_amount, 
    all_agreement_transactions_by_prime_sub_vendor__0.prime_maximum_contract_amount, -- prime_current_amount
    all_agreement_transactions_by_prime_sub_vendor__0.prime_amount_id,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_amount_name,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_dollar_difference,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_percent_difference,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_document_version,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_vendor_id,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_vendor_code,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_vendor_name,
    all_agreement_transactions_by_prime_sub_vendor__0.associated_prime_vendor_code,
    all_agreement_transactions_by_prime_sub_vendor__0.associated_prime_vendor_name,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_minority_type_id,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_minority_type_name,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_mwbe_adv_search_id,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_mwbe_adv_search,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_rfed_amount, -- prime_spent_to_date
    all_agreement_transactions_by_prime_sub_vendor__0.prime_starting_year,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_starting_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_ending_year,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_ending_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_effective_begin_date,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_effective_begin_date_id,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_effective_begin_year,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_effective_begin_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_effective_end_date,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_effective_end_date_id,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_effective_end_year,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_effective_end_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_industry_type_id,
    all_agreement_transactions_by_prime_sub_vendor__0.prime_industry_type_name,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_vendor_type,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_vendor_id,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_vendor_code,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_vendor_name,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_vendor_name_export,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_minority_type_id,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_minority_type_name,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_minority_type_name_export,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_purpose,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_purpose_export,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_apt_pin,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_pin,
    all_agreement_transactions_by_prime_sub_vendor__0.aprv_sta, -- subcontract_status_in_pip
    all_agreement_transactions_by_prime_sub_vendor__0.aprv_sta_name,
    all_agreement_transactions_by_prime_sub_vendor__0.aprv_sta_name_export,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_original_contract_amount,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_maximum_contract_amount,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_amount_id,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_amount_name,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_dollar_difference,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_percent_difference,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_rfed_amount,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_starting_year,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_starting_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_ending_year,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_ending_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_effective_begin_date,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_effective_begin_date_export,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_effective_begin_date_id,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_effective_begin_year,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_effective_begin_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_effective_end_date,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_effective_end_date_export,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_effective_end_date_id,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_effective_end_year,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_effective_end_year_id,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_document_version,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_contract_id,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_contract_id_export,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_industry_type_id,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_industry_type_name,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_industry_type_name_export,
    all_agreement_transactions_by_prime_sub_vendor__0.sub_latest_flag
    FROM  all_agreement_transactions_by_prime_sub_vendor__0; 


SET search_path = public;


CREATE INDEX idx_original_agreement_id_history_agreement ON history_agreement(original_agreement_id);
CREATE INDEX idx_master_agreement_id_history_agreement ON history_agreement(master_agreement_id);
CREATE INDEX idx_latest_flag_history_agreement ON history_agreement(latest_flag); 

CREATE INDEX idx_vendor_id_agr_snapshot ON agreement_snapshot(vendor_id);
CREATE INDEX idx_vendor_name_agr_snapshot ON agreement_snapshot(vendor_name);
CREATE INDEX idx_agency_id_agr_snapshot ON agreement_snapshot(agency_id);
CREATE INDEX idx_award_method_id_agr_snapshot ON agreement_snapshot(award_method_id);
CREATE INDEX idx_award_category_id_agr_snapshot ON agreement_snapshot(award_category_id);


CREATE INDEX idx_vendor_id_agr_snapshot_cy ON agreement_snapshot_cy(vendor_id);
CREATE INDEX idx_vendor_name_agr_snapshot_cy ON agreement_snapshot_cy(vendor_name);
CREATE INDEX idx_agency_id_agr_snapshot_cy ON agreement_snapshot_cy(agency_id);
CREATE INDEX idx_award_method_id_agr_snapshot_cy ON agreement_snapshot_cy(award_method_id);
CREATE INDEX idx_award_category_id_agr_snapshot_cy ON agreement_snapshot_cy(award_category_id);

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

-- copy indexes for above public tables from shard_public.sql

-- Production
--select grantaccess('apache','SELECT');

-- Table used for mapping 'aprv_sta' 

DROP TABLE IF EXISTS subcontract_approval_status;

CREATE TABLE subcontract_approval_status
(
aprv_sta_id smallint,
aprv_sta_value character varying,
sort_order smallint
)DISTRIBUTED BY(aprv_sta_id);


INSERT INTO subcontract_approval_status(
        aprv_sta_id, aprv_sta_value, sort_order
)VALUES(6,'No Subcontract Information Submitted',1);


INSERT INTO subcontract_approval_status(
        aprv_sta_id, aprv_sta_value, sort_order
)VALUES(1, 'No Subcontract Payments Submitted', 2);

INSERT INTO subcontract_approval_status(
        aprv_sta_id, aprv_sta_value, sort_order
)VALUES(4, 'ACCO Approved Sub Vendor', 3);

INSERT INTO subcontract_approval_status(
        aprv_sta_id, aprv_sta_value, sort_order
)VALUES(3, 'ACCO Reviewing Sub Vendor', 4);

INSERT INTO subcontract_approval_status(
        aprv_sta_id, aprv_sta_value, sort_order
)VALUES(2, 'ACCO Rejected Sub Vendor', 5);

INSERT INTO subcontract_approval_status(
        aprv_sta_id, aprv_sta_value, sort_order
)VALUES(5, 'ACCO Canceled Sub Vendor', 6);

INSERT INTO subcontract_approval_status(
        aprv_sta_id, aprv_sta_value, sort_order
)VALUES(7, 'N/A', 7);

GRANT ALL ON TABLE subcontract_approval_status TO gpadmin;
GRANT SELECT ON TABLE subcontract_approval_status TO webuser1;

select grantaccess('webuser1','SELECT');

