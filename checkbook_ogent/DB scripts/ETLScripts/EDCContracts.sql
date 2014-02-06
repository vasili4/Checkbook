CREATE OR REPLACE FUNCTION etl.processEDCContracts(p_load_file_id_in bigint,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_count bigint;
	l_start_time  timestamp;
	l_end_time  timestamp;
BEGIN
    
	l_start_time := timeofday()::timestamp;
	
	ALTER SEQUENCE seq_address_address_id RESTART WITH 5;
	TRUNCATE etl.address_id_seq;

	INSERT INTO etl.address_id_seq(uniq_id)
	SELECT uniq_id
	FROM (SELECT min(uniq_id) as uniq_id, contractor_address, contractor_city, contractor_state, contractor_zip
	FROM   etl.stg_edc_contract 
	GROUP BY 2,3,4,5) a;
	
	TRUNCATE address CASCADE;
	INSERT INTO address(address_id,address_line_1 ,city,
  				state ,zip ) 
	SELECT	min(b.address_id) as address_id,a.contractor_address ,a.contractor_city,
  				a.contractor_state ,a.contractor_zip  			
  	FROM	etl.stg_edc_contract a JOIN etl.address_id_seq b ON a.uniq_id = b.uniq_id
  	GROUP BY 2,3,4,5;
	
	GET DIAGNOSTICS l_count = ROW_COUNT;
			  	IF l_count >0 THEN
					INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
					VALUES(p_load_file_id_in,'ED',l_count,'Number of records inserted into vendor');
	END IF;

	ALTER SEQUENCE seq_vendor_vendor_id RESTART WITH 5;	
	TRUNCATE etl.vendor_id_seq;

	INSERT INTO etl.vendor_id_seq(uniq_id)
	SELECT uniq_id
	FROM (SELECT contractor_name, min(uniq_id) as uniq_id
	      FROM   etl.stg_edc_contract
		GROUP BY 1) a;

	TRUNCATE vendor CASCADE;
	INSERT INTO vendor(vendor_id,legal_name,created_load_id,created_date)
	SELECT 	b.vendor_id,a.contractor_name,p_load_id_in as created_load_id, now()::timestamp
	FROM	etl.stg_edc_contract a JOIN etl.vendor_id_seq b ON a.uniq_id = b.uniq_id;
	
	GET DIAGNOSTICS l_count = ROW_COUNT;
			  	IF l_count >0 THEN
					INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
					VALUES(p_load_file_id_in,'ED',l_count,'Number of records inserted into vendor');
	END IF;
	
	
	ALTER SEQUENCE seq_vendor_history_vendor_history_id RESTART WITH 5;	 
	TRUNCATE etl.vendor_history_id_seq;
	
	INSERT INTO etl.vendor_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM  (SELECT contractor_name, contractor_address ,contractor_city,
  				contractor_state ,contractor_zip, min(uniq_id) as uniq_id
	      FROM   etl.stg_edc_contract
		GROUP BY 1,2,3,4,5) a;
		
	TRUNCATE vendor_history CASCADE;
	INSERT INTO vendor_history(vendor_history_id, vendor_id, legal_name,load_id ,created_date)
		SELECT 	b.vendor_history_id,c.vendor_id,a.contractor_name,p_load_id_in as load_id, now()::timestamp
		FROM	etl.stg_edc_contract a JOIN etl.vendor_history_id_seq b ON a.uniq_id = b.uniq_id
			JOIN vendor c ON a.contractor_name = c.legal_name ;
	
	GET DIAGNOSTICS l_count = ROW_COUNT;
			  	IF l_count >0 THEN
					INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
					VALUES(p_load_file_id_in,'ED',l_count,'Number of records inserted into vendor_history');
	END IF;
	

	ALTER SEQUENCE seq_vendor_address_vendor_address_id RESTART WITH 5;		
	TRUNCATE etl.vendor_address_id_seq;

	INSERT INTO etl.vendor_address_id_seq(uniq_id)
	SELECT uniq_id
	FROM   (SELECT contractor_name, contractor_address ,contractor_city,
  				contractor_state ,contractor_zip, min(uniq_id) as uniq_id
	      FROM   etl.stg_edc_contract
		  GROUP BY 1,2,3,4,5) a;

	TRUNCATE vendor_address CASCADE;
	INSERT INTO vendor_address(vendor_address_id,vendor_history_id,address_id,load_id,created_date)
	SELECT c.vendor_address_id,d.vendor_history_id, e.address_id, p_load_id_in,now()::timestamp
	FROM	etl.stg_edc_contract a JOIN etl.vendor_history_id_seq d ON a.uniq_id = d.uniq_id
		JOIN address e ON COALESCE(a.contractor_address,'') = COALESCE(e.address_line_1,'')  
			   AND COALESCE(a.contractor_city,'') = COALESCE(e.city,'')  
			   AND COALESCE(a.contractor_state,'') = COALESCE(e.state,'') 
			   AND COALESCE(a.contractor_zip,'') = COALESCE(e.zip,'') 
		JOIN etl.vendor_address_id_seq c ON a.uniq_id = c.uniq_id	;

	GET DIAGNOSTICS l_count = ROW_COUNT;
			  	IF l_count >0 THEN
					INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
					VALUES(p_load_file_id_in,'ED',l_count,'Number of records inserted into vendor_address');
	END IF;
	
	UPDATE etl.stg_edc_contract a
	SET agency_id = b.agency_id
	FROM ref_agency b
	WHERE a.agency_code = b.agency_code AND b.agency_code = 'z81';
	
	UPDATE etl.stg_edc_contract a
	SET vendor_id = b.vendor_id
	FROM vendor b
	WHERE a.contractor_name = b.legal_name;
	
	TRUNCATE  edc_contract;
	
	INSERT INTO edc_contract(agency_code, fms_contract_number, fms_commodity_line, edc_contract_number, purpose, budget_name,
	edc_registered_amount, vendor_name, agency_id, vendor_id, created_load_id, created_date)
	SELECT agency_code, fms_contract_number, fms_commodity_line, edc_contract_number, purpose, budget_name, 
	edc_registered_amount, contractor_name, agency_id, vendor_id, p_load_id_in, now()::timestamp
	FROM etl.stg_edc_contract ;
	
	TRUNCATE oge_contract_previous_load;
	
	INSERT INTO oge_contract_previous_load 
	SELECT * FROM oge_contract;
	
	
	TRUNCATE oge_contract;
	
	INSERT INTO oge_contract(agency_code, fms_contract_number, fms_commodity_line, oge_contract_number, purpose, budget_name,
	oge_registered_amount, vendor_name, agency_id, vendor_id, created_load_id, created_date)
	SELECT agency_code, fms_contract_number, fms_commodity_line, min(edc_contract_number), min(purpose), min(budget_name), 
	sum(edc_registered_amount), vendor_name, agency_id, vendor_id, p_load_id_in, now()::timestamp
	FROM edc_contract group by 1,2,3,8,9,10,11;
	
	
	
	GET DIAGNOSTICS l_count = ROW_COUNT;	
	
		IF l_count > 0 THEN
			INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
			VALUES(p_load_file_id_in,'ED',l_count, '# of records inserted into edc_contract');
		END IF;
	
	l_end_time := timeofday()::timestamp;

	INSERT INTO etl.etl_script_execution_status(load_file_id,script_name,completed_flag,start_time,end_time)
	VALUES(p_load_file_id_in,'etl.processEDCContracts',1,l_start_time,l_end_time);
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processEDCContracts';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	
	
		l_end_time := timeofday()::timestamp;
	
	INSERT INTO etl.etl_script_execution_status(load_file_id,script_name,completed_flag,start_time,end_time,errno,errmsg)
	VALUES(p_load_file_id_in,'etl.processEDCContracts',0,l_start_time,l_end_time,SQLSTATE,SQLERRM);
	RETURN 0;	
END;
$$ language plpgsql;