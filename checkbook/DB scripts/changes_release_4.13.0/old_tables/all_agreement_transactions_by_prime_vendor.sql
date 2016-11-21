/* DDL for all_agreement_transactions_by_prime_vendor */
DROP TABLE IF EXISTS all_agreement_transactions_by_prime_vendor;

CREATE TABLE all_agreement_transactions_by_prime_vendor (
	agreement_id bigint,
	original_agreement_id bigint,
	contract_original_agreement_id bigint,
	contract_number varchar,
	description character varying(256),
	original_contract_amount numeric(16,2),
	maximum_contract_amount numeric(16,2),
	agreement_type_name character varying,
	sub_contract_id character varying(20),
	master_agreement_yn character(1),  
	master_agreement_id bigint,
	master_contract_number character varying,
	has_children character(1),
	has_mwbe_children character(1),
	document_version smallint,
	document_code_id smallint,
	document_code character varying(8),
	dollar_difference numeric(16,2),
	percent_difference numeric(17,4),
	agency_id integer,
	agency_name character varying,
	prime_sub_vendor_code character varying,
	prime_sub_vendor_code_by_type character varying,
	prime_sub_vendor_name_by_type character varying,
	prime_sub_minority_type_id character varying,
	prime_sub_vendor_minority_type_by_name_code character varying,
	prime_vendor_id integer,
	prime_vendor_code character varying,
	prime_vendor_name character varying,
	prime_minority_type_id smallint,
	prime_minority_type_name character varying(50),
	sub_vendor_id integer,
	sub_vendor_code character varying,
	sub_vendor_name character varying,
	sub_minority_type_id smallint,
	sub_minority_type_name character varying(50),
	aprv_sta smallint,
	aprv_sta_name character varying(50),
	scntrc_status smallint,
	scntrc_status_name character varying(50),
	award_method_id smallint,
	award_method_code character varying(10) ,
	award_method_name character varying,
	award_size_id smallint,
	expenditure_object_codes character varying,
	expenditure_object_names character varying,
	industry_type_id smallint,
	industry_type_name character varying(50),
	brd_awd_no character varying,
	tracking_number character varying,
	rfed_amount numeric(16,2),
	starting_year smallint,
	starting_year_id smallint,
	ending_year smallint,
	ending_year_id smallint,
	registered_year smallint,
	registered_year_id smallint,
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
	latest_flag character(1),
	sort_order smallint
)
DISTRIBUTED BY(agreement_id);

TRUNCATE TABLE all_agreement_transactions_by_prime_vendor;

-- SELECT * FROM all_agreement_transactions_by_prime_vendor
INSERT INTO all_agreement_transactions_by_prime_vendor (
	agreement_id,
	original_agreement_id,
	contract_original_agreement_id,
	contract_number,
	description,
	original_contract_amount,
	maximum_contract_amount,
	agreement_type_name,
	sub_contract_id,
	master_agreement_yn,
	master_agreement_id,
	master_contract_number,
	has_children,
	has_mwbe_children,
	document_version,
	document_code_id,
	document_code,
	dollar_difference,
	percent_difference,
	agency_id,
	agency_name,
	prime_vendor_id,
	prime_vendor_name,
	prime_minority_type_id,
	prime_minority_type_name,
	sub_vendor_id,
	sub_vendor_name,
	sub_minority_type_id,
	sub_minority_type_name,
	aprv_sta,
	aprv_sta_name,
	scntrc_status,
	scntrc_status_name,
	award_method_id,
	award_method_code,
	award_method_name,
	award_size_id,
	expenditure_object_codes,
	expenditure_object_names,
	industry_type_id,
	industry_type_name,
	brd_awd_no,
	tracking_number,
	rfed_amount,
	starting_year,
	starting_year_id,
	ending_year,
	ending_year_id,
	registered_year,
	registered_year_id,
	effective_begin_date,
	effective_begin_date_id,
	effective_begin_year,
	effective_begin_year_id,
	effective_end_date,
	effective_end_date_id,
	effective_end_year,
	effective_end_year_id,
	registered_date,
	registered_date_id,
	latest_flag,
	sort_order,
	prime_vendor_code,
	sub_vendor_code,
	prime_sub_vendor_code,
	prime_sub_vendor_code_by_type,
	prime_sub_vendor_name_by_type,
	prime_sub_minority_type_id,
	prime_sub_vendor_minority_type_by_name_code
)
SELECT 
a.agreement_id,
a.original_agreement_id,
a.contract_original_agreement_id,
a.contract_number,
a.description,
a.original_contract_amount,
COALESCE(a.maximum_contract_amount,0),
a.agreement_type_name,
CASE WHEN d.document_code IN ('CT1', 'CTA1', 'CT2')
    THEN (CASE WHEN ((b.sub_contract_id IS NULL OR b.sub_contract_id = '') AND a.scntrc_status = 2) THEN 'NOT PROVIDED' 
               WHEN (b.sub_contract_id IS NULL OR b.sub_contract_id = '') THEN 'N/A'
               ELSE b.sub_contract_id
           END)
    ELSE 'N/A' END AS sub_contract_id,
