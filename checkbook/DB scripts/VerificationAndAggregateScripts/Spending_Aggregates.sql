-- SpendingByCOAEntitiesAndFiscalYear

TRUNCATE aggregateon_spending_coa_entities ;

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
  
  
 -- SpendingByVendorId
 
  TRUNCATE aggregateon_spending_vendor ;
  
  INSERT INTO aggregateon_spending_vendor
  SELECT vendor_id, agency_id,       
       month_id,
       year_id,
       'B' as type_of_year,
       sum(total_spending_amount) total_spending_amount,
       sum(contract_amount) total_contract_amount
  FROM (SELECT agency_id,
               vendor_id,
               check_eft_issued_cal_month_id as month_id,
               check_eft_issued_nyc_year_id AS year_id,
               COALESCE(master_agreement_id, agreement_id) AS agreement_id,
               sum(check_amount) AS total_spending_amount,
               MIN(
                  CASE
                     WHEN master_agreement_id > 0 THEN maximum_spending_limit
                     WHEN agreement_id > 0 THEN maximum_contract_amount
                     ELSE 0
                  END)
                  AS contract_amount
          FROM    disbursement_line_item_details a 
		  WHERE  a.spending_category_id <> 2
GROUP BY 1,2,3,4,5) X
GROUP BY 1,2,3,4,5 ;

 INSERT INTO aggregateon_spending_vendor
 SELECT vendor_id, agency_id,       
       month_id,
       year_id,
       'C' as type_of_year,
       sum(total_spending_amount) total_spending_amount,
       sum(contract_amount) total_contract_amount
  FROM (SELECT agency_id,
               vendor_id,
               check_eft_issued_cal_month_id as month_id,
               calendar_fiscal_year_id AS year_id,
               COALESCE(master_agreement_id, agreement_id) AS agreement_id,
               sum(check_amount) AS total_spending_amount,
               MIN(
                  CASE
                     WHEN master_agreement_id > 0 THEN maximum_spending_limit
                     WHEN agreement_id > 0 THEN maximum_contract_amount
                     ELSE 0
                  END)
                  AS contract_amount
          FROM    disbursement_line_item_details a 
		  WHERE  a.spending_category_id <> 2
GROUP BY 1,2,3,4,5) X
GROUP BY 1,2,3,4,5 ;

-- SpendingByContractId

TRUNCATE aggregateon_spending_contract ;

INSERT INTO aggregateon_spending_contract
SELECT * FROM
(SELECT COALESCE(master_agreement_id, agreement_id) as agreement_id, 
       COALESCE(master_contract_number,contract_number) as contract_number,
       COALESCE(master_contract_vendor_id,contract_vendor_id) as vendor_id,
       COALESCE(master_contract_agency_id,contract_agency_id) as agency_id,
       COALESCE(master_purpose,purpose) as description,
       check_eft_issued_nyc_year_id AS year_id,
       'B' as type_of_year,
       sum(check_amount) AS total_spending_amount,
       MIN(COALESCE(maximum_spending_limit,maximum_contract_amount)) AS total_contract_amount
  FROM disbursement_line_item_details
GROUP BY 1,2,3,4,5,6,7 ) inner_tbl
WHERE agreement_id IS NOT NULL ;


INSERT INTO aggregateon_spending_contract
SELECT * FROM
(SELECT COALESCE(master_agreement_id, agreement_id) as agreement_id,
       COALESCE(master_contract_number,contract_number) as contract_number,
       COALESCE(master_contract_vendor_id_cy,contract_vendor_id_cy) as vendor_id,
       COALESCE(master_contract_agency_id_cy,contract_agency_id_cy) as agency_id,
       COALESCE(master_purpose_cy,purpose_cy) as description,
       calendar_fiscal_year_id AS year_id,
       'C' as type_of_year,
       sum(check_amount) AS total_spending_amount,
       MIN(COALESCE(maximum_spending_limit_cy,maximum_contract_amount_cy)) AS total_contract_amount
  FROM disbursement_line_item_details
GROUP BY 1,2,3,4,5,6,7 ) inner_tbl
WHERE agreement_id IS NOT NULL ;

-- SpendingByVendorExpObject

TRUNCATE aggregateon_spending_vendor_exp_object ;

INSERT INTO aggregateon_spending_vendor_exp_object
SELECT vendor_id,expenditure_object_id,
 check_eft_issued_nyc_year_id AS year_id, 'B' as type_of_year,SUM(check_amount) as total_spending_amount
 FROM disbursement_line_item_details
GROUP BY 1,2,3 ;


INSERT INTO aggregateon_spending_vendor_exp_object
SELECT vendor_id,expenditure_object_id,
 calendar_fiscal_year_id AS year_id,  'C' as type_of_year,SUM(check_amount) as total_spending_amount
 FROM disbursement_line_item_details
GROUP BY 1,2,3 ;

