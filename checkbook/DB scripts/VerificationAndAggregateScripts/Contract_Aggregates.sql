-- Creating and populating agreement_snapshot_expanded table

DROP TABLE IF EXISTS agreement_snapshot_expanded;

CREATE TABLE agreement_snapshot_expanded(
	original_agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	vendor_id int,
	agency_id smallint,
	original_contract_amount numeric(16,2) ,
	maximum_contract_amount numeric(16,2),
	starting_year smallint,	
	ending_year smallint,
	dollar_difference numeric(16,2), 
	percent_difference numeric(17,4),
	award_method_id smallint,
	document_code_id smallint,
	master_agreement_id bigint,
	master_agreement_yn character(1),
	status_flag char(1)
	)
DISTRIBUTED BY (original_agreement_id);	

INSERT INTO agreement_snapshot_expanded
SELECT  original_agreement_id ,
	fiscal_year ,
	description ,
	contract_number ,
	vendor_id ,
	agency_id,
	original_contract_amount ,
	maximum_contract_amount ,
	starting_year,	
	ending_year ,
	dollar_difference , 
	percent_difference ,
	award_method_id,
	document_code_id,
	master_agreement_id,
	master_agreement_yn,
	status_flag
FROM	
(SELECT original_agreement_id,
	generate_series(effective_begin_year,effective_end_year,1) as fiscal_year,
	description,
	contract_number,
	vendor_id,
	agency_id,
	original_contract_amount,
	maximum_contract_amount,
	starting_year,	
	ending_year,
	dollar_difference,
	percent_difference,
	award_method_id,
	document_code_id,
	master_agreement_id,
	master_agreement_yn,
	'A' as status_flag
FROM	agreement_snapshot ) expanded_tbl WHERE fiscal_year between starting_year AND ending_year
AND fiscal_year >= 2010 AND ( (fiscal_year <= extract(year from now()::date) AND extract(month from now()::date) <= 6) OR
		     (fiscal_year <= (extract(year from now()::date)::smallint)+1 AND extract(month from now()::date) > 6) );

INSERT INTO agreement_snapshot_expanded
SELECT original_agreement_id,
	registered_year,
	description,
	contract_number,
	vendor_id,
	agency_id,
	original_contract_amount,
	maximum_contract_amount,
	starting_year,	
	ending_year,
	dollar_difference,
	percent_difference,
	award_method_id,
	document_code_id,
	master_agreement_id,
	master_agreement_yn,
	'R' as status_flag
FROM	agreement_snapshot
WHERE registered_year between starting_year AND ending_year
AND registered_year >= 2010 ;

-- For Calendar Year

DROP TABLE IF EXISTS agreement_snapshot_expanded_cy;

CREATE TABLE agreement_snapshot_expanded_cy(
	original_agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	vendor_id int,
	agency_id smallint,
	original_contract_amount numeric(16,2) ,
	maximum_contract_amount numeric(16,2),
	starting_year smallint,	
	ending_year smallint,
	dollar_difference numeric(16,2), 
	percent_difference numeric(17,4),
	award_method_id smallint,
	document_code_id smallint,
	master_agreement_id bigint,
	master_agreement_yn character(1),
	status_flag char(1)
	)
DISTRIBUTED BY (original_agreement_id);	

INSERT INTO agreement_snapshot_expanded_cy
SELECT  original_agreement_id ,
	fiscal_year ,
	description ,
	contract_number ,
	vendor_id ,
	agency_id,
	original_contract_amount ,
	maximum_contract_amount ,
	starting_year,	
	ending_year ,
	dollar_difference , 
	percent_difference ,
	award_method_id,
	document_code_id,
	master_agreement_id,
	master_agreement_yn,
	status_flag
FROM	
(SELECT original_agreement_id,
	generate_series(effective_begin_year,effective_end_year,1) as fiscal_year,
	description,
	contract_number,
	vendor_id,
	agency_id,
	original_contract_amount,
	maximum_contract_amount,
	starting_year,	
	ending_year,
	dollar_difference,
	percent_difference,
	award_method_id,
	document_code_id,
	master_agreement_id,
	master_agreement_yn,
	'A' as status_flag
FROM	agreement_snapshot_cy ) expanded_tbl WHERE fiscal_year between starting_year AND ending_year
AND fiscal_year >= 2010 AND ( (fiscal_year <= extract(year from now()::date) AND extract(month from now()::date) <= 6) OR
		     (fiscal_year <= (extract(year from now()::date)::smallint)+1 AND extract(month from now()::date) > 6) );

