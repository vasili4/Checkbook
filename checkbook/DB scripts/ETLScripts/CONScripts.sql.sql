/*
Functions defined

	updateForeignKeysForCTInHeader
	updateForeignKeysForCTInAwardDetail
	associateMAGToCT
	updateForeignKeysForCTVendors
	updateForeignKeysForCTInAccLine
	processCONGeneralContracts
	processCon

*/
set search_path=etl;

CREATE OR REPLACE FUNCTION updateForeignKeysForCTInHeader() RETURNS INT AS $$
DECLARE
BEGIN
	/* UPDATING FOREIGN KEY VALUES	FOR THE HEADER RECORD*/		
	
	CREATE TEMPORARY TABLE tmp_fk_values (uniq_id bigint, document_code_id smallint,agency_history_id smallint,award_status_id smallint,
					      document_function_code_id smallint, record_date_id smallint,procurement_type_id smallint,
					      effective_begin_date_id smallint,effective_end_date_id smallint,source_created_date_id smallint,
					      source_updated_date_id smallint,registered_date_id smallint, original_term_begin_date_id smallint,
					      original_term_end_date_id smallint)
	DISTRIBUTED BY (uniq_id);
	
	-- FK:Document_Code_id
	
	INSERT INTO tmp_fk_values(uniq_id,document_code_id)
	SELECT	a.uniq_id, b.document_code_id
	FROM etl.stg_con_ct_header a JOIN ref_document_code b ON a.doc_cd = b.document_code;
	
	-- FK:Agency_history_id
	
	INSERT INTO tmp_fk_values(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) as agency_history_id
	FROM etl.stg_con_ct_header a JOIN ref_agency b ON a.doc_dept_cd = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1;
	
	-- FK:Award_status_id
	
	INSERT INTO tmp_fk_values(uniq_id,award_status_id)
	SELECT	a.uniq_id, b.award_status_id
	FROM etl.stg_con_ct_header a JOIN ref_award_status b ON a.cntrc_sta = b.award_status_id;
	
	-- FK:document_function_code_id
	
	INSERT INTO tmp_fk_values(uniq_id,document_function_code_id)
	SELECT	a.uniq_id, b.document_function_code_id
	FROM etl.stg_con_ct_header a JOIN ref_document_function_code b ON a.doc_func_cd = b.document_function_code_id;
	
	-- FK:record_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,record_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.doc_rec_dt_dc = b.date;
	
	--FK:procurement_type_id
	
	INSERT INTO tmp_fk_values(uniq_id,procurement_type_id)
	SELECT	a.uniq_id, b.procurement_type_id
	FROM etl.stg_con_ct_header a JOIN ref_procurement_type b ON a.prcu_typ_id = b.procurement_type_id;
	
	--FK:effective_begin_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,effective_begin_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.cntrct_strt_dt = b.date;
	
	--FK:effective_end_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,effective_end_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.cntrct_end_dt = b.date;
	
	--FK:source_created_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,source_created_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.doc_appl_crea_dt = b.date;
	
	--FK:source_updated_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,source_updated_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.doc_appl_last_dt = b.date;
	
	--FK:registered_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,registered_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.reg_dt = b.date;

	--FK:original_term_begin_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,original_term_begin_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.orig_cntrc_strt_dt = b.date;

	--FK:original_term_end_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,original_term_end_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.orig_cntrc_end_dt = b.date;
	
	--Updating con_ct_header with all the FK values
	
	UPDATE etl.stg_con_ct_header a
	SET	document_code_id = ct_table.document_code_id ,
		agency_history_id = ct_table.agency_history_id,
		award_status_id = ct_table.award_status_id,
		document_function_code_id = ct_table.document_function_code_id, 
		record_date_id = ct_table.record_date_id,
		procurement_type_id = ct_table.procurement_type_id, 
		effective_begin_date_id = ct_table.effective_begin_date_id,
		effective_end_date_id = ct_table.effective_end_date_id,
		source_created_date_id = ct_table.source_created_date_id,
		source_updated_date_id = ct_table.source_updated_date_id,
		registered_date_id = ct_table.registered_date_id, 
		original_term_begin_date_id = ct_table.original_term_begin_date_id, 
		original_term_end_date_id = ct_table.original_term_end_date_id
	FROM	(SELECT uniq_id, max(document_code_id) as document_code_id ,
				 max(agency_history_id) as agency_history_id,max(award_status_id) as award_status_id,
				 max(document_function_code_id) as document_function_code_id, max(record_date_id) as record_date_id,
				 max(procurement_type_id) as procurement_type_id, max(effective_begin_date_id) as effective_begin_date_id,
				 max(effective_end_date_id) as effective_end_date_id,max(source_created_date_id) as source_created_date_id,
				 max(source_updated_date_id) as source_updated_date_id,max(registered_date_id) as registered_date_id, 
				 max(original_term_begin_date_id) as original_term_begin_date_id, max(original_term_end_date_id) as original_term_end_date_id
		 FROM	tmp_fk_values
		 GROUP BY 1) ct_table
	WHERE	a.uniq_id = ct_table.uniq_id;	
	
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in updateForeignKeysForCTInHeader';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

