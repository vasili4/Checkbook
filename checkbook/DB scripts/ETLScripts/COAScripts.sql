/*
Functions defined
	processCOAAgency
	processCOADepartment
	processCOAExpenditureObject	
	processCOALocation
	processCOAObjectClass
*/

CREATE OR REPLACE FUNCTION etl.processCOAAgency(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
BEGIN
	CREATE TEMPORARY TABLE tmp_ref_agency(uniq_id bigint,agency_code varchar(20),agency_name varchar, exists_flag char(1), modified_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	-- For all records check if data is modified/new
	
	INSERT INTO tmp_ref_agency
	SELECT  a.uniq_id,
		a.agency_code, 
	       a.agency_name,
	       (CASE WHEN b.agency_code IS NULL THEN 'N' ELSE 'Y' END) as exists_flag,
	       (CASE WHEN b.agency_code IS NOT NULL AND a.agency_name <> b.agency_name THEN 'Y' ELSE 'N' END) as modified_flag
	FROM   etl.stg_agency a LEFT JOIN ref_agency b ON a.agency_code = b.agency_code;
	
	
	-- Generate the agency id for new records
		
	TRUNCATE etl.ref_agency_id_seq;
	
	INSERT INTO etl.ref_agency_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_agency
	WHERE  exists_flag ='N';
	
	INSERT INTO ref_agency(agency_id,agency_code,agency_name,created_date,created_load_id,original_agency_name)
	SELECT a.agency_id,b.agency_code,b.agency_name,now()::timestamp,p_load_id_in,b.agency_name
	FROM   etl.ref_agency_id_seq a JOIN tmp_ref_agency b ON a.uniq_id = b.uniq_id;
	
	-- Generate the agency history id for history records
	
	TRUNCATE etl.ref_agency_history_id_seq;
	
	INSERT INTO etl.ref_agency_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_agency
	WHERE  exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');
		

	CREATE TEMPORARY TABLE tmp_ref_agency_1(uniq_id bigint,agency_code varchar(20),agency_name varchar, exists_flag char(1), modified_flag char(1), agency_id smallint)
	DISTRIBUTED BY (agency_id);

	INSERT INTO tmp_ref_agency_1
	SELECT a.*,b.agency_id FROM tmp_ref_agency a JOIN ref_agency b ON a.agency_code = b.agency_code
	WHERE exists_flag ='Y' and modified_flag='Y';

	RAISE NOTICE '1';
	
	UPDATE ref_agency a
	SET	agency_name = b.agency_name,
		updated_date = now()::timestamp,
		updated_load_id = p_load_id_in,
		original_agency_name = (CASE WHEN COALESCE(a.original_agency_name,'')='' THEN b.agency_name 
						ELSE a.original_agency_name END)
	FROM	tmp_ref_agency_1 b		
	WHERE	a.agency_id = b.agency_id;

	RAISE NOTICE '2';
	
	INSERT INTO ref_agency_history(agency_history_id,agency_id,agency_name,created_date,load_id)
	SELECT a.agency_history_id,c.agency_id,b.agency_name,now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_history_id_seq a JOIN tmp_ref_agency_1 b ON a.uniq_id = b.uniq_id
		JOIN ref_agency c ON b.agency_code = c.agency_code;

	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processCOAAgency';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

---------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processCOADepartment(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
BEGIN
	CREATE TEMPORARY TABLE tmp_ref_department(uniq_id bigint,agency_code varchar,agency_id int,fund_class_code varchar,fund_class_id int,
						  department_code varchar(20),fiscal_year smallint,department_name varchar, exists_flag char(1), 
						  modified_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	-- For all records check if data is modified/new
	
	INSERT INTO tmp_ref_department
	SELECT inner_tbl.uniq_id,
		inner_tbl.agency_code,
		inner_tbl.agency_id,
		inner_tbl.fund_class_code,
		inner_tbl.fund_class_id,
		inner_tbl.department_code, 
		inner_tbl.fiscal_year,
	       inner_tbl.department_name,
	       (CASE WHEN b.department_code IS NULL THEN 'N' ELSE 'Y' END) as exists_flag,
	       (CASE WHEN b.department_code IS NOT NULL AND inner_tbl.department_name <> b.department_name THEN 'Y' ELSE 'N' END) as modified_flag
	FROM       
	(SELECT a.uniq_id,
		a.agency_code,
		d.agency_id,		
		a.fund_class_code,
		c.fund_class_id,
		a.department_code,
		a.fiscal_year, 
	        a.department_name	       
	FROM   etl.stg_department a LEFT JOIN ref_fund_class c ON a.fund_class_code = c.fund_class_code 
	       LEFT JOIN ref_agency d ON a.agency_code = d.agency_code ) inner_tbl
	       LEFT JOIN ref_department b ON inner_tbl.department_code = b.department_code AND inner_tbl.fiscal_year=b.fiscal_year
						AND inner_tbl.agency_id =b.agency_id AND inner_tbl.fund_class_id = b.fund_class_id;

	RAISE NOTICE '1';
	
	-- Generate the agency id for new agency records & insert into ref_agency/ref_agency_history
	
	TRUNCATE etl.ref_agency_id_seq;
	
	INSERT INTO etl.ref_agency_id_seq(uniq_id)
	SELECT min(uniq_id)
	FROM   tmp_ref_department
	WHERE  exists_flag ='N'
	       AND agency_id =0
	GROUP BY agency_code;
	
	CREATE TEMPORARY TABLE tmp_agency_id(uniq_id bigint, agency_id smallint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_agency_id
	SELECT c.uniq_id,b.agency_id
	FROM	tmp_ref_department a JOIN etl.ref_agency_id_seq b ON a.uniq_id = b.uniq_id
		JOIN tmp_ref_department c ON a.agency_code = c.agency_code;
	
	UPDATE 	tmp_ref_department a
	SET	agency_id = b.agency_id
	FROM	tmp_agency_id b
	WHERE 	a.uniq_id = b.uniq_id;

	RAISE NOTICE '2';

	
	
	INSERT INTO ref_agency(agency_id,agency_code,created_date,created_load_id)
	SELECT a.agency_id,b.agency_code,now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_id_seq a JOIN tmp_ref_department b ON a.uniq_id = b.uniq_id;
	
	TRUNCATE etl.ref_agency_history_id_seq;
	
	INSERT INTO etl.ref_agency_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   etl.ref_agency_id_seq;

	RAISE NOTICE '3';


	
	INSERT INTO ref_agency_history(agency_history_id,agency_id,created_date,load_id)
	SELECT a.agency_history_id,c.agency_id,now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_history_id_seq a JOIN tmp_ref_department b ON a.uniq_id = b.uniq_id
		JOIN ref_agency c ON b.agency_code = c.agency_code;
		
	
	-- Generate the fund class identifier for new fund class
	
	TRUNCATE etl.ref_fund_class_id_seq;
	
	INSERT INTO etl.ref_fund_class_id_seq
	SELECT min(uniq_id)
	FROM   tmp_ref_department
	WHERE  exists_flag ='N'
	       AND fund_class_id =0
	GROUP BY fund_class_code;

	RAISE NOTICE '3.1';
	
	CREATE TEMPORARY TABLE tmp_fund_class_id_id(uniq_id bigint, fund_class_id smallint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_fund_class_id_id
	SELECT c.uniq_id,b.fund_class_id
	FROM	tmp_ref_department a JOIN etl.ref_fund_class_id_seq b ON a.uniq_id = b.uniq_id
		JOIN tmp_ref_department c ON a.fund_class_code = c.fund_class_code;
	
	UPDATE 	tmp_ref_department a
	SET	fund_class_id = b.fund_class_id
	FROM	tmp_fund_class_id_id b
	WHERE 	a.uniq_id = b.uniq_id;
	
	INSERT INTO ref_fund_class(fund_class_id,fund_class_code)
	SELECT a.fund_class_id,b.fund_class_code
	FROM 	etl.ref_fund_class_id_seq a JOIN tmp_ref_department b ON a.uniq_id = b.uniq_id;
	
	RAISE NOTICE '3.2';
	
	-- Generate the department id for new records
		
	TRUNCATE etl.ref_department_id_seq;
	
	INSERT INTO etl.ref_department_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_department
	WHERE  exists_flag ='N';
	
	INSERT INTO ref_department(department_id,department_code,department_name,agency_id,fund_class_id,fiscal_year,created_date,created_load_id,original_department_name)
	SELECT a.department_id,b.department_code,b.department_name,b.agency_id,b.fund_class_id,b.fiscal_year,now()::timestamp,p_load_id_in,b.department_name
	FROM   etl.ref_department_id_seq a JOIN tmp_ref_department b ON a.uniq_id = b.uniq_id;

	RAISE NOTICE '3.3';
	-- Generate the department history id for history records
	
	TRUNCATE etl.ref_department_history_id_seq;
	
	INSERT INTO etl.ref_department_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_department
	WHERE  exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');
		
	RAISE NOTICE '3.4';

	CREATE TEMPORARY TABLE tmp_ref_department_1(uniq_id bigint,agency_code varchar,agency_id int,fund_class_code varchar,fund_class_id int,
						  department_code varchar(20),fiscal_year smallint,department_name varchar, exists_flag char(1), 
						  modified_flag char(1), department_id smallint)
	DISTRIBUTED BY (department_id);

	INSERT INTO tmp_ref_department_1
	SELECT a.*,b.department_id FROM tmp_ref_department a JOIN ref_department b ON a.department_code = b.department_code AND a.agency_id = b.agency_id 
							AND a.fund_class_id = b.fund_class_id AND a.fiscal_year=b.fiscal_year
	WHERE exists_flag ='Y' and modified_flag='Y';

	RAISE NOTICE '4';
	
	UPDATE ref_department a
	SET	department_name = b.department_name,
		updated_date = now()::timestamp,
		updated_load_id = p_load_id_in
	FROM	tmp_ref_department_1 b		
	WHERE	a.department_id = b.department_id;

	RAISE NOTICE '5';
	
	INSERT INTO ref_department_history(department_history_id,department_id,department_name,agency_id,fund_class_id,fiscal_year,created_date,load_id)
	SELECT a.department_history_id,c.department_id,b.department_name,b.agency_id,b.fund_class_id,b.fiscal_year,now()::timestamp,p_load_id_in
	FROM   etl.ref_department_history_id_seq a JOIN tmp_ref_department b ON a.uniq_id = b.uniq_id
		JOIN ref_department c ON b.department_code = c.department_code AND b.agency_id = c.agency_id 
			AND b.fund_class_id = c.fund_class_id AND b.fiscal_year=c.fiscal_year;

	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processCOAdepartment';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processCOAExpenditureObject(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
BEGIN
	CREATE TEMPORARY TABLE tmp_ref_expenditure_object(uniq_id bigint,expenditure_object_code varchar(20),fiscal_year smallint,expenditure_object_name varchar, exists_flag char(1), modified_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	-- For all records check if data is modified/new
	
	INSERT INTO tmp_ref_expenditure_object
	SELECT  a.uniq_id,
		a.expenditure_object_code,
		a.fiscal_year, 
	       a.expenditure_object_name,	       
	       (CASE WHEN b.expenditure_object_code IS NULL THEN 'N' ELSE 'Y' END) as exists_flag,
	       (CASE WHEN b.expenditure_object_code IS NOT NULL AND a.expenditure_object_name <> b.expenditure_object_name THEN 'Y' ELSE 'N' END) as modified_flag
	FROM   etl.stg_expenditure_object a LEFT JOIN ref_expenditure_object b ON a.expenditure_object_code = b.expenditure_object_code AND a.fiscal_year=b.fiscal_year;
	
	
	-- Generate the expenditure_object id for new records
		
	TRUNCATE etl.ref_expenditure_object_id_seq;
	
	INSERT INTO etl.ref_expenditure_object_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_expenditure_object
	WHERE  exists_flag ='N';
	
	INSERT INTO ref_expenditure_object(expenditure_object_id,expenditure_object_code,expenditure_object_name,fiscal_year,created_date,created_load_id,original_expenditure_object_name)
	SELECT a.expenditure_object_id,b.expenditure_object_code,b.expenditure_object_name,fiscal_year,now()::timestamp,p_load_id_in,b.expenditure_object_name
	FROM   etl.ref_expenditure_object_id_seq a JOIN tmp_ref_expenditure_object b ON a.uniq_id = b.uniq_id;
	
	-- Generate the expenditure_object history id for history records
	
	TRUNCATE etl.ref_expenditure_object_history_id_seq;
	
	INSERT INTO etl.ref_expenditure_object_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_expenditure_object
	WHERE  exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');
		

	CREATE TEMPORARY TABLE tmp_ref_expenditure_object_1(uniq_id bigint,expenditure_object_code varchar(20),fiscal_year smallint,expenditure_object_name varchar, exists_flag char(1), modified_flag char(1), expenditure_object_id smallint)
	DISTRIBUTED BY (expenditure_object_id);

	INSERT INTO tmp_ref_expenditure_object_1
	SELECT a.*,b.expenditure_object_id FROM tmp_ref_expenditure_object a JOIN ref_expenditure_object b ON a.expenditure_object_code = b.expenditure_object_code AND a.fiscal_year=b.fiscal_year
	WHERE exists_flag ='Y' and modified_flag='Y';

	RAISE NOTICE '1';
	
	UPDATE ref_expenditure_object a
	SET	expenditure_object_name = b.expenditure_object_name,
		updated_date = now()::timestamp,
		updated_load_id = p_load_id_in
	FROM	tmp_ref_expenditure_object_1 b		
	WHERE	a.expenditure_object_id = b.expenditure_object_id;

	RAISE NOTICE '2';
	
	INSERT INTO ref_expenditure_object_history(expenditure_object_history_id,expenditure_object_id,fiscal_year,expenditure_object_name,created_date,load_id)
	SELECT a.expenditure_object_history_id,c.expenditure_object_id,b.fiscal_year,b.expenditure_object_name,now()::timestamp,p_load_id_in
	FROM   etl.ref_expenditure_object_history_id_seq a JOIN tmp_ref_expenditure_object b ON a.uniq_id = b.uniq_id
		JOIN ref_expenditure_object c ON b.expenditure_object_code = c.expenditure_object_code AND b.fiscal_year = c.fiscal_year;

	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processCOAexpenditure_object';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Schema: etl
CREATE OR REPLACE FUNCTION etl.processCOALocation(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
BEGIN
	CREATE TEMPORARY TABLE tmp_ref_location(uniq_id bigint,agency_code varchar,agency_id int,
						  location_code varchar(20),location_name varchar,location_short_name varchar, exists_flag char(1), 
						  modified_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	-- For all records check if data is modified/new
	
	INSERT INTO tmp_ref_location
	SELECT inner_tbl.uniq_id,
		inner_tbl.agency_code,
		inner_tbl.agency_id,
		inner_tbl.location_code, 
		inner_tbl.location_name,
	       inner_tbl.location_short_name,
	       (CASE WHEN b.location_code IS NULL THEN 'N' ELSE 'Y' END) as exists_flag,
	       (CASE WHEN b.location_code IS NOT NULL AND inner_tbl.location_name <> b.location_name THEN 'Y' ELSE 'N' END) as modified_flag
	FROM       
	(SELECT a.uniq_id,
		a.agency_code,
		d.agency_id,		
		a.location_code,
		a.location_name,
		a.location_short_name
	FROM   etl.stg_location a LEFT JOIN ref_agency d ON a.agency_code = d.agency_code ) inner_tbl
	       LEFT JOIN ref_location b ON inner_tbl.location_code = b.location_code AND inner_tbl.agency_id =b.agency_id;

	RAISE NOTICE '1';
	
	-- Generate the agency id for new agency records & insert into ref_agency/ref_agency_history
	
	TRUNCATE etl.ref_agency_id_seq;
	
	INSERT INTO etl.ref_agency_id_seq(uniq_id)
	SELECT min(uniq_id)
	FROM   tmp_ref_location
	WHERE  exists_flag ='N'
	       AND agency_id =0
	GROUP BY agency_code;
	
	CREATE TEMPORARY TABLE tmp_agency_id(uniq_id bigint, agency_id smallint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_agency_id
	SELECT c.uniq_id,b.agency_id
	FROM	tmp_ref_location a JOIN etl.ref_agency_id_seq b ON a.uniq_id = b.uniq_id
		JOIN tmp_ref_location c ON a.agency_code = c.agency_code;
	
	UPDATE 	tmp_ref_location a
	SET	agency_id = b.agency_id
	FROM	tmp_agency_id b
	WHERE 	a.uniq_id = b.uniq_id;

	RAISE NOTICE '2';

	
	
	INSERT INTO ref_agency(agency_id,agency_code,created_date,created_load_id)
	SELECT a.agency_id,b.agency_code,now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_id_seq a JOIN tmp_ref_location b ON a.uniq_id = b.uniq_id;
	
	TRUNCATE etl.ref_agency_history_id_seq;
	
	INSERT INTO etl.ref_agency_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   etl.ref_agency_id_seq;

	RAISE NOTICE '3';


	
	INSERT INTO ref_agency_history(agency_history_id,agency_id,created_date,load_id)
	SELECT a.agency_history_id,c.agency_id,now()::timestamp,p_load_id_in
	FROM   etl.ref_agency_history_id_seq a JOIN tmp_ref_location b ON a.uniq_id = b.uniq_id
		JOIN ref_agency c ON b.agency_code = c.agency_code;
		
	
	-- Generate the location id for new records
		
	TRUNCATE etl.ref_location_id_seq;
	
	INSERT INTO etl.ref_location_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_location
	WHERE  exists_flag ='N';
	
	INSERT INTO ref_location(location_id,location_code,location_name,agency_id,location_short_name,created_date,created_load_id,original_location_name)
	SELECT a.location_id,b.location_code,b.location_name,b.agency_id,b.location_short_name,now()::timestamp,p_load_id_in,b.location_name
	FROM   etl.ref_location_id_seq a JOIN tmp_ref_location b ON a.uniq_id = b.uniq_id;

	RAISE NOTICE '3.3';
	-- Generate the location history id for history records
	
	TRUNCATE etl.ref_location_history_id_seq;
	
	INSERT INTO etl.ref_location_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_location
	WHERE  exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');
		
	RAISE NOTICE '3.4';

	CREATE TEMPORARY TABLE tmp_ref_location_1(uniq_id bigint,agency_code varchar,agency_id int,
						  location_code varchar(20),location_name varchar,location_short_name varchar, exists_flag char(1), 
						  modified_flag char(1), location_id smallint)
	DISTRIBUTED BY (location_id);

	INSERT INTO tmp_ref_location_1
	SELECT a.*,b.location_id FROM tmp_ref_location a JOIN ref_location b ON a.location_code = b.location_code AND a.agency_id = b.agency_id 							
	WHERE exists_flag ='Y' and modified_flag='Y';

	RAISE NOTICE '4';
	
	UPDATE ref_location a
	SET	location_name = b.location_name,
		updated_date = now()::timestamp,
		updated_load_id = p_load_id_in
	FROM	tmp_ref_location_1 b		
	WHERE	a.location_id = b.location_id;

	RAISE NOTICE '5';
	
	INSERT INTO ref_location_history(location_history_id,location_id,location_name,agency_id,location_short_name,created_date,load_id)
	SELECT a.location_history_id,c.location_id,b.location_name,b.agency_id,b.location_short_name,now()::timestamp,p_load_id_in
	FROM   etl.ref_location_history_id_seq a JOIN tmp_ref_location b ON a.uniq_id = b.uniq_id
		JOIN ref_location c ON b.location_code = c.location_code AND b.agency_id = c.agency_id;

	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processCOAlocation';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

---------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION etl.processCOAObjectClass(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
BEGIN
	CREATE TEMPORARY TABLE tmp_ref_object_class(uniq_id bigint,object_class_code varchar(4),object_class_name varchar(60),exists_flag char(1), modified_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	-- For all records check if data is modified/new
	
	INSERT INTO tmp_ref_object_class
	SELECT  a.uniq_id,
		a.object_class_code, 
	       a.object_class_name,
	       (CASE WHEN b.object_class_code IS NULL THEN 'N' ELSE 'Y' END) as exists_flag,
	       (CASE WHEN b.object_class_code IS NOT NULL AND a.object_class_name <> b.object_class_name THEN 'Y' ELSE 'N' END) as modified_flag
	FROM   etl.stg_object_class a LEFT JOIN ref_object_class b ON a.object_class_code = b.object_class_code;

	RAISE NOTICE 'start';
	
	
	-- Generate the object_class id for new records
		
	TRUNCATE etl.ref_object_class_id_seq;
	
	INSERT INTO etl.ref_object_class_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_object_class
	WHERE  exists_flag ='N';
	
	INSERT INTO ref_object_class(object_class_id,object_class_code,object_class_name,object_class_short_name,
				     active_flag, effective_begin_date_id, effective_end_date_id, budget_allowed_flag, description,
				     source_updated_date,intra_city_flag,contracts_positions_flag,payroll_type,extended_description,
				     related_object_class_code,created_date,created_load_id,original_object_class_name)
	SELECT a.object_class_id,b.object_class_code,b.object_class_name,c.short_name,
		act_fl, d.date_id, e.date_id, alw_bud_fl, c.description,
		c.tbl_last_dt,intr_cty_fl,cntrc_pos_fl,c.pyrl_typ,c.dscr_ext,
		c.rltd_ocls_cd,now()::timestamp,p_load_id_in,b.object_class_name
	FROM   etl.ref_object_class_id_seq a JOIN tmp_ref_object_class b ON a.uniq_id = b.uniq_id
		JOIN etl.stg_object_class c ON b.uniq_id = c.uniq_id
		LEFT JOIN ref_date d ON c.effective_begin_date::date = d.date
		LEFT JOIN ref_date e ON c.effective_end_date::date = e.date;

	RAISE NOTICE 'start.2';
	
	-- Generate the object_class history id for history records
	
	TRUNCATE etl.ref_object_class_history_id_seq;
	
	INSERT INTO etl.ref_object_class_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_object_class
	WHERE  exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');
		

	CREATE TEMPORARY TABLE tmp_ref_object_class_1(uniq_id bigint,object_class_code varchar(20),object_class_name varchar, exists_flag char(1), modified_flag char(1), object_class_id smallint)
	DISTRIBUTED BY (object_class_id);

	INSERT INTO tmp_ref_object_class_1
	SELECT a.*,b.object_class_id FROM tmp_ref_object_class a JOIN ref_object_class b ON a.object_class_code = b.object_class_code
	WHERE exists_flag ='Y' and modified_flag='Y';

	RAISE NOTICE '1';
	
	UPDATE ref_object_class a
	SET	object_class_name = b.object_class_name,
		updated_date = now()::timestamp,
		updated_load_id = p_load_id_in
	FROM	tmp_ref_object_class_1 b		
	WHERE	a.object_class_id = b.object_class_id;

	RAISE NOTICE '2';
	
	INSERT INTO ref_object_class_history(object_class_history_id,object_class_id,object_class_name,object_class_short_name,
				     active_flag, effective_begin_date_id, effective_end_date_id, budget_allowed_flag, description,
				     source_updated_date,intra_city_flag,contracts_positions_flag,payroll_type,extended_description,
				     related_object_class_code,created_date,load_id)
	SELECT a.object_class_history_id,c.object_class_id,b.object_class_name,d.short_name,
		d.act_fl, e.date_id, f.date_id, d.alw_bud_fl, d.description,
		d.tbl_last_dt,intr_cty_fl, cntrc_pos_fl,d.pyrl_typ,d.dscr_ext,
		d.rltd_ocls_cd,now()::timestamp,p_load_id_in
	FROM   etl.ref_object_class_history_id_seq a JOIN tmp_ref_object_class b ON a.uniq_id = b.uniq_id
		JOIN ref_object_class c ON b.object_class_code = c.object_class_code
		JOIN etl.stg_object_class d ON b.uniq_id = d.uniq_id
		LEFT JOIN ref_date e ON d.effective_begin_date::date = e.date
		LEFT JOIN ref_date f ON d.effective_end_date::date = f.date;

	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processCOAobject_class';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;
