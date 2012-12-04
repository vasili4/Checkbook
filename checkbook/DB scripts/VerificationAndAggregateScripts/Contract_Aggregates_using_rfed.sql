-- For Contracts

DROP TABLE IF EXISTS mid_aggregateon_disbursement_spending_year;
	
CREATE TABLE mid_aggregateon_disbursement_spending_year(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	check_amount numeric(16,2),
	type_of_year char(1),
	master_agreement_yn character(1))
DISTRIBUTED BY (original_agreement_id) 	;

-- For Contracts

INSERT INTO mid_aggregateon_disbursement_spending_year
SELECT agreement_id,
	a.fiscal_year,
	year_id,
	SUM(check_amount),
	'B' as type_of_year,
	'N' as master_agreement_yn
FROM	disbursement_line_item_details a JOIN ref_year b ON a.fiscal_year = b.year_value AND agreement_id IS NOT NULL
GROUP  BY 1,2,3,5,6
UNION ALL
SELECT agreement_id,
	a.calendar_fiscal_year,
	year_id,
	SUM(check_amount),
	'C' as type_of_year,
	'N' as master_agreement_yn
FROM	disbursement_line_item_details a JOIN ref_year b ON a.calendar_fiscal_year = b.year_value AND agreement_id IS NOT NULL
GROUP  BY 1,2,3,5,6;

-- For master agreements

INSERT INTO mid_aggregateon_disbursement_spending_year
SELECT master_agreement_id,
	a.fiscal_year,
	year_id,
	SUM(check_amount),
	'B' as type_of_year,
	'Y' as master_agreement_yn
FROM	disbursement_line_item_details a JOIN ref_year b ON a.fiscal_year = b.year_value AND master_agreement_id IS NOT NULL
GROUP  BY 1,2,3,5,6
UNION ALL
SELECT master_agreement_id,
	a.calendar_fiscal_year,
	year_id,
	SUM(check_amount),
	'C' as type_of_year,
	'Y' as master_agreement_yn
FROM	disbursement_line_item_details a JOIN ref_year b ON a.calendar_fiscal_year = b.year_value AND master_agreement_id IS NOT NULL
GROUP  BY 1,2,3,5,6;



-- Creating Final Aggregate Tables

DROP TABLE IF EXISTS aggregateon_contracts_cumulative_spending;