-------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION updateForeignKeysForCTInAwardDetail() RETURNS INT AS $$
DECLARE
BEGIN
	-- UPDATING FK VALUES IN AWARD DETAIL
	
	CREATE TEMPORARY TABLE tmp_fk_values_award_detail(uniq_id bigint,award_method_id smallint,award_level_id smallint,agreement_type_id smallint,
						      		award_category_id_1 smallint,award_category_id_2 smallint, award_category_id_3 smallint, award_category_id_4 smallint,
					      			award_category_id_5 smallint)
	DISTRIBUTED BY (uniq_id);
	
	-- FK:award_method_id
	
	INSERT INTO tmp_fk_values_award_detail(uniq_id,award_method_id)
	SELECT a.uniq_id , b.award_method_id
	FROM	etl.stg_con_ct_award_detail a JOIN ref_award_method b ON a.awd_meth_cd = b.award_method_code;

	--FK:award_level_id
	
	INSERT INTO tmp_fk_values_award_detail(uniq_id,award_level_id)
	SELECT a.uniq_id , b.award_level_id
	FROM	etl.stg_con_ct_award_detail a JOIN ref_award_level b ON a.awd_lvl_cd = b.award_level_code;
	
	--FK:agreement_type_id
	
	INSERT INTO tmp_fk_values_award_detail(uniq_id,agreement_type_id)
	SELECT a.uniq_id , b.agreement_type_id
	FROM	etl.stg_con_ct_award_detail a JOIN ref_agreement_type b ON a.cttyp_cd = b.agreement_type_code;

	--FK:award_category_id_1
	
	INSERT INTO tmp_fk_values_award_detail(uniq_id,award_category_id_1)
	SELECT a.uniq_id , b.award_category_id
	FROM	etl.stg_con_ct_award_detail a JOIN ref_award_category b ON a.ctcat_cd_1 = b.award_category_code;

	--FK:award_category_id_2
	
	INSERT INTO tmp_fk_values_award_detail(uniq_id,award_category_id_2)
	SELECT a.uniq_id , b.award_category_id
	FROM	etl.stg_con_ct_award_detail a JOIN ref_award_category b ON a.ctcat_cd_2 = b.award_category_code;

	--FK:award_category_id_3
	
	INSERT INTO tmp_fk_values_award_detail(uniq_id,award_category_id_3)
	SELECT a.uniq_id , b.award_category_id
	FROM	etl.stg_con_ct_award_detail a JOIN ref_award_category b ON a.ctcat_cd_3 = b.award_category_code;

	--FK:award_category_id_4
	
	INSERT INTO tmp_fk_values_award_detail(uniq_id,award_category_id_4)
	SELECT a.uniq_id , b.award_category_id
	FROM	etl.stg_con_ct_award_detail a JOIN ref_award_category b ON a.ctcat_cd_4 = b.award_category_code;

	--FK:award_category_id_5
	
	INSERT INTO tmp_fk_values_award_detail(uniq_id,award_category_id_5)
	SELECT a.uniq_id , b.award_category_id
	FROM	etl.stg_con_ct_award_detail a JOIN ref_award_category b ON a.ctcat_cd_5 = b.award_category_code;


	UPDATE etl.stg_con_ct_award_detail a
	SET	award_method_id = ct_table.award_method_id ,
		award_level_id = ct_table.award_level_id ,
		agreement_type_id = ct_table.agreement_type_id ,
		award_category_id_1 = ct_table.award_category_id_1 ,
		award_category_id_2 = ct_table.award_category_id_2 ,
		award_category_id_3 = ct_table.award_category_id_3 ,
		award_category_id_4 = ct_table.award_category_id_4 ,
		award_category_id_5 = ct_table.award_category_id_5 
	FROM	
		(SELECT uniq_id,
			max(award_method_id) as award_method_id ,
			max(award_level_id) as award_level_id 	 ,
			max(agreement_type_id) as agreement_type_id   ,
			max(award_category_id_1) as award_category_id_1	 ,
			max(award_category_id_2) as award_category_id_2	 ,
			max(award_category_id_3) as award_category_id_3	 ,
			max(award_category_id_4) as award_category_id_4	 ,
			max(award_category_id_5) as award_category_id_5  
		FROM 	tmp_fk_values_award_detail
		GROUP BY 1 )ct_table
	WHERE	a.uniq_id = ct_table.uniq_id;	
	

	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in updateForeignKeysForCTInAwardDetail';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION associateMAGToCT() RETURNS INT AS $$
DECLARE
	l_worksite_col_array VARCHAR ARRAY[10];
	l_array_ctr smallint;
	l_fk_update int;
