-- To add the "scntrc_status" field

-- history_agreement 
SET search_path = public;

-- adding scntrc_status fields to history_agreement

DROP TABLE IF EXISTS history_agreement_backup;

CREATE TABLE history_agreement_backup as SELECT * FROM history_agreement
DISTRIBUTED BY (agreement_id);


DROP TABLE history_agreement CASCADE;

CREATE TABLE history_agreement
(
  agreement_id bigint NOT NULL DEFAULT nextval('seq_agreement_agreement_id'::regclass),
  master_agreement_id bigint,
  document_code_id smallint,
  agency_history_id smallint,
  document_id character varying(20),
  document_version integer,
  tracking_number character varying(30),
  record_date_id integer,
  budget_fiscal_year smallint,
  document_fiscal_year smallint,
  document_period character(2),
  description character varying(60),
  actual_amount_original numeric(16,2),
  actual_amount numeric(16,2),
  obligated_amount_original numeric(16,2),
  obligated_amount numeric(16,2),
  maximum_contract_amount_original numeric(16,2),
  maximum_contract_amount numeric(16,2),
  amendment_number character varying(19),
  replacing_agreement_id bigint,
  replaced_by_agreement_id bigint,
  award_status_id smallint,
  procurement_id character varying(20),
  procurement_type_id smallint,
  effective_begin_date_id integer,
  effective_end_date_id integer,
  reason_modification character varying,
  source_created_date_id integer,
  source_updated_date_id integer,
  document_function_code character varying,
  award_method_id smallint,
  award_level_code character varying,
  agreement_type_id smallint,
  contract_class_code character varying(2),
  award_category_id_1 smallint,
  award_category_id_2 smallint,
  award_category_id_3 smallint,
  award_category_id_4 smallint,
  award_category_id_5 smallint,
  number_responses integer,
  location_service character varying(255),
  location_zip character varying(10),
  borough_code character varying(10),
  block_code character varying(10),
  lot_code character varying(10),
  council_district_code character varying(10),
  vendor_history_id integer,
  vendor_preference_level integer,
  original_contract_amount_original numeric(16,2),
  original_contract_amount numeric(16,2),
  registered_date_id integer,
  oca_number character varying(20),
  number_solicitation integer,
  document_name character varying(60),
  original_term_begin_date_id integer,
  original_term_end_date_id integer,
  brd_awd_no character varying,
  rfed_amount_original numeric(16,2),
  rfed_amount numeric(16,2),
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
  contract_number character varying,
  original_agreement_id bigint,
  original_version_flag character(1),
  latest_flag character(1),
  scntrc_status smallint,
  privacy_flag character(1),
  created_load_id integer,
  updated_load_id integer,
  created_date timestamp without time zone,
  updated_date timestamp without time zone,
  CONSTRAINT history_agreement_pkey PRIMARY KEY (agreement_id)
)DISTRIBUTED BY (agreement_id);