CREATE TABLE aggregateon_contracts_cumulative_spending(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	master_agreement_yn character(1),
	description varchar,
	contract_number varchar,
	vendor_id int,
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


-- For Fiscal year 
	
INSERT INTO aggregateon_contracts_cumulative_spending
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
	'R' as status_flag, 
	'B' as type_of_year	
	FROM 	agreement_snapshot_expanded a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='B' 
	WHERE   a.status_flag='R'
	GROUP BY 1,2,3,4,5;
		

-- For Calendar year 

INSERT INTO aggregateon_contracts_cumulative_spending
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
	'R' as status_flag, 
	'C' as type_of_year	
	FROM 	agreement_snapshot_expanded_cy a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='C'
	WHERE   a.status_flag='R'
	GROUP BY 1,2,3,4,5;
	
	
-- 	Spending by month	

DROP TABLE IF EXISTS aggregateon_contracts_spending_by_month ;

CREATE TABLE aggregateon_contracts_spending_by_month(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	month_id integer,
	vendor_id int,
	award_method_id smallint,
	agency_id smallint,
	industry_type_id smallint,
	award_size_id smallint,
	spending_amount numeric(16,2),
	status_flag char(1),
	type_of_year char(1)	
) DISTRIBUTED BY (vendor_id);	


-- For Fiscal year 
	
INSERT INTO aggregateon_contracts_spending_by_month
SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		b.check_eft_issued_cal_month_id as month_id,		
		a.vendor_id,
		a.award_method_id,
		a.agency_id ,
		a.industry_type_id,
		a.award_size_id,
		SUM(coalesce(b.check_amount,0)),		
		'A' as status_flag,
		'B' as type_of_year
	FROM 	agreement_snapshot_expanded a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN disbursement_line_item_details b ON a.original_agreement_id = b.agreement_id AND a.fiscal_year = b.fiscal_year 
	WHERE  a.status_flag='A' AND a.master_agreement_yn = 'N'
	GROUP BY 1,2,3,4,5,6,7,8,9,10
UNION ALL
SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		b.check_eft_issued_cal_month_id as month_id,		
		a.vendor_id,
		a.award_method_id,
		a.agency_id ,
		a.industry_type_id,
		a.award_size_id,
		SUM(coalesce(b.check_amount,0)),		
		'A' as status_flag,
		'B' as type_of_year
	FROM 	agreement_snapshot_expanded a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN disbursement_line_item_details b ON a.original_agreement_id = b.master_agreement_id AND a.fiscal_year = b.fiscal_year 
	WHERE  a.status_flag='A' AND a.master_agreement_yn = 'Y'
	GROUP BY 1,2,3,4,5,6,7,8,9,10
UNION ALL
SELECT a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		b.check_eft_issued_cal_month_id as month_id,		
		a.vendor_id,
		a.award_method_id,
		a.agency_id ,	
		a.industry_type_id,
		a.award_size_id,
		SUM(coalesce(b.check_amount,0)),
		'R' as status_flag, 
		'B' as type_of_year	
	FROM 	agreement_snapshot_expanded a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN disbursement_line_item_details b ON a.original_agreement_id = b.agreement_id AND a.fiscal_year = b.fiscal_year 
	WHERE   a.status_flag='R' AND a.master_agreement_yn = 'N'
	GROUP BY 1,2,3,4,5,6,7,8,9,10
UNION ALL
SELECT a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		b.check_eft_issued_cal_month_id as month_id,		
		a.vendor_id,
		a.award_method_id,
		a.agency_id ,	
		a.industry_type_id,
		a.award_size_id,
		SUM(coalesce(b.check_amount,0)),
		'R' as status_flag, 
		'B' as type_of_year	
	FROM 	agreement_snapshot_expanded a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN disbursement_line_item_details b ON a.original_agreement_id = b.master_agreement_id AND a.fiscal_year = b.fiscal_year 
	WHERE   a.status_flag='R' AND a.master_agreement_yn = 'Y'
	GROUP BY 1,2,3,4,5,6,7,8,9,10;
		

-- For Calendar year 

INSERT INTO aggregateon_contracts_spending_by_month
SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		b.check_eft_issued_cal_month_id as month_id,		
		a.vendor_id,
		a.award_method_id,
		a.agency_id ,	
		a.industry_type_id,
		a.award_size_id,
		SUM(coalesce(b.check_amount,0)),
		'A' as status_flag,
		'C' as type_of_year
	FROM 	agreement_snapshot_expanded_cy a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN disbursement_line_item_details b ON a.original_agreement_id = b.agreement_id AND a.fiscal_year = b.calendar_fiscal_year 
	WHERE  a.status_flag='A' AND a.master_agreement_yn = 'N'
	GROUP BY 1,2,3,4,5,6,7,8,9,10
UNION ALL
SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		b.check_eft_issued_cal_month_id as month_id,		
		a.vendor_id,
		a.award_method_id,
		a.agency_id ,	
		a.industry_type_id,
		a.award_size_id,
		SUM(coalesce(b.check_amount,0)),
		'A' as status_flag,
		'C' as type_of_year
	FROM 	agreement_snapshot_expanded_cy a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN disbursement_line_item_details b ON a.original_agreement_id = b.master_agreement_id AND a.fiscal_year = b.calendar_fiscal_year 
	WHERE  a.status_flag='A' AND a.master_agreement_yn = 'Y'
	GROUP BY 1,2,3,4,5,6,7,8,9,10
UNION ALL
SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		b.check_eft_issued_cal_month_id as month_id,		
		a.vendor_id,
		a.award_method_id,
		a.agency_id ,	
		a.industry_type_id,
		a.award_size_id,
		SUM(coalesce(b.check_amount,0)),
	'R' as status_flag, 
	'C' as type_of_year	
	FROM 	agreement_snapshot_expanded_cy a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN disbursement_line_item_details b ON a.original_agreement_id = b.agreement_id AND a.fiscal_year = b.calendar_fiscal_year 
	WHERE   a.status_flag='R' AND a.master_agreement_yn = 'N'
	GROUP BY 1,2,3,4,5,6,7,8,9,10
UNION ALL
SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		b.check_eft_issued_cal_month_id as month_id,		
		a.vendor_id,
		a.award_method_id,
		a.agency_id ,	
		a.industry_type_id,
		a.award_size_id,
		SUM(coalesce(b.check_amount,0)),
	'R' as status_flag, 
	'C' as type_of_year	
	FROM 	agreement_snapshot_expanded_cy a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN disbursement_line_item_details b ON a.original_agreement_id = b.master_agreement_id AND a.fiscal_year = b.calendar_fiscal_year 
	WHERE   a.status_flag='R' AND a.master_agreement_yn = 'Y'
	GROUP BY 1,2,3,4,5,6,7,8,9,10;
	
	
	
	
/*
-- For Contracts total, committed contracts total  and total spending till date group by agency

DROP TABLE IF EXISTS aggregateon_total_contracts_agency;

CREATE TABLE aggregateon_total_contracts_agency
(
fiscal_year smallint,
fiscal_year_id smallint,
agency_id smallint,
total_contracts bigint,
total_commited_contracts bigint,
total_master_agreements bigint,
total_standalone_contracts bigint,
total_commited_contracts_amount numeric(16,2),
total_contracts_amount numeric(16,2),
total_spending_amount numeric(16,2), 
status_flag char(1),
type_of_year char(1)
) DISTRIBUTED BY (fiscal_year);	

INSERT INTO aggregateon_total_contracts_agency
SELECT 	fiscal_year, 
		fiscal_year_id,
		agency_id,
		count(*) as  total_contracts,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1','CT1','POC','POD','PCC1') THEN 1 ELSE 0 END) AS total_commited_contracts,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1') THEN 1 ELSE 0 END) AS total_master_agreements,
		SUM(CASE WHEN b.document_code IN ('CT1','POC','POD','PCC1') THEN 1 ELSE 0 END) AS total_standalone_contracts,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1','CT1','POC','POD','PCC1') THEN maximum_contract_amount ELSE 0 END) AS total_commited_contracts_amount,
		SUM(maximum_contract_amount) as total_contracts_amount,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1') THEN 0 ELSE spending_amount END) as total_spending_amount,
		status_flag,
		type_of_year
FROM aggregateon_contracts_cumulative_spending a LEFT JOIN ref_document_code b ON a.document_code_id = b.document_code_id
GROUP BY 1,2,3,11,12;

*/
	
-- For Contracts total, committed contracts total  and total spending till date

DROP TABLE IF EXISTS aggregateon_total_contracts;

CREATE TABLE aggregateon_total_contracts
(
fiscal_year smallint,
fiscal_year_id smallint,
vendor_id int,
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

INSERT INTO aggregateon_total_contracts
SELECT 	fiscal_year, 
		fiscal_year_id,
		vendor_id,
		award_method_id,
		agency_id,
		industry_type_id,
		award_size_id,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1','CT1','CTA1') THEN 1 ELSE 0 END) AS    total_contracts,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1','CT1') THEN 1 ELSE 0 END) AS total_commited_contracts,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1') THEN 1 ELSE 0 END) AS total_master_agreements,
		SUM(CASE WHEN b.document_code IN ('CT1','CTA1') THEN  1 ELSE 0 END) AS total_standalone_contracts,
		SUM(CASE WHEN b.document_code IN ('RCT1') THEN  1 ELSE 0 END) AS total_revenue_contracts,
		SUM(CASE WHEN b.document_code IN ('RCT1') THEN  maximum_contract_amount ELSE 0 END) AS total_revenue_contracts_amount,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1','CT1') THEN maximum_contract_amount ELSE 0 END) AS total_commited_contracts_amount,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1','CT1','CTA1') THEN maximum_contract_amount ELSE 0 END) AS total_contracts_amount,
		SUM(CASE WHEN b.document_code IN ('CT1','CTA1','DO1') THEN spending_amount_disb ELSE 0 END) as total_spending_amount_disb,
		SUM(CASE WHEN b.document_code IN ('CT1','CTA1','DO1') THEN spending_amount ELSE 0 END) as total_spending_amount,
		status_flag,
		type_of_year
