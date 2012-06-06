/*
Functions defined

	updateForeignKeysForCTInHeader
	updateForeignKeysForCTInAwardDetail
	associateMAGToCT
	updateForeignKeysForCTInAccLine
	processCONGeneralContracts
	processCon
	postProcessContracts

*/
set search_path=etl;

CREATE OR REPLACE FUNCTION updateForeignKeysForCTInHeader(p_load_file_id_in bigint,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_count smallint;
BEGIN
	/* UPDATING FOREIGN KEY VALUES	FOR THE HEADER RECORD*/		
	
	CREATE TEMPORARY TABLE tmp_fk_values (uniq_id bigint, document_code_id smallint,agency_history_id smallint,record_date_id int,
					      effective_begin_date_id int,effective_end_date_id int,source_created_date_id int,
					      source_updated_date_id int,registered_date_id int, original_term_begin_date_id int,
					      original_term_end_date_id int,registered_fiscal_year smallint,registered_fiscal_year_id smallint, registered_calendar_year smallint,
					      registered_calendar_year_id smallint,effective_begin_fiscal_year smallint,effective_begin_fiscal_year_id smallint, effective_begin_calendar_year smallint,
					      effective_begin_calendar_year_id smallint,effective_end_fiscal_year smallint,effective_end_fiscal_year_id smallint, effective_end_calendar_year smallint,
					      effective_end_calendar_year_id smallint,source_updated_fiscal_year smallint,source_updated_calendar_year smallint,source_updated_calendar_year_id smallint,
					      source_updated_fiscal_year_id smallint)
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
	
	CREATE TEMPORARY TABLE tmp_fk_values_new_agencies(dept_cd varchar,uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_new_agencies
	SELECT doc_dept_cd,MIN(b.uniq_id) as uniq_id
	FROM etl.stg_con_ct_header a join (SELECT uniq_id
						 FROM tmp_fk_values
						 GROUP BY 1
						 HAVING max(agency_history_id) is null) b on a.uniq_id=b.uniq_id
	GROUP BY 1;

	RAISE NOTICE '1';
	
	TRUNCATE etl.ref_agency_id_seq;
	
	INSERT INTO etl.ref_agency_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_new_agencies;
	
	INSERT INTO ref_agency(agency_id,agency_code,agency_name,created_date,created_load_id,original_agency_name)
	SELECT a.agency_id,b.dept_cd,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in,'<Unknown Agency>' as original_agency_name
	FROM   etl.ref_agency_id_seq a JOIN tmp_fk_values_new_agencies b ON a.uniq_id = b.uniq_id;

	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'C',l_count, 'New agency records inserted from general contracts header');
	END IF;
	
	RAISE NOTICE '1.1';

	-- Generate the agency history id for history records
	
	TRUNCATE etl.ref_agency_history_id_seq;
	
	INSERT INTO etl.ref_agency_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_new_agencies;

	INSERT INTO ref_agency_history(agency_history_id,agency_id,agency_name,created_date,load_id)
	SELECT a.agency_history_id,b.agency_id,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_history_id_seq a JOIN etl.ref_agency_id_seq b ON a.uniq_id = b.uniq_id;

	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'C',l_count, 'New agency history records inserted from general contracts header');
	END IF;
	
	RAISE NOTICE '1.3';
	INSERT INTO tmp_fk_values(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) 
	FROM etl.stg_con_ct_header a JOIN ref_agency b ON a.doc_dept_cd = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
		JOIN etl.ref_agency_history_id_seq d ON c.agency_history_id = d.agency_history_id
	GROUP BY 1	;	
			
	-- FK:record_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,record_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.doc_rec_dt_dc = b.date;
		
	--FK:effective_begin_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,effective_begin_date_id,effective_begin_fiscal_year,effective_begin_fiscal_year_id, effective_begin_calendar_year,effective_begin_calendar_year_id)
	SELECT	a.uniq_id, b.date_id,c.year_value,b.nyc_year_id,e.year_value,d.year_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.cntrct_strt_dt = b.date
		JOIN ref_year c ON b.nyc_year_id = c.year_id
		JOIN ref_month d ON b.calendar_month_id = d.month_id
		JOIN ref_year e ON d.year_id = e.year_id;
	
	--FK:effective_end_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,effective_end_date_id,effective_end_fiscal_year,effective_end_fiscal_year_id, effective_end_calendar_year,effective_end_calendar_year_id)
	SELECT	a.uniq_id, b.date_id,c.year_value,b.nyc_year_id,e.year_value,d.year_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.cntrct_end_dt = b.date
		JOIN ref_year c ON b.nyc_year_id = c.year_id
		JOIN ref_month d ON b.calendar_month_id = d.month_id
		JOIN ref_year e ON d.year_id = e.year_id;
	
	--FK:source_created_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,source_created_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.doc_appl_crea_dt = b.date;
	
	--FK:source_updated_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,source_updated_date_id,source_updated_fiscal_year,source_updated_fiscal_year_id, source_updated_calendar_year,source_updated_calendar_year_id)
	SELECT	a.uniq_id, b.date_id,c.year_value,b.nyc_year_id,e.year_value,d.year_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.doc_appl_last_dt = b.date
		JOIN ref_year c ON b.nyc_year_id = c.year_id
		JOIN ref_month d ON b.calendar_month_id = d.month_id
		JOIN ref_year e ON d.year_id = e.year_id;
	
	--FK:registered_date_id
	
	INSERT INTO tmp_fk_values(uniq_id,registered_date_id, registered_fiscal_year,registered_fiscal_year_id, registered_calendar_year,registered_calendar_year_id)
	SELECT	a.uniq_id, b.date_id,c.year_value,b.nyc_year_id,e.year_value,d.year_id
	FROM etl.stg_con_ct_header a JOIN ref_date b ON a.reg_dt = b.date
		JOIN ref_year c ON b.nyc_year_id = c.year_id
		JOIN ref_month d ON b.calendar_month_id = d.month_id
		JOIN ref_year e ON d.year_id = e.year_id;

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
		record_date_id = ct_table.record_date_id,
		effective_begin_date_id = ct_table.effective_begin_date_id,
		effective_end_date_id = ct_table.effective_end_date_id,
		source_created_date_id = ct_table.source_created_date_id,
		source_updated_date_id = ct_table.source_updated_date_id,
		registered_date_id = ct_table.registered_date_id, 
		original_term_begin_date_id = ct_table.original_term_begin_date_id,		
		original_term_end_date_id = ct_table.original_term_end_date_id,
		registered_fiscal_year = ct_table.registered_fiscal_year, 		
		registered_fiscal_year_id = ct_table.registered_fiscal_year_id,
		registered_calendar_year = ct_table.registered_calendar_year,
		registered_calendar_year_id = ct_table.registered_calendar_year_id,
		effective_begin_fiscal_year = ct_table.effective_begin_fiscal_year,
		effective_begin_fiscal_year_id = ct_table.effective_begin_fiscal_year_id,
		effective_begin_calendar_year = ct_table.effective_begin_calendar_year,
		effective_begin_calendar_year_id = ct_table.effective_begin_calendar_year_id,
		effective_end_fiscal_year = ct_table.effective_end_fiscal_year,
		effective_end_fiscal_year_id = ct_table.effective_end_fiscal_year_id,
		effective_end_calendar_year = ct_table.effective_end_calendar_year,
		effective_end_calendar_year_id = ct_table.effective_end_calendar_year_id,
		source_updated_fiscal_year = ct_table.source_updated_fiscal_year,
		source_updated_fiscal_year_id = ct_table.source_updated_fiscal_year_id,		
		source_updated_calendar_year = ct_table.source_updated_calendar_year,
		source_updated_calendar_year_id = ct_table.source_updated_calendar_year_id		
	FROM	(SELECT uniq_id, max(document_code_id) as document_code_id ,
				 max(agency_history_id) as agency_history_id,
				 max(record_date_id) as record_date_id,
				 max(effective_begin_date_id) as effective_begin_date_id,
				 max(effective_end_date_id) as effective_end_date_id,
				 max(source_created_date_id) as source_created_date_id,
				 max(source_updated_date_id) as source_updated_date_id,
				 max(registered_date_id) as registered_date_id, 
				 max(original_term_begin_date_id) as original_term_begin_date_id, 
				 max(original_term_end_date_id) as original_term_end_date_id,
				 max(registered_fiscal_year) as registered_fiscal_year, 
				 max(registered_fiscal_year_id) as registered_fiscal_year_id,
				 max(registered_calendar_year) as registered_calendar_year, 
				 max(registered_calendar_year_id) as registered_calendar_year_id,
				 max(effective_begin_fiscal_year) as effective_begin_fiscal_year, 
				 max(effective_begin_fiscal_year_id) as effective_begin_fiscal_year_id,
				 max(effective_begin_calendar_year) as effective_begin_calendar_year, 
				 max(effective_begin_calendar_year_id) as effective_begin_calendar_year_id,
				 max(effective_end_fiscal_year) as effective_end_fiscal_year, 
				 max(effective_end_fiscal_year_id) as effective_end_fiscal_year_id,
				 max(effective_end_calendar_year) as effective_end_calendar_year, 
				 max(effective_end_calendar_year_id) as effective_end_calendar_year_id,
				 max(source_updated_fiscal_year) as source_updated_fiscal_year,
				 max(source_updated_fiscal_year_id) as source_updated_fiscal_year_id,
				 max(source_updated_calendar_year) as source_updated_calendar_year, 
				 max(source_updated_calendar_year_id) as source_updated_calendar_year_id
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
	
	CREATE TEMPORARY TABLE tmp_fk_values_award_detail(uniq_id bigint,award_method_id smallint,agreement_type_id smallint,
						      		award_category_id_1 smallint,award_category_id_2 smallint, award_category_id_3 smallint, award_category_id_4 smallint,
					      			award_category_id_5 smallint)
	DISTRIBUTED BY (uniq_id);
	
	-- FK:award_method_id
	
	INSERT INTO tmp_fk_values_award_detail(uniq_id,award_method_id)
	SELECT a.uniq_id , b.award_method_id
	FROM	etl.stg_con_ct_award_detail a JOIN ref_award_method b ON a.awd_meth_cd = b.award_method_code;
	
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
		agreement_type_id = ct_table.agreement_type_id ,
		award_category_id_1 = ct_table.award_category_id_1 ,
		award_category_id_2 = ct_table.award_category_id_2 ,
		award_category_id_3 = ct_table.award_category_id_3 ,
		award_category_id_4 = ct_table.award_category_id_4 ,
		award_category_id_5 = ct_table.award_category_id_5 
	FROM	
		(SELECT uniq_id,
			max(award_method_id) as award_method_id ,
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
CREATE OR REPLACE FUNCTION associateMAGToCT(p_load_file_id_in bigint,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_worksite_col_array VARCHAR ARRAY[10];
	l_array_ctr smallint;
	l_fk_update int;
	l_count int;
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
	       b.master_agreement_id
	FROM tmp_ct_mag a JOIN history_master_agreement b ON a.mag_document_id = b.document_id 
		JOIN ref_document_code f ON a.mag_document_code = f.document_code AND b.document_code_id = f.document_code_id
		JOIN ref_agency e ON a.mag_agency_code = e.agency_code 
		JOIN ref_agency_history c ON b.agency_history_id = c.agency_history_id AND e.agency_id = c.agency_id
	WHERE b.original_version_flag='Y';	
			
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
	
	INSERT INTO history_master_agreement(master_agreement_id,document_code_id,agency_history_id,document_id,document_version,privacy_flag,created_load_id,created_date)
	SELECT  b.agreement_id, a.mag_document_code_id,a.mag_agency_history_id,a.mag_document_id,1 as document_version,'F' as privacy_flag,p_load_id_in,now()::timestamp
	FROM	tmp_new_ct_mag_con a JOIN etl.agreement_id_seq b ON a.uniq_id = b.uniq_id;	
		
	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'C',l_count, 'New MAG records inserted from general contracts');
	END IF;
	
	-- Updating the newly created MAG identifier.
	
	CREATE TEMPORARY TABLE tmp_new_ct_mag_con_2(uniq_id bigint,master_agreement_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_new_ct_mag_con_2
	SELECT a.uniq_id,d.agreement_id
	FROM   tmp_ct_mag a JOIN tmp_new_ct_mag_con b ON b.mag_document_code = a.mag_document_code
				     AND b.mag_agency_code = a.mag_agency_code
				     AND b.mag_document_id = a.mag_document_id
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

CREATE OR REPLACE FUNCTION etl.updateForeignKeysForCTInAccLine(p_load_file_id_in bigint,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_count integer;
BEGIN
	-- UPDATING FK VALUES IN ETL.STG_CON_CT_ACCOUNTING_LINE
	
	CREATE TEMPORARY TABLE tmp_fk_values_acc_line(uniq_id bigint,fund_class_id smallint,agency_history_id smallint,
							department_history_id int, expenditure_object_history_id integer,budget_code_id integer)
	DISTRIBUTED BY (uniq_id);

	
	-- FK:fund_class_id

	INSERT INTO tmp_fk_values_acc_line(uniq_id,fund_class_id)
	SELECT	a.uniq_id, b.fund_class_id
	FROM etl.stg_con_ct_accounting_line a JOIN ref_fund_class b ON COALESCE(a.fund_cd,'---') = b.fund_class_code;	

	CREATE TEMPORARY TABLE tmp_fk_values_acc_line_new_fund_class(fund_class_code varchar,uniq_id integer)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_acc_line_new_fund_class
	SELECT COALESCE(a.fund_cd,'---'),MIN(b.uniq_id) as uniq_id
	FROM etl.stg_con_ct_accounting_line a join (SELECT uniq_id
				    FROM tmp_fk_values_acc_line
				    GROUP BY 1
				    HAVING max(fund_class_id) is null) b on a.uniq_id=b.uniq_id
	GROUP BY 1;
	
	TRUNCATE etl.ref_fund_class_id_seq;
	
	INSERT INTO etl.ref_fund_class_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_acc_line_new_fund_class;
	
	INSERT INTO ref_fund_class(fund_class_id,fund_class_code,fund_class_name,created_date,created_load_id)
	SELECT a.fund_class_id,COALESCE(b.fund_class_code,'---'),(CASE WHEN COALESCE(b.fund_class_code,'') <> ''  THEN '<Unknown Fund Class>' 
							ELSE '<Non-Applicable Fund Class>' END) as fund_class_name,
				now()::timestamp,p_load_id_in
	FROM   etl.ref_fund_class_id_seq a JOIN tmp_fk_values_acc_line_new_fund_class b ON a.uniq_id = b.uniq_id;
	
	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN 
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'C',l_count, 'New fund class records inserted from general contracts accounting lines');	
	END IF;	
	
	-- FK:agency_history_id

	INSERT INTO tmp_fk_values_acc_line(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) 
	FROM etl.stg_con_ct_accounting_line a JOIN ref_agency b ON COALESCE(a.dept_cd,'---') = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1	;	

	CREATE TEMPORARY TABLE tmp_fk_values_acc_line_new_agencies(dept_cd varchar,uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_acc_line_new_agencies
	SELECT COALESCE(dept_cd,'---') as dept_cd ,MIN(b.uniq_id) as uniq_id
	FROM etl.stg_con_ct_accounting_line a join (SELECT uniq_id
						 FROM tmp_fk_values_acc_line
						 GROUP BY 1
						 HAVING max(agency_history_id) is null) b on a.uniq_id=b.uniq_id
	GROUP BY 1;
	
	TRUNCATE etl.ref_agency_id_seq;

	RAISE NOTICE '1.1';
	
	INSERT INTO etl.ref_agency_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_acc_line_new_agencies;
	
	INSERT INTO ref_agency(agency_id,agency_code,agency_name,created_date,created_load_id,original_agency_name)
	SELECT a.agency_id,COALESCE(b.dept_cd,'---'),(CASE WHEN COALESCE(b.dept_cd,'---')='---' THEN '<Non-Applicable Agency>' ELSE '<Unknown Agency>' END)as agency_name,
		now()::timestamp,p_load_id_in,'<Unknown Agency>' as original_agency_name
	FROM   etl.ref_agency_id_seq a JOIN tmp_fk_values_acc_line_new_agencies b ON a.uniq_id = b.uniq_id;

	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'C',l_count, 'New agency records inserted from general contracts accounting lines');
	END IF;
	
	RAISE NOTICE '1.2';
	
	-- Generate the agency history id for history records
	
	TRUNCATE etl.ref_agency_history_id_seq;
	
	INSERT INTO etl.ref_agency_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_acc_line_new_agencies;

	INSERT INTO ref_agency_history(agency_history_id,agency_id,agency_name,created_date,load_id)
	SELECT a.agency_history_id,b.agency_id,(CASE WHEN COALESCE(c.dept_cd,'---')='---' THEN '<Non-Applicable Agency>' ELSE '<Unknown Agency>' END),now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_history_id_seq a JOIN etl.ref_agency_id_seq b ON a.uniq_id = b.uniq_id
		 JOIN tmp_fk_values_acc_line_new_agencies c ON a.uniq_id = c.uniq_id;

	RAISE NOTICE '1.3';
	
	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'C',l_count, 'New agency history records inserted from general contracts accounting lines');
	END IF;
	
	INSERT INTO tmp_fk_values_acc_line(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) 
	FROM etl.stg_con_ct_accounting_line a JOIN ref_agency b ON COALESCE(a.dept_cd,'---') = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
		JOIN etl.ref_agency_history_id_seq d ON c.agency_history_id = d.agency_history_id
	GROUP BY 1	;	

	RAISE NOTICE '1.4';
	-- FK:department_history_id

	INSERT INTO tmp_fk_values_acc_line(uniq_id,department_history_id)
	SELECT	a.uniq_id, max(c.department_history_id) 
	FROM etl.stg_con_ct_accounting_line a JOIN ref_department b ON a.appr_cd = b.department_code AND a.fy_dc = b.fiscal_year
		JOIN ref_department_history c ON b.department_id = c.department_id
		JOIN ref_agency d ON a.dept_cd = d.agency_code AND b.agency_id = d.agency_id
		JOIN ref_fund_class e ON a.fund_cd = e.fund_class_code AND e.fund_class_id = b.fund_class_id
	GROUP BY 1	;		

	-- Generate the department id for new records

	CREATE TEMPORARY TABLE tmp_fk_values_acc_line_new_dept(agency_id integer,appr_cd varchar,
						fund_class_id smallint,fiscal_year smallint, uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_acc_line_new_dept
	SELECT c.agency_id,appr_cd,e.fund_class_id,fy_dc,MIN(b.uniq_id) as uniq_id
	FROM etl.stg_con_ct_accounting_line a join (SELECT uniq_id
						 FROM tmp_fk_values_acc_line
						 GROUP BY 1
						 HAVING max(department_history_id) IS NULL) b on a.uniq_id=b.uniq_id
		JOIN ref_agency c ON COALESCE(a.dept_cd,'---') = c.agency_code		
		JOIN ref_fund_class e ON COALESCE(a.fund_cd,'---') = e.fund_class_code
	GROUP BY 1,2,3,4;

	RAISE NOTICE '1.4';
							
		
	TRUNCATE etl.ref_department_id_seq;
	
	INSERT INTO etl.ref_department_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_acc_line_new_dept;

	INSERT INTO ref_department(department_id,department_code,
				   department_name,
				   agency_id,fund_class_id,
				   fiscal_year,created_date,created_load_id,original_department_name)
	SELECT a.department_id,COALESCE(b.appr_cd,'---------') as department_code,
		(CASE WHEN COALESCE(b.appr_cd,'') <> '' THEN '<Unknown Department>'
			ELSE 'Non-Applicable Department' END) as department_name,
		b.agency_id,b.fund_class_id,b.fiscal_year,
		now()::timestamp,p_load_id_in,
		(CASE WHEN COALESCE(b.appr_cd,'') <> '' THEN '<Unknown Department>'
			ELSE 'Non-Applicable Department' END) as original_department_name
	FROM   etl.ref_department_id_seq a JOIN tmp_fk_values_acc_line_new_dept b ON a.uniq_id = b.uniq_id;

	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'C',l_count, 'New department records inserted from general contracts accounting lines');
	END IF;
	
	RAISE NOTICE '1.5';
	-- Generate the department history id for history records
	
	TRUNCATE etl.ref_department_history_id_seq;
	
	INSERT INTO etl.ref_department_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_acc_line_new_dept;

	INSERT INTO ref_department_history(department_history_id,department_id,
					   department_name,agency_id,fund_class_id,
					   fiscal_year,created_date,load_id)
	SELECT a.department_history_id,c.department_id,	
		(CASE WHEN COALESCE(b.appr_cd,'') <> '' THEN '<Unknown Department>'
		      ELSE 'Non-Applicable Department' END) as department_name,
		b.agency_id,b.fund_class_id,b.fiscal_year,now()::timestamp,p_load_id_in
	FROM   etl.ref_department_history_id_seq a JOIN tmp_fk_values_acc_line_new_dept b ON a.uniq_id = b.uniq_id
		JOIN etl.ref_department_id_seq  c ON a.uniq_id = c.uniq_id ;

	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'C',l_count, 'New department history records inserted from general contracts accounting lines');
	END IF;

	RAISE NOTICE '1.6';
	
	INSERT INTO tmp_fk_values_acc_line(uniq_id,department_history_id)
	SELECT	a.uniq_id, max(c.department_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_department b  ON COALESCE(a.appr_cd,'---------') = b.department_code AND a.fy_dc = b.fiscal_year
		JOIN ref_department_history c ON b.department_id = c.department_id
		JOIN ref_agency d ON COALESCE(a.dept_cd,'---') = d.agency_code AND b.agency_id = d.agency_id
		JOIN ref_fund_class e ON COALESCE(a.fund_cd,'---') = e.fund_class_code AND e.fund_class_id = b.fund_class_id
		JOIN etl.ref_department_history_id_seq f ON c.department_history_id = f.department_history_id
	GROUP BY 1	;	

	RAISE NOTICE '1.7';
	

	-- FK:expenditure_object_history_id

	INSERT INTO tmp_fk_values_acc_line(uniq_id,expenditure_object_history_id)
	SELECT	a.uniq_id, max(c.expenditure_object_history_id) 
	FROM etl.stg_con_ct_accounting_line a JOIN ref_expenditure_object b ON COALESCE(a.obj_cd,'----') = b.expenditure_object_code AND a.fy_dc = b.fiscal_year
		JOIN ref_expenditure_object_history c ON b.expenditure_object_id = c.expenditure_object_id
	GROUP BY 1	;

	-- Generate the expenditure_object id for new records

	CREATE TEMPORARY TABLE tmp_fk_values_acc_line_new_exp_object(obj_cd varchar,fiscal_year smallint,uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_acc_line_new_exp_object
	SELECT COALESCE(a.obj_cd,'----') as obj_cd,fy_dc,MIN(a.uniq_id) as uniq_id
	FROM etl.stg_con_ct_accounting_line a join (SELECT uniq_id
						 FROM tmp_fk_values_acc_line
						 GROUP BY 1
						 HAVING max(expenditure_object_history_id) is null) b on a.uniq_id=b.uniq_id
	GROUP BY 1,2;	
		
	TRUNCATE etl.ref_expenditure_object_id_seq;
	
	INSERT INTO etl.ref_expenditure_object_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_acc_line_new_exp_object;

	RAISE NOTICE '1.9';
	
	INSERT INTO ref_expenditure_object(expenditure_object_id,expenditure_object_code,
		expenditure_object_name,fiscal_year,created_date,created_load_id,original_expenditure_object_name)
	SELECT a.expenditure_object_id,b.obj_cd,
		(CASE WHEN b.obj_cd <> '----' THEN '<Unknown Expenditure Object>'
			ELSE '<Non-Applicable Expenditure Object>' END) as expenditure_object_name,
		b.fiscal_year,now()::timestamp,p_load_id_in,
		(CASE WHEN b.obj_cd <> '----' THEN '<Unknown Expenditure Object>'
			ELSE '<Non-Applicable Expenditure Object>' END) as original_expenditure_object_name
	FROM   etl.ref_expenditure_object_id_seq a JOIN tmp_fk_values_acc_line_new_exp_object b ON a.uniq_id = b.uniq_id;

	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'C',l_count, 'New expenditure object records inserted from general contracts accounting lines');
	END IF;
	
	-- Generate the expenditure_object history id for history records
	
	TRUNCATE etl.ref_expenditure_object_history_id_seq;
	
	INSERT INTO etl.ref_expenditure_object_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_acc_line_new_exp_object;

	RAISE NOTICE '1.10';
	
	INSERT INTO ref_expenditure_object_history(expenditure_object_history_id,expenditure_object_id,fiscal_year,expenditure_object_name,created_date,load_id)
	SELECT a.expenditure_object_history_id,c.expenditure_object_id,b.fiscal_year,
		(CASE WHEN b.obj_cd <> '----' THEN '<Unknown Expenditure Object>'
			ELSE '<Non-Applicable Expenditure Object>' END) as expenditure_object_name,now()::timestamp,p_load_id_in
	FROM   etl.ref_expenditure_object_history_id_seq a JOIN tmp_fk_values_acc_line_new_exp_object b ON a.uniq_id = b.uniq_id
		JOIN etl.ref_expenditure_object_id_seq c ON a.uniq_id = c.uniq_id;

	GET DIAGNOSTICS l_count = ROW_COUNT;	

	IF l_count > 0 THEN
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
		VALUES(p_load_file_id_in,'C',l_count, 'New expenditure object history records inserted from general contracts accounting lines');
	END IF;

	RAISE NOTICE '1.11';
	
	INSERT INTO tmp_fk_values_acc_line(uniq_id,expenditure_object_history_id)
	SELECT	a.uniq_id, max(c.expenditure_object_history_id) 
	FROM etl.stg_con_ct_accounting_line a JOIN ref_expenditure_object b ON COALESCE(a.obj_cd,'----') = b.expenditure_object_code AND a.fy_dc = b.fiscal_year
		JOIN ref_expenditure_object_history c ON b.expenditure_object_id = c.expenditure_object_id
		JOIN etl.ref_expenditure_object_history_id_seq d ON c.expenditure_object_history_id = d.expenditure_object_history_id
	GROUP BY 1	;
	
	-- FK:budget_code_id

	INSERT INTO tmp_fk_values_acc_line(uniq_id,budget_code_id)
	SELECT	a.uniq_id, b.budget_code_id
	FROM etl.stg_con_ct_accounting_line a JOIN ref_budget_code b ON a.func_cd = b.budget_code AND a.fy_dc=b.fiscal_year
		JOIN ref_agency d ON a.dept_cd = d.agency_code AND b.agency_id = d.agency_id
		JOIN ref_fund_class e ON a.fund_cd = e.fund_class_code AND e.fund_class_id = b.fund_class_id;	

	RAISE NOTICE '1.12';	
	
	UPDATE etl.stg_con_ct_accounting_line a
	SET	fund_class_id =ct_table.fund_class_id ,
		agency_history_id =ct_table.agency_history_id ,
		department_history_id =ct_table.department_history_id ,
		expenditure_object_history_id =ct_table.expenditure_object_history_id ,
		budget_code_id=ct_table.budget_code_id 
	FROM	
		(SELECT uniq_id,			
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
	l_count int;
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
				      
	
	l_fk_update := etl.updateForeignKeysForCTInHeader(p_load_file_id_in,p_load_id_in);

	RAISE NOTICE 'CON 1';
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.updateForeignKeysForCTInAwardDetail();
	ELSE
		RETURN -1;
	END IF;

	RAISE NOTICE 'CON 2';
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.associateMAGToCT(p_load_file_id_in,p_load_id_in);
	ELSE
		RETURN -1;
	END IF;

	RAISE NOTICE 'CON 3';
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.processvendor(p_load_file_id_in,p_load_id_in,'CT1');
	ELSE
		RETURN -1;
	END IF;
	

	IF l_fk_update <> 1 THEN
		RETURN -1;
	END IF;
	
	RAISE NOTICE 'CON 4';
	
	IF l_fk_update = 1 THEN	 
		l_fk_update := etl.updateForeignKeysForCTInAccLine(p_load_file_id_in,p_load_id_in);	
	ELSE
		RETURN -1;
	END IF;

	RAISE NOTICE 'CON 5';

	
	/*
	1.Pull the key information such as document code, document id, document version etc for all agreements
	2. For the existing contracts gather details on max version in the transaction, staging tables..Determine if the staged agreement is latest version...
	3. Identify the new agreements. Determine the latest version for each of it.
	*/
	
	-- Inserting all records from staging header
	
	RAISE NOTICE 'CON 6';
	CREATE TEMPORARY TABLE tmp_ct_con(uniq_id bigint, agency_history_id smallint,doc_id varchar,agreement_id bigint, action_flag char(1), 
					  latest_flag char(1),doc_vers_no smallint,privacy_flag char(1),old_agreement_ids varchar)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_ct_con(uniq_id,agency_history_id,doc_id,doc_vers_no,privacy_flag,action_flag)
	SELECT uniq_id,agency_history_id,doc_id,doc_vers_no,'F' as privacy_flag,'I' as action_flag
	FROM etl.stg_con_ct_header;
	
	-- Identifying the versions of the agreements for update
	CREATE TEMPORARY TABLE tmp_old_ct_con(uniq_id bigint, agreement_id bigint);
	
	INSERT INTO tmp_old_ct_con
	SELECT  uniq_id,		
		b.agreement_id
	FROM etl.stg_con_ct_header a JOIN history_agreement b ON a.doc_id = b.document_id AND a.document_code_id = b.document_code_id AND a.doc_vers_no = b.document_version
		JOIN ref_agency_history c ON a.agency_history_id = c.agency_history_id
		JOIN ref_agency_history d ON b.agency_history_id = d.agency_history_id and c.agency_id = d.agency_id;				
	
	UPDATE tmp_ct_con a
	SET	agreement_id = b.agreement_id,
		action_flag = 'U'		
	FROM	tmp_old_ct_con b
	WHERE	a.uniq_id = b.uniq_id;

	RAISE NOTICE '1';
	
	-- Identifying the versions of the agreements for update
	
	INSERT INTO etl.agreement_id_seq
	SELECT uniq_id
	FROM	tmp_ct_con
	WHERE	action_flag ='I' 
		AND COALESCE(agreement_id,0) =0 ;

	UPDATE tmp_ct_con a
	SET	agreement_id = b.agreement_id	
	FROM	etl.agreement_id_seq b
	WHERE	a.uniq_id = b.uniq_id;	

	RAISE NOTICE '2';
	
	INSERT INTO history_agreement(agreement_id,master_agreement_id,document_code_id,
				agency_history_id,document_id,document_version,
				tracking_number,record_date_id,budget_fiscal_year,
				document_fiscal_year,document_period,description,
				actual_amount,obligated_amount,maximum_contract_amount,
				amendment_number,replacing_agreement_id,replaced_by_agreement_id,
				award_status_id,procurement_id,procurement_type_id,
				effective_begin_date_id,effective_end_date_id,reason_modification,
				source_created_date_id,source_updated_date_id,document_function_code,
				award_method_id,award_level_code,agreement_type_id,
				contract_class_code,award_category_id_1,award_category_id_2,
				award_category_id_3,award_category_id_4,award_category_id_5,
				number_responses,location_service,location_zip,
				borough_code,block_code,lot_code,
				council_district_code,vendor_history_id,vendor_preference_level,
				original_contract_amount,registered_date_id,oca_number,
				number_solicitation,document_name,original_term_begin_date_id,
				original_term_end_date_id,privacy_flag,created_load_id,created_date,
				registered_fiscal_year,registered_fiscal_year_id, registered_calendar_year,
				registered_calendar_year_id,effective_end_fiscal_year,effective_end_fiscal_year_id, 
				effective_end_calendar_year,effective_end_calendar_year_id,effective_begin_fiscal_year,
				effective_begin_fiscal_year_id, effective_begin_calendar_year,effective_begin_calendar_year_id,
		   		source_updated_fiscal_year,source_updated_fiscal_year_id, source_updated_calendar_year,
		   		source_updated_calendar_year_id,contract_number,brd_awd_no)
	SELECT	d.agreement_id,a.master_agreement_id,a.document_code_id,
		a.agency_history_id,a.doc_id,a.doc_vers_no,
		a.trkg_no,a.record_date_id,a.doc_bfy,
		a.doc_fy_dc,a.doc_per_dc,a.doc_dscr,
		a.doc_actu_am,a.enc_am,a.max_cntrc_am,
		a.amend_no,0 as replacing_agreement_id,0 as replaced_by_agreement_id,
		a.cntrc_sta,a.prcu_id,a.prcu_typ_id,
		a.effective_begin_date_id,a.effective_end_date_id,a.reas_mod_dc,
		a.source_created_date_id,a.source_updated_date_id,a.doc_func_cd,
		c.award_method_id,c.awd_lvl_cd,c.agreement_type_id,
		c.ctcls_cd,c.award_category_id_1,c.award_category_id_2,
		c.award_category_id_3,c.award_category_id_4,c.award_category_id_5,
		c.resp_ct,c.loc_serv,c.loc_zip,
		c.brgh_cd,c.blck_cd,c.lot_cd,
		c.coun_dist_cd,b.vendor_history_id,b.vend_pref_lvl,
		a.orig_max_am,a.registered_date_id,a.oca_no,
		c.out_of_no_so,a.doc_nm,a.original_term_begin_date_id,
		a.original_term_end_date_id,d.privacy_flag,p_load_id_in,now()::timestamp,
		registered_fiscal_year,registered_fiscal_year_id, registered_calendar_year,
		registered_calendar_year_id,effective_end_fiscal_year,effective_end_fiscal_year_id, 
		effective_end_calendar_year,effective_end_calendar_year_id,effective_begin_fiscal_year,
		effective_begin_fiscal_year_id, effective_begin_calendar_year,effective_begin_calendar_year_id,
		source_updated_fiscal_year,source_updated_fiscal_year_id, source_updated_calendar_year,
		source_updated_calendar_year_id,a.doc_cd||a.doc_dept_cd||a.doc_id as contract_number,a.brd_awd_no
	FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_vendor b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
					     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
					JOIN etl.stg_con_ct_award_detail c ON a.doc_cd = c.doc_cd AND a.doc_dept_cd = c.doc_dept_cd 
					     AND a.doc_id = c.doc_id AND a.doc_vers_no = c.doc_vers_no
					 JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id
	WHERE   action_flag='I';
	

	RAISE NOTICE '3';
	/* Updates */
	CREATE TEMPORARY TABLE tmp_con_ct_update AS
	SELECT d.agreement_id,a.master_agreement_id,a.document_code_id,
			a.agency_history_id,a.doc_id,a.doc_vers_no,
			a.trkg_no,a.record_date_id,a.doc_bfy,
			a.doc_fy_dc,a.doc_per_dc,a.doc_dscr,
			a.doc_actu_am,a.enc_am,a.max_cntrc_am,
			a.amend_no,0 as replacing_agreement_id,0 as replaced_by_agreement_id,
			a.cntrc_sta,a.prcu_id,a.prcu_typ_id,
			a.effective_begin_date_id,a.effective_end_date_id,a.reas_mod_dc,
			a.source_created_date_id,a.source_updated_date_id,a.doc_func_cd,
			c.award_method_id,c.awd_lvl_cd,c.agreement_type_id,
			c.ctcls_cd,c.award_category_id_1,c.award_category_id_2,
			c.award_category_id_3,c.award_category_id_4,c.award_category_id_5,
			c.resp_ct,c.loc_serv,c.loc_zip,
			c.brgh_cd,c.blck_cd,c.lot_cd,
			c.coun_dist_cd,b.vendor_history_id,b.vend_pref_lvl,
			a.orig_max_am,a.registered_date_id,a.oca_no,
			c.out_of_no_so,a.doc_nm,a.original_term_begin_date_id,
			a.original_term_end_date_id,d.privacy_flag,p_load_id_in as load_id,now()::timestamp as updated_date,
			registered_fiscal_year,registered_fiscal_year_id, registered_calendar_year,
			registered_calendar_year_id,effective_end_fiscal_year,effective_end_fiscal_year_id, 
			effective_end_calendar_year,effective_end_calendar_year_id,effective_begin_fiscal_year,
			effective_begin_fiscal_year_id, effective_begin_calendar_year,effective_begin_calendar_year_id,
			source_updated_fiscal_year,source_updated_fiscal_year_id, source_updated_calendar_year,
			source_updated_calendar_year_id,a.brd_awd_no			
		FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_vendor b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
						     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
						JOIN etl.stg_con_ct_award_detail c ON a.doc_cd = c.doc_cd AND a.doc_dept_cd = c.doc_dept_cd 
						     AND a.doc_id = c.doc_id AND a.doc_vers_no = c.doc_vers_no
						 JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id
	WHERE   action_flag='U'
	DISTRIBUTED BY (agreement_id);				 

	RAISE NOTICE '4';
	
	UPDATE history_agreement a
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
		award_status_id = b.cntrc_sta,
		procurement_id = b.prcu_id,
		procurement_type_id = b.prcu_typ_id,
		effective_begin_date_id = b.effective_begin_date_id,
		effective_end_date_id = b.effective_end_date_id,
		reason_modification = b.reas_mod_dc,
		source_created_date_id = b.source_created_date_id,
		source_updated_date_id = b.source_updated_date_id,
		document_function_code = b.doc_func_cd,
		award_method_id = b.award_method_id,
		award_level_code = b.awd_lvl_cd,
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
		updated_load_id = b.load_id,		
		updated_date = b.updated_date,
		registered_fiscal_year = b.registered_fiscal_year,
		registered_fiscal_year_id = b.registered_fiscal_year_id,
		registered_calendar_year = b.registered_calendar_year,
		registered_calendar_year_id = b.registered_calendar_year_id,
		effective_end_fiscal_year = b.effective_end_fiscal_year,
		effective_end_fiscal_year_id = b.effective_end_fiscal_year_id,
		effective_end_calendar_year = b.effective_end_calendar_year,
		effective_end_calendar_year_id = b.effective_end_calendar_year_id,
		effective_begin_fiscal_year = b.effective_begin_fiscal_year,
		effective_begin_fiscal_year_id = b.effective_begin_fiscal_year_id,
		effective_begin_calendar_year = b.effective_begin_calendar_year,
		effective_begin_calendar_year_id = b.effective_begin_calendar_year_id,
		source_updated_fiscal_year = b.source_updated_fiscal_year,
		source_updated_fiscal_year_id = b.source_updated_fiscal_year_id,
		source_updated_calendar_year = b.source_updated_calendar_year,
		source_updated_calendar_year_id = b.source_updated_calendar_year_id,
		brd_awd_no = b.brd_awd_no
	FROM	tmp_con_ct_update b
	WHERE	a.agreement_id = b.agreement_id;

	RAISE NOTICE '5';
	
	-- Agreement line changes
	
	INSERT INTO history_agreement_accounting_line(agreement_id,commodity_line_number,line_number,
			event_type_code,description,line_amount,
			budget_fiscal_year,fiscal_year,fiscal_period,
			fund_class_id,agency_history_id,department_history_id,
			expenditure_object_history_id,revenue_source_id,location_code,
			budget_code_id,reporting_code,created_load_id,
			created_date)	
	SELECT  d.agreement_id,b.doc_comm_ln_no,b.doc_actg_ln_no,
		b.evnt_typ_id,b.actg_ln_dscr,b.ln_am,
		b.bfy,b.fy_dc,b.per_dc,
		b.fund_class_id,b.agency_history_id,b.department_history_id,
		b.expenditure_object_history_id,null as revenue_source_id,b.loc_cd,
		b.budget_code_id,b.rpt_cd,p_load_id_in,
		now()::timestamp
	FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_accounting_line b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
					     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
					     JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id
	WHERE   action_flag = 'I';

	RAISE NOTICE '6';
	-- Identify the agreement accounting lines which need to be deleted/updated

	CREATE TEMPORARY TABLE tmp_acc_lines_actions(agreement_id bigint, commodity_line_number integer,line_number integer,action_flag char(1),uniq_id bigint)
	DISTRIBUTED BY (agreement_id);
	
	INSERT INTO tmp_acc_lines_actions
	SELECT  COALESCE(latest_tbl.agreement_id,old_tbl.agreement_id) as agreement_id,
		COALESCE(latest_tbl.doc_comm_ln_no, old_tbl.commodity_line_number) as commodity_line_number,
		COALESCE(latest_tbl.doc_actg_ln_no, old_tbl.line_number) as line_number,
		(CASE WHEN latest_tbl.agreement_id = old_tbl.agreement_id THEN 'U'
		      WHEN old_tbl.agreement_id IS NULL THEN 'I'
		      WHEN latest_tbl.agreement_id IS NULL THEN 'D' END) as action_flag	,
		      uniq_id
	FROM	      
		(SELECT a.agreement_id,c.doc_comm_ln_no,c.doc_actg_ln_no,c.uniq_id
		FROM   tmp_ct_con a JOIN etl.stg_con_ct_header b ON a.uniq_id = b.uniq_id
			JOIN etl.stg_con_ct_accounting_line c ON c.doc_cd = b.doc_cd AND c.doc_dept_cd = b.doc_dept_cd 
						     AND c.doc_id = b.doc_id AND c.doc_vers_no = b.doc_vers_no
		WHERE   a.action_flag ='U'
		order by 1,2,3 ) latest_tbl				     
		FULL OUTER JOIN (SELECT e.agreement_id,e.commodity_line_number,e.line_number 
			    FROM   history_agreement_accounting_line e JOIN tmp_ct_con f ON e.agreement_id = f.agreement_id ) old_tbl ON latest_tbl.agreement_id = old_tbl.agreement_id 
			    AND latest_tbl.doc_comm_ln_no = old_tbl.commodity_line_number AND latest_tbl.doc_actg_ln_no = old_tbl.line_number;

	RAISE NOTICE '7';
	
	INSERT INTO history_agreement_accounting_line(agreement_id,commodity_line_number,line_number,
			event_type_code,description,line_amount,
			budget_fiscal_year,fiscal_year,fiscal_period,
			fund_class_id,agency_history_id,department_history_id,
			expenditure_object_history_id,revenue_source_id,location_code,
			budget_code_id,reporting_code,created_load_id,
			created_date)	
	SELECT  d.agreement_id,b.doc_comm_ln_no,b.doc_actg_ln_no,
		b.evnt_typ_id,b.actg_ln_dscr,b.ln_am,
		b.bfy,b.fy_dc,b.per_dc,
		b.fund_class_id,b.agency_history_id,b.department_history_id,
		b.expenditure_object_history_id,null as revenue_source_id,b.loc_cd,
		b.budget_code_id,b.rpt_cd,p_load_id_in,
		now()::timestamp
	FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_accounting_line b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
					     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
					     JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id
					     JOIN tmp_acc_lines_actions e ON d.agreement_id = e.agreement_id AND b.doc_actg_ln_no = e.line_number AND b.doc_comm_ln_no = e.commodity_line_number
	WHERE   d.action_flag = 'U' AND e.action_flag='I';
	
	RAISE NOTICE '8';
	/* TO DO
	INSERT INTO deleted_agreement_accounting_line
	SELECT a.*,now()::timestamp, p_load_id_in as deleted_load_id
	FROM   history_agreement_accounting_line a JOIN tmp_acc_lines_actions b  ON a.agreement_id = b.agreement_id AND a.line_number = b.line_number
	WHERE	b.action_flag = 'D';
	*/
	RAISE NOTICE '9';
	
	DELETE FROM ONLY history_agreement_accounting_line a 
	USING tmp_acc_lines_actions b , tmp_ct_con c
	WHERE   a.agreement_id = b.agreement_id 
		AND a.commodity_line_number = b.commodity_line_number
		AND a.line_number = b.line_number
		AND a.agreement_id = c.agreement_id
		AND b.action_flag = 'D' AND c.action_flag='U';

	RAISE NOTICE '10';
	       
	UPDATE  history_agreement_accounting_line f
	SET     event_type_code = b.evnt_typ_id,
		description = b.actg_ln_dscr,
		line_amount = b.ln_am,
		budget_fiscal_year = b.bfy,
		fiscal_year = b.fy_dc,
		fiscal_period = b.per_dc,
		fund_class_id = b.fund_class_id,
		agency_history_id = b.agency_history_id,
		department_history_id =b.department_history_id,
		expenditure_object_history_id = b.expenditure_object_history_id,
		location_code = b.loc_cd,
		budget_code_id = b.budget_code_id,
		reporting_code = b.rpt_cd,
		updated_load_id = p_load_id_in,
		updated_date = now()::timestamp
	FROM   etl.stg_con_ct_header a, etl.stg_con_ct_accounting_line b,
		tmp_ct_con d,tmp_acc_lines_actions e			      	      
	WHERE  d.action_flag = 'U' AND e.action_flag='U'
	       AND a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
	       AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
	       AND a.uniq_id = d.uniq_id
	       AND d.agreement_id = e.agreement_id AND b.uniq_id = e.uniq_id
	       AND f.agreement_id = d.agreement_id AND f.line_number = e.line_number AND f.agreement_id = e.agreement_id AND f.commodity_line_number = e.commodity_line_number;	       

	RAISE NOTICE '11';
	
	DELETE FROM history_agreement_worksite a 
	USING tmp_ct_con b 
	WHERE a.agreement_id = b.agreement_id
	      AND b.action_flag ='U';
	      
	FOR l_array_ctr IN 1..array_upper(l_worksite_col_array,1) LOOP

		RAISE NOTICE 'asdasda %',l_worksite_col_array[l_array_ctr];
		
		l_insert_sql := ' INSERT INTO history_agreement_worksite(agreement_id,worksite_code,percentage,amount,master_agreement_yn,load_id,created_date) '||
				' SELECT d.agreement_id,b.'||l_worksite_col_array[l_array_ctr]||',b.'|| l_worksite_per_array[l_array_ctr] || ',(a.max_cntrc_am *b.'||l_worksite_per_array[l_array_ctr] || ')/100 as amount ,''N'',' ||p_load_id_in || ', now()::timestamp '||
				' FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_award_detail b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd '||
				'			     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no '||
				'			     JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id '||
				' WHERE b.'|| l_worksite_col_array[l_array_ctr] || ' IS NOT NULL' ;			     

		EXECUTE l_insert_sql;		

		GET DIAGNOSTICS l_count = ROW_COUNT;
		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,document_type,num_transactions,description)
		VALUES(p_load_file_id_in,'C','CT1,CTA1,CTA2',l_count,'# of records inserted in all_agreement_worksite ');
		
	END LOOP; 
		
	DELETE FROM history_agreement_commodity a 
	USING tmp_ct_con b 
	WHERE a.agreement_id = b.agreement_id
	      AND b.action_flag ='U';	

	INSERT INTO history_agreement_commodity(agreement_id,line_number,master_agreement_yn,
					    description,commodity_code,commodity_type_id,
					    quantity,unit_of_measurement,unit_price,
					    contract_amount,commodity_specification,load_id,
					    created_date)
	SELECT	d.agreement_id,b.doc_comm_ln_no,'N' as master_agreement_yn,
		b.cl_dscr,b.comm_cd,b.ln_typ,
		b.qty,b.unit_meas_cd,b.unit_price,
		b.cntrc_am,b.comm_cd_spfn,p_load_id_in,
		now()::timestamp
	FROM	etl.stg_con_ct_header a JOIN etl.stg_con_ct_commodity b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd 
						     AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
						     JOIN tmp_ct_con d ON a.uniq_id = d.uniq_id;
		

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


--------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.postProcessContracts(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
BEGIN
	/* Common for all types 
	Can be done once per etl
	*/
	
	-- Get the contracts (key elements only without version) which have been created or updated
	
	CREATE TEMPORARY TABLE tmp_loaded_agreements(document_id varchar,document_version integer,document_code_id smallint, agency_id smallint,
		latest_version_no smallint,first_version smallint );
	
	INSERT INTO tmp_loaded_agreements
	SELECT distinct document_id,document_version,document_code_id, agency_id
	FROM history_agreement a JOIN ref_agency_history b ON a.agency_history_id = b.agency_history_id
	WHERE a.created_load_id = p_load_id_in OR a.updated_load_id = p_load_id_in;
	
	-- Get the max version and min version
	
	CREATE TEMPORARY TABLE tmp_loaded_agreements_1(document_id varchar,document_code_id smallint, agency_id smallint,
		latest_version_no smallint,first_version_no smallint );
		
	INSERT INTO tmp_loaded_agreements_1
	SELECT a.document_id,a.document_code_id, c.agency_id, 
	       max(a.document_version) as latest_version_no, min(a.document_version) as first_version_no
	FROM history_agreement a JOIN tmp_loaded_agreements b ON a.document_id = b.document_id AND a.document_code_id = b.document_code_id
		JOIN ref_agency_history c ON a.agency_history_id = c.agency_history_id AND c.agency_id = b.agency_id
	GROUP BY 1,2,3;	
	
	-- Update the versions which are no more the first versions
	-- Might have to change the disbursements linkage here

	CREATE TEMPORARY TABLE tmp_agreement_flag_changes (document_id varchar,document_code_id smallint, agency_id smallint,
					latest_agreement_id bigint, first_agreement_id bigint,non_latest_agreement_id varchar, non_first_agreement_id varchar,
					latest_maximum_contract_amount numeric(16,2)
					);
					
	INSERT INTO tmp_agreement_flag_changes 				
	SELECT a.document_id,a.document_code_id, b.agency_id, 
		MAX(CASE WHEN a.document_version = b.latest_version_no THEN agreement_id END) as latest_agreement_id,
		MAX(CASE WHEN a.document_version = b.first_version_no THEN agreement_id END) as first_agreement_id,
		group_concat(CASE WHEN a.document_version <> b.latest_version_no THEN agreement_id ELSE 0 END) as non_latest_agreement_id,		
		group_concat(CASE WHEN a.document_version <> b.first_version_no THEN agreement_id ELSE 0 END) as non_first_agreement_id,
		MAX(CASE WHEN a.document_version = b.latest_version_no THEN maximum_contract_amount END) as latest_current_amount
	FROM   history_agreement a JOIN tmp_loaded_agreements_1 b ON a.document_id = b.document_id AND a.document_code_id = b.document_code_id
		JOIN ref_agency_history c ON a.agency_history_id = c.agency_history_id AND c.agency_id = b.agency_id	
	GROUP BY 1,2,3;	
	
	-- Updating the original flag for non first agreements 
	
	UPDATE history_agreement a 
	SET    original_version_flag = 'N',
		original_agreement_id = b.first_agreement_id
	FROM   (SELECT unnest(string_to_array(non_first_agreement_id,','))::int as agreement_id ,
		first_agreement_id
		FROM	tmp_agreement_flag_changes ) b
	WHERE  a.agreement_id = b.agreement_id;
		
	
	UPDATE history_agreement a 
	SET    latest_flag = 'N'
	FROM   (SELECT unnest(string_to_array(non_latest_agreement_id,','))::int as agreement_id 
		FROM	tmp_agreement_flag_changes ) b
	WHERE  a.agreement_id = b.agreement_id
		AND a.latest_flag = 'Y';	
	
	UPDATE history_agreement a 
	SET     original_version_flag = 'Y',
		original_agreement_id = b.first_agreement_id
	FROM    tmp_agreement_flag_changes  b
	WHERE  a.agreement_id = b.first_agreement_id;	
		
	
	UPDATE history_agreement a 
	SET    latest_flag = 'Y'
	FROM    tmp_agreement_flag_changes  b
	WHERE  a.agreement_id = b.latest_agreement_id
		AND COALESCE(a.latest_flag,'N') = 'N';	

	-- Associate Disbursement line item to the original version of the agreement
	
	CREATE TEMPORARY TABLE tmp_ct_fms_line_item(disbursement_line_item_id bigint, agreement_id bigint,maximum_contract_amount numeric(16,2))
	DISTRIBUTED BY (disbursement_line_item_id);
	
	INSERT INTO tmp_ct_fms_line_item
	SELECT disbursement_line_item_id, b.first_agreement_id
	FROM disbursement_line_item a JOIN  (SELECT unnest(string_to_array(non_first_agreement_id,','))::int as agreement_id ,
						    first_agreement_id,
						    latest_maximum_contract_amount
					     FROM   tmp_agreement_flag_changes ) b ON a.agreement_id = b.agreement_id;
		
	
	
	UPDATE disbursement_line_item a
	SET	agreement_id = b.agreement_id
	FROM	tmp_ct_fms_line_item b
	WHERE	a.disbursement_line_item_id = b.disbursement_line_item_id;
	
	UPDATE disbursement_line_item_details a
	SET	agreement_id = b.agreement_id,
		--updated_date = (CASE WHEN a.maximum_contract_amount <> b.maximum_contract_amount THEN now()::timestamp ELSE updated_date END),		
		maximum_contract_amount = b.maximum_contract_amount		
	FROM	tmp_ct_fms_line_item b
	WHERE	a.disbursement_line_item_id = b.disbursement_line_item_id;
	
	-- End of associating Disbursement line item to the original version of an agreement
	
	-- Populating the agreement_snapshot tables

	
	CREATE TEMPORARY TABLE tmp_agreement_snapshot(original_agreement_id bigint,starting_year smallint,starting_year_id smallint,document_version smallint,
						     master_agreement_id bigint,ending_year smallint, ending_year_id smallint ,rank_value smallint,agreement_id bigint,
						     effective_begin_fiscal_year smallint,effective_begin_fiscal_year_id smallint,effective_end_fiscal_year smallint,
						     effective_end_fiscal_year_id smallint,registered_fiscal_year smallint)
	DISTRIBUTED BY 	(original_agreement_id);				      
	
	-- Get the latest version for every year of modification
	
	INSERT INTO tmp_agreement_snapshot 		
	SELECT  b.original_agreement_id, b.source_updated_fiscal_year, b.source_updated_fiscal_year_id,
		max(b.document_version) as document_version,
		max(b.master_agreement_id) as master_agreement_id,
		lead(source_updated_fiscal_year) over (partition by original_agreement_id ORDER BY source_updated_fiscal_year),
		lead(source_updated_fiscal_year_id) over (partition by original_agreement_id ORDER BY source_updated_fiscal_year),
		rank() over (partition by original_agreement_id order by source_updated_fiscal_year ASC) as rank_value,
		NULL as agreement_id,
		max(effective_begin_fiscal_year) as effective_begin_fiscal_year,
		max(effective_begin_fiscal_year_id) as effective_begin_fiscal_year_id,
		max(effective_end_fiscal_year) as effective_end_fiscal_year,
		max(effective_end_fiscal_year_id) as effective_end_fiscal_year_id,
		NULL as registered_fiscal_year
	FROM	tmp_agreement_flag_changes a JOIN history_agreement b ON a.first_agreement_id = b.original_agreement_id
	GROUP  BY 1,2,3;

	-- Update the agreement id based on the version number and original agreeement if
	
	UPDATE tmp_agreement_snapshot a
	SET     agreement_id = b.agreement_id,
		registered_fiscal_year = b.registered_fiscal_year
	FROM	history_agreement b
	WHERE   a.original_agreement_id = b.original_agreement_id
		AND a.document_version = b.document_version;
		
	
	-- Updating the POP years from the latest version of the agreement
	UPDATE tmp_agreement_snapshot a
	SET	effective_begin_fiscal_year = b.effective_begin_fiscal_year,
		effective_begin_fiscal_year_id = b.effective_begin_fiscal_year_id,
		effective_end_fiscal_year = b.effective_end_fiscal_year,
		effective_end_fiscal_year_id = b.effective_end_fiscal_year_id
	FROM	history_agreement b
	WHERE   a.original_agreement_id = b.original_agreement_id
		AND b.latest_flag = 'Y';
				
	-- Update the starting year to 2010 for the very first record of an agreement in the snapshot if starting year >2010 and pop start year prior to 2010
	
	UPDATE 	tmp_agreement_snapshot
	SET	starting_year = 2010,
		starting_year_id = year_id
	FROM	ref_year 
	WHERE	year_value = 2010
		AND starting_year > 2010
		AND rank_value = 1
		AND registered_fiscal_year <= 2010;
		
	-- Updating the ending year to be ending year - 1 
	-- Until this step ending year of a record is equivalent to the staring year of the sucessor. So -1 should be done to ensure no overlapping
	
	UPDATE 	tmp_agreement_snapshot
	SET	ending_year = ending_year - 1,
		ending_year_id  = year_id
	FROM	ref_year 
	WHERE	year_value = ending_year - 1
		AND ending_year is not null;
	
	DELETE FROM ONLY agreement_snapshot a USING  tmp_agreement_snapshot b WHERE a.original_agreement_id = b.original_agreement_id;
	
	INSERT INTO agreement_snapshot(original_agreement_id, starting_year,starting_year_id,document_version,
				       agreement_id, ending_year,ending_year_id,contract_number,
				       original_contract_amount,maximum_contract_amount,description,
					vendor_history_id,vendor_id,vendor_name,
					dollar_difference,
					percent_difference,
					master_agreement_id, master_contract_number,agreement_type_id,
					agreement_type_name,award_category_id,award_category_name,
					expenditure_object_names,effective_begin_date,effective_begin_date_id,
					effective_end_date, effective_end_date_id,registered_date, 
					registered_date_id,brd_awd_no,tracking_number,
					registered_year, registered_year_id,latest_flag,original_version_flag,
					effective_begin_year,effective_begin_year_id,effective_end_year,effective_end_year_id,
					master_agreement_yn)
	SELECT 	a.original_agreement_id, a.starting_year,a.starting_year_id,a.document_version,
	        a.agreement_id, (CASE WHEN a.ending_year IS NOT NULL THEN ending_year 
	        		      WHEN b.effective_end_fiscal_year < a.starting_year THEN a.starting_year
	        		      ELSE b.effective_end_fiscal_year END),
	        		(CASE WHEN a.ending_year IS NOT NULL THEN ending_year_id 
	        		      WHEN b.effective_end_fiscal_year < a.starting_year THEN a.starting_year_id
	        		      ELSE b.effective_end_fiscal_year_id END),b.contract_number,
	        b.original_contract_amount,b.maximum_contract_amount,b.description,
		b.vendor_history_id,c.vendor_id, COALESCE(c.legal_name,c.alias_name),
		b.maximum_contract_amount - b.original_contract_amount,
		(CASE WHEN b.original_contract_amount = 0 THEN 0 ELSE ROUND(((b.maximum_contract_amount - b.original_contract_amount) * 100 )::decimal / b.original_contract_amount,2) END) as percentage,
		b.master_agreement_id,d.contract_number,e.agreement_type_id,
		e.agreement_type_name,f.award_category_id, f.award_category_name,
		g.expenditure_object_names,h.date as effective_begin_date, h.date_id as effective_begin_date_id,
		i.date as effective_end_date, i.date_id as effective_end_date_id,j.date as registered_date, 
		j.date_id as registered_date_id,b.brd_awd_no,b.tracking_number,
		b.registered_fiscal_year, registered_fiscal_year_id,b.latest_flag,b.original_version_flag,
		a.effective_begin_fiscal_year,a.effective_begin_fiscal_year_id,a.effective_end_fiscal_year,a.effective_end_fiscal_year_id,
		'N' as master_agreement_yn
	FROM	tmp_agreement_snapshot a JOIN history_agreement b ON a.agreement_id = b.agreement_id 
		LEFT JOIN vendor_history c ON b.vendor_history_id = c.vendor_history_id
		LEFT JOIN history_master_agreement d ON b.master_agreement_id = d.master_agreement_id	
		LEFT JOIN ref_agreement_type e ON b.agreement_type_id = e.agreement_type_id
		LEFT JOIN ref_award_category f ON b.award_category_id_1 = f.award_category_id
		LEFT JOIN (SELECT z.agreement_id, GROUP_CONCAT(distinct expenditure_object_name) as expenditure_object_names
			   FROM history_agreement_accounting_line z JOIN ref_expenditure_object_history y ON z.expenditure_object_history_id = y.expenditure_object_history_id 
			   JOIN tmp_agreement_snapshot x ON x.agreement_id = z.agreement_id
			   GROUP BY 1) g ON a.agreement_id = g.agreement_id
		LEFT JOIN ref_date h ON h.date_id = b.effective_begin_date_id
		LEFT JOIN ref_date i ON i.date_id = b.effective_end_date_id
		LEFT JOIN ref_date j ON j.date_id = b.registered_date_id;

		RETURN 1;
					
	/* End of one time changes */
	
	-- Populating the agreement_snapshot tables related to the calendar year			      

	-- Get the latest version for every year of modification

	TRUNCATE tmp_agreement_snapshot;
	
	INSERT INTO tmp_agreement_snapshot 		
	SELECT  b.original_agreement_id, b.source_updated_calendar_year, b.source_updated_calendar_year_id,
		max(b.document_version) as document_version,
		max(b.master_agreement_id) as master_agreement_id,
		lead(source_updated_calendar_year) over (partition by original_agreement_id ORDER BY source_updated_calendar_year),
		lead(source_updated_calendar_year_id) over (partition by original_agreement_id ORDER BY source_updated_calendar_year),
		rank() over (partition by original_agreement_id order by source_updated_calendar_year ASC) as rank_value,
		NULL as agreement_id,
		max(effective_begin_calendar_year) as effective_begin_fiscal_year,
		max(effective_begin_calendar_year_id) as effective_begin_fiscal_year_id,
		max(effective_end_calendar_year) as effective_end_fiscal_year,
		max(effective_end_calendar_year_id) as effective_end_fiscal_year_id,
		NULL as registered_fiscal_year
	FROM	tmp_agreement_flag_changes a JOIN history_agreement b ON a.first_agreement_id = b.original_agreement_id
	GROUP  BY 1,2,3;

	-- Update the agreement id based on the version number and original agreeement if

	UPDATE tmp_agreement_snapshot a
	SET     agreement_id = b.agreement_id,
		registered_fiscal_year = b.registered_calendar_year
	FROM	history_agreement b
	WHERE   a.original_agreement_id = b.original_agreement_id
		AND a.document_version = b.document_version;


	-- Updating the POP years from the latest version of the agreement
	UPDATE tmp_agreement_snapshot a
	SET	effective_begin_fiscal_year = b.effective_begin_calendar_year,
		effective_begin_fiscal_year_id = b.effective_begin_calendar_year_id,
		effective_end_fiscal_year = b.effective_end_calendar_year,
		effective_end_fiscal_year_id = b.effective_end_calendar_year_id
	FROM	history_agreement b
	WHERE   a.original_agreement_id = b.original_agreement_id
		AND b.latest_flag = 'Y';

	-- Update the starting year to 2010 for the very first record of an agreement in the snapshot if starting year >2010 and pop start year prior to 2010

	UPDATE 	tmp_agreement_snapshot
	SET	starting_year = 2010,
		starting_year_id = year_id
	FROM	ref_year 
	WHERE	year_value = 2010
		AND starting_year > 2010
		AND rank_value = 1
		AND registered_calendar_year <= 2010;

	-- Updating the ending year to be ending year - 1 
	-- Until this step ending year of a record is equivalent to the staring year of the sucessor. So -1 should be done to ensure no overlapping

	UPDATE 	tmp_agreement_snapshot
	SET	ending_year = ending_year - 1,
		ending_year_id  = year_id
	FROM	ref_year 
	WHERE	year_value = ending_year - 1
		AND ending_year is not null;

	DELETE FROM ONLY agreement_snapshot_cy a USING  tmp_agreement_snapshot b WHERE a.original_agreement_id = b.original_agreement_id;

	INSERT INTO agreement_snapshot_cy(original_agreement_id, starting_year,starting_year_id,document_version,
				       agreement_id, ending_year,ending_year_id,contract_number,
				       original_contract_amount,maximum_contract_amount,description,
					vendor_history_id,vendor_id,vendor_name,
					dollar_difference,
					percent_difference,
					master_agreement_id, master_contract_number,agreement_type_id,
					agreement_type_name,award_category_id,award_category_name,
					expenditure_object_names,effective_begin_date,effective_begin_date_id,
					effective_end_date, effective_end_date_id,registered_date, 
					registered_date_id,brd_awd_no,tracking_number,
					registered_year, registered_year_id,latest_flag,original_version_flag,
					effective_begin_year,effective_begin_year_id,effective_end_year,effective_end_year_id,
					master_agreement_yn)
	SELECT 	a.original_agreement_id, a.starting_year,a.starting_year_id,a.document_version,
		a.agreement_id, (CASE WHEN a.ending_year IS NOT NULL THEN ending_year 
				      WHEN b.effective_end_calendar_year < a.starting_year THEN a.starting_year
				      ELSE b.effective_end_calendar_year END),
				(CASE WHEN a.ending_year IS NOT NULL THEN ending_year_id 
				      WHEN b.effective_end_calendar_year < a.starting_year THEN a.starting_year_id
				      ELSE b.effective_end_calendar_year_id END),b.contract_number,
		b.original_contract_amount,b.maximum_contract_amount,b.description,
		b.vendor_history_id,c.vendor_id, COALESCE(c.legal_name,c.alias_name),
		b.maximum_contract_amount - b.original_contract_amount,
		(CASE WHEN b.original_contract_amount = 0 THEN 0 ELSE ROUND(((b.maximum_contract_amount - b.original_contract_amount) * 100 )::decimal / b.original_contract_amount,2) END) as percentage,
		b.master_agreement_id,d.contract_number,e.agreement_type_id,
		e.agreement_type_name,f.award_category_id, f.award_category_name,
		g.expenditure_object_names,h.date as effective_begin_date, h.date_id as effective_begin_date_id,
		i.date as effective_end_date, i.date_id as effective_end_date_id,j.date as registered_date, 
		j.date_id as registered_date_id,b.brd_awd_no,b.tracking_number,
		b.registered_calendar_year, registered_calendar_year_id,b.latest_flag,b.original_version_flag,
		a.effective_begin_fiscal_year,a.effective_begin_fiscal_year_id,a.effective_end_fiscal_year,a.effective_end_fiscal_year_id,
		'N' as master_agreement_yn
	FROM	tmp_agreement_snapshot a JOIN history_agreement b ON a.agreement_id = b.agreement_id 
		LEFT JOIN vendor_history c ON b.vendor_history_id = c.vendor_history_id
		LEFT JOIN history_master_agreement d ON b.master_agreement_id = d.master_agreement_id	
		LEFT JOIN ref_agreement_type e ON b.agreement_type_id = e.agreement_type_id
		LEFT JOIN ref_award_category f ON b.award_category_id_1 = f.award_category_id
		LEFT JOIN (SELECT z.agreement_id, GROUP_CONCAT(distinct expenditure_object_name) as expenditure_object_names
			   FROM history_agreement_accounting_line z JOIN ref_expenditure_object_history y ON z.expenditure_object_history_id = y.expenditure_object_history_id 
			   JOIN tmp_agreement_snapshot x ON x.agreement_id = z.agreement_id
			   GROUP BY 1) g ON a.agreement_id = g.agreement_id
		LEFT JOIN ref_date h ON h.date_id = b.effective_begin_date_id
		LEFT JOIN ref_date i ON i.date_id = b.effective_end_date_id
		LEFT JOIN ref_date j ON j.date_id = b.registered_date_id;

			RETURN 1;
						
	/* End of one time changes */
	

EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in postProcessContracts';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
	
END;
$$ language plpgsql;