BEGIN
						  
	-- Fetch all the contracts associated with MAG
	
	CREATE TEMPORARY TABLE tmp_ct_mag(uniq_id bigint, master_agreement_id bigint,mag_document_id varchar, 
				mag_agency_history_id smallint, mag_document_code_id smallint, mag_document_code varchar, mag_agency_code varchar )	
	DISTRIBUTED BY(uniq_id);
	
	INSERT INTO tmp_ct_mag
	SELECT uniq_id, 0 as master_agreement_id,
	       max(agree_doc_id),
	       max(d.agency_history_id) as mag_agency_history_id,
	       max(c.document_code_id),
	       max(c.document_code),
	       max(b.agency_code)
	FROM	etl.stg_con_ct_header a JOIN ref_agency b ON a.agree_doc_dept_cd = b.agency_code
		JOIN ref_document_code c ON a.agree_doc_cd = c.document_code
		JOIN ref_agency_history d ON b.agency_id = d.agency_id
	GROUP BY 1,2;		
		
	
	-- Identify the MAG Id
	
	CREATE TEMPORARY TABLE tmp_old_ct_mag_con(uniq_id bigint,master_agreement_id bigint, action_flag char(1), latest_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_old_ct_mag_con
	SELECT uniq_id,
	       master_agreement_id	
	FROM	
		(SELECT  uniq_id,		
			 b.document_version as mag_document_version,
			 b.master_agreement_id,
			 rank()over(partition by uniq_id order by b.document_version desc) as rank_value
		FROM tmp_ct_mag a JOIN history_all_master_agreement b ON a.mag_document_id = b.document_id 
			JOIN ref_document_code f ON a.mag_document_code = f.document_code AND b.document_code_id = f.document_code_id
			JOIN ref_agency e ON a.mag_agency_code = e.agency_code 
			JOIN ref_agency_history c ON b.agency_history_id = c.agency_history_id AND e.agency_id = c.agency_id			
		) inner_tbl
	WHERE	rank_value = 1;	
	
	UPDATE tmp_ct_mag a
	SET	master_agreement_id = b.master_agreement_id
	FROM	tmp_old_ct_mag_con b
	WHERE	a.uniq_id = b.uniq_id;
	
	-- Identify the MAG ones which have to be created
	
	CREATE TEMPORARY TABLE tmp_new_ct_mag_con(mag_document_code varchar,mag_agency_code varchar, mag_document_id varchar,
					   mag_agency_history_id smallint,mag_document_code_id smallint,uniq_id bigint);
	
	INSERT INTO tmp_new_ct_mag_con
	SELECT 	mag_document_code,mag_agency_code, mag_document_id,mag_agency_history_id,mag_document_code_id,min(uniq_id)
	FROM	tmp_ct_mag
	WHERE	master_agreement_id =0
	GROUP BY 1,2,3,4,5;
	
	TRUNCATE etl.agreement_id_seq;
	
	INSERT INTO etl.agreement_id_seq(uniq_id)
	SELECT uniq_id
	FROM  tmp_new_ct_mag_con;
	
	INSERT INTO all_master_agreement(master_agreement_id,document_code_id,agency_history_id,document_id,document_version,privacy_flag)
	SELECT  b.agreement_id, a.mag_document_code_id,a.mag_agency_history_id,a.mag_document_id,0 as document_version,'F' as privacy_flag
	FROM	tmp_new_ct_mag_con a JOIN etl.agreement_id_seq b ON a.uniq_id = b.uniq_id;
	
	INSERT INTO history_all_master_agreement(master_agreement_id,document_code_id,agency_history_id,document_id,document_version,privacy_flag)
	SELECT  b.agreement_id, a.mag_document_code_id,a.mag_agency_history_id,a.mag_document_id,0 as document_version,'F' as privacy_flag
	FROM	tmp_new_ct_mag_con a JOIN etl.agreement_id_seq b ON a.uniq_id = b.uniq_id;	
	
	/* Rule covers this
	INSERT INTO master_agreement(master_agreement_id,document_code_id,agency_history_id,document_id,document_version)
	SELECT  b.agreement_id, a.mag_document_code_id,a.mag_agency_history_id,a.mag_document_id,0 as document_version
	FROM	tmp_new_ct_mag_con a JOIN etl.agreement_id_seq b ON a.uniq_id = b.uniq_id;
	
	
	INSERT INTO history_master_agreement(master_agreement_id,document_code_id,agency_history_id,document_id,document_version)
	SELECT  b.agreement_id, a.mag_document_code_id,a.mag_agency_history_id,a.mag_document_id,0 as document_version
	FROM	tmp_new_ct_mag_con a JOIN etl.agreement_id_seq b ON a.uniq_id = b.uniq_id;
	*/
	
	-- Updating the newly created MAG identifier.
	
	CREATE TEMPORARY TABLE tmp_new_ct_mag_con_2(uniq_id bigint,master_agreement_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_new_ct_mag_con_2
	SELECT c.uniq_id,d.agreement_id
	FROM   tmp_ct_mag a JOIN tmp_new_ct_mag_con b ON a.uniq_id = b.uniq_id
		JOIN tmp_ct_mag c ON c.mag_document_code = a.mag_document_code
				     AND c.mag_agency_code = a.mag_agency_code
				     AND c.mag_document_id = a.mag_document_id
		JOIN etl.agreement_id_seq d ON b.uniq_id = d.uniq_id;
		
	UPDATE tmp_ct_mag a
	SET	master_agreement_id = b.master_agreement_id
	FROM	tmp_new_ct_mag_con_2 b
	WHERE	a.uniq_id = b.uniq_id
		AND a.master_agreement_id =0;
	 	
	 UPDATE etl.stg_con_ct_header a
	 SET	master_agreement_id = b.master_agreement_id
	 FROM	tmp_ct_mag b
	 WHERE	a.uniq_id = b.uniq_id;
	 
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in associateMAGToCT';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION updateForeignKeysForCTVendors() RETURNS INT AS $$
DECLARE

BEGIN

	-- UPDATING FK VALUES IN VENDOR

	CREATE TEMPORARY TABLE tmp_fk_values_vendor(uniq_id bigint,vendor_customer_code varchar, vendor_history_id integer)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_vendor
	SELECT uniq_id,a.vend_cust_cd,MAX(c.vendor_history_id) as vendor_history_id
	FROM	etl.stg_con_ct_vendor a LEFT JOIN vendor b ON a.vend_cust_cd = b.vendor_customer_code
		LEFT JOIN vendor_history c ON b.vendor_id = c.vendor_id
	GROUP BY 1,2;
	
	-- Identify the new vendors
	
	CREATE TEMPORARY TABLE tmp_vendor_new(uniq_id bigint, vendor_customer_code varchar)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_vendor_new
	SELECT min(uniq_id) as uniq_id, vendor_customer_code
	FROM	tmp_fk_values_vendor
	WHERE   vendor_history_id IS NULL
	GROUP BY 2;
	
	TRUNCATE etl.vendor_id_seq;
	
	INSERT INTO etl.vendor_id_seq(uniq_id)
	SELECT uniq_id
	FROM tmp_vendor_new;
	

	TRUNCATE etl.vendor_history_id_seq;
	
	INSERT INTO etl.vendor_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM tmp_vendor_new;


	CREATE TEMPORARY TABLE tmp_ct_vendor(uniq_id bigint,vendor_history_id int)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_ct_vendor
	SELECT c.uniq_id, d.vendor_history_id
	FROM tmp_fk_values_vendor a JOIN tmp_vendor_new b ON a.uniq_id = b.uniq_id		
		JOIN tmp_fk_values_vendor c ON a.vendor_customer_code = c.vendor_customer_code
		JOIN etl.vendor_history_id_seq d ON b.uniq_id = d.uniq_id;
	
	
	UPDATE tmp_fk_values_vendor a
	SET	vendor_history_id = b.vendor_history_id
	FROM	tmp_ct_vendor b 
	WHERE	a.uniq_id = b.uniq_id;
					
	
	UPDATE etl.stg_con_ct_vendor a
	SET	vendor_history_id = b.vendor_history_id
	FROM	tmp_fk_values_vendor b 
	WHERE	a.uniq_id = b.uniq_id;
	
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in updateForeignKeysForCTVendors';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;
------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.updateForeignKeysForCTInAccLine() RETURNS INT AS $$
DECLARE
BEGIN
	-- UPDATING FK VALUES IN ETL.STG_CON_CT_ACCOUNTING_LINE
	
	CREATE TEMPORARY TABLE tmp_fk_values_acc_line(uniq_id bigint,event_type_id smallint, fund_class_id smallint,agency_history_id smallint,
							department_history_id int, expenditure_object_history_id integer,budget_code_id integer)
	DISTRIBUTED BY (uniq_id);
	
	-- FK:event_type_id

	INSERT INTO tmp_fk_values_acc_line(uniq_id,event_type_id)
	SELECT	a.uniq_id, b.event_type_id
	FROM etl.stg_con_ct_accounting_line a JOIN ref_event_type b ON a.evnt_typ_id = b.event_type_code;	
	
	-- FK:fund_class_id

	INSERT INTO tmp_fk_values_acc_line(uniq_id,fund_class_id)
	SELECT	a.uniq_id, b.fund_class_id
	FROM etl.stg_con_ct_accounting_line a JOIN ref_fund_class b ON a.fund_cd = b.fund_class_code;	

	-- FK:agency_history_id

	INSERT INTO tmp_fk_values_acc_line(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) 
	FROM etl.stg_con_ct_accounting_line a JOIN ref_agency b ON a.dept_cd = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1	;	

	-- FK:department_history_id

	INSERT INTO tmp_fk_values_acc_line(uniq_id,department_history_id)
	SELECT	a.uniq_id, max(c.department_history_id) 
	FROM etl.stg_con_ct_accounting_line a JOIN ref_department b ON a.appr_cd = b.department_code AND a.bfy = b.fiscal_year
		JOIN ref_department_history c ON b.department_id = c.department_id
		JOIN ref_agency d ON a.dept_cd = d.agency_code AND b.agency_id = d.agency_id
		JOIN ref_fund_class e ON a.fund_cd = e.fund_class_code AND e.fund_class_id = b.fund_class_id
	GROUP BY 1	;		


	-- FK:expenditure_object_history_id

	INSERT INTO tmp_fk_values_acc_line(uniq_id,expenditure_object_history_id)
	SELECT	a.uniq_id, max(c.expenditure_object_history_id) 
	FROM etl.stg_con_ct_accounting_line a JOIN ref_expenditure_object b ON a.obj_cd = b.expenditure_object_code AND a.bfy = b.fiscal_year
		JOIN ref_expenditure_object_history c ON b.expenditure_object_id = c.expenditure_object_id
	GROUP BY 1	;


	-- FK:budget_code_id

	INSERT INTO tmp_fk_values_acc_line(uniq_id,budget_code_id)
	SELECT	a.uniq_id, b.budget_code_id
	FROM etl.stg_con_ct_accounting_line a JOIN ref_budget_code b ON a.func_cd = b.budget_code AND a.bfy=b.fiscal_year
		JOIN ref_agency d ON a.dept_cd = d.agency_code AND b.agency_id = d.agency_id
		JOIN ref_fund_class e ON a.fund_cd = e.fund_class_code AND e.fund_class_id = b.fund_class_id;	
		
	
	UPDATE etl.stg_con_ct_accounting_line a
	SET	event_type_id =ct_table.event_type_id ,
		fund_class_id =ct_table.fund_class_id ,
		agency_history_id =ct_table.agency_history_id ,
		department_history_id =ct_table.department_history_id ,
		expenditure_object_history_id =ct_table.expenditure_object_history_id ,
		budget_code_id=ct_table.budget_code_id 
	FROM	
		(SELECT uniq_id,
			max(event_type_id )as event_type_id ,
			max(fund_class_id )as fund_class_id ,
			max(agency_history_id )as agency_history_id ,
			max(department_history_id )as department_history_id ,
			max(expenditure_object_history_id )as expenditure_object_history_id ,
			max(budget_code_id) as budget_code_id 
		FROM	tmp_fk_values_acc_line
		GROUP	BY 1) ct_table
	WHERE	a.uniq_id = ct_table.uniq_id;	

	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in updateForeignKeysForCTInAccLine';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processCONGeneralContracts(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_worksite_col_array VARCHAR ARRAY[10];
	l_array_ctr smallint;
	l_fk_update int;
	l_worksite_per_array VARCHAR ARRAY[10];
	l_insert_sql VARCHAR;
BEGIN
	l_worksite_col_array := ARRAY['wk_site_cd_01',
				      'wk_site_cd_02',
				      'wk_site_cd_03',
				      'wk_site_cd_04',
				      'wk_site_cd_05',
				      'wk_site_cd_06',
				      'wk_site_cd_07',
				      'wk_site_cd_08',
				      'wk_site_cd_09',
				      'wk_site_cd_10'];
				      
	l_worksite_per_array := ARRAY['percent_01',
				      'percent_02',
				      'percent_03',
				      'percent_04',
				      'percent_05',
				      'percent_06',
				      'percent_07',
				      'percent_08',
				      'percent_09',
				      'percent_10'];
				      

	l_fk_update := etl.updateForeignKeysForCTInHeader();

	RAISE NOTICE 'CON 1';
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.updateForeignKeysForCTInAwardDetail();
	ELSE
		RETURN -1;
	END IF;

	RAISE NOTICE 'CON 2';
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.associateMAGToCT();
	ELSE
		RETURN -1;
	END IF;

	RAISE NOTICE 'CON 3';
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.updateForeignKeysForCTVendors();
	ELSE
		RETURN -1;
	END IF;

	RAISE NOTICE 'CON 4';
	
	IF l_fk_update = 1 THEN	 
		l_fk_update := etl.updateForeignKeysForCTInAccLine();	
	ELSE
		RETURN -1;
	END IF;

	RAISE NOTICE 'CON 5';
	-- UPDATING FK VALUES IN ETL.STG_CON_CT_COMMODITY
	
	CREATE TEMPORARY TABLE tmp_fk_values_commodity(uniq_id bigint,commodity_type_id int)
	DISTRIBUTED BY (uniq_id);	
	
	-- FK:commodity_type_id

	INSERT INTO tmp_fk_values_commodity(uniq_id,commodity_type_id)
	SELECT	a.uniq_id, b.commodity_type_id
	FROM etl.stg_con_ct_commodity a JOIN ref_commodity_type b ON a.ln_typ = b.commodity_type_id;
	
	UPDATE etl.stg_con_ct_commodity a
	SET	commodity_type_id = b.commodity_type_id
	FROM	tmp_fk_values_commodity b
	WHERE 	a.uniq_id = b.uniq_id;
	
	/*
	1.Pull the key information such as document code, document id, document version etc for all agreements
	2. For the existing contracts gather details on max version in the transaction, staging tables..Determine if the staged agreement is latest version...
	3. Identify the new agreements. Determine the latest version for each of it.
	*/
	
	RAISE NOTICE 'CON 6';
	CREATE TEMPORARY TABLE tmp_ct_con(uniq_id bigint, agency_history_id smallint,doc_id varchar,agreement_id bigint, action_flag char(1), 
					  latest_flag char(1),doc_vers_no smallint,privacy_flag char(1),old_agreement_ids varchar)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_ct_con(uniq_id,agency_history_id,doc_id,doc_vers_no,privacy_flag)
	SELECT uniq_id,agency_history_id,doc_id,doc_vers_no,'F' as privacy_flag
	FROM etl.stg_con_ct_header;
	
	-- For the existing contracts gather details on max version in the transaction, staging tables..Determine if the staged agreement is latest version...
	
	CREATE TEMPORARY TABLE tmp_old_ct_con(uniq_id bigint,agreement_id bigint, action_flag char(1), latest_flag char(1),privacy_flag char(1),old_agreement_ids varchar)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_old_ct_con
	SELECT d.uniq_id,
		inner_tbl.agreement_id,
		(CASE WHEN match_count = 1 THEN 'U' ELSE 'I' END) as action_flag,
		(CASE WHEN d.doc_vers_no >= staging_max_doc_vers_no AND d.doc_vers_no >= max_document_version THEN 'Y' ELSE 'N' END) as latest_flag,
		privacy_flag,
		old_agreement_ids
	FROM	
		(SELECT  uniq_id,		
			MAX(c.agency_history_id) as stagig_agency_history_id,	
			MIN(a.doc_id) as staging_document_id,
			MAX(a.doc_vers_no) as staging_max_doc_vers_no,
			MAX(b.document_version) as max_document_version, 
			SUM(CASE WHEN a.doc_vers_no = b.document_version THEN 1 ELSE 0 END) as match_count,			
			MAX(CASE WHEN a.doc_vers_no = b.document_version THEN b.agreement_id ELSE 0 END) as agreement_id,
			MAX(b.privacy_flag) as privacy_flag,
			GROUP_CONCAT(b.agreement_id) as old_agreement_ids
		FROM etl.stg_con_ct_header a JOIN history_all_agreement b ON a.doc_id = b.document_id AND a.document_code_id = b.document_code_id
			JOIN ref_agency_history c ON a.agency_history_id = c.agency_history_id
			JOIN ref_agency_history d ON b.agency_history_id = d.agency_history_id
			JOIN ref_agency e ON c.agency_id = d.agency_id AND a.doc_dept_cd = e.agency_code
		GROUP BY 1) inner_tbl JOIN etl.stg_con_ct_header d ON inner_tbl.uniq_id = d.uniq_id;
			
	
	UPDATE tmp_ct_con a
	SET	agreement_id = b.agreement_id,
		action_flag = b.action_flag,
		latest_flag = b.latest_flag,
		privacy_flag=b.privacy_flag,
		old_agreement_ids = b.old_agreement_ids
	FROM	tmp_old_ct_con b
	WHERE	a.uniq_id = b.uniq_id;
	
	RAISE NOTICE 'CON 7';
	-- Identify the new agreements. Determine the latest version for each of it.
	
	CREATE TEMPORARY TABLE tmp_new_ct_con(uniq_id bigint,agreement_id bigint, action_flag char(1), latest_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_new_ct_con
	SELECT inner_tbl.uniq_id,
		0 as agreement_id,
		'I' as action_flag,
		(CASE WHEN c.doc_vers_no = inner_tbl.staging_max_doc_vers_no THEN 'Y' ELSE 'N' END) as latest_flag
	FROM	
	(SELECT  a.uniq_id,
		max(b.doc_vers_no) as staging_max_doc_vers_no
	FROM	tmp_ct_con a JOIN etl.stg_con_ct_header b ON a.doc_id = b.doc_id AND a.agency_history_id = b.agency_history_id
	WHERE	COALESCE(a.agreement_id,0) =0 AND a.action_flag IS NULL
	GROUP BY 1) inner_tbl JOIN tmp_ct_con c ON inner_tbl.uniq_id = c.uniq_id;
	

	TRUNCATE etl.agreement_id_seq;
	
	
	INSERT INTO etl.agreement_id_seq(uniq_id)
	SELECT uniq_id
	FROM	tmp_new_ct_con;
	
	UPDATE tmp_new_ct_con a
	SET	agreement_id = b.agreement_id
	FROM	etl.agreement_id_seq b
	WHERE	a.uniq_id = b.uniq_id;
	
	UPDATE tmp_ct_con a
	SET	agreement_id = b.agreement_id,
		action_flag = b.action_flag,
		latest_flag = b.latest_flag,
		privacy_flag='F'
	FROM	tmp_new_ct_con b
	WHERE	a.uniq_id = b.uniq_id;
	
	RAISE NOTICE 'CON 8';
	-- Handling new ones
		-- match_count is 0 & staging_doc_vers_no > max_document_version then delete the existing one from agreement and insert new records in both agreement,history_agreement
		-- match_count is 0 & staging_doc_vers_no < max_document_version then insert into history_agreement
	-- Handling existing ones
		-- match_count is 0 & staging_doc_vers_no = max_document_version then update agreement,history_agreement. Delete the corresponding child records and insert new sets
		-- match_count is 0 & staging_doc_vers_no < max_document_version then update history_agreement. Delete the corresponding child records and insert new sets
		
	/* Identify the agreements which have to be deleted since the latest version has been recieved in the data feed.*/
	
	CREATE TEMPORARY TABLE tmp_ct_deletion(agreement_id bigint)
	DISTRIBUTED BY (agreement_id);
	
	INSERT INTO tmp_ct_deletion
	SELECT  unnest(string_to_array(old_agreement_ids,','))::int
	FROM	tmp_ct_con
	WHERE	action_flag = 'I'
		AND latest_flag ='Y';	
		
	DELETE FROM agreement_accounting_line WHERE agreement_id IN (select agreement_id from tmp_ct_deletion);
	DELETE FROM all_agreement_accounting_line WHERE agreement_id IN (select agreement_id from tmp_ct_deletion);
	
	DELETE FROM agreement_commodity WHERE agreement_id IN (select agreement_id from tmp_ct_deletion);
	DELETE FROM all_agreement_commodity WHERE agreement_id IN (select agreement_id from tmp_ct_deletion);
	
	DELETE FROM agreement_worksite WHERE agreement_id IN (select agreement_id from tmp_ct_deletion) AND master_agreement_yn='N';
	DELETE FROM all_agreement_worksite WHERE agreement_id IN (select agreement_id from tmp_ct_deletion) AND master_agreement_yn='N';	
	
	DELETE FROM agreement WHERE agreement_id IN (select agreement_id from tmp_ct_deletion);
	DELETE FROM all_agreement WHERE agreement_id IN (select agreement_id from tmp_ct_deletion);	

	RAISE NOTICE 'CON 9';
	INSERT INTO all_agreement(agreement_id,master_agreement_id,document_code_id,
				agency_history_id,document_id,document_version,
				tracking_number,record_date_id,budget_fiscal_year,
				document_fiscal_year,document_period,description,
				actual_amount,obligated_amount,maximum_contract_amount,
				amendment_number,replacing_agreement_id,replaced_by_agreement_id,
				award_status_id,procurement_id,procurement_type_id,
				effective_begin_date_id,effective_end_date_id,reason_modification,
				source_created_date_id,source_updated_date_id,document_function_code_id,
				award_method_id,award_level_id,agreement_type_id,
				contract_class_code,award_category_id_1,award_category_id_2,
				award_category_id_3,award_category_id_4,award_category_id_5,
				number_responses,location_service,location_zip,
				borough_code,block_code,lot_code,
				council_district_code,vendor_history_id,vendor_preference_level,
				original_contract_amount,registered_date_id,oca_number,
				number_solicitation,document_name,original_term_begin_date_id,
				original_term_end_date_id,privacy_flag,load_id,created_date)
	SELECT	d.agreement_id,a.master_agreement_id,a.document_code_id,
		a.agency_history_id,a.doc_id,a.doc_vers_no,
		a.trkg_no,a.record_date_id,a.doc_bfy,
		a.doc_fy_dc,a.doc_per_dc,a.doc_dscr,
		a.doc_actu_am,a.enc_am,a.max_cntrc_am,
		a.amend_no,0 as replacing_agreement_id,0 as replaced_by_agreement_id,
		a.award_status_id,a.prcu_id,a.procurement_type_id,
		a.effective_begin_date_id,a.effective_end_date_id,a.reas_mod_dc,
		a.source_created_date_id,a.source_updated_date_id,a.document_function_code_id,
		c.award_method_id,c.award_level_id,c.agreement_type_id,
		c.ctcls_cd,c.award_category_id_1,c.award_category_id_2,
		c.award_category_id_3,c.award_category_id_4,c.award_category_id_5,
		c.resp_ct,c.loc_serv,c.loc_zip,
		c.brgh_cd,c.blck_cd,c.lot_cd,
		c.coun_dist_cd,b.vendor_history_id,b.vend_pref_lvl,
		a.orig_max_am,a.registered_date_id,a.oca_no,
		c.out_of_no_so,a.doc_nm,a.original_term_begin_date_id,
		a.original_term_end_date_id,d.privacy_flag,p_load_id_in,now()::timestamp
	FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_vendor b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
					     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
					JOIN etl.stg_con_ct_award_detail c ON a.doc_cd = c.doc_cd AND a.doc_dept_cd = c.doc_dept_cd 
					     AND a.doc_id = c.doc_id AND a.doc_vers_no = c.doc_vers_no
					 JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id
	WHERE   action_flag='I' and latest_flag='Y';				 


	/* Insert new contracts into history_all_agreement
	identified by action flag as I 
	It will be inserted into hist_agreement based on the rule
	*/
	
	INSERT INTO history_all_agreement(agreement_id,master_agreement_id,document_code_id,
				agency_history_id,document_id,document_version,
				tracking_number,record_date_id,budget_fiscal_year,
				document_fiscal_year,document_period,description,
				actual_amount,obligated_amount,maximum_contract_amount,
				amendment_number,replacing_agreement_id,replaced_by_agreement_id,
				award_status_id,procurement_id,procurement_type_id,
				effective_begin_date_id,effective_end_date_id,reason_modification,
				source_created_date_id,source_updated_date_id,document_function_code_id,
				award_method_id,award_level_id,agreement_type_id,
				contract_class_code,award_category_id_1,award_category_id_2,
				award_category_id_3,award_category_id_4,award_category_id_5,
				number_responses,location_service,location_zip,
				borough_code,block_code,lot_code,
				council_district_code,vendor_history_id,vendor_preference_level,
				original_contract_amount,registered_date_id,oca_number,
				number_solicitation,document_name,original_term_begin_date_id,
				original_term_end_date_id,privacy_flag,load_id,created_date)
	SELECT	d.agreement_id,a.master_agreement_id,a.document_code_id,
		a.agency_history_id,a.doc_id,a.doc_vers_no,
		a.trkg_no,a.record_date_id,a.doc_bfy,
		a.doc_fy_dc,a.doc_per_dc,a.doc_dscr,
		a.doc_actu_am,a.enc_am,a.max_cntrc_am,
		a.amend_no,0 as replacing_agreement_id,0 as replaced_by_agreement_id,
		a.award_status_id,a.prcu_id,a.procurement_type_id,
		a.effective_begin_date_id,a.effective_end_date_id,a.reas_mod_dc,
		a.source_created_date_id,a.source_updated_date_id,a.document_function_code_id,
		c.award_method_id,c.award_level_id,c.agreement_type_id,
		c.ctcls_cd,c.award_category_id_1,c.award_category_id_2,
		c.award_category_id_3,c.award_category_id_4,c.award_category_id_5,
		c.resp_ct,c.loc_serv,c.loc_zip,
		c.brgh_cd,c.blck_cd,c.lot_cd,
		c.coun_dist_cd,b.vendor_history_id,b.vend_pref_lvl,
		a.orig_max_am,a.registered_date_id,a.oca_no,
		c.out_of_no_so,a.doc_nm,a.original_term_begin_date_id,
		a.original_term_end_date_id,d.privacy_flag,p_load_id_in,now()::timestamp
	FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_vendor b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
					     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
					JOIN etl.stg_con_ct_award_detail c ON a.doc_cd = c.doc_cd AND a.doc_dept_cd = c.doc_dept_cd 
					     AND a.doc_id = c.doc_id AND a.doc_vers_no = c.doc_vers_no
					 JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id
	WHERE   action_flag='I';				 
	
	/* Updates */
	CREATE TEMPORARY TABLE tmp_con_ct_update AS
	SELECT d.agreement_id,a.master_agreement_id,a.document_code_id,
			a.agency_history_id,a.doc_id,a.doc_vers_no,
			a.trkg_no,a.record_date_id,a.doc_bfy,
			a.doc_fy_dc,a.doc_per_dc,a.doc_dscr,
			a.doc_actu_am,a.enc_am,a.max_cntrc_am,
			a.amend_no,0 as replacing_agreement_id,0 as replaced_by_agreement_id,
			a.award_status_id,a.prcu_id,a.procurement_type_id,
			a.effective_begin_date_id,a.effective_end_date_id,a.reas_mod_dc,
			a.source_created_date_id,a.source_updated_date_id,a.document_function_code_id,
			c.award_method_id,c.award_level_id,c.agreement_type_id,
			c.ctcls_cd,c.award_category_id_1,c.award_category_id_2,
			c.award_category_id_3,c.award_category_id_4,c.award_category_id_5,
			c.resp_ct,c.loc_serv,c.loc_zip,
			c.brgh_cd,c.blck_cd,c.lot_cd,
			c.coun_dist_cd,b.vendor_history_id,b.vend_pref_lvl,
			a.orig_max_am,a.registered_date_id,a.oca_no,
			c.out_of_no_so,a.doc_nm,a.original_term_begin_date_id,
			a.original_term_end_date_id,d.privacy_flag,p_load_id_in as load_id,now()::timestamp as updated_date
		FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_vendor b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
						     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
						JOIN etl.stg_con_ct_award_detail c ON a.doc_cd = c.doc_cd AND a.doc_dept_cd = c.doc_dept_cd 
						     AND a.doc_id = c.doc_id AND a.doc_vers_no = c.doc_vers_no
						 JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id
	WHERE   action_flag='U'
	DISTRIBUTED BY (agreement_id);				 

	UPDATE history_all_agreement a
	SET	master_agreement_id = b.master_agreement_id,
		document_code_id = b.document_code_id,
		agency_history_id  = b.agency_history_id,
		document_id  = b.doc_id,
		document_version = b.doc_vers_no,
		tracking_number = b.trkg_no,
		record_date_id = b.record_date_id,
		budget_fiscal_year = b.doc_bfy,
		document_fiscal_year = b.doc_fy_dc,
		document_period = b.doc_per_dc,
		description = b.doc_dscr,
		actual_amount = b.doc_actu_am,
		obligated_amount = b.enc_am,
		maximum_contract_amount = b.max_cntrc_am,
		amendment_number = b.amend_no,
		replacing_agreement_id = b.replacing_agreement_id,
		replaced_by_agreement_id = b.replaced_by_agreement_id,
		award_status_id = b.award_status_id,
		procurement_id = b.prcu_id,
		procurement_type_id = b.procurement_type_id,
		effective_begin_date_id = b.effective_begin_date_id,
		effective_end_date_id = b.effective_end_date_id,
		reason_modification = b.reas_mod_dc,
		source_created_date_id = b.source_created_date_id,
		source_updated_date_id = b.source_updated_date_id,
		document_function_code_id = b.document_function_code_id,
		award_method_id = b.award_method_id,
		award_level_id = b.award_level_id,
		agreement_type_id = b.agreement_type_id,
		contract_class_code = b.ctcls_cd,
		award_category_id_1 = b.award_category_id_1,
		award_category_id_2 = b.award_category_id_2,
		award_category_id_3 = b.award_category_id_3,
		award_category_id_4 = b.award_category_id_4,
		award_category_id_5 = b.award_category_id_5,
		number_responses = b.resp_ct,
		location_service = b.loc_serv,
		location_zip = b.loc_zip,
		borough_code = b.brgh_cd,
		block_code = b.blck_cd,
		lot_code = b.lot_cd,
		council_district_code = b.coun_dist_cd,
		vendor_history_id = b.vendor_history_id,
		vendor_preference_level = b.vend_pref_lvl,
		original_contract_amount = b.orig_max_am,
		registered_date_id = b.registered_date_id,
		oca_number = b.oca_no,
		number_solicitation = b.out_of_no_so,
		document_name = b.doc_nm,
		original_term_begin_date_id = b.original_term_begin_date_id,
		original_term_end_date_id = b.original_term_end_date_id,
		privacy_flag = b.privacy_flag,
		load_id = b.load_id,		
		updated_date = b.updated_date
	FROM	tmp_con_ct_update b
	WHERE	a.agreement_id = b.agreement_id;
	
	/* Delete the existing agreement line items
	Rule is set up on all_agreement_accounting_line to delete from agreement_accounting_line
	Rule is set up on history_all_agreement_accounting_line to delete from history_agreement_accounting_line
	*/

	RAISE NOTICE 'CON 10';
	TRUNCATE tmp_ct_deletion;
	
	INSERT INTO tmp_ct_deletion
	SELECT  agreement_id
	FROM	tmp_ct_con
	WHERE	action_flag = 'U';
	
	DELETE FROM all_agreement_accounting_line WHERE agreement_id IN (SELECT agreement_id FROM tmp_ct_deletion);
		
	DELETE FROM history_all_agreement_accounting_line WHERE agreement_id IN (SELECT agreement_id FROM tmp_ct_deletion);
	
	
	/* Insert the agreement accounting lines.
	Accounting lines of the Latest version will be inserted into all_agreement_accounting_line.
	Accounting lines of the Latest version corresponding to public agreements will be inserted into all_agreement_accounting_line.
	Accounting lines of all the versions will be inserted into history_all_agreement_accounting_line.
	Accounting lines of all the versions of public agreements will be inserted into history_agreement_accounting_line.
	*/
	INSERT INTO all_agreement_accounting_line(agreement_id,line_number,
			event_type_id,description,line_amount,
			budget_fiscal_year,fiscal_year,fiscal_period,
			fund_class_id,agency_history_id,department_history_id,
			expenditure_object_history_id,revenue_source_id,location_code,
			budget_code_id,reporting_code,load_id,
			created_date)	
	SELECT  d.agreement_id,b.doc_actg_ln_no,
		b.event_type_id,b.actg_ln_dscr,b.ln_am,
		b.bfy,b.fy_dc,b.per_dc,
		b.fund_class_id,b.agency_history_id,b.department_history_id,
		b.expenditure_object_history_id,null as revenue_source_id,b.loc_cd,
		b.budget_code_id,b.rpt_cd,p_load_id_in,
		now()::timestamp
	FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_accounting_line b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
					     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
					     JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id
	WHERE   latest_flag='Y';		
					     
	INSERT INTO agreement_accounting_line
	SELECT a.*
	FROM   all_agreement_accounting_line a JOIN tmp_ct_con b ON a.agreement_id = b.agreement_id
	WHERE	privacy_flag = 'F';
	

	INSERT INTO history_all_agreement_accounting_line
	SELECT a.*
	FROM   all_agreement_accounting_line a JOIN tmp_ct_con b ON a.agreement_id = b.agreement_id
	WHERE	privacy_flag = 'F';
	
	INSERT INTO history_all_agreement_accounting_line(agreement_id,line_number,
			event_type_id,description,line_amount,
			budget_fiscal_year,fiscal_year,fiscal_period,
			fund_class_id,agency_history_id,department_history_id,
			expenditure_object_history_id,revenue_source_id,location_code,
			budget_code_id,reporting_code,load_id,
			created_date)	
	SELECT  d.agreement_id,b.doc_actg_ln_no,
		b.event_type_id,b.actg_ln_dscr,b.ln_am,
		b.bfy,b.fy_dc,b.per_dc,
		b.fund_class_id,b.agency_history_id,b.department_history_id,
		b.expenditure_object_history_id,null as revenue_source_id,b.loc_cd,
		b.budget_code_id,b.rpt_cd,p_load_id_in,
		now()::timestamp
	FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_accounting_line b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
					     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
					     JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id
	WHERE   latest_flag='N';
	
	INSERT INTO history_agreement_accounting_line
	SELECT a.*
	FROM   history_all_agreement_accounting_line a JOIN tmp_ct_con b ON a.agreement_id = b.agreement_id
	WHERE	privacy_flag = 'F';
	

	RAISE NOTICE 'CON 11';
	-- Capturing worksite information
	
	DELETE FROM all_agreement_worksite WHERE agreement_id IN (SELECT agreement_id FROM tmp_ct_deletion);
		
	DELETE FROM history_all_agreement_worksite WHERE agreement_id IN (SELECT agreement_id FROM tmp_ct_deletion);

	
	FOR l_array_ctr IN 1..array_upper(l_worksite_col_array,1) LOOP
	
		l_insert_sql := ' INSERT INTO all_agreement_worksite(agreement_id,worksite_id,percentage,amount,master_agreement_yn,load_id,created_date) '||
				' SELECT d.agreement_id,c.worksite_id,b.'|| l_worksite_per_array[l_array_ctr] || ',(a.max_cntrc_am *b.'||l_worksite_per_array[l_array_ctr] || ')/100 as amount ,''N'',' ||p_load_id_in || ', now()::timestamp '||
				' FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_award_detail b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd '||
				'			     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no '||
				'			     JOIN ref_worksite c ON b.' || l_worksite_col_array[l_array_ctr] || ' = c.worksite_code ' ||
				'			     JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id '||
				' WHERE latest_flag=''Y'' ';			     

		EXECUTE l_insert_sql;		
		
		l_insert_sql := ' INSERT INTO history_all_agreement_worksite(agreement_id,worksite_id,percentage,amount,master_agreement_yn,load_id,created_date) '||
				' SELECT d.agreement_id,c.worksite_id,b.'|| l_worksite_per_array[l_array_ctr] || ',(a.max_cntrc_am *b.'|| l_worksite_per_array[l_array_ctr] || ')/100 as amount ,''N'',' ||p_load_id_in || ', now()::timestamp '||
				' FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_award_detail b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd '||
				'			     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no '||
				'			     JOIN ref_worksite c ON b.' || l_worksite_col_array[l_array_ctr] || ' = c.worksite_code ' ||
				'			     JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id '||
				' WHERE latest_flag=''N'' ';	

		EXECUTE l_insert_sql;			
	END LOOP; 
	
	INSERT INTO agreement_worksite
	SELECT a.* 
	FROM 	all_agreement_worksite a JOIN tmp_ct_con b ON a.agreement_id = b.agreement_id
	WHERE	b.privacy_flag ='F';
	
	INSERT INTO history_all_agreement_worksite
	SELECT a.* 
	FROM 	all_agreement_worksite a JOIN tmp_ct_con b ON a.agreement_id = b.agreement_id;


	INSERT INTO history_agreement_worksite
	SELECT a.* 
	FROM 	history_all_agreement_worksite a JOIN tmp_ct_con b ON a.agreement_id = b.agreement_id
	WHERE	b.privacy_flag ='F';

	RAISE NOTICE 'CON 12';
	-- Capturing commodity

	DELETE FROM all_agreement_commodity WHERE agreement_id IN (SELECT agreement_id FROM tmp_ct_deletion);
		
	DELETE FROM history_all_agreement_commodity WHERE agreement_id IN (SELECT agreement_id FROM tmp_ct_deletion);
	
	INSERT INTO all_agreement_commodity(agreement_id,line_number,master_agreement_yn,
					    description,commodity_code,commodity_type_id,
					    quantity,unit_of_measurement,unit_price,
					    contract_amount,commodity_specification,load_id,
					    created_date)
	SELECT	d.agreement_id,b.doc_comm_ln_no,'N' as master_agreement_yn,
		b.cl_dscr,b.comm_cd,b.commodity_type_id,
		b.qty,b.unit_meas_cd,b.unit_price,
		b.cntrc_am,b.comm_cd_spfn,p_load_id_in,
		now()::timestamp
	FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_commodity b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
						     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
						     JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id
	WHERE   latest_flag='Y';	
	
	

	INSERT INTO agreement_commodity
	SELECT a.*
	FROM   all_agreement_commodity a JOIN tmp_ct_con b ON a.agreement_id = b.agreement_id
	WHERE	privacy_flag = 'F';
	

	INSERT INTO history_all_agreement_commodity
	SELECT a.*
	FROM   all_agreement_commodity a JOIN tmp_ct_con b ON a.agreement_id = b.agreement_id
	WHERE	privacy_flag = 'F';
	
	INSERT INTO history_all_agreement_commodity(agreement_id,line_number,master_agreement_yn,
					    description,commodity_code,commodity_type_id,
					    quantity,unit_of_measurement,unit_price,
					    contract_amount,commodity_specification,load_id,
					    created_date)
	SELECT	d.agreement_id,b.doc_comm_ln_no,'N' as master_agreement_yn,
		b.cl_dscr,b.comm_cd,b.commodity_type_id,
		b.qty,b.unit_meas_cd,b.unit_price,
		b.cntrc_am,b.comm_cd_spfn,p_load_id_in,
		now()::timestamp
	FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_commodity b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
						     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
						     JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id
	WHERE   latest_flag='N';	
	
	INSERT INTO history_agreement_commodity
	SELECT a.*
	FROM   history_all_agreement_commodity a JOIN tmp_ct_con b ON a.agreement_id = b.agreement_id
	WHERE	privacy_flag = 'F';	

	RAISE NOTICE 'CON 13';
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processCONGeneralContracts';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processCon(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_status int;
BEGIN
	
	l_status := etl.processCONGeneralContracts(p_load_file_id_in,p_load_id_in);
	
	IF l_status = 1 THEN 
		l_status := etl.processCONDeliveryOrders(p_load_file_id_in,p_load_id_in);
	ELSE 
		RETURN 0;
	END IF;	
	
	IF l_status = 1 THEN 
			l_status := etl.processCONPurchaseOrder(p_load_file_id_in,p_load_id_in);
		ELSE 
			RETURN 0;
	END IF;	
		
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processCon';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
	
END;
$$ language plpgsql;