FROM aggregateon_contracts_cumulative_spending a LEFT JOIN ref_document_code b ON a.document_code_id = b.document_code_id
GROUP BY 1,2,3,4,5,6,7,18,19;	

-- Contract Aggregate table for the filter All years 
/*
DROP TABLE IF EXISTS aggregateon_contracts_cumulative_spending_all_years;

CREATE TABLE aggregateon_contracts_cumulative_spending_all_years(
	original_agreement_id bigint,
	document_code_id smallint,
	master_agreement_yn character(1),
	description varchar,
	contract_number varchar,
	vendor_id bigint,
	award_method_id smallint,
	agency_id smallint,
	original_contract_amount numeric(16,2),
	maximum_contract_amount numeric(16,2),
	spending_amount numeric(16,2),
	dollar_difference numeric(16,2),
	percent_difference numeric(16,2),
	status_flag char(1)	
) DISTRIBUTED BY (original_agreement_id);	

*/
/*

INSERT INTO aggregateon_contracts_cumulative_spending_all_years
SELECT a.original_agreement_id, 
	document_code_id, 
	master_agreement_yn, 
	description, 
	contract_number, 
	vendor_id, 
	award_method_id, 
	agency_id, 
	original_contract_amount, 
	maximum_contract_amount, 
	spending_amount, 
	dollar_difference, 
	percent_difference, 
	'A' as status_flag
FROM aggregateon_contracts_cumulative_spending a JOIN 
(SELECT original_agreement_id, 
	max(fiscal_year) as max_fiscal_year 
FROM aggregateon_contracts_cumulative_spending 
WHERE type_of_year ='C' AND status_flag = 'A' GROUP BY 1) b ON a.original_agreement_id = b.original_agreement_id 
AND a.fiscal_year = max_fiscal_year AND a.type_of_year ='C' AND a.status_flag = 'A' ;


INSERT INTO aggregateon_contracts_cumulative_spending_all_years
SELECT a.original_agreement_id, 
	document_code_id, 
	master_agreement_yn, 
	description, 
	contract_number, 
	vendor_id, 
	award_method_id, 
	agency_id, 
	original_contract_amount, 
	maximum_contract_amount, 
	spending_amount, 
	dollar_difference, 
	percent_difference, 
	'R' as status_flag
FROM aggregateon_contracts_cumulative_spending a JOIN 
(SELECT original_agreement_id, max(fiscal_year) as max_fiscal_year 
FROM aggregateon_contracts_cumulative_spending 
WHERE type_of_year ='C' AND status_flag = 'R' GROUP BY 1) b ON a.original_agreement_id = b.original_agreement_id 
AND a.fiscal_year = max_fiscal_year AND a.type_of_year ='C' AND a.status_flag = 'R' ;

*/

