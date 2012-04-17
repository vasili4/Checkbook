CREATE OR REPLACE FUNCTION etl.updateEmployees(p_load_id_in bigint) RETURNS INT AS $$
DECLARE
BEGIN

	CREATE TEMPORARY TABLE tmp_ref_employee(employee_number varchar,first_name varchar, last_name varchar,initial varchar,
						exists_flag char(1), modified_flag char(1))
	DISTRIBUTED BY (employee_number);
	
	-- For all records check if data is modified/new
	
	INSERT INTO tmp_ref_employee
	SELECT  DISTINCT
		a.employee_number, 
	       a.first_name,
	       a.last_name,
	       a.initial,
	       (CASE WHEN b.employee_number IS NULL THEN 'N' ELSE 'Y' END) as exists_flag,
	       (CASE WHEN b.employee_number IS NOT NULL AND (a.first_name <> b.first_name OR a.last_name <> b.last_name OR a.initial <> b.initial) THEN 'Y' ELSE 'N' END) as modified_flag
	FROM   etl.stg_payroll a LEFT JOIN employee b ON a.employee_number = b.employee_number;
	
	TRUNCATE etl.employee_id_seq;
	
	INSERT INTO etl.employee_id_seq(employee_number)
	SELECT employee_number
	FROM   tmp_ref_employee
	WHERE  exists_flag ='N';
	
	INSERT INTO employee(employee_id,employee_number,first_name,last_name,initial,created_date,created_load_id,original_first_name,original_last_name,original_initial)
	SELECT a.employee_id,b.employee_number,first_name,last_name,initial,now()::timestamp,p_load_id_in,first_name,last_name,initial
	FROM   etl.employee_id_seq a JOIN tmp_ref_employee b ON a.employee_number = b.employee_number;
	
	
	TRUNCATE etl.employee_history_id_seq;
	
	INSERT INTO etl.employee_history_id_seq(employee_number)
	SELECT employee_number
	FROM   tmp_ref_employee
	WHERE  exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');


	CREATE TEMPORARY TABLE tmp_ref_employee_1(employee_number varchar,first_name varchar, last_name varchar,initial varchar,
						exists_flag char(1), modified_flag char(1), employee_id int)
	DISTRIBUTED BY (employee_id);

	INSERT INTO tmp_ref_employee_1
	SELECT a.*,b.employee_id FROM tmp_ref_employee a JOIN employee b ON a.employee_number = b.employee_number
	WHERE exists_flag ='Y' and modified_flag='Y';

	RAISE NOTICE '1';
	
	UPDATE employee a
	SET	first_name = b.first_name,
		last_name = b.last_name,
		initial = b.initial,
		updated_date = now()::timestamp,
		updated_load_id = p_load_id_in
	FROM	tmp_ref_employee_1 b		
	WHERE	a.employee_id = b.employee_id;
	
	INSERT INTO employee_history(employee_history_id,employee_id,first_name,last_name,initial,created_date,created_load_id)
	SELECT a.employee_history_id,c.employee_id,b.first_name,b.last_name,b.initial,now()::timestamp,p_load_id_in
	FROM   etl.employee_history_id_seq a JOIN tmp_ref_employee b ON a.employee_number = b.employee_number
		JOIN employee c ON b.employee_number = c.employee_number
	WHERE   exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y') ;

	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in updateEmployees';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
	
END;
$$ language plpgsql;

