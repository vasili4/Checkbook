/* Functions defined 
createSummaryTableStructures
refreshAllAggregateTables
*/

DROP TABLE IF EXISTS summary_types;

CREATE TABLE summary_types(type_name varchar(50),
			   type_description varchar(100),
			   spending_category_type char(1),
			   source_table_name varchar(50),
			   source_column_name varchar(100));
			   
DROP TABLE IF EXISTS summary_categories;

CREATE TABLE summary_categories(category_name varchar(50),
				category_description varchar(100),
				spending_category_type char(1),
				source_table_name varchar(50),
				source_column_name varchar(100));
				
-- FPDS Types				
insert into summary_types values('stateCode','POP State Code','c','fpds_award_short_ca','pop_state_code');				
insert into summary_types values('state','Vendor State Code','c','fpds_award_short_ca','vendor_state_code');				
insert into summary_types values('pop_cd','POP Congressional district','c','fpds_award_short_ca','pop_cd');				
insert into summary_types values('vendor_cd','Vendor Congressional district','c','fpds_award_short_ca','vendor_cd');				
insert into summary_types values('maj_agency_cat','Major contracting agency','c','fpds_award_short_ca','maj_agency_cat');				
insert into summary_types values('mod_agency','Contracting agency','c','fpds_award_short_ca','mod_agency');				
insert into summary_types values('maj_funding_agency_cat','Major funding agency','c','fpds_award_short_ca','maj_fund_agency_cat');				
insert into summary_types values('mod_fund_agency','Funding agency','c','fpds_award_short_ca','mod_fund_agency');				
insert into summary_types values('productOrServiceCode','PSC Code','c','fpds_award_short_ca','productOrServiceCode');				
insert into summary_types values('psc_cat','PSC Category','c','fpds_award_short_ca','psc_cat');				
insert into summary_types values('compete_cat','Competition category','c','fpds_award_short_ca','compete_cat');				
insert into summary_types values('typeOfContractPricing','Type of contract pricing','c','fpds_award_short_ca','typeOfContractPricing');				
insert into summary_types values('award','award','c','fpds_award_short_ca','award');
insert into summary_types values('programsource','programsource','c','fpds_award_short_ca','maj_agency_cat||''$''||ProgSourceAgency||''~''||ProgSourceAccount');
insert into summary_types values('extentCompeted','extentCompeted','c','fpds_award_short_ca','extentCompeted');				


-- FPDS Categories

insert into summary_types values('stateCode','POP State Code','a','faads_main_ca','principal_place_state_code');
insert into summary_types values('state','Recipient State Code','a','faads_main_ca','correct_state_code');				
insert into summary_types values('vendor_cd','Recipient Congressional district','a','faads_main_ca','recipient_cd');				
insert into summary_types values('maj_agency_cat','Major agency','a','faads_main_ca','maj_agency_cat');				
insert into summary_types values('mod_agency','Agency','a','faads_main_ca','agency_code');
insert into summary_types values('cfda_program_num','CFDA Program number','a','faads_main_ca','cfda_program_num');
insert into summary_types values('recip_cat_type','Recipient category type','a','faads_main_ca','recip_cat_type');
insert into summary_types values('asst_cat_type','Recipient category type','a','faads_main_ca','asst_cat_type');
insert into summary_types values('award','award','a','faads_main_ca','award');
insert into summary_types values('programsource','programsource','a','faads_main_ca','maj_agency_cat||''$''||progsrc_agen_code||''~''||progsrc_acnt_code');
insert into summary_types values('pop_cd','POP Congressional district','a','faads_main_ca','principal_place_cd');

-- FAADS Types