/*
INSERT INTO aggregateon_contracts_cumulative_spending_all_years
SELECT  a.original_agreement_id, 
	a.document_code_id, 
	master_agreement_yn, 
	MIN(a.description) as description, 
	MIN(a.contract_number) as contract_number, 
	MIN(a.vendor_id) as vendor_id, 
	MIN(a.award_method_id) as award_method_id, 
	MIN(CASE WHEN a.master_agreement_yn = 'N' THEN funding_agency_id WHEN a.master_agreement_yn = 'Y' THEN  document_agency_id ELSE NULL END) as agency_id ,
	MIN(a.original_contract_amount) as original_contract_amount,
	MIN(a.maximum_contract_amount) as maximum_contract_amount,
	SUM(a.check_amount) as spending_amount,
	MIN(a.dollar_difference) as dollar_difference,
	MIN(a.percent_difference) as percent_difference,
	'A' as status_flag
	FROM
(SELECT  a.original_agreement_id, 
	a.document_code_id, 
	a.master_agreement_yn, 
	a.description, 
	a.contract_number, 
	a.vendor_id, 
	a.award_method_id, 
	first_value(b.agency_id) over (partition by a.original_agreement_id  ORDER BY b.check_eft_issued_date_id desc) as funding_agency_id,
	a.agency_id as document_agency_id,
	a.original_contract_amount,
	a.maximum_contract_amount,
	b.check_amount,
	a.dollar_difference,
	a.percent_difference
FROM agreement_snapshot a 
LEFT JOIN disbursement_line_item_details  b ON a.original_agreement_id = b.agreement_id
 WHERE latest_flag = 'Y' and (effective_begin_year >= 2010 OR effective_end_year >= 2010 )) a
 GROUP BY 1,2,3 
 UNION ALL
 SELECT  a.original_agreement_id, 
	a.document_code_id, 
	master_agreement_yn, 
	MIN(a.description) as description, 
	MIN(a.contract_number) as contract_number, 
	MIN(a.vendor_id) as vendor_id, 
	MIN(a.award_method_id) as award_method_id, 
	MIN(CASE WHEN a.master_agreement_yn = 'N' THEN funding_agency_id WHEN a.master_agreement_yn = 'Y' THEN  document_agency_id ELSE NULL END) as agency_id ,
	MIN(a.original_contract_amount) as original_contract_amount,
	MIN(a.maximum_contract_amount) as maximum_contract_amount,
	SUM(a.check_amount) as spending_amount,
	MIN(a.dollar_difference) as dollar_difference,
	MIN(a.percent_difference) as percent_difference,
	'R' as status_flag
	FROM
(SELECT  a.original_agreement_id, 
	a.document_code_id, 
	a.master_agreement_yn, 
	a.description, 
	a.contract_number, 
	a.vendor_id, 
	a.award_method_id, 
	first_value(b.agency_id) over (partition by a.original_agreement_id  ORDER BY b.check_eft_issued_date_id desc) as funding_agency_id,
	a.agency_id as document_agency_id,
	a.original_contract_amount,
	a.maximum_contract_amount,
	b.check_amount,
	a.dollar_difference,
	a.percent_difference
FROM agreement_snapshot a 
LEFT JOIN disbursement_line_item_details  b ON a.original_agreement_id = b.agreement_id
 WHERE latest_flag = 'Y' and registered_year >= 2010 ) a
 GROUP BY 1,2,3 ;
 
*/

-- Contract Aggregate table for the department 

DROP TABLE IF EXISTS aggregateon_contracts_department;

