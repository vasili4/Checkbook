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
			     AND COALESCE(a.document_type,'')=COALESCE(b.document_type,'')
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
						' WHERE uniq_id IN (' || l_all_uniq_id || ')' ;						

				-- Retain the least record for duplicates
				IF l_rule.rule_name ='Duplicate' THEN
					l_update_str := l_update_str || 
							' AND uniq_id NOT IN (' || l_min_uniq_id || ')';
				END IF;
				RAISE NOTICE 'l_update_str %',l_update_str;
				
				EXECUTE l_update_str;		
			END IF; 	
		END IF;


		
		IF l_rule.rule_name like 'Invalid%' THEN 

			
			EXECUTE 'TRUNCATE tmp_invalid_uniq_id ';
		
			-- Invalid Parent/Component		
			IF (COALESCE(l_rule.parent_table_name,'') <> '' OR COALESCE(l_rule.component_table_name,'') <> '' ) THEN

				
				RAISE NOTICE 'Inside invalid check 1.1';
				
				l_select_str :=  ' select array_to_string( ' || 
						 '	 array( ' || 
						 '		select (case when staging_data_type =''varchar'' then '' coalesce(a.''||staging_column_name||'','''''''') = coalesce(b.''||staging_column_name||'','''''''') '' ' || 
						 '			    when staging_data_type =''int'' or staging_data_type like ''numeric%'' then '' coalesce(a.''||staging_column_name||'',0) = coalesce(b.''||staging_column_name||'',0) '' ' || 
						 '			    when staging_data_type =''date'' then '' coalesce(a.''||staging_column_name||'',''''2000-01-01'''') = coalesce(b.''||staging_column_name||'',''''2000-01-01'''') '' ' || 
						 '		       end) as sql_condition ' || 
						 '		from etl.ref_column_mapping ' || 
						 '		where staging_table_name = ''' || l_rule.staging_table_name||''' ' ||
						 '			AND staging_column_name IN (''' || replace(l_rule.staging_column_name,',',''',''') ||''' )' ||
						 '		order by column_order )  ,''AND'') ';

				-- RAISE notice 'l_select_str %',l_select_str;
				EXECUTE l_select_str INTO l_where_clause;
				-- RAISE notice 'where %',l_where_clause;		
				
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

				l_select_str :=  ' SELECT (CASE WHEN staging_data_type = ''varchar'' THEN ''COALESCE(''||staging_column_name||'','''''''') <> '''''''' '' '||
						 '	WHEN staging_data_type = ''int'' THEN ''COALESCE('' || staging_column_name || '',0) <> 0 ''   END) '||
						 '	FROM etl.ref_column_mapping '||
						 '	WHERE staging_table_name=''' || l_rule.staging_table_name || ''' '||
						 '	AND staging_column_name=''' || l_rule.staging_column_name || ''' '; 

				EXECUTE l_select_str INTO l_where_clause;
							
				l_where_clause := l_where_clause || ' AND ' || l_rule.staging_column_name || ' NOT IN (SELECT ' || l_rule.ref_column_name || 
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
			
			
			l_insert_str := 'INSERT INTO tmp_invalid_uniq_id(uniq_id) '||
					' SELECT a.uniq_id ' ||
					' FROM ' || l_rule.staging_table_name ||' a LEFT JOIN ' || COALESCE(l_rule.parent_table_name,l_rule.component_table_name ) || ' b ' ||
					' ON ' || l_where_clause || 
					' WHERE b.uniq_id IS NULL ';
						
			
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
	
	INSERT INTO ref_department(department_id,department_code,department_name,agency_id,fund_class_id,fiscal_year,created_date,created_load_id)
	SELECT a.department_id,b.department_code,b.department_name,b.agency_id,b.fund_class_id,b.fiscal_year,now()::timestamp,p_load_id_in
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
	
	INSERT INTO ref_expenditure_object(expenditure_object_id,expenditure_object_code,expenditure_object_name,fiscal_year,created_date,created_load_id)
	SELECT a.expenditure_object_id,b.expenditure_object_code,b.expenditure_object_name,fiscal_year,now()::timestamp,p_load_id_in
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
	
	INSERT INTO ref_location(location_id,location_code,location_name,agency_id,location_short_name,created_date,created_load_id)
	SELECT a.location_id,b.location_code,b.location_name,b.agency_id,b.location_short_name,now()::timestamp,p_load_id_in
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
				     related_object_class_code,created_date,created_load_id)
	SELECT a.object_class_id,b.object_class_code,b.object_class_name,c.short_name,
		act_fl, d.date_id, e.date_id, alw_bud_fl, c.description,
		c.tbl_last_dt,intr_cty_fl,cntrc_pos_fl,c.pyrl_typ,c.dscr_ext,
		c.rltd_ocls_cd,now()::timestamp,p_load_id_in
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
-------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE FUNCTION etl.processFMSVVendor(p_load_file_id_in int,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
BEGIN
	CREATE TEMPORARY TABLE tmp_vendor(uniq_id bigint,vendor_customer_code varchar(20),legal_name varchar, alias_name varchar,miscellaneous_vendor_flag bit(1),
					  vendor_id int,exists_flag char(1), modified_flag char(1))
	DISTRIBUTED BY (uniq_id);

	-- For all records check if data is modified/new
		
	INSERT INTO tmp_vendor
	SELECT  a.uniq_id,
		a.vend_cust_cd, 
	       a.lgl_nm,
	       a.alias_nm,
	       a.misc_acct_fl,
	       (CASE WHEN b.vendor_customer_code IS NULL THEN 0 ELSE b.vendor_id END) as vendor_id,
	       (CASE WHEN b.vendor_customer_code IS NULL THEN 'N' ELSE 'Y' END) as exists_flag,
	       (CASE WHEN b.vendor_customer_code IS NOT NULL AND COALESCE(a.lgl_nm,a.alias_nm) <> COALESCE(b.legal_name,b.alias_name) THEN 'Y' ELSE 'N' END) as modified_flag
	FROM   etl.stg_fmsv_vendor a LEFT JOIN vendor b ON a.vend_cust_cd = b.vendor_customer_code;


	RAISE NOTICE '1';
	
	-- Generate the vendor id for new records
	
	TRUNCATE etl.vendor_id_seq;
	
	INSERT INTO etl.vendor_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_vendor
	WHERE  exists_flag ='N';
	
	UPDATE tmp_vendor a
	SET    vendor_id = b.vendor_id
	FROM   etl.vendor_id_seq b
	WHERE	a.uniq_id = b.uniq_id;

	-- Inserting new vendor records
	
	INSERT INTO vendor(vendor_id,vendor_customer_code,legal_name,alias_name,miscellaneous_vendor_flag,
			   vendor_sub_code,load_id,created_date)
	SELECT 	b.vendor_id,a.vendor_customer_code,a.legal_name,a.alias_name,a.miscellaneous_vendor_flag,
		NULL as vendor_sub_code,p_load_id_in as load_id, now()::timestamp
	FROM	tmp_vendor a JOIN etl.vendor_id_seq b ON a.uniq_id = b.uniq_id;


	RAISE NOTICE '2';
	
	-- Updating vendor records which have been modified
	
	CREATE TEMPORARY TABLE tmp_vendor_update(vendor_id int, legal_name varchar, alias_name varchar)
	DISTRIBUTED BY (vendor_id);
	
	UPDATE vendor a
	SET    legal_name = b.legal_name,
		alias_name = b.alias_name
	FROM	tmp_vendor_update b
	WHERE	a.vendor_id = b.vendor_id;
	
	-- Generating vendor history id sequence
	
	TRUNCATE etl.vendor_history_id_seq;
	
	INSERT INTO etl.vendor_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_vendor
	WHERE  exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');

	RAISE NOTICE '3';
	
	-- Inserting vendor records to vendor_history table
	
	INSERT INTO vendor_history(vendor_history_id, vendor_id, legal_name,alias_name,miscellaneous_vendor_flag ,vendor_sub_code,
    		load_id ,created_date)
	SELECT 	b.vendor_history_id,c.vendor_id,a.legal_name,a.alias_name,a.miscellaneous_vendor_flag,
		NULL as vendor_sub_code,p_load_id_in as load_id, now()::timestamp
	FROM	tmp_vendor a JOIN etl.vendor_history_id_seq b ON a.uniq_id = b.uniq_id
		JOIN vendor c ON a.vendor_customer_code = c.vendor_customer_code;

    	RAISE NOTICE '4';
    		
	-- Generating address id for new addresses
	
	CREATE TEMPORARY TABLE tmp_address(uniq_id bigint,address_line_1 varchar,address_line_2 varchar,city varchar,state char(2),zip varchar,country char(3),
					exists_flag char(1), address_id bigint)
	DISTRIBUTED BY (uniq_id);
	
	INSERT INTO tmp_address
	SELECT a.uniq_id,str_1_nm,str_2_nm,city_nm,st,a.zip,a.ctry,
		(CASE WHEN COALESCE(b.address_id,0) >0 THEN 'Y' ELSE 'N' END) as exists_flag,
		COALESCE(b.address_id,0) as address_id		
	FROM etl.stg_fmsv_address a LEFT JOIN address b ON COALESCE(a.str_1_nm,'') = COALESCE(b.address_line_1,'')  
			   AND COALESCE(a.str_2_nm,'') = COALESCE(b.address_line_2,'')  
			   AND COALESCE(a.city_nm,'') = COALESCE(b.city,'') 
			   AND COALESCE(a.st,'') = COALESCE(b.state,'') 
			   AND COALESCE(a.zip,'') = COALESCE(b.zip,'') 
			   AND COALESCE(a.ctry,'') = COALESCE(b.country,'');
	
	TRUNCATE etl.address_id_seq;

	RAISE NOTICE '5';
	
	
	INSERT INTO etl.address_id_seq(uniq_id)
	SELECT uniq_id
	FROM   tmp_address
	WHERE  exists_flag ='N';
	
	-- Inserting into the address table
	
	INSERT INTO address(address_id,address_line_1 ,address_line_2,city,
  				state ,zip ,country) 
	SELECT	min(b.address_id),a.address_line_1 ,a.address_line_2,a.city,
  				a.state ,a.zip ,a.country  			
  	FROM	tmp_address a JOIN etl.address_id_seq b ON a.uniq_id = b.uniq_id
  	GROUP BY 2,3,4,5,6,7;
  	
  	-- Inserting into the vendor_address table

  	RAISE NOTICE '6';
  	
	TRUNCATE etl.vendor_address_id_seq;
	
	INSERT INTO etl.vendor_address_id_seq(uniq_id)
	SELECT a.uniq_id
	FROM   etl.stg_fmsv_address_type a JOIN tmp_vendor b ON a.vend_cust_cd = b.vendor_customer_code
	WHERE  exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');

	INSERT INTO vendor_address(vendor_address_id,vendor_history_id,address_id,address_type_id,
    			           effective_begin_date_id,effective_end_date_id,load_id,created_date)
	SELECT c.vendor_address_id,d.vendor_history_id, e.address_id,g.address_type_id,
		h.date_id, i.date_id, p_load_id_in,now()::timestamp
	FROM	etl.stg_fmsv_address a JOIN etl.stg_fmsv_vendor b ON a.vend_cust_cd = b.vend_cust_cd				
		JOIN etl.vendor_history_id_seq d ON b.uniq_id = d.uniq_id
		JOIN address e ON COALESCE(a.str_1_nm,'') = COALESCE(e.address_line_1,'')  
			   AND COALESCE(a.str_2_nm,'') = COALESCE(e.address_line_2,'')  
			   AND COALESCE(a.city_nm,'') = COALESCE(e.city,'')  
			   AND COALESCE(a.st,'') = COALESCE(e.state,'') 
			   AND COALESCE(a.zip,'') = COALESCE(e.zip,'') 
			   AND COALESCE(a.ctry,'') = COALESCE(e.country,'')	
		JOIN etl.stg_fmsv_address_type f ON a.vend_cust_cd = f.vend_cust_cd AND a.ad_id = f.ad_id 
		JOIN etl.vendor_address_id_seq c ON f.uniq_id = c.uniq_id	   
		LEFT JOIN ref_address_type g ON a.ad_typ = g.address_type_code	   
		LEFT JOIN ref_date h ON f.efbgn_dt = h.date
		LEFT JOIN ref_date i ON f.efend_dt = i.date;

	RAISE NOTICE '7';
		
	-- Inserting into vendor_business_type
	
	TRUNCATE etl.vendor_business_id_seq;
	
	INSERT INTO etl.vendor_business_id_seq(uniq_id)
	SELECT a.uniq_id
	FROM   etl.stg_fmsv_business_type a JOIN tmp_vendor b ON a.vend_cust_cd = b.vendor_customer_code
	WHERE  exists_flag ='N'
		OR (exists_flag ='Y' and modified_flag='Y');	
		
	INSERT INTO vendor_business_type(vendor_business_type_id,vendor_history_id,business_type_id,status,
    					 minority_type_id,load_id,created_date)
    	SELECT  c.vendor_business_type_id,d.vendor_history_id,e.business_type_id,a.bus_typ_sta,
    		a.min_typ,p_load_id_in,now()::timestamp
    	FROM	etl.stg_fmsv_business_type a JOIN etl.stg_fmsv_vendor b ON a.vend_cust_cd = b.vend_cust_cd
    		JOIN etl.vendor_business_id_seq c ON a.uniq_id = c.uniq_id
		JOIN etl.vendor_history_id_seq d ON b.uniq_id = d.uniq_id
		JOIN ref_business_type e ON a.bus_typ = e.business_type_code;
		
	RETURN 1;

EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processFMSVVendor';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
		
END;
$$ language plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.isEligibleForConsumption(p_job_id_in integer) RETURNS integer AS $$
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
	SELECT a.load_id,load_file_id
		FROM	etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id
		WHERE 	b.job_id = p_job_id_in
			AND b.data_source_code ='V'
			AND a.type_of_feed ='W'
			AND a.pattern_matched_flag ='Y'
			AND ((a.file_timestamp::timestamp >= l_monthly_timestamp::timestamp) OR 
			      l_monthly_timestamp IS NULL);
		
	SELECT 	max(file_timestamp)
	FROM   	etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id
	WHERE 	data_source_code ='V'
		AND type_of_feed ='W'
		AND pattern_matched_flag ='Y'
	INTO	l_weekly_timestamp;	
	
	SELECT greatest(l_monthly_timestamp::timestamp,l_weekly_timestamp::timestamp) INTO l_timestamp ;
	
	-- Identifying daily FMSV files uploaded.
	
	INSERT INTO tmp_files_consumption
	SELECT a.load_id,load_file_id
		FROM	etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id
		WHERE 	b.job_id = p_job_id_in
			AND b.data_source_code ='V'
			AND a.type_of_feed ='D'
			AND a.pattern_matched_flag ='Y'
			AND ((a.file_timestamp::timestamp >= l_timestamp::timestamp) OR 
			      l_timestamp IS NULL);
			      
	-- Update consume_flag to 'Y' for the FMSV files which have to be consumed
	
	UPDATE etl.etl_data_load_file a
	SET    consume_flag ='Y'
	FROM	tmp_files_consumption b
	WHERE	a.load_id = b.load_id
		AND a.load_file_id = b.load_file_id;
	
	RETURN 1;
END;
$$ language plpgsql;



SELECT b.load_id,a.data_source_code,c.file_name,(CASE WHEN type_of_feed = 'M' THEN 1 
						      WHEN type_of_feed = 'W' THEN 2
						      WHEN type_of_feed = 'D' THEN 3 END ) file_order, file_timestamp
FROM etl.ref_data_source a JOIN etl.etl_data_load b ON a.data_source_code = b.data_source_code
	JOIN  etl.etl_data_load_file c ON b.load_id = c.load_id
WHERE b.job_id = 1 
	AND  table_order=1
	AND consume_flag='Y'
ORDER BY a.data_source_order, 4,file_timestamp;