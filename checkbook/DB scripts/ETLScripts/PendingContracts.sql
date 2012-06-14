CREATE OR REPLACE FUNCTION etl.processPendingContracts(p_load_file_id_in bigint,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_count smallint;
BEGIN
	CREATE TEMPORARY TABLE tmp_fk_values_pc (uniq_id bigint, document_code_id smallint, document_agency_history_id smallint,
						parent_document_code_id smallint, parent_document_agency_history_id smallint,submitting_agency_history_id smallint,
						awarding_agency_history_id smallint,submitting_agency_name varchar,submitting_agency_short_name varchar,
						awarding_agency_name varchar,awarding_agency_short_name varchar,start_date_id int,
						end_date_id int,revised_start_date_id int,revised_end_date_id int,	
						cif_received_date_id int, document_agency_name varchar, document_agency_short_name varchar )
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_pc (uniq_id,document_code_id)
	SELECT	a.uniq_id, b.document_code_id
	FROM etl.stg_pending_contracts a JOIN ref_document_code b ON a.con_trans_code = b.document_code;
	
	
	INSERT INTO tmp_fk_values_pc (uniq_id,document_agency_history_id,document_agency_name,document_agency_short_name)
	SELECT	a.uniq_id, max(c.agency_history_id),b.agency_name,b.agency_short_name
	FROM etl.stg_pending_contracts a JOIN ref_agency b ON a.con_trans_ad_code = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1,3,4;
		
	INSERT INTO tmp_fk_values_pc (uniq_id,parent_document_code_id)
	SELECT	a.uniq_id, b.document_code_id
	FROM etl.stg_pending_contracts a JOIN ref_document_code b ON a.con_par_trans_code = b.document_code;	
	
	INSERT INTO tmp_fk_values_pc (uniq_id,parent_document_agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id)
	FROM etl.stg_pending_contracts a JOIN ref_agency b ON a.con_par_ad_code = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1;
	
	INSERT INTO tmp_fk_values_pc (uniq_id,submitting_agency_history_id,submitting_agency_name,submitting_agency_short_name)
	SELECT	a.uniq_id, max(c.agency_history_id),b.agency_name,b.agency_short_name
	FROM etl.stg_pending_contracts a JOIN ref_agency b ON a.submitting_agency_code = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1,3,4;
	
	INSERT INTO tmp_fk_values_pc (uniq_id,awarding_agency_history_id,awarding_agency_name,awarding_agency_short_name)
	SELECT	a.uniq_id, max(c.agency_history_id),b.agency_name,b.agency_short_name
	FROM etl.stg_pending_contracts a JOIN ref_agency b ON a.awarding_agency_code = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1,3,4;
	
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
	
	INSERT INTO tmp_fk_values_pc(uniq_id,cif_received_date_id)
	SELECT a.uniq_id,b.date_id
	FROM etl.stg_pending_contracts a JOIN ref_date b ON a.con_cif_received_date = b.date;	
	
	--Updating con_ct_header with all the FK values

	UPDATE etl.stg_pending_contracts a
	SET	document_code_id = ct_table.document_code_id ,
		document_agency_history_id = ct_table.document_agency_history_id,
		document_agency_name = ct_table.document_agency_name,
		document_agency_short_name = ct_table.document_agency_short_name,
		parent_document_code_id = ct_table.parent_document_code_id,
		parent_document_agency_history_id = ct_table.parent_document_agency_history_id,
		submitting_agency_history_id = ct_table.submitting_agency_history_id,
		submitting_agency_name = ct_table.submitting_agency_name, 
		submitting_agency_short_name = ct_table.submitting_agency_short_name,		
		awarding_agency_history_id = ct_table.awarding_agency_history_id,
		awarding_agency_name = ct_table.awarding_agency_name, 		
		awarding_agency_short_name = ct_table.awarding_agency_short_name,
		start_date_id = ct_table.start_date_id,
		end_date_id = ct_table.end_date_id,
		revised_start_date_id = ct_table.revised_start_date_id,
		revised_end_date_id = ct_table.revised_end_date_id,
		cif_received_date_id = ct_table.cif_received_date_id	
	FROM	(SELECT uniq_id, max(document_code_id) as document_code_id ,
				 max(document_agency_history_id) as document_agency_history_id,
				 max(document_agency_name) as document_agency_name,
				 max(document_agency_short_name) as document_agency_short_name,
				 max(parent_document_code_id) as parent_document_code_id,
				 max(parent_document_agency_history_id) as parent_document_agency_history_id,
				 max(submitting_agency_history_id) as submitting_agency_history_id,
				 max(submitting_agency_name) as submitting_agency_name, 
				 max(submitting_agency_short_name) as submitting_agency_short_name, 
				 max(awarding_agency_history_id) as awarding_agency_history_id,
				 max(awarding_agency_name) as awarding_agency_name, 
				 max(awarding_agency_short_name) as awarding_agency_short_name,
				 max(start_date_id) as start_date_id, 
				 max(end_date_id) as end_date_id,
				 max(revised_start_date_id) as revised_start_date_id, 
				 max(revised_end_date_id) as revised_end_date_id,
				 max(cif_received_date_id) as cif_received_date_id
		 FROM	tmp_fk_values_pc
		 GROUP BY 1) ct_table
	WHERE	a.uniq_id = ct_table.uniq_id;	

	TRUNCATE pending_contracts;
	
	INSERT INTO pending_contracts(document_code_id,document_agency_history_id,document_id,parent_document_code_id,
				      parent_document_agency_history_id,parent_document_id,encumbrance_mount,original_maximum_amount,
				      revised_maximum_amount,vendor_legal_name,vendor_customer_code,description,
				      submitting_agency_history_id,oaisis_submitting_agency_desc,submitting_agency_code	,awarding_agency_history_id,
				      oaisis_awarding_agency_desc,awarding_agency_code,contract_type_name,cont_type_code,
				      award_method_name,award_method_code,start_date,end_date,revised_start_date,
				      revised_end_date,cif_received_date,tracking_number,board_award_number,
				      oca_number,version_number,contract_number,fms_parent_contract_number,
				      submitting_agency_name,submitting_agency_short_name,awarding_agency_name,awarding_agency_short_name,
				      start_date_id,end_date_id,revised_start_date_id,revised_end_date_id,
				      cif_received_date_id,document_agency_code,document_agency_name,document_agency_short_name)
	SELECT document_code_id,document_agency_history_id,con_no,parent_document_code_id,
	      parent_document_agency_history_id,con_par_reg_num,con_cur_encumbrance,con_original_max,
	      con_rev_max,vc_legal_name,con_vc_code,con_purpose,
	      submitting_agency_history_id,submitting_agency_desc,submitting_agency_code,awarding_agency_history_id,
	      awarding_agency_desc,awarding_agency_code,cont_desc,cont_code,
	      am_desc,am_code,con_term_from,con_term_to,con_rev_start_dt,
	      con_rev_end_dt,con_cif_received_date,con_pin,con_internal_pin,
	      con_batch_suffix,con_version,con_trans_code||con_trans_ad_code||con_no as contract_number,con_par_trans_code || con_par_ad_code || con_par_reg_num as fms_parent_contract_number,
	      submitting_agency_name,submitting_agency_short_name,awarding_agency_name,awarding_agency_short_name,
	      start_date_id,end_date_id,revised_start_date_id,revised_end_date_id,
	      cif_received_date_id,document_agency_code,document_agency_name,document_agency_short_name
	FROM  etl.stg_pending_contracts;
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processPendingContracts';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;	
END;
$$ language plpgsql;