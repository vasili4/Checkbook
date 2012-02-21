set search_path=public;
/* Functions defined
	updateForeignKeysForFMSInHeader
	updateForeignKeysForFMSVendors
	updateForeignKeysForFMSInAccLine
	changeVisibilityOfAgreements
	changeVisibilityOfVendor
	refreshFactsForFMS
	processFMS
*/
CREATE OR REPLACE FUNCTION etl.updateForeignKeysForFMSInHeader(p_load_id_in bigint) RETURNS INT AS $$
DECLARE
BEGIN
	/* UPDATING FOREIGN KEY VALUES	FOR THE HEADER RECORD*/		
	
	CREATE TEMPORARY TABLE tmp_fk_fms_values (uniq_id bigint, document_code_id smallint,agency_history_id smallint,record_date_id smallint,
						check_eft_issued_date_id smallint,check_eft_record_date_id smallint, expenditure_status_id smallint,
						expenditure_cancel_type_id smallint, expenditure_cancel_reason_id smallint)
	DISTRIBUTED BY (uniq_id);
	
	-- FK:Document_Code_id
	
	INSERT INTO tmp_fk_fms_values(uniq_id,document_code_id)
	SELECT	a.uniq_id, b.document_code_id
	FROM etl.stg_fms_header a JOIN ref_document_code b ON a.doc_cd = b.document_code;
	
	-- FK:Agency_history_id
	
	INSERT INTO tmp_fk_fms_values(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) as agency_history_id
	FROM etl.stg_fms_header a JOIN ref_agency b ON a.doc_dept_cd = b.agency_code
		 JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1;
	
	CREATE TEMPORARY TABLE tmp_fk_fms_values_new_agencies(dept_cd varchar,uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_fms_values_new_agencies
	SELECT doc_dept_cd,MIN(b.uniq_id) as uniq_id
	FROM etl.stg_fms_header a join (SELECT uniq_id
						 FROM tmp_fk_fms_values
						 GROUP BY 1
						 HAVING max(agency_history_id) is null) b on a.uniq_id=b.uniq_id
	GROUP BY 1;

	RAISE NOTICE '1';
	
	TRUNCATE etl.ref_agency_id_seq;
	
	INSERT INTO etl.ref_agency_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_fms_values_new_agencies;
	
	INSERT INTO ref_agency(agency_id,agency_code,agency_name,created_date,created_load_id,original_agency_name)
	SELECT a.agency_id,b.dept_cd,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in,'<Unknown Agency>' as original_agency_name
	FROM   etl.ref_agency_id_seq a JOIN tmp_fk_fms_values_new_agencies b ON a.uniq_id = b.uniq_id;

	RAISE NOTICE '1.1';

	-- Generate the agency history id for history records
	
	TRUNCATE etl.ref_agency_history_id_seq;
	
	INSERT INTO etl.ref_agency_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_fms_values_new_agencies;

	INSERT INTO ref_agency_history(agency_history_id,agency_id,agency_name,created_date,load_id)
	SELECT a.agency_history_id,b.agency_id,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_history_id_seq a JOIN etl.ref_agency_id_seq b ON a.uniq_id = b.uniq_id;

	RAISE NOTICE '1.3';
	INSERT INTO tmp_fk_fms_values(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) 
	FROM etl.stg_fms_header a JOIN ref_agency b ON a.doc_dept_cd = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
		JOIN etl.ref_agency_history_id_seq d ON c.agency_history_id = d.agency_history_id
	GROUP BY 1	;	
	
	-- FK:record_date_id
	
	INSERT INTO tmp_fk_fms_values(uniq_id,record_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_fms_header a JOIN ref_date b ON a.doc_rec_dt_dc = b.date;
	
	-- FK:check_eft_issued_date_id
	
	INSERT INTO tmp_fk_fms_values(uniq_id,check_eft_issued_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_fms_header a JOIN ref_date b ON a.chk_eft_iss_dt = b.date;
	
	-- FK:check_eft_record_date_id
	
	INSERT INTO tmp_fk_fms_values(uniq_id,check_eft_record_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_fms_header a JOIN ref_date b ON a.chk_eft_rec_dt = b.date;
	
	-- FK:expenditure_status_id
	
	INSERT INTO tmp_fk_fms_values(uniq_id,expenditure_status_id)
	SELECT	a.uniq_id, b.expenditure_status_id
	FROM etl.stg_fms_header a JOIN ref_expenditure_status b ON a.chk_eft_sta = b.expenditure_status_id;
	
	
	-- FK:expenditure_cancel_type_id
	
	INSERT INTO tmp_fk_fms_values(uniq_id,expenditure_cancel_type_id)
	SELECT	a.uniq_id, b.expenditure_cancel_type_id
	FROM etl.stg_fms_header a JOIN ref_expenditure_cancel_type b ON a.can_typ_cd = b.expenditure_cancel_type_id;
	
	-- FK:expenditure_cancel_reason_id
	
	INSERT INTO tmp_fk_fms_values(uniq_id,expenditure_cancel_reason_id)
	SELECT	a.uniq_id, b.expenditure_cancel_reason_id
	FROM etl.stg_fms_header a JOIN ref_expenditure_cancel_reason b ON a.can_reas_cd_dc = b.expenditure_cancel_reason_id;

	raise notice '1';
		
	UPDATE etl.stg_fms_header a
	SET	document_code_id = ct_table.document_code_id ,
		agency_history_id = ct_table.agency_history_id,		
		record_date_id = ct_table.record_date_id,
		check_eft_issued_date_id = ct_table.check_eft_issued_date_id, 
		check_eft_record_date_id = ct_table.check_eft_record_date_id,
		expenditure_status_id = ct_table.expenditure_status_id,
		expenditure_cancel_type_id = ct_table.expenditure_cancel_type_id,
		expenditure_cancel_reason_id = ct_table.expenditure_cancel_reason_id
	FROM	(SELECT uniq_id, max(document_code_id) as document_code_id ,
				 max(agency_history_id) as agency_history_id,max(record_date_id) as record_date_id,
				 max(check_eft_issued_date_id) as check_eft_issued_date_id, max(check_eft_record_date_id) as check_eft_record_date_id,
				 max(expenditure_status_id) as expenditure_status_id, max(expenditure_cancel_type_id) as expenditure_cancel_type_id,
				max(expenditure_cancel_reason_id) as expenditure_cancel_reason_id
		 FROM	tmp_fk_fms_values
		 GROUP BY 1) ct_table
	WHERE	a.uniq_id = ct_table.uniq_id;	
	
	
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in updateForeignKeysForFMSInHeader';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

---------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.updateForeignKeysForFMSVendors(p_load_id_in bigint) RETURNS INT AS $$
DECLARE

BEGIN

	-- UPDATING FK VALUES IN VENDOR

	CREATE TEMPORARY TABLE tmp_fk_fms_values_vendor(uniq_id bigint,vendor_customer_code varchar, vendor_history_id integer,miscellaneous_vendor_flag bit,
				lgl_nm varchar,alias_nm varchar )
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_fms_values_vendor
	SELECT uniq_id,a.vend_cust_cd,MAX(c.vendor_history_id) as vendor_history_id,COALESCE(b.miscellaneous_vendor_flag,0::bit),
		MIN(a.lgl_nm),MIN(a.alias_nm)
	FROM	etl.stg_fms_vendor a LEFT JOIN vendor b ON a.vend_cust_cd = b.vendor_customer_code	
			LEFT JOIN vendor_history c ON b.vendor_id=c.vendor_id
	WHERE b.miscellaneous_vendor_flag = 0::bit OR b.miscellaneous_vendor_flag IS NULL	
	GROUP BY 1,2,4;

	INSERT INTO tmp_fk_fms_values_vendor
	SELECT uniq_id,a.vend_cust_cd,NULL as vendor_history_id,1::bit,
		a.lgl_nm,a.alias_nm
	FROM	etl.stg_fms_vendor a LEFT JOIN vendor b ON a.vend_cust_cd = b.vendor_customer_code
	WHERE  b.miscellaneous_vendor_flag = 1::bit;
	
	RAISE NOTICE 'Vend 1';
	
	-- Identify the new vendors
	
	CREATE TEMPORARY TABLE tmp_fms_vendor_new(uniq_id bigint, vendor_customer_code varchar)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fms_vendor_new
	SELECT min(uniq_id) as uniq_id, vendor_customer_code
	FROM	tmp_fk_fms_values_vendor
	WHERE   vendor_history_id IS NULL AND miscellaneous_vendor_flag = 0::bit
	GROUP BY 2;
	
	INSERT INTO tmp_fms_vendor_new
	SELECT  uniq_id as uniq_id, vendor_customer_code
	FROM	tmp_fk_fms_values_vendor
	WHERE   vendor_history_id IS NULL AND miscellaneous_vendor_flag = 1::bit;

	RAISE NOTICE 'Vend 1.1';
	
	TRUNCATE etl.vendor_id_seq;
	
	INSERT INTO etl.vendor_id_seq(uniq_id)
	SELECT uniq_id
	FROM tmp_fms_vendor_new;

	INSERT INTO vendor(vendor_id,vendor_customer_code,legal_name,alias_name,miscellaneous_vendor_flag,load_id,created_date)
	SELECT  a.vendor_id,b.vendor_customer_code,b.lgl_nm,b.alias_nm,b.miscellaneous_vendor_flag, p_load_id_in,now()::timestamp
	FROM	etl.vendor_id_seq a JOIN tmp_fk_fms_values_vendor b ON a.uniq_id = b.uniq_id;

	RAISE NOTICE 'Vend 1.3';
	
	TRUNCATE etl.vendor_history_id_seq;
	
	INSERT INTO etl.vendor_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM tmp_fms_vendor_new;


	INSERT INTO vendor_history(vendor_history_id,vendor_id,legal_name,alias_name,miscellaneous_vendor_flag,load_id,created_date)
	SELECT  a.vendor_history_id,c.vendor_id,b.lgl_nm,b.alias_nm,b.miscellaneous_vendor_flag, p_load_id_in,now()::timestamp
	FROM	etl.vendor_history_id_seq a JOIN tmp_fk_fms_values_vendor b ON a.uniq_id = b.uniq_id
		JOIN etl.vendor_id_seq c ON a.uniq_id = c.uniq_id;

	RAISE NOTICE 'Vend 1.4';
	
	CREATE TEMPORARY TABLE tmp_fms_vendor(uniq_id bigint,vendor_history_id int)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fms_vendor
	SELECT c.uniq_id, d.vendor_history_id
	FROM tmp_fk_fms_values_vendor a JOIN tmp_fms_vendor_new b ON a.uniq_id = b.uniq_id AND a.miscellaneous_vendor_flag=0::bit
		JOIN tmp_fk_fms_values_vendor c ON a.vendor_customer_code = c.vendor_customer_code
		JOIN etl.vendor_history_id_seq d ON b.uniq_id = d.uniq_id;

	INSERT INTO tmp_fms_vendor
	SELECT a.uniq_id, d.vendor_history_id
	FROM tmp_fk_fms_values_vendor a JOIN tmp_fms_vendor_new b ON a.uniq_id = b.uniq_id AND a.miscellaneous_vendor_flag=1::bit		
		JOIN etl.vendor_history_id_seq d ON b.uniq_id = d.uniq_id;
			
	
	UPDATE tmp_fk_fms_values_vendor a
	SET	vendor_history_id = b.vendor_history_id
	FROM	tmp_fms_vendor b 
	WHERE	a.uniq_id = b.uniq_id;
					
	RAISE NOTICE 'Vend 1.5';
	
	UPDATE etl.stg_fms_vendor a
	SET	vendor_history_id = b.vendor_history_id
	FROM	tmp_fk_fms_values_vendor b 
	WHERE	a.uniq_id = b.uniq_id;
	
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in updateForeignKeysForFMSVendors';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;
------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION etl.updateForeignKeysForFMSInAccLine(p_load_id_in bigint) RETURNS INT AS $$
DECLARE
BEGIN
	-- UPDATING FK VALUES IN ETL.STG_FMS_ACCOUNTING_LINE
	
	CREATE TEMPORARY TABLE tmp_fk_values_fms_acc_line(uniq_id bigint,fund_class_id smallint,agency_history_id smallint,
							department_history_id int, expenditure_object_history_id integer,budget_code_id integer,
							fund_id smallint, location_history_id int, masked_agency_history_id smallint, masked_department_history_id int)
	DISTRIBUTED BY (uniq_id);
		
	-- FK:fund_class_id

	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,fund_class_id)
	SELECT	a.uniq_id, b.fund_class_id
	FROM etl.stg_fms_accounting_line a JOIN ref_fund_class b ON a.fcls_cd = b.fund_class_code;	

	-- FK:agency_history_id

	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_agency b ON a.dept_cd = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1	;	

	RAISE NOTICE '1';
	
	CREATE TEMPORARY TABLE tmp_fk_values_fms_acc_line_new_agencies(dept_cd varchar,uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_fms_acc_line_new_agencies
	SELECT dept_cd,MIN(b.uniq_id) as uniq_id
	FROM etl.stg_fms_accounting_line a join (SELECT uniq_id
						 FROM tmp_fk_values_fms_acc_line
						 GROUP BY 1
						 HAVING max(agency_history_id) is null) b on a.uniq_id=b.uniq_id
	GROUP BY 1;
	
	TRUNCATE etl.ref_agency_id_seq;

	RAISE NOTICE '1.1';
	
	INSERT INTO etl.ref_agency_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_fms_acc_line_new_agencies;
	
	INSERT INTO ref_agency(agency_id,agency_code,agency_name,created_date,created_load_id,original_agency_name)
	SELECT a.agency_id,b.dept_cd,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in,'<Unknown Agency>' as original_agency_name
	FROM   etl.ref_agency_id_seq a JOIN tmp_fk_values_fms_acc_line_new_agencies b ON a.uniq_id = b.uniq_id;

	RAISE NOTICE '1.2';
	
	-- Generate the agency history id for history records
	
	TRUNCATE etl.ref_agency_history_id_seq;
	
	INSERT INTO etl.ref_agency_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_fms_acc_line_new_agencies;

	INSERT INTO ref_agency_history(agency_history_id,agency_id,agency_name,created_date,load_id)
	SELECT a.agency_history_id,b.agency_id,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_history_id_seq a JOIN etl.ref_agency_id_seq b ON a.uniq_id = b.uniq_id;

	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_agency b ON a.dept_cd = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
		JOIN etl.ref_agency_history_id_seq d ON c.agency_history_id = d.agency_history_id
	GROUP BY 1	;	

	RAISE NOTICE '1.3';
	
	-- FK:department_history_id

	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,department_history_id)
	SELECT	a.uniq_id, max(c.department_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_department b ON a.appr_cd = b.department_code AND a.fy_dc = b.fiscal_year
		JOIN ref_department_history c ON b.department_id = c.department_id
		JOIN ref_agency d ON a.dept_cd = d.agency_code AND b.agency_id = d.agency_id
		JOIN ref_fund_class e ON a.fcls_cd = e.fund_class_code AND e.fund_class_id = b.fund_class_id
	GROUP BY 1;
	
	CREATE TEMPORARY TABLE tmp_fk_values_fms_acc_line_new_dept(agency_history_id integer,agency_id integer,appr_cd varchar,
						fund_class_id smallint,fiscal_year smallint, uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_fms_acc_line_new_dept
	SELECT d.agency_history_id,c.agency_id,appr_cd,e.fund_class_id,fy_dc,MIN(b.uniq_id) as uniq_id
	FROM etl.stg_fms_accounting_line a join (SELECT uniq_id
						 FROM tmp_fk_values_fms_acc_line
						 GROUP BY 1
						 HAVING max(department_history_id) IS NULL) b on a.uniq_id=b.uniq_id
		JOIN ref_agency c ON a.dept_cd = c.agency_code
		JOIN ref_agency_history d ON c.agency_id = d.agency_id
		JOIN ref_fund_class e ON a.fcls_cd = e.fund_class_code
	GROUP BY 1,2,3,4,5;

	RAISE NOTICE '1.4';
						
	-- Generate the department id for new records
		
	TRUNCATE etl.ref_department_id_seq;
	
	INSERT INTO etl.ref_department_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_fms_acc_line_new_dept;

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
	FROM   etl.ref_department_id_seq a JOIN tmp_fk_values_fms_acc_line_new_dept b ON a.uniq_id = b.uniq_id;

	RAISE NOTICE '1.5';
	-- Generate the department history id for history records
	
	TRUNCATE etl.ref_department_history_id_seq;
	
	INSERT INTO etl.ref_department_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_fms_acc_line_new_dept;

	INSERT INTO ref_department_history(department_history_id,department_id,
					   department_name,agency_id,fund_class_id,
					   fiscal_year,created_date,load_id)
	SELECT a.department_history_id,c.department_id,	
		(CASE WHEN COALESCE(b.appr_cd,'') <> '' THEN '<Unknown Department>'
		      ELSE 'Non-Applicable Department' END) as department_name,
		b.agency_id,b.fund_class_id,b.fiscal_year,now()::timestamp,p_load_id_in
	FROM   etl.ref_department_history_id_seq a JOIN tmp_fk_values_fms_acc_line_new_dept b ON a.uniq_id = b.uniq_id
		JOIN etl.ref_department_id_seq  c ON a.uniq_id = c.uniq_id ;


	RAISE NOTICE '1.6';
	
	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,department_history_id)
	SELECT	a.uniq_id, max(c.department_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_department b  ON a.appr_cd = b.department_code AND a.fy_dc = b.fiscal_year
		JOIN ref_department_history c ON b.department_id = c.department_id
		JOIN ref_agency d ON a.dept_cd = d.agency_code AND b.agency_id = d.agency_id
		JOIN ref_fund_class e ON a.fcls_cd = e.fund_class_code AND e.fund_class_id = b.fund_class_id
		JOIN etl.ref_department_history_id_seq f ON c.department_history_id = f.department_history_id
	GROUP BY 1	;	

	RAISE NOTICE '1.7';
	
	-- FK:expenditure_object_history_id

	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,expenditure_object_history_id)
	SELECT	a.uniq_id, max(c.expenditure_object_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_expenditure_object b ON a.obj_cd = b.expenditure_object_code AND a.fy_dc = b.fiscal_year
		JOIN ref_expenditure_object_history c ON b.expenditure_object_id = c.expenditure_object_id
	GROUP BY 1	;


	RAISE NOTICE '1.8';
	
	CREATE TEMPORARY TABLE tmp_fk_values_fms_acc_line_new_exp_object(obj_cd varchar,fiscal_year smallint,uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_fms_acc_line_new_exp_object
	SELECT (CASE WHEN COALESCE(obj_cd,'')='' THEN '----' ELSE obj_cd END) as obj_cd,fy_dc,MIN(a.uniq_id) as uniq_id
	FROM etl.stg_fms_accounting_line a join (SELECT uniq_id
						 FROM tmp_fk_values_fms_acc_line
						 GROUP BY 1
						 HAVING max(expenditure_object_history_id) is null) b on a.uniq_id=b.uniq_id
	GROUP BY 1,2;

	-- Generate the expenditure_object id for new records
		
	TRUNCATE etl.ref_expenditure_object_id_seq;
	
	INSERT INTO etl.ref_expenditure_object_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_fms_acc_line_new_exp_object;

	RAISE NOTICE '1.9';
	
	INSERT INTO ref_expenditure_object(expenditure_object_id,expenditure_object_code,
		expenditure_object_name,fiscal_year,created_date,created_load_id,original_expenditure_object_name)
	SELECT a.expenditure_object_id,b.obj_cd,
		(CASE WHEN b.obj_cd <> '----' THEN '<Unknown Expenditure Object>'
			ELSE '<Non-Applicable Expenditure Object>' END) as expenditure_object_name,
		b.fiscal_year,now()::timestamp,p_load_id_in,
		(CASE WHEN b.obj_cd <> '----' THEN '<Unknown Expenditure Object>'
			ELSE '<Non-Applicable Expenditure Object>' END) as original_expenditure_object_name
	FROM   etl.ref_expenditure_object_id_seq a JOIN tmp_fk_values_fms_acc_line_new_exp_object b ON a.uniq_id = b.uniq_id;

	-- Generate the expenditure_object history id for history records
	
	TRUNCATE etl.ref_expenditure_object_history_id_seq;
	
	INSERT INTO etl.ref_expenditure_object_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_fms_acc_line_new_exp_object;

	RAISE NOTICE '1.10';
	
	INSERT INTO ref_expenditure_object_history(expenditure_object_history_id,expenditure_object_id,fiscal_year,expenditure_object_name,created_date,load_id)
	SELECT a.expenditure_object_history_id,c.expenditure_object_id,b.fiscal_year,
		(CASE WHEN b.obj_cd <> '----' THEN '<Unknown Expenditure Object>'
			ELSE '<Non-Applicable Expenditure Object>' END) as expenditure_object_name,now()::timestamp,p_load_id_in
	FROM   etl.ref_expenditure_object_history_id_seq a JOIN tmp_fk_values_fms_acc_line_new_exp_object b ON a.uniq_id = b.uniq_id
		JOIN etl.ref_expenditure_object_id_seq c ON a.uniq_id = c.uniq_id;

	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,expenditure_object_history_id)
	SELECT	a.uniq_id, max(c.expenditure_object_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_expenditure_object b ON (COALESCE(a.obj_cd,'----') = b.expenditure_object_code 
										OR (a.obj_cd='' AND b.expenditure_object_code='----')
									     ) 
									     AND a.fy_dc = b.fiscal_year
		JOIN ref_expenditure_object_history c ON b.expenditure_object_id = c.expenditure_object_id
		JOIN etl.ref_expenditure_object_history_id_seq d ON c.expenditure_object_history_id = d.expenditure_object_history_id
	GROUP BY 1	;
		
	-- FK:budget_code_id

	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,budget_code_id)
	SELECT	a.uniq_id, b.budget_code_id
	FROM etl.stg_fms_accounting_line a JOIN ref_budget_code b ON a.func_cd = b.budget_code AND a.fy_dc=b.fiscal_year
		JOIN ref_agency d ON a.dept_cd = d.agency_code AND b.agency_id = d.agency_id
		JOIN ref_fund_class e ON a.fcls_cd = e.fund_class_code AND e.fund_class_id = b.fund_class_id;	
		
	-- FK:fund_id

	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,fund_id)
	SELECT	a.uniq_id, b.fund_id
	FROM etl.stg_fms_accounting_line a JOIN ref_fund b ON a.fund_cd = b.fund_code;	
		
	-- FK:location_history_id

	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,location_history_id)
	SELECT	a.uniq_id, max(c.location_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_location b ON a.loc_cd = b.location_code
		JOIN ref_location_history c ON b.location_id = c.location_id
		JOIN ref_agency d ON a.dept_cd = d.agency_code AND b.agency_id = d.agency_id
	GROUP BY 1	;	
	
	CREATE TEMPORARY TABLE tmp_fk_values_fms_acc_line_new_loc(loc_cd varchar,agency_history_id integer,agency_id integer, fiscal_year smallint,uniq_id bigint)
	DISTRIBUTED BY (uniq_id);

	INSERT INTO tmp_fk_values_fms_acc_line_new_loc
	SELECT (CASE WHEN COALESCE(loc_cd,'') ='' THEN '----' ELSE loc_cd END) as loc_cd,
		d.agency_history_id,c.agency_id,a.fy_dc,min(b.uniq_id)
	FROM etl.stg_fms_accounting_line a join (SELECT uniq_id
						 FROM tmp_fk_values_fms_acc_line
						 GROUP BY 1
						 HAVING max(location_history_id) is null) b on a.uniq_id=b.uniq_id
	     JOIN ref_agency c ON a.dept_cd = c.agency_code
	     JOIN ref_agency_history d ON c.agency_id = d.agency_id					 
	GROUP BY 1,2,3,4;
	
	-- Generate the location id for new records
		
	TRUNCATE etl.ref_location_id_seq;
	
	INSERT INTO etl.ref_location_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_fms_acc_line_new_loc;

	INSERT INTO ref_location(location_id,location_code,location_name,agency_id,created_date,created_load_id,original_location_name)
	SELECT a.location_id,b.loc_cd,(CASE WHEN COALESCE(b.loc_cd,'') <> '' THEN '<Unknown Location>'
			ELSE 'Non-Applicable Location' END) as location_name,b.agency_id,now()::timestamp,p_load_id_in,
			(CASE WHEN COALESCE(b.loc_cd,'') <> '' THEN '<Unknown Location>'
			ELSE 'Non-Applicable Location' END) as original_location_name
	FROM   etl.ref_location_id_seq a JOIN tmp_fk_values_fms_acc_line_new_loc b ON a.uniq_id = b.uniq_id;
	

	RAISE NOTICE '1.5';
	-- Generate the location history id for history records
	
	TRUNCATE etl.ref_location_history_id_seq;
	
	INSERT INTO etl.ref_location_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_fms_acc_line_new_loc;

	INSERT INTO ref_location_history(location_history_id,location_id,location_name,
					 created_date,load_id)
	SELECT a.location_history_id,c.location_id,	
		(CASE WHEN COALESCE(b.loc_cd,'') <> '' THEN '<Unknown Location>'
			ELSE 'Non-Applicable Location' END) as location_name,
		now()::timestamp,p_load_id_in
	FROM   etl.ref_location_history_id_seq a JOIN tmp_fk_values_fms_acc_line_new_loc b ON a.uniq_id = b.uniq_id
		JOIN etl.ref_location_id_seq  c ON a.uniq_id = c.uniq_id ;


	RAISE NOTICE '1.6';
	
	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,location_history_id)
	SELECT	a.uniq_id, max(c.location_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_location b ON COALESCE(a.loc_cd,'----') = b.location_code OR (a.loc_cd ='' AND b.location_code='----')
		JOIN ref_location_history c ON b.location_id = c.location_id
		JOIN ref_agency d ON a.dept_cd = d.agency_code AND b.agency_id = d.agency_id
		JOIN etl.ref_location_history_id_seq f ON c.location_history_id = f.location_history_id
	GROUP BY 1	;		

	-- FK:masked_agency_history_id
	-- If dept_cd is 096 in stg_fms_accounting_line, public_agency_id is updated to the one corresponding to 069.	
	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,masked_agency_history_id)
	SELECT	a.uniq_id, d.agency_history_id 
	FROM etl.stg_fms_accounting_line a CROSS JOIN (SELECT max(agency_history_id)  as agency_history_id
						 FROM ref_agency b JOIN ref_agency_history c ON b.agency_id = c.agency_id
						 WHERE b.agency_code='069') d
	WHERE	a.dept_cd='096';
	
	-- FK:masked_agency_history_id	
	-- If dept_cd is 098 in stg_fms_accounting_line and associated to an agreement with the department code as 015 
	-- i.e. rqporf_doc_dept_cd as 015, public_agency_id is updated to the one corresponding to 015.
	
	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,masked_agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id)
	FROM etl.stg_fms_accounting_line a JOIN ref_agency b ON a.rqporf_doc_dept_cd = b.agency_code 
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	WHERE	a.rqporf_doc_dept_cd='015' AND a.dept_cd ='098'
	GROUP BY 1;
	
	-- FK:masked_agency_history_id
	-- If dept_cd is 098 and obj_cd is 4000/ 4140/ 6000/ 6130/ 6150/ 6220/ 6650/ 6710/ 6780/ 6810/ 6820/ 6830/ 6860, 
	-- public_agency_id will be set to the one corresponding to rqporf_doc_dept_cd.
	
	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,masked_agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_agency b ON  a.rqporf_doc_dept_cd = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	WHERE	a.dept_cd ='098'
		AND a.obj_cd IN ('4000','4140','6000','6130','6150','6220','6650','6710','6780','6810','6820','6830','6860') 
	GROUP BY 1;


	-- FK:masked_department_history_id
	-- Getting the appropriate appropriation unit for the masked agency
	
	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,masked_department_history_id)
	SELECT	a.uniq_id, max(c.department_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_department b ON a.appr_cd = b.department_code AND a.fy_dc = b.fiscal_year
		JOIN ref_department_history c ON b.department_id = c.department_id
		JOIN ref_agency d ON b.agency_id = d.agency_id
		JOIN ref_fund_class e ON a.fcls_cd = e.fund_class_code AND e.fund_class_id = b.fund_class_id
	WHERE	a.dept_cd='096'
		AND d.agency_code='069'		
	GROUP BY 1;		

	--FK:masked_department_history_id
	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,masked_department_history_id)
	SELECT	a.uniq_id, max(c.department_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_department b ON a.appr_cd = b.department_code AND a.fy_dc = b.fiscal_year
		JOIN ref_department_history c ON b.department_id = c.department_id
		JOIN ref_agency d ON b.agency_id = d.agency_id
		JOIN ref_fund_class e ON a.fcls_cd = e.fund_class_code AND e.fund_class_id = b.fund_class_id
		JOIN etl.stg_fms_header f ON  a.doc_cd = f.doc_cd AND a.doc_dept_cd = f.doc_dept_cd
					AND a.doc_id = f.doc_id AND a.doc_vers_no = f.doc_vers_no
	WHERE	a.rqporf_doc_dept_cd='015' AND a.dept_cd ='098'
		AND d.agency_code='015'
	GROUP BY 1;

	--FK:masked_department_history_id
	INSERT INTO tmp_fk_values_fms_acc_line(uniq_id,masked_department_history_id)
	SELECT	a.uniq_id, max(c.department_history_id) 
	FROM etl.stg_fms_accounting_line a JOIN ref_department b ON a.appr_cd = b.department_code AND a.fy_dc = b.fiscal_year
		JOIN ref_department_history c ON b.department_id = c.department_id
		JOIN ref_agency d ON b.agency_id = d.agency_id
		JOIN ref_fund_class e ON a.fcls_cd = e.fund_class_code AND e.fund_class_id = b.fund_class_id
		JOIN etl.stg_fms_header f ON  a.doc_cd = f.doc_cd AND a.doc_dept_cd = f.doc_dept_cd
					AND a.doc_id = f.doc_id AND a.doc_vers_no = f.doc_vers_no
	WHERE	a.dept_cd ='098'
		AND a.obj_cd IN ('4000','4140','6000','6130','6150','6220','6650','6710','6780','6810','6820','6830','6860') 
		AND d.agency_code=a.rqporf_doc_dept_cd
	GROUP BY 1;
	
	UPDATE etl.stg_fms_accounting_line a
	SET	fund_class_id =ct_table.fund_class_id ,
		agency_history_id =ct_table.agency_history_id ,
		department_history_id =ct_table.department_history_id ,
		expenditure_object_history_id =ct_table.expenditure_object_history_id ,
		budget_code_id=ct_table.budget_code_id,
		fund_id = ct_table.fund_id,
		location_history_id = ct_table.location_history_id,
		masked_agency_history_id = ct_table.masked_agency_history_id,
		masked_department_history_id = ct_table.masked_department_history_id
	FROM	
		(SELECT uniq_id,
			max(fund_class_id )as fund_class_id ,
			max(agency_history_id )as agency_history_id ,
			max(department_history_id )as department_history_id ,
			max(expenditure_object_history_id )as expenditure_object_history_id ,
			max(budget_code_id) as budget_code_id ,
			max(fund_id) as fund_id ,
			max(location_history_id) as location_history_id,
			max(masked_agency_history_id) as masked_agency_history_id,
			max(masked_department_history_id) as masked_department_history_id
		FROM	tmp_fk_values_fms_acc_line
		GROUP	BY 1) ct_table
	WHERE	a.uniq_id = ct_table.uniq_id;	

	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in updateForeignKeysForFMSInAccLine';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;
---------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION etl.associateCONToFMS(p_privacy_flag_in char(1)) RETURNS INT AS $$
DECLARE
	l_worksite_col_array VARCHAR ARRAY[10];
	l_array_ctr smallint;
	l_fk_update int;
BEGIN
						  
	-- Fetch all the contracts associated with MAG
	
	CREATE TEMPORARY TABLE tmp_ct_fms(uniq_id bigint, agreement_id bigint,con_document_id varchar, 
				con_agency_history_id smallint, con_document_code_id smallint, con_document_code varchar, con_agency_code varchar )	
	DISTRIBUTED BY(uniq_id);
	
	INSERT INTO tmp_ct_fms
	SELECT uniq_id, 0 as agreement_id,
	       max(rqporf_doc_id),
	       max(d.agency_history_id) as mag_agency_history_id,
	       max(c.document_code_id),
	       max(c.document_code),
	       max(b.agency_code)
	FROM	etl.stg_fms_accounting_line a JOIN ref_agency b ON a.rqporf_doc_dept_cd = b.agency_code
		JOIN ref_document_code c ON a.rqporf_doc_cd = c.document_code
		JOIN ref_agency_history d ON b.agency_id = d.agency_id
	GROUP BY 1,2;		
		
	
	-- Identify the agreement/CON Id
	
	CREATE TEMPORARY TABLE tmp_old_ct_fms_con(uniq_id bigint,agreement_id bigint, action_flag char(1), latest_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_old_ct_fms_con
	SELECT uniq_id,
	       agreement_id	
	FROM	
		(SELECT  uniq_id,		
			 b.document_version as mag_document_version,
			 b.agreement_id,
			 rank()over(partition by uniq_id order by b.document_version desc) as rank_value
		FROM tmp_ct_fms a JOIN history_all_agreement b ON a.con_document_id = b.document_id 
			JOIN ref_document_code f ON a.con_document_code = f.document_code AND b.document_code_id = f.document_code_id
			JOIN ref_agency e ON a.con_agency_code = e.agency_code 
			JOIN ref_agency_history c ON b.agency_history_id = c.agency_history_id AND e.agency_id = c.agency_id			
		) inner_tbl
	WHERE	rank_value = 1;	
	
	UPDATE tmp_ct_fms a
	SET	agreement_id = b.agreement_id
	FROM	tmp_old_ct_fms_con b
	WHERE	a.uniq_id = b.uniq_id;
	
	-- Delete from agreement, history_agreement if the agreements are associated to Partial/Not to be displayed disbursements.
	
	IF p_privacy_flag_IN IN ('P','X') THEN
		CREATE TEMPORARY TABLE tmp_con_fms_deletion(agreement_id bigint)
		DISTRIBUTED BY (agreement_id);
		
		INSERT INTO tmp_con_fms_deletion
		SELECT agreement_id
		FROM   tmp_ct_fms;
		
		DELETE FROM agreement WHERE agreement_id IN (SELECT agreement_id FROM tmp_con_fms_deletion);
		DELETE FROM agreement_accounting_line WHERE agreement_id IN (SELECT agreement_id FROM tmp_con_fms_deletion);
		DELETE FROM agreement_commodity WHERE agreement_id IN (SELECT agreement_id FROM tmp_con_fms_deletion);
		DELETE FROM agreement_worksite WHERE agreement_id IN (SELECT agreement_id FROM tmp_con_fms_deletion);

		DELETE FROM history_agreement WHERE agreement_id IN (SELECT agreement_id FROM tmp_con_fms_deletion);
		DELETE FROM history_agreement_accounting_line WHERE agreement_id IN (SELECT agreement_id FROM tmp_con_fms_deletion);
		DELETE FROM history_agreement_commodity WHERE agreement_id IN (SELECT agreement_id FROM tmp_con_fms_deletion);
		DELETE FROM history_agreement_worksite WHERE agreement_id IN (SELECT agreement_id FROM tmp_con_fms_deletion);

	END IF;
	
	-- Identify the CON ones which have to be created
	
	CREATE TEMPORARY TABLE tmp_new_ct_fms_con(con_document_code varchar,con_agency_code varchar, con_document_id varchar,
					   con_agency_history_id smallint,con_document_code_id smallint,uniq_id bigint);
	
	INSERT INTO tmp_new_ct_fms_con
	SELECT 	con_document_code,con_agency_code, con_document_id,con_agency_history_id,con_document_code_id,min(uniq_id)
	FROM	tmp_ct_fms
	WHERE	agreement_id =0
	GROUP BY 1,2,3,4,5;
	
	TRUNCATE etl.agreement_id_seq;
	
	INSERT INTO etl.agreement_id_seq(uniq_id)
	SELECT uniq_id
	FROM  tmp_new_ct_fms_con;
	
	INSERT INTO all_agreement(agreement_id,document_code_id,agency_history_id,document_id,document_version,privacy_flag)
	SELECT  b.agreement_id, a.con_document_code_id,a.con_agency_history_id,a.con_document_id,0 as document_version,p_privacy_flag_in
	FROM	tmp_new_ct_fms_con a JOIN etl.agreement_id_seq b ON a.uniq_id = b.uniq_id;
	
	INSERT INTO history_all_agreement(agreement_id,document_code_id,agency_history_id,document_id,document_version,privacy_flag)
	SELECT  b.agreement_id, a.con_document_code_id,a.con_agency_history_id,a.con_document_id,0 as document_version,p_privacy_flag_in
	FROM	tmp_new_ct_fms_con a JOIN etl.agreement_id_seq b ON a.uniq_id = b.uniq_id;	
	
	/* Rule covers this
	INSERT INTO master_agreement(master_agreement_id,document_code_id,agency_history_id,document_id,document_version)
	SELECT  b.agreement_id, a.mag_document_code_id,a.mag_agency_history_id,a.mag_document_id,0 as document_version
	FROM	tmp_new_ct_mag_con a JOIN etl.agreement_id_seq b ON a.uniq_id = b.uniq_id;
	
	
	INSERT INTO history_master_agreement(master_agreement_id,document_code_id,agency_history_id,document_id,document_version)
	SELECT  b.agreement_id, a.mag_document_code_id,a.mag_agency_history_id,a.mag_document_id,0 as document_version
	FROM	tmp_new_ct_mag_con a JOIN etl.agreement_id_seq b ON a.uniq_id = b.uniq_id;
	*/
	
	-- Updating the newly created CON identifier.
	
	CREATE TEMPORARY TABLE tmp_new_ct_fms_con_2(uniq_id bigint,agreement_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_new_ct_fms_con_2
	SELECT c.uniq_id,d.agreement_id
	FROM   tmp_ct_fms a JOIN tmp_new_ct_fms_con b ON a.uniq_id = b.uniq_id
		JOIN tmp_ct_fms c ON c.con_document_code = a.con_document_code
				     AND c.con_agency_code = a.con_agency_code
				     AND c.con_document_id = a.con_document_id
		JOIN etl.agreement_id_seq d ON b.uniq_id = d.uniq_id;
		
	UPDATE tmp_ct_fms a
	SET	agreement_id = b.agreement_id
	FROM	tmp_new_ct_fms_con_2 b
	WHERE	a.uniq_id = b.uniq_id
		AND a.agreement_id =0;
	 	
	 UPDATE etl.stg_fms_accounting_line a
	 SET	agreement_id = b.agreement_id
	 FROM	tmp_ct_fms b
	 WHERE	a.uniq_id = b.uniq_id;
	 
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in associateCONToFMS';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

---------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.changeVisibilityOfAgreements(p_load_id_in int)  RETURNS INT AS $$
DECLARE
BEGIN
	-- Deleting the con/mag associated with partially displayed or not to be displayed disbursements
	
	CREATE TEMPORARY TABLE tmp_con_changes_fms(agreement_id bigint, full_visible_count smallint, document_code_id smallint,
						document_id varchar, agency_id smallint)
	DISTRIBUTED BY (agreement_id);

	-- identify the con/mag directly associated with disbursement
	
	INSERT INTO tmp_con_changes_fms(agreement_id, full_visible_count, document_code_id,document_id, agency_id)
	SELECT b.agreement_id, SUM(CASE WHEN c.privacy_flag IN ('X','P') AND d.document_code='DC' THEN 0 ELSE 1 END) as full_visible_count,
		min(e.document_code_id) as document_code_id, 
		min(e.document_id) as document_id,
		min(e.agency_id) as agency_id
	FROM   etl.stg_fms_accounting_line a JOIN disbursement_line_item b ON a.agreement_id = b.agreement_id
		JOIN disbursement c ON b.disbursement_id = c.disbursement_id
		JOIN ref_document_code d ON c.document_code_id = d.document_code_id
		JOIN fact_agreement e ON b.agreement_id = e.agreement_id		
	WHERE	a.agreement_id > 0
	GROUP BY 1;

	RAISE NOTICE 'CON 14';
	
	-- identify the mag  indirectly associated with disbursement	
	
	INSERT INTO tmp_con_changes_fms(agreement_id, full_visible_count, document_code_id,document_id, agency_id)
	SELECT e.master_agreement_id, SUM(CASE WHEN c.privacy_flag IN ('X','P') AND d.document_code='DC' THEN 0 ELSE 1 END) as full_visible_count,
		min(e.document_code_id) as document_code_id, 
		min(e.document_id) as document_id,
		min(e.agency_id) as agency_id
	FROM   etl.stg_fms_accounting_line a JOIN disbursement_line_item b ON a.agreement_id = b.agreement_id
		JOIN disbursement c ON b.disbursement_id = c.disbursement_id
		JOIN ref_document_code d ON c.document_code_id = d.document_code_id
		JOIN fact_agreement e ON b.agreement_id = e.agreement_id		
	WHERE	a.agreement_id > 0		
		AND coalesce(e.master_agreement_id,0) > 0
	GROUP BY 1	;

	RAISE NOTICE 'CON 14.1';
		
	CREATE TEMPORARY TABLE tmp_con_changes_fms_1(agreement_id bigint)
	DISTRIBUTED BY (agreement_id);

	INSERT INTO tmp_con_changes_fms_1(agreement_id)	
	SELECT  a.agreement_id
	FROM	history_agreement a ,
		(SELECT document_code_id,document_id,agency_id,sum(full_visible_count) as full_visible_count
		FROM	tmp_con_changes_fms
		GROUP BY 1,2,3
		HAVING SUM(full_visible_count) = 0 ) inner_tbl,
		ref_agency_history b
	WHERE	a.document_id = inner_tbl.document_id
		AND a.document_code_id = inner_tbl.document_code_id
		AND a.agency_history_id = b.agency_history_id
		AND b.agency_id = inner_tbl.agency_id;

	RAISE NOTICE 'CON 14.1.1';
	
	INSERT INTO tmp_con_changes_fms_1(agreement_id)	
	SELECT  a.master_agreement_id
	FROM	history_master_agreement a ,
		(SELECT document_code_id,document_id,agency_id,sum(full_visible_count) as full_visible_count
		FROM	tmp_con_changes_fms
		GROUP BY 1,2,3
		HAVING SUM(full_visible_count) = 0 ) inner_tbl,
		ref_agency_history b
	WHERE	a.document_id = inner_tbl.document_id
		AND a.document_code_id = inner_tbl.document_code_id
		AND a.agency_history_id = b.agency_history_id
		AND b.agency_id = inner_tbl.agency_id;

	RAISE NOTICE 'CON 14.1.2';
		
	DELETE FROM history_agreement WHERE agreement_id IN (SELECT agreement_id FROM tmp_con_changes_fms_1);
	DELETE FROM history_master_agreement WHERE master_agreement_id IN (SELECT agreement_id FROM tmp_con_changes_fms_1);
		
	-- Insert the agreements/master agreements which are now associated to fully displayed disbursements
	-- This is required when agreement/master agreement was deleted from the public table because of being associated only to partially/not displayed disbursements 
	-- and is now having fully displayed disbursements
	
	TRUNCATE tmp_con_changes_fms_1;
	
	INSERT INTO tmp_con_changes_fms_1(agreement_id)		
	SELECT  a.agreement_id
	FROM	history_all_agreement a ,
		(SELECT document_code_id,document_id,agency_id,sum(full_visible_count) as full_visible_count
		FROM	tmp_con_changes_fms
		GROUP BY 1,2,3
		HAVING SUM(full_visible_count) > 0 ) inner_tbl,
		ref_agency_history b
	WHERE	a.document_id = inner_tbl.document_id
		AND a.document_code_id = inner_tbl.document_code_id
		AND a.agency_history_id = b.agency_history_id
		AND b.agency_id = inner_tbl.agency_id;
	

	INSERT INTO tmp_con_changes_fms_1(agreement_id)		
	SELECT  a.master_agreement_id
	FROM	history_all_master_agreement a ,
		(SELECT document_code_id,document_id,agency_id,sum(full_visible_count) as full_visible_count
		FROM	tmp_con_changes_fms
		GROUP BY 1,2,3
		HAVING SUM(full_visible_count) > 0 ) inner_tbl,
		ref_agency_history b
	WHERE	a.document_id = inner_tbl.document_id
		AND a.document_code_id = inner_tbl.document_code_id
		AND a.agency_history_id = b.agency_history_id
		AND b.agency_id = inner_tbl.agency_id;

	select * from tmp_con_changes_fms_1;
	
	DELETE FROM tmp_con_changes_fms_1 WHERE agreement_id in (SELECT agreement_id FROM history_agreement);

	DELETE FROM tmp_con_changes_fms_1 WHERE agreement_id in (SELECT master_agreement_id FROM history_master_agreement);
	
	-- Inserting the agreement

	RAISE NOTICE 'CON 15';
	
	INSERT INTO agreement
	SELECT a.* FROM all_agreement a JOIN tmp_con_changes_fms_1 b ON a.agreement_id = b.agreement_id;
	
	RAISE NOTICE 'CON 15.1';
	
	INSERT INTO master_agreement
	SELECT a.* FROM all_master_agreement a JOIN tmp_con_changes_fms_1 b ON a.master_agreement_id = b.agreement_id;

	RAISE NOTICE 'CON 15.2';
	
	INSERT INTO agreement_worksite
	SELECT a.* FROM all_agreement_worksite a JOIN tmp_con_changes_fms_1 b ON a.agreement_id = b.agreement_id;

	RAISE NOTICE 'CON 15.3';
	
	INSERT INTO agreement_commodity
	SELECT a.* FROM all_agreement_commodity a JOIN tmp_con_changes_fms_1 b ON a.agreement_id = b.agreement_id;

	INSERT INTO agreement_accounting_line
	SELECT a.* FROM all_agreement_accounting_line a JOIN tmp_con_changes_fms_1 b ON a.agreement_id = b.agreement_id;
	
	-- Inserting the history records
	
	INSERT INTO history_agreement
	SELECT a.* FROM history_all_agreement a JOIN tmp_con_changes_fms_1 b ON a.agreement_id = b.agreement_id;

	RAISE NOTICE 'CON 15.1';
	
	INSERT INTO history_master_agreement
	SELECT a.* FROM history_all_master_agreement a JOIN tmp_con_changes_fms_1 b ON a.master_agreement_id = b.agreement_id;

	RAISE NOTICE 'CON 15.2';
	
	INSERT INTO history_agreement_worksite
	SELECT a.* FROM history_all_agreement_worksite a JOIN tmp_con_changes_fms_1 b ON a.agreement_id = b.agreement_id;

	RAISE NOTICE 'CON 15.3';
	
	INSERT INTO history_agreement_commodity
	SELECT a.* FROM history_all_agreement_commodity a JOIN tmp_con_changes_fms_1 b ON a.agreement_id = b.agreement_id;

	INSERT INTO history_agreement_accounting_line
	SELECT a.* FROM history_all_agreement_accounting_line a JOIN tmp_con_changes_fms_1 b ON a.agreement_id = b.agreement_id;
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in changeVisibilityOfAgreements';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
	
END;
$$ language plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.changeVisibilityOfVendor(p_load_id_in int) RETURNS INT AS
$$
DECLARE
BEGIN
	-- Deleting the vendor associated with partially displayed or not to be displayed disbursements
	
	CREATE TEMPORARY TABLE tmp_vendor_changes_fms(vendor_id int, full_visible_count smallint,orig_display_flag char(1), new_display_flag char(1))
	DISTRIBUTED BY (vendor_id);

	-- identify the vendor associated with disbursement
	
	INSERT INTO tmp_vendor_changes_fms
	SELECT b.vendor_id, SUM(CASE WHEN d.privacy_flag IN ('X','P') AND e.document_code='DC' THEN 0 ELSE 1 END) as full_visible_count,
		min(f.display_flag) as orig_display_flag,'' as new_display_flag
	FROM   etl.stg_fms_vendor a JOIN vendor_history b ON a.vendor_history_id = b.vendor_history_id
		JOIN vendor_history c ON b.vendor_id = c.vendor_id
		JOIN disbursement d ON c.vendor_history_id = d.vendor_history_id
		JOIN ref_document_code e ON d.document_code_id = e.document_code_id	
		JOIN vendor f ON c.vendor_id = f.vendor_id
	GROUP BY 1;


	RAISE NOTICE 'Vendor 1.1';
	
	UPDATE tmp_vendor_changes_fms
	SET	new_display_flag = 'Y'
	WHERE	full_visible_count >0;
	
	UPDATE tmp_vendor_changes_fms
	SET	new_display_flag = 'N'
	WHERE	full_visible_count =0;
	
	UPDATE vendor a
	SET    	display_flag = 'N',
		updated_load_id = p_load_id_in,
		updated_date = now()::timestamp
	FROM	tmp_vendor_changes_fms b
	WHERE a.vendor_id = b.vendor_id
		AND b.new_display_flag ='N' 
		AND b.orig_display_flag ='Y';
	
	RAISE NOTICE 'Vendor 1.2';
	
	CREATE TEMPORARY TABLE tmp_con_changed_fms_1(agreement_id bigint)
	DISTRIBUTED BY (agreement_id);
	
	INSERT INTO tmp_con_changed_fms_1(agreement_id)
	SELECT agreement_id
	FROM	history_agreement a JOIN vendor_history b ON a.vendor_history_id = b.vendor_history_id
		JOIN vendor c ON b.vendor_id = c.vendor_id
		JOIN tmp_vendor_changes_fms d ON c.vendor_id = d.vendor_id
	WHERE 	d.new_display_flag ='N' 	;

	RAISE NOTICE 'Vendor 1.3';	
	
	INSERT INTO tmp_con_changed_fms_1(agreement_id)
	SELECT master_agreement_id
	FROM	history_master_agreement a JOIN vendor_history b ON a.vendor_history_id = b.vendor_history_id
		JOIN vendor c ON b.vendor_id = c.vendor_id
		JOIN tmp_vendor_changes_fms d ON c.vendor_id = d.vendor_id
	WHERE 	d.new_display_flag ='N' 	;
		
	DELETE FROM history_agreement WHERE agreement_id IN (SELECT agreement_id FROM tmp_con_changed_fms_1);
	DELETE FROM history_master_agreement WHERE master_agreement_id IN (SELECT agreement_id FROM tmp_con_changed_fms_1);		
	
	DELETE FROM tmp_vendor_changes_fms WHERE full_visible_count =0;

	RAISE NOTICE 'Vendor 1.4';
	
	UPDATE  vendor a
	SET     display_flag = 'Y',
		updated_load_id = p_load_id_in,
		updated_date = now()::timestamp
	FROM	tmp_vendor_changes_fms b
	WHERE a.vendor_id = b.vendor_id
		AND b.new_display_flag ='Y' 
		AND b.orig_display_flag = 'N';
		
	CREATE TEMPORARY TABLE tmp_con_changes_fms_2(agreement_id bigint)
	DISTRIBUTED BY (agreement_id);		

	
	INSERT INTO tmp_con_changes_fms_2
	SELECT a.agreement_id
	FROM 	history_all_agreement a JOIN vendor_history b ON a.vendor_history_id = b.vendor_history_id
		JOIN tmp_vendor_changes_fms c ON b.vendor_id = c.vendor_id
	WHERE c.new_display_flag ='Y' 
		AND c.orig_display_flag = 'N';

	RAISE NOTICE 'Vendor 1.5';
	
	INSERT INTO tmp_con_changes_fms_2
	SELECT a.master_agreement_id
	FROM 	history_all_agreement a JOIN vendor_history b ON a.vendor_history_id = b.vendor_history_id
		JOIN tmp_vendor_changes_fms c ON b.vendor_id = c.vendor_id
	WHERE c.new_display_flag ='Y' 
		AND c.orig_display_flag = 'N';
		
	INSERT INTO agreement
	SELECT a.* FROM all_agreement a JOIN tmp_con_changes_fms_2 b ON a.agreement_id = b.agreement_id;

	RAISE NOTICE 'CON 15.1';
	
	INSERT INTO master_agreement
	SELECT a.* FROM all_master_agreement a JOIN tmp_con_changes_fms_2 b ON a.master_agreement_id = b.agreement_id;

	RAISE NOTICE 'CON 15.2';
	
	INSERT INTO agreement_worksite
	SELECT a.* FROM all_agreement_worksite a JOIN tmp_con_changes_fms_2 b ON a.agreement_id = b.agreement_id;

	RAISE NOTICE 'CON 15.3';
	
	INSERT INTO agreement_commodity
	SELECT a.* FROM all_agreement_commodity a JOIN tmp_con_changes_fms_2 b ON a.agreement_id = b.agreement_id;

	INSERT INTO agreement_accounting_line
	SELECT a.* FROM all_agreement_accounting_line a JOIN tmp_con_changes_fms_2 b ON a.agreement_id = b.agreement_id;

	-- Inserting the history records ---
	
	INSERT INTO history_agreement
	SELECT a.* FROM history_all_agreement a JOIN tmp_con_changes_fms_2 b ON a.agreement_id = b.agreement_id;

	RAISE NOTICE 'CON 15.1';
	
	INSERT INTO history_master_agreement
	SELECT a.* FROM history_all_master_agreement a JOIN tmp_con_changes_fms_2 b ON a.master_agreement_id = b.agreement_id;

	RAISE NOTICE 'CON 15.2';
	
	INSERT INTO history_agreement_worksite
	SELECT a.* FROM history_all_agreement_worksite a JOIN tmp_con_changes_fms_2 b ON a.agreement_id = b.agreement_id;

	RAISE NOTICE 'CON 15.3';
	
	INSERT INTO history_agreement_commodity
	SELECT a.* FROM history_all_agreement_commodity a JOIN tmp_con_changes_fms_2 b ON a.agreement_id = b.agreement_id;

	INSERT INTO history_agreement_accounting_line
	SELECT a.* FROM history_all_agreement_accounting_line a JOIN tmp_con_changes_fms_2 b ON a.agreement_id = b.agreement_id;
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in changeVisibilityOfVendor';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
	
END;
$$ language plpgsql;	

------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION etl.refreshFactsForFMS(p_load_id_in int) RETURNS INT AS
$$
DECLARE
BEGIN
	-- Inserting into the fact_disbursement_line_item

	RAISE NOTICE 'CON 16';
	INSERT INTO fact_disbursement_line_item(disbursement_line_item_id,disbursement_id,line_number,check_eft_issued_date_id,	
						check_eft_issued_nyc_year_id,check_eft_issued_cal_month_id,
						agreement_id,master_agreement_id,fund_class_id,
						check_amount,agency_id,expenditure_object_id,
						vendor_id,maximum_contract_amount,maximum_spending_limit)
	SELECT  b.disbursement_line_item_id,a.disbursement_id,b.line_number,a.check_eft_issued_date_id,
		f.nyc_year_id,f.calendar_month_id,
		b.agreement_id,NULL as master_agreement_id,b.fund_class_id,
		b.check_amount,c.agency_id,d.expenditure_object_id,
		e.vendor_id,NULL as maximum_contract_amount, NULL as maximum_spending_limit
	FROM disbursement a JOIN disbursement_line_item b ON a.disbursement_id = b.disbursement_id
			JOIN ref_agency_history c ON b.agency_history_id = c.agency_history_id
			JOIN ref_expenditure_object_history d ON b.expenditure_object_history_id = d.expenditure_object_history_id
			JOIN vendor_history e ON a.vendor_history_id = e.vendor_history_id
			JOIN ref_date f ON a.check_eft_issued_date_id = f.date_id
	WHERE a.load_id = p_load_id_in;
	

	CREATE TEMPORARY TABLE tmp_agreement_con(disbursement_line_item_id bigint,agreement_id bigint,master_agreement_id bigint, maximum_contract_amount numeric(16,2), master_agreement_yn char(1))
	DISTRIBUTED  BY (disbursement_line_item_id);
	
	INSERT INTO tmp_agreement_con
	SELECT a.disbursement_line_item_id, b.agreement_id,b.master_agreement_id,b.maximum_contract_amount, b.master_agreement_yn
	FROM fact_disbursement_line_item a JOIN fact_agreement b ON a.agreement_id = b.agreement_id
		JOIN etl.seq_disbursement_line_item_id c ON a.disbursement_line_item_id = c.disbursement_line_item_id;

	UPDATE fact_disbursement_line_item a
	SET	master_agreement_id = (CASE WHEN b.master_agreement_yn = 'Y' THEN b.agreement_id ELSE b.master_agreement_id END),
		agreement_id = (CASE WHEN b.master_agreement_yn = 'Y' THEN NULL ELSE a.agreement_id END),
		maximum_contract_amount =(CASE WHEN b.master_agreement_yn = 'N' THEN b.maximum_contract_amount ELSE NULL END),
		maximum_spending_limit =(CASE WHEN b.master_agreement_yn = 'Y' THEN b.maximum_contract_amount ELSE NULL END)
	FROM	tmp_agreement_con  b
	WHERE   a.disbursement_line_item_id = b.disbursement_line_item_id;

	TRUNCATE tmp_agreement_con;
	
	-- To fetch the maximum spending limit of the MAG associated with CON
	
	INSERT INTO tmp_agreement_con(disbursement_line_item_id,master_agreement_id,maximum_contract_amount)
	SELECT a.disbursement_line_item_id, b.agreement_id,b.maximum_contract_amount
	FROM	fact_disbursement_line_item a JOIN fact_agreement b ON	a.master_agreement_id = b.agreement_id AND COALESCE(a.agreement_id) > 0
		JOIN etl.seq_disbursement_line_item_id c ON a.disbursement_line_item_id = c.disbursement_line_item_id;

	UPDATE fact_disbursement_line_item a
	SET maximum_spending_limit = b.maximum_contract_amount
	FROM	tmp_agreement_con  b
	WHERE   a.disbursement_line_item_id = b.disbursement_line_item_id;
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in refreshFactsForFMS';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
	
END;
$$ language plpgsql;	
------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processFMS(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE


	l_fk_update int;
	l_insert_sql VARCHAR;
	l_display_type char(1);
	l_masked_agreement_id bigint;
	l_masked_vendor_history_id integer;
BEGIN


	SELECT display_type
	FROM   etl.etl_data_load_file
	WHERE  load_file_id = p_load_file_id_in
	INTO   l_display_type;
	
	SELECT	agreement_id
	FROM	agreement a JOIN ref_document_code b ON a.document_code_id = b.document_code_id
	WHERE	a.document_id='(PRIVACY/SECURITY)'
		AND b.document_code='N/A'
	INTO	l_masked_agreement_id;
	
	SELECT	a.vendor_history_id
	FROM	vendor_history a JOIN vendor b ON a.vendor_id = b.vendor_id
	WHERE	b.vendor_customer_code='N/A'
		AND b.legal_name='(PRIVACY/SECURITY)'
	INTO	l_masked_vendor_history_id;	
		
	l_fk_update := etl.updateForeignKeysForFMSInHeader(p_load_id_in);

	RAISE NOTICE 'CON 1';
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.updateForeignKeysForFMSVendors(p_load_id_in);
	ELSE
		RETURN -1;
	END IF;

	RAISE NOTICE 'CON 2';
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.updateForeignKeysForFMSInAccLine(p_load_id_in);
	ELSE
		RETURN -1;
	END IF;

	RAISE NOTICE 'CON 3';
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.associateCONToFMS(l_display_type);
	ELSE
		RETURN -1;
	END IF;

	RAISE NOTICE 'CON 5';
	
	/*
	1.Pull the key information such as document code, document id, document version etc for all agreements
	2. For the existing contracts gather details on max version in the transaction, staging tables..Determine if the staged agreement is latest version...
	3. Identify the new agreements. Determine the latest version for each of it.
	*/
	
	RAISE NOTICE 'CON 6';
	
	TRUNCATE etl.seq_expenditure_expenditure_id;
	
	INSERT INTO etl.seq_expenditure_expenditure_id(uniq_id)
	SELECT uniq_id
	FROM	etl.stg_fms_header;	

	INSERT INTO all_disbursement(disbursement_id,document_code_id,agency_history_id,
				 document_id,document_version,record_date_id,
				 budget_fiscal_year,document_fiscal_year,document_period,
				 check_eft_amount,check_eft_issued_date_id,check_eft_record_date_id,
				 expenditure_status_id,expenditure_cancel_type_id,expenditure_cancel_reason_id,
				 total_accounting_line_amount,vendor_history_id,
				 retainage_amount,privacy_flag,load_id,created_date)
	SELECT c.disbursement_id, a.document_code_id,a.agency_history_id,
	       a.doc_id,a.doc_vers_no,a.record_date_id,
	       a.doc_bfy,a.doc_fy_dc,a.doc_per_dc,
	       a.chk_eft_am,a.check_eft_issued_date_id,a.check_eft_record_date_id,
	       a.expenditure_status_id,a.expenditure_cancel_type_id,a.expenditure_cancel_reason_id,
	       a.ln_am,b.vendor_history_id, 
	       a.rtg_am,l_display_type,p_load_id_in,now()::timestamp
	FROM	etl.stg_fms_header a JOIN etl.stg_fms_vendor b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd
					AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
		JOIN etl.seq_expenditure_expenditure_id c ON a.uniq_id = c.uniq_id;
		
	RAISE NOTICE 'CON 13';
	
	TRUNCATE etl.seq_disbursement_line_item_id;
	
	INSERT INTO etl.seq_disbursement_line_item_id(uniq_id)
	SELECT uniq_id
	FROM	etl.stg_fms_accounting_line;
	
	INSERT INTO all_disbursement_line_item(disbursement_line_item_id,disbursement_id,line_number,
						budget_fiscal_year,fiscal_year,fiscal_period,
						fund_class_id,agency_history_id,department_history_id,
						expenditure_object_history_id,budget_code_id,fund_id,
						reporting_code,check_amount,agreement_id,
						agreement_accounting_line_number,location_history_id,retainage_amount,
						created_load_id,created_date)
	SELECT  c.disbursement_line_item_id,d.disbursement_id,a.DOC_ACTG_LN_NO,
		a.bfy,a.fy_dc,a.per_dc,
		a.fund_class_id,a.agency_history_id,a.department_history_id,
		a.expenditure_object_history_id,a.budget_code_id,a.fund_id,
		a.RPT_CD,a.CHK_AMT,a.agreement_id,
		a.RQPORF_ACTG_LN_NO,a.location_history_id,a.RTG_LN_AM,
		p_load_id_in, now()::timestamp
	FROM	etl.stg_fms_accounting_line a JOIN etl.stg_fms_header b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd
					AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
		JOIN etl.seq_disbursement_line_item_id c ON a.uniq_id = c.uniq_id
		JOIN etl.seq_expenditure_expenditure_id d ON b.uniq_id = d.uniq_id;

	RAISE NOTICE 'CON 13.1';
	
	INSERT INTO disbursement_line_item(disbursement_line_item_id,disbursement_id,line_number,
						budget_fiscal_year,fiscal_year,fiscal_period,
						fund_class_id,agency_history_id,
						department_history_id,
						expenditure_object_history_id,budget_code_id,fund_id,
						reporting_code,check_amount,agreement_id,
						agreement_accounting_line_number,location_history_id,retainage_amount,
						created_load_id,created_date)
	SELECT  c.disbursement_line_item_id,d.disbursement_id,a.DOC_ACTG_LN_NO,
		a.bfy,a.fy_dc,a.per_dc,
		a.fund_class_id,(CASE WHEN l_display_type='P' THEN a.masked_agency_history_id ELSE a.agency_history_id END) as agency_history_id,
		(CASE WHEN l_display_type='P' THEN a.masked_department_history_id ELSE a.department_history_id END) as department_history_id,
		a.expenditure_object_history_id,a.budget_code_id,a.fund_id,
		a.rpt_cd,(CASE WHEN a.doc_vers_no > 1 THEN -a.chk_amt ELSE a.chk_amt END),(CASE WHEN l_display_type='P' THEN l_masked_agreement_id ELSE a.agreement_id END) as agreement_id,
		a.rqporf_actg_ln_no,a.location_history_id,a.rtg_ln_am,
		p_load_id_in, now()::timestamp
	FROM	etl.stg_fms_accounting_line a JOIN etl.stg_fms_header b ON a.doc_cd = b.doc_cd AND a.doc_dept_cd = b.doc_dept_cd
					AND a.doc_id = b.doc_id AND a.doc_vers_no = b.doc_vers_no
		JOIN etl.seq_disbursement_line_item_id c ON a.uniq_id = c.uniq_id
		JOIN etl.seq_expenditure_expenditure_id d ON b.uniq_id = d.uniq_id
	WHERE	b.doc_cd <> 'DC'
		AND l_display_type <> 'X';

	l_fk_update := etl.changeVisibilityOfAgreements(p_load_id_in);
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.changeVisibilityOfVendor(p_load_id_in);
	ELSE
		RETURN -2;
	END IF;	
	
	IF l_fk_update = 1 THEN
		l_fk_update := etl.refreshFactsForFMS(p_load_id_in);
	ELSE
		RETURN -2;
	END IF;	
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processFMS';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;