insert into summary_categories values('compete_cat','Competition category','c','fpds_award_short_ca','compete_cat');
insert into summary_categories values('pop_cd','POP Congressional district','c','fpds_award_short_ca','pop_cd');
insert into summary_categories values('productOrServiceCode','PSC Code','c','fpds_award_short_ca','productOrServiceCode');
insert into summary_categories values('mod_agency','Contracting agency','c','fpds_award_short_ca','mod_agency');
insert into summary_categories values('mod_fund_agency','Funding agency','c','fpds_award_short_ca','mod_fund_agency');
insert into summary_categories values('parent_id','Parent ID','c','fpds_award_short_ca','parent_id||''~''||mod_parent');
insert into summary_categories values('vendor_cd','vendor_cd','c','fpds_award_short_ca','vendor_cd');
insert into summary_categories values('award','award','c','fpds_award_short_ca','award');
insert into summary_categories values('maj_agency_cat','Major agency','c','fpds_award_short_ca','maj_agency_cat');
insert into summary_categories values('typeOfContractPricing','Type of contract pricing','c','fpds_award_short_ca','typeOfContractPricing');
insert into summary_categories values('programsource','programsource','c','fpds_award_short_ca','maj_agency_cat||''$''||ProgSourceAgency||''~''||ProgSourceAccount');
insert into summary_categories values('state','Vendor State Code','c','fpds_award_short_ca','vendor_state_code');				
insert into summary_categories values('maj_funding_agency_cat','Major funding agency','c','fpds_award_short_ca','maj_fund_agency_cat');				
insert into summary_categories values('extentCompeted','extentCompeted','c','fpds_award_short_ca','extentCompeted');

-- FAADS Categories

insert into summary_categories values('recip_cat_type','Recipient category type','a','faads_main_ca','recip_cat_type');
insert into summary_categories values('asst_cat_type','Recipient category type','a','faads_main_ca','asst_cat_type');
insert into summary_categories values('vendor_cd','Recipient Congressional district','a','faads_main_ca','recipient_cd');
insert into summary_categories values('cfda_program_num','CFDA Program number','a','faads_main_ca','cfda_program_num');
insert into summary_categories values('mod_agency','Agency','a','faads_main_ca','agency_code');
insert into summary_categories values('recip_id','Recipient ID','a','faads_main_ca','recip_id||''~''||corr_mod_name');
insert into summary_categories values('award','award','a','faads_main_ca','award');
insert into summary_categories values('maj_agency_cat','Major agency','a','faads_main_ca','maj_agency_cat');				 
insert into summary_categories values('pop_cd','POP Congressional district','a','faads_main_ca','principal_place_cd');
insert into summary_categories values('programsource','programsource','a','faads_main_ca','maj_agency_cat||''$''||progsrc_agen_code||''~''||progsrc_acnt_code');
insert into summary_categories values('state','Recipient State Code','a','faads_main_ca','correct_state_code');				

----------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE FUNCTION truncateAllAggregateTables(p_jobid integer)
  RETURNS integer AS $$
DECLARE	
	v_summary_types_cursor refcursor;
	v_summary_categories_cursor refcursor;
	v_summary_types_rec summary_types%ROWTYPE;
	v_summary_categories_rec summary_categories%ROWTYPE;

	v_table_name varchar;
	v_time timestamp;
	v_continue_flag INT :=0;
	v_start_time timestamp;
	v_end_time timestamp;
