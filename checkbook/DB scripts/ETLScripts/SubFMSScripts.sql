set search_path=public;
/* Functions defined
	updateForeignKeysForSubPayments	
	associateSubCONToSubPayments
	processSubPayments
	refreshFactsForSubPayments
	
*/
CREATE OR REPLACE FUNCTION etl.updateForeignKeysForSubPayments(p_load_file_id_in bigint,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_count bigint;
BEGIN
	/* UPDATING FOREIGN KEY VALUES	FOR THE HEADER RECORD*/		
	
	CREATE TEMPORARY TABLE tmp_sub_fk_fms_values (uniq_id bigint, document_code_id smallint,agency_history_id smallint,
						check_eft_issued_date_id integer, check_eft_issued_nyc_year_id smallint)
	DISTRIBUTED BY (uniq_id);
	
	-- FK:Document_Code_id
	
	INSERT INTO tmp_sub_fk_fms_values(uniq_id,document_code_id)
	SELECT	a.uniq_id, b.document_code_id
	FROM etl.stg_scntrc_pymt a JOIN ref_document_code b ON a.doc_cd = b.document_code;
	
	-- FK:Agency_history_id
	
	INSERT INTO tmp_sub_fk_fms_values(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) as agency_history_id
	FROM etl.stg_scntrc_pymt a JOIN ref_agency b ON a.doc_dept_cd = b.agency_code
		 JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1;
	
		

	-- FK:check_eft_issued_date_id
	
	INSERT INTO tmp_sub_fk_fms_values(uniq_id,check_eft_issued_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_scntrc_pymt a JOIN ref_date b ON a.scntrc_pymt_dt = b.date;
	
	-- FK:check_eft_issued_nyc_year_id
	
	INSERT INTO tmp_sub_fk_fms_values(uniq_id,check_eft_issued_nyc_year_id)
	SELECT	a.uniq_id, b.nyc_year_id
	FROM etl.stg_scntrc_pymt a JOIN ref_date b ON a.scntrc_pymt_dt = b.date;
	


	raise notice '1';
		
	UPDATE etl.stg_scntrc_pymt a
	SET	document_code_id = ct_table.document_code_id ,
		agency_history_id = ct_table.agency_history_id,	
		check_eft_issued_date_id = ct_table.check_eft_issued_date_id, 
		check_eft_issued_nyc_year_id = ct_table.check_eft_issued_nyc_year_id
	FROM	(SELECT uniq_id, max(document_code_id) as document_code_id ,
				 max(agency_history_id) as agency_history_id,
				 max(check_eft_issued_date_id) as check_eft_issued_date_id, 
				max(check_eft_issued_nyc_year_id) as check_eft_issued_nyc_year_id
		 FROM	tmp_sub_fk_fms_values
		 GROUP BY 1) ct_table
	WHERE	a.uniq_id = ct_table.uniq_id;	
	
	
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in updateForeignKeysForSubPayments';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

---------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.associateSubCONToSubPayments(p_load_file_id_in bigint, p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_worksite_col_array VARCHAR ARRAY[10];
	l_array_ctr smallint;
	l_fk_update int;
	l_count bigint;
BEGIN
						  

	
	-- Fetch all the contracts associated with Disbursements
	
	CREATE TEMPORARY TABLE tmp_sub_ct_fms(uniq_id bigint, agreement_id bigint,con_document_id varchar, 
				con_agency_history_id smallint, con_document_code_id smallint, con_document_code varchar, con_agency_code varchar, con_sub_contract_id varchar, )	
	DISTRIBUTED BY(uniq_id);
	
	INSERT INTO tmp_sub_ct_fms
	SELECT uniq_id, 0 as agreement_id,
	       max(a.doc_id)as con_document_id ,
	       max(d.agency_history_id) as con_agency_history_id,
	       max(c.document_code_id) as con_document_code_id,
	       max(c.document_code) as con_document_code,
	       max(b.agency_code) as con_agency_code,
	       max(a.scntrc_id) as con_sub_contract_id
	FROM	etl.stg_scntrc_pymt a JOIN ref_agency b ON a.doc_dept_cd = b.agency_code
		JOIN ref_document_code c ON a.doc_cd = c.document_code
		JOIN ref_agency_history d ON b.agency_id = d.agency_id
	GROUP BY 1,2;		
		
	RAISE NOTICE 'FMS AC 1';
	-- Identify the agreement/CON Id
	
	CREATE TEMPORARY TABLE tmp_sub_old_ct_fms_con(uniq_id bigint,agreement_id bigint, action_flag char(1), latest_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_old_ct_fms_con
	SELECT uniq_id,
	       original_agreement_id as agreement_id	
	FROM	
		(SELECT  uniq_id,		
			 b.document_version as mag_document_version,
			 b.original_agreement_id,
			 rank()over(partition by uniq_id order by b.document_version desc) as rank_value
		FROM tmp_sub_ct_fms a JOIN subcontract_details b ON a.con_document_id = b.document_id AND a.con_sub_contract_id = b.sub_contract_id
			JOIN ref_document_code f ON a.con_document_code = f.document_code AND b.document_code_id = f.document_code_id
			JOIN ref_agency e ON a.con_agency_code = e.agency_code 
			JOIN ref_agency_history c ON b.agency_history_id = c.agency_history_id AND e.agency_id = c.agency_id
		WHERE b.original_version_flag ='Y'	
		) inner_tbl
	WHERE	rank_value = 1;	
	
	UPDATE tmp_sub_ct_fms a
	SET	agreement_id = b.agreement_id
	FROM	tmp_sub_old_ct_fms_con b
	WHERE	a.uniq_id = b.uniq_id;
	
	RAISE NOTICE 'FMS AC 2';	

	 UPDATE etl.stg_scntrc_pymt a
	 SET	agreement_id = b.agreement_id
	 FROM	tmp_sub_ct_fms b
	 WHERE	a.uniq_id = b.uniq_id;
	 
	 UPDATE etl.stg_scntrc_pymt a
	 SET	agreement_id = NULL
	 WHERE agreement_id = 0;
	 
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in associateSubCONToSubPayments';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;


------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processSubPayments(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE


	l_fk_update int;
	l_insert_sql VARCHAR;
	l_display_type char(1);
	l_masked_agreement_id bigint;
	l_masked_vendor_history_id integer;
	l_count bigint;
BEGIN


	SELECT display_type
	FROM   etl.etl_data_load_file
	WHERE  load_file_id = p_load_file_id_in
	INTO   l_display_type;
	

	
	l_fk_update := etl.updateForeignKeysForSubPayments(p_load_file_id_in,p_load_id_in);

	RAISE NOTICE 'FMS 1';
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.processsubvendor(p_load_file_id_in,p_load_id_in);
	ELSE
		RETURN -1;
	END IF;


	RAISE NOTICE 'FMS 3';
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.associateSubCONToSubPayments(p_load_file_id_in,p_load_id_in);
	ELSE
		RETURN -1;
	END IF;

	RAISE NOTICE 'FMS 5';
	
	/*
	1.Pull the key information such as document code, document id, document version etc for all agreements
	2. For the existing contracts gather details on max version in the transaction, staging tables..Determine if the staged agreement is latest version...
	3. Identify the new agreements. Determine the latest version for each of it.
	*/
	
	RAISE NOTICE 'FMS 6';
	
	-- Handling interload duplicates
	
	CREATE TEMPORARY TABLE tmp_sub_all_disbs(uniq_id bigint, contract_number varchar, sub_contract_id varchar, payment_id varchar, disbursement_line_item_id bigint, action_flag char(1)) 
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_sub_all_disbs(uniq_id,contract_number,sub_contract_id,payment_id, action_flag)
	SELECT uniq_id, doc_cd || doc_dept_cd || doc_id as contract_number, scntrc_id as sub_contract_id, scntrc_pymt_id as payment_id, 'I' as action_flag
	FROM etl.stg_scntrc_pymt;
	
	CREATE TEMPORARY TABLE tmp_sub_old_disbs(disbursement_line_item_id bigint, uniq_id bigint) 
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_sub_old_disbs 
	SELECT a.disbursement_line_item_id, b.uniq_id
	FROM subcontract_spendings a JOIN etl.stg_scntrc_pymt b ON a.contract_number = b.doc_cd || b.doc_dept_cd || b.doc_id 
	AND a.sub_contract_id = b.scntrc_id  AND a.payment_id = b.scntrc_pymt_id 	;
	
	
	UPDATE tmp_sub_all_disbs a
	SET	disbursement_line_item_id = b.disbursement_line_item_id,
		action_flag = 'U'		
	FROM	tmp_sub_old_disbs b
	WHERE	a.uniq_id = b.uniq_id;

	RAISE NOTICE 'FMS 13';
	
	TRUNCATE etl.seq_disbursement_line_item_id;
		
	INSERT INTO etl.seq_disbursement_line_item_id
	SELECT uniq_id
	FROM	tmp_sub_all_disbs
	WHERE	action_flag ='I' 
		AND COALESCE(disbursement_line_item_id,0) =0 ;

	UPDATE tmp_sub_all_disbs a
	SET	disbursement_line_item_id = b.disbursement_line_item_id	
	FROM	etl.seq_disbursement_line_item_id b
	WHERE	a.uniq_id = b.uniq_id;	

	RAISE NOTICE 'FMS 14';
	

	INSERT INTO subcontract_spendings(disbursement_line_item_id,document_code_id,agency_history_id,
				 document_id, contract_number, sub_contract_id, payment_id, 
				 check_eft_amount_original,check_eft_amount,check_eft_issued_date_id,check_eft_issued_nyc_year_id, 
				 payment_description, payment_proof, is_final_payment,
				 vendor_history_id,agreement_id,
				 created_load_id,created_date)
	SELECT d.disbursement_line_item_id, a.document_code_id,a.agency_history_id,
	       a.doc_id,a.doc_cd || a.doc_dept_cd || a.doc_id as contract_number, a.scntrc_id as sub_contract_id, a.scntrc_pymt_id as payment_id,
	       a.chk_eft_am,coalesce(a.chk_eft_am,0) as check_eft_amount,a.check_eft_issued_date_id,a.check_eft_issued_nyc_year_id,
	       a.scntrc_pymt_dscr as payment_description, a.scntrc_prf_pymt as payment_proof, a.scntrc_fnl_pymt_fl as is_final_payment,
	        a.vendor_history_id, a.agreement_id,
	       p_load_id_in,now()::timestamp
	FROM	etl.stg_scntrc_pymt a 
		JOIN tmp_sub_all_disbs d ON a.uniq_id = d.uniq_id
	WHERE   action_flag='I';
		
	GET DIAGNOSTICS l_count = ROW_COUNT;	
							
			IF l_count > 0 THEN 
			INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
				VALUES(p_load_file_id_in,'SF',l_count, '# of records inserted into subcontract_spendings');	
	END IF;	
		
		
	RAISE NOTICE 'FMS 15';
	
	CREATE TEMPORARY TABLE tmp_sub_disbs_update AS
	SELECT d.disbursement_line_item_id, a.document_code_id,a.agency_history_id,
	       a.doc_id,a.doc_cd || a.doc_dept_cd || a.doc_id as contract_number, a.scntrc_id as sub_contract_id, a.scntrc_pymt_id as payment_id,
	       a.chk_eft_am,a.check_eft_issued_date_id,a.check_eft_issued_nyc_year_id,
	       a.scntrc_pymt_dscr as payment_description, a.scntrc_prf_pymt as payment_proof, a.scntrc_fnl_pymt_fl as is_final_payment,
	        a.vendor_history_id, a.agreement_id	    
	FROM	etl.stg_fms_header a JOIN etl.stg_fms_vendor b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd
					AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
		JOIN tmp_sub_all_disbs d ON a.uniq_id = d.uniq_id
	WHERE   action_flag='U'
	DISTRIBUTED BY (disbursement_line_item_id);	
	
	UPDATE subcontract_spendings a
	SET document_code_id = b.document_code_id,
		agency_history_id = b.agency_history_id,
		document_id = b.doc_id,
		contract_number = b.contract_number, 
		sub_contract_id = b.sub_contract_id, 
		payment_id = b.payment_id,
		check_eft_amount_original = b.chk_eft_am,
		check_eft_amount = coalesce(b.chk_eft_am,0),
		check_eft_issued_date_id = b.check_eft_issued_date_id,
		check_eft_issued_nyc_year_id = b.check_eft_issued_nyc_year_id,
		payment_description = b.payment_description,
		payment_proof = b.payment_proof,
		is_final_payment = b.is_final_payment,
		vendor_history_id = b.vendor_history_id,
		agreement_id = b.agreement_id,
		updated_load_id = p_load_id_in,
		updated_date = now()::timestamp
	FROM	tmp_disbs_update b
	WHERE	a.disbursement_line_item_id = b.disbursement_line_item_id;
	
		GET DIAGNOSTICS l_count = ROW_COUNT;	
				
					IF l_count > 0 THEN 
						INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
						VALUES(p_load_file_id_in,'SF',l_count, '# of records updated in subcontract_spendings');	
	END IF;	
	
		RAISE NOTICE 'FMS 16';
		
		
	RETURN 1;
	
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processSubPayments';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

---------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.refreshFactsForSubPayments(p_job_id_in bigint) RETURNS INT AS
$$
DECLARE
	l_start_time  timestamp;
	l_end_time  timestamp;
BEGIN
	-- Inserting into the disbursement_line_item_details
	
	l_start_time := timeofday()::timestamp;
	
	RAISE NOTICE 'FMS RF 1';
	
	INSERT INTO disbursement_line_item_deleted(disbursement_line_item_id, agency_id, load_id, deleted_date, job_id)
	SELECT a.disbursement_line_item_id, a.agency_id, c.load_id, now()::timestamp, p_job_id_in
	FROM disbursement_line_item_details a, disbursement b, etl.etl_data_load c
	WHERE   a.disbursement_id = b.disbursement_id 
	AND b.updated_load_id = c.load_id
	AND c.job_id = p_job_id_in AND c.data_source_code IN ('C','M','F');
	
	DELETE FROM ONLY disbursement_line_item_details a 
	USING disbursement b, etl.etl_data_load c
	WHERE   a.disbursement_id = b.disbursement_id 
	AND updated_load_id = c.load_id
	AND c.job_id = p_job_id_in AND c.data_source_code IN ('C','M','F'); 
	

		
		
	INSERT INTO disbursement_line_item_details(disbursement_line_item_id,disbursement_id,line_number,disbursement_number,check_eft_issued_date_id,	
						check_eft_issued_nyc_year_id,fiscal_year, check_eft_issued_cal_month_id,
						agreement_id,master_agreement_id,fund_class_id,
						check_amount,agency_id,agency_history_id,agency_code,expenditure_object_id,
						vendor_id,maximum_contract_amount,maximum_spending_limit,department_id,						
						document_id,vendor_name,vendor_customer_code,check_eft_issued_date,agency_name,agency_short_name,location_name,
						department_name,department_short_name,department_code,expenditure_object_name,expenditure_object_code,
						budget_code_id,budget_code,budget_name,reporting_code,location_id,location_code,fund_class_name,fund_class_code,
						spending_category_id,spending_category_name,calendar_fiscal_year_id,calendar_fiscal_year,
						agreement_accounting_line_number, agreement_commodity_line_number, agreement_vendor_line_number, reference_document_number,reference_document_code,
						minority_type_id, minority_type_name,
						load_id,last_modified_date,file_type,job_id)
	SELECT  b.disbursement_line_item_id,a.disbursement_id,b.line_number,b.disbursement_number,a.check_eft_issued_date_id,
		f.nyc_year_id,l.year_value,f.calendar_month_id,
		b.agreement_id,NULL as master_agreement_id,b.fund_class_id,
		b.check_amount,c.agency_id,b.agency_history_id,m.agency_code,d.expenditure_object_id,
		e.vendor_id,NULL as maximum_contract_amount, NULL as maximum_spending_limit, g.department_id,
		a.document_id,COALESCE(e.legal_name,e.alias_name) as vendor_name,q.vendor_customer_code,f.date,c.agency_name,c.agency_short_name, COALESCE(i.location_short_name,i.location_name),
		g.department_name,g.department_short_name,o.department_code,d.expenditure_object_name,p.expenditure_object_code,
		j.budget_code_id,j.budget_code,j.attribute_name,b.reporting_code,i.location_id,n.location_code,k.fund_class_name,k.fund_class_code,
		(CASE WHEN k.fund_class_code in ('400', '402') THEN 3
		      WHEN reference_document_number IS NOT NULL AND k.fund_class_code in ('001') THEN 1
		      WHEN k.fund_class_code not in ('400', '402', '001') THEN 5
		      ELSE 4
		 END) as spending_category_id,
		 (CASE WHEN k.fund_class_code in ('400', '402') THEN 'Capital Contracts'
		 	   WHEN reference_document_number IS NOT NULL AND k.fund_class_code in ('001') THEN  'Contracts'
		 	   WHEN k.fund_class_code not in ('400', '402', '001') THEN 'Trust & Agency'
		 	   ELSE 'Others'
		 END) as spending_category_name,x.year_id,x.year_value,
		 b.agreement_accounting_line_number, b.agreement_commodity_line_number, b.agreement_vendor_line_number, b.reference_document_number,b.reference_document_code,
		 vmb.minority_type_id, vmb.minority_type_name,
		 coalesce(a.updated_load_id, a.created_load_id), coalesce(a.updated_date, a.created_date),b.file_type,p_job_id_in
		FROM disbursement a JOIN disbursement_line_item b ON a.disbursement_id = b.disbursement_id
			JOIN ref_agency_history c ON b.agency_history_id = c.agency_history_id
			JOIN ref_agency m on c.agency_id = m.agency_id
			JOIN ref_expenditure_object_history d ON b.expenditure_object_history_id = d.expenditure_object_history_id
			JOIN ref_expenditure_object p on d.expenditure_object_id = p.expenditure_object_id
			JOIN vendor_history e ON a.vendor_history_id = e.vendor_history_id
			JOIN vendor q ON q.vendor_id = e.vendor_id
			JOIN ref_date f ON a.check_eft_issued_date_id = f.date_id
			JOIN ref_year l on f.nyc_year_id = l.year_id
			JOIN ref_department_history g ON b.department_history_id = g.department_history_id
			JOIN ref_department o on g.department_id = o.department_id
			JOIN ref_location_history i ON b.location_history_id = i.location_history_id
			JOIN ref_location  n ON i.location_id = n.location_id
			LEFT JOIN ref_budget_code j ON j.budget_code_id = b.budget_code_id
			JOIN ref_fund_class k ON k.fund_class_id = b.fund_class_id			
			JOIN ref_month y on f.calendar_month_id = y.month_id
			JOIN ref_year x on y.year_id = x.year_id
			JOIN etl.etl_data_load z ON coalesce(a.updated_load_id, a.created_load_id) = z.load_id
			LEFT JOIN vendor_min_bus_type vmb ON e.vendor_history_id = vmb.vendor_history_id
		WHERE z.job_id = p_job_id_in AND z.data_source_code IN ('C','M','F');
		
		
	
	
	RAISE NOTICE 'FMS RF 2';
	
	CREATE TEMPORARY TABLE tmp_agreement_con(disbursement_line_item_id bigint,agreement_id bigint,fiscal_year smallint,calendar_fiscal_year smallint,master_agreement_id bigint,  maximum_contract_amount numeric(16,2),
												maximum_contract_amount_cy numeric(16,2), maximum_spending_limit numeric(16,2), maximum_spending_limit_cy numeric(16,2),
												purpose varchar, purpose_cy varchar, contract_number varchar, master_contract_number varchar, contract_vendor_id integer, contract_vendor_id_cy integer,
												master_contract_vendor_id integer, master_contract_vendor_id_cy integer, contract_agency_id smallint, contract_agency_id_cy smallint, master_contract_agency_id smallint,
												master_contract_agency_id_cy smallint, master_purpose varchar, master_purpose_cy varchar, contract_document_code varchar, master_contract_document_code varchar, 
												industry_type_id smallint, industry_type_name varchar, agreement_type_code varchar, award_method_code varchar,
												contract_industry_type_id smallint, contract_industry_type_id_cy smallint, master_contract_industry_type_id smallint, master_contract_industry_type_id_cy smallint,
												contract_minority_type_id smallint, contract_minority_type_id_cy smallint, master_contract_minority_type_id smallint, master_contract_minority_type_id_cy smallint)
	DISTRIBUTED  BY (disbursement_line_item_id);
	
	INSERT INTO tmp_agreement_con(disbursement_line_item_id,agreement_id,fiscal_year,calendar_fiscal_year)
	SELECT DISTINCT a.disbursement_line_item_id, a.agreement_id, a.fiscal_year, a.calendar_fiscal_year 
	FROM disbursement_line_item_details a JOIN disbursement_line_item b ON a.disbursement_line_item_id = b.disbursement_line_item_id
		 JOIN disbursement c ON b.disbursement_id = c.disbursement_id
		 JOIN etl.etl_data_load d ON coalesce(c.updated_load_id, c.created_load_id) = d.load_id
		WHERE d.job_id = p_job_id_in AND d.data_source_code IN ('C','M','F') AND b.agreement_id > 0;
	
		
	-- Getting maximum_contract_amount, master_agreement_id, purpose, contract_number,  contract_vendor_id, contract_agency_id for FY from non master contracts.
	
	CREATE TEMPORARY TABLE tmp_agreement_con_fy(disbursement_line_item_id bigint,agreement_id bigint,master_agreement_id bigint, contract_number varchar,
						maximum_contract_amount_fy numeric(16,2), purpose_fy varchar, contract_vendor_id_fy integer, contract_agency_id_fy smallint, contract_document_code_fy varchar, 
						industry_type_id smallint, industry_type_name varchar, agreement_type_code varchar, award_method_code varchar,
						contract_industry_type_id_fy smallint, contract_minority_type_id_fy smallint)
	DISTRIBUTED  BY (disbursement_line_item_id);
	
	INSERT INTO tmp_agreement_con_fy
	SELECT a.disbursement_line_item_id, b.original_agreement_id,b.master_agreement_id,b.contract_number,
	b.maximum_contract_amount as maximum_contract_amount_fy ,
	b.description as purpose_fy ,
	b.vendor_id as contract_vendor_id_fy,
	b.agency_id as contract_agency_id_fy,
	e.document_code as contract_document_code_fy,
	b.industry_type_id as industry_type_id,
	b.industry_type_name as industry_type_name,
	b.agreement_type_code as agreement_type_code,
	b.award_method_code as award_method_code,
	b.industry_type_id as contract_industry_type_id_fy,
	b.minority_type_id as contract_minority_type_id_fy
		FROM tmp_agreement_con a JOIN agreement_snapshot b ON a.agreement_id = b.original_agreement_id AND a.fiscal_year between b.starting_year and b.ending_year
		JOIN disbursement_line_item c ON a.disbursement_line_item_id = c.disbursement_line_item_id
		JOIN disbursement d ON c.disbursement_id = d.disbursement_id 
		JOIN ref_document_code e ON b.document_code_id = e.document_code_id ;
		
	
	INSERT INTO tmp_agreement_con_fy
    SELECT a.disbursement_line_item_id, b.original_agreement_id,b.master_agreement_id,b.contract_number,
	b.maximum_contract_amount as maximum_contract_amount_fy ,
	b.description as purpose_fy ,
	b.vendor_id as contract_vendor_id_fy,
	b.agency_id as contract_agency_id_fy,
	e.document_code as contract_document_code_fy,
	b.industry_type_id as industry_type_id,
	b.industry_type_name as industry_type_name,
	b.agreement_type_code as agreement_type_code,
	b.award_method_code as award_method_code,
	b.industry_type_id as contract_industry_type_id_fy,
	b.minority_type_id as contract_minority_type_id_fy
		FROM tmp_agreement_con a JOIN agreement_snapshot b ON a.agreement_id = b.original_agreement_id AND b.latest_flag='Y'
		JOIN disbursement_line_item c ON a.disbursement_line_item_id = c.disbursement_line_item_id
		JOIN disbursement d ON c.disbursement_id = d.disbursement_id
		JOIN ref_document_code e ON b.document_code_id = e.document_code_id 
		LEFT JOIN tmp_agreement_con_fy f ON a.disbursement_line_item_id = f.disbursement_line_item_id
		WHERE f.disbursement_line_item_id IS NULL ;
   	
	UPDATE tmp_agreement_con a
	SET master_agreement_id = b.master_agreement_id,
		maximum_contract_amount = b.maximum_contract_amount_fy,
		purpose = b.purpose_fy,
		contract_number = b.contract_number,
		contract_vendor_id = b.contract_vendor_id_fy,
		contract_agency_id = b.contract_agency_id_fy,
		contract_document_code = b.contract_document_code_fy,
		industry_type_id = b.industry_type_id,
		industry_type_name = b.industry_type_name,
		agreement_type_code = b.agreement_type_code,
		award_method_code = b.award_method_code,
		contract_industry_type_id = b.contract_industry_type_id_fy,
		contract_minority_type_id = b.contract_minority_type_id_fy
	FROM tmp_agreement_con_fy b
	WHERE a.disbursement_line_item_id = b.disbursement_line_item_id;
	
	-- Getting maximum_spending_limit, master_contract_number, master_contract_vendor_id, master_contract_agency_id for FY for master agreements
	
	CREATE TEMPORARY TABLE tmp_agreement_con_master_fy(disbursement_line_item_id bigint, master_agreement_id bigint, master_contract_number varchar, maximum_spending_limit_fy numeric(16,2), 
	master_contract_vendor_id_fy integer, master_contract_agency_id_fy smallint, master_purpose_fy varchar, master_contract_document_code_fy varchar, 
	master_contract_industry_type_id_fy smallint, master_contract_minority_type_id_fy smallint)
	DISTRIBUTED  BY (disbursement_line_item_id);
	
	INSERT INTO tmp_agreement_con_master_fy
	SELECT a.disbursement_line_item_id, a.master_agreement_id,
	b.contract_number as master_contract_number,
	b.maximum_contract_amount as maximum_spending_limit_fy ,
	b.vendor_id as master_contract_vendor_id_fy,
	b.agency_id as master_contract_agency_id_fy,
	b.description as master_purpose_fy,
	e.document_code as master_contract_document_code_fy,
	b.industry_type_id as master_contract_industry_type_id_fy,
	b.minority_type_id as master_contract_minority_type_id_fy
	FROM tmp_agreement_con a JOIN agreement_snapshot b ON a.master_agreement_id = b.original_agreement_id AND b.master_agreement_yn = 'Y' AND a.fiscal_year between b.starting_year and b.ending_year
		JOIN disbursement_line_item c ON a.disbursement_line_item_id = c.disbursement_line_item_id
		JOIN disbursement d ON c.disbursement_id = d.disbursement_id 
		JOIN ref_document_code e ON b.document_code_id = e.document_code_id;
		
	INSERT INTO tmp_agreement_con_master_fy
	SELECT a.disbursement_line_item_id, a.master_agreement_id,
	b.contract_number as master_contract_number,
	b.maximum_contract_amount as maximum_spending_limit_fy ,
	b.vendor_id as master_contract_vendor_id_fy,
	b.agency_id as master_contract_agency_id_fy,
	b.description as master_purpose_fy ,
	e.document_code as master_contract_document_code_fy,
	b.industry_type_id as master_contract_industry_type_id_fy,
	b.minority_type_id as master_contract_minority_type_id_fy
	FROM tmp_agreement_con a JOIN agreement_snapshot b ON a.master_agreement_id = b.original_agreement_id AND b.master_agreement_yn = 'Y' AND b.latest_flag='Y'
		JOIN disbursement_line_item c ON a.disbursement_line_item_id = c.disbursement_line_item_id
		JOIN disbursement d ON c.disbursement_id = d.disbursement_id 
		JOIN ref_document_code e ON b.document_code_id = e.document_code_id
		LEFT JOIN tmp_agreement_con_master_fy f ON a.disbursement_line_item_id = f.disbursement_line_item_id
		WHERE f.disbursement_line_item_id IS NULL ;
		
		
	
	UPDATE tmp_agreement_con a
	SET maximum_spending_limit = b.maximum_spending_limit_fy,
		master_contract_number = b.master_contract_number,
		master_contract_vendor_id = b.master_contract_vendor_id_fy,
		master_contract_agency_id = b.master_contract_agency_id_fy,
		master_purpose = b.master_purpose_fy,
		master_contract_document_code = b.master_contract_document_code_fy,
		master_contract_industry_type_id = b.master_contract_industry_type_id_fy,
		master_contract_minority_type_id = b.master_contract_minority_type_id_fy
	FROM tmp_agreement_con_master_fy b
	WHERE a.disbursement_line_item_id = b.disbursement_line_item_id;
	
	
	
	RAISE NOTICE 'FMS RF 3';
	
	-- Getting maximum_contract_amount and purpose for CY 
	
	/* CREATE TEMPORARY TABLE tmp_agreement_con_cy(disbursement_line_item_id bigint,agreement_id bigint, 
						maximum_contract_amount_cy numeric(16,2),maximum_contract_amount_latest numeric(16,2), description_cy varchar,
						description_latest varchar)
	DISTRIBUTED  BY (disbursement_line_item_id);
	
	INSERT INTO tmp_agreement_con_cy
    SELECT a.disbursement_line_item_id, b.original_agreement_id,
	SUM(CASE WHEN a.calendar_fiscal_year between b.starting_year and b.ending_year THEN b.maximum_contract_amount ELSE 0 END) as maximum_contract_amount_cy ,
	SUM(CASE WHEN b.latest_flag='Y' THEN b.maximum_contract_amount ELSE 0 END) as maximum_contract_amount_latest ,
	MIN(CASE WHEN a.calendar_fiscal_year between b.starting_year and b.ending_year THEN b.description ELSE NULL END) as description_cy ,
	MIN(CASE WHEN b.latest_flag='Y' THEN b.description ELSE NULL END) as description_latest 
	FROM tmp_agreement_con a JOIN agreement_snapshot_cy b ON a.agreement_id = b.original_agreement_id 
		JOIN disbursement_line_item c ON a.disbursement_line_item_id = c.disbursement_line_item_id
		JOIN disbursement d ON c.disbursement_id = d.disbursement_id
		GROUP BY 1,2;
		
	UPDATE tmp_agreement_con a
	SET maximum_contract_amount_cy = COALESCE(b.maximum_contract_amount_cy, b.maximum_contract_amount_latest),
		purpose_cy = COALESCE(b.description_cy,b.description_latest)	
	FROM tmp_agreement_con_cy b
	WHERE a.disbursement_line_item_id = b.disbursement_line_item_id;
	
	-- Getting maximum_spending_limit for CY
	
	CREATE TEMPORARY TABLE tmp_agreement_con_master_cy(disbursement_line_item_id bigint, master_agreement_id_cy bigint, maximum_spending_limit_cy numeric(16,2),  maximum_spending_limit_latest numeric(16,2))
	DISTRIBUTED  BY (disbursement_line_item_id);
	
	INSERT INTO tmp_agreement_con_master_cy
	SELECT a.disbursement_line_item_id, a.master_agreement_id,
	SUM(CASE WHEN a.calendar_fiscal_year between b.starting_year and b.ending_year THEN b.maximum_contract_amount ELSE 0 END) as maximum_spending_limit_cy ,
	SUM(CASE WHEN b.latest_flag='Y' THEN b.maximum_contract_amount ELSE 0 END) as maximum_spending_limit_latest
	FROM tmp_agreement_con a JOIN agreement_snapshot_cy b ON a.master_agreement_id = b.original_agreement_id AND b.master_agreement_yn = 'Y'
		JOIN disbursement_line_item c ON a.disbursement_line_item_id = c.disbursement_line_item_id
		JOIN disbursement d ON c.disbursement_id = d.disbursement_id
		GROUP BY 1,2;
		
	UPDATE tmp_agreement_con a
	SET maximum_spending_limit_cy = COALESCE(b.maximum_spending_limit_cy, b.maximum_spending_limit_latest)
	FROM tmp_agreement_con_master_cy b
	WHERE a.disbursement_line_item_id = b.disbursement_line_item_id; */
	
	
	-- Getting maximum_contract_amount, master_agreement_id, purpose, contract_number,  contract_vendor_id, contract_agency_id for CY from non master contracts.
	
	CREATE TEMPORARY TABLE tmp_agreement_con_cy(disbursement_line_item_id bigint,agreement_id bigint,
						maximum_contract_amount_cy numeric(16,2), purpose_cy varchar, contract_vendor_id_cy integer, contract_agency_id_cy smallint, 
						contract_industry_type_id_cy smallint, contract_minority_type_id_cy smallint)
	DISTRIBUTED  BY (disbursement_line_item_id);
	
	INSERT INTO tmp_agreement_con_cy
    SELECT a.disbursement_line_item_id, b.original_agreement_id,
	b.maximum_contract_amount as maximum_contract_amount_cy ,
	b.description as purpose_cy ,
	b.vendor_id as contract_vendor_id_cy,
	b.agency_id as contract_agency_id_cy,
	b.industry_type_id as contract_industry_type_id_cy,
	b.minority_type_id as contract_minority_type_id_cy
		FROM tmp_agreement_con a JOIN agreement_snapshot_cy b ON a.agreement_id = b.original_agreement_id AND a.fiscal_year between b.starting_year and b.ending_year
		JOIN disbursement_line_item c ON a.disbursement_line_item_id = c.disbursement_line_item_id
		JOIN ref_document_code e ON b.document_code_id = e.document_code_id;
		
	
	INSERT INTO tmp_agreement_con_cy
    SELECT a.disbursement_line_item_id, b.original_agreement_id,
	b.maximum_contract_amount as maximum_contract_amount_cy ,
	b.description as purpose_cy ,
	b.vendor_id as contract_vendor_id_cy,
	b.agency_id as contract_agency_id_cy,
	b.industry_type_id as contract_industry_type_id_cy,
	b.minority_type_id as contract_minority_type_id_cy
		FROM tmp_agreement_con a JOIN agreement_snapshot_cy b ON a.agreement_id = b.original_agreement_id AND b.latest_flag='Y'
		JOIN disbursement_line_item c ON a.disbursement_line_item_id = c.disbursement_line_item_id
		JOIN disbursement d ON c.disbursement_id = d.disbursement_id
		LEFT JOIN tmp_agreement_con_cy f ON a.disbursement_line_item_id = f.disbursement_line_item_id
		WHERE f.disbursement_line_item_id IS NULL ;
   
		
	UPDATE tmp_agreement_con a
	SET maximum_contract_amount_cy = b.maximum_contract_amount_cy,
		purpose_cy = b.purpose_cy,
		contract_vendor_id_cy = b.contract_vendor_id_cy,
		contract_agency_id_cy = b.contract_agency_id_cy,
		contract_industry_type_id_cy = b.contract_industry_type_id_cy,
		contract_minority_type_id_cy = b.contract_minority_type_id_cy
	FROM tmp_agreement_con_cy b
	WHERE a.disbursement_line_item_id = b.disbursement_line_item_id;
	
	-- Getting maximum_spending_limit, master_contract_number, master_contract_vendor_id, master_contract_agency_id for FY for master agreements
	
	CREATE TEMPORARY TABLE tmp_agreement_con_master_cy(disbursement_line_item_id bigint, master_agreement_id bigint,  maximum_spending_limit_cy numeric(16,2), 
	master_contract_vendor_id_cy integer, master_contract_agency_id_cy smallint, master_purpose_cy varchar, 
	master_contract_industry_type_id_cy smallint, master_contract_minority_type_id_cy smallint)
	DISTRIBUTED  BY (disbursement_line_item_id);
	
	
	INSERT INTO tmp_agreement_con_master_cy
	SELECT a.disbursement_line_item_id, a.master_agreement_id,
	b.maximum_contract_amount as maximum_spending_limit_cy ,
	b.vendor_id as master_contract_vendor_id_cy,
	b.agency_id as master_contract_agency_id_cy,
	b.description as master_purpose_cy,
	b.industry_type_id as master_contract_industry_type_id_cy,
	b.minority_type_id as master_contract_minority_type_id_cy
	FROM tmp_agreement_con a JOIN agreement_snapshot_cy b ON a.master_agreement_id = b.original_agreement_id AND b.master_agreement_yn = 'Y' AND a.fiscal_year between b.starting_year and b.ending_year
		JOIN disbursement_line_item c ON a.disbursement_line_item_id = c.disbursement_line_item_id
		JOIN ref_document_code e ON b.document_code_id = e.document_code_id;
		
		
	INSERT INTO tmp_agreement_con_master_cy
	SELECT a.disbursement_line_item_id, a.master_agreement_id,
	b.maximum_contract_amount as maximum_spending_limit_cy ,
	b.vendor_id as master_contract_vendor_id_cy,
	b.agency_id as master_contract_agency_id_cy,
	b.description as master_purpose_cy,
	b.industry_type_id as master_contract_industry_type_id_cy,
	b.minority_type_id as master_contract_minority_type_id_cy
	FROM tmp_agreement_con a JOIN agreement_snapshot_cy b ON a.master_agreement_id = b.original_agreement_id AND b.master_agreement_yn = 'Y' AND b.latest_flag='Y'
		JOIN disbursement_line_item c ON a.disbursement_line_item_id = c.disbursement_line_item_id
		JOIN disbursement d ON c.disbursement_id = d.disbursement_id 
		LEFT JOIN tmp_agreement_con_master_cy f ON a.disbursement_line_item_id = f.disbursement_line_item_id
		WHERE f.disbursement_line_item_id IS NULL ;
		
		

		
	UPDATE tmp_agreement_con a
	SET maximum_spending_limit_cy = b.maximum_spending_limit_cy,
		master_contract_vendor_id_cy = b.master_contract_vendor_id_cy,
		master_contract_agency_id_cy = b.master_contract_agency_id_cy,
		master_purpose_cy = b.master_purpose_cy,
		master_contract_industry_type_id_cy = b.master_contract_industry_type_id_cy,
		master_contract_minority_type_id_cy = b.master_contract_minority_type_id_cy
	FROM tmp_agreement_con_master_cy b
	WHERE a.disbursement_line_item_id = b.disbursement_line_item_id;
	
	RAISE NOTICE 'FMS RF 4';
	
	UPDATE disbursement_line_item_details a
	SET	agreement_id = a.agreement_id,
		master_agreement_id = b.master_agreement_id,		
		contract_number = b.contract_number,
		master_contract_number = b.master_contract_number,
		maximum_contract_amount =b.maximum_contract_amount,
		maximum_spending_limit = b.maximum_spending_limit,
		purpose = b.purpose,
		master_purpose = b.master_purpose,		
		contract_agency_id  = b.contract_agency_id ,
		master_contract_agency_id  = b.master_contract_agency_id,
		contract_vendor_id  = b.contract_vendor_id ,
		master_contract_vendor_id  = b.master_contract_vendor_id ,		
		maximum_contract_amount_cy =b.maximum_contract_amount_cy,
		maximum_spending_limit_cy = b.maximum_spending_limit_cy,
		purpose_cy = b.purpose_cy,
		master_purpose_cy = b.master_purpose_cy,		
		contract_agency_id_cy  = b.contract_agency_id_cy ,
		master_contract_agency_id_cy  = b.master_contract_agency_id_cy,
		contract_vendor_id_cy  = b.contract_vendor_id_cy ,
		master_contract_vendor_id_cy  = b.master_contract_vendor_id_cy,
		contract_document_code = b.contract_document_code,
		master_contract_document_code = b.master_contract_document_code,
		master_child_contract_agency_id = coalesce(b.master_contract_agency_id,b.contract_agency_id),
		master_child_contract_agency_id_cy = coalesce(b.master_contract_agency_id_cy,b.contract_agency_id_cy),
		master_child_contract_vendor_id = coalesce(b.master_contract_vendor_id,b.contract_vendor_id),
		master_child_contract_vendor_id_cy = coalesce(b.master_contract_vendor_id_cy,b.contract_vendor_id_cy),
		master_child_contract_number = coalesce(b.master_contract_number,b.contract_number),
		industry_type_id = b.industry_type_id,
		industry_type_name = b.industry_type_name,
		agreement_type_code = b.agreement_type_code,
		award_method_code = b.award_method_code,
		contract_industry_type_id = b.contract_industry_type_id,
		contract_industry_type_id_cy = b.contract_industry_type_id_cy,
		master_contract_industry_type_id = b.master_contract_industry_type_id,
		master_contract_industry_type_id_cy = b.master_contract_industry_type_id_cy,
		contract_minority_type_id = b.contract_minority_type_id,
		contract_minority_type_id_cy = b.contract_minority_type_id_cy,
		master_contract_minority_type_id = b.master_contract_minority_type_id,
		master_contract_minority_type_id_cy = b.master_contract_minority_type_id_cy
	FROM	tmp_agreement_con  b
	WHERE   a.disbursement_line_item_id = b.disbursement_line_item_id;
	

	UPDATE disbursement_line_item_details a
	SET minority_type_id = (case when b.bustype_exmp = 'EXMP' AND b.bustype_exmp_status = 2 then 11
			when b.bustype_mnrt = 'MNRT' AND b.bustype_mnrt_status = 2 then c.minority_type_id 
			WHEN b.bustype_wmno = 'WMNO' AND b.bustype_wmno_status = 2 then 9
           		else NULL end),
		minority_type_name = (case when b.bustype_exmp = 'EXMP' AND b.bustype_exmp_status = 2 then 'Individuals & Others'
			when b.bustype_mnrt = 'MNRT' AND b.bustype_mnrt_status = 2 then c.minority_type_name 
			WHEN b.bustype_wmno = 'WMNO' AND b.bustype_wmno_status = 2 then 'Caucasian Woman'
           		else NULL end)
	FROM disbursement  b LEFT JOIN  ref_minority_type c on b.minority_type_id = c.minority_type_id
	WHERE a.disbursement_id = b.disbursement_id AND job_id = p_job_id_in
	AND a.spending_category_id <> 2 and file_type = 'P';
	
	
UPDATE disbursement_line_item_details
SET minority_type_id=11,
minority_type_name = 'Individuals & Others'
WHERE job_id = p_job_id_in AND agreement_type_code IN ('35','36','39','40','44','65','68','79','85') 
AND ( minority_type_id IS NULL OR minority_type_id IN (1,6,7,8));

UPDATE disbursement_line_item_details
SET minority_type_id=11,
minority_type_name = 'Individuals & Others'
WHERE job_id = p_job_id_in AND award_method_code IN ('07','08','09','17','18','44','45','55')
AND ( minority_type_id IS NULL OR minority_type_id IN (1,6,7,8));

UPDATE disbursement_line_item_details a
SET minority_type_id=11,
minority_type_name = 'Individuals & Others'
FROM disbursement b 
WHERE a.disbursement_id = b.disbursement_id AND a.job_id = p_job_id_in
AND b.vendor_org_classification IN (1,5,6,7,8,9,12,13,14,15,19,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36) 
AND ( a.minority_type_id IS NULL OR a.minority_type_id IN (1,6,7,8));

UPDATE disbursement_line_item_details
SET minority_type_id=7,
	minority_type_name = 'Non-Minority'
WHERE job_id = p_job_id_in 	AND ( minority_type_id IS NULL OR minority_type_id IN (1,6,7,8));


	-- needs to delete after first load
	/*
	INSERT INTO disbursement_line_item_deleted(disbursement_line_item_id, load_id, deleted_date, job_id)
	SELECT a.disbursement_line_item_id, coalesce(a.updated_load_id, a.created_load_id), now()::timestamp, p_job_id_in
	FROM disbursement_line_item a, disbursement b
	WHERE   a.disbursement_id = b.disbursement_id 
	AND b.document_version > 1;
	 
	DELETE FROM ONLY disbursement_line_item_details a
	USING disbursement b
	WHERE   a.disbursement_id = b.disbursement_id 
	AND b.document_version > 1;
	
	DELETE FROM ONLY disbursement_line_item a
	USING disbursement b
	WHERE   a.disbursement_id = b.disbursement_id 
	AND b.document_version > 1;
	
	DELETE FROM ONLY disbursement
	WHERE   document_version > 1;
	
	*/
	-- needs to add the script which will delete the version > 1 if we do not have with version = 1
	
	
	 
	CREATE TEMPORARY TABLE tmp_disb_delete_ver_gt1_without_ver0(disbursement_id bigint)
	DISTRIBUTED  BY (disbursement_id);
	
	INSERT INTO tmp_disb_delete_ver_gt1_without_ver0
	select a.disbursement_id from 
	(select * from disbursement where document_version > 1) a 
	LEFT JOIN (select * from disbursement where document_version = 1) b 
	ON a.document_code_id = b.document_code_id  AND a.agency_history_id = b.agency_history_id AND a.document_id = b.document_id
	WHERE b.document_id IS NULL ;
	
	DELETE FROM disbursement a
	USING tmp_disb_delete_ver_gt1_without_ver0 b
	WHERE   a.disbursement_id = b.disbursement_id 
	AND a.document_version > 1 ;
	
	DELETE FROM ONLY disbursement_line_item_details a
	USING tmp_disb_delete_ver_gt1_without_ver0 b
	WHERE   a.disbursement_id = b.disbursement_id ;
	
	INSERT INTO disbursement_line_item_deleted(disbursement_line_item_id, load_id, deleted_date,job_id)
	SELECT a.disbursement_line_item_id, c.load_id, now()::timestamp,p_job_id_in
	FROM disbursement_line_item a, tmp_disb_delete_ver_gt1_without_ver0 b , etl.etl_data_load c
	WHERE   a.disbursement_id = b.disbursement_id 	AND coalesce(a.updated_load_id, a.created_load_id) = c.load_id ;
		
		
	DELETE FROM ONLY disbursement_line_item a
	USING tmp_disb_delete_ver_gt1_without_ver0 b
	WHERE   a.disbursement_id = b.disbursement_id ;
	
	DELETE FROM disbursement_line_item_details 
	WHERE reference_document_code IN ('MA1','MMA1') ;
	 
	 
	
	l_end_time := timeofday()::timestamp;
	
	INSERT INTO etl.etl_script_execution_status(job_id,script_name,completed_flag,start_time,end_time)
	VALUES(p_job_id_in,'etl.refreshFactsForSubPayments',1,l_start_time,l_end_time);
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in refreshFactsForSubPayments';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	
	
	l_end_time := timeofday()::timestamp;
	
	INSERT INTO etl.etl_script_execution_status(job_id,script_name,completed_flag,start_time,end_time,errno,errmsg)
	VALUES(p_job_id_in,'etl.refreshFactsForSubPayments',0,l_start_time,l_end_time,SQLSTATE,SQLERRM);
	
	RETURN 0;
	
END;
$$ language plpgsql;	