CREATE TABLE aggregateon_contracts_department(
	document_code_id smallint,
	document_agency_id smallint,
	agency_id smallint,
	department_id integer,
	fiscal_year smallint,
	fiscal_year_id smallint,
	award_method_id smallint,
	vendor_id int,
	industry_type_id smallint,
	award_size_id smallint,
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	total_contracts integer,
	status_flag char(1),
	type_of_year char(1)
) DISTRIBUTED BY (department_id);	
 
 
 INSERT INTO aggregateon_contracts_department
 SELECT a.document_code_id,
 		a.agency_id as document_agency_id,
 		e.agency_id as agency_id,
		f.department_id as department_id,
		a.fiscal_year,
		b.year_id,
		a.award_method_id,
		a.vendor_id,
		a.industry_type_id,
		a.award_size_id,
		sum(coalesce(d.check_amount,0)) as spending_amount_disb,
		sum(coalesce(c.rfed_line_amount,0)) as spending_amount,
		count(distinct a.original_agreement_id) as total_contracts,
		'A' as status_flag,
		'B' as type_of_year
 FROM agreement_snapshot_expanded a JOIN ref_year b ON a.fiscal_year = b.year_value
 JOIN history_agreement_accounting_line c ON a.agreement_id = c.agreement_id
 LEFT JOIN disbursement_line_item_details d ON a.original_agreement_id = d.agreement_id AND c.line_number =  d.agreement_accounting_line_number 
 AND c.commodity_line_number = d.agreement_commodity_line_number AND a.fiscal_year >= d.fiscal_year
 JOIN ref_agency_history e ON e.agency_history_id = c.agency_history_id
 JOIN ref_department_history f ON f.department_history_id = c.department_history_id AND e.agency_id = f.agency_id
 WHERE  a.master_agreement_yn = 'N' AND a.status_flag='A' GROUP BY 1,2,3,4,5,6,7,8,9,10	
 UNION ALL 
 SELECT a.document_code_id,
 		a.agency_id as document_agency_id,
 		e.agency_id as agency_id,
		f.department_id as department_id,
		a.fiscal_year,
		b.year_id,
		a.award_method_id,
		a.vendor_id,
		a.industry_type_id,
		a.award_size_id,
		sum(coalesce(d.check_amount,0)) as spending_amount_disb,
		sum(coalesce(c.rfed_line_amount,0)) as spending_amount,
		count(distinct a.original_agreement_id) as total_contracts,
		'R' as status_flag,
		'B' as type_of_year
 FROM agreement_snapshot_expanded a JOIN ref_year b ON a.fiscal_year = b.year_value
 JOIN history_agreement_accounting_line c ON a.agreement_id = c.agreement_id
 LEFT JOIN disbursement_line_item_details d ON a.original_agreement_id = d.agreement_id AND c.line_number =  d.agreement_accounting_line_number 
 AND c.commodity_line_number = d.agreement_commodity_line_number AND a.fiscal_year >= d.fiscal_year
 JOIN ref_agency_history e ON e.agency_history_id = c.agency_history_id
 JOIN ref_department_history f ON f.department_history_id = c.department_history_id AND e.agency_id = f.agency_id
 WHERE  a.master_agreement_yn = 'N' AND a.status_flag='R' GROUP BY 1,2,3,4,5,6,7,8,9,10	;
 
 INSERT INTO aggregateon_contracts_department
 SELECT a.document_code_id,
 		a.agency_id as document_agency_id,
 		e.agency_id as agency_id,
		f.department_id as department_id,
		a.fiscal_year,
		b.year_id,
		a.award_method_id,
		a.vendor_id,
		a.industry_type_id,
		a.award_size_id,
		sum(coalesce(d.check_amount,0)) as spending_amount_disb,
		sum(coalesce(c.rfed_line_amount,0)) as spending_amount,
		count(distinct a.original_agreement_id) as total_contracts,
		'A' as status_flag,
		'C' as type_of_year
 FROM agreement_snapshot_expanded_cy a JOIN ref_year b ON a.fiscal_year = b.year_value
 JOIN history_agreement_accounting_line c ON a.agreement_id = c.agreement_id
 LEFT JOIN disbursement_line_item_details d ON a.original_agreement_id = d.agreement_id AND c.line_number =  d.agreement_accounting_line_number 
 AND c.commodity_line_number = d.agreement_commodity_line_number AND a.fiscal_year >= d.calendar_fiscal_year
 JOIN ref_agency_history e ON e.agency_history_id = c.agency_history_id
 JOIN ref_department_history f ON f.department_history_id = c.department_history_id AND e.agency_id = f.agency_id
 WHERE  a.master_agreement_yn = 'N' AND a.status_flag='A' GROUP BY 1,2,3,4,5,6,7,8,9,10	
 UNION ALL 
 SELECT a.document_code_id,
 		a.agency_id as document_agency_id,
 		e.agency_id as agency_id,
		f.department_id as department_id,
		a.fiscal_year,
		b.year_id,
		a.award_method_id,
		a.vendor_id,
		a.industry_type_id,
		a.award_size_id,
		sum(coalesce(d.check_amount,0)) as spending_amount_disb,
		sum(coalesce(c.rfed_line_amount,0)) as spending_amount,
		count(distinct a.original_agreement_id) as total_contracts,
		'R' as status_flag,
		'C' as type_of_year
 FROM agreement_snapshot_expanded_cy a JOIN ref_year b ON a.fiscal_year = b.year_value
 JOIN history_agreement_accounting_line c ON a.agreement_id = c.agreement_id
 LEFT JOIN disbursement_line_item_details d ON a.original_agreement_id = d.agreement_id AND c.line_number =  d.agreement_accounting_line_number 
 AND c.commodity_line_number = d.agreement_commodity_line_number AND a.fiscal_year >= d.calendar_fiscal_year
 JOIN ref_agency_history e ON e.agency_history_id = c.agency_history_id
 JOIN ref_department_history f ON f.department_history_id = c.department_history_id AND e.agency_id = f.agency_id
 WHERE  a.master_agreement_yn = 'N' AND a.status_flag='R' GROUP BY 1,2,3,4,5,6,7,8,9,10	;
 
 
 -- For spending transactions

