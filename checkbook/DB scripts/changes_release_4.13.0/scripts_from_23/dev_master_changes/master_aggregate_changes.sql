-- adding scntrc_status fields to aggregate tables

-- aggregateon_contracts_cumulative_spending_backup

SET search_path = public;

DROP TABLE IF EXISTS aggregateon_contracts_cumulative_spending_backup;

CREATE TABLE aggregateon_contracts_cumulative_spending_backup as SELECT * FROM aggregateon_contracts_cumulative_spending
DISTRIBUTED BY (vendor_id);


DROP TABLE IF EXISTS aggregateon_contracts_cumulative_spending;


CREATE TABLE aggregateon_contracts_cumulative_spending
(
  original_agreement_id bigint,
  fiscal_year smallint,
  fiscal_year_id smallint,
  document_code_id smallint,
  master_agreement_yn character(1),
  description character varying,
  contract_number character varying,
  vendor_id integer,
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
  scntrc_status smallint,
  status_flag character(1),
  type_of_year character(1)
)DISTRIBUTED BY (vendor_id);


INSERT INTO aggregateon_contracts_cumulative_spending(
            original_agreement_id, fiscal_year, fiscal_year_id, document_code_id, 
            master_agreement_yn, description, contract_number, vendor_id, 
            award_method_id, agency_id, industry_type_id, award_size_id, 
            original_contract_amount, maximum_contract_amount, spending_amount_disb, 
            spending_amount, current_year_spending_amount, dollar_difference, 
            percent_difference, scntrc_status, status_flag, type_of_year)
SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		a.master_agreement_yn,
		MIN(description),
		MIN(contract_number),
		MIN(vendor_id),
		MIN(award_method_id),
		MIN(a.agency_id) ,
		MIN(industry_type_id),
		MIN(award_size_id),
		MIN(original_contract_amount),
		MIN(maximum_contract_amount),
		SUM(coalesce(b.check_amount,0)),
		MIN(a.rfed_amount),
		SUM(CASE WHEN b.fiscal_year IS NOT NULL AND a.fiscal_year = b.fiscal_year THEN coalesce(b.check_amount,0) ELSE 0 END) as current_year_spending_amount,
		MIN(dollar_difference),
		MIN(percent_difference),
    	MIN(scntrc_status),
		'A' as status_flag,
		'B' as type_of_year
	FROM 	agreement_snapshot_expanded a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='B'
	WHERE  a.status_flag='A'
	GROUP BY 1,2,3,4,5
UNION ALL
SELECT a.original_agreement_id,
	a.fiscal_year,
	ry.year_id,
	document_code_id,
	a.master_agreement_yn,
	MIN(description),
	MIN(contract_number),
	MIN(vendor_id),
	MIN(award_method_id),
	MIN(a.agency_id) ,
	MIN(industry_type_id),
	MIN(award_size_id),
	MIN(original_contract_amount),
	MIN(maximum_contract_amount),
	SUM(coalesce(b.check_amount,0)) ,
	MIN(a.rfed_amount),
	SUM(CASE WHEN b.fiscal_year IS NOT NULL AND a.fiscal_year = b.fiscal_year THEN coalesce(b.check_amount,0) ELSE 0 END) as current_year_spending_amount,
	MIN(dollar_difference),
	MIN(percent_difference),
  	MIN(scntrc_status),
	'R' as status_flag, 
	'B' as type_of_year	
	FROM 	agreement_snapshot_expanded a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='B' 
	WHERE   a.status_flag='R'
	GROUP BY 1,2,3,4,5;

INSERT INTO aggregateon_contracts_cumulative_spending(
            original_agreement_id, fiscal_year, fiscal_year_id, document_code_id, 
            master_agreement_yn, description, contract_number, vendor_id, 
            award_method_id, agency_id, industry_type_id, award_size_id, 
            original_contract_amount, maximum_contract_amount, spending_amount_disb, 
            spending_amount, current_year_spending_amount, dollar_difference, 
            percent_difference, scntrc_status, status_flag, type_of_year)
SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		a.master_agreement_yn,
		MIN(description),
		MIN(contract_number),
		MIN(vendor_id),
		MIN(award_method_id),
		MIN(a.agency_id) ,
		MIN(industry_type_id),
		MIN(award_size_id),
		MIN(original_contract_amount),
		MIN(maximum_contract_amount),
		SUM(coalesce(b.check_amount,0)),
		MIN(a.rfed_amount),
		SUM(CASE WHEN b.fiscal_year IS NOT NULL AND a.fiscal_year = b.fiscal_year THEN coalesce(b.check_amount,0) ELSE 0 END) as current_year_spending_amount,
		MIN(dollar_difference),
		MIN(percent_difference),
   	 	MIN(scntrc_status),
		'A' as status_flag,
		'C' as type_of_year
	FROM 	agreement_snapshot_expanded_cy a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='C'
	WHERE  a.status_flag='A'
	GROUP BY 1,2,3,4,5
UNION ALL
SELECT a.original_agreement_id,
	a.fiscal_year,
	ry.year_id,
	document_code_id,
	a.master_agreement_yn,
	MIN(description),
	MIN(contract_number),
	MIN(vendor_id),
	MIN(award_method_id),
	MIN(a.agency_id),
	MIN(industry_type_id),
	MIN(award_size_id),
	MIN(original_contract_amount),
	MIN(maximum_contract_amount),
	SUM(coalesce(b.check_amount,0)) ,
	MIN(a.rfed_amount),
	SUM(CASE WHEN b.fiscal_year IS NOT NULL AND a.fiscal_year = b.fiscal_year THEN coalesce(b.check_amount,0) ELSE 0 END) as current_year_spending_amount,
	MIN(dollar_difference),
	MIN(percent_difference),
  	MIN(scntrc_status),
	'R' as status_flag, 
	'C' as type_of_year	
	FROM 	agreement_snapshot_expanded_cy a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='C'
	WHERE   a.status_flag='R'
	GROUP BY 1,2,3,4,5;



-- aggregateon_contracts_cumulative_spending_backup
SET search_path = public;

DROP TABLE IF EXISTS aggregateon_mwbe_contracts_cumulative_spending_backup;

CREATE TABLE aggregateon_mwbe_contracts_cumulative_spending_backup as SELECT * FROM aggregateon_mwbe_contracts_cumulative_spending
DISTRIBUTED BY (vendor_id);

DROP TABLE IF EXISTS aggregateon_mwbe_contracts_cumulative_spending;

CREATE TABLE aggregateon_mwbe_contracts_cumulative_spending
(
  original_agreement_id bigint,
  fiscal_year smallint,
  fiscal_year_id smallint,
  document_code_id smallint,
  master_agreement_yn character(1),
  description character varying,
  contract_number character varying,
  vendor_id integer,
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
  scntrc_status smallint,
  status_flag character(1),
  type_of_year character(1)
)DISTRIBUTED BY (vendor_id);


INSERT INTO aggregateon_mwbe_contracts_cumulative_spending(
            original_agreement_id, fiscal_year, fiscal_year_id, document_code_id, 
            master_agreement_yn, description, contract_number, vendor_id, 
            minority_type_id, award_method_id, agency_id, industry_type_id, 
            award_size_id, original_contract_amount, maximum_contract_amount, 
            spending_amount_disb, spending_amount, current_year_spending_amount, 
            dollar_difference, percent_difference, scntrc_status, status_flag, type_of_year)
SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		a.master_agreement_yn,
		MIN(description),
		MIN(contract_number),
		MIN(vendor_id),
		MIN(minority_type_id),
		MIN(award_method_id),
		MIN(a.agency_id) ,
		MIN(industry_type_id),
		MIN(award_size_id),
		MIN(original_contract_amount),
		MIN(maximum_contract_amount),
		SUM(coalesce(b.check_amount,0)),
		MIN(a.rfed_amount),
		SUM(CASE WHEN b.fiscal_year IS NOT NULL AND a.fiscal_year = b.fiscal_year THEN coalesce(b.check_amount,0) ELSE 0 END) as current_year_spending_amount,
		MIN(dollar_difference),
		MIN(percent_difference),
		MIN(scntrc_status),
		'A' as status_flag,
		'B' as type_of_year
	FROM 	agreement_snapshot_expanded a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='B'
	WHERE  a.status_flag='A'
	GROUP BY 1,2,3,4,5
