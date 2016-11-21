-- Function: etl.refreshcommontransactiontables(bigint)

-- DROP FUNCTION etl.refreshcommontransactiontables(bigint);

CREATE OR REPLACE FUNCTION etl.refreshcommontransactiontables(p_job_id_in bigint)
  RETURNS integer AS
$BODY$
DECLARE
  l_start_time  timestamp;
  l_end_time  timestamp;
  
BEGIN
  
  

  l_start_time := timeofday()::timestamp;
  
  /*
  DELETE FROM ONLY all_agreement_transactions a
  USING agreement_snapshot b
  WHERE a.agreement_id = b.agreement_id 
  AND b.job_id = p_job_id_in AND a.is_prime_or_sub = 'P';
  
  
  DELETE FROM all_agreement_transactions WHERE is_prime_or_sub = 'S';
  */
  
  TRUNCATE TABLE all_agreement_transactions;
  
  INSERT INTO all_agreement_transactions(original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, prime_vendor_id, prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name,dollar_difference, percent_difference, 
            master_agreement_id, master_contract_number, agreement_type_id, 
            agreement_type_code, agreement_type_name, award_category_id, 
            award_category_code, award_category_name, award_method_id, award_method_code, 
            award_method_name, expenditure_object_codes, expenditure_object_names, 
            industry_type_id, industry_type_name, award_size_id, effective_begin_date, 
            effective_begin_date_id, effective_begin_year, effective_begin_year_id, 
            effective_end_date, effective_end_date_id, effective_end_year, 
            effective_end_year_id, registered_date, registered_date_id, brd_awd_no, 
            tracking_number, rfed_amount, minority_type_id, minority_type_name, 
            master_agreement_yn, has_children, has_mwbe_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, last_modified_year_id, is_prime_or_sub, 
            is_minority_vendor, vendor_type, contract_original_agreement_id, 
            is_subvendor, associated_prime_vendor_name, mwbe_category_ui, job_id, scntrc_status, scntrc_status_name, aprv_sta, aprv_sta_name)
    SELECT  original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, vendor_id as prime_vendor_id, vendor_name as prime_vendor_name, 
            minority_type_id as prime_minority_type_id, minority_type_name as prime_minority_type_name,dollar_difference, percent_difference, 
            master_agreement_id, master_contract_number, agreement_type_id, 
            agreement_type_code, agreement_type_name, award_category_id, 
            award_category_code, award_category_name, award_method_id, award_method_code, 
            award_method_name, expenditure_object_codes, expenditure_object_names, 
            industry_type_id, industry_type_name, award_size_id, effective_begin_date, 
            effective_begin_date_id, effective_begin_year, effective_begin_year_id, 
            effective_end_date, effective_end_date_id, effective_end_year, 
            effective_end_year_id, registered_date, registered_date_id, brd_awd_no, 
            tracking_number, rfed_amount, minority_type_id, minority_type_name, 
            master_agreement_yn, has_children, has_mwbe_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, b.nyc_year_id as last_modified_year_id, 'P' as is_prime_or_sub, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'Y' ELSE 'N' END) as is_minority_vendor, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'PM' ELSE 'P' END) as vendor_type,
            original_agreement_id as contract_original_agreement_id, 
            'No' as is_subvendor, 'N/A' as associated_prime_vendor_name, 
            (CASE WHEN minority_type_id = 2 THEN 'Black American' WHEN minority_type_id = 3 THEN 'Hispanic American' WHEN minority_type_id = 7 THEN 'Non-M/WBE'
          WHEN minority_type_id = 9 THEN 'Women' WHEN minority_type_id = 11 THEN 'Individuals and Others' ELSE 'Asian American' END) AS mwbe_category_ui, job_id, 
            COALESCE(scntrc_status,0) as scntrc_status,
            (CASE WHEN scntrc_status = 1 THEN 'No Data Entered' WHEN scntrc_status = 2 THEN 'Yes' WHEN scntrc_status = 3 THEN 'No' ELSE 'Prior Year Exclusions' END) AS scntrc_status_name,
            6 AS aprv_sta, 'N/A' AS aprv_sta_name
       FROM agreement_snapshot a LEFT JOIN ref_date b ON a.last_modified_date::date = b.date;
       
       
      INSERT INTO all_agreement_transactions(original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, sub_contract_id, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, prime_vendor_id, prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name,dollar_difference, 
            percent_difference, agreement_type_id, agreement_type_code, agreement_type_name, 
            award_category_id, award_category_code, award_category_name, 
            award_method_id, award_method_code, award_method_name, expenditure_object_codes, 
            expenditure_object_names, industry_type_id, industry_type_name, 
            award_size_id, effective_begin_date, effective_begin_date_id, 
            effective_begin_year, effective_begin_year_id, effective_end_date, 
            effective_end_date_id, effective_end_year, effective_end_year_id, 
            registered_date, registered_date_id, brd_awd_no, tracking_number, 
            rfed_amount, minority_type_id, minority_type_name, original_version_flag, 
            master_agreement_id,master_contract_number,master_agreement_yn,
            latest_flag, load_id, last_modified_date, last_modified_year_id, is_prime_or_sub, 
            is_minority_vendor, vendor_type, contract_original_agreement_id, 
            is_subvendor, associated_prime_vendor_name, mwbe_category_ui, job_id, scntrc_status, scntrc_status_name, aprv_sta, aprv_sta_name)
     SELECT a.original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, a.contract_number, a.sub_contract_id, a.original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, a.vendor_id, 
            vendor_code, vendor_name, prime_vendor_id, (CASE WHEN a.prime_vendor_id = 0 THEN 'N/A (PRIVACY/SECURITY)' ELSE c.legal_name END) as prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name,dollar_difference, 
            percent_difference, agreement_type_id, agreement_type_code, agreement_type_name, 
            award_category_id, award_category_code, award_category_name, 
            award_method_id, award_method_code, award_method_name, expenditure_object_codes, 
            expenditure_object_names, industry_type_id, industry_type_name, 
            award_size_id, effective_begin_date, effective_begin_date_id, 
            effective_begin_year, effective_begin_year_id, effective_end_date, 
            effective_end_date_id, effective_end_year, effective_end_year_id, 
            registered_date, registered_date_id, brd_awd_no, tracking_number, 
            rfed_amount, minority_type_id, minority_type_name, original_version_flag, 
            master_agreement_id,master_contract_number,'N' as master_agreement_yn,
            latest_flag, load_id, last_modified_date,  b.nyc_year_id as last_modified_year_id, 'S' as is_prime_or_sub, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'Y' ELSE 'N' END) as is_minority_vendor, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'SM' ELSE 'S' END) as vendor_type, 
            d.original_agreement_id as contract_original_agreement_id, 
            'Yes' as is_subvendor, (CASE WHEN a.prime_vendor_id = 0 THEN 'N/A (PRIVACY/SECURITY)' ELSE c.legal_name END) as associated_prime_vendor_name, 
            (CASE WHEN minority_type_id = 2 THEN 'Black American' WHEN minority_type_id = 3 THEN 'Hispanic American' WHEN minority_type_id = 7 THEN 'Non-M/WBE'
          WHEN minority_type_id = 9 THEN 'Women' WHEN minority_type_id = 11 THEN 'Individuals and Others' ELSE 'Asian American' END) AS mwbe_category_ui, job_id,
      COALESCE(e.scntrc_status,0) as scntrc_status,
      CASE
      WHEN e.scntrc_status = 1 THEN 'No Data Entered'
      WHEN e.scntrc_status = 2 THEN 'Yes'
      WHEN e.scntrc_status = 3 THEN 'No'
      ELSE 'Prior Year Exclusions'
      END AS scntrc_status_name, 
            (CASE WHEN aprv_sta=4 THEN (CASE WHEN payments.check_amount > 0 THEN  4 ELSE 1 END) WHEN aprv_sta is NULL THEN 0 ELSE aprv_sta END) AS aprv_sta,
            (CASE WHEN aprv_sta=4 THEN (CASE WHEN payments.check_amount >0 THEN 'ACCO Approved Sub Vendor' ELSE 'No Subcontract Payments Submitted' END )
          WHEN aprv_sta=2 THEN 'ACCO Rejected Sub Vendor'
          WHEN aprv_sta=5 THEN 'ACCO Canceled Sub Vendor'
          WHEN aprv_sta=3 THEN 'ACCO Reviewing Sub Vendor'
          WHEN aprv_sta is NULL THEN 'No Subcontract Information Submitted'
            END) as aprv_sta_name
     FROM sub_agreement_snapshot a 
     LEFT JOIN ref_date b ON a.last_modified_date::date = b.date
     LEFT JOIN vendor c ON a.prime_vendor_id = c.vendor_id
     LEFT JOIN (select original_agreement_id, contract_number from history_agreement where latest_flag = 'Y') d ON a.contract_number = d.contract_number
     LEFT JOIN (select contract_number, sub_contract_id, SUM(check_eft_amount) as check_amount from subcontract_spending group by 1,2) payments on a.contract_number = payments.contract_number and a.sub_contract_id= payments.sub_contract_id
     LEFT JOIN (SELECT a.contract_number,a.scntrc_status FROM agreement_snapshot a WHERE latest_flag = 'Y') e ON a.contract_number = e.contract_number;
       
        