INSERT INTO history_agreement(
            agreement_id, master_agreement_id, document_code_id, agency_history_id, 
            document_id, document_version, tracking_number, record_date_id, 
            budget_fiscal_year, document_fiscal_year, document_period, description, 
            actual_amount_original, actual_amount, obligated_amount_original, 
            obligated_amount, maximum_contract_amount_original, maximum_contract_amount, 
            amendment_number, replacing_agreement_id, replaced_by_agreement_id, 
            award_status_id, procurement_id, procurement_type_id, effective_begin_date_id, 
            effective_end_date_id, reason_modification, source_created_date_id, 
            source_updated_date_id, document_function_code, award_method_id, 
            award_level_code, agreement_type_id, contract_class_code, award_category_id_1, 
            award_category_id_2, award_category_id_3, award_category_id_4, 
            award_category_id_5, number_responses, location_service, location_zip, 
            borough_code, block_code, lot_code, council_district_code, vendor_history_id, 
            vendor_preference_level, original_contract_amount_original, original_contract_amount, 
            registered_date_id, oca_number, number_solicitation, document_name, 
            original_term_begin_date_id, original_term_end_date_id, brd_awd_no, 
            rfed_amount_original, rfed_amount, registered_fiscal_year, registered_fiscal_year_id, 
            registered_calendar_year, registered_calendar_year_id, effective_end_fiscal_year, 
            effective_end_fiscal_year_id, effective_end_calendar_year, effective_end_calendar_year_id, 
            effective_begin_fiscal_year, effective_begin_fiscal_year_id, 
            effective_begin_calendar_year, effective_begin_calendar_year_id, 
            source_updated_fiscal_year, source_updated_fiscal_year_id, source_updated_calendar_year, 
            source_updated_calendar_year_id, contract_number, original_agreement_id, 
            original_version_flag, latest_flag, privacy_flag, created_load_id, 
            updated_load_id, created_date, updated_date, scntrc_status)
  SELECT agreement_id, master_agreement_id, document_code_id, agency_history_id, 
           document_id, document_version, tracking_number, record_date_id, 
           budget_fiscal_year, document_fiscal_year, document_period, description, 
           actual_amount_original, actual_amount, obligated_amount_original, 
           obligated_amount, maximum_contract_amount_original, maximum_contract_amount, 
           amendment_number, replacing_agreement_id, replaced_by_agreement_id, 
           award_status_id, procurement_id, procurement_type_id, effective_begin_date_id, 
           effective_end_date_id, reason_modification, source_created_date_id, 
           source_updated_date_id, document_function_code, award_method_id, 
           award_level_code, agreement_type_id, contract_class_code, award_category_id_1, 
           award_category_id_2, award_category_id_3, award_category_id_4, 
           award_category_id_5, number_responses, location_service, location_zip, 
           borough_code, block_code, lot_code, council_district_code, vendor_history_id, 
           vendor_preference_level, original_contract_amount_original, original_contract_amount, 
           registered_date_id, oca_number, number_solicitation, document_name, 
           original_term_begin_date_id, original_term_end_date_id, brd_awd_no, 
           rfed_amount_original, rfed_amount, registered_fiscal_year, registered_fiscal_year_id, 
           registered_calendar_year, registered_calendar_year_id, effective_end_fiscal_year, 
           effective_end_fiscal_year_id, effective_end_calendar_year, effective_end_calendar_year_id, 
           effective_begin_fiscal_year, effective_begin_fiscal_year_id, 
           effective_begin_calendar_year, effective_begin_calendar_year_id, 
           source_updated_fiscal_year, source_updated_fiscal_year_id, source_updated_calendar_year, 
           source_updated_calendar_year_id, contract_number, original_agreement_id, 
           original_version_flag, latest_flag, privacy_flag, created_load_id, 
           updated_load_id, created_date, updated_date, NULL as scntrc_status
      FROM history_agreement_backup;


-- UPDATE history_agreement a
-- SET scntrc_status = NULL
-- one time update strntc_sta = 1
UPDATE history_agreement a
SET scntrc_status = 1
FROM ref_date b,ref_document_code c
WHERE a.effective_end_date_id=b.date_id 
AND a.document_code_id=c.document_code_id
AND  a.latest_flag='Y' AND b.date >= '2015-07-01' 
AND c.document_code in ('CT1','CTA1','CT2');

-- one time update

-- update the scntrc_status field with subcontract_status data
UPDATE history_agreement a
SET scntrc_status = b.scntrc_status
FROM subcontract_status b, ref_document_code c,ref_date d
WHERE a.contract_number = b.contract_number 
AND a.document_code_id=c.document_code_id 
AND a.effective_end_date_id=d.date_id
AND a.latest_flag='Y' AND d.date >= '2015-07-01'
AND c.document_code in ('CT1','CTA1','CT2');

-- test queries, do not execute