INSERT INTO agreement_snapshot_expanded_cy
SELECT original_agreement_id,
	registered_year,
	description,
	contract_number,
	vendor_id,
	agency_id,
	original_contract_amount,
	maximum_contract_amount,
	starting_year,	
	ending_year,
	dollar_difference,
	percent_difference,
	award_method_id,
	document_code_id,
	master_agreement_id,
	master_agreement_yn,
	'R' as status_flag
FROM	agreement_snapshot_cy
WHERE registered_year between starting_year AND ending_year
AND registered_year >= 2010 ;

-- Creating mid Aggregate tables

-- For Contracts

DROP TABLE IF EXISTS mid_aggregateon_disbursement_spending_date;

CREATE TABLE mid_aggregateon_disbursement_spending_date(
	original_agreement_id bigint,
	date_value date,
	agency_id smallint,
	check_amount numeric(16,2),
	date_order int,
	date_order_cy int,
	fiscal_year smallint,
	calendar_year smallint,
	master_agreement_yn character(1)
	)
DISTRIBUTED BY (original_agreement_id) 	;

-- For Contracts

INSERT INTO mid_aggregateon_disbursement_spending_date
SELECT  agreement_id,
	check_eft_issued_date,
	agency_id,
	SUM(check_amount) as check_amount,
	rank() OVER (partition by agreement_id,fiscal_year ORDER BY check_eft_issued_date DESC ,agency_id) as date_order,
	rank() OVER (partition by agreement_id,calendar_fiscal_year ORDER BY check_eft_issued_date DESC ,agency_id) as date_order_cy,
        fiscal_year,
        calendar_fiscal_year,
		'N' as master_agreement_yn
FROM	disbursement_line_item_details
WHERE agreement_id IS NOT NULL
GROUP BY 1,2,3,7,8,9;

-- For master agreements

INSERT INTO mid_aggregateon_disbursement_spending_date
SELECT  master_agreement_id,
	check_eft_issued_date,	
	NULL as agency_id,
	SUM(check_amount) as check_amount,	
	NULL as date_order,
	NULL as date_order_cy,
    fiscal_year,
    calendar_fiscal_year,
	'Y' as master_agreement_yn
FROM	disbursement_line_item_details
WHERE master_agreement_id IS NOT NULL
GROUP BY 1,2,7,8,9;


-- For Contracts

DROP TABLE IF EXISTS mid_aggregateon_disbursement_spending_year;
	
CREATE TABLE mid_aggregateon_disbursement_spending_year(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	agency_id smallint,
	check_amount numeric(16,2),
	type_of_year char(1),
	master_agreement_yn character(1))
DISTRIBUTED BY (original_agreement_id) 	;

-- For Contracts

INSERT INTO mid_aggregateon_disbursement_spending_year
SELECT original_agreement_id,
	a.fiscal_year,
	year_id,
	MIN(CASE WHEN date_order = 1 THEN agency_id END) as agency_id,
	SUM(check_amount),
	'B' as type_of_year,
	'N' as master_agreement_yn
FROM	mid_aggregateon_disbursement_spending_date a JOIN ref_year b ON a.fiscal_year = b.year_value
WHERE a.master_agreement_yn = 'N'
GROUP  BY 1,2,3,6,7
UNION ALL
SELECT original_agreement_id,
	a.calendar_year,
	year_id,
	MIN(CASE WHEN date_order_cy = 1 THEN agency_id END) as agency_id,
	SUM(check_amount),
	'C' as type_of_year,
	'N' as master_agreement_yn
FROM	mid_aggregateon_disbursement_spending_date a JOIN ref_year b ON a.calendar_year = b.year_value
WHERE a.master_agreement_yn = 'N'
GROUP  BY 1,2,3,6,7;

-- For master agreements

INSERT INTO mid_aggregateon_disbursement_spending_year
SELECT original_agreement_id,
	a.fiscal_year,
	year_id,
	NULL::INT as agency_id,
	SUM(check_amount),
	'B' as type_of_year,
	'Y' as master_agreement_yn
FROM	mid_aggregateon_disbursement_spending_date a JOIN ref_year b ON a.fiscal_year = b.year_value
WHERE a.master_agreement_yn = 'Y'
GROUP  BY 1,2,3,6,7
UNION ALL
SELECT original_agreement_id,
	a.calendar_year,
	year_id,
	NULL::INT as agency_id,
	SUM(check_amount),
	'C' as type_of_year,
	'Y' as master_agreement_yn
FROM	mid_aggregateon_disbursement_spending_date a JOIN ref_year b ON a.calendar_year = b.year_value
WHERE a.master_agreement_yn = 'Y'
GROUP  BY 1,2,3,6,7;



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
	vendor_id bigint,
	award_method_id smallint,
	agency_id smallint,
	original_contract_amount numeric(16,2),
	maximum_contract_amount numeric(16,2),
	spending_amount numeric(16,2),
	current_year_spending_amount numeric(16,2),
	dollar_difference numeric(16,2),
	percent_difference numeric(16,2),
	status_flag char(1),
	type_of_year char(1)	
) DISTRIBUTED BY (vendor_id);	


