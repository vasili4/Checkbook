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

TRUNCATE TABLE all_agreement_transactions_by_prime_sub_vendor;

INSERT INTO all_agreement_transactions_by_prime_sub_vendor (
	agreement_id,
	original_agreement_id,
	contract_original_agreement_id,
  	contract_number, 
  	scntrc_status, -- contract_include_subvendor
	scntrc_status_name, 
	master_agreement_yn,  
	master_agreement_id,
	master_contract_number, -- Parent_ contract_id
	master_contract_number_export,
	has_children,
	has_mwbe_children,
	document_code_id ,
	document_code,
	agency_id,
	agency_name,
	agency_code,
	vendor_record_type, -- is_prime_or_sub
	agreement_type_id,
	agreement_type_code,
	agreement_type_name, -- contract_type
	award_method_id,
	award_method_code,
	award_method_name,
	award_size_id,
	expenditure_object_codes, -- expense_category
	expenditure_object_names,
	industry_type_id,
	industry_type_name,
	brd_awd_no, -- apt_pin
	tracking_number, -- pin
	registered_year,
	registered_year_id,
 	registered_date,
	registered_date_id,
	starting_year_id,
	ending_year_id,
	effective_begin_year_id,
	effective_end_year_id, 
	latest_flag,
	version,
    prime_apt_pin,
    prime_pin,
	prime_vendor_type,
	prime_purpose, 
	prime_original_contract_amount, 
	prime_maximum_contract_amount, -- prime_current_amount
	prime_amount_id,
	prime_amount_name,
	prime_dollar_difference,
	prime_percent_difference,
	prime_document_version,
	prime_vendor_id,
	prime_vendor_code,
	prime_vendor_name,
	associated_prime_vendor_code,
	associated_prime_vendor_name,
	prime_minority_type_id,
	prime_minority_type_name,
	prime_mwbe_adv_search_id,
	prime_mwbe_adv_search,
	prime_rfed_amount, -- prime_spent_to_date
	prime_starting_year,
	prime_starting_year_id,
	prime_ending_year,
	prime_ending_year_id,
	prime_effective_begin_date,
	prime_effective_begin_date_id,
	prime_effective_begin_year,
	prime_effective_begin_year_id,
	prime_effective_end_date,
	prime_effective_end_date_id,
	prime_effective_end_year,
	prime_effective_end_year_id,
    prime_industry_type_id,
	prime_industry_type_name,
	sub_vendor_type,
	sub_vendor_id,
	sub_vendor_code,
	sub_vendor_name,
	sub_vendor_name_export,
	sub_minority_type_id,
	sub_minority_type_name,
	sub_minority_type_name_export,
	sub_purpose,
	sub_purpose_export,
    sub_apt_pin,
    sub_pin,
	aprv_sta, -- subcontract_status_in_pip
	aprv_sta_name,
	aprv_sta_name_export,
	sub_original_contract_amount,
	sub_maximum_contract_amount,
	sub_amount_id,
	sub_amount_name,
	sub_dollar_difference,
	sub_percent_difference,
	sub_rfed_amount,
	sub_starting_year,
	sub_starting_year_id,
	sub_ending_year,
	sub_ending_year_id,
	sub_effective_begin_date,
	sub_effective_begin_date_export,
	sub_effective_begin_date_id,
	sub_effective_begin_year,
	sub_effective_begin_year_id,
	sub_effective_end_date,
	sub_effective_end_date_export,
	sub_effective_end_date_id,
	sub_effective_end_year,
	sub_effective_end_year_id,
	sub_document_version,
	sub_contract_id,
	sub_contract_id_export,
	sub_industry_type_id,
	sub_industry_type_name,
	sub_industry_type_name_export,
	sub_latest_flag
)
--SELECT count(*) FROM(
SELECT 
a.agreement_id,
a.original_agreement_id,
a.contract_original_agreement_id,
a.contract_number,
CASE WHEN d.document_code in ('CT1', 'CT2', 'CTA1') THEN a.scntrc_status ELSE 5 END AS scntrc_status,
CASE WHEN d.document_code in ('CT1', 'CT2', 'CTA1') THEN a.scntrc_status_name ELSE 'N/A' END AS scntrc_status_name,
a.master_agreement_yn,
a.master_agreement_id,
a.master_contract_number,
CASE WHEN a.master_contract_number IS NULL THEN '-' ELSE a.master_contract_number END AS master_contract_number_export,
a.has_children,
a.has_mwbe_children,
a.document_code_id,
d.document_code,
a.agency_id,
a.agency_name,
a.agency_code,
CASE WHEN a.is_prime_or_sub = 'P' THEN 'Prime Vendor' ELSE 'Sub Vendor' END as vendor_record_type,
a.agreement_type_id,
a.agreement_type_code,
a.agreement_type_name,
a.award_method_id,
a.award_method_code,
a.award_method_name,
a.award_size_id,
a.expenditure_object_codes,
a.expenditure_object_names,
a.industry_type_id,
a.industry_type_name,
a.brd_awd_no,
a.tracking_number,
a.registered_year,
a.registered_year_id,
a.registered_date,
a.registered_date_id,
a.starting_year_id,
a.ending_year_id,
a.effective_begin_year_id,
a.effective_end_year_id,
a.latest_flag,
a.document_version as version,
e.brd_awd_no as prime_apt_pin,
e.tracking_number as prime_pin,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.vendor_type ELSE 'N/A' END as prime_vendor_type,
e.description as prime_purpose,
CASE WHEN a.is_prime_or_sub = 'P' THEN COALESCE(a.original_contract_amount,0) ELSE 0 END as prime_original_contract_amount,
CASE WHEN a.is_prime_or_sub = 'P' THEN COALESCE(a.maximum_contract_amount,0) ELSE 0 END as prime_maximum_contract_amount,
CASE
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) > 100000000 THEN 1
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) > 50000000 AND COALESCE(a.maximum_contract_amount,0) <= 100000000 THEN 2
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) > 25000000 AND COALESCE(a.maximum_contract_amount,0) <= 50000000 THEN 3
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) > 10000000 AND COALESCE(a.maximum_contract_amount,0) <= 25000000 THEN 4
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) >= 1000000 AND COALESCE(a.maximum_contract_amount,0) <= 10000000 THEN 5
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) < 1000000 THEN 6
END as prime_amount_id,
CASE
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) > 100000000 THEN 'Greater than $100M'
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) > 50000000 AND COALESCE(a.maximum_contract_amount,0) <= 100000000 THEN '$51M - $100M'
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) > 25000000 AND COALESCE(a.maximum_contract_amount,0) <= 50000000 THEN '$26M - $50M'
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) > 10000000 AND COALESCE(a.maximum_contract_amount,0) <= 25000000 THEN '$11M - $25M'
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) >= 1000000 AND COALESCE(a.maximum_contract_amount,0) <= 10000000 THEN '$1M - $10M'
WHEN a.is_prime_or_sub = 'P' AND COALESCE(a.maximum_contract_amount,0) < 1000000 THEN 'Less than $1M'
END as prime_amount_name,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.dollar_difference ELSE 0 END as prime_dollar_difference,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.percent_difference ELSE 0 END as prime_percent_difference,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.document_version ELSE e.document_version END as prime_document_version,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.vendor_id ELSE e.vendor_id END as prime_vendor_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.vendor_code ELSE e.vendor_code END as prime_vendor_code,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.vendor_name ELSE e.vendor_name END as prime_vendor_name,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.vendor_code ELSE '-' END as associated_prime_vendor_code,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.vendor_name ELSE '-' END as associated_prime_vendor_name,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.minority_type_id ELSE e.minority_type_id END as prime_minority_type_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.mwbe_category_ui ELSE e.mwbe_category_ui END as prime_minority_type_name,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.minority_type_id END as prime_mwbe_adv_search_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.mwbe_category_ui ELSE '-' END as prime_mwbe_adv_search,
CASE WHEN a.is_prime_or_sub = 'P' THEN e.rfed_amount ELSE 0 END as prime_rfed_amount,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.starting_year ELSE e.starting_year END as prime_starting_year,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.starting_year_id ELSE e.starting_year_id END as prime_starting_year_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.ending_year ELSE e.ending_year END as prime_ending_year,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.ending_year_id ELSE e.ending_year_id END as prime_ending_year_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.effective_begin_date ELSE e.effective_begin_date END as prime_effective_begin_date,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.effective_begin_date_id ELSE e.effective_begin_date_id END as prime_effective_begin_date_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.effective_begin_year ELSE e.effective_begin_year END as prime_effective_begin_year,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.effective_begin_year_id ELSE e.effective_begin_year_id END as prime_effective_begin_year_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.effective_end_date ELSE e.effective_end_date END as prime_effective_end_date,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.effective_end_date_id ELSE e.effective_end_date_id END as prime_effective_end_date_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.effective_end_year ELSE e.effective_end_year END as prime_effective_end_year,
CASE WHEN a.is_prime_or_sub = 'P' THEN a.effective_end_year_id ELSE e.effective_end_year_id END as prime_effective_end_year_id,
e.industry_type_id as prime_industry_type_id,
e.industry_type_name as prime_industry_type_name,
CASE WHEN a.is_prime_or_sub = 'S' THEN a.vendor_type ELSE 'N/A' END as sub_vendor_type,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.vendor_id END as sub_vendor_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN 'N/A' ELSE b.vendor_code END as sub_vendor_code,
CASE WHEN a.is_prime_or_sub = 'P' THEN 'N/A' ELSE b.vendor_name END as sub_vendor_name,
CASE WHEN a.is_prime_or_sub = 'P' THEN  '-' ELSE b.vendor_name END AS sub_vendor_name_export,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.minority_type_id END as sub_minority_type_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN 'N/A' ELSE b.sub_mwbe_type_name END as sub_minority_type_name,
CASE WHEN a.is_prime_or_sub = 'P' THEN '-' ELSE b.sub_mwbe_type_name END AS sub_minority_type_name_export,
CASE WHEN a.is_prime_or_sub = 'P' THEN 'N/A' ELSE  b.description END as sub_purpose,
CASE WHEN a.is_prime_or_sub = 'P' THEN '-' ELSE b.description END AS sub_purpose_export,
CASE WHEN a.is_prime_or_sub = 'P' THEN 'N/A' ELSE a.brd_awd_no END as sub_apt_pin,
CASE WHEN a.is_prime_or_sub = 'P' THEN 'N/A' ELSE a.tracking_number END as sub_pin,
CASE WHEN a.is_prime_or_sub = 'P' THEN 
 (CASE WHEN a.scntrc_status = 2 AND (select count(*) from subcontract_details s where s.contract_number = a.contract_number) < 1 THEN c.aprv_sta_id  ELSE 0 END) 