/*
select scntrc_status,count(*) FROM history_agreement a, ref_date b,ref_document_code c
 WHERE a.effective_end_date_id=b.date_id AND a.document_code_id=c.document_code_id
AND  a.latest_flag='Y' AND b.date >= '2015-07-01' AND c.document_code in ('CT1','CTA1','CT2')
group by 1

select a.scntrc_status,count(*)
FROM history_agreement a, subcontract_status b, ref_document_code c,ref_date d
WHERE a.contract_number = b.contract_number AND a.document_code_id=c.document_code_id AND a.effective_end_date_id=d.date_id
AND a.latest_flag='Y' AND d.date >= '2015-07-01'
AND c.document_code in ('CT1','CTA1','CT2') group by 1
*/


-- agreement_snapshot 
SET search_path = public;

DROP TABLE IF EXISTS agreement_snapshot_backup;

CREATE TABLE agreement_snapshot_backup as SELECT * FROM agreement_snapshot
DISTRIBUTED BY (original_agreement_id);

DROP TABLE agreement_snapshot CASCADE;

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


INSERT INTO agreement_snapshot(
            original_agreement_id, document_version, document_code_id, agency_history_id, 
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
            master_agreement_yn, has_children, has_mwbe_children, original_version_flag, 
            latest_flag, load_id, last_modified_date, job_id, scntrc_status)
    	SELECT original_agreement_id, document_version, document_code_id, agency_history_id, 
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
       master_agreement_yn, has_children, has_mwbe_children, original_version_flag, 
       latest_flag, load_id, last_modified_date, job_id, NULL as scntrc_status
  FROM agreement_snapshot_backup;


-- one time update to set scntrc_status = 1
UPDATE agreement_snapshot a
SET scntrc_status = 1
FROM ref_document_code c
WHERE a.latest_flag='Y' 
AND a.effective_end_date >= '2015-07-01'
AND a.document_code_id=c.document_code_id 
AND c.document_code in ('CT1','CTA1','CT2');

-- update from subcontract_status table
UPDATE agreement_snapshot a
SET scntrc_status = b.scntrc_status
FROM subcontract_status b, ref_document_code c
WHERE a.contract_number = b.contract_number 
AND a.document_code_id=c.document_code_id
AND a.latest_flag='Y' 
AND a.effective_end_date >= '2015-07-01'
AND c.document_code in ('CT1','CTA1','CT2');




/** test sql
select scntrc_status, count(*)
FROM agreement_snapshot a,ref_document_code c
WHERE a.latest_flag='Y' AND a.effective_end_date >= '2015-07-01'
AND a.document_code_id=c.document_code_id AND c.document_code in ('CT1','CTA1','CT2') group by 1
**/


-- agreement_snapshot_cy
SET search_path = public;

DROP TABLE IF EXISTS agreement_snapshot_cy_backup;

CREATE TABLE agreement_snapshot_cy_backup as SELECT * FROM agreement_snapshot_cy
DISTRIBUTED BY (original_agreement_id);

DROP TABLE IF EXISTS agreement_snapshot_cy;

CREATE TABLE agreement_snapshot_cy
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

INSERT INTO agreement_snapshot_cy(
            original_agreement_id, document_version, document_code_id, agency_history_id, 
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
            master_agreement_yn, has_children, has_mwbe_children, original_version_flag, 
            latest_flag, load_id, last_modified_date, job_id, scntrc_status)
        SELECT 
        original_agreement_id, document_version, document_code_id, agency_history_id, 
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
      master_agreement_yn, has_children, has_mwbe_children, original_version_flag, 
      latest_flag, load_id, last_modified_date, job_id, NULL as scntrc_status
  FROM agreement_snapshot_cy_backup;

-- one time update to set scntrc_status = 1
UPDATE agreement_snapshot_cy a
SET scntrc_status = 1
FROM ref_document_code c
WHERE a.latest_flag='Y' 
AND a.effective_end_date >= '2015-07-01'
AND a.document_code_id=c.document_code_id 
AND c.document_code in ('CT1','CTA1','CT2');

-- update from subcontract_status table
UPDATE agreement_snapshot_cy a
SET scntrc_status = b.scntrc_status
FROM subcontract_status b, ref_document_code c
WHERE a.contract_number = b.contract_number 
AND a.document_code_id=c.document_code_id
AND a.latest_flag='Y' 
AND a.effective_end_date >= '2015-07-01'
AND c.document_code in ('CT1','CTA1','CT2');


