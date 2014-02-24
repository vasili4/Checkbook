CREATE OR REPLACE FUNCTION etl.modifyFMSDataForOGE(p_job_id_in bigint) RETURNS INT AS $$
DECLARE
	l_count bigint;
	l_start_time  timestamp;
	l_end_time  timestamp;
BEGIN
	l_start_time := timeofday()::timestamp;
	

    /*	
	DELETE FROM ref_agency_history a 
	USING ref_agency b
	WHERE   a.agency_id = b.agency_id  AND b.agency_code in ('z81');
		
	DELETE FROM ref_agency where agency_code in ('z81');
	
	INSERT INTO ref_agency(agency_id, agency_code, agency_name, original_agency_name, created_date, agency_short_name, is_display) VALUES(nextval('seq_ref_agency_agency_id'),'z81','NEW YORK CITY ECONOMIC DEVELOPMENT CORPORATION','NEW YORK CITY ECONOMIC DEVELOPMENT CORPORATION', now()::timestamp, 'NYC EDC','Y');

	INSERT INTO ref_agency_history(agency_history_id, agency_id, agency_name, created_date) SELECT nextval('seq_ref_agency_history_id'),agency_id, agency_name,now()::timestamp FROM ref_agency WHERE agency_code = 'z81';
  
  
	UPDATE edc_contract a
	SET agency_id = b.agency_id
	FROM ref_agency b
	WHERE a.agency_code = b.agency_code AND b.agency_code in ('z81');
	
	UPDATE tdc_contract a
	SET agency_id = b.agency_id
	FROM ref_agency b
	WHERE a.agency_code = b.agency_code AND b.agency_code in ('z81');
	
	UPDATE oge_contract a
	SET  agency_id = b.agency_id
	FROM ref_agency b
	WHERE a.agency_code = b.agency_code AND b.agency_code in ('z81'); 
	
	*/
	
	UPDATE disbursement_line_item_details disb
	SET agency_code = edc_data.agency_code,
		agency_id = edc_data.agency_id,
		contract_agency_id = edc_data.agency_id,
		contract_agency_id_cy = edc_data.agency_id,
		master_contract_agency_id = edc_data.agency_id,
		master_contract_agency_id_cy = edc_data.agency_id,
		master_child_contract_agency_id = edc_data.agency_id,
		master_child_contract_agency_id_cy = edc_data.agency_id,
		agency_name = edc_data.agency_name,
		agency_short_name = edc_data.agency_short_name,
		agency_history_id = edc_data.agency_history_id,
		vendor_name = edc_data.vendor_name,
		vendor_id = edc_data.vendor_id,
		contract_vendor_id = edc_data.vendor_id,
		contract_vendor_id_cy = edc_data.vendor_id,
		master_contract_vendor_id = edc_data.vendor_id,
		master_contract_vendor_id_cy = edc_data.vendor_id,
		master_child_contract_vendor_id = edc_data.vendor_id,
		master_child_contract_vendor_id_cy = edc_data.vendor_id,
		vendor_customer_code = NULL,
		department_id = edc_data.department_id ,
		department_name = edc_data.department_name,
		department_short_name = edc_data.department_short_name,
		department_code = edc_data.department_code		
	FROM (select disb.disbursement_line_item_id, ag.agency_code, ag.agency_id, ag.agency_name, ag.agency_short_name, agh.agency_history_id, edc.vendor_id, edc.vendor_name, 
	dep.department_id, dep.department_name, dep.department_short_name, dep.department_code FROM disbursement_line_item_details disb JOIN oge_contract edc ON disb.contract_number = edc.fms_contract_number AND disb.agreement_commodity_line_number = edc.fms_commodity_line  JOIN ref_agency ag ON edc.agency_id = ag.agency_id 
	JOIN (select agency_id, max(agency_history_id) agency_history_id from ref_agency_history group by 1) agh ON ag.agency_id = agh.agency_id
	JOIN ref_department dep ON edc.department_id = dep.department_id) edc_data
	WHERE disb.disbursement_line_item_id = edc_data.disbursement_line_item_id;
	
	UPDATE disbursement_line_item disb
	SET agency_history_id = disb1.agency_history_id
	FROM disbursement_line_item_details disb1
	WHERE disb.disbursement_line_item_id = disb1.disbursement_line_item_id;
	
	UPDATE disbursement_line_item disb
	SET department_history_id = dep_his.department_history_id
	FROM disbursement_line_item_details disb1, ref_department dep, ref_department_history dep_his
	WHERE disb.disbursement_line_item_id = disb1.disbursement_line_item_id AND disb1.department_id = dep.department_id AND dep.department_id = dep_his.department_id ;
	
	UPDATE history_agreement_accounting_line a
	SET department_history_id = edc_data.department_history_id,
	agency_history_id = edc_data.agency_history_id
	FROM (select ha.agreement_id, agh.agency_history_id,	deph.department_history_id  FROM history_agreement ha JOIN oge_contract edc ON ha.contract_number = edc.fms_contract_number  JOIN ref_agency ag ON edc.agency_id = ag.agency_id 
	JOIN (select agency_id, max(agency_history_id) agency_history_id from ref_agency_history group by 1) agh ON ag.agency_id = agh.agency_id
	JOIN ref_department dep ON edc.department_id = dep.department_id 
	JOIN ref_department_history deph ON dep.department_id = deph.department_id) edc_data 
	WHERE a.agreement_id = edc_data.agreement_id;
	
	UPDATE history_agreement a
	SET agency_history_id = edc_data.agency_history_id
	FROM (select ha.agreement_id, agh.agency_history_id FROM history_agreement ha JOIN oge_contract edc ON ha.contract_number = edc.fms_contract_number  JOIN ref_agency ag ON edc.agency_id = ag.agency_id 
	JOIN (select agency_id, max(agency_history_id) agency_history_id from ref_agency_history group by 1) agh ON ag.agency_id = agh.agency_id) edc_data 
	WHERE a.agreement_id = edc_data.agreement_id;
	
	UPDATE agreement_snapshot a
	SET agency_history_id = edc_data.agency_history_id,
		agency_id = edc_data.agency_id,
		agency_code = edc_data.agency_code,
		agency_name = edc_data.agency_name
	FROM (select ha.agreement_id, ag.agency_code, ag.agency_id, ag.agency_name, ag.agency_short_name, agh.agency_history_id FROM history_agreement ha JOIN oge_contract edc ON ha.contract_number = edc.fms_contract_number  JOIN ref_agency ag ON edc.agency_id = ag.agency_id 
	JOIN (select agency_id, max(agency_history_id) agency_history_id from ref_agency_history group by 1) agh ON ag.agency_id = agh.agency_id) edc_data 
	WHERE a.agreement_id = edc_data.agreement_id;
	
	UPDATE agreement_snapshot_cy a
	SET agency_history_id = edc_data.agency_history_id,
		agency_id = edc_data.agency_id,
		agency_code = edc_data.agency_code,
		agency_name = edc_data.agency_name
	FROM (select ha.agreement_id, ag.agency_code, ag.agency_id, ag.agency_name, ag.agency_short_name, agh.agency_history_id FROM history_agreement ha JOIN oge_contract edc ON ha.contract_number = edc.fms_contract_number  JOIN ref_agency ag ON edc.agency_id = ag.agency_id 
	JOIN (select agency_id, max(agency_history_id) agency_history_id from ref_agency_history group by 1) agh ON ag.agency_id = agh.agency_id) edc_data 
	WHERE a.agreement_id = edc_data.agreement_id;
	
	
	TRUNCATE agreement_snapshot_expanded CASCADE;
	INSERT INTO agreement_snapshot_expanded(
            original_agreement_id, agreement_id, fiscal_year, description, 
            contract_number, vendor_id, agency_id, industry_type_id, award_size_id, 
            original_contract_amount, maximum_contract_amount, rfed_amount, 
            starting_year, ending_year, dollar_difference, percent_difference, 
            award_method_id, document_code_id, master_agreement_id, master_agreement_yn, 
            status_flag)
	SELECT original_agreement_id, a.agreement_id, fiscal_year, min(description) as description, 
            min(contract_number) as contract_number, b.vendor_id, min(b.agency_id) as agency_id, min(a.industry_type_id) as industry_type_id, min(a.award_size_id) as award_size_id, 
            sum(oge_registered_amount) as original_contract_amount, min(maximum_contract_amount) as maximum_contract_amount, min(rfed_amount) as rfed_amount, 
            min(starting_year) as starting_year, min(ending_year) ending_year, NULL as dollar_difference, NULL as percent_difference, 
            min(award_method_id) as award_method_id, min(document_code_id) as document_code_id, min(master_agreement_id) as master_agreement_id, 'N' as master_agreement_yn, 
            status_flag
	FROM  agreement_snapshot_expanded_edc a JOIN oge_contract b ON a.contract_number = b.fms_contract_number
	      WHERE a.master_agreement_yn = 'N'
		  GROUP BY 1,2,3,6,21;
	
			GET DIAGNOSTICS l_count = ROW_COUNT;	
	
	INSERT INTO etl.etl_data_load_verification(job_id,data_source_code,num_transactions,description)
	VALUES(p_job_id_in,'ED',l_count, '# of records inserted into agreement_snapshot_expanded');	
		  
	INSERT INTO agreement_snapshot_expanded(
            original_agreement_id, agreement_id, fiscal_year, description, 
            contract_number, vendor_id, agency_id, industry_type_id, award_size_id, 
            original_contract_amount, maximum_contract_amount, rfed_amount, 
            starting_year, ending_year, dollar_difference, percent_difference, 
            award_method_id, document_code_id, master_agreement_id, master_agreement_yn, 
            status_flag)
	SELECT original_agreement_id, a.agreement_id, fiscal_year, min(description) as description, 
            min(a.contract_number) as contract_number, c.vendor_id, min(c.agency_id) as agency_id, min(a.industry_type_id) as industry_type_id, min(a.award_size_id) as award_size_id, 
            min(original_contract_amount) as original_contract_amount, min(maximum_contract_amount) as maximum_contract_amount, min(rfed_amount) as rfed_amount, 
            min(starting_year) as starting_year, min(ending_year) as ending_year, NULL as dollar_difference, NULL as percent_difference, 
            min(award_method_id) as award_method_id, min(document_code_id) as document_code_id, min(a.master_agreement_id) as master_agreement_id, 'Y' as master_agreement_yn, 
            status_flag
	FROM  agreement_snapshot_expanded_edc a JOIN (select distinct contract_number, master_agreement_id FROM history_agreement) b ON a.original_agreement_id = b.master_agreement_id JOIN oge_contract c ON b.contract_number = c.fms_contract_number
	      WHERE a.master_agreement_yn = 'Y'
		  GROUP BY 1,2,3,6,21;
	
			GET DIAGNOSTICS l_count = ROW_COUNT;	
	
	INSERT INTO etl.etl_data_load_verification(job_id,data_source_code,num_transactions,description)
	VALUES(p_job_id_in,'ED',l_count, '# of records inserted into agreement_snapshot_expanded');
	

	TRUNCATE agreement_snapshot_expanded_cy CASCADE;
	INSERT INTO agreement_snapshot_expanded_cy(
            original_agreement_id, agreement_id, fiscal_year, description, 
            contract_number, vendor_id, agency_id, industry_type_id, award_size_id, 
            original_contract_amount, maximum_contract_amount, rfed_amount, 
            starting_year, ending_year, dollar_difference, percent_difference, 
            award_method_id, document_code_id, master_agreement_id, master_agreement_yn, 
            status_flag)
	SELECT original_agreement_id, a.agreement_id, fiscal_year, min(description) as description, 
            min(contract_number) as contract_number, b.vendor_id, min(b.agency_id) as agency_id, min(a.industry_type_id) as industry_type_id, min(a.award_size_id) as award_size_id, 
            sum(oge_registered_amount) as original_contract_amount, min(maximum_contract_amount) as maximum_contract_amount, min(rfed_amount) as rfed_amount, 
            min(starting_year) as starting_year, min(ending_year) ending_year, NULL as dollar_difference, NULL as percent_difference, 
            min(award_method_id) as award_method_id, min(document_code_id) as document_code_id, min(master_agreement_id) as master_agreement_id, 'N' as master_agreement_yn, 
            status_flag
	FROM  agreement_snapshot_expanded_cy_edc a JOIN oge_contract b ON a.contract_number = b.fms_contract_number
	      WHERE a.master_agreement_yn = 'N'
		  GROUP BY 1,2,3,6,21;
	
			GET DIAGNOSTICS l_count = ROW_COUNT;	
	
	INSERT INTO etl.etl_data_load_verification(job_id,data_source_code,num_transactions,description)
	VALUES(p_job_id_in,'ED',l_count, '# of records inserted into agreement_snapshot_expanded_cy');	
		  
	INSERT INTO agreement_snapshot_expanded_cy(
            original_agreement_id, agreement_id, fiscal_year, description, 
            contract_number, vendor_id, agency_id, industry_type_id, award_size_id, 
            original_contract_amount, maximum_contract_amount, rfed_amount, 
            starting_year, ending_year, dollar_difference, percent_difference, 
            award_method_id, document_code_id, master_agreement_id, master_agreement_yn, 
            status_flag)
	SELECT original_agreement_id, a.agreement_id, fiscal_year, min(description) as description, 
            min(a.contract_number) as contract_number, c.vendor_id, min(c.agency_id) as agency_id, min(a.industry_type_id) as industry_type_id, min(a.award_size_id) as award_size_id, 
            min(original_contract_amount) as original_contract_amount, min(maximum_contract_amount) as maximum_contract_amount, min(rfed_amount) as rfed_amount, 
            min(starting_year) as starting_year, min(ending_year) as ending_year, NULL as dollar_difference, NULL as percent_difference, 
            min(award_method_id) as award_method_id, min(document_code_id) as document_code_id, min(a.master_agreement_id) as master_agreement_id, 'Y' as master_agreement_yn, 
            status_flag
	FROM  agreement_snapshot_expanded_cy_edc a JOIN (select distinct contract_number, master_agreement_id FROM history_agreement) b ON a.original_agreement_id = b.master_agreement_id JOIN oge_contract c ON b.contract_number = c.fms_contract_number
	      WHERE a.master_agreement_yn = 'Y'
		  GROUP BY 1,2,3,6,21;
	
			GET DIAGNOSTICS l_count = ROW_COUNT;	
	
	INSERT INTO etl.etl_data_load_verification(job_id,data_source_code,num_transactions,description)
	VALUES(p_job_id_in,'ED',l_count, '# of records inserted into agreement_snapshot_expanded_cy');
	
	-- need to revisit the below logic for dollar difference and percent difference
	/*
	UPDATE agreement_snapshot_expanded
	SET  dollar_difference =  coalesce(maximum_contract_amount,0) - coalesce(original_contract_amount,0),
		 percent_difference = (CASE WHEN coalesce(original_contract_amount,0) = 0 THEN 0 ELSE 
		ROUND((( coalesce(maximum_contract_amount,0) - coalesce(original_contract_amount,0)) * 100 )::decimal / coalesce(original_contract_amount,0),2) END) ;
		
	UPDATE agreement_snapshot_expanded_cy
	SET  dollar_difference =  coalesce(maximum_contract_amount,0) - coalesce(original_contract_amount,0),
	     percent_difference = (CASE WHEN coalesce(original_contract_amount,0) = 0 THEN 0 ELSE 
		ROUND((( coalesce(maximum_contract_amount,0) - coalesce(original_contract_amount,0)) * 100 )::decimal / coalesce(original_contract_amount,0),2) END) ;
	
	*/
	
	TRUNCATE pending_contracts CASCADE;
	
	INSERT INTO pending_contracts (
		document_code_id, document_agency_id, document_id, parent_document_code_id, 
            parent_document_agency_id, parent_document_id, encumbrance_amount_original, 
            encumbrance_amount, original_maximum_amount_original, original_maximum_amount, 
            revised_maximum_amount_original, revised_maximum_amount, registered_contract_max_amount, 
            vendor_legal_name, vendor_customer_code, vendor_id, description, 
            submitting_agency_id, oaisis_submitting_agency_desc, submitting_agency_code, 
            awarding_agency_id, oaisis_awarding_agency_desc, awarding_agency_code, 
            contract_type_name, cont_type_code, award_method_name, award_method_code, 
            award_method_id, start_date, end_date, revised_start_date, revised_end_date, 
            cif_received_date, cif_fiscal_year, cif_fiscal_year_id, tracking_number, 
            board_award_number, oca_number, version_number, fms_contract_number, 
            contract_number, fms_parent_contract_number, submitting_agency_name, 
            submitting_agency_short_name, awarding_agency_name, awarding_agency_short_name, 
            start_date_id, end_date_id, revised_start_date_id, revised_end_date_id, 
            cif_received_date_id, document_agency_code, document_agency_name, 
            document_agency_short_name, funding_agency_id, funding_agency_code, 
            funding_agency_name, funding_agency_short_name, original_agreement_id, 
            original_master_agreement_id, dollar_difference, percent_difference, 
            original_or_modified, original_or_modified_desc, award_size_id, 
            award_category_id, industry_type_id, document_version, latest_flag)
	SELECT document_code_id, b.agency_id as document_agency_id, document_id, parent_document_code_id, 
            parent_document_agency_id, parent_document_id, encumbrance_amount_original, 
            encumbrance_amount, oge_registered_amount as original_maximum_amount_original, oge_registered_amount as original_maximum_amount, 
            revised_maximum_amount_original, revised_maximum_amount, registered_contract_max_amount, 
            b.vendor_name as vendor_legal_name, NULL as vendor_customer_code, b.vendor_id as vendor_id, description, 
            submitting_agency_id, oaisis_submitting_agency_desc, submitting_agency_code, 
            awarding_agency_id, oaisis_awarding_agency_desc, awarding_agency_code, 
            contract_type_name, cont_type_code, award_method_name, award_method_code, 
            award_method_id, start_date, end_date, revised_start_date, revised_end_date, 
            cif_received_date, cif_fiscal_year, cif_fiscal_year_id, tracking_number, 
            board_award_number, oca_number, version_number, a.fms_contract_number, 
            contract_number, fms_parent_contract_number, submitting_agency_name, 
            submitting_agency_short_name, awarding_agency_name, awarding_agency_short_name, 
            start_date_id, end_date_id, revised_start_date_id, revised_end_date_id, 
            cif_received_date_id, c.agency_code as document_agency_code, c.agency_name as document_agency_name, 
            c.agency_short_name as document_agency_short_name, funding_agency_id, funding_agency_code, 
            funding_agency_name, funding_agency_short_name, original_agreement_id, 
            original_master_agreement_id, dollar_difference, percent_difference, 
            original_or_modified, original_or_modified_desc, award_size_id, 
            award_category_id, industry_type_id, document_version, latest_flag
	FROM pending_contracts a JOIN (select fms_contract_number, vendor_id, agency_id, vendor_name, sum(oge_registered_amount) as oge_registered_amount FROM oge_contract group by 1,2,3,4) b ON a.fms_contract_number = b.fms_contract_number  JOIN ref_agency c ON b.agency_id = b.agency_id;
	
	INSERT INTO pending_contracts (
		document_code_id, document_agency_id, document_id, parent_document_code_id, 
            parent_document_agency_id, parent_document_id, encumbrance_amount_original, 
            encumbrance_amount, original_maximum_amount_original, original_maximum_amount, 
            revised_maximum_amount_original, revised_maximum_amount, registered_contract_max_amount, 
            vendor_legal_name, vendor_customer_code, vendor_id, description, 
            submitting_agency_id, oaisis_submitting_agency_desc, submitting_agency_code, 
            awarding_agency_id, oaisis_awarding_agency_desc, awarding_agency_code, 
            contract_type_name, cont_type_code, award_method_name, award_method_code, 
            award_method_id, start_date, end_date, revised_start_date, revised_end_date, 
            cif_received_date, cif_fiscal_year, cif_fiscal_year_id, tracking_number, 
            board_award_number, oca_number, version_number, fms_contract_number, 
            contract_number, fms_parent_contract_number, submitting_agency_name, 
            submitting_agency_short_name, awarding_agency_name, awarding_agency_short_name, 
            start_date_id, end_date_id, revised_start_date_id, revised_end_date_id, 
            cif_received_date_id, document_agency_code, document_agency_name, 
            document_agency_short_name, funding_agency_id, funding_agency_code, 
            funding_agency_name, funding_agency_short_name, original_agreement_id, 
            original_master_agreement_id, dollar_difference, percent_difference, 
            original_or_modified, original_or_modified_desc, award_size_id, 
            award_category_id, industry_type_id, document_version, latest_flag)
	SELECT document_code_id, b.agency_id as document_agency_id, document_id, parent_document_code_id, 
            parent_document_agency_id, parent_document_id, encumbrance_amount_original, 
            encumbrance_amount, oge_registered_amount as original_maximum_amount_original, oge_registered_amount as original_maximum_amount, 
            revised_maximum_amount_original, revised_maximum_amount, registered_contract_max_amount, 
            b.vendor_name as vendor_legal_name, NULL as vendor_customer_code, b.vendor_id as vendor_id, description, 
            submitting_agency_id, oaisis_submitting_agency_desc, submitting_agency_code, 
            awarding_agency_id, oaisis_awarding_agency_desc, awarding_agency_code, 
            contract_type_name, cont_type_code, award_method_name, award_method_code, 
            award_method_id, start_date, end_date, revised_start_date, revised_end_date, 
            cif_received_date, cif_fiscal_year, cif_fiscal_year_id, tracking_number, 
            board_award_number, oca_number, version_number, fms_contract_number, 
            a.contract_number, fms_parent_contract_number, submitting_agency_name, 
            submitting_agency_short_name, awarding_agency_name, awarding_agency_short_name, 
            start_date_id, end_date_id, revised_start_date_id, revised_end_date_id, 
            cif_received_date_id, c.agency_code as document_agency_code, c.agency_name as document_agency_name, 
            c.agency_short_name as document_agency_short_name, funding_agency_id, funding_agency_code, 
            funding_agency_name, funding_agency_short_name, original_agreement_id, 
            original_master_agreement_id, dollar_difference, percent_difference, 
            original_or_modified, original_or_modified_desc, award_size_id, 
            award_category_id, industry_type_id, document_version, latest_flag
	FROM pending_contracts a JOIN (select c.contract_number, vendor_id, agency_id, vendor_name, sum(oge_registered_amount) as  oge_registered_amount FROM oge_contract a JOIN (select distinct contract_number, master_agreement_id FROM history_agreement) b ON a.fms_contract_number = b.contract_number JOIN (SELECT distinct contract_number, original_master_agreement_id FROM history_master_agreement) c ON b.master_agreement_id = c.original_master_agreement_id group by 1,2,3,4) b ON a.fms_contract_number = b.contract_number  JOIN ref_agency c ON b.agency_id = b.agency_id;
	
		l_end_time := timeofday()::timestamp;
INSERT INTO etl.etl_script_execution_status(job_id,script_name,completed_flag,start_time,end_time)
	VALUES(p_job_id_in,'etl.modifyFMSDataForOGE',1,l_start_time,l_end_time);
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in modifyFMSDataForOGE';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	
	l_end_time := timeofday()::timestamp;
	INSERT INTO etl.etl_script_execution_status(job_id,script_name,completed_flag,start_time,end_time)
	VALUES(p_job_id_in,'etl.modifyFMSDataForOGE',0,l_start_time,l_end_time);
	RETURN 0;	
END;
$$ language plpgsql;