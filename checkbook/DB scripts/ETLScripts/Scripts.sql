CREATE FUNCTION concat(text, text) RETURNS text
    AS $$
  DECLARE
    t text;
  BEGIN
    IF  character_length($1) > 0 THEN
      t = $1 ||', '|| $2;
    ELSE
      t = $2;
    END IF;
    RETURN t;
  END;
  $$ language plpgsql;

CREATE AGGREGATE group_concat(text) (
    SFUNC = concat,
    STYPE = text,
    INITCOND = ''
);
-------------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION etl.stageandarchivedata(p_load_file_id_in int) RETURNS INT AS $$
DECLARE
	l_data_source_code ref_data_source.data_source_code%TYPE;
	l_staging_table_array varchar ARRAY[15];
	l_array_ctr smallint;
	l_target_columns varchar;
	l_source_columns varchar;
	l_data_feed_table varchar;
	l_record_identifiers varchar ARRAY[15];
	l_insert_sql varchar;
	l_document_type_array varchar ARRAY[15];
	l_load_id bigint;
	l_archive_table_array varchar ARRAY[15];
BEGIN

	-- Initialize all the variables
	l_data_source_code :='';
	l_target_columns :='';
	l_source_columns :='';
	l_data_feed_table :='';
	l_insert_sql :='';
	
	-- Determine the type of data load - F/V/A etc and assign it to l_data_source_code
	
	SELECT b.data_source_code , a.load_id
	FROM   etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id	       
	WHERE  a.load_file_id = p_load_file_id_in     
	INTO   l_data_source_code, l_load_id;	

	SELECT staging_table_name
	FROM etl.ref_data_source
	WHERE data_source_code=l_data_source_code
	      AND table_order =1
	INTO l_data_feed_table;

	raise notice 'staging table %',l_data_feed_table;
	
	SELECT ARRAY(SELECT staging_table_name
		     FROM etl.ref_data_source
		     WHERE data_source_code=l_data_source_code
			   AND table_order > 1
		     ORDER BY table_order) INTO l_staging_table_array;

	SELECT ARRAY(SELECT archive_table_name
		     FROM etl.ref_data_source
		     WHERE data_source_code=l_data_source_code
			   AND table_order > 1
		     ORDER BY table_order) INTO l_archive_table_array;
		     
	SELECT ARRAY(SELECT record_identifier
		     FROM etl.ref_data_source
		     WHERE data_source_code=l_data_source_code
			   AND table_order > 1
		     ORDER BY table_order) INTO l_record_identifiers;	
		
	SELECT ARRAY(SELECT document_type
		     FROM etl.ref_data_source
		     WHERE data_source_code=l_data_source_code
			   AND table_order > 1
		     ORDER BY table_order) INTO l_document_type_array;
		     		     
	FOR l_array_ctr IN 1..array_upper(l_staging_table_array,1) LOOP
		RAISE NOTICE '%', l_staging_table_array[l_array_ctr];
		

		SELECT array_to_string(ARRAY(SELECT staging_column_name 
					     FROM etl.ref_column_mapping 
					     WHERE staging_table_name=l_staging_table_array[l_array_ctr]						   
					     ORDER BY column_order),',')
		INTO l_target_columns;

	raise notice 'target columns %', l_target_columns;
	
		SELECT array_to_string(ARRAY(SELECT (CASE WHEN staging_data_type in ('varchar','bpchar') THEN
							data_feed_column_name || ' AS ' || staging_column_name 
							WHEN staging_data_type = 'int' or  staging_data_type like 'numeric%' THEN
								CASE
									WHEN data_feed_data_type = staging_data_type THEN
										data_feed_column_name || ' AS ' || staging_column_name 
									ELSE	
										'(CASE WHEN ' || data_feed_column_name || ' ='''' THEN NULL ELSE  ' || data_feed_column_name || '::' || staging_data_type || ' END ) AS ' ||  staging_column_name 
								END
							WHEN staging_data_type = 'date' THEN
								'(case when ' || data_feed_column_name || ' ='''' THEN NULL ELSE '|| data_feed_column_name || '::date END ) AS ' || staging_column_name 
							WHEN staging_data_type = 'timestamp' THEN
								'(case when ' || data_feed_column_name || ' ='''' THEN NULL ELSE '|| data_feed_column_name || '::timestamp END ) AS ' || staging_column_name 
							ELSE
								data_feed_column_name || ' AS ' || staging_column_name
						END)	
						FROM etl.ref_column_mapping 
						WHERE staging_table_name=l_staging_table_array[l_array_ctr]
						ORDER BY column_order),',')	
		INTO l_source_columns;					

		raise notice 'source columns %', l_source_columns;

		l_insert_sql := 'INSERT INTO ' || l_staging_table_array[l_array_ctr] || '(' || l_target_columns || ')' ||
				'SELECT ' || l_source_columns ||
				' FROM ' || l_data_feed_table;				

		IF COALESCE(l_record_identifiers[l_array_ctr],'') <> '' THEN
			l_insert_sql := l_insert_sql || ' WHERE record_type = ''' || l_record_identifiers[l_array_ctr] || ''' ';
		END IF;
		
		IF COALESCE(l_document_type_array[l_array_ctr] ,'') <> '' THEN
			l_insert_sql := l_insert_sql || ' AND doc_cd IN (''' || replace (l_document_type_array[l_array_ctr],',',''',''') || ''') ';
		END IF;

		raise notice 'l_insert_sql %',l_insert_sql;
		
		EXECUTE 'TRUNCATE ' || l_staging_table_array[l_array_ctr];
		
		EXECUTE l_insert_sql;				

		-- Archiving the records
		
		IF COALESCE(l_archive_table_array[l_array_ctr],'') <> ''  THEN

			RAISE NOTICE 'INSIDE';

			
			l_insert_sql :=  'INSERT INTO ' || l_archive_table_array[l_array_ctr] ||
					 ' SELECT *,' || l_load_id ||
					 ' FROM ' ||l_staging_table_array[l_array_ctr] ;

			RAISE NOTICE 'insert %',l_insert_sql;
			
			EXECUTE l_insert_sql;															
			
		END IF;
	END LOOP; 
	
	return 1;
END;
$$ language plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.validatedata(p_load_file_id_in int) RETURNS INT AS $$
DECLARE
	l_data_source_code etl.ref_data_source.data_source_code%TYPE;
	l_rule	RECORD;
	l_update_str VARCHAR;
	l_insert_str VARCHAR;
	l_select_str VARCHAR;
	l_delete_str VARCHAR;
	l_all_uniq_id VARCHAR;
	l_min_uniq_id VARCHAR;
	l_where_clause VARCHAR;
	l_load_id bigint;
	l_staging_table_array varchar ARRAY[15];
	l_invalid_table_array varchar ARRAY[15];
	l_array_ctr smallint;	
		
BEGIN

	-- Initialize the variables
	l_update_str :='';
	l_insert_str :='';
	l_delete_str :='';
	l_select_str :='';
	l_all_uniq_id :='';
	l_min_uniq_id :='';
	l_where_clause :='';
	
	-- Determine the type of data load - F/V/A etc and assign it to l_data_source_code
	
	SELECT b.data_source_code , a.load_id
	FROM   etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id	       
	WHERE  a.load_file_id = p_load_file_id_in     
	INTO   l_data_source_code, l_load_id;	

	CREATE TEMPORARY TABLE tmp_invalid_uniq_id(uniq_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	For l_rule IN SELECT a.record_identifier,a.document_type,a.staging_table_name, b.rule_name,b.parent_table_name,
			     b.component_table_name,b.staging_column_name,b.transaction_table_name,b.ref_table_name,b.ref_column_name,
			     b.invalid_condition
		      FROM   etl.ref_data_source a, etl.ref_validation_rule b
		      WHERE  a.data_source_code = b.data_source_code
			     AND COALESCE(a.record_identifier,'')=COALESCE(b.record_identifier,'')
		      	     AND a.data_source_code=l_data_source_code
		      	     AND a.table_order>1
		      ORDER BY b.rule_order
		      
	LOOP
		RAISE NOTICE 'rule name: %', l_rule.rule_name;
		-- Missing key elements		
		IF l_rule.rule_name = 'Missing key elements' THEN

			l_select_str :=  ' select array_to_string( ' || 
					 '	 array( ' || 
					 '		select (case when staging_data_type =''varchar'' then '' coalesce(''||staging_column_name||'','''''''')='''''''' '' ' || 
					 '			    when staging_data_type =''int'' or staging_data_type like ''numeric%'' then '' coalesce(''||staging_column_name||'',0)=0 '' ' || 
					 '			    when staging_data_type =''date'' then '' coalesce(''||staging_column_name||'',''''2000-01-01'''')=''''2000-01-01'''' '' ' || 
					 '		       end) as sql_condition ' || 
					 '		from etl.ref_column_mapping ' || 
					 '		where staging_table_name = ''' || l_rule.staging_table_name||''' ' || 
					 '			AND staging_column_name IN (''' || replace(l_rule.staging_column_name,',',''',''') ||''' )' ||
					 '		order by column_order )  ,''OR'') ';

			RAISE notice 'l_select_str %',l_select_str;
			EXECUTE l_select_str INTO l_where_clause;
			-- RAISE notice 'where %',l_where_clause;
			
			l_update_str := 'UPDATE ' || l_rule.staging_table_name ||
					' SET invalid_flag = ''Y'', ' ||
					'	invalid_reason =''' || l_rule.rule_name || ''' ' ||
					'WHERE COALESCE(invalid_flag,'''')=''''  AND ' || l_where_clause ;		

			RAISE NOTICE 'l_update_str %',l_update_str;
			
			EXECUTE l_update_str;		
		END IF;

		-- Duplicate records
		
		IF l_rule.rule_name  IN ('Duplicate', 'Multiple') THEN
			--RAISE NOTICE 'select %', l_rule.staging_column_name;
			
			l_select_str := ' SELECT group_concat(all_uniq_id) as all_uniq_id, group_concat(min_uniq_id) as min_uniq_id ' ||
					' FROM ' || 
					' (SELECT ' || l_rule.staging_column_name || ',count(uniq_id) as num_records , min(uniq_id) as min_uniq_id, group_concat(uniq_id) as all_uniq_id' ||
					' FROM ' || l_rule.staging_table_name ||
					' GROUP BY ' || l_rule.staging_column_name ||
					' HAVING count(uniq_id) > 1 ) as a';

			RAISE NOTICE 'select %', l_select_str;
			
			EXECUTE	l_select_str INTO l_all_uniq_id, l_min_uniq_id;

			IF COALESCE(l_all_uniq_id,'') <> '' THEN
				l_update_str := 'UPDATE '|| l_rule.staging_table_name ||
						' SET invalid_flag = ''Y'', ' ||
						'	invalid_reason =''' || l_rule.rule_name || ''' ' ||
						' WHERE uniq_id IN (' || l_all_uniq_id || ')' || 
						' AND uniq_id NOT IN (' || l_min_uniq_id || ')';

				RAISE NOTICE 'l_update_str %',l_update_str;
				
				EXECUTE l_update_str;		
			END IF; 	
		END IF;


		
		IF l_rule.rule_name like 'Invalid%' THEN 

			EXECUTE 'TRUNCATE tmp_invalid_uniq_id ';
			
			-- Invalid Parent/Component		
			IF (COALESCE(l_rule.parent_table_name,'') <> '' OR COALESCE(l_rule.component_table_name,'') <> '' ) THEN

				

				l_select_str :=  ' select array_to_string( ' || 
						 '	 array( ' || 
						 '		select (case when staging_data_type =''varchar'' then '' coalesce(''||staging_column_name||'','''''''') '' ' || 
						 '			    when staging_data_type =''int'' or staging_data_type like ''numeric%'' then '' coalesce(''||staging_column_name||'',0) '' ' || 
						 '			    when staging_data_type =''date'' then '' coalesce(''||staging_column_name||'',''''2000-01-01'''') '' ' || 
						 '		       end) as sql_condition ' || 
						 '		from etl.ref_column_mapping ' || 
						 '		where staging_table_name = ''' || l_rule.staging_table_name||''' ' ||
						 '			AND staging_column_name IN (''' || replace(l_rule.staging_column_name,',',''',''') ||''' )' ||
						 '		order by column_order )  ,''|| ''''~'''' ||'') ';

				RAISE notice 'l_select_str %',l_select_str;
				EXECUTE l_select_str INTO l_where_clause;
				RAISE notice 'where %',l_where_clause;
				

				l_where_clause := l_where_clause || '  IN (SELECT ' || l_where_clause || 
									     ' FROM ' || COALESCE( l_rule.parent_table_name,l_rule.component_table_name) || 
									     ' WHERE invalid_flag = ''Y'' and invalid_reason <> ''Duplicate'') ';
				

			ELSIF (l_rule.ref_table_name,'') <> '' THEN
				-- Invalid values (Not in the reference table )
				l_where_clause := l_rule.staging_column_name || ' NOT IN (SELECT ' || l_rule.ref_column_name || 
										'	  FROM ' || l_rule.ref_table_name || ' ) ';

										
			ELSE
				-- Inconsistent values. Invalid condition must definitely have a value

				l_where_clause := l_rule.invalid_condition;
					
			END IF;	

			l_insert_str := 'INSERT INTO tmp_invalid_uniq_id(uniq_id) '||
					' SELECT uniq_id ' ||
					' FROM ' || l_rule.staging_table_name ||
					' WHERE COALESCE(invalid_flag,'''')='''' AND ' || l_where_clause ;		

			RAISE notice 'l_insert_str %',l_insert_str;		
			EXECUTE l_insert_str;
				
			l_update_str := 'UPDATE ' || l_rule.staging_table_name || ' a' ||
					' SET invalid_flag = ''Y'', ' ||
					'	invalid_reason =''' || l_rule.rule_name || ''' ' ||
					' FROM tmp_invalid_uniq_id b ' || 
					'WHERE a.uniq_id = b.uniq_id ' ;		
				
			EXECUTE l_update_str;				
		END IF;

		IF (l_rule.rule_name like 'Missing%' AND l_rule.rule_name <> 'Missing key elements') THEN

			EXECUTE 'TRUNCATE tmp_invalid_uniq_id ';

			l_select_str :=  ' select array_to_string( ' || 
					 '	 array( ' || 
					 '		select (case when staging_data_type =''varchar'' then '' coalesce(''||staging_column_name||'','''''''') '' ' || 
					 '			    when staging_data_type =''int'' or staging_data_type like ''numeric%'' then '' coalesce(''||staging_column_name||'',0) '' ' || 
					 '			    when staging_data_type =''date'' then '' coalesce(''||staging_column_name||'',''''2000-01-01'''') '' ' || 
					 '		       end) as sql_condition ' || 
					 '		from etl.ref_column_mapping ' || 
					 '		where staging_table_name = ''' || l_rule.staging_table_name||''' ' ||
					 '			AND staging_column_name IN (''' || replace(l_rule.staging_column_name,',',''',''') ||''' )' ||
					 '		order by column_order )  ,''|| ''''~'''' ||'') ';

			--RAISE notice 'l_select_str %',l_select_str;
			EXECUTE l_select_str INTO l_where_clause;
			 --RAISE notice 'where %',l_where_clause;
			

			l_where_clause := l_where_clause || ' NOT IN (SELECT ' || l_where_clause || 
								     ' FROM ' || COALESCE( l_rule.parent_table_name,l_rule.component_table_name) || ')';
			
			l_insert_str := 'INSERT INTO tmp_invalid_uniq_id(uniq_id) '||
					' SELECT uniq_id ' ||
					' FROM ' || l_rule.staging_table_name ||
					' WHERE COALESCE(invalid_flag,'''')='''' AND ' || l_where_clause ;		

			RAISE notice 'l_insert_str %',l_insert_str;		
			EXECUTE l_insert_str;
			
			l_update_str := 'UPDATE ' || l_rule.staging_table_name || ' a' ||
					' SET invalid_flag = ''Y'', ' ||
					'	invalid_reason =''' || l_rule.rule_name || ''' ' ||
					' FROM tmp_invalid_uniq_id b ' || 
					'WHERE a.uniq_id = b.uniq_id ' ;		
			
			EXECUTE l_update_str;	
						
		END IF;
		
		
		IF l_rule.rule_name = 'Inter-load duplicate' THEN

			EXECUTE 'TRUNCATE tmp_invalid_uniq_id ';

			l_insert_str := ' INSERT INTO tmp_invalid_uniq_id ' || 
					' SELECT uniq_id ' || 
					' FROM ' || l_rule.staging_table_name || ',' || l_rule.ref_table_name || ',' || l_rule.transaction_table_name || 
					' WHERE ' || l_rule.invalid_condition ;

					
			EXECUTE l_insert_str;
			
			l_update_str := 'UPDATE ' || l_rule.staging_table_name || ' a' ||
					' SET invalid_flag = ''Y'', ' ||
					'	invalid_reason =''' || l_rule.rule_name || ''' ' ||
					' FROM tmp_invalid_uniq_id b ' || 
					'WHERE a.uniq_id = b.uniq_id ' ;		
			
			EXECUTE l_update_str;	
								
		END IF;
	
	END LOOP;
	
	-- Copying the invalid records to invalid table and deleting the same from the staging table
	
	SELECT ARRAY(SELECT staging_table_name
		     FROM etl.ref_data_source
		     WHERE data_source_code=l_data_source_code
			   AND table_order > 1
		     ORDER BY table_order) INTO l_staging_table_array;

	SELECT ARRAY(SELECT invalid_table_name
		     FROM etl.ref_data_source
		     WHERE data_source_code=l_data_source_code
			   AND table_order > 1
		     ORDER BY table_order) INTO l_invalid_table_array;
		     

	FOR l_array_ctr IN 1..array_upper(l_staging_table_array,1) LOOP
	
		IF COALESCE(l_invalid_table_array[l_array_ctr],'') <> ''  THEN

			RAISE NOTICE 'INSIDE';

			
			l_insert_str :=  'INSERT INTO ' || l_invalid_table_array[l_array_ctr] ||
					 ' SELECT *,' || l_load_id ||
					 ' FROM ' ||l_staging_table_array[l_array_ctr] ||
					 ' WHERE invalid_flag = ''Y'' ';

			RAISE NOTICE 'insert %',l_insert_str;
			
			EXECUTE l_insert_str;															
			
		END IF;	
		
		l_delete_str := ' DELETE FROM ' || l_staging_table_array[l_array_ctr] ||
				' WHERE invalid_flag = ''Y'' ';

		EXECUTE l_delete_str;			
	END LOOP;

		     
	
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in validatedatanew';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processdata(p_load_file_id_in int) RETURNS INT AS $$
DECLARE
	l_data_source_code etl.ref_data_source.data_source_code%TYPE;
	l_load_id bigint;
	l_processed int;	
BEGIN

	-- Determine the type of data load - F/V/A etc and assign it to l_data_source_code
	
	SELECT b.data_source_code , a.load_id
	FROM   etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id	       
	WHERE  a.load_file_id = p_load_file_id_in     
	INTO   l_data_source_code, l_load_id;	
	
	IF l_data_source_code ='A' THEN
		l_processed := etl.processCOAAgency(p_load_file_id_in,l_load_id);
	END IF;
	
	RETURN 1;

EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processdata';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

-----------------------------------------------------------------------------------------------------------------------------------------------

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
	
	INSERT INTO ref_agency(agency_id,agency_code,agency_name,created_date,created_load_id)
	SELECT a.agency_id,b.agency_code,b.agency_name,now()::timestamp,p_load_id_in
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
		updated_load_id = p_load_id_in
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