-- sub agreement snapshot

-- agreement_snapshot 
SET search_path = public;

DROP TABLE IF EXISTS sub_agreement_snapshot_backup;

CREATE TABLE sub_agreement_snapshot_backup as SELECT * FROM sub_agreement_snapshot
DISTRIBUTED BY (original_agreement_id);

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


INSERT INTO sub_agreement_snapshot(
            original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, sub_contract_id, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, prime_vendor_id, prime_minority_type_id, 
            prime_minority_type_name, dollar_difference, percent_difference, 
            agreement_type_id, agreement_type_code, agreement_type_name, 
            award_category_id, award_category_code, award_category_name, 
            award_method_id, award_method_code, award_method_name, expenditure_object_codes, 
            expenditure_object_names, industry_type_id, industry_type_name, 
            award_size_id, effective_begin_date, effective_begin_date_id, 
            effective_begin_year, effective_begin_year_id, effective_end_date, 
            effective_end_date_id, effective_end_year, effective_end_year_id, 
            registered_date, registered_date_id, brd_awd_no, tracking_number, 
            rfed_amount, minority_type_id, minority_type_name, original_version_flag, 
            master_agreement_id, master_contract_number, latest_flag, load_id, 
            last_modified_date, job_id, aprv_sta)
      SELECT original_agreement_id, document_version, document_code_id, agency_history_id, 
       agency_id, agency_code, agency_name, agreement_id, starting_year, 
       starting_year_id, ending_year, ending_year_id, registered_year, 
       registered_year_id, contract_number, sub_contract_id, original_contract_amount, 
       maximum_contract_amount, description, vendor_history_id, vendor_id, 
       vendor_code, vendor_name, prime_vendor_id, prime_minority_type_id, 
       prime_minority_type_name, dollar_difference, percent_difference, 
       agreement_type_id, agreement_type_code, agreement_type_name, 
       award_category_id, award_category_code, award_category_name, 
       award_method_id, award_method_code, award_method_name, expenditure_object_codes, 
       expenditure_object_names, industry_type_id, industry_type_name, 
       award_size_id, effective_begin_date, effective_begin_date_id, 
       effective_begin_year, effective_begin_year_id, effective_end_date, 
       effective_end_date_id, effective_end_year, effective_end_year_id, 
       registered_date, registered_date_id, brd_awd_no, tracking_number, 
       rfed_amount, minority_type_id, minority_type_name, original_version_flag, 
       master_agreement_id, master_contract_number, latest_flag, load_id, 
       last_modified_date, job_id, NULL as aprv_sta
  FROM sub_agreement_snapshot_backup;

-- update from subcontract_status table
UPDATE sub_agreement_snapshot a
SET aprv_sta = b.aprv_sta
FROM subcontract_details b
WHERE a.contract_number = b.contract_number 
AND a.sub_contract_id=b.sub_contract_id;

-- agreement_snapshot_expanded

SET search_path = public;


DROP TABLE IF EXISTS agreement_snapshot_expanded_backup;

CREATE TABLE agreement_snapshot_expanded_backup as SELECT * FROM agreement_snapshot_expanded
DISTRIBUTED BY (agreement_id);


DROP TABLE agreement_snapshot_expanded;

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


INSERT INTO agreement_snapshot_expanded(
            original_agreement_id, agreement_id, fiscal_year, description, 
            contract_number, vendor_id, agency_id, industry_type_id, award_size_id, 
            original_contract_amount, maximum_contract_amount, rfed_amount, 
            starting_year, ending_year, dollar_difference, percent_difference, 
            award_method_id, document_code_id, master_agreement_id, minority_type_id, 
            minority_type_name, master_agreement_yn, status_flag, scntrc_status)
    SELECT 
      original_agreement_id, agreement_id, fiscal_year, description, 
      contract_number, vendor_id, agency_id, industry_type_id, award_size_id, 
      original_contract_amount, maximum_contract_amount, rfed_amount, 
      starting_year, ending_year, dollar_difference, percent_difference, 
      award_method_id, document_code_id, master_agreement_id, minority_type_id, 
      minority_type_name, master_agreement_yn, status_flag, NULL as scntrc_status
  FROM agreement_snapshot_expanded_backup;