a.master_agreement_yn,
a.master_agreement_id,
a.master_contract_number,
a.has_children,
a.has_mwbe_children,
a.document_version,
a.document_code_id,
d.document_code,
a.dollar_difference,
a.percent_difference,
a.agency_id,
a.agency_name,
a.vendor_id as prime_vendor_id,
a.vendor_name as prime_vendor_name,
a.minority_type_id as prime_minority_type_id,
CASE
	WHEN a.minority_type_id = 2 THEN 'Black American'
	WHEN a.minority_type_id = 3 THEN 'Hispanic American'
	WHEN a.minority_type_id IN (4,5) THEN 'Asian American'
	WHEN a.minority_type_id = 7 THEN 'Non-M/WBE'
	WHEN a.minority_type_id = 9 THEN 'Women'
	WHEN a.minority_type_id = 11 THEN 'Individuals and Others'
END as prime_minority_type_name,
b.vendor_id as sub_vendor_id,
CASE WHEN d.document_code IN ('CT1', 'CTA1', 'CT2')
	THEN (CASE WHEN ((b.vendor_name IS NULL OR b.vendor_name = '') AND a.scntrc_status = 2) 
		THEN 'NOT PROVIDED' 
	     WHEN (b.vendor_name IS NULL OR b.vendor_name = '') 
	        THEN 'N/A'
                ELSE b.vendor_name
	END)
           ELSE 'N/A' END AS sub_vendor_name,
b.minority_type_id as sub_minority_type_id,
CASE WHEN d.document_code IN ('CT1', 'CTA1', 'CT2')
			THEN (CASE WHEN (b.sub_mwbe_type_name IS NULL AND a.scntrc_status = 2) 
				THEN 'NOT PROVIDED' 
			     WHEN b.sub_mwbe_type_name IS NULL
			        THEN 'N/A'
                            ELSE b.sub_mwbe_type_name
			END)
                 ELSE 'N/A' END AS sub_minority_type_name,
CASE WHEN d.document_code in ('CT1', 'CT2', 'CTA1') THEN c.aprv_sta_id ELSE 7 END AS aprv_sta_id,
CASE WHEN d.document_code in ('CT1', 'CT2', 'CTA1') THEN c.aprv_sta_value ELSE 'N/A' END AS aprv_sta_name,
CASE WHEN d.document_code in ('CT1', 'CT2', 'CTA1') THEN a.scntrc_status ELSE 5 END AS scntrc_status,
CASE WHEN d.document_code in ('CT1', 'CT2', 'CTA1') THEN a.scntrc_status_name ELSE 'N/A' END AS scntrc_status_name,
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
a.rfed_amount,
a.starting_year,
a.starting_year_id,
a.ending_year,
a.ending_year_id,
a.registered_year,
a.registered_year_id,
a.effective_begin_date,
a.effective_begin_date_id,
a.effective_begin_year,
a.effective_begin_year_id,
a.effective_end_date,
a.effective_end_date_id,
a.effective_end_year,
a.effective_end_year_id,
a.registered_date,
a.registered_date_id,
a.latest_flag,
c.sort_order,
vendor.vendor_customer_code as prime_vendor_code,
subvendor.vendor_customer_code as sub_vendor_code,
CASE
	WHEN subvendor.vendor_customer_code IS NULL THEN CAST(vendor.vendor_customer_code as text)
	ELSE CAST(vendor.vendor_customer_code as text) || ',' || CAST(subvendor.vendor_customer_code as text)