BEGIN

	
	v_start_time := now();
						
	OPEN v_summary_types_cursor FOR SELECT * FROM summary_types  order by type_name ;
	LOOP
	FETCH v_summary_types_cursor INTO v_summary_types_rec;
	EXIT WHEN NOT FOUND;
		OPEN v_summary_categories_cursor FOR select * FROM summary_categories WHERE spending_category_type=v_summary_types_rec.spending_category_type ;
		LOOP
			FETCH v_summary_categories_cursor into v_summary_categories_rec ;
			EXIT WHEN NOT FOUND;

			IF (v_summary_types_rec.type_name = 'award'  OR v_summary_types_rec.type_name = 'programsource' ) AND v_summary_categories_rec.category_name <> 'parent_id' AND v_summary_categories_rec.category_name <>  'recip_id' THEN
				v_continue_flag = 0;
			ELSIF (v_summary_categories_rec.category_name = 'state' AND v_summary_types_rec.type_name <> 'stateCode') THEN
				v_continue_flag = 0;
			ELSIF (v_summary_categories_rec.category_name ='maj_funding_agency_cat' AND v_summary_types_rec.type_name NOT IN ('state','stateCode')) THEN
				v_continue_flag := 0;	
			ELSE	
				v_continue_flag = 1;	
			END IF;

			IF v_continue_flag = 1 THEN
				v_table_name := 'AggregateOn' || v_summary_types_rec.type_name || 'And' || v_summary_categories_rec.category_name;				
				 
				EXECUTE 'TRUNCATE ' || v_table_name;
			END IF;	
		END LOOP;
		CLOSE v_summary_categories_cursor;	
	END LOOP;
	CLOSE v_summary_types_cursor;

        INSERT INTO faads_script_status(jobid,script_name,completed_flag,start_time,end_time)
	VALUES(p_jobid,'truncateAllAggregateTables',1,v_start_time,v_end_time);		
	
        RETURN 1;        
        
	EXCEPTION
		WHEN OTHERS THEN
			RAISE NOTICE 'Exception Occurred In truncateAllAggregateTables ';
			RAISE NOTICE 'ERROR % and ERROR MEssage: %',SQLSTATE,SQLERRM;
			

		        INSERT INTO faads_script_status(jobid,script_name,completed_flag,start_time,end_time)
			VALUES(p_jobid,'truncateAllAggregateTables',0,v_start_time,v_end_time);	
			
			RETURN 0;      
END;
$$ language plpgsql;	


----------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION createsummarytablestructures()
  RETURNS INT AS $$
DECLARE	
	v_summary_types_cursor refcursor;
	v_summary_categories_cursor refcursor;
	v_type_name summary_types.type_name%TYPE;
	v_spending_count integer;
	v_spending_category_type char(1);
	v_category_name summary_categories.category_name%TYPE;
	v_create_sql_str varchar;
	v_table_name varchar;
	v_index_sql_str varchar;
	v_drop_sql varchar;
	v_continue_flag INT :=1;
	v_grant_sql varchar;
BEGIN
	OPEN v_summary_types_cursor FOR SELECT type_name,count(*) as spending_count,min(spending_category_type)as spending_category_type FROM summary_types  group by 1 order by 2 desc,3;
	LOOP
	FETCH v_summary_types_cursor INTO v_type_name,v_spending_count,v_spending_category_type;
	EXIT WHEN NOT FOUND;
	
		IF v_spending_count = 2 THEN
			OPEN v_summary_categories_cursor FOR select distinct category_name FROM summary_categories;
		ELSIF v_spending_count = 1 THEN
			OPEN v_summary_categories_cursor FOR SELECT DISTINCT category_name 
							     FROM summary_categories 
							     WHERE spending_category_type = v_spending_category_type;
		END IF;							     
		LOOP
			FETCH v_summary_categories_cursor into v_category_name ;
			EXIT WHEN NOT FOUND;

			IF (v_type_name = 'award' OR v_type_name ='programsource') AND v_category_name <> 'parent_id' AND v_category_name <>  'recip_id' THEN
			
				v_continue_flag := 0;
			ELSIF (v_category_name ='state' AND v_type_name <> 'stateCode' ) THEN
				v_continue_flag := 0;
			ELSIF (v_category_name='maj_funding_agency_cat' AND v_type_name NOT IN ('state','stateCode')) THEN
				v_continue_flag := 0;
			ELSE	
				v_continue_flag := 1;	
			END IF;

			IF v_continue_flag = 1 THEN		
			
				v_table_name := 'AggregateOn' || v_type_name || 'And' || v_category_name;

				-- Non award related tables have recovery related figures as separate rows
				
				IF v_type_name <> 'award' and v_category_name <> 'award' THEN
					v_create_sql_str := 'CREATE TABLE ' || v_table_name || '(type_value varchar(150), ' ||
							' category_value varchar(150), type_of_spending char(2) , spending_category char(1), ' ||
							' fiscal_year int ,rec_flag char(1), amount_1 decimal(18,2), amount_2 decimal(18,2), '||
							' num_transactions bigint, action_flag char(1) ) DISTRIBUTED BY (type_value)';				
				ELSE
					-- award related tables have recovery related figures as separate columns
					
					v_create_sql_str := 'CREATE TABLE ' || v_table_name || '(type_value varchar(150), ' ||
							' category_value varchar(150), type_of_spending char(2) , spending_category char(1), ' ||
							' fiscal_year int , amount_1 decimal(18,2), amount_2 decimal(18,2), '||
							' num_transactions bigint, action_flag char(1),rec_amount_1 decimal(18,2), rec_amount_2 decimal(18,2), rec_num_transactions bigint) DISTRIBUTED BY (type_value)';								
				END IF;
				v_drop_sql := 'drop table if exists ' || v_table_name ;
				EXECUTE v_drop_sql;			
				EXECUTE v_create_sql_str;
				
				v_grant_sql := 'GRANT SELECT ON ' || v_table_name || ' TO PUBLIC ';
				EXECUTE v_grant_sql;
				
				--RAISE NOTICE 'create str %',v_create_sql_str;
			END IF;	
			
		END LOOP;			
		CLOSE v_summary_categories_cursor;		
	END LOOP;
	CLOSE v_summary_types_cursor;
	
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
		RETURN 0;
	