-- agreement_snapshot_expanded_cy 
SET search_path = public;

DROP TABLE IF EXISTS agreement_snapshot_expanded_cy_backup;

CREATE TABLE agreement_snapshot_expanded_cy_backup as SELECT * FROM agreement_snapshot_expanded_cy
DISTRIBUTED BY (original_agreement_id);

DROP TABLE agreement_snapshot_expanded_cy;

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

INSERT INTO agreement_snapshot_expanded_cy(
            original_agreement_id, agreement_id, fiscal_year, description, 
            contract_number, vendor_id, agency_id, industry_type_id, award_size_id, 
            original_contract_amount, maximum_contract_amount, rfed_amount, 
            starting_year, ending_year, dollar_difference, percent_difference, 
            award_method_id, document_code_id, master_agreement_id, minority_type_id, 
            minority_type_name, master_agreement_yn, status_flag, scntrc_status)
    SELECT original_agreement_id, agreement_id, fiscal_year, description, 
       contract_number, vendor_id, agency_id, industry_type_id, award_size_id, 
       original_contract_amount, maximum_contract_amount, rfed_amount, 
       starting_year, ending_year, dollar_difference, percent_difference, 
       award_method_id, document_code_id, master_agreement_id, minority_type_id, 
       minority_type_name, master_agreement_yn, status_flag, NULL as scntrc_status
  FROM agreement_snapshot_expanded_cy_backup;


/** test sql
select scntrc_status, count(*)
FROM agreement_snapshot_cy a,ref_document_code c
WHERE a.latest_flag='Y' AND a.effective_end_date >= '2015-07-01'
AND a.document_code_id=c.document_code_id AND c.document_code in ('CT1','CTA1','CT2') group by 1
**/


-- all_agreemnt_transactions
SET search_path = public;

-- adding scntrc_status fields to all_agreemnt_transactions

DROP TABLE IF EXISTS all_agreement_transactions_backup;

CREATE TABLE all_agreement_transactions_backup as SELECT * FROM all_agreement_transactions
DISTRIBUTED BY (original_agreement_id);


DROP TABLE  all_agreement_transactions;

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

INSERT INTO all_agreement_transactions(
            original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, sub_contract_id, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, prime_vendor_id, prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name, dollar_difference, 
            percent_difference, master_agreement_id, master_contract_number, 
            agreement_type_id, agreement_type_code, agreement_type_name, 
            award_category_id, award_category_code, award_category_name, 
            award_method_id, award_method_code, award_method_name, expenditure_object_codes, 
            expenditure_object_names, industry_type_id, industry_type_name, 
            award_size_id, effective_begin_date, effective_begin_date_id, 
            effective_begin_year, effective_begin_year_id, effective_end_date, 
            effective_end_date_id, effective_end_year, effective_end_year_id, 
            registered_date, registered_date_id, brd_awd_no, tracking_number, 
            rfed_amount, minority_type_id, minority_type_name, master_agreement_yn, 
            has_children, has_mwbe_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, last_modified_year_id, is_prime_or_sub, 
            is_minority_vendor, vendor_type, contract_original_agreement_id, 
            is_subvendor, associated_prime_vendor_name, mwbe_category_ui, 
            job_id, scntrc_status, scntrc_status_name, aprv_sta, aprv_sta_name)
     SELECT original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, sub_contract_id, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, prime_vendor_id, prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name, dollar_difference, 
            percent_difference, master_agreement_id, master_contract_number, 
            agreement_type_id, agreement_type_code, agreement_type_name, 
            award_category_id, award_category_code, award_category_name, 
            award_method_id, award_method_code, award_method_name, expenditure_object_codes, 
            expenditure_object_names, industry_type_id, industry_type_name, 
            award_size_id, effective_begin_date, effective_begin_date_id, 
            effective_begin_year, effective_begin_year_id, effective_end_date, 
            effective_end_date_id, effective_end_year, effective_end_year_id, 
            registered_date, registered_date_id, brd_awd_no, tracking_number, 
            rfed_amount, minority_type_id, minority_type_name, master_agreement_yn, 
            has_children, has_mwbe_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, last_modified_year_id, is_prime_or_sub, 
            is_minority_vendor, vendor_type, contract_original_agreement_id, 
            is_subvendor, associated_prime_vendor_name, mwbe_category_ui, 
            job_id, NULL as scntrc_status, NULL as scntrc_status_name, NULL as aprv_sta, NULL as aprv_sta_name 
            FROM all_agreement_transactions_backup;