END AS prime_sub_vendor_code,

CASE
	WHEN a.minority_type_id IN (7,11) THEN 'P:'||CAST(vendor.vendor_customer_code as text)
	ELSE 'PM:'||CAST(vendor.vendor_customer_code as text)
END ||
CASE
	WHEN b.minority_type_id IS NULL THEN ''
	WHEN b.minority_type_id IN (7,11) THEN ',S:'||CAST(subvendor.vendor_customer_code as text)
	ELSE ',SM:'||CAST(subvendor.vendor_customer_code as text)
END AS prime_sub_vendor_code_by_type,

CASE
	WHEN a.minority_type_id IN (7,11) THEN 'P:'||CAST(a.vendor_name as text)
	ELSE 'PM:'||CAST(a.vendor_name as text)
END ||
CASE
	WHEN b.minority_type_id IS NULL THEN ''
	WHEN b.minority_type_id IN (7,11) THEN ',S:'||CAST(b.vendor_name as text)
	ELSE ',SM:'||CAST(b.vendor_name as text)
END AS prime_sub_vendor_name_by_type,

CASE
	WHEN a.minority_type_id IN (7,11) THEN 'P:'||a.minority_type_id
	ELSE 'PM:'||a.minority_type_id
END ||
CASE
	WHEN b.minority_type_id IS NULL THEN ''
	WHEN b.minority_type_id IN (7,11) THEN ',S:'||b.minority_type_id
	ELSE ',SM:'||b.minority_type_id
END AS prime_sub_minority_type_id,
a.vendor_type||':'||a.minority_type_id||':'||CAST(vendor.vendor_customer_code as text)||':'||a.vendor_name ||
(CASE
                WHEN b.vendor_name IS NULL THEN ''
                ELSE ','||b.vendor_type||':'||b.minority_type_id||':'||CAST(subvendor.vendor_customer_code as text)||':'||b.vendor_name
END) AS prime_sub_vendor_minority_type_by_name_code
FROM all_agreement_transactions a
LEFT JOIN
(
	SELECT
	a.contract_number,
	a.vendor_id,
	a.vendor_name,
    a.vendor_type,
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
	a.aprv_sta as aprv_sta_id
	FROM all_agreement_transactions a
	WHERE a.latest_flag = 'Y'
	AND a.is_prime_or_sub IN ('S')
) b on b.contract_number = a.contract_number
LEFT JOIN subcontract_approval_status c ON c.aprv_sta_id = COALESCE(b.aprv_sta_id,6)
JOIN ref_document_code d ON d.document_code_id = a.document_code_id
JOIN
(
	SELECT v.vendor_id, v.legal_name, v.vendor_customer_code FROM vendor v
	JOIN (SELECT vendor_id, MAX(vendor_history_id) AS vendor_history_id FROM vendor_history WHERE miscellaneous_vendor_flag::BIT = 0 ::BIT  GROUP BY 1) vh ON v.vendor_id = vh.vendor_id
) vendor on vendor.vendor_id = a.vendor_id
LEFT JOIN
(
	SELECT v.vendor_id, v.legal_name, v.vendor_customer_code FROM subvendor v
	JOIN (SELECT vendor_id, MAX(vendor_history_id) AS vendor_history_id FROM subvendor_history GROUP BY 1) vh ON v.vendor_id = vh.vendor_id
) subvendor on subvendor.vendor_id = b.vendor_id
WHERE a.is_prime_or_sub IN ('P');


select etl.grantaccess('webuser1','SELECT');