END;
$$ language plpgsql;

-------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION refreshallaggregatetables(p_jobid integer, p_spending_category character varying)
  RETURNS integer AS $$
DECLARE	
	v_summary_types_cursor refcursor;
	v_summary_categories_cursor refcursor;
	v_summary_types_rec summary_types%ROWTYPE;
	v_summary_categories_rec summary_categories%ROWTYPE;
	v_del_sql_str varchar;
	v_table_name varchar;
	v_ins_sql_str varchar;
	v_time timestamp;
	v_count integer;
	v_int_table_name varchar;
	v_cnt integer;
	v_del_sql varchar;
        v_start_time  timestamp;
	v_end_time  timestamp;	
	v_fyq varchar;
	v_continue_flag INT :=0;
	
BEGIN

	v_start_time := now();
	
	
	-- CREATE temporary table tmp_deleted_tables(table_name varchar(100));

	IF p_spending_category = 'a' THEN
		
		TRUNCATE faads_main_ca;
			
		INSERT INTO faads_main_ca 
		SELECT * FROM faads_main ;
	
		EXECUTE 'ANALYZE faads_main_ca(principal_place_state_code,recipient_state_code,recipient_cd,maj_agency_cat,agency_code,cfda_program_num,recip_cat_type,asst_cat_type,federal_award_id) ';
		RAISE NOTICE 'Completed the analyze of faads_main_ca';
	ELSE
	
		TRUNCATE fpds_award_short_ca;
			
		INSERT INTO fpds_award_short_ca 
		SELECT * FROM fpds_award_short ;
	
		EXECUTE 'ANALYZE fpds_award_short_ca(stateCode,state,pop_cd,vendor_cd,maj_agency_cat,mod_agency,maj_fund_agency_cat,mod_fund_agency,productOrServiceCode,psc_cat,compete_cat,typeofcontractpricing,agencyID,PIID,IDVAgencyID,IDVPIID) ';
		RAISE NOTICE 'Completed the analyze of fpds_award_short_ca';
	END IF;
		
	RAISE NOTICE '1';
	
	OPEN v_summary_types_cursor FOR SELECT * FROM summary_types WHERE spending_category_type = p_spending_category  order by type_name ;
	LOOP
	FETCH v_summary_types_cursor INTO v_summary_types_rec;
	EXIT WHEN NOT FOUND;
		OPEN v_summary_categories_cursor FOR select * FROM summary_categories WHERE spending_category_type=v_summary_types_rec.spending_category_type ;
		LOOP
			FETCH v_summary_categories_cursor into v_summary_categories_rec ;
			EXIT WHEN NOT FOUND;

			IF (v_summary_types_rec.type_name = 'award'  OR v_summary_types_rec.type_name = 'programsource' ) AND v_summary_categories_rec.category_name <> 'parent_id' AND v_summary_categories_rec.category_name <>  'recip_id' THEN
				v_continue_flag = 0;
			ELSIF (v_summary_categories_rec.category_name = 'state' AND v_summary_types_rec.type_name <> 'stateCode') THEN
				v_continue_flag = 0;
			ELSIF (v_summary_categories_rec.category_name ='maj_funding_agency_cat' AND v_summary_types_rec.type_name NOT IN ('state','stateCode')) THEN
				v_continue_flag := 0;	
			ELSE	
				v_continue_flag = 1;	
			END IF;

			IF v_continue_flag = 1 THEN
				v_table_name := 'AggregateOn' || v_summary_types_rec.type_name || 'And' || v_summary_categories_rec.category_name;
				v_int_table_name := 'Int_'||v_table_name;
				
				 -- EXECUTE 'CREATE TEMPORARY TABLE '||v_int_table_name || ' (like ' || v_table_name || ')';

				 -- EXECUTE 'INSERT INTO ' || v_int_table_name  || ' SELECT * FROM ' || v_table_name ||  ' WHERE spending_category <> ''' || p_spending_category || ''' ';
				 
				 -- EXECUTE 'TRUNCATE ' || v_table_name;
				 
				 -- EXECUTE 'INSERT INTO ' || v_table_name ||' SELECT * FROM ' || v_int_table_name ;
							
				
				-- Contracts & Type name is award 
				IF v_summary_types_rec.spending_category_type ='c' AND v_summary_types_rec.type_name = 'award' THEN
				
					v_ins_sql_str := 'insert into ' || v_table_name || 
							'(type_value,category_value,type_of_spending,spending_category, ' ||
							' fiscal_year,amount_1,amount_2,num_transactions,rec_amount_1,rec_amount_2,rec_num_transactions) ' ||
							'select (case when IDVPIID IS NULL OR LENGTH(TRIM(IDVPIID)) = 0 THEN agencyID || ''~'' || PIID ELSE agencyID || ''~'' || PIID || ''~'' || IDVPIID || ''~'' || IDVAgencyID END) as award, category_value, ' ||
							'type_of_contract,''c'',fiscal_year,obligatedAmount,amount_2,num_transactions,rec_obligatedAmount,rec_amount_2,rec_num_transactions ' ||
							'from ' ||
								'(select ''c'' as type_of_contract,' || v_summary_categories_rec.source_column_name || ' as category_value,' ||
								'agencyID,PIID,IDVPIID,IDVAgencyID, ' || 
								'fiscal_year,sum(obligatedAmount) as obligatedAmount,0 as amount_2 ,count(*) as num_transactions, ' ||
								'sum((case when coalesce(rec_flag,'''') =''R'' THEN obligatedAmount ELSE 0 END)) as rec_obligatedAmount,0 as rec_amount_2 ,SUM((CASE WHEN COALESCE(rec_flag,'''') = ''R'' THEN 1 ELSE 0 END)) as rec_num_transactions ' ||
								' from ' || v_summary_types_rec.source_table_name ||
								' group by 1,2,3,4,5,6,7 ) award_tbl';	

				-- Contracts & all categories other than award 
				
				ELSIF v_summary_types_rec.spending_category_type ='c' AND 
				      v_summary_categories_rec.category_name <> 'award'  THEN
				      
					v_ins_sql_str := 'insert into ' || v_table_name || 
							'(type_value,category_value,type_of_spending,spending_category, ' ||
							' fiscal_year,rec_flag,amount_1,amount_2,num_transactions) ' ||
							' select ' || v_summary_types_rec.source_column_name || ',' ||
							v_summary_categories_rec.source_column_name || ',''c'' as type_of_contract ,''c''' ||
							' ,fiscal_year,rec_flag,sum(obligatedAmount) as obligatedAmount,0 as amount_2 ,count(*) as num_transactions ' ||
							' from ' || v_summary_types_rec.source_table_name ||
							' group by 1,2,3,4,5,6 ';
				
				-- Contracts & category is award
				
				ELSIF v_summary_types_rec.spending_category_type ='c' AND v_summary_categories_rec.category_name = 'award' THEN			
								
					v_ins_sql_str := 'insert into ' || v_table_name || 
							'(type_value,category_value,type_of_spending,spending_category, ' ||
							' fiscal_year,amount_1,amount_2,num_transactions,rec_amount_1,rec_amount_2,rec_num_transactions) ' ||
							'select type_name,(case when IDVPIID IS NULL OR LENGTH(TRIM(IDVPIID)) = 0 THEN agencyID || ''~'' || PIID ELSE agencyID || ''~'' || PIID || ''~'' || IDVPIID || ''~'' || IDVAgencyID END) as award, ' ||
							'type_of_contract,''c'',fiscal_year,obligatedAmount,amount_2,num_transactions,rec_obligatedAmount,rec_amount_2,rec_num_transactions ' ||
							'from ' ||
								'(select ''c'' as type_of_contract,' || v_summary_types_rec.source_column_name || ' as type_name,' ||
								'agencyID,PIID,IDVPIID,IDVAgencyID, ' || 
								'fiscal_year,sum(obligatedAmount) as obligatedAmount,0 as amount_2 ,count(*) as num_transactions, ' ||
								'sum((case when coalesce(rec_flag,'''') =''R'' THEN obligatedAmount ELSE 0 END)) as rec_obligatedAmount,0 as rec_amount_2 ,SUM((CASE WHEN COALESCE(rec_flag,'''') = ''R'' THEN 1 ELSE 0 END)) as rec_num_transactions ' ||								
								' from ' || v_summary_types_rec.source_table_name ||
								' group by 1,2,3,4,5,6,7 ) award_tbl';			
				-- Assistance & type is award
				
				ELSIF v_summary_types_rec.spending_category_type ='a' AND v_summary_types_rec.type_name = 'award' THEN				
					v_ins_sql_str := 'insert into ' || v_table_name || 
							'(type_value,category_value,type_of_spending,spending_category, ' ||
							' fiscal_year,amount_1,amount_2,num_transactions,rec_amount_1,rec_amount_2,rec_num_transactions) ' ||
							' select ' ||						
							'(CASE WHEN federal_award_id IS NULL OR trim(federal_award_id) ='''' THEN ''UNKNOWN'' || record_id ' ||
							'	ELSE federal_award_id END) || ''$'' || agency_code as award, ' ||v_summary_categories_rec.source_column_name ||
							',asst_cat_type, '||
							'''a'',' ||
							' fiscal_year,sum(case when asst_cat_type <> ''l'' then fed_funding_amount else orig_sub_guran end ) as amount_1,' ||
							' sum(case when asst_cat_type = ''l'' then face_loan_guran else 0 end )  as amount_2 ,count(*) as num_transactions, ' ||
							' sum(case when asst_cat_type <> ''l'' AND COALESCE(rec_flag,'''') = ''R'' then fed_funding_amount  when asst_cat_type = ''l'' AND COALESCE(rec_flag,'''') = ''R'' THEN orig_sub_guran ELSE 0 end ) as rec_amount_1,' ||
							' sum(case when asst_cat_type = ''l'' AND COALESCE(rec_flag,'''') = ''R'' then face_loan_guran else 0 end )  as rec_amount_2 ,SUM(CASE WHEN COALESCE(rec_flag,'''') = ''R'' THEN 1 ELSE 0 END) as rec_num_transactions ' ||							
							' from ' || v_summary_types_rec.source_table_name ||
							' group by 1,2,3,4,5 ';						
				

				-- Assistance with type as stateCode and all categories other than award
				
				ELSIF v_summary_types_rec.spending_category_type ='a' AND 
				      v_summary_types_rec.type_name = 'stateCode' AND 
				      v_summary_categories_rec.category_name <> 'award' THEN

					v_ins_sql_str := 'insert into ' || v_table_name || 
							'(type_value,category_value,type_of_spending,spending_category, ' ||
							' fiscal_year,rec_flag,amount_1,amount_2,num_transactions) ' ||
							' SELECT (CASE WHEN principal_place_code=''00*****'' OR (COALESCE(principal_place_code,'''')='''' AND principal_place_state IN (''MULTI STATE'',''Nation-wide performance'',''NATIONWIDE''))THEN ''MULTISTATE'' ' ||
							'	WHEN principal_place_code =''00FORGN'' THEN ''FOREIGN'' ELSE principal_place_state_code END) as type_value,'  ||
							v_summary_categories_rec.source_column_name || ',asst_cat_type, ' ||
							'''a'',' ||
							' fiscal_year,rec_flag,sum(case when asst_cat_type <> ''l'' then fed_funding_amount else orig_sub_guran end ) as amount_1,' ||
							' sum(case when asst_cat_type = ''l'' then face_loan_guran else 0 end )  as amount_2 ,count(*) as num_transactions ' ||
							' from ' || v_summary_types_rec.source_table_name ||
							' group by 1,2,3,4,5,6 ';			
				
				-- Assistance with type as stateCode and category as award
				ELSIF v_summary_types_rec.spending_category_type ='a' AND 
				      v_summary_types_rec.type_name = 'stateCode' AND 
				      v_summary_categories_rec.category_name = 'award' THEN
				      
					v_ins_sql_str := 'insert into ' || v_table_name || 
							'(type_value,category_value,type_of_spending,spending_category, ' ||
							' fiscal_year,amount_1,amount_2,num_transactions,rec_amount_1,rec_amount_2,rec_num_transactions) ' ||
							' SELECT (CASE WHEN principal_place_code=''00*****'' OR (COALESCE(principal_place_code,'''')='''' AND principal_place_state IN (''MULTI STATE'',''Nation-wide performance'',''NATIONWIDE''))THEN ''MULTISTATE'' ' ||
							'	WHEN principal_place_code =''00FORGN'' THEN ''FOREIGN'' ELSE principal_place_state_code END) as type_value,'  ||
							'(CASE WHEN federal_award_id IS NULL OR trim(federal_award_id) ='''' THEN ''UNKNOWN'' || record_id ' ||
							'	ELSE federal_award_id END) || ''$'' || agency_code  as award ' ||
							',asst_cat_type, '||
							'''a'',' ||
							' fiscal_year,sum(case when asst_cat_type <> ''l'' then fed_funding_amount else orig_sub_guran end ) as amount_1,' ||
							' sum(case when asst_cat_type = ''l'' then face_loan_guran else 0 end )  as amount_2 ,count(*) as num_transactions, ' ||
							' sum(case when asst_cat_type <> ''l'' AND COALESCE(rec_flag,'''') = ''R'' then fed_funding_amount  when asst_cat_type = ''l'' AND COALESCE(rec_flag,'''') = ''R'' THEN orig_sub_guran ELSE 0 end ) as rec_amount_1,' ||
							' sum(case when asst_cat_type = ''l'' AND COALESCE(rec_flag,'''') = ''R'' then face_loan_guran else 0 end )  as rec_amount_2 ,SUM(CASE WHEN COALESCE(rec_flag,'''') = ''R'' THEN 1 ELSE 0 END) as rec_num_transactions ' ||														
							' from ' || v_summary_types_rec.source_table_name ||
							' group by 1,2,3,4,5 ';			
				      
				-- Assistance and all categories other than award 
							
				ELSIF v_summary_types_rec.spending_category_type ='a'
				      AND v_summary_types_rec.type_name <> 'stateCode' 
				      AND v_summary_categories_rec.category_name <> 'award'  THEN				
					v_ins_sql_str := 'insert into ' || v_table_name || 
							'(type_value,category_value,type_of_spending,spending_category, ' ||
							' fiscal_year,rec_flag,amount_1,amount_2,num_transactions) ' ||
							' select ' || v_summary_types_rec.source_column_name || ',' ||
							v_summary_categories_rec.source_column_name || ',asst_cat_type, ' ||
							'''a'',' ||
							' fiscal_year,rec_flag,sum(case when asst_cat_type <> ''l'' then fed_funding_amount else orig_sub_guran end ) as amount_1,' ||
							' sum(case when asst_cat_type = ''l'' then face_loan_guran else 0 end )  as amount_2 ,count(*) as num_transactions ' ||
							' from ' || v_summary_types_rec.source_table_name ||
							' group by 1,2,3,4,5,6 ';			

				-- Assistance and category is award
				
				ELSE
								
					v_ins_sql_str := 'insert into ' || v_table_name || 
							'(type_value,category_value,type_of_spending,spending_category, ' ||
							' fiscal_year,amount_1,amount_2,num_transactions,rec_amount_1,rec_amount_2,rec_num_transactions) ' ||
							' select ' || v_summary_types_rec.source_column_name || ',' ||						
							'(CASE WHEN federal_award_id IS NULL OR trim(federal_award_id) ='''' THEN ''UNKNOWN'' || record_id ' ||
							'	ELSE federal_award_id END) || ''$'' || agency_code  as award ' ||
							',asst_cat_type, '||
							'''a'',' ||
							' fiscal_year,sum(case when asst_cat_type <> ''l'' then fed_funding_amount else orig_sub_guran end ) as amount_1,' ||
							' sum(case when asst_cat_type = ''l'' then face_loan_guran else 0 end )  as amount_2 ,count(*) as num_transactions, ' ||
							' sum(case when asst_cat_type <> ''l'' AND COALESCE(rec_flag,'''') = ''R'' then fed_funding_amount  when asst_cat_type = ''l'' AND COALESCE(rec_flag,'''') = ''R'' THEN orig_sub_guran ELSE 0 end ) as rec_amount_1,' ||
							' sum(case when asst_cat_type = ''l'' AND COALESCE(rec_flag,'''') = ''R'' then face_loan_guran else 0 end )  as rec_amount_2 ,SUM(CASE WHEN COALESCE(rec_flag,'''') = ''R'' THEN 1 ELSE 0 END) as rec_num_transactions ' ||																					
							' from ' || v_summary_types_rec.source_table_name ||
							' group by 1,2,3,4,5 ';			
				
				END IF;
				
				SELECT into v_time now();
				--RAISE NOTICE 'Populating Table % Starts % % %',v_table_name,date_part('hour', v_time),date_part('minute', v_time),date_part('second', v_time);
				RAISE NOTICE ' Insert statement % ',v_ins_sql_str;
				 EXECUTE v_ins_sql_str;
				SELECT into v_time now();

				-- EXECUTE 'SELECT COUNT(*) FROM ' || v_table_name INTO v_cnt;
				-- RAISE NOTICE 'TABLE % CNT %', v_table_name,v_cnt;
				
				-- RAISE NOTICE 'Populating Table % Ends % % %',v_table_name,date_part('hour', v_time),date_part('minute', v_time),date_part('second', v_time);
			END IF;	
		END LOOP;
		CLOSE v_summary_categories_cursor;	
		RAISE NOTICE 'Completed type: %',v_summary_types_rec.type_name;
	END LOOP;
	CLOSE v_summary_types_cursor;

        v_end_time := now();
        
        IF p_spending_category = 'a' THEN
        	INSERT INTO faads_script_status(jobid,script_name,completed_flag,start_time,end_time)
		VALUES(p_jobid,'refreshallaggregatetables FAADS',1,v_start_time,v_end_time);	
	ELSE
		INSERT INTO fpds_execution_status(jobid,script_name,completed_flag,start_time,end_time)
		VALUES(p_jobid,'refreshallaggregatetables FPDS',1,v_start_time,v_end_time); 	

	END IF;
	
        RETURN 1;        
        
	EXCEPTION
		WHEN OTHERS THEN
			RAISE NOTICE 'Exception Occurred In refreshallaggregatetables ';
			RAISE NOTICE 'ERROR % and ERROR MEssage: %',SQLSTATE,SQLERRM;
			v_end_time := now();
			IF p_spending_category = 'a' THEN
				INSERT INTO faads_script_status(jobid,script_name,completed_flag,start_time,end_time)
				VALUES(p_jobid,'refreshallaggregatetables FAADS',0,v_start_time,v_end_time);	
			ELSE
				INSERT INTO fpds_execution_status(jobid,script_name,completed_flag,start_time,end_time)
				VALUES(p_jobid,'refreshallaggregatetables FPDS',0,v_start_time,v_end_time); 	
			END IF;	
	RETURN 0;      
END;
$$ language plpgsql;