-- all_agreement_transactions_cy
SET search_path = public;

-- adding scntrc_status fields to all_agreemnt_transactions

DROP TABLE IF EXISTS all_agreement_transactions_cy_backup;

CREATE TABLE all_agreement_transactions_cy_backup as SELECT * FROM all_agreement_transactions_cy
DISTRIBUTED BY (original_agreement_id);


DROP TABLE  all_agreement_transactions_cy;

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

INSERT INTO all_agreement_transactions_cy(
            original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, sub_contract_id, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, prime_vendor_id, prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name, dollar_difference, 
            percent_difference, master_agreement_id, master_contract_number, 
            agreement_type_id, agreement_type_code, agreement_type_name, 
            award_category_id, award_category_code, award_category_name, 
            award_method_id, award_method_code, award_method_name, expenditure_object_codes, 
            expenditure_object_names, industry_type_id, industry_type_name, 
            award_size_id, effective_begin_date, effective_begin_date_id, 
            effective_begin_year, effective_begin_year_id, effective_end_date, 
            effective_end_date_id, effective_end_year, effective_end_year_id, 
            registered_date, registered_date_id, brd_awd_no, tracking_number, 
            rfed_amount, minority_type_id, minority_type_name, master_agreement_yn, 
            has_children, has_mwbe_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, last_modified_year_id, is_prime_or_sub, 
            is_minority_vendor, vendor_type, contract_original_agreement_id, 
            is_subvendor, associated_prime_vendor_name, mwbe_category_ui, 
            job_id, scntrc_status, scntrc_status_name)
     SELECT original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, sub_contract_id, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, prime_vendor_id, prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name, dollar_difference, 
            percent_difference, master_agreement_id, master_contract_number, 
            agreement_type_id, agreement_type_code, agreement_type_name, 
            award_category_id, award_category_code, award_category_name, 
            award_method_id, award_method_code, award_method_name, expenditure_object_codes, 
            expenditure_object_names, industry_type_id, industry_type_name, 
            award_size_id, effective_begin_date, effective_begin_date_id, 
            effective_begin_year, effective_begin_year_id, effective_end_date, 
            effective_end_date_id, effective_end_year, effective_end_year_id, 
            registered_date, registered_date_id, brd_awd_no, tracking_number, 
            rfed_amount, minority_type_id, minority_type_name, master_agreement_yn, 
            has_children, has_mwbe_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, last_modified_year_id, is_prime_or_sub, 
            is_minority_vendor, vendor_type, contract_original_agreement_id, 
            is_subvendor, associated_prime_vendor_name, mwbe_category_ui, 
            job_id, NULL as scntrc_status, NULL as scntrc_status_name 
            FROM all_agreement_transactions_cy_backup;



            DROP TABLE IF EXISTS subcontract_status_by_prime_contract_id;
            
            CREATE TABLE subcontract_status_by_prime_contract_id (
            original_agreement_id bigint,
            contract_number varchar,
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
            latest_flag char(1)
            )
            DISTRIBUTED BY (original_agreement_id);


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

GRANT ALL ON TABLE subcontract_approval_status TO gpadmin;
GRANT SELECT ON TABLE subcontract_approval_status TO webuser1;

select etl.grantaccess('webuser1', 'SELECT');



