/* Functions defined
	stageandarchivedata
	validatedata	
	processdata
	isEligibleForConsumption
	errorhandler
*/

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
	l_processed_flag etl.etl_data_load_file.processed_flag%TYPE;
	l_job_id etl.etl_data_load.job_id%TYPE;
	l_exception int;
	l_start_time  timestamp;
	l_end_time  timestamp;
	l_ins_staging_cnt int:=0;
	l_count int:=0;
BEGIN

	-- Initialize all the variables

	l_start_time := timeofday()::timestamp;
	
	l_data_source_code :='';
	l_target_columns :='';
	l_source_columns :='';
	l_data_feed_table :='';
	l_insert_sql :='';
	
	-- Determine the type of data load - F/V/A etc and assign it to l_data_source_code
	
	SELECT b.data_source_code , a.load_id,a.processed_flag,b.job_id
	FROM   etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id	       
	WHERE  a.load_file_id = p_load_file_id_in     
	INTO   l_data_source_code, l_load_id,l_processed_flag, l_job_id;	

	IF l_processed_flag ='N' THEN 
		SELECT staging_table_name
		FROM etl.ref_data_source
		WHERE data_source_code=l_data_source_code
		      AND table_order =1
		INTO l_data_feed_table;

		-- raise notice 'staging table %',l_data_feed_table;

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

			-- raise notice 'target columns %', l_target_columns;

			SELECT array_to_string(ARRAY(SELECT (CASE WHEN staging_data_type in ('varchar','bpchar') THEN
								data_feed_column_name || ' AS ' || staging_column_name 
								WHEN staging_data_type = 'int' or staging_data_type = 'smallint' OR staging_data_type like 'numeric%' THEN
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
								WHEN staging_data_type = 'bit' THEN	
									'(CASE WHEN ' || data_feed_column_name || ' =''1'' THEN 1::bit ELSE 0::bit END)'
								ELSE
									data_feed_column_name || ' AS ' || staging_column_name
							END)	
							FROM etl.ref_column_mapping 
							WHERE staging_table_name=l_staging_table_array[l_array_ctr]
							ORDER BY column_order),',')	
			INTO l_source_columns;					

			-- raise notice 'source columns %', l_source_columns;

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

		GET DIAGNOSTICS l_count = ROW_COUNT;

		l_ins_staging_cnt := l_count;

		INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,record_identifier,document_type,num_transactions,description)
		VALUES(p_load_file_id_in,l_data_source_code,l_record_identifiers[l_array_ctr],l_document_type_array[l_array_ctr],l_ins_staging_cnt, 'staging');
		
			-- Archiving the records

			IF COALESCE(l_archive_table_array[l_array_ctr],'') <> ''  THEN

				RAISE NOTICE 'INSIDE';


				l_insert_sql :=  'INSERT INTO ' || l_archive_table_array[l_array_ctr] ||
						 ' SELECT *,' || p_load_file_id_in ||
						 ' FROM ' ||l_staging_table_array[l_array_ctr] ;

				-- RAISE NOTICE 'insert %',l_insert_sql;

				EXECUTE l_insert_sql;															

			END IF;
		END LOOP; 

	-- Updating the processed flag to S to indicate that the data is staged.	
	
	UPDATE  etl.etl_data_load_file
	SET	processed_flag ='S' 
	WHERE	load_file_id = p_load_file_id_in;
			
	END IF;

	l_end_time := timeofday()::timestamp;

	INSERT INTO etl.etl_script_execution_status(load_file_id,script_name,completed_flag,start_time,end_time)
	VALUES(p_load_file_id_in,'etl.stageandarchivedata',1,l_start_time,l_end_time);
		
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	
	RAISE NOTICE 'Exception Occurred in stageandarchivedata';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	


	-- l_exception :=  etl.errorhandler(l_job_id,l_data_source_code,l_load_id,p_load_file_id_in);
	
	l_end_time := timeofday()::timestamp;
	INSERT INTO etl.etl_script_execution_status(load_file_id,script_name,completed_flag,start_time,end_time,errno,errmsg)
	VALUES(p_load_file_id_in,'etl.stageandarchivedata',0,l_start_time,l_end_time,SQLSTATE,SQLERRM);
	
	RETURN 0;
	
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
		RAISE NOTICE 'staging table name: %', l_rule.staging_table_name;
		-- Missing key elements		
		IF l_rule.rule_name = 'Missing key elements' THEN

			l_select_str :=  ' select array_to_string( ' || 
					 '	 array( ' || 
					 '		select (case when staging_data_type =''varchar'' then '' coalesce(''||staging_column_name||'','''''''')='''''''' '' ' || 
					 '			    when staging_data_type =''int'' or staging_data_type =''smallint'' or staging_data_type like ''numeric%'' then '' coalesce(''||staging_column_name||'',0)=0 '' ' || 
					 '			    when staging_data_type =''date'' then '' coalesce(''||staging_column_name||'',''''2000-01-01'''')=''''2000-01-01'''' '' ' || 
					 '		       end) as sql_condition ' || 
					 '		from etl.ref_column_mapping ' || 
					 '		where staging_table_name = ''' || l_rule.staging_table_name||''' ' || 
					 '			AND staging_column_name IN (''' || replace(l_rule.staging_column_name,',',''',''') ||''' )' ||
					 '		order by column_order )  ,''OR'') ';

			-- RAISE notice 'l_select_str %',l_select_str;
			EXECUTE l_select_str INTO l_where_clause;
			-- RAISE notice 'where %',l_where_clause;
			
			IF COALESCE(l_rule.invalid_condition,'') <> '' THEN
				l_where_clause := l_where_clause || 'OR (' || l_rule.invalid_condition || ')';
			END IF;
			
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

			--RAISE NOTICE 'select %', l_select_str;
			
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

				
				RAISE NOTICE 'Inside invalid check 1.1';
				/*l_select_str :=  ' select array_to_string( ' || 
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
				*/
				
				l_select_str :=  ' select array_to_string( ' || 
						 '	 array( ' || 
						 '		select (case when staging_data_type =''varchar'' then '' coalesce(a.''||staging_column_name||'','''''''') = coalesce(b.''||staging_column_name||'','''''''') '' ' || 
						 '			    when staging_data_type =''int'' or staging_data_type like ''numeric%'' then '' coalesce(a.''||staging_column_name||'',0) = coalesce(b.''||staging_column_name||'',0) '' ' || 
						 '			    when staging_data_type =''date'' then '' coalesce(a.''||staging_column_name||'',''''2000-01-01'''') = coalesce(b.''||staging_column_name||'',''''2000-01-01'''') '' ' || 
						 '		       end) as sql_condition ' || 
						 '		from etl.ref_column_mapping ' || 
						 '		where staging_table_name = ''' || l_rule.staging_table_name||''' ' ||
						 '			AND staging_column_name IN (''' || replace(l_rule.staging_column_name,',',''',''') ||''' )' ||
						 '		order by column_order )  ,''|| ''''~'''' ||'') ';

				-- RAISE notice 'l_select_str %',l_select_str;
				EXECUTE l_select_str INTO l_where_clause;
				-- RAISE notice 'where %',l_where_clause;		

				/*l_where_clause := l_where_clause || '  IN (SELECT ' || l_where_clause || 
									     ' FROM ' || COALESCE( l_rule.parent_table_name,l_rule.component_table_name) || 
									     ' WHERE invalid_flag = ''Y'' and invalid_reason <> ''Duplicate'') ';
				*/
				
				l_insert_str := 'INSERT INTO tmp_invalid_uniq_id(uniq_id) '||
						' SELECT a.uniq_id ' ||
						' FROM ' || l_rule.staging_table_name ||' a JOIN ' || COALESCE(l_rule.parent_table_name,l_rule.component_table_name ) || ' b ' ||
						' ON ' || l_where_clause || 
						' WHERE b.invalid_flag =''Y''  '||
						'	AND b.invalid_reason <> ''Duplicate'' '||
						'	AND COALESCE(a.invalid_flag,'''')='''' ' ||
						'	AND b.invalid_reason not like ''Invalid component -%'' ';
						
						 

			ELSIF COALESCE(l_rule.ref_table_name,'') <> '' THEN
				RAISE NOTICE 'Inside invalid check 1.2';
				-- Invalid values (Not in the reference table )
				l_where_clause := l_rule.staging_column_name || ' NOT IN (SELECT ' || l_rule.ref_column_name || 
										'	  FROM ' || l_rule.ref_table_name || ' ) ';

				l_insert_str := 'INSERT INTO tmp_invalid_uniq_id(uniq_id) '||
						' SELECT uniq_id ' ||
						' FROM ' || l_rule.staging_table_name ||
						' WHERE COALESCE(invalid_flag,'''')='''' AND ' || l_where_clause ;		

			ELSE
				-- Inconsistent values. Invalid condition must definitely have a value
				RAISE NOTICE 'Inside inconsistent';
				l_where_clause := l_rule.invalid_condition;										
				

				l_insert_str := 'INSERT INTO tmp_invalid_uniq_id(uniq_id) '||
						' SELECT uniq_id ' ||
						' FROM ' || l_rule.staging_table_name ||
						' WHERE COALESCE(invalid_flag,'''')='''' AND ' || l_where_clause ;		
					
			END IF;	


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

			/*
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
			*/
			
			l_select_str :=  ' select array_to_string( ' || 
					 '	 array( ' || 
					 '		select (case when staging_data_type =''varchar'' then '' coalesce(a.''||staging_column_name||'','''''''') =coalesce(b.''||staging_column_name||'','''''''') '' ' || 
					 '			    when staging_data_type =''int'' or staging_data_type like ''numeric%'' then '' coalesce(a.''||staging_column_name||'',0) = coalesce(b.''||staging_column_name||'',0) '' ' || 
					 '			    when staging_data_type =''date'' then '' coalesce(a.''||staging_column_name||'',''''2000-01-01'''') = coalesce(b.''||staging_column_name||'',''''2000-01-01'''') '' ' || 
					 '		       end) as sql_condition ' || 
					 '		from etl.ref_column_mapping ' || 
					 '		where staging_table_name = ''' || l_rule.staging_table_name||''' ' ||
					 '			AND staging_column_name IN (''' || replace(l_rule.staging_column_name,',',''',''') ||''' )' ||
					 '		order by column_order )  ,''AND'') ';


			--RAISE notice 'l_select_str %',l_select_str;
			EXECUTE l_select_str INTO l_where_clause;
			 --RAISE notice 'where %',l_where_clause;
			

			/* l_where_clause := l_where_clause || ' NOT IN (SELECT ' || l_where_clause || 
								     ' FROM ' || COALESCE( l_rule.parent_table_name,l_rule.component_table_name) || ')';
			
			*/
			
			l_insert_str := 'INSERT INTO tmp_invalid_uniq_id(uniq_id) '||
					' SELECT a.uniq_id ' ||
					' FROM ' || l_rule.staging_table_name ||' a LEFT JOIN ' || COALESCE(l_rule.parent_table_name,l_rule.component_table_name ) || ' b ' ||
					' ON ' || l_where_clause || 
					' WHERE b.uniq_id IS NULL ';
						
			/* l_insert_str := 'INSERT INTO tmp_invalid_uniq_id(uniq_id) '||
					' SELECT uniq_id ' ||
					' FROM ' || l_rule.staging_table_name ||
					' WHERE COALESCE(invalid_flag,'''')='''' AND ' || l_where_clause ;		
			*/
			
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


-----------------------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION etl.processdata(p_load_file_id_in integer)
  RETURNS integer AS
$BODY$
DECLARE
	l_data_source_code etl.ref_data_source.data_source_code%TYPE;
	l_load_id bigint;
	l_processed int;	
	l_processed_flag etl.etl_data_load_file.processed_flag%TYPE;
	l_job_id etl.etl_data_load.job_id%TYPE;
	l_exception int;
	l_start_time  timestamp;
	l_end_time  timestamp;
	
BEGIN

	l_start_time := timeofday()::timestamp;
	
	-- Determine the type of data load - F/V/A etc and assign it to l_data_source_code
	
	SELECT b.data_source_code , a.load_id,a.processed_flag,b.job_id
	FROM   etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id	       
	WHERE  a.load_file_id = p_load_file_id_in     
	INTO   l_data_source_code, l_load_id,l_processed_flag, l_job_id;
	
	IF l_processed_flag ='V' THEN
	
		IF l_data_source_code ='A' THEN
			l_processed := etl.processCOAAgency(p_load_file_id_in,l_load_id);

		ELSIF 	l_data_source_code ='D' THEN
			l_processed := etl.processCOADepartment(p_load_file_id_in,l_load_id);

		ELSIF 	l_data_source_code ='E' THEN
			l_processed := etl.processCOAExpenditureObject(p_load_file_id_in,l_load_id);

		ELSIF 	l_data_source_code ='L' THEN
			l_processed := etl.processCOALocation(p_load_file_id_in,l_load_id);

		ELSIF 	l_data_source_code ='O' THEN
			l_processed := etl.processCOAObjectClass(p_load_file_id_in,l_load_id);	

		ELSIF 	l_data_source_code ='V' THEN
			l_processed := etl.processFMSVVendor(p_load_file_id_in,l_load_id);	

		ELSIF 	l_data_source_code ='C' THEN
			l_processed := etl.processCon(p_load_file_id_in,l_load_id);
			
		ELSIF 	l_data_source_code ='RC' THEN
			l_processed := etl.processrevenueclass(p_load_file_id_in,l_load_id);	
			
		ELSIF 	l_data_source_code ='RC' THEN
			l_processed := etl.processrevenueclass(p_load_file_id_in,l_load_id);	

		ELSIF 	l_data_source_code ='RY' THEN
			l_processed := etl.processrevenuecategory(p_load_file_id_in,l_load_id);	
			
		ELSIF 	l_data_source_code ='RS' THEN
			l_processed := etl.processrevenuesource(p_load_file_id_in,l_load_id);	

		ELSIF 	l_data_source_code ='BC' THEN
			l_processed := etl.processbudgetcode(p_load_file_id_in,l_load_id);	
		END IF;

	-- Updating the processed flag to Y to indicate that the data is posted to the transaction table.
	
	RAISE NOTICE 'l_processed %',l_processed;
	
	UPDATE  etl.etl_data_load_file
	SET	processed_flag ='Y' 
	WHERE	load_file_id = p_load_file_id_in;
			
	END IF;

	l_end_time := timeofday()::timestamp;

	INSERT INTO etl.etl_script_execution_status(load_file_id,script_name,completed_flag,start_time,end_time)
	VALUES(p_load_file_id_in,'etl.processdata',1,l_start_time,l_end_time);
		
	RETURN 1;

EXCEPTION

	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processdata';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	-- l_exception := etl.errorhandler(l_job_id,l_data_source_code,l_load_id,p_load_file_id_in);
	l_end_time := timeofday()::timestamp;
	
	INSERT INTO etl.etl_script_execution_status(load_file_id,script_name,completed_flag,start_time,end_time,errno,errmsg)
	VALUES(p_load_file_id_in,'etl.processdata',0,l_start_time,l_end_time,SQLSTATE,SQLERRM);
	
	RETURN 0;
END;


$$ language plpgsql;
-----------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processdata(p_load_file_id_in int) RETURNS INT AS $$
DECLARE
	l_data_source_code etl.ref_data_source.data_source_code%TYPE;
	l_load_id bigint;
	l_processed int;	
	l_processed_flag etl.etl_data_load_file.processed_flag%TYPE;
	l_job_id etl.etl_data_load.job_id%TYPE;
	l_exception int;
	l_start_time  timestamp;
	l_end_time  timestamp;
	
BEGIN

	l_start_time := timeofday()::timestamp;
	
	-- Determine the type of data load - F/V/A etc and assign it to l_data_source_code
	
	SELECT b.data_source_code , a.load_id,a.processed_flag,b.job_id
	FROM   etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id	       
	WHERE  a.load_file_id = p_load_file_id_in     
	INTO   l_data_source_code, l_load_id,l_processed_flag, l_job_id;
	
	IF l_processed_flag ='V' THEN
	
		IF l_data_source_code ='A' THEN
			l_processed := etl.processCOAAgency(p_load_file_id_in,l_load_id);

		ELSIF 	l_data_source_code ='D' THEN
			l_processed := etl.processCOADepartment(p_load_file_id_in,l_load_id);

		ELSIF 	l_data_source_code ='E' THEN
			l_processed := etl.processCOAExpenditureObject(p_load_file_id_in,l_load_id);

		ELSIF 	l_data_source_code ='L' THEN
			l_processed := etl.processCOALocation(p_load_file_id_in,l_load_id);

		ELSIF 	l_data_source_code ='O' THEN
			l_processed := etl.processCOAObjectClass(p_load_file_id_in,l_load_id);	

		ELSIF 	l_data_source_code ='V' THEN
			l_processed := etl.processFMSVVendor(p_load_file_id_in,l_load_id);	

		ELSIF 	l_data_source_code ='C' THEN
			l_processed := etl.processCon(p_load_file_id_in,l_load_id);
			
		ELSIF 	l_data_source_code ='RC' THEN
			l_processed := etl.processrevenueclass(p_load_file_id_in,l_load_id);	

		ELSIF 	l_data_source_code ='B' THEN
			l_processed := etl.processbudget(p_load_file_id_in,l_load_id);

		ELSIF 	l_data_source_code ='RY' THEN
			l_processed := etl.processrevenuecategory(p_load_file_id_in,l_load_id);	
			
		ELSIF 	l_data_source_code ='RS' THEN
			l_processed := etl.processrevenuesource(p_load_file_id_in,l_load_id);	
			
		END IF;

	-- Updating the processed flag to Y to indicate that the data is posted to the transaction table.
	
	UPDATE  etl.etl_data_load_file
	SET	processed_flag ='Y' 
	WHERE	load_file_id = p_load_file_id_in;
			
	END IF;

	l_end_time := timeofday()::timestamp;

	INSERT INTO etl.etl_script_execution_status(load_file_id,script_name,completed_flag,start_time,end_time)
	VALUES(p_load_file_id_in,'etl.processdata',1,l_start_time,l_end_time);
		
	RETURN 1;

EXCEPTION

	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processdata';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	-- l_exception := etl.errorhandler(l_job_id,l_data_source_code,l_load_id,p_load_file_id_in);
	l_end_time := timeofday()::timestamp;
	
	INSERT INTO etl.etl_script_execution_status(load_file_id,script_name,completed_flag,start_time,end_time,errno,errmsg)
	VALUES(p_load_file_id_in,'etl.processdata',0,l_start_time,l_end_time,SQLSTATE,SQLERRM);
	
	RETURN 0;
END;
$$ language plpgsql;

<<<<<<< .mine
CREATE OR REPLACE FUNCTION etl.processrevenueclass(p_load_file_id_in integer, p_load_id_in bigint)
  RETURNS integer AS
$BODY$
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
--------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE FUNCTION etl.processrevenuecategory(p_load_file_id_in integer, p_load_id_in bigint)
  RETURNS integer AS
$BODY$
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

--------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processrevenuesource(p_load_file_id_in integer, p_load_id_in bigint)
  RETURNS integer AS
$BODY$
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
--------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processbudgetcode(p_load_file_id_in integer, p_load_id_in bigint)
  RETURNS integer AS
$BODY$
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
	RAISE NOTICE 'Exception Occurred in processbudget';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
	
END;


$$ language plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION etl.isEligibleForConsumption(p_job_id_in integer) RETURNS integer AS $$
=======
-------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION etl.iseligibleforconsumption(p_job_id_in integer) RETURNS integer AS $$
>>>>>>> .r171
DECLARE
	l_monthly_timestamp VARCHAR;
	l_weekly_timestamp VARCHAR;
	l_timestamp VARCHAR;
BEGIN
	CREATE TEMPORARY TABLE tmp_files_consumption(load_id bigint,load_file_id bigint )
	DISTRIBUTED BY (load_id);
	
	-- Get the file with the latest timestamp for COA feed
	
	INSERT INTO tmp_files_consumption
	SELECT c.load_id, max(load_file_id) as load_file_id
	FROM etl.etl_data_load_file c JOIN
		(SELECT a.load_id,max(file_timestamp) as file_timestamp
		FROM	etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id
		WHERE 	b.job_id = p_job_id_in
			AND b.data_source_code IN ('A','D','E','L','O')
			AND a.pattern_matched_flag ='Y'
		GROUP BY 1 ) tbl_timestamp ON c.load_id = tbl_timestamp.load_id AND c.file_timestamp = tbl_timestamp.file_timestamp
	WHERE 	c.pattern_matched_flag ='Y'
	GROUP BY 1;		
	
	-- FMSV - Identify the last monthly feed
	
	INSERT INTO tmp_files_consumption
	SELECT c.load_id, max(load_file_id) as load_file_id
	FROM etl.etl_data_load_file c JOIN
		(SELECT a.load_id,max(file_timestamp) as file_timestamp
		FROM	etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id
		WHERE 	b.job_id = p_job_id_in
			AND b.data_source_code ='V'
			AND a.type_of_feed ='M'
			AND a.pattern_matched_flag ='Y'
		GROUP BY 1 ) tbl_timestamp ON c.load_id = tbl_timestamp.load_id AND c.file_timestamp = tbl_timestamp.file_timestamp
	WHERE 	c.pattern_matched_flag ='Y'
	GROUP BY 1;	
	
	-- Update consume_flag to N for the COA/FMSV files which are not with the latest timestamp
	
	UPDATE etl.etl_data_load_file a
	SET    consume_flag ='N'
	FROM	tmp_files_consumption b
	WHERE	a.load_id = b.load_id
		AND a.load_file_id <> b.load_file_id;
	
	DELETE FROM tmp_files_consumption;
	
	-- Select timestamp associated with the last monthly FMSV data feed.
	
	SELECT 	file_timestamp
	FROM   	etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id
	WHERE 	data_source_code ='V'
		AND type_of_feed ='M'
		AND pattern_matched_flag ='Y'
	INTO	l_monthly_timestamp;	

	-- Identifying weekly FMSV files uploaded.
	
	INSERT INTO tmp_files_consumption
	SELECT c.load_id, max(load_file_id) as load_file_id
	FROM etl.etl_data_load_file c JOIN
	(SELECT a.load_id,max(file_timestamp) as file_timestamp
		FROM	etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id
		WHERE 	b.job_id = p_job_id_in
			AND b.data_source_code ='V'
			AND a.type_of_feed ='W'
			AND a.pattern_matched_flag ='Y'
			AND ((a.file_timestamp::timestamp >= l_monthly_timestamp::timestamp) OR 
			      l_monthly_timestamp IS NULL)
		GROUP BY 1) tbl_timestamp ON c.load_id = tbl_timestamp.load_id AND c.file_timestamp = tbl_timestamp.file_timestamp
	WHERE 	c.pattern_matched_flag ='Y'
	GROUP BY 1;	
		
	SELECT 	max(file_timestamp)
	FROM   	etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id
	WHERE 	data_source_code ='V'
		AND type_of_feed ='W'
		AND pattern_matched_flag ='Y'
	INTO	l_weekly_timestamp;	
	
	SELECT greatest(l_monthly_timestamp::timestamp,l_weekly_timestamp::timestamp) INTO l_timestamp ;
	
	-- Identifying daily FMSV files uploaded.
	
	INSERT INTO tmp_files_consumption
	SELECT c.load_id, max(load_file_id) as load_file_id
	FROM etl.etl_data_load_file c JOIN
	(SELECT a.load_id,max(file_timestamp) as file_timestamp
		FROM	etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id
		WHERE 	b.job_id = p_job_id_in
			AND b.data_source_code ='V'
			AND a.type_of_feed ='D'
			AND a.pattern_matched_flag ='Y'
			AND ((a.file_timestamp::timestamp >= l_timestamp::timestamp) OR 
			      l_timestamp IS NULL)
			      GROUP BY 1) tbl_timestamp ON c.load_id = tbl_timestamp.load_id AND c.file_timestamp = tbl_timestamp.file_timestamp
	WHERE 	c.pattern_matched_flag ='Y'
	GROUP BY 1;	
			      
	-- Update consume_flag to N for the FMSV files which are not with the latest timestamp
	
	UPDATE etl.etl_data_load_file a
	SET    consume_flag ='Y'
	FROM	tmp_files_consumption b
	WHERE	a.load_id = b.load_id
		AND a.load_file_id = b.load_file_id;

	RETURN 1;	
END;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.errorhandler(p_load_file_id_in int) RETURNS INT AS $$
DECLARE
	l_data_source_code etl.ref_data_source.data_source_code%TYPE;
	l_load_id bigint;
	l_job_id etl.etl_data_load.job_id%TYPE;

BEGIN

	
	RAISE NOTICE 'inside error handler % '  , p_load_file_id_in;

	SELECT b.data_source_code , a.load_id,b.job_id
	FROM   etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id	       
	WHERE  a.load_file_id = p_load_file_id_in     
	INTO   l_data_source_code, l_load_id,l_job_id;

	
	-- Updating the processed flag to E for the data file which resulted in an error
	UPDATE etl.etl_data_load_file
	SET    processed_flag ='E' 
	WHERE  load_file_id = p_load_file_id_in;

	RAISE NOTICE 'inside error handler 1';
	
	IF l_data_source_code IN ('A','D','E','L','O') THEN
		-- Updating the processed flag to C for all non processed data files for the job

		UPDATE  etl.etl_data_load_file a
		SET	processed_flag ='C' 
		FROM	etl.etl_data_load b
		WHERE	a.processed_flag = 'N'
			AND a.load_id = b.load_id
			AND b.job_id = l_job_id;		
		
		
		RAISE NOTICE 'inside error handler 1.2';	
	ELSE
		-- For any feed other than COA set only the non processed files of the specific feed to cancelled.
		
		UPDATE  etl.etl_data_load_file a
		SET	processed_flag ='C' 
		FROM	etl.etl_data_load b
		WHERE	a.processed_flag = 'N'
			AND a.load_id = b.load_id
			AND b.load_id = l_load_id;		

		RAISE NOTICE 'inside error handler 1.3';

		
		
	END IF;

	RETURN 1;
	
	
EXCEPTION
	WHEN OTHERS THEN
	
	RAISE NOTICE 'Exception Occurred in errorhandler';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;		
	
	RETURN 0;
END;
$$ language plpgsql;

------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT b.load_id,a.data_source_code,c.file_name,(CASE WHEN type_of_feed = 'M' THEN 1 
						      WHEN type_of_feed = 'W' THEN 2
						      WHEN type_of_feed = 'D' THEN 3 END ) file_order, file_timestamp
FROM etl.ref_data_source a JOIN etl.etl_data_load b ON a.data_source_code = b.data_source_code
	JOIN  etl.etl_data_load_file c ON b.load_id = c.load_id
WHERE b.job_id = 1 
	AND  table_order=1
	AND consume_flag='Y'
ORDER BY a.data_source_order, 4,file_timestamp;