RAISE NOTICE 'REF COMMON TT1';

/*
DELETE FROM ONLY all_agreement_transactions_cy a
  USING agreement_snapshot_cy b
  WHERE a.agreement_id = b.agreement_id 
  AND b.job_id = p_job_id_in AND a.is_prime_or_sub = 'P';
  */

  TRUNCATE TABLE all_agreement_transactions_cy ;
  
  INSERT INTO all_agreement_transactions_cy(original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, prime_vendor_id, prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name,dollar_difference, percent_difference, 
            master_agreement_id, master_contract_number, agreement_type_id, 
            agreement_type_code, agreement_type_name, award_category_id, 
            award_category_code, award_category_name, award_method_id, award_method_code, 
            award_method_name, expenditure_object_codes, expenditure_object_names, 
            industry_type_id, industry_type_name, award_size_id, effective_begin_date, 
            effective_begin_date_id, effective_begin_year, effective_begin_year_id, 
            effective_end_date, effective_end_date_id, effective_end_year, 
            effective_end_year_id, registered_date, registered_date_id, brd_awd_no, 
            tracking_number, rfed_amount, minority_type_id, minority_type_name, 
            master_agreement_yn, has_children, has_mwbe_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, last_modified_year_id, is_prime_or_sub, 
            is_minority_vendor, vendor_type, contract_original_agreement_id, 
            is_subvendor, associated_prime_vendor_name, mwbe_category_ui, job_id, scntrc_status, scntrc_status_name)
    SELECT  original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, vendor_id as prime_vendor_id, vendor_name as prime_vendor_name, 
            minority_type_id as prime_minority_type_id, minority_type_name as prime_minority_type_name,dollar_difference, percent_difference, 
            master_agreement_id, master_contract_number, agreement_type_id, 
            agreement_type_code, agreement_type_name, award_category_id, 
            award_category_code, award_category_name, award_method_id, award_method_code, 
            award_method_name, expenditure_object_codes, expenditure_object_names, 
            industry_type_id, industry_type_name, award_size_id, effective_begin_date, 
            effective_begin_date_id, effective_begin_year, effective_begin_year_id, 
            effective_end_date, effective_end_date_id, effective_end_year, 
            effective_end_year_id, registered_date, registered_date_id, brd_awd_no, 
            tracking_number, rfed_amount, minority_type_id, minority_type_name, 
            master_agreement_yn, has_children, has_mwbe_children, original_version_flag, latest_flag, 
            load_id, last_modified_date, c.year_id as last_modified_year_id, 'P' as is_prime_or_sub, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'Y' ELSE 'N' END) as is_minority_vendor, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'PM' ELSE 'P' END) as vendor_type,
            original_agreement_id as contract_original_agreement_id, 
            'No' as is_subvendor, 'N/A' as associated_prime_vendor_name, 
            (CASE WHEN minority_type_id = 2 THEN 'Black American' WHEN minority_type_id = 3 THEN 'Hispanic American' WHEN minority_type_id = 7 THEN 'Non-M/WBE'
          WHEN minority_type_id = 9 THEN 'Women' WHEN minority_type_id = 11 THEN 'Individuals and Others' ELSE 'Asian American' END) AS mwbe_category_ui, job_id,
            COALESCE(scntrc_status,0),
            (CASE WHEN scntrc_status = 1 THEN 'No Data Entered' WHEN scntrc_status = 2 THEN 'Yes' WHEN scntrc_status = 3 THEN 'No' ELSE 'N/A' END) AS scntrc_status_name
        FROM agreement_snapshot_cy a LEFT JOIN ref_date b ON a.last_modified_date::date = b.date
        LEFT JOIN ref_month c ON b.calendar_month_id = c.month_id;
       
       
      INSERT INTO all_agreement_transactions_cy(original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, contract_number, sub_contract_id, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, vendor_id, 
            vendor_code, vendor_name, prime_vendor_id, prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name,dollar_difference, 
            percent_difference, agreement_type_id, agreement_type_code, agreement_type_name, 
            award_category_id, award_category_code, award_category_name, 
            award_method_id, award_method_code, award_method_name, expenditure_object_codes, 
            expenditure_object_names, industry_type_id, industry_type_name, 
            award_size_id, effective_begin_date, effective_begin_date_id, 
            effective_begin_year, effective_begin_year_id, effective_end_date, 
            effective_end_date_id, effective_end_year, effective_end_year_id, 
            registered_date, registered_date_id, brd_awd_no, tracking_number, 
            rfed_amount, minority_type_id, minority_type_name, original_version_flag, 
            master_agreement_id,master_contract_number, master_agreement_yn,
            latest_flag, load_id, last_modified_date, last_modified_year_id, is_prime_or_sub, 
            is_minority_vendor, vendor_type, contract_original_agreement_id, 
            is_subvendor, associated_prime_vendor_name, mwbe_category_ui, job_id)
     SELECT a.original_agreement_id, document_version, document_code_id, agency_history_id, 
            agency_id, agency_code, agency_name, agreement_id, starting_year, 
            starting_year_id, ending_year, ending_year_id, registered_year, 
            registered_year_id, a.contract_number, sub_contract_id, original_contract_amount, 
            maximum_contract_amount, description, vendor_history_id, a.vendor_id, 
            vendor_code, vendor_name, prime_vendor_id, (CASE WHEN a.prime_vendor_id = 0 THEN 'N/A (PRIVACY/SECURITY)' ELSE d.legal_name END) as prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name,dollar_difference, 
            percent_difference, agreement_type_id, agreement_type_code, agreement_type_name, 
            award_category_id, award_category_code, award_category_name, 
            award_method_id, award_method_code, award_method_name, expenditure_object_codes, 
            expenditure_object_names, industry_type_id, industry_type_name, 
            award_size_id, effective_begin_date, effective_begin_date_id, 
            effective_begin_year, effective_begin_year_id, effective_end_date, 
            effective_end_date_id, effective_end_year, effective_end_year_id, 
            registered_date, registered_date_id, brd_awd_no, tracking_number, 
            rfed_amount, minority_type_id, minority_type_name, original_version_flag, 
            master_agreement_id,master_contract_number,'N' as master_agreement_yn,
            latest_flag, load_id, last_modified_date, c.year_id as last_modified_year_id,'S' as is_prime_or_sub, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'Y' ELSE 'N' END) as is_minority_vendor, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'SM' ELSE 'S' END) as vendor_type,
            e.original_agreement_id as contract_original_agreement_id, 
            'Yes' as is_subvendor, (CASE WHEN a.prime_vendor_id = 0 THEN 'N/A (PRIVACY/SECURITY)' ELSE d.legal_name END) as associated_prime_vendor_name, 
            (CASE WHEN minority_type_id = 2 THEN 'Black American' WHEN minority_type_id = 3 THEN 'Hispanic American' WHEN minority_type_id = 7 THEN 'Non-M/WBE'
          WHEN minority_type_id = 9 THEN 'Women' WHEN minority_type_id = 11 THEN 'Individuals and Others' ELSE 'Asian American' END) AS mwbe_category_ui, job_id
     FROM sub_agreement_snapshot_cy a LEFT JOIN ref_date b ON a.last_modified_date::date = b.date
        LEFT JOIN ref_month c ON b.calendar_month_id = c.month_id
        LEFT JOIN vendor d ON a.prime_vendor_id = d.vendor_id
        LEFT JOIN (select original_agreement_id, contract_number from history_agreement where latest_flag = 'Y') e ON a.contract_number = e.contract_number;
       
          -- subcontract_status_by_prime_contract_id
          TRUNCATE TABLE subcontract_status_by_prime_contract_id;

      INSERT INTO subcontract_status_by_prime_contract_id
      (
      original_agreement_id,
      contract_number,
      description,
      agency_id,
      agency_name,
      prime_vendor_type,
      prime_vendor_id,
      prime_vendor_name,
      prime_minority_type_id,
      prime_minority_type_name,
      sub_vendor_type,
      sub_vendor_id,
      sub_vendor_name,
      sub_minority_type_id,
      sub_minority_type_name,
      sub_contract_id,
      aprv_sta_id,
      aprv_sta_value,
      starting_year_id,
      ending_year_id,
      effective_begin_year_id,
      effective_end_year_id,
      sort_order,
      latest_flag,
      prime_sub_vendor_minority_type_by_name_code
      )
      SELECT
      a.original_agreement_id,
      a.contract_number,
      a.description,
      a.agency_id,
      a.agency_name,
      a.vendor_type as prime_vendor_type,
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
      b.vendor_type as sub_vendor_type,
      b.vendor_id as sub_vendor_id,
      b.vendor_name as sub_vendor_name,
      b.minority_type_id as sub_minority_type_id,
      CASE
        WHEN b.minority_type_id = 2 THEN 'Black American'
        WHEN b.minority_type_id = 3 THEN 'Hispanic American'
        WHEN b.minority_type_id IN (4,5) THEN 'Asian American'
        WHEN b.minority_type_id = 7 THEN 'Non-M/WBE'
        WHEN b.minority_type_id = 9 THEN 'Women'
        WHEN b.minority_type_id = 11 THEN 'Individuals and Others'
      END as sub_minority_type_name,
      CASE WHEN b.sub_contract_id is NULL OR b.sub_contract_id = '' THEN 'NOT PROVIDED' ELSE b.sub_contract_id END as sub_contract_id,
      c.aprv_sta_id,
      c.aprv_sta_value,
      a.starting_year_id,
      a.ending_year_id,
      a.effective_begin_year_id,
      a.effective_end_year_id,
      c.sort_order,
      a.latest_flag,
      a.vendor_type||':'||a.minority_type_id||':'||CAST(vendor.vendor_customer_code as text)||':'||a.vendor_name ||
      (CASE
          WHEN b.vendor_name IS NULL THEN ''
          ELSE ','||b.vendor_type||':'||b.minority_type_id||':'||CAST(subvendor.vendor_customer_code as text)||':'||b.vendor_name
      END) AS prime_sub_vendor_minority_type_by_name_code
      FROM all_agreement_transactions a
      LEFT JOIN
      (
        SELECT a.original_agreement_id, a.contract_number, a.vendor_name, a.vendor_type, a.vendor_id,a.aprv_sta as aprv_sta_id, a.minority_type_id, a.sub_contract_id
        FROM all_agreement_transactions a
        WHERE (a.is_prime_or_sub = 'S' AND a.latest_flag = 'Y')
      ) b on b.contract_number = a.contract_number
      LEFT JOIN subcontract_approval_status c ON c.aprv_sta_id = COALESCE(b.aprv_sta_id,6)
      JOIN ref_document_code rd ON rd.document_code_id = a.document_code_id
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
      WHERE (a.is_prime_or_sub = 'P' 
        --AND a.latest_flag = 'Y' 
        AND a.scntrc_status = 2 
        AND rd.document_code IN ('CTA1','CT1','CT2'));


      UPDATE subcontract_status_by_prime_contract_id tbl1
      SET prime_sub_vendor_code = tbl2.prime_sub_vendor_code,
      prime_sub_vendor_code_by_type = tbl2.prime_sub_vendor_code_by_type,
      prime_vendor_code = tbl2.prime_vendor_code,
      sub_vendor_code = tbl2.sub_vendor_code,
      prime_sub_minority_type_id = tbl2.prime_sub_minority_type_id
      -- SELECT *
      FROM
      (
        SELECT
        contract_number,
        prime_vendor_id,
        COALESCE(sub_vendor_id, 0) as sub_vendor_id,
        b.vendor_customer_code as prime_vendor_code,
        c.vendor_customer_code as sub_vendor_code,
        CASE
          WHEN c.vendor_customer_code IS NULL THEN CAST(b.vendor_customer_code as text)
          ELSE CAST(b.vendor_customer_code as text) || ',' || CAST(c.vendor_customer_code as text)
        END AS prime_sub_vendor_code,
        CASE
          WHEN a.prime_minority_type_id IN (7,11) THEN 'P:'||CAST(b.vendor_customer_code as text)
          ELSE 'PM:'||CAST(b.vendor_customer_code as text)
        END ||
        CASE
          WHEN a.sub_minority_type_id IS NULL THEN ''
          WHEN a.sub_minority_type_id IN (7,11) THEN ',S:'||CAST(c.vendor_customer_code as text)
          ELSE ',SM:'||CAST(c.vendor_customer_code as text)
        END AS prime_sub_vendor_code_by_type,
        CASE
          WHEN a.prime_minority_type_id IN (7,11) THEN 'P:'||a.prime_minority_type_id
          ELSE 'PM:'||a.prime_minority_type_id
        END ||
        CASE
          WHEN a.sub_minority_type_id IS NULL THEN ''
          WHEN a.sub_minority_type_id IN (7,11) THEN ',S:'||a.sub_minority_type_id
          ELSE ',SM:'||a.sub_minority_type_id
        END AS prime_sub_minority_type_id
        FROM subcontract_status_by_prime_contract_id a
        JOIN
        (
          SELECT v.vendor_id, v.legal_name, v.vendor_customer_code FROM vendor v
          JOIN (SELECT vendor_id, MAX(vendor_history_id) AS vendor_history_id FROM vendor_history WHERE miscellaneous_vendor_flag::BIT = 0 ::BIT  GROUP BY 1) vh ON v.vendor_id = vh.vendor_id
        ) b on b.vendor_id = a.prime_vendor_id
        LEFT JOIN
        (
          SELECT v.vendor_id, v.legal_name, v.vendor_customer_code FROM subvendor v
          JOIN (SELECT vendor_id, MAX(vendor_history_id) AS vendor_history_id FROM subvendor_history GROUP BY 1) vh ON v.vendor_id = vh.vendor_id
        ) c on c.vendor_id = a.sub_vendor_id
      ) tbl2
      WHERE tbl2.contract_number = tbl1.contract_number
      AND tbl2.prime_vendor_id = tbl1.prime_vendor_id
      AND tbl2.sub_vendor_id = COALESCE(tbl1.sub_vendor_id, 0);