DROP TABLE IF EXISTS contracts_spending_transactions;
	
CREATE TABLE contracts_spending_transactions
(
disbursement_line_item_id bigint,
original_agreement_id bigint,
fiscal_year smallint,
fiscal_year_id smallint,
document_code_id smallint,
vendor_id int,
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
status_flag char(1),
type_of_year char(1)
) DISTRIBUTED BY (disbursement_line_item_id);	


INSERT INTO contracts_spending_transactions
SELECT 	d.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		b.year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id as document_agency_id,
		a.industry_type_id,
		a.award_size_id,
		d.document_id,
		d.vendor_name,
		d.check_eft_issued_date,
		d.agency_name,
		d.department_short_name,
		d.check_amount,
		d.expenditure_object_name,
		d.budget_name,
		d.contract_number,
		d.purpose,
		d.reporting_code,
		d.spending_category_name,
		d.agency_id,
		d.vendor_id,
		d.expenditure_object_id,
		d.department_id,
		d.spending_category_id,
		d.agreement_id,
		d.contract_document_code,
		d.master_agreement_id,
		d.check_eft_issued_nyc_year_id,
		d.check_eft_issued_cal_month_id,
		'A' as status_flag,
		'B' as type_of_year
FROM   agreement_snapshot_expanded a, ref_year b, disbursement_line_item_details d
WHERE a.fiscal_year = b.year_value 
AND a.original_agreement_id = d.agreement_id  AND a.fiscal_year >= d.fiscal_year
AND a.status_flag='A' AND a.master_agreement_yn = 'N'
UNION ALL
SELECT 	d.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		b.year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id as document_agency_id,
		a.industry_type_id,
		a.award_size_id,
		d.document_id,
		d.vendor_name,
		d.check_eft_issued_date,
		d.agency_name,
		d.department_short_name,
		d.check_amount,
		d.expenditure_object_name,
		d.budget_name,
		d.contract_number,
		d.purpose,
		d.reporting_code,
		d.spending_category_name,
		d.agency_id,
		d.vendor_id,
		d.expenditure_object_id,
		d.department_id,
		d.spending_category_id,
		d.agreement_id,
		d.contract_document_code,
		d.master_agreement_id,
		d.check_eft_issued_nyc_year_id,
		d.check_eft_issued_cal_month_id,
		'A' as status_flag,
		'B' as type_of_year
FROM   agreement_snapshot_expanded a, ref_year b, disbursement_line_item_details d
WHERE a.fiscal_year = b.year_value 
AND a.original_agreement_id = d.master_agreement_id  AND a.fiscal_year >= d.fiscal_year
AND a.status_flag='A' AND a.master_agreement_yn = 'Y'
UNION ALL
 SELECT d.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		b.year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id as document_agency_id,
		a.industry_type_id,
		a.award_size_id,
		d.document_id,
		d.vendor_name,
		d.check_eft_issued_date,
		d.agency_name,
		d.department_short_name,
		d.check_amount,
		d.expenditure_object_name,
		d.budget_name,
		d.contract_number,
		d.purpose,
		d.reporting_code,
		d.spending_category_name,
		d.agency_id,
		d.vendor_id,
		d.expenditure_object_id,
		d.department_id,
		d.spending_category_id,
		d.agreement_id,
		d.contract_document_code,
		d.master_agreement_id,
		d.check_eft_issued_nyc_year_id,
		d.check_eft_issued_cal_month_id,
		'R' as status_flag,
		'B' as type_of_year
FROM   agreement_snapshot_expanded a, ref_year b, disbursement_line_item_details d
WHERE a.fiscal_year = b.year_value 
AND a.original_agreement_id = d.agreement_id  AND a.fiscal_year >= d.fiscal_year
AND a.status_flag='R' AND a.master_agreement_yn = 'N' 
UNION ALL
 SELECT d.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		b.year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id as document_agency_id,
		a.industry_type_id,
		a.award_size_id,
		d.document_id,
		d.vendor_name,
		d.check_eft_issued_date,
		d.agency_name,
		d.department_short_name,
		d.check_amount,
		d.expenditure_object_name,
		d.budget_name,
		d.contract_number,
		d.purpose,
		d.reporting_code,
		d.spending_category_name,
		d.agency_id,
		d.vendor_id,
		d.expenditure_object_id,
		d.department_id,
		d.spending_category_id,
		d.agreement_id,
		d.contract_document_code,
		d.master_agreement_id,
		d.check_eft_issued_nyc_year_id,
		d.check_eft_issued_cal_month_id,
		'R' as status_flag,
		'B' as type_of_year