-- For Fiscal year 
	
INSERT INTO aggregateon_contracts_cumulative_spending
SELECT  original_agreement_id,
	fiscal_year,
	year_id,
	document_code_id,	
	master_agreement_yn,
	MIN(description),
	MIN(contract_number),
	MIN(vendor_id),
	MIN(award_method_id),
	MIN(case when master_agreement_yn = 'N' THEN funding_agency_id WHEN  master_agreement_yn = 'Y'  THEN document_agency_id ELSE NULL END) as agency_id,
	MIN(original_contract_amount),
	MIN(maximum_contract_amount),
	SUM(check_amount),
	SUM(CASE WHEN spending_fiscal_year IS NOT NULL AND fiscal_year = spending_fiscal_year THEN check_amount ELSE 0 END) as current_year_spending_amount,
	MIN(dollar_difference),
	MIN(percent_difference),
	'A' as status_flag,
	'B' as type_of_year
FROM
(
	SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		a.master_agreement_yn,
		description,
		contract_number,
		vendor_id,
		award_method_id,
		original_contract_amount,
		maximum_contract_amount,
		dollar_difference,
		percent_difference,
		b.fiscal_year as spending_fiscal_year,
		a.agency_id as document_agency_id,
		b.check_amount,
		first_value(b.agency_id) over (partition by a.original_agreement_id,a.fiscal_year  ORDER BY b.fiscal_year desc) as funding_agency_id
	FROM 	agreement_snapshot_expanded a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='B'
	WHERE  a.status_flag='A'
) expanded_tbl 
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
	MIN(CASE WHEN a.master_agreement_yn = 'N' THEN b.agency_id WHEN  a.master_agreement_yn = 'Y'  THEN a.agency_id ELSE NULL END) as agency_id,
	MIN(original_contract_amount),
	MIN(maximum_contract_amount),
	SUM(b.check_amount) ,
	SUM(CASE WHEN b.fiscal_year IS NOT NULL AND a.fiscal_year = b.fiscal_year THEN b.check_amount ELSE 0 END) as current_year_spending_amount,
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
SELECT  original_agreement_id,
	fiscal_year,	
	year_id,
	document_code_id,
	master_agreement_yn,
	MIN(description),
	MIN(contract_number),
	MIN(vendor_id),
	MIN(award_method_id),
	MIN(case when master_agreement_yn = 'N' THEN funding_agency_id WHEN  master_agreement_yn = 'Y'  THEN document_agency_id ELSE NULL END) as agency_id,
	MIN(original_contract_amount),
	MIN(maximum_contract_amount),
	SUM(check_amount),
	SUM(CASE WHEN spending_fiscal_year IS NOT NULL AND fiscal_year = spending_fiscal_year THEN check_amount ELSE 0 END) as current_year_spending_amount,
	MIN(dollar_difference),
	MIN(percent_difference),
	'A' as status_flag,
	'C' as type_of_year
FROM
(
	SELECT  a.original_agreement_id,
		a.fiscal_year,
		ry.year_id,
		document_code_id,
		a.master_agreement_yn,
		description,
		contract_number,
		vendor_id,
		award_method_id,
		original_contract_amount,
		maximum_contract_amount,
		dollar_difference,
		percent_difference,
		b.fiscal_year as spending_fiscal_year,
		a.agency_id as document_agency_id,
		b.check_amount,
		first_value(b.agency_id) over (partition by a.original_agreement_id,a.fiscal_year  ORDER BY b.fiscal_year desc) as funding_agency_id
	FROM 	agreement_snapshot_expanded_cy a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='C'
	WHERE  a.status_flag='A'
) expanded_tbl 
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
	MIN(CASE WHEN a.master_agreement_yn = 'N' THEN b.agency_id WHEN  a.master_agreement_yn = 'Y'  THEN a.agency_id ELSE NULL END) as agency_id,
	MIN(original_contract_amount),
	MIN(maximum_contract_amount),
	SUM(b.check_amount) ,
	SUM(CASE WHEN b.fiscal_year IS NOT NULL AND a.fiscal_year = b.fiscal_year THEN check_amount ELSE 0 END) as current_year_spending_amount,
	MIN(dollar_difference),
	MIN(percent_difference),
	'R' as status_flag, 
	'C' as type_of_year	
	FROM 	agreement_snapshot_expanded_cy a 
	LEFT JOIN ref_year ry ON a.fiscal_year = ry.year_value 
	LEFT JOIN mid_aggregateon_disbursement_spending_year b ON a.original_agreement_id = b.original_agreement_id AND a.fiscal_year >= b.fiscal_year AND b.type_of_year ='C'
	WHERE   a.status_flag='R'
	GROUP BY 1,2,3,4,5;
		
		

-- For Contracts total, committed contracts total  and total spending till date group by agency

DROP TABLE IF EXISTS aggregateon_total_contracts_agency;

CREATE TABLE aggregateon_total_contracts_agency
(
fiscal_year smallint,
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
GROUP BY 1,2,10,11;

-- For Contracts total, committed contracts total  and total spending till date

DROP TABLE IF EXISTS aggregateon_total_contracts;

CREATE TABLE aggregateon_total_contracts
(
fiscal_year smallint,
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

INSERT INTO aggregateon_total_contracts
SELECT 	fiscal_year, 
		count(*) as  total_contracts,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1','CT1','POC','POD','PCC1') THEN 1 ELSE 0 END) AS total_commited_contracts,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1') THEN 1 ELSE 0 END) AS total_master_agreements,
		SUM(CASE WHEN b.document_code IN ('CT1','POC','POD','PCC1') THEN  1 ELSE 0 END) AS total_standalone_contracts,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1','CT1','POC','POD','PCC1') THEN maximum_contract_amount ELSE 0 END) AS total_commited_contracts_amount,
		SUM(maximum_contract_amount) as total_contracts_amount,
		SUM(CASE WHEN b.document_code IN ('MA1','MMA1') THEN 0 ELSE spending_amount END) as total_spending_amount,
		status_flag,
		type_of_year
FROM aggregateon_contracts_cumulative_spending a LEFT JOIN ref_document_code b ON a.document_code_id = b.document_code_id
GROUP BY 1,9,10;	

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
	agency_id smallint,
	department_id integer,
	fiscal_year smallint,
	fiscal_year_id smallint,
	spending_amount numeric(16,2),
	total_contracts integer,
	status_flag char(1),
	type_of_year char(1)
) DISTRIBUTED BY (agency_id);	
 
 
 INSERT INTO aggregateon_contracts_department
 SELECT c.agency_id, 
		c.department_id,
		a.fiscal_year,
		b.year_id,
		sum(c.check_amount) as spending_amount,
		count(distinct a.original_agreement_id) as total_contracts,
		'A' as status_flag,
		'B' as type_of_year
 FROM agreement_snapshot_expanded a JOIN ref_year b ON a.fiscal_year = b.year_value
 LEFT JOIN disbursement_line_item_details c ON a.original_agreement_id = c.agreement_id AND a.fiscal_year >= c.fiscal_year
 WHERE  a.master_agreement_yn = 'N' AND a.status_flag='A' GROUP BY 1,2,3,4	
 UNION ALL 
 SELECT c.agency_id, 
		c.department_id,
		a.fiscal_year,
		b.year_id,
		sum(c.check_amount) as spending_amount,
		count(distinct a.original_agreement_id) as total_contracts,
		'R' as status_flag,
		'B' as type_of_year
 FROM agreement_snapshot_expanded a JOIN ref_year b ON a.fiscal_year = b.year_value
 LEFT JOIN disbursement_line_item_details c ON a.original_agreement_id = c.agreement_id AND a.fiscal_year >= c.fiscal_year
 WHERE  a.master_agreement_yn = 'N' AND a.status_flag='R' GROUP BY 1,2,3,4	;
 
 INSERT INTO aggregateon_contracts_department
 SELECT c.agency_id, 
		c.department_id,
		a.fiscal_year,
		b.year_id,
		sum(c.check_amount) as spending_amount,
		count(distinct a.original_agreement_id) as total_contracts,
		'A' as status_flag,
		'C' as type_of_year
 FROM agreement_snapshot_expanded_cy a JOIN ref_year b ON a.fiscal_year = b.year_value
 LEFT JOIN disbursement_line_item_details c ON a.original_agreement_id = c.agreement_id AND a.fiscal_year >= c.calendar_fiscal_year
 WHERE  a.master_agreement_yn = 'N' AND a.status_flag='A' GROUP BY 1,2,3,4	
 UNION ALL 
 SELECT c.agency_id, 
		c.department_id,
		a.fiscal_year,
		b.year_id,
		sum(c.check_amount) as spending_amount,
		count(distinct a.original_agreement_id) as total_contracts,
		'R' as status_flag,
		'C' as type_of_year
 FROM agreement_snapshot_expanded_cy a JOIN ref_year b ON a.fiscal_year = b.year_value
 LEFT JOIN disbursement_line_item_details c ON a.original_agreement_id = c.agreement_id AND a.fiscal_year >= c.calendar_fiscal_year
 WHERE  a.master_agreement_yn = 'N' AND a.status_flag='R' GROUP BY 1,2,3,4	;