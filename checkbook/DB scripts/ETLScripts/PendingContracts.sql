CREATE OR REPLACE FUNCTION etl.processPendingContracts(p_load_file_id_in bigint,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_count smallint;
BEGIN
	CREATE TEMPORARY TABLE tmp_fk_values_pc (uniq_id bigint, document_code_id smallint, document_agency_id smallint,
						parent_document_code_id smallint, parent_document_agency_id smallint,submitting_agency_id smallint,
						awarding_agency_id smallint,submitting_agency_name varchar,submitting_agency_short_name varchar,
						awarding_agency_name varchar,awarding_agency_short_name varchar,start_date_id int,
						end_date_id int,revised_start_date_id int,revised_end_date_id int,	
						cif_received_date_id int, cif_fiscal_year smallint, cif_fiscal_year_id smallint, document_agency_name varchar, document_agency_short_name varchar )
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_pc (uniq_id,document_code_id)
	SELECT	a.uniq_id, b.document_code_id
	FROM etl.stg_pending_contracts a JOIN ref_document_code b ON a.con_trans_code = b.document_code;
	
	
	-- FK document_agency_id
	
	RAISE NOTICE '1';
	
	INSERT INTO tmp_fk_values_pc (uniq_id,document_agency_id,document_agency_name,document_agency_short_name)
	SELECT	a.uniq_id, max(b.agency_id),b.agency_name,b.agency_short_name
	FROM etl.stg_pending_contracts a JOIN ref_agency b ON a.con_trans_ad_code = b.agency_code
	GROUP BY 1,3,4;	
	
	
	CREATE TEMPORARY TABLE tmp_fk_values_pc_new_agencies(dept_cd varchar,uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_pc_new_agencies
	SELECT con_trans_ad_code,MIN(b.uniq_id) as uniq_id
	FROM etl.stg_pending_contracts a join (SELECT uniq_id
						 FROM tmp_fk_values_pc
						 GROUP BY 1
						 HAVING max(document_agency_id) is null) b on a.uniq_id=b.uniq_id
	GROUP BY 1;
	
	

	RAISE NOTICE '2';
	
	TRUNCATE etl.ref_agency_id_seq;
	
	INSERT INTO etl.ref_agency_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_pc_new_agencies;
	
	INSERT INTO ref_agency(agency_id,agency_code,agency_name,created_date,created_load_id,original_agency_name)
	SELECT a.agency_id,b.dept_cd,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in,'<Unknown Agency>' as original_agency_name
	FROM   etl.ref_agency_id_seq a JOIN tmp_fk_values_pc_new_agencies b ON a.uniq_id = b.uniq_id;

	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'PC',l_count, 'New agency records inserted from Pending Contracts');
	END IF;
	
	RAISE NOTICE '3';

	-- Generate the agency history id for history records
	
	TRUNCATE etl.ref_agency_history_id_seq;
	
	INSERT INTO etl.ref_agency_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_pc_new_agencies;

	INSERT INTO ref_agency_history(agency_history_id,agency_id,agency_name,created_date,load_id)
	SELECT a.agency_history_id,b.agency_id,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_history_id_seq a JOIN etl.ref_agency_id_seq b ON a.uniq_id = b.uniq_id;

	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'PC',l_count, 'New agency history records inserted from Pending Contracts');
	END IF;
	
	INSERT INTO tmp_fk_values_pc (uniq_id,document_agency_id,document_agency_name,document_agency_short_name)
	SELECT	a.uniq_id, max(b.agency_id),b.agency_name,b.agency_short_name
	FROM etl.stg_pending_contracts a JOIN ref_agency b ON a.con_trans_ad_code = b.agency_code
	JOIN etl.ref_agency_id_seq c ON b.agency_id = c.agency_id
	GROUP BY 1,3,4;	
	
	RAISE NOTICE '4';
	-- FK parent_document_code_id
			
	INSERT INTO tmp_fk_values_pc (uniq_id,parent_document_code_id)
	SELECT	a.uniq_id, b.document_code_id
	FROM etl.stg_pending_contracts a JOIN ref_document_code b ON a.con_par_trans_code = b.document_code;	
	
	--FK  parent_document_agency_id
	
	INSERT INTO tmp_fk_values_pc (uniq_id,parent_document_agency_id)
	SELECT	a.uniq_id, max(b.agency_id)
	FROM etl.stg_pending_contracts a JOIN ref_agency b ON a.con_par_ad_code = b.agency_code
	GROUP BY 1;
	
	-- FK submitting_agency_id
	
	
	INSERT INTO tmp_fk_values_pc (uniq_id,submitting_agency_id,submitting_agency_name,submitting_agency_short_name)
	SELECT	a.uniq_id, max(b.agency_id),b.agency_name,b.agency_short_name
	FROM etl.stg_pending_contracts a JOIN ref_agency b ON a.submitting_agency_code = b.agency_code
	GROUP BY 1,3,4;
	
	RAISE NOTICE '5';
	-- FK awarding_agency_id
	
	
	INSERT INTO tmp_fk_values_pc (uniq_id,awarding_agency_id,awarding_agency_name,awarding_agency_short_name)
	SELECT	a.uniq_id, max(b.agency_id),b.agency_name,b.agency_short_name
	FROM etl.stg_pending_contracts a JOIN ref_agency b ON a.awarding_agency_code = b.agency_code
	GROUP BY 1,3,4;
	
	
	TRUNCATE TABLE tmp_fk_values_pc_new_agencies;
	
	
	INSERT INTO tmp_fk_values_pc_new_agencies
	SELECT awarding_agency_code,MIN(b.uniq_id) as uniq_id
	FROM etl.stg_pending_contracts a join (SELECT uniq_id
						 FROM tmp_fk_values_pc
						 GROUP BY 1
						 HAVING max(document_agency_id) is null) b on a.uniq_id=b.uniq_id
	GROUP BY 1;
	
	


	TRUNCATE etl.ref_agency_id_seq;
	
	INSERT INTO etl.ref_agency_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_pc_new_agencies;
	
	INSERT INTO ref_agency(agency_id,agency_code,agency_name,created_date,created_load_id,original_agency_name)
	SELECT a.agency_id,b.dept_cd,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in,'<Unknown Agency>' as original_agency_name
	FROM   etl.ref_agency_id_seq a JOIN tmp_fk_values_pc_new_agencies b ON a.uniq_id = b.uniq_id;

	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'PC',l_count, 'New agency records inserted from Pending Contracts');
	END IF;
	
	RAISE NOTICE '6';

	-- Generate the agency history id for history records
	
	TRUNCATE etl.ref_agency_history_id_seq;
	
	INSERT INTO etl.ref_agency_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_pc_new_agencies;

	INSERT INTO ref_agency_history(agency_history_id,agency_id,agency_name,created_date,load_id)
	SELECT a.agency_history_id,b.agency_id,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_history_id_seq a JOIN etl.ref_agency_id_seq b ON a.uniq_id = b.uniq_id;

	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'PC',l_count, 'New agency history records inserted from Pending Contracts');
	END IF;
	
	
	INSERT INTO tmp_fk_values_pc (uniq_id,awarding_agency_id,awarding_agency_name,awarding_agency_short_name)
	SELECT	a.uniq_id, max(b.agency_id),b.agency_name,b.agency_short_name
	FROM etl.stg_pending_contracts a JOIN ref_agency b ON a.awarding_agency_code = b.agency_code
	JOIN etl.ref_agency_id_seq c ON b.agency_id = c.agency_id
	GROUP BY 1,3,4;
	
	RAISE NOTICE '7';
	-- FK start_date_id
	
	
	INSERT INTO tmp_fk_values_pc(uniq_id,start_date_id)
	SELECT a.uniq_id,b.date_id
	FROM etl.stg_pending_contracts a JOIN ref_date b ON a.con_term_from = b.date;
	
	INSERT INTO tmp_fk_values_pc(uniq_id,end_date_id)
	SELECT a.uniq_id,b.date_id
	FROM etl.stg_pending_contracts a JOIN ref_date b ON a.con_term_to = b.date;
	
	INSERT INTO tmp_fk_values_pc(uniq_id,revised_start_date_id)
	SELECT a.uniq_id,b.date_id
	FROM etl.stg_pending_contracts a JOIN ref_date b ON a.con_rev_start_dt = b.date;
	
	INSERT INTO tmp_fk_values_pc(uniq_id,revised_end_date_id)
	SELECT a.uniq_id,b.date_id
	FROM etl.stg_pending_contracts a JOIN ref_date b ON a.con_rev_end_dt = b.date;
	
	INSERT INTO tmp_fk_values_pc(uniq_id,cif_received_date_id, cif_fiscal_year, cif_fiscal_year_id)
	SELECT a.uniq_id,b.date_id, c.year_value, c.year_id
	FROM etl.stg_pending_contracts a 
	JOIN ref_date b ON a.con_cif_received_date = b.date
	JOIN ref_year c ON b.nyc_year_id = c.year_id;	
	
	RAISE NOTICE '8';
	--Updating con_ct_header with all the FK values

	UPDATE etl.stg_pending_contracts a
	SET	document_code_id = ct_table.document_code_id ,
		document_agency_id = ct_table.document_agency_id,
		document_agency_name = ct_table.document_agency_name,
		document_agency_short_name = ct_table.document_agency_short_name,
		parent_document_code_id = ct_table.parent_document_code_id,
		parent_document_agency_id = ct_table.parent_document_agency_id,
		submitting_agency_id = ct_table.submitting_agency_id,
		submitting_agency_name = ct_table.submitting_agency_name, 
		submitting_agency_short_name = ct_table.submitting_agency_short_name,		
		awarding_agency_id = ct_table.awarding_agency_id,
		awarding_agency_name = ct_table.awarding_agency_name, 		
		awarding_agency_short_name = ct_table.awarding_agency_short_name,
		start_date_id = ct_table.start_date_id,
		end_date_id = ct_table.end_date_id,
		revised_start_date_id = ct_table.revised_start_date_id,
		revised_end_date_id = ct_table.revised_end_date_id,
		cif_received_date_id = ct_table.cif_received_date_id,
		cif_fiscal_year = ct_table.cif_fiscal_year,
		cif_fiscal_year_id = ct_table.cif_fiscal_year_id
	FROM	(SELECT uniq_id, max(document_code_id) as document_code_id ,
				 max(document_agency_id) as document_agency_id,
				 max(document_agency_name) as document_agency_name,
				 max(document_agency_short_name) as document_agency_short_name,
				 max(parent_document_code_id) as parent_document_code_id,
				 max(parent_document_agency_id) as parent_document_agency_id,
				 max(submitting_agency_id) as submitting_agency_id,
				 max(submitting_agency_name) as submitting_agency_name, 
				 max(submitting_agency_short_name) as submitting_agency_short_name, 
				 max(awarding_agency_id) as awarding_agency_id,
				 max(awarding_agency_name) as awarding_agency_name, 
				 max(awarding_agency_short_name) as awarding_agency_short_name,
				 max(start_date_id) as start_date_id, 
				 max(end_date_id) as end_date_id,
				 max(revised_start_date_id) as revised_start_date_id, 
				 max(revised_end_date_id) as revised_end_date_id,
				 max(cif_received_date_id) as cif_received_date_id,
				 max(cif_fiscal_year) as cif_fiscal_year,
				 max(cif_fiscal_year_id) as cif_fiscal_year_id
		 FROM	tmp_fk_values_pc
		 GROUP BY 1) ct_table
	WHERE	a.uniq_id = ct_table.uniq_id;	

	RAISE NOTICE '9';
	
	
	
	UPDATE etl.stg_pending_contracts
	SET contract_number = con_trans_code||con_trans_ad_code||con_no ;
	
		
	UPDATE etl.stg_pending_contracts a
	SET original_agreement_id = b.original_agreement_id
	FROM history_agreement b
	WHERE a.contract_number = b.contract_number
	AND b.original_version_flag = 'Y';
	
	UPDATE etl.stg_pending_contracts a
	SET original_agreement_id = b.original_master_agreement_id
	FROM history_master_agreement b
	WHERE a.contract_number = b.contract_number
	AND b.original_version_flag = 'Y';
	
	RAISE NOTICE '10';
	
	CREATE TEMPORARY TABLE tmp_pc_funding_agency(original_agreement_id bigint, funding_agency_id smallint) DISTRIBUTED BY (original_agreement_id);
	
	INSERT INTO tmp_pc_funding_agency 
	SELECT distinct original_agreement_id, funding_agency_id
	FROM
	(SELECT x.original_agreement_id, first_value(y.agency_id) over (partition by x.original_agreement_id ORDER BY y.check_eft_issued_date DESC) as funding_agency_id
	FROM etl.stg_pending_contracts x, disbursement_line_item_details y
	WHERE x.original_agreement_id = y.agreement_id) z;
	
	
	UPDATE etl.stg_pending_contracts a
	SET funding_agency_id = b.funding_agency_id
	FROM tmp_pc_funding_agency b
	WHERE a.original_agreement_id = b.original_agreement_id ;
	
	UPDATE etl.stg_pending_contracts a
	SET funding_agency_code = b.agency_code,
		funding_agency_name = b.agency_name,
		funding_agency_short_name = b.agency_short_name
	FROM ref_agency b
	WHERE a.funding_agency_id = b.agency_id;
	
	RAISE NOTICE '11';
	TRUNCATE pending_contracts;
	
	INSERT INTO pending_contracts(document_code_id,document_agency_id,document_id,parent_document_code_id,
				      parent_document_agency_id,parent_document_id,encumbrance_mount,original_maximum_amount,
				      revised_maximum_amount,vendor_legal_name,vendor_customer_code,description,
				      submitting_agency_id,oaisis_submitting_agency_desc,submitting_agency_code	,awarding_agency_id,
				      oaisis_awarding_agency_desc,awarding_agency_code,contract_type_name,cont_type_code,
				      award_method_name,award_method_code,start_date,end_date,revised_start_date,
				      revised_end_date,cif_received_date,cif_fiscal_year, cif_fiscal_year_id, tracking_number,board_award_number,
				      oca_number,version_number,contract_number,fms_parent_contract_number,
				      submitting_agency_name,submitting_agency_short_name,awarding_agency_name,awarding_agency_short_name,
				      start_date_id,end_date_id,revised_start_date_id,revised_end_date_id,
				      cif_received_date_id,document_agency_code,document_agency_name,document_agency_short_name,  
				      original_agreement_id, funding_agency_id, funding_agency_code, funding_agency_name, funding_agency_short_name,
				      dollar_difference, percent_difference,original_or_modified,award_size_id )
	SELECT document_code_id,document_agency_id,con_no,parent_document_code_id,
	      parent_document_agency_id,con_par_reg_num,con_cur_encumbrance,con_original_max,
	      con_rev_max,vc_legal_name,con_vc_code,con_purpose,
	      submitting_agency_id,submitting_agency_desc,submitting_agency_code,awarding_agency_id,
	      awarding_agency_desc,awarding_agency_code,cont_desc,cont_code,
	      am_desc,am_code,con_term_from,con_term_to,con_rev_start_dt,
	      con_rev_end_dt,con_cif_received_date,cif_fiscal_year, cif_fiscal_year_id, con_pin,con_internal_pin,
	      con_batch_suffix,con_version,contract_number,con_par_trans_code || con_par_ad_code || con_par_reg_num as fms_parent_contract_number,
	      submitting_agency_name,submitting_agency_short_name,awarding_agency_name,awarding_agency_short_name,
	      start_date_id,end_date_id,revised_start_date_id,revised_end_date_id,
	      cif_received_date_id,con_trans_ad_code,document_agency_name,document_agency_short_name,
	      original_agreement_id, funding_agency_id, funding_agency_code, funding_agency_name, funding_agency_short_name,
	      coalesce(con_rev_max,0) - coalesce(con_original_max,0) as dollar_difference,
		(CASE WHEN coalesce(con_original_max,0) = 0 THEN 0 ELSE 
		ROUND((( coalesce(con_rev_max,0) - coalesce(con_original_max,0)) * 100 )::decimal / coalesce(con_original_max,0),2) END) as percent_difference,
		original_or_modified,
		(CASE WHEN con_rev_max IS NULL THEN 5 WHEN con_rev_max <= 5000 THEN 4 WHEN con_rev_max  > 5000 
		            AND con_rev_max  <= 100000 THEN 3 WHEN  con_rev_max > 100000 AND con_rev_max <= 1000000 THEN 2 WHEN con_rev_max > 1000000 THEN 1 
            ELSE 5 END) as award_size_id

	FROM  etl.stg_pending_contracts;
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processPendingContracts';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;	
END;
$$ language plpgsql;