TRUNCATE TABLE all_agreement_transactions_by_prime_sub_vendor;

INSERT INTO all_agreement_transactions_by_prime_sub_vendor (
  agreement_id,
  original_agreement_id,
  contract_original_agreement_id,
    contract_number, 
    scntrc_status, 
  scntrc_status_name, 
  master_agreement_yn,  
  master_agreement_id,
  master_contract_number, 
  master_contract_number_export,
  has_children,
  has_mwbe_children,
  document_code_id ,
  document_code,
  agency_id,
  agency_name,
  agency_code,
  vendor_record_type, 
  agreement_type_id,
  agreement_type_code,
  agreement_type_name, 
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
  prime_maximum_contract_amount,
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
  prime_rfed_amount, 
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
  aprv_sta, 
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
order by a.is_prime_or_sub;


  RAISE NOTICE 'REF COMMON TT2';

  DELETE FROM ONLY all_disbursement_transactions a
  USING disbursement_line_item_details b
  WHERE a.disbursement_line_item_id = b.disbursement_line_item_id
  AND b.job_id = p_job_id_in AND a.is_prime_or_sub = 'P';
  
  DELETE FROM  all_disbursement_transactions WHERE is_prime_or_sub = 'S';
  
  INSERT INTO all_disbursement_transactions(disbursement_line_item_id, disbursement_id, line_number, disbursement_number, 
            check_eft_issued_date_id, check_eft_issued_nyc_year_id, fiscal_year, 
            check_eft_issued_cal_month_id, agreement_id, master_agreement_id, 
            fund_class_id, check_amount, agency_id, agency_history_id, agency_code, 
            expenditure_object_id, vendor_id,  prime_vendor_id, prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name,department_id, maximum_contract_amount, 
            maximum_contract_amount_cy, maximum_spending_limit, maximum_spending_limit_cy, 
            document_id, vendor_name, vendor_customer_code, check_eft_issued_date, 
            agency_name, agency_short_name, location_name, location_code, 
            department_name, department_short_name, department_code, expenditure_object_name, 
            expenditure_object_code, budget_code_id, budget_code, budget_name, 
            contract_number, master_contract_number, master_child_contract_number, 
            contract_vendor_id, contract_vendor_id_cy, master_contract_vendor_id, 
            master_contract_vendor_id_cy, contract_agency_id, contract_agency_id_cy, 
            master_contract_agency_id, master_contract_agency_id_cy, master_purpose, 
            master_purpose_cy, purpose, purpose_cy, master_child_contract_agency_id, 
            master_child_contract_agency_id_cy, master_child_contract_vendor_id, 
            master_child_contract_vendor_id_cy, reporting_code, location_id, 
            fund_class_name, fund_class_code, spending_category_id, spending_category_name, 
            calendar_fiscal_year_id, calendar_fiscal_year, agreement_accounting_line_number, 
            agreement_commodity_line_number, agreement_vendor_line_number, 
            reference_document_number, reference_document_code, contract_document_code, 
            master_contract_document_code, minority_type_id, minority_type_name, 
            industry_type_id, industry_type_name, agreement_type_code, award_method_code, 
            contract_industry_type_id, contract_industry_type_id_cy, master_contract_industry_type_id, 
            master_contract_industry_type_id_cy, contract_minority_type_id, 
            contract_minority_type_id_cy, master_contract_minority_type_id, 
            master_contract_minority_type_id_cy, file_type, load_id, last_modified_date,
            last_modified_fiscal_year_id, last_modified_calendar_year_id,
            is_prime_or_sub, is_minority_vendor, vendor_type, contract_original_agreement_id, 
            is_subvendor, associated_prime_vendor_name, mwbe_category_ui, job_id)
     SELECT disbursement_line_item_id, disbursement_id, line_number, disbursement_number, 
            check_eft_issued_date_id, check_eft_issued_nyc_year_id, fiscal_year, 
            check_eft_issued_cal_month_id, agreement_id, master_agreement_id, 
            fund_class_id, check_amount, agency_id, agency_history_id, agency_code, 
            expenditure_object_id, vendor_id, vendor_id as prime_vendor_id, vendor_name as prime_vendor_name, 
            minority_type_id as prime_minority_type_id, minority_type_name as prime_minority_type_name,department_id, maximum_contract_amount, 
            maximum_contract_amount_cy, maximum_spending_limit, maximum_spending_limit_cy, 
            document_id, vendor_name, vendor_customer_code, check_eft_issued_date, 
            agency_name, agency_short_name, location_name, location_code, 
            department_name, department_short_name, department_code, expenditure_object_name, 
            expenditure_object_code, budget_code_id, budget_code, budget_name, 
            contract_number, master_contract_number, master_child_contract_number, 
            contract_vendor_id, contract_vendor_id_cy, master_contract_vendor_id, 
            master_contract_vendor_id_cy, contract_agency_id, contract_agency_id_cy, 
            master_contract_agency_id, master_contract_agency_id_cy, master_purpose, 
            master_purpose_cy, purpose, purpose_cy, master_child_contract_agency_id, 
            master_child_contract_agency_id_cy, master_child_contract_vendor_id, 
            master_child_contract_vendor_id_cy, reporting_code, location_id, 
            fund_class_name, fund_class_code, spending_category_id, spending_category_name, 
            calendar_fiscal_year_id, calendar_fiscal_year, agreement_accounting_line_number, 
            agreement_commodity_line_number, agreement_vendor_line_number, 
            reference_document_number, reference_document_code, contract_document_code, 
            master_contract_document_code, minority_type_id, minority_type_name, 
            industry_type_id, industry_type_name, agreement_type_code, award_method_code, 
            contract_industry_type_id, contract_industry_type_id_cy, master_contract_industry_type_id, 
            master_contract_industry_type_id_cy, contract_minority_type_id, 
            contract_minority_type_id_cy, master_contract_minority_type_id, 
            master_contract_minority_type_id_cy, file_type, load_id, last_modified_date, 
            b.nyc_year_id as last_modified_fiscal_year_id, c.year_id as last_modified_calendar_year_id,
            'P' as is_prime_or_sub,
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'Y' ELSE 'N' END) as is_minority_vendor, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'PM' ELSE 'P' END) as vendor_type,
            agreement_id as contract_original_agreement_id, 
            'No' as is_subvendor, 'N/A' as associated_prime_vendor_name, 
            (CASE WHEN minority_type_id = 2 THEN 'Black American' WHEN minority_type_id = 3 THEN 'Hispanic American' WHEN minority_type_id = 7 THEN 'Non-M/WBE'
          WHEN minority_type_id = 9 THEN 'Women' WHEN minority_type_id = 11 THEN 'Individuals and Others' ELSE 'Asian American' END) AS mwbe_category_ui,job_id
    FROM disbursement_line_item_details a LEFT JOIN ref_date b ON a.last_modified_date::date = b.date
        LEFT JOIN ref_month c ON b.calendar_month_id = c.month_id
    WHERE job_id = p_job_id_in;
    
    
    INSERT INTO all_disbursement_transactions(disbursement_line_item_id, disbursement_number, payment_id, check_eft_issued_date_id, 
            check_eft_issued_nyc_year_id, fiscal_year, check_eft_issued_cal_month_id, 
            agreement_id, check_amount, agency_id, agency_history_id, agency_code, 
            vendor_id, prime_vendor_id, prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name,maximum_contract_amount, maximum_contract_amount_cy, 
            document_id, vendor_name, vendor_customer_code, check_eft_issued_date, 
            agency_name, agency_short_name, expenditure_object_name, expenditure_object_code, 
            contract_number, sub_contract_id, contract_vendor_id, contract_vendor_id_cy, 
            contract_prime_vendor_id, contract_prime_vendor_id_cy, contract_agency_id, 
            contract_agency_id_cy, purpose, purpose_cy, reporting_code, spending_category_id, 
            spending_category_name, calendar_fiscal_year_id, calendar_fiscal_year, 
            reference_document_number, reference_document_code, contract_document_code, 
            minority_type_id, minority_type_name, industry_type_id, industry_type_name, 
            agreement_type_code, award_method_code, contract_industry_type_id, 
            contract_industry_type_id_cy, contract_minority_type_id, contract_minority_type_id_cy, 
            master_agreement_id,master_contract_number,
            file_type, load_id, last_modified_date, 
            last_modified_fiscal_year_id, last_modified_calendar_year_id,
            is_prime_or_sub, is_minority_vendor, vendor_type, contract_original_agreement_id, 
            is_subvendor, associated_prime_vendor_name, mwbe_category_ui, job_id)
   SELECT  disbursement_line_item_id, disbursement_number, payment_id, check_eft_issued_date_id, 
            check_eft_issued_nyc_year_id, fiscal_year, check_eft_issued_cal_month_id, 
            agreement_id, check_amount, agency_id, agency_history_id, agency_code, 
            a.vendor_id, prime_vendor_id, (CASE WHEN a.prime_vendor_id = 0 THEN 'N/A (PRIVACY/SECURITY)' ELSE d.legal_name END) as prime_vendor_name, 
            prime_minority_type_id, prime_minority_type_name,maximum_contract_amount, maximum_contract_amount_cy, 
            document_id, vendor_name, a.vendor_customer_code, check_eft_issued_date, 
            agency_name, agency_short_name, expenditure_object_name, expenditure_object_code, 
            a.contract_number, sub_contract_id, contract_vendor_id, contract_vendor_id_cy, 
            contract_prime_vendor_id, contract_prime_vendor_id_cy, contract_agency_id, 
            contract_agency_id_cy, purpose, purpose_cy, reporting_code, spending_category_id, 
            spending_category_name, calendar_fiscal_year_id, calendar_fiscal_year, 
            reference_document_number, reference_document_code, contract_document_code, 
            minority_type_id, minority_type_name, industry_type_id, industry_type_name, 
            agreement_type_code, award_method_code, contract_industry_type_id, 
            contract_industry_type_id_cy, contract_minority_type_id, contract_minority_type_id_cy, 
            master_agreement_id,master_contract_number,
            file_type, load_id, last_modified_date, 
            b.nyc_year_id as last_modified_fiscal_year_id, c.year_id as last_modified_calendar_year_id,
            'S' as is_prime_or_sub, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'Y' ELSE 'N' END) as is_minority_vendor, 
            (CASE WHEN minority_type_id in (2,3,4,5,9) THEN 'SM' ELSE 'S' END) as vendor_type, 
            e.original_agreement_id as contract_original_agreement_id, 
             'Yes' as is_subvendor, (CASE WHEN a.prime_vendor_id = 0 THEN 'N/A (PRIVACY/SECURITY)' ELSE d.legal_name END) as associated_prime_vendor_name, 
            (CASE WHEN minority_type_id = 2 THEN 'Black American' WHEN minority_type_id = 3 THEN 'Hispanic American' WHEN minority_type_id = 7 THEN 'Non-M/WBE'
          WHEN minority_type_id = 9 THEN 'Women' WHEN minority_type_id = 11 THEN 'Individuals and Others' ELSE 'Asian American' END) AS mwbe_category_ui,job_id
    FROM subcontract_spending_details a LEFT JOIN ref_date b ON a.last_modified_date::date = b.date
        LEFT JOIN ref_month c ON b.calendar_month_id = c.month_id
        LEFT JOIN vendor d ON a.prime_vendor_id = d.vendor_id
        LEFT JOIN (select original_agreement_id, contract_number from history_agreement where latest_flag = 'Y') e ON a.contract_number = e.contract_number;
            
            
  
  l_end_time := timeofday()::timestamp;
  
  INSERT INTO etl.etl_script_execution_status(job_id,script_name,completed_flag,start_time,end_time)
  VALUES(p_job_id_in,'etl.refreshCommonTransactionTables',1,l_start_time,l_end_time);
  
      RETURN 1;
            
  

EXCEPTION
  WHEN OTHERS THEN
  RAISE NOTICE 'Exception Occurred in refreshCommonTransactionTables';
  RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;  

  l_end_time := timeofday()::timestamp;
  
  INSERT INTO etl.etl_script_execution_status(job_id,script_name,completed_flag,start_time,end_time,errno,errmsg)
  VALUES(p_job_id_in,'etl.refreshCommonTransactionTables',0,l_start_time,l_end_time,SQLSTATE,SQLERRM);
  
  RETURN 0;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION etl.refreshcommontransactiontables(bigint) OWNER TO gpadmin;
