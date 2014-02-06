CREATE OR REPLACE FUNCTION etl.processTDCContracts(p_load_file_id_in bigint,p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_count bigint;
	l_start_time  timestamp;
	l_end_time  timestamp;
BEGIN
    
	l_start_time := timeofday()::timestamp;
	
	TRUNCATE etl.tmp_all_vendors;
	
	INSERT INTO etl.tmp_all_vendors
	SELECT MAX(uniq_id), COALESCE(MAX(b.vendor_history_id),0) as vendor_history_id, COALESCE(MAX(b.vendor_id),0) as vendor_id,
				'N' as is_new_vendor,  'N' as is_vendor_address_changed, 'N' as  is_address_new, lgl_nm, ad_ln_1, st, zip, city		
	FROM etl.stg_tdc_contract a LEFT JOIN 
	(SELECT max(b.vendor_id) as vendor_id, max(c.vendor_history_id) as vendor_history_id, b.legal_name 
	FROM vendor b, vendor_history c
	WHERE b.vendor_id = c.vendor_id
	GROUP BY 3) b
	ON a.contractor_name = b.legal_name	
	GROUP BY 4,5,6,7,8,9,10,11;


	RAISE NOTICE 'VENDOR 01';
	
	-- Identifying new vendors
	
	UPDATE etl.tmp_all_vendors
	SET is_new_vendor = 'Y'
	WHERE coalesce(vendor_history_id,0) =0;

	RAISE NOTICE 'VENDOR 02';

	-- Identifying new addresses
	
	TRUNCATE etl.tmp_all_vendors_uniq_id ;
	
	INSERT INTO etl.tmp_all_vendors_uniq_id
	SELECT uniq_id
	FROM etl.tmp_all_vendors a LEFT JOIN address b
	ON COALESCE(a.ad_ln_1,'') = COALESCE(b.address_line_1,'')
	AND COALESCE(a.city,'') = COALESCE(b.city,'')
	AND COALESCE(a.st,'') = COALESCE(b.state,'')
	AND COALESCE(a.zip,'') = COALESCE(b.zip,'')
	WHERE b.address_id IS NULL ;
	
	UPDATE etl.tmp_all_vendors a
	SET is_address_new = 'Y'
	FROM
	etl.tmp_all_vendors_uniq_id b
	WHERE a.uniq_id = b.uniq_id ;
	
	-- Identifying existing vendors for which address information changed 
	
	TRUNCATE etl.tmp_all_vendors_uniq_id ;
	
	INSERT INTO etl.tmp_all_vendors_uniq_id
	SELECT b.uniq_id
	FROM
	(SELECT m.uniq_id,vendor_address_id
	FROM etl.tmp_all_vendors m 
			LEFT JOIN
			          (SELECT  a.vendor_address_id,h.lgl_nm, h.uniq_id,c.address_line_1,c.city,c.state,c.zip				
					FROM	vendor_address a,   address c, vendor_history f, etl.tmp_all_vendors h
					WHERE  a.address_id = c.address_id
					AND a.vendor_history_id = f.vendor_history_id AND f.vendor_history_id = h.vendor_history_id 
					AND h.is_new_vendor = 'N'	
					) z on m.lgl_nm = z.lgl_nm 
						AND COALESCE(m.ad_ln_1,'') = COALESCE(z.address_line_1,'')
						AND COALESCE(m.city,'') = COALESCE(z.city,'')
						AND COALESCE(m.st,'') = COALESCE(z.state,'')
						AND COALESCE(m.zip,'') = COALESCE(z.zip,'')
						WHERE m.is_new_vendor = 'N'
						) b
	WHERE b.vendor_address_id IS NULL;
	
	UPDATE etl.tmp_all_vendors a
	SET is_vendor_address_changed = 'Y'
	FROM
	etl.tmp_all_vendors_uniq_id b
	WHERE a.uniq_id = b.uniq_id
	AND a.is_new_vendor = 'N' ;

	
	RAISE NOTICE 'VENDOR 3';

	-- Inserting new addresses in address table
	
	TRUNCATE etl.address_id_seq;

	INSERT INTO etl.address_id_seq(uniq_id)
	SELECT uniq_id
	FROM (SELECT min(uniq_id) as uniq_id, ad_ln_1, st, zip, city
	FROM   etl.tmp_all_vendors
	WHERE  is_address_new ='Y'
	GROUP BY 2,3,4,5) a;
	


	INSERT INTO address(address_id,address_line_1 ,city,
  				state ,zip ) 
	SELECT	min(b.address_id) as address_id,a.ad_ln_1,a.city,
  				a.st ,a.zip  			
  	FROM	etl.tmp_all_vendors a JOIN etl.address_id_seq b ON a.uniq_id = b.uniq_id
  	GROUP BY 2,3,4,5;


	RAISE NOTICE 'VENDOR 4';
	
	-- Inserting new Vendor records

	TRUNCATE etl.vendor_id_seq;
	
	INSERT INTO etl.vendor_id_seq(uniq_id)
	SELECT uniq_id
	FROM (SELECT lgl_nm, min(uniq_id) as uniq_id
	      FROM   etl.tmp_all_vendors
		WHERE  is_new_vendor ='Y' 
		GROUP BY 1) a;

	
	INSERT INTO vendor(vendor_id,legal_name,created_load_id,created_date)
	SELECT 	b.vendor_id,a.lgl_nm,p_load_id_in as created_load_id, now()::timestamp
	FROM	etl.tmp_all_vendors a JOIN etl.vendor_id_seq b ON a.uniq_id = b.uniq_id;
	
	GET DIAGNOSTICS l_count = ROW_COUNT;
			  	IF l_count >0 THEN
					INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
					VALUES(p_load_file_id_in,'TD',l_count,'Number of records inserted into vendor');
	END IF;


	RAISE NOTICE 'VENDOR 5';

	


	-- Inserting the records into vendor_history
	
	TRUNCATE etl.vendor_history_id_seq;
	
	INSERT INTO etl.vendor_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   etl.tmp_all_vendors
	WHERE  is_new_vendor ='Y'  OR is_vendor_address_changed = 'Y' ;


	INSERT INTO vendor_history(vendor_history_id, vendor_id, legal_name,
	    		load_id ,created_date)
		SELECT 	b.vendor_history_id,c.vendor_id,a.lgl_nm,p_load_id_in as load_id, now()::timestamp
		FROM	etl.tmp_all_vendors a JOIN etl.vendor_history_id_seq b ON a.uniq_id = b.uniq_id
			JOIN vendor c ON a.lgl_nm = c.legal_name ;
	
	GET DIAGNOSTICS l_count = ROW_COUNT;
			  	IF l_count >0 THEN
					INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
					VALUES(p_load_file_id_in,'TD',l_count,'Number of records inserted into vendor_history');
	END IF;
	

		
	RAISE NOTICE 'VENDOR 6';	
	
	-- Updating vendor records which have been modified
	
	TRUNCATE etl.tmp_vendor_update ;
	
	INSERT INTO etl.tmp_vendor_update (vendor_id, legal_name, alias_name)
	SELECT vendor_id, x.lgl_nm as legal_name , x.alias_nm as alias_name
	FROM etl.tmp_all_vendors x, etl.vendor_history_id_seq y
	WHERE	x.uniq_id = y.uniq_id AND x.is_new_vendor ='N' 
	AND x.is_vendor_address_changed = 'Y'  ;
	
	UPDATE vendor a
	SET    	legal_name = b.legal_name,
		updated_load_id = p_load_id_in,
		updated_date = now()::timestamp
	FROM	
	etl.tmp_vendor_update b
	WHERE a.vendor_id = b.vendor_id;

	RAISE NOTICE 'VENDOR 7';

		
	
	-- Inserting into vendor_address table

	TRUNCATE etl.vendor_address_id_seq;
	
	INSERT INTO etl.vendor_address_id_seq(uniq_id)
	SELECT uniq_id
	FROM   etl.tmp_all_vendors
	WHERE  is_new_vendor ='Y'  OR is_vendor_address_changed = 'Y' ;

	INSERT INTO vendor_address(vendor_address_id,vendor_history_id,address_id,load_id,created_date)
	SELECT c.vendor_address_id,d.vendor_history_id, e.address_id, p_load_id_in,now()::timestamp
	FROM	etl.tmp_all_vendors a JOIN etl.vendor_history_id_seq d ON a.uniq_id = d.uniq_id
		JOIN address e ON COALESCE(a.ad_ln_1,'') = COALESCE(e.address_line_1,'') 
			   AND COALESCE(a.city,'') = COALESCE(e.city,'')  
			   AND COALESCE(a.st,'') = COALESCE(e.state,'') 
			   AND COALESCE(a.zip,'') = COALESCE(e.zip,'') 
		JOIN etl.vendor_address_id_seq c ON a.uniq_id = c.uniq_id	 ;

	GET DIAGNOSTICS l_count = ROW_COUNT;
			  	IF l_count >0 THEN
					INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
					VALUES(p_load_file_id_in,'ED',l_count,'Number of records inserted into vendor_address');
	END IF;

	RAISE NOTICE 'VENDOR 8';
	
	UPDATE etl.stg_tdc_contract a
	SET agency_id = b.agency_id
	FROM ref_agency b
	WHERE a.agency_code = b.agency_code AND b.agency_code = 'z81';
	
	UPDATE etl.stg_tdc_contract a
	SET vendor_id = b.vendor_id
	FROM vendor b
	WHERE a.contractor_name = b.legal_name;
	
	TRUNCATE  tdc_contract;
	
	INSERT INTO tdc_contract(agency_code, fms_contract_number, fms_commodity_line, tdc_contract_number, purpose, budget_name,
	tdc_registered_amount, vendor_name, agency_id, vendor_id, created_load_id, created_date)
	SELECT agency_code, fms_contract_number, fms_commodity_line, tdc_contract_number, purpose, budget_name, 
	tdc_registered_amount, contractor_name, agency_id, vendor_id, p_load_id_in, now()::timestamp
	FROM etl.stg_tdc_contract ;
	
		
	INSERT INTO oge_contract(agency_code, fms_contract_number, fms_commodity_line, oge_contract_number, purpose, budget_name,
	oge_registered_amount, vendor_name, agency_id, vendor_id, created_load_id, created_date)
	SELECT agency_code, fms_contract_number, fms_commodity_line, min(tdc_contract_number), min(purpose), min(budget_name), 
	sum(tdc_registered_amount), vendor_name, agency_id, vendor_id, p_load_id_in, now()::timestamp
	FROM tdc_contract group by 1,2,3,8,9,10,11;
	
	GET DIAGNOSTICS l_count = ROW_COUNT;	
	
		IF l_count > 0 THEN
			INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
			VALUES(p_load_file_id_in,'TD',l_count, '# of records inserted into tdc_contract');
		END IF;
	
	l_end_time := timeofday()::timestamp;

	INSERT INTO etl.etl_script_execution_status(load_file_id,script_name,completed_flag,start_time,end_time)
	VALUES(p_load_file_id_in,'etl.processTDCContracts',1,l_start_time,l_end_time);
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processTDCContracts';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	
	
		l_end_time := timeofday()::timestamp;
	
	INSERT INTO etl.etl_script_execution_status(load_file_id,script_name,completed_flag,start_time,end_time,errno,errmsg)
	VALUES(p_load_file_id_in,'etl.processTDCContracts',0,l_start_time,l_end_time,SQLSTATE,SQLERRM);
	RETURN 0;	
END;
$$ language plpgsql;