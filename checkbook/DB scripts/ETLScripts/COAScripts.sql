/*
Functions defined
	processCOAAgency
	processCOADepartment
	processCOAExpenditureObject	
	processCOALocation
	processCOAObjectClass
	processrevenuecategory
	processrevenueclass
	processrevenuesource
	
	
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
	FROM   etl.ref_agency_history_id_seq a JOIN tmp_ref_agency b ON a.uniq_id = b.uniq_id
		JOIN ref_agency c ON b.agency_code = c.agency_code
	WHERE   exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y') 	;

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
	       AND COALESCE(agency_id,0) =0
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
	       AND COALESCE(fund_class_id,0) =0
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
			AND b.fund_class_id = c.fund_class_id AND b.fiscal_year=c.fiscal_year
	WHERE	exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');			

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
		JOIN ref_expenditure_object c ON b.expenditure_object_code = c.expenditure_object_code AND b.fiscal_year = c.fiscal_year
	WHERE	exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');
		
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
	       AND COALESCE(agency_id,0) =0
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
		JOIN ref_location c ON b.location_code = c.location_code AND b.agency_id = c.agency_id
	WHERE	exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');
		
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
		LEFT JOIN ref_date f ON d.effective_end_date::date = f.date
	WHERE 	exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');
		
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processCOAobject_class';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION etl.processrevenuecategory(p_load_file_id_in integer, p_load_id_in bigint) RETURNS integer AS $$
DECLARE
BEGIN


	CREATE TEMPORARY TABLE tmp_ref_revenue_category(uniq_id bigint,rscat_cd varchar(20),rscat_nm varchar,rscat_sh_nm varchar, exists_flag char(1), modified_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	-- For all records check if data is modified/new


	
	INSERT INTO tmp_ref_revenue_category
	SELECT  a.uniq_id,
		a.rscat_cd, 
	       a.rscat_nm,
	       a.rscat_sh_nm,
	       (CASE WHEN b.revenue_category_code IS NULL THEN 'N' ELSE 'Y' END) as exists_flag,
	       (CASE WHEN b.revenue_category_code IS NOT NULL AND a.rscat_nm <> b.revenue_category_name THEN 'Y' ELSE 'N' END) as modified_flag
	FROM   etl.stg_revenue_category a LEFT JOIN ref_revenue_category b ON a.rscat_cd = b.revenue_category_code;

	RAISE NOTICE '1';
	
	-- Generate the revenue category id for new records



	TRUNCATE etl.ref_revenue_category_id_seq;
	
	INSERT INTO etl.ref_revenue_category_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_revenue_category
	WHERE  exists_flag ='N';

	
	
	INSERT INTO ref_revenue_category(revenue_category_id,revenue_category_code,revenue_category_name,revenue_category_short_name,created_date)
	SELECT a.revenue_category_id,b.rscat_cd,b.rscat_nm,rscat_sh_nm, now()::timestamp
	FROM   etl.ref_revenue_category_id_seq a JOIN tmp_ref_revenue_category b ON a.uniq_id = b.uniq_id;
	




CREATE TEMPORARY TABLE tmp_ref_revenue_category_1(uniq_id bigint,rscat_cd varchar(20),rscat_nm varchar,rscat_sh_nm varchar, exists_flag char(1), modified_flag char(1), revenue_category_id smallint)
	DISTRIBUTED BY (revenue_category_id);

	INSERT INTO tmp_ref_revenue_category_1
	SELECT a.*,b.revenue_category_id FROM tmp_ref_revenue_category a JOIN ref_revenue_category b ON a.rscat_cd = b.revenue_category_code
	WHERE exists_flag ='Y' and modified_flag='Y';

	RAISE NOTICE '2';
	
	UPDATE ref_revenue_category a
	SET	revenue_category_name = b.rscat_nm,
		updated_date = now()::timestamp,
		updated_load_id = p_load_id_in
	FROM	tmp_ref_revenue_category_1 b		
	WHERE	a.revenue_category_id = b.revenue_category_id;


	Return 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processrevenuecategory';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;

	
END;
$$ language plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION etl.processrevenueclass(p_load_file_id_in integer, p_load_id_in bigint) RETURNS integer AS $$
DECLARE
BEGIN


	CREATE TEMPORARY TABLE tmp_ref_revenue_class(uniq_id bigint,rscls_cd varchar(20),rscls_nm varchar,rscls_sh_nm varchar, exists_flag char(1), modified_flag char(1))
	DISTRIBUTED BY (uniq_id);
	
	-- For all records check if data is modified/new


	
	INSERT INTO tmp_ref_revenue_class
	SELECT  a.uniq_id,
		a.rscls_cd, 
	       a.rscls_nm,
	       a.rscls_sh_nm,
	       (CASE WHEN b.revenue_class_code IS NULL THEN 'N' ELSE 'Y' END) as exists_flag,
	       (CASE WHEN b.revenue_class_code IS NOT NULL AND a.rscls_nm <> b.revenue_class_name THEN 'Y' ELSE 'N' END) as modified_flag
	FROM   etl.stg_revenue_class a LEFT JOIN ref_revenue_class b ON a.rscls_cd = b.revenue_class_code;

	Raise notice '1';
	
	-- Generate the revenue class id for new records
		
	TRUNCATE etl.ref_revenue_class_id_seq;
	
	INSERT INTO etl.ref_revenue_class_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_revenue_class
	WHERE  exists_flag ='N';

	
	Raise notice '3';
	INSERT INTO ref_revenue_class(revenue_class_id,revenue_class_code,revenue_class_name,revenue_class_short_name,created_date)
	SELECT a.revenue_class_id,b.rscls_cd,b.rscls_nm,b.rscls_sh_nm, now()::timestamp
	FROM   etl.ref_revenue_class_id_seq a JOIN tmp_ref_revenue_class b ON a.uniq_id = b.uniq_id;
	




CREATE TEMPORARY TABLE tmp_ref_revenue_class_1(uniq_id bigint,rscls_cd varchar(20),rscls_nm varchar,rscls_sh_nm varchar, exists_flag char(1), modified_flag char(1), revenue_class_id smallint)
	DISTRIBUTED BY (revenue_class_id);

	INSERT INTO tmp_ref_revenue_class_1
	SELECT a.*,b.revenue_class_id FROM tmp_ref_revenue_class a JOIN ref_revenue_class b ON a.rscls_cd = b.revenue_class_code
	WHERE exists_flag ='Y' and modified_flag='Y';
Raise notice '5';
	
	UPDATE ref_revenue_class a
	SET	revenue_class_name = b.rscls_nm,
		updated_date = now()::timestamp,
		updated_load_id = p_load_id_in
	FROM	tmp_ref_revenue_class_1 b		
	WHERE	a.revenue_class_id = b.revenue_class_id;

	Return 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processrevenueclass';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;	
END;
$$ language plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION etl.processrevenuesource(p_load_file_id_in integer, p_load_id_in bigint) RETURNS integer AS $$
DECLARE
BEGIN



CREATE TEMPORARY TABLE tmp_ref_revenue_source(uniq_id bigint,fy integer,
rsrc_cd varchar(20),rsrc_nm varchar, exists_flag char(1), modified_flag char(1),
		rsrc_sh_nm varchar,
		act_fl bit(1),   
		alw_bud_fl bit(1), 
		oper_ind integer, 
		fasb_cls_ind integer,
		fhwa_rev_cr_fl integer, 
		usetax_coll_fl integer,
		rsrc_dscr varchar,	 
		apy_intr_lat_fee integer,
		apy_intr_admn_fee integer,
		apy_intr_nsf_fee integer,
		apy_intr_othr_fee integer,
		elg_inct_fl integer,
		earn_rcvb_cd VarChar, 
		fin_fee_ov_fl integer,
		apy_intr_ov integer,     
		bill_lag_dy integer,
		bill_freq integer,
		bill_fy_strt_mnth integer,
		bill_fy_strt_dy integer,
		fed_agcy_cd VarChar,
		fed_agcy_sfx VarChar,
		fed_nm VarChar,
		srsrc_req VarChar,
		rcls_id smallint,
		fund_class_id smallint,
		rscat_id smallint
)
	DISTRIBUTED BY (uniq_id);	
	-- For all records check if data is modified/new


	
	INSERT INTO tmp_ref_revenue_source
	SELECT  a.uniq_id,
		a.fy,
		a.rsrc_cd, 
	       a.rsrc_nm,
		(CASE WHEN b.revenue_source_code IS NULL THEN 'N' ELSE 'Y' END) as exists_flag,
	       (CASE WHEN b.revenue_source_code IS NOT NULL AND a.rsrc_nm <> b.revenue_source_name THEN 'Y' ELSE 'N' END) as modified_flag,
	       a.rsrc_sh_nm,
	       a.act_fl,   
		a.alw_bud_fl, 
		a.oper_ind, 
		a.fasb_cls_ind,
		a.fhwa_rev_cr_fl, 
		a.usetax_coll_fl,
		a.rsrc_dscr,  
		a.apy_intr_lat_fee,
		a.apy_intr_admn_fee,
		a.apy_intr_nsf_fee,
		a.apy_intr_othr_fee,
		a.elg_inct_fl,
		a.earn_rcvb_cd, 
		a.fin_fee_ov_fl,
		a.apy_intr_ov,     
		a.bill_lag_dy,
		a.bill_freq,
		a.bill_fy_strt_mnth,
		a.bill_fy_strt_dy,
		a.fed_agcy_cd,
		a.fed_agcy_sfx,
		a.fed_nm,
		a.srsrc_req
	       	FROM   etl.stg_revenue_source a LEFT JOIN ref_revenue_source b ON a.rsrc_cd = b.revenue_source_code and a.fy= fiscal_year;




--For Populating temp with revenue class id

CREATE TEMPORARY TABLE temp_revenuesource_class_id(uniq_id bigint,rcls_cd varchar,rcls_id smallint)DISTRIBUTED BY (uniq_id); 

insert into temp_revenuesource_class_id  select b.uniq_id as uniq_id, a.revenue_class_code as revenue_class_code,a.revenue_class_id as revenue_class_id  from
 etl.stg_revenue_source b  left join   ref_revenue_class a on a.revenue_class_code = b.rscls_cd;

update tmp_ref_revenue_source a set rcls_id = b.rcls_id from temp_revenuesource_class_id b where a.uniq_id = b.uniq_id  ;




--For populating temp with funding_class_id

CREATE TEMPORARY TABLE temp_revenuesource_fund_class_id(uniq_id bigint,fund_class_cd varchar,fund_class_id smallint)DISTRIBUTED BY (uniq_id); 

insert into temp_revenuesource_fund_class_id  select b.uniq_id as uniq_id,a.funding_class_code as funding_class_code,a.funding_class_id as funding_class_id  from
 etl.stg_revenue_source b  left join   ref_funding_class a on a.funding_class_code = b.fund_cls;

update tmp_ref_revenue_source a set fund_class_id = b.fund_class_id from temp_revenuesource_fund_class_id b where a.uniq_id = b.uniq_id  ;




--For populating temp with revenue category
CREATE TEMPORARY TABLE temp_revenuesource_category_id(uniq_id bigint,rscat_cd varchar,rscat_id smallint)DISTRIBUTED BY (uniq_id); 

insert into temp_revenuesource_category_id select b.uniq_id, a.revenue_category_code as revenue_category_code,a.revenue_category_id as revenue_category_id from
etl.stg_revenue_source b left join ref_revenue_category a on a.revenue_category_code = b.rscat_cd;

update tmp_ref_revenue_source a set rscat_id = b.rscat_id from temp_revenuesource_category_id b where a.uniq_id = b.uniq_id ;

RAISE NOTICE 'RS -2';


	
	-- Generate the revenue source id for new records
		
	TRUNCATE etl.ref_revenue_source_id_seq;
	
	INSERT INTO etl.ref_revenue_source_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_ref_revenue_source
	WHERE  exists_flag ='N';



   RAISE NOTICE 'RS - 3';
	
	INSERT INTO ref_revenue_source(revenue_source_id,fiscal_year,revenue_source_code,revenue_source_name,revenue_source_short_name,description,
	funding_class_id,revenue_class_id,revenue_category_id,
	active_flag,budget_allowed_flag,operating_indicator,fasb_class_indicator,fhwa_revenue_credit_flag ,usetax_collection_flag ,
	apply_interest_late_fee ,apply_interest_admin_fee ,apply_interest_nsf_fee ,apply_interest_other_fee,eligible_intercept_process,
	earned_receivable_code,finance_fee_override_flag,allow_override_interest, billing_lag_days, billing_frequency , billing_fiscal_year_start_month ,
 	 billing_fiscal_year_start_day , federal_agency_code ,	 federal_agency_suffix , federal_name ,srsrc_req ,created_date)

	SELECT a.revenue_source_id,b.fy,b.rsrc_cd,b.rsrc_nm,
	        b.rsrc_sh_nm,
		b.rsrc_dscr,
		b.fund_class_id,
		b.rcls_id,
		b.rscat_id,
	        b.act_fl,   
		b.alw_bud_fl, 
		b.oper_ind, 
		b.fasb_cls_ind,
		b.fhwa_rev_cr_fl, 
		b.usetax_coll_fl,
		b.apy_intr_lat_fee,
		b.apy_intr_admn_fee,
		b.apy_intr_nsf_fee,
		b.apy_intr_othr_fee,
		b.elg_inct_fl,
		b.earn_rcvb_cd, 
		b.fin_fee_ov_fl,
		b.apy_intr_ov,     
		b.bill_lag_dy,
		b.bill_freq,
		b.bill_fy_strt_mnth,
		b.bill_fy_strt_dy,
		b.fed_agcy_cd,
		b.fed_agcy_sfx,
		b.fed_nm,
		b.srsrc_req,
		 now()::timestamp
	FROM   etl.ref_revenue_source_id_seq a JOIN tmp_ref_revenue_source b ON a.uniq_id = b.uniq_id;

	RAISE NOTICE 'RS - 4';

CREATE TEMPORARY TABLE tmp_ref_revenue_source_1(rsrc_nm varchar, revenue_source_id smallint)
	DISTRIBUTED BY (revenue_source_id);

	INSERT INTO tmp_ref_revenue_source_1
	SELECT a.rsrc_nm,b.revenue_source_id FROM tmp_ref_revenue_source a JOIN ref_revenue_source b ON a.rsrc_cd = b.revenue_source_code AND a.fy = b.fiscal_year
	WHERE exists_flag ='Y' and modified_flag='Y';


Raise notice '5';
	
	UPDATE ref_revenue_source a
	SET	revenue_source_name = b.rsrc_nm,
		updated_date = now()::timestamp,
		updated_load_id = p_load_id_in
	FROM	tmp_ref_revenue_source_1 b		
	WHERE	a.revenue_source_id = b.revenue_source_id;

	Return 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processrevenuesource';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
	
END;
$$ language plpgsql;



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processbudgetcode(p_load_file_id_in integer, p_load_id_in bigint)   RETURNS integer AS $$
DECLARE
BEGIN




CREATE TEMPORARY TABLE tmp_ref_budget_code
		(uniq_id bigint,fy integer,
		fcls_cd	varchar,
		fcls_nm	varchar,
		exists_flag char(1), modified_flag char(1),
		dept_cd	varchar,
		dept_nm	varchar,
		func_cd	varchar,
		func_nm	varchar,
		func_attr_nm varchar,
		func_attr_sh_nm varchar,
		resp_ctr varchar,
		func_anlys_unit varchar,
		cntrl_cat varchar,
		local_svc_dist varchar,
		ua_fund_fl bit(1),
		pyrl_dflt_fl bit(1),
		bud_cat_a varchar,
		bud_cat_b varchar,
		bud_func varchar,
		dscr_ext varchar,
		tbl_last_dt date,	
		func_attr_nm_up varchar,
		fin_plan_sav_fl bit(1),
		agency_id smallint,
		fund_class_id smallint
)
	DISTRIBUTED BY (uniq_id);	

	-- For all records check if data is modified/new


	
	
		INSERT INTO tmp_ref_budget_code
	
		SELECT  a.uniq_id,
			a.fy,
			a.fcls_cd, 
		       a.fcls_nm,
			(CASE WHEN b.budget_code IS NULL THEN 'N' ELSE 'Y' END) as exists_flag,
		       (CASE WHEN b.budget_code IS NOT NULL AND a.fcls_nm <> b.budget_code_name THEN 'Y' ELSE 'N' END) as modified_flag,
		       		a.dept_cd,
		       		a.dept_nm,
		       		a.func_cd,
		       		a.func_nm,
		       		a.func_attr_nm,
		       		a.func_attr_sh_nm,
		       		a.resp_ctr varchar,
		       		a.func_anlys_unit,
		       		a.cntrl_cat,
		       		a.local_svc_dist,
		       		a.ua_fund_fl ,
		       		a.pyrl_dflt_fl,
		       		a.bud_cat_a,
		       		a.bud_cat_b,
		       		a.bud_func,
		       		a.dscr_ext,
		       		a.tbl_last_dt,	
		       		a.func_attr_nm_up,
				a.fin_plan_sav_fl 
		       	FROM   etl.stg_budget_code a LEFT JOIN ref_budget_code b ON a.fcls_cd = b.budget_code and a.fy= fiscal_year;


--For Populating temp with agency _id
CREATE TEMPORARY TABLE temp_budgetcode_agency_id(uniq_id bigint,dept_cd varchar,agency_id smallint)DISTRIBUTED BY (uniq_id); 

insert into temp_budgetcode_agency_id  select b.uniq_id as uniq_id,a.agency_code as agency_code,a.agency_id as agency_id  from
 etl.stg_budget_code b  left join   ref_agency a on a.agency_code = b.dept_cd;

update tmp_ref_budget_code a set agency_id = b.agency_id from temp_budgetcode_agency_id b where a.uniq_id = b.uniq_id  ;



--For populating temp with fund_class_id

CREATE TEMPORARY TABLE temp_budgetcode_fund_class_id(uniq_id bigint,fund_class_cd varchar,fund_class_id smallint)DISTRIBUTED BY (uniq_id); 

insert into temp_budgetcode_fund_class_id  select b.uniq_id as uniq_id,a.fund_class_code as fund_class_code,a.fund_class_id as fund_class_id  from
 etl.stg_budget_code b  left join   ref_fund_class a on a.fund_class_code = b.fcls_cd;

update tmp_ref_budget_code a set fund_class_id = b.fund_class_id from temp_budgetcode_fund_class_id b where a.uniq_id = b.uniq_id  ;




RAISE NOTICE 'RS -2';


	
	-- Generate the budget code id for new records
		
	TRUNCATE etl.ref_budget_code_id_seq;
	INSERT INTO etl.ref_budget_code_id_seq(uniq_id)
		SELECT uniq_id
		FROM   tmp_ref_budget_code
	WHERE  exists_flag ='N';

	

   RAISE NOTICE 'RS - 3';
	
	INSERT INTO ref_budget_code( budget_code_id ,
					fiscal_year ,budget_code ,
					agency_id,fund_class_id,
					budget_code_name ,
					attribute_name ,
					attribute_short_name ,
					responsibility_center ,	
					control_category , 
					ua_funding_flag ,payroll_default_flag , 
					budget_function ,description , 
					 created_date  ,
					 load_id 
					 )
	
		SELECT a.budget_code_id,
				b.fy,b.func_cd,
				b.agency_id,
				b.fund_class_id,
				b.func_nm,
				b.func_attr_nm,
				b.func_attr_sh_nm,
				b.resp_ctr,
				b.cntrl_cat,
				b.ua_fund_fl ,b.pyrl_dflt_fl,
				b.bud_func,b.dscr_ext,
				now()::timestamp
				,p_load_id_in
			FROM   etl.ref_budget_code_id_seq a JOIN tmp_ref_budget_code b ON a.uniq_id = b.uniq_id ;
			
			


	RAISE NOTICE 'RS - 4';

CREATE TEMPORARY TABLE tmp_ref_budget_code_1(fcls_nm varchar, budget_code_id smallint)
	DISTRIBUTED BY (budget_code_id);

	INSERT INTO tmp_ref_budget_code_1
	SELECT a.fcls_nm,b.budget_code_id FROM tmp_ref_budget_code a JOIN ref_budget_code b ON a.fcls_cd = b.budget_code AND a.fy = b.fiscal_year
	WHERE exists_flag ='Y' and modified_flag='Y';

	
	UPDATE ref_budget_code a
	SET	budget_code_name = b.fcls_nm,
		updated_date = now()::timestamp,
		updated_load_id = p_load_id_in
	FROM	tmp_ref_budget_code_1 b		
	WHERE	a.budget_code_id = b.budget_code_id;


Return 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processrevenueclass';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;

	
END;

$$ language plpgsql;