FROM   agreement_snapshot_expanded a, ref_year b, disbursement_line_item_details d
WHERE a.fiscal_year = b.year_value 
AND a.original_agreement_id = d.master_agreement_id  AND a.fiscal_year >= d.fiscal_year
AND a.status_flag='R' AND a.master_agreement_yn = 'Y';

 INSERT INTO contracts_spending_transactions
 SELECT d.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		b.year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id as document_agency_id,
		a.industry_type_id,
		a.award_size_id,
		d.document_id,
		d.vendor_name,
		d.check_eft_issued_date,
		d.agency_name,
		d.department_short_name,
		d.check_amount,
		d.expenditure_object_name,
		d.budget_name,
		d.contract_number,
		d.purpose,
		d.reporting_code,
		d.spending_category_name,
		d.agency_id,
		d.vendor_id,
		d.expenditure_object_id,
		d.department_id,
		d.spending_category_id,
		d.agreement_id,
		d.contract_document_code,
		d.master_agreement_id,
		d.calendar_fiscal_year_id,
		d.check_eft_issued_cal_month_id,
		'A' as status_flag,
		'C' as type_of_year
FROM   agreement_snapshot_expanded_cy a, ref_year b, disbursement_line_item_details d
WHERE a.fiscal_year = b.year_value 
AND a.original_agreement_id = d.agreement_id  AND a.fiscal_year >= d.calendar_fiscal_year
AND a.status_flag='A' AND a.master_agreement_yn = 'N' 
UNION ALL
 SELECT d.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		b.year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id as document_agency_id,
		a.industry_type_id,
		a.award_size_id,
		d.document_id,
		d.vendor_name,
		d.check_eft_issued_date,
		d.agency_name,
		d.department_short_name,
		d.check_amount,
		d.expenditure_object_name,
		d.budget_name,
		d.contract_number,
		d.purpose,
		d.reporting_code,
		d.spending_category_name,
		d.agency_id,
		d.vendor_id,
		d.expenditure_object_id,
		d.department_id,
		d.spending_category_id,
		d.agreement_id,
		d.contract_document_code,
		d.master_agreement_id,
		d.calendar_fiscal_year_id,
		d.check_eft_issued_cal_month_id,
		'A' as status_flag,
		'C' as type_of_year
FROM   agreement_snapshot_expanded_cy a, ref_year b, disbursement_line_item_details d
WHERE a.fiscal_year = b.year_value 
AND a.original_agreement_id = d.master_agreement_id  AND a.fiscal_year >= d.calendar_fiscal_year
AND a.status_flag='A' AND a.master_agreement_yn = 'Y' 
UNION ALL
SELECT 	d.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		b.year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id as document_agency_id,
		a.industry_type_id,
		a.award_size_id,
		d.document_id,
		d.vendor_name,
		d.check_eft_issued_date,
		d.agency_name,
		d.department_short_name,
		d.check_amount,
		d.expenditure_object_name,
		d.budget_name,
		d.contract_number,
		d.purpose,
		d.reporting_code,
		d.spending_category_name,
		d.agency_id,
		d.vendor_id,
		d.expenditure_object_id,
		d.department_id,
		d.spending_category_id,
		d.agreement_id,
		d.contract_document_code,
		d.master_agreement_id,
		d.calendar_fiscal_year_id,
		d.check_eft_issued_cal_month_id,
		'R' as status_flag,
		'C' as type_of_year
FROM   agreement_snapshot_expanded_cy a, ref_year b, disbursement_line_item_details d
WHERE a.fiscal_year = b.year_value 
AND a.original_agreement_id = d.agreement_id  AND a.fiscal_year >= d.calendar_fiscal_year
AND a.status_flag='R' AND a.master_agreement_yn = 'N'
UNION ALL
SELECT 	d.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		b.year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id as document_agency_id,
		a.industry_type_id,
		a.award_size_id,
		d.document_id,
		d.vendor_name,
		d.check_eft_issued_date,
		d.agency_name,
		d.department_short_name,
		d.check_amount,
		d.expenditure_object_name,
		d.budget_name,
		d.contract_number,
		d.purpose,
		d.reporting_code,
		d.spending_category_name,
		d.agency_id,
		d.vendor_id,
		d.expenditure_object_id,
		d.department_id,
		d.spending_category_id,
		d.agreement_id,
		d.contract_document_code,
		d.master_agreement_id,
		d.calendar_fiscal_year_id,
		d.check_eft_issued_cal_month_id,
		'R' as status_flag,
		'C' as type_of_year