ELSE c.aprv_sta_id  END AS aprv_sta,
CASE WHEN a.is_prime_or_sub = 'P' THEN 
 (CASE WHEN a.scntrc_status = 2 AND (select count(*) from subcontract_details s where s.contract_number = a.contract_number) < 1 THEN c.aprv_sta_value  ELSE 'N/A' END)
ELSE c.aprv_sta_value END AS aprv_sta_name,
CASE WHEN a.is_prime_or_sub = 'P' THEN
 (CASE WHEN a.scntrc_status = 2 AND (select count(*) from subcontract_details s where s.contract_number = a.contract_number) < 1 THEN c.aprv_sta_value  ELSE  '-' END)
ELSE c.aprv_sta_value END AS aprv_sta_name_export,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.original_contract_amount END as sub_original_contract_amount,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE COALESCE(b.maximum_contract_amount,0) END as sub_maximum_contract_amount,
CASE
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) > 100000000 THEN 1
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) > 50000000 AND COALESCE(b.maximum_contract_amount,0) <= 100000000 THEN 2
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) > 25000000 AND COALESCE(b.maximum_contract_amount,0) <= 50000000 THEN 3
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) > 10000000 AND COALESCE(b.maximum_contract_amount,0) <= 25000000 THEN 4
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) >= 1000000 AND COALESCE(b.maximum_contract_amount,0) <= 10000000 THEN 5
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) < 1000000 THEN 6
END as sub_amount_id,
CASE
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) > 100000000 THEN 'Greater than $100M'
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) > 50000000 AND COALESCE(b.maximum_contract_amount,0) <= 100000000 THEN '$51M - $100M'
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) > 25000000 AND COALESCE(b.maximum_contract_amount,0) <= 50000000 THEN '$26M - $50M'
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) > 10000000 AND COALESCE(b.maximum_contract_amount,0) <= 25000000 THEN '$11M - $25M'
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) >= 1000000 AND COALESCE(b.maximum_contract_amount,0) <= 10000000 THEN '$1M - $10M'
WHEN a.is_prime_or_sub = 'S' AND  COALESCE(b.maximum_contract_amount,0) < 1000000 THEN 'Less than $1M'
END as sub_amount_name,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.dollar_difference END as sub_dollar_difference,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.percent_difference END as sub_percent_difference,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.rfed_amount END as sub_rfed_amount,
b.starting_year as sub_starting_year,
b.starting_year_id as sub_starting_year_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.ending_year END as sub_ending_year,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.ending_year_id END as sub_ending_year_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN null ELSE b.effective_begin_date END as sub_effective_begin_date,
CASE WHEN a.is_prime_or_sub = 'P' THEN CAST('-' AS TEXT) ELSE  CAST(b.effective_begin_date AS TEXT)  END AS sub_effective_begin_date_export, --text
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.effective_begin_date_id END as sub_effective_begin_date_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.effective_begin_year END as sub_effective_begin_year,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.effective_begin_year_id END as sub_effective_begin_year_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN null ELSE b.effective_end_date END as sub_effective_end_date,
CASE WHEN a.is_prime_or_sub = 'P' THEN CAST('-' AS TEXT) ELSE  CAST(b.effective_end_date AS TEXT)  END AS sub_effective_end_date_export,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.effective_end_date_id END as sub_effective_end_date_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.effective_end_year END as sub_effective_end_year,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.effective_end_year_id END as sub_effective_end_year_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE b.document_version END as sub_document_version,
CASE WHEN a.is_prime_or_sub = 'P' THEN 'N/A' ELSE b.sub_contract_id END as sub_contract_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN '-' ELSE b.sub_contract_id END AS sub_contract_id_export,
CASE WHEN a.is_prime_or_sub = 'P' THEN 0 ELSE a.industry_type_id END AS sub_industry_type_id,
CASE WHEN a.is_prime_or_sub = 'P' THEN 'N/A' ELSE a.industry_type_name END AS sub_industry_type_name,
CASE WHEN a.is_prime_or_sub = 'P' THEN '-' ELSE a.industry_type_name END AS sub_industry_type_name_export,
CASE WHEN a.is_prime_or_sub = 'P' THEN e.latest_flag ELSE b.latest_flag END as sub_latest_flag
FROM all_agreement_transactions a
LEFT JOIN
(
	SELECT
	a.original_agreement_id,
	a.agreement_id,
	a.contract_number,
	a.vendor_id,
	a.vendor_name,
	a.vendor_type,
	a.vendor_code,
	a.sub_contract_id,
	a.minority_type_id,
	CASE
		WHEN a.minority_type_id = 2 THEN 'Black American'
		WHEN a.minority_type_id = 3 THEN 'Hispanic American'
		WHEN a.minority_type_id IN (4,5) THEN 'Asian American'
		WHEN a.minority_type_id = 7 THEN 'Non-M/WBE'
		WHEN a.minority_type_id = 9 THEN 'Women'
		WHEN a.minority_type_id = 11 THEN 'Individuals and Others'
  	END as sub_mwbe_type_name,
  	a.rfed_amount,
	a.starting_year,
	a.starting_year_id,
	a.ending_year,
	a.ending_year_id,
	a.effective_begin_date,
	a.effective_begin_date_id ,
	a.effective_begin_year,
	a.effective_begin_year_id ,
	a.effective_end_date,
	a.effective_end_date_id ,
	a.effective_end_year ,
	a.effective_end_year_id,
	a.aprv_sta,
	a.description,
	a.original_contract_amount,
	a.dollar_difference, 
	a.percent_difference,
	a.maximum_contract_amount,
	a.document_version,
	a.latest_flag,
	a.brd_awd_no,
	a.tracking_number,
	a.industry_type_id,
	a.industry_type_name
	FROM all_agreement_transactions a
) b on a.contract_number = b.contract_number and a.original_agreement_id = b.original_agreement_id and a.agreement_id = b.agreement_id
LEFT JOIN 
( SELECT 
    a.original_agreement_id,
	a.agreement_id,
	a.contract_number,
	a.description,
	a.rfed_amount,
	c.starting_year,
	c.starting_year_id,
	c.ending_year,
	c.ending_year_id,
	a.effective_begin_date,
	a.effective_begin_date_id ,
	a.effective_begin_year,
	a.effective_begin_year_id ,
	a.effective_end_date,
	a.effective_end_date_id ,
	a.effective_end_year ,
	a.effective_end_year_id,
	a.document_version,
	a.dollar_difference, 
	a.percent_difference,
	a.vendor_id,
	a.vendor_name,
	a.minority_type_id,
	a.original_contract_amount,
	a.maximum_contract_amount,
	a.tracking_number,
	a.brd_awd_no,
	a.vendor_code,
	a.mwbe_category_ui,
	a.industry_type_id,
	a.industry_type_name,
	a.latest_flag
	FROM all_agreement_transactions a
	LEFT JOIN (
	 SELECT MIN(starting_year) as starting_year,
	 MAX(ending_year) as ending_year, 
	 MIN(starting_year_id) as starting_year_id, 
	 MAX(ending_year_id) as ending_year_id, 
	 contract_number, sub_contract_id 
	FROM all_agreement_transactions WHERE is_prime_or_sub = 'P' 
	GROUP BY contract_number, sub_contract_id) c
	on a.contract_number = c.contract_number
	WHERE a.is_prime_or_sub IN ('P') AND a.latest_flag = 'Y'
 )e ON a.contract_number = e.contract_number 
LEFT JOIN subcontract_approval_status c ON c.aprv_sta_id = COALESCE(b.aprv_sta,6)
LEFT JOIN ref_document_code d ON d.document_code_id = a.document_code_id
--WHERE a.contract_number = 'CT185020151424707'
--WHERE a.contract_number = 'CTA185820157202568'
order by a.is_prime_or_sub;
--)x;

select etl.grantaccess('webuser1','SELECT');

-- CT184120131429672 haks engineers as prime
-- CT182620131416306 haks engineers has sub