UNION ALL
SELECT a.original_agreement_id,
	a.fiscal_year,
	ry.year_id,
	document_code_id,
	a.master_agreement_yn,
	MIN(description),
	MIN(contract_number),
	MIN(vendor_id),
	MIN(minority_type_id),
	MIN(award_method_id),
	MIN(a.agency_id) ,
	MIN(industry_type_id),
	MIN(award_size_id),
	MIN(original_contract_amount),
	MIN(maximum_contract_amount),
	SUM(coalesce(b.check_amount,0)) ,
	MIN(a.rfed_amount),
	SUM(CASE WHEN b.fiscal_year IS NOT NULL AND a.fiscal_year = b.fiscal_year THEN coalesce(b.check_amount,0) ELSE 0 END) as current_year_spending_amount,
	MIN(dollar_difference),
	MIN(percent_difference),
	MIN(scntrc_status),
	'R' as status_flag, 
	'B' as type_of_year	
	FROM 	agreement_snapshot_expanded a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='B' 
	WHERE   a.status_flag='R'
	GROUP BY 1,2,3,4,5;

INSERT INTO aggregateon_mwbe_contracts_cumulative_spending(
            original_agreement_id, fiscal_year, fiscal_year_id, document_code_id, 
            master_agreement_yn, description, contract_number, vendor_id, 
            minority_type_id, award_method_id, agency_id, industry_type_id, 
            award_size_id, original_contract_amount, maximum_contract_amount, 
            spending_amount_disb, spending_amount, current_year_spending_amount, 
            dollar_difference, percent_difference, scntrc_status, status_flag, type_of_year)
SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		a.master_agreement_yn,
		MIN(description),
		MIN(contract_number),
		MIN(vendor_id),
		MIN(minority_type_id),
		MIN(award_method_id),
		MIN(a.agency_id) ,
		MIN(industry_type_id),
		MIN(award_size_id),
		MIN(original_contract_amount),
		MIN(maximum_contract_amount),
		SUM(coalesce(b.check_amount,0)),
		MIN(a.rfed_amount),
		SUM(CASE WHEN b.fiscal_year IS NOT NULL AND a.fiscal_year = b.fiscal_year THEN coalesce(b.check_amount,0) ELSE 0 END) as current_year_spending_amount,
		MIN(dollar_difference),
		MIN(percent_difference),
		MIN(scntrc_status),
		'A' as status_flag,
		'C' as type_of_year
	FROM 	agreement_snapshot_expanded_cy a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='C'
	WHERE  a.status_flag='A'
	GROUP BY 1,2,3,4,5
UNION ALL
SELECT a.original_agreement_id,
	a.fiscal_year,
	ry.year_id,
	document_code_id,
	a.master_agreement_yn,
	MIN(description),
	MIN(contract_number),
	MIN(vendor_id),
	MIN(minority_type_id),
	MIN(award_method_id),
	MIN(a.agency_id),
	MIN(industry_type_id),
	MIN(award_size_id),
	MIN(original_contract_amount),
	MIN(maximum_contract_amount),
	SUM(coalesce(b.check_amount,0)) ,
	MIN(a.rfed_amount),
	SUM(CASE WHEN b.fiscal_year IS NOT NULL AND a.fiscal_year = b.fiscal_year THEN coalesce(b.check_amount,0) ELSE 0 END) as current_year_spending_amount,
	MIN(dollar_difference),
	MIN(percent_difference),
	MIN(scntrc_status),
	'R' as status_flag, 
	'C' as type_of_year	
	FROM 	agreement_snapshot_expanded_cy a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='C'
	WHERE   a.status_flag='R'
	GROUP BY 1,2,3,4,5;


TRUNCATE etl.aggregate_tables;

COPY etl.aggregate_tables FROM '/home/gpadmin/TREDDY/CREATE_NEW_DATABASE/widget_aggregate_tables.csv' CSV HEADER QUOTE as '"';

COPY etl.aggregate_tables FROM '/home/gpadmin/TREDDY/CREATE_NEW_DATABASE/widget_aggregate_tables_mwbe.csv' CSV HEADER QUOTE as '"';

COPY etl.aggregate_tables FROM '/home/gpadmin/TREDDY/CREATE_NEW_DATABASE/widget_aggregate_tables_subcontracts.csv' CSV HEADER QUOTE as '"';