FROM   agreement_snapshot_expanded_cy a, ref_year b, disbursement_line_item_details d
WHERE a.fiscal_year = b.year_value 
AND a.original_agreement_id = d.master_agreement_id  AND a.fiscal_year >= d.calendar_fiscal_year
AND a.status_flag='R' AND a.master_agreement_yn = 'Y';
 
 
/*
 
 INSERT INTO contracts_spending_transactions
SELECT 	b.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		a.fiscal_year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id,
		'A' as status_flag,
		'B' as type_of_year
FROM aggregateon_contracts_cumulative_spending a 
JOIN disbursement_line_item_details b ON a.original_agreement_id = b.agreement_id 
AND a.fiscal_year >= b.fiscal_year
WHERE a.status_flag='A' AND a.type_of_year = 'B'
UNION ALL
SELECT 	b.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		a.fiscal_year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id,
		'R' as status_flag,
		'B' as type_of_year
FROM aggregateon_contracts_cumulative_spending a 
JOIN disbursement_line_item_details b ON a.original_agreement_id = b.agreement_id 
AND a.fiscal_year >= b.fiscal_year
WHERE a.status_flag='R' AND a.type_of_year = 'B' ;


INSERT INTO contracts_spending_transactions
SELECT 	b.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		a.fiscal_year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id,
		'A' as status_flag,
		'C' as type_of_year
FROM aggregateon_contracts_cumulative_spending a 
JOIN disbursement_line_item_details b ON a.original_agreement_id = b.agreement_id 
AND a.fiscal_year >= b.calendar_fiscal_year
WHERE a.status_flag='A' AND a.type_of_year = 'C'
UNION ALL
SELECT 	b.disbursement_line_item_id, 
		a.original_agreement_id,
		a.fiscal_year,
		a.fiscal_year_id,
		a.document_code_id,
		a.vendor_id,
		a.award_method_id,
		a.agency_id,
		'R' as status_flag,
		'C' as type_of_year
FROM aggregateon_contracts_cumulative_spending a 
JOIN disbursement_line_item_details b ON a.original_agreement_id = b.agreement_id 
AND a.fiscal_year >= b.calendar_fiscal_year
WHERE a.status_flag='R' AND a.type_of_year = 'C' ;
*/


DROP TABLE IF EXISTS aggregateon_contracts_expense;

CREATE TABLE aggregateon_contracts_expense(
	original_agreement_id bigint,
	expenditure_object_code character varying(4),
	expenditure_object_name character varying(40),
	encumbered_amount numeric(16,2),
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	is_disbursements_exist char(1)
) DISTRIBUTED BY (original_agreement_id);	
 
 /*
 INSERT INTO aggregateon_contracts_expense
 SELECT a.original_agreement_id, e.expenditure_object_id, e.expenditure_object_name, sum(b.line_amount) as encumbered_amount, sum(c.check_amount) as spending_amount
 FROM history_agreement a
 JOIN history_agreement_accounting_line b ON a.agreement_id = b.agreement_id AND a.latest_flag = 'Y'
 LEFT JOIN disbursement_line_item_details c ON a.original_agreement_id = c.agreement_id 
 AND b.line_number =  c.agreement_accounting_line_number  AND b.commodity_line_number = c.agreement_commodity_line_number
 JOIN ref_expenditure_object_history d ON d.expenditure_object_history_id = b.expenditure_object_history_id 
 JOIN ref_expenditure_object e ON e.expenditure_object_id = d.expenditure_object_id AND e.expenditure_object_id = c.expenditure_object_id
  GROUP BY 1,2,3 ;
  
  select original_agreement_id, expenditure_object_name, count(*) from aggregateon_contracts_expense group by 1,2 having count(*) > 1
 */

 INSERT INTO aggregateon_contracts_expense 
SELECT m.original_agreement_id, m.expenditure_object_code, m.expenditure_object_name, m.encumbered_amount,coalesce(n.spending_amount_disb,0) as spending_amount_disb, m.spending_amount, 
(CASE WHEN n.original_agreement_id IS NULL THEN 'N' ELSE 'Y' END) as is_disbursements_exist
FROM
 (SELECT a.original_agreement_id, d.expenditure_object_code,  d.expenditure_object_name, sum(b.line_amount) as encumbered_amount, sum(b.rfed_line_amount) as spending_amount
 FROM history_agreement a, history_agreement_accounting_line b , ref_expenditure_object_history c, ref_expenditure_object d 
 WHERE a.agreement_id = b.agreement_id AND a.latest_flag = 'Y' AND b.expenditure_object_history_id = c.expenditure_object_history_id AND  c.expenditure_object_id = d.expenditure_object_id
 GROUP BY 1,2,3) m LEFT JOIN
 (SELECT agreement_id as original_agreement_id, expenditure_object_code, sum(check_amount) as spending_amount_disb
 FROM disbursement_line_item_details
 GROUP BY 1,2) n ON m.original_agreement_id = n.original_agreement_id AND m.expenditure_object_code = n.expenditure_object_code ;
 