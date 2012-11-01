-- SpendingByCOAEntitiesAndFiscalYear

DROP TABLE IF EXISTS aggregateon_spending_coa_entities ;

CREATE TABLE aggregateon_spending_coa_entities (
	department_id integer,
	agency_id smallint,
	spending_category_id smallint,
	expenditure_object_id integer,
	month_id int,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2)
	) DISTRIBUTED BY (department_id) ;
	
	
INSERT INTO aggregateon_spending_coa_entities
SELECT department_id,agency_id,
       spending_category_id,
       expenditure_object_id,       
       month_id,
       year_id,
       'B' as type_of_year,
       sum(total_spending_amount) total_spending_amount
  FROM (SELECT agency_id,
               spending_category_id,
               expenditure_object_id,
               department_id,
               COALESCE(master_agreement_id, agreement_id) AS agreement_id,
               check_eft_issued_cal_month_id AS month_id,
               check_eft_issued_nyc_year_id AS year_id,
               sum(check_amount) AS total_spending_amount
          FROM disbursement_line_item_details a
          JOIN ref_fund_class b ON a.fund_class_id = b.fund_class_id           
  GROUP BY 1,2,3,4,5,6,7) X
  GROUP BY 1,2,3,4,5,6,7 ;
  
  
INSERT INTO aggregateon_spending_coa_entities
SELECT department_id,agency_id,
       spending_category_id,
       expenditure_object_id,       
       month_id,
       year_id,
       'C' as type_of_year,
       sum(total_spending_amount) total_spending_amount
  FROM (SELECT agency_id,
               spending_category_id,
               expenditure_object_id,
               department_id,
               COALESCE(master_agreement_id, agreement_id) AS agreement_id,
               check_eft_issued_cal_month_id AS month_id,
               calendar_fiscal_year_id AS year_id,
               sum(check_amount) AS total_spending_amount
          FROM disbursement_line_item_details a
          JOIN ref_fund_class b ON a.fund_class_id = b.fund_class_id 
  GROUP BY 1,2,3,4,5,6,7) X
  GROUP BY 1,2,3,4,5,6,7 ;
  
  
/*
INSERT INTO aggregateon_spending_coa_entities
SELECT department_id,agency_id,
       spending_category_id,
       expenditure_object_id,       
       month_id,
       year_id,
       'B' as type_of_year,
       sum(total_spending_amount) total_spending_amount,
       sum(contract_amount) total_contract_amount
  FROM (SELECT agency_id,
               spending_category_id,
               expenditure_object_id,
               department_id,
               COALESCE(master_agreement_id, agreement_id) AS agreement_id,
               check_eft_issued_cal_month_id AS month_id,
               check_eft_issued_nyc_year_id AS year_id,
               sum(check_amount) AS total_spending_amount,
               MIN(
                  CASE
                     WHEN master_agreement_id > 0 THEN maximum_spending_limit
                     WHEN agreement_id > 0 THEN maximum_contract_amount
                     ELSE 0
                  END)
                  AS contract_amount
          FROM disbursement_line_item_details a
          JOIN ref_fund_class b ON a.fund_class_id = b.fund_class_id           
  GROUP BY 1,2,3,4,5,6,7) X
  GROUP BY 1,2,3,4,5,6,7 ;
  
  
INSERT INTO aggregateon_spending_coa_entities
SELECT department_id,agency_id,
       spending_category_id,
       expenditure_object_id,       
       month_id,
       year_id,
       'C' as type_of_year,
       sum(total_spending_amount) total_spending_amount,
       sum(contract_amount) total_contract_amount
  FROM (SELECT agency_id,
               spending_category_id,
               expenditure_object_id,
               department_id,
               COALESCE(master_agreement_id, agreement_id) AS agreement_id,
               check_eft_issued_cal_month_id AS month_id,
               calendar_fiscal_year_id AS year_id,
               sum(check_amount) AS total_spending_amount,
               MIN(
                  CASE
                     WHEN master_agreement_id > 0 THEN maximum_spending_limit
                     WHEN agreement_id > 0 THEN maximum_contract_amount
                     ELSE 0
                  END)
                  AS contract_amount
          FROM disbursement_line_item_details a
          JOIN ref_fund_class b ON a.fund_class_id = b.fund_class_id 
  GROUP BY 1,2,3,4,5,6,7) X
  GROUP BY 1,2,3,4,5,6,7 ;
  
*/
	
	
	
  -- SpendingByContractId

DROP TABLE IF EXISTS aggregateon_spending_contract ;

CREATE TABLE aggregateon_spending_contract (
    agreement_id bigint,
    document_id character varying(20),
	vendor_id integer,
	agency_id smallint,
	description character varying(60),	
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2), 
	total_contract_amount numeric(16,2)
	) DISTRIBUTED BY (agreement_id) ;
	
	

INSERT INTO aggregateon_spending_contract
SELECT agreement_id, contract_number, vendor_id, agency_id, description,  
spending_category_id, year_id, type_of_year,
 sum(total_spending_amount) total_spending_amount,
  sum(contract_amount) total_contract_amount
FROM
(SELECT COALESCE(master_agreement_id, agreement_id) as agreement_id, 
       COALESCE(master_contract_number,contract_number) as contract_number,
       COALESCE(master_contract_vendor_id,contract_vendor_id) as vendor_id,
       COALESCE(master_contract_agency_id,contract_agency_id) as agency_id,
       COALESCE(master_purpose,purpose) as description,
       spending_category_id,
       check_eft_issued_nyc_year_id AS year_id,
       'B' as type_of_year,
       sum(check_amount) AS total_spending_amount,
       MIN(COALESCE(maximum_spending_limit,maximum_contract_amount)) AS contract_amount
  FROM disbursement_line_item_details 
  WHERE agreement_id IS NOT NULL
GROUP BY 1,2,3,4,5,6,7,8
) X
GROUP BY 1,2,3,4,5,6,7,8  ;


INSERT INTO aggregateon_spending_contract
SELECT agreement_id, contract_number, vendor_id, agency_id, description,  
 spending_category_id, year_id, type_of_year,
 sum(total_spending_amount) total_spending_amount,
  sum(contract_amount) total_contract_amount
  FROM
(SELECT COALESCE(master_agreement_id, agreement_id) as agreement_id,
       COALESCE(master_contract_number,contract_number) as contract_number,
       COALESCE(master_contract_vendor_id_cy,contract_vendor_id_cy) as vendor_id,
       COALESCE(master_contract_agency_id_cy,contract_agency_id_cy) as agency_id,
       COALESCE(master_purpose_cy,purpose_cy) as description,
       calendar_fiscal_year_id AS year_id,   
       spending_category_id,
       'C' as type_of_year,
       sum(check_amount) AS total_spending_amount,
       MIN(COALESCE(maximum_spending_limit_cy,maximum_contract_amount_cy)) AS contract_amount
  FROM disbursement_line_item_details
  WHERE agreement_id IS NOT NULL
GROUP BY 1,2,3,4,5,6,7,8 ) X
 GROUP BY 1,2,3,4,5,6,7,8 ;
 
 
 -- SpendingByVendorId
 
DROP TABLE IF EXISTS aggregateon_spending_vendor ;

CREATE TABLE aggregateon_spending_vendor (
	vendor_id integer,
	agency_id smallint,
	spending_category_id smallint,
	month_id int,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2), 
	total_contract_amount numeric(16,2),
	is_all_categories char(1)
	) DISTRIBUTED BY (vendor_id) ;
	
	
  
  INSERT INTO aggregateon_spending_vendor
  SELECT X.vendor_id, X.agency_id, X.spending_category_id,       
       X.month_id,
       X.year_id,
       X.type_of_year,
       X.total_spending_amount,
       Y.total_contract_amount,
       'N' as is_all_categories
  FROM (SELECT agency_id,
               vendor_id,
               spending_category_id,
               check_eft_issued_cal_month_id as month_id,
               check_eft_issued_nyc_year_id AS year_id,
               'B' as type_of_year,
               sum(check_amount) AS total_spending_amount
          FROM    disbursement_line_item_details a 
		  WHERE  a.spending_category_id <> 2
GROUP BY 1,2,3,4,5,6) X
LEFT JOIN (SELECT vendor_id, agency_id, spending_category_id, year_id, sum(total_contract_amount) as total_contract_amount
 FROM aggregateon_spending_contract WHERE type_of_year = 'B' 
 GROUP BY 1,2,3,4) Y
 ON X.vendor_id = Y.vendor_id AND X.agency_id = Y.agency_id AND X.spending_category_id = Y.spending_category_id AND X.year_id = Y.year_id 
 UNION ALL
   SELECT X.vendor_id, X.agency_id, X.spending_category_id::smallint,       
       X.month_id,
       X.year_id,
       X.type_of_year,
       X.total_spending_amount,
       Y.total_contract_amount,
       'Y' as is_all_categories
  FROM (SELECT agency_id,
               vendor_id,
               NULL as spending_category_id,
               check_eft_issued_cal_month_id as month_id,
               check_eft_issued_nyc_year_id AS year_id,
               'B' as type_of_year,
               sum(check_amount) AS total_spending_amount
          FROM    disbursement_line_item_details a 
		  WHERE  a.spending_category_id <> 2
GROUP BY 1,2,3,4,5,6) X
LEFT JOIN (SELECT vendor_id, agency_id, year_id, SUM(total_contract_amount) as total_contract_amount
FROM 
(SELECT agreement_id, vendor_id, agency_id, year_id, MIN(total_contract_amount) as total_contract_amount
 FROM aggregateon_spending_contract WHERE type_of_year = 'B' 
 GROUP BY 1,2,3,4) Z GROUP BY 1,2,3) Y
 ON X.vendor_id = Y.vendor_id AND X.agency_id = Y.agency_id AND X.year_id = Y.year_id  ;
 
 
 INSERT INTO aggregateon_spending_vendor
  SELECT X.vendor_id, X.agency_id, X.spending_category_id,       
       X.month_id,
       X.year_id,
       X.type_of_year,
       X.total_spending_amount,
       Y.total_contract_amount,
       'N' as is_all_categories
  FROM (SELECT agency_id,
               vendor_id,
               spending_category_id,
               check_eft_issued_cal_month_id as month_id,
               calendar_fiscal_year_id AS year_id,
               'C' as type_of_year,
               sum(check_amount) AS total_spending_amount
          FROM    disbursement_line_item_details a 
		  WHERE  a.spending_category_id <> 2
GROUP BY 1,2,3,4,5,6) X
LEFT JOIN (SELECT vendor_id, agency_id, spending_category_id, year_id, sum(total_contract_amount) as total_contract_amount
 FROM aggregateon_spending_contract WHERE type_of_year = 'C' 
 GROUP BY 1,2,3,4) Y
 ON X.vendor_id = Y.vendor_id AND X.agency_id = Y.agency_id AND X.spending_category_id = Y.spending_category_id AND X.year_id = Y.year_id 
 UNION ALL
   SELECT X.vendor_id, X.agency_id, X.spending_category_id::smallint,       
       X.month_id,
       X.year_id,
       X.type_of_year,
       X.total_spending_amount,
       Y.total_contract_amount,
       'Y' as is_all_categories
  FROM (SELECT agency_id,
               vendor_id,
               NULL as spending_category_id,
               check_eft_issued_cal_month_id as month_id,
               calendar_fiscal_year_id AS year_id,
               'C' as type_of_year,
               sum(check_amount) AS total_spending_amount
          FROM    disbursement_line_item_details a 
		  WHERE  a.spending_category_id <> 2
GROUP BY 1,2,3,4,5,6) X
LEFT JOIN (SELECT vendor_id, agency_id, year_id, SUM(total_contract_amount) as total_contract_amount
FROM 
(SELECT agreement_id, vendor_id, agency_id, year_id, MIN(total_contract_amount) as total_contract_amount
 FROM aggregateon_spending_contract WHERE type_of_year = 'C' 
 GROUP BY 1,2,3,4) Z GROUP BY 1,2,3) Y
 ON X.vendor_id = Y.vendor_id AND X.agency_id = Y.agency_id AND X.year_id = Y.year_id  ;
 

-- SpendingByVendorExpObject

DROP TABLE IF EXISTS aggregateon_spending_vendor_exp_object ;

CREATE TABLE aggregateon_spending_vendor_exp_object(
	vendor_id integer,
	expenditure_object_id integer,
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2) )
DISTRIBUTED BY (expenditure_object_id);	

INSERT INTO aggregateon_spending_vendor_exp_object
SELECT vendor_id,expenditure_object_id,spending_category_id,
 check_eft_issued_nyc_year_id AS year_id, 'B' as type_of_year,SUM(check_amount) as total_spending_amount
 FROM disbursement_line_item_details
GROUP BY 1,2,3,4 ;


INSERT INTO aggregateon_spending_vendor_exp_object
SELECT vendor_id,expenditure_object_id,spending_category_id,
 calendar_fiscal_year_id AS year_id,  'C' as type_of_year,SUM(check_amount) as total_spending_amount
 FROM disbursement_line_item_details
GROUP BY 1,2,3,4 ;