-------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.updateForeignKeysForPMS(p_load_id_in bigint) RETURNS INT AS $$
DECLARE
BEGIN
	CREATE TEMPORARY TABLE tmp_fk_pms_values(uniq_id bigint,employee_history_id int, pay_date_id smallint,agency_history_id smallint,orig_pay_date_id smallint,
					department_history_id integer,amount_basis_id smallint,payroll_id bigint, action_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	-- FK:pay_date_id
	
	INSERT INTO tmp_fk_pms_values(uniq_id,pay_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_payroll a JOIN ref_date b ON a.pay_date = b.date;
	
	-- FK:Agency_history_id
	
	INSERT INTO tmp_fk_pms_values(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) as agency_history_id
	FROM etl.stg_payroll a JOIN ref_agency b ON a.agency_code = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1;
	
	CREATE TEMPORARY TABLE tmp_fk_pms_values_new_agencies(agency_code varchar,uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_pms_values_new_agencies
	SELECT agency_code,MIN(b.uniq_id) as uniq_id
	FROM etl.stg_payroll a join (SELECT uniq_id
						 FROM tmp_fk_pms_values
						 GROUP BY 1
						 HAVING max(agency_history_id) is null) b on a.uniq_id=b.uniq_id
	GROUP BY 1;

	RAISE NOTICE '1';
	
	TRUNCATE etl.ref_agency_id_seq;
	
	INSERT INTO etl.ref_agency_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_pms_values_new_agencies;
	
	INSERT INTO ref_agency(agency_id,agency_code,agency_name,created_date,created_load_id,original_agency_name)
	SELECT a.agency_id,b.agency_code,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in,'<Unknown Agency>' as original_agency_name
	FROM   etl.ref_agency_id_seq a JOIN tmp_fk_pms_values_new_agencies b ON a.uniq_id = b.uniq_id;

	RAISE NOTICE '1.1';

	-- Generate the agency history id for history records
	
	TRUNCATE etl.ref_agency_history_id_seq;
	
	INSERT INTO etl.ref_agency_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_pms_values_new_agencies;

	INSERT INTO ref_agency_history(agency_history_id,agency_id,agency_name,created_date,load_id)
	SELECT a.agency_history_id,b.agency_id,'<Unknown Agency>' as agency_name,now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_history_id_seq a JOIN etl.ref_agency_id_seq b ON a.uniq_id = b.uniq_id;

	RAISE NOTICE '1.3';
	INSERT INTO tmp_fk_pms_values(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) 
	FROM etl.stg_payroll a JOIN ref_agency b ON a.agency_code = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
		JOIN etl.ref_agency_history_id_seq d ON c.agency_history_id = d.agency_history_id
	GROUP BY 1	;
	
	-- FK:orig_pay_date_id
	
	INSERT INTO tmp_fk_pms_values(uniq_id,orig_pay_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_payroll a JOIN ref_date b ON a.orig_pay_date = b.date;
	
	-- FK:department_history_id
	
	INSERT INTO tmp_fk_pms_values(uniq_id,department_history_id)
	SELECT	a.uniq_id, max(c.department_history_id) 
	FROM etl.stg_payroll a JOIN ref_department b ON a.department_code = b.department_code AND a.fiscal_year = b.fiscal_year
		JOIN ref_department_history c ON b.department_id = c.department_id
		JOIN ref_agency d ON a.agency_code = d.agency_code AND b.agency_id = d.agency_id
		JOIN ref_fund_class e ON '001' = e.fund_class_code AND e.fund_class_id = b.fund_class_id
	GROUP BY 1;
	
	CREATE TEMPORARY TABLE tmp_fk_values_pms_new_dept(agency_history_id integer,agency_id integer,department_code varchar,
						fund_class_id smallint,fiscal_year smallint, uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fk_values_pms_new_dept
	SELECT d.agency_history_id,c.agency_id,a.department_code,e.fund_class_id,a.fiscal_year,MIN(b.uniq_id) as uniq_id
	FROM etl.stg_payroll a join (SELECT uniq_id
						 FROM tmp_fk_pms_values
						 GROUP BY 1
						 HAVING max(department_history_id) IS NULL) b on a.uniq_id=b.uniq_id
		JOIN ref_agency c ON a.agency_code = c.agency_code
		JOIN ref_agency_history d ON c.agency_id = d.agency_id
		JOIN ref_fund_class e ON '001' = e.fund_class_code
	GROUP BY 1,2,3,4,5;

	RAISE NOTICE '1.4';
						
	-- Generate the department id for new records
		
	TRUNCATE etl.ref_department_id_seq;
	
	INSERT INTO etl.ref_department_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_pms_new_dept;

	INSERT INTO ref_department(department_id,department_code,
				   department_name,
				   agency_id,fund_class_id,
				   fiscal_year,created_date,created_load_id,original_department_name)
	SELECT a.department_id,COALESCE(b.department_code,'---------') as department_code,
		(CASE WHEN COALESCE(b.department_code,'') <> '' THEN '<Unknown Department>'
			ELSE 'Non-Applicable Department' END) as department_name,
		b.agency_id,b.fund_class_id,b.fiscal_year,
		now()::timestamp,p_load_id_in,
		(CASE WHEN COALESCE(b.department_code,'') <> '' THEN '<Unknown Department>'
			ELSE 'Non-Applicable Department' END) as original_department_name
	FROM   etl.ref_department_id_seq a JOIN tmp_fk_values_pms_new_dept b ON a.uniq_id = b.uniq_id;

	RAISE NOTICE '1.5';
	-- Generate the department history id for history records
	
	TRUNCATE etl.ref_department_history_id_seq;
	
	INSERT INTO etl.ref_department_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_fk_values_pms_new_dept;

	INSERT INTO ref_department_history(department_history_id,department_id,
					   department_name,agency_id,fund_class_id,
					   fiscal_year,created_date,load_id)
	SELECT a.department_history_id,c.department_id,	
		(CASE WHEN COALESCE(b.department_code,'') <> '' THEN '<Unknown Department>'
		      ELSE 'Non-Applicable Department' END) as department_name,
		b.agency_id,b.fund_class_id,b.fiscal_year,now()::timestamp,p_load_id_in
	FROM   etl.ref_department_history_id_seq a JOIN tmp_fk_values_pms_new_dept b ON a.uniq_id = b.uniq_id
		JOIN etl.ref_department_id_seq  c ON a.uniq_id = c.uniq_id ;


	RAISE NOTICE '1.6';
	
	INSERT INTO tmp_fk_pms_values(uniq_id,department_history_id)
	SELECT	a.uniq_id, max(c.department_history_id) 
	FROM etl.stg_payroll a JOIN ref_department b  ON a.department_code = b.department_code AND a.fiscal_year = b.fiscal_year
		JOIN ref_department_history c ON b.department_id = c.department_id
		JOIN ref_agency d ON a.agency_code = d.agency_code AND b.agency_id = d.agency_id
		JOIN ref_fund_class e ON '001' = e.fund_class_code AND e.fund_class_id = b.fund_class_id
		JOIN etl.ref_department_history_id_seq f ON c.department_history_id = f.department_history_id
	GROUP BY 1	;	

	RAISE NOTICE '1.7';
	
	-- FK:amount_basis_id
	
	INSERT INTO tmp_fk_pms_values(uniq_id,amount_basis_id)
	SELECT	a.uniq_id, b.amount_basis_id
	FROM etl.stg_payroll a JOIN ref_amount_basis b ON a.amount_basis = b.amount_basis_name;	

	-- FK: employee_history_id
	
	INSERT INTO tmp_fk_pms_values(uniq_id,employee_history_id)
	SELECT a.uniq_id,max(c.employee_history_id) as employee_history_id
	FROM	etl.stg_payroll a JOIN employee b ON a.employee_number = b.employee_number
		JOIN employee_history c ON b.employee_id = c.employee_id
	GROUP BY 1	;
	
	-- FK: payroll_id
	
	INSERT INTO tmp_fk_pms_values(uniq_id,payroll_id,action_flag)
	SELECT a.uniq_id,b.payroll_id,'U' as action_flag
	FROM	etl.stg_payroll a 
		JOIN (SELECT uniq_id,
				max(pay_date_id )as pay_date_id ,
				max(agency_history_id )as agency_history_id ,
				max(orig_pay_date_id )as orig_pay_date_id ,
				max(department_history_id )as department_history_id ,
				max(amount_basis_id) as amount_basis_id,
				max(employee_history_id) as employee_history_id
			FROM	tmp_fk_pms_values
			GROUP	BY 1) ct_table ON a.uniq_id = ct_table.uniq_id
		JOIN payroll b ON ct_table.employee_history_id = b.employee_history_id 	AND ct_table.pay_date_id=b.pay_date_id
				  AND ct_table.agency_history_id = b.agency_history_id AND a.pay_cycle_code = b.pay_cycle_code;
		
	RAISE NOTICE '1.8';
	
	TRUNCATE etl.payroll_id_seq;
	
	INSERT INTO etl.payroll_id_seq(uniq_id)
	SELECT DISTINCT a.uniq_id
	FROM 	etl.stg_payroll a join (SELECT uniq_id
					FROM tmp_fk_pms_values
					GROUP BY 1
					HAVING max(payroll_id) is null) b on a.uniq_id=b.uniq_id;
	RAISE NOTICE '1.8.1';
	
	INSERT INTO tmp_fk_pms_values(uniq_id,payroll_id,action_flag)
	SELECT uniq_id,payroll_id,'I' as action_flag
	FROM   etl.payroll_id_seq;

	RAISE NOTICE '1.8.1';
	
	UPDATE etl.stg_payroll a
	SET	
		pay_date_id =ct_table.pay_date_id ,
		agency_history_id =ct_table.agency_history_id ,
		orig_pay_date_id =ct_table.orig_pay_date_id ,
		department_history_id=ct_table.department_history_id,
		amount_basis_id = ct_table.amount_basis_id,
		employee_history_id = ct_table.employee_history_id,
		payroll_id = ct_table.payroll_id,
		action_flag = ct_table.action_flag
	FROM	
		(SELECT uniq_id,
			max(pay_date_id )as pay_date_id ,
			max(agency_history_id )as agency_history_id ,
			max(orig_pay_date_id )as orig_pay_date_id ,
			max(department_history_id )as department_history_id ,
			max(amount_basis_id) as amount_basis_id,
			max(employee_history_id) as employee_history_id,
			max(payroll_id) as payroll_id,
			max(action_flag) as action_flag
		FROM	tmp_fk_pms_values
		GROUP	BY 1) ct_table
	WHERE	a.uniq_id = ct_table.uniq_id;	

	RAISE NOTICE '1.9';
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in updateForeignKeysForPMS';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;	
	
END;
$$ language plpgsql;
----------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processPayroll(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_count bigint;
	l_fk_update smallint;
	
BEGIN
	l_fk_update := etl.updateEmployees(p_load_id_in);
	
	IF l_fk_update = 1 THEN		
		l_fk_update := etl.updateForeignKeysForPMS(p_load_id_in);
	ELSE
		RETURN -1;
	END IF;	

	IF l_fk_update <> 1 THEN
		RETURN -1;
	END IF;
	
	CREATE TEMPORARY TABLE tmp_payroll_update(payroll_id bigint, pay_cycle_code CHAR(1), pay_date_id smallint, employee_history_id bigint,
						  payroll_number varchar, job_sequence_number varchar ,agency_history_id smallint,fiscal_year smallint,
						  orig_pay_date_id smallint,pay_frequency varchar,department_history_id int,annual_salary numeric(16,2),
						  amount_basis_id smallint,base_pay numeric(16,2),overtime_pay numeric(16,2),other_payments numeric(16,2),
						  gross_pay numeric(16,2))
	DISTRIBUTED BY (payroll_id);
	
	INSERT INTO tmp_payroll_update
	SELECT payroll_id, pay_cycle_code, pay_date_id, employee_history_id,
	       payroll_number, job_sequence_number ,agency_history_id,fiscal_year,
	       orig_pay_date_id,pay_frequency,department_history_id,annual_salary,
	       amount_basis_id,base_pay,overtime_pay,other_payments,
	       gross_pay
	FROM   etl.stg_payroll
	WHERE  action_flag = 'U';
	
	UPDATE payroll a
	SET     pay_cycle_code = b.pay_cycle_code,
		pay_date_id = b.pay_date_id,
		employee_history_id = b.employee_history_id,
		payroll_number = b.payroll_number,
		job_sequence_number = b.job_sequence_number,
		agency_history_id = b.agency_history_id,
		fiscal_year = b.fiscal_year,
		orig_pay_date_id = b.orig_pay_date_id,
		pay_frequency = b.pay_frequency,
		department_history_id = b.department_history_id,
		annual_salary = b.annual_salary,
		amount_basis_id = b.amount_basis_id,
		base_pay = b.base_pay,
		overtime_pay = b.overtime_pay,
		other_payments = b.other_payments,
		gross_pay = b.gross_pay
	FROM	tmp_payroll_update b
	WHERE 	a.payroll_id = b.payroll_id;
	
	GET DIAGNOSTICS l_count = ROW_COUNT;
	INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
	VALUES(p_load_file_id_in,'P',l_count,'# of modified PMS records');
		
	INSERT INTO payroll(payroll_id, pay_cycle_code, pay_date_id, employee_history_id,
						  payroll_number, job_sequence_number ,agency_history_id,fiscal_year,
						  orig_pay_date_id,pay_frequency,department_history_id,annual_salary,
						  amount_basis_id,base_pay,overtime_pay,other_payments,
						  gross_pay)
	SELECT payroll_id, pay_cycle_code, pay_date_id, employee_history_id,
	       payroll_number, job_sequence_number ,agency_history_id,fiscal_year,
	       orig_pay_date_id,pay_frequency,department_history_id,annual_salary,
	       amount_basis_id,base_pay,overtime_pay,other_payments,
	       gross_pay
	FROM   etl.stg_payroll
	WHERE  action_flag = 'I';
		
	GET DIAGNOSTICS l_count = ROW_COUNT;
	INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
	VALUES(p_load_file_id_in,'P',l_count,'# of new PMS records');
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processPayroll';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
	
END;
$$ language plpgsql;