set search_path=public;
/* Functions defined
	updateForeignKeysForFMSInHeader
	
*/
-- Function: etl.processvendor(integer, bigint, character varying)

-- DROP FUNCTION etl.processvendor(integer, bigint, character varying);

CREATE OR REPLACE FUNCTION etl.processsubvendor(p_load_file_id_in integer, p_load_id_in bigint)  RETURNS integer AS $$

DECLARE

	l_data_source_code char(2);
	l_vendor_stg_table VARCHAR;
	l_update_query varchar;
	l_count bigint;

BEGIN


	SELECT data_source_code
	FROM   etl.etl_data_load a 
	WHERE  load_id = p_load_id_in
	INTO   l_data_source_code;

	
	
	TRUNCATE etl.tmp_stg_scntrc_vendor;
	
	
	IF l_data_source_code = 'SF' THEN
	
	UPDATE etl.tmp_stg_scntrc_vendor SET vend_cust_cd = 'N/A' WHERE vend_cust_cd ='N/A (PRIVACY/SECURITY)';
	
	l_vendor_stg_table :='etl.stg_scntrc_pymt';
	
	INSERT INTO etl.tmp_stg_scntrc_vendor(vend_cust_cd, lgl_nm, vendor_history_id, uniq_id)
	SELECT vend_cust_cd, scntrc_lgl_nm, NULL as vendor_history_id, uniq_id
	FROM etl.stg_scntrc_pymt;
	
	ELSIF l_data_source_code = 'SC'  THEN
	
	l_vendor_stg_table :='etl.stg_scntrc_details';
	
	INSERT INTO etl.tmp_stg_scntrc_vendor(vend_cust_cd, lgl_nm, vendor_history_id, uniq_id)
	SELECT vend_cust_cd, scntrc_lgl_nm, NULL as vendor_history_id, uniq_id
	FROM etl.stg_scntrc_details;
	
	ELSE
	
	l_vendor_stg_table :='';
	
	END IF;

	RAISE NOTICE 'SUB VENDOR 0';

	
	-- Getting all vendors and categorizing if they are new and/or name/address/business type changed.
	-- TO DO Filter, Address type, Updating vendor history id
	


	TRUNCATE etl.tmp_scntrc_all_vendors;
	
	INSERT INTO etl.tmp_scntrc_all_vendors
	SELECT MAX(uniq_id), a.vend_cust_cd as vendor_customer_code, COALESCE(MAX(b.vendor_history_id),0) as vendor_history_id, COALESCE(MAX(b.vendor_id),0) as vendor_id, 
				'N' as is_new_vendor, 'N' as is_name_changed, 'N' as is_bus_type_changed, lgl_nm
	FROM etl.tmp_stg_scntrc_vendor a LEFT JOIN 
	(SELECT max(b.vendor_id) as vendor_id, max(c.vendor_history_id) as vendor_history_id, b.vendor_customer_code 
	FROM subvendor b, subvendor_history c
	WHERE  b.vendor_id = c.vendor_id
	GROUP BY 3) b
	ON a.vend_cust_cd = b.vendor_customer_code	
	GROUP BY 2,5,6,7,8;

	RAISE NOTICE 'SUBVENDOR 001';
	
	-- Identifying new vendors
	
	UPDATE etl.tmp_scntrc_all_vendors
	SET is_new_vendor = 'Y'
	WHERE coalesce(vendor_history_id,0) =0 ;

	RAISE NOTICE 'SUBVENDOR 02';
	-- Identifying existing vendors for which legal/alias name changed 
	
	TRUNCATE etl.tmp_scntrc_all_vendors_uniq_id ;
	
	INSERT INTO etl.tmp_scntrc_all_vendors_uniq_id
	SELECT uniq_id
	FROM etl.tmp_scntrc_all_vendors a , vendor b
	WHERE a.vendor_customer_code = b.vendor_customer_code
	AND a.is_new_vendor = 'N' AND COALESCE(a.lgl_nm, '') <>  COALESCE(b.legal_name, '') ;
	
	
	UPDATE etl.tmp_scntrc_all_vendors a
	SET is_name_changed = 'Y'
	FROM
	etl.tmp_scntrc_all_vendors_uniq_id b
	WHERE a.uniq_id = b.uniq_id AND a.is_new_vendor = 'N';

	RAISE NOTICE 'SUBVENDOR 1';


	-- Identifying existing vendors for which vendor business type information changed 

	TRUNCATE etl.tmp_scntrc_all_vendors_uniq_id ;
	
	INSERT INTO etl.tmp_scntrc_all_vendors_uniq_id
	SELECT distinct a.uniq_id
	FROM etl.tmp_scntrc_all_vendors a JOIN
	(SELECT distinct vendor_customer_code FROM
	(SELECT coalesce(z.vendor_customer_code, a.vendor_customer_code) as vendor_customer_code,
		(CASE WHEN vendor_business_type_id IS NOT NULL AND b.vendor_customer_code IS NOT NULL THEN 'N' 
			WHEN vendor_business_type_id IS NOT NULL AND b.vendor_customer_code IS NULL  THEN 'Y'
			WHEN vendor_business_type_id IS NULL AND b.vendor_customer_code IS NOT NULL  THEN 'Y'
			ELSE NULL END) as modified_flag
	FROM subcontract_vendor_business_type a JOIN (SELECT distinct vendor_customer_code FROM etl.tmp_scntrc_all_vendors WHERE is_new_vendor = 'N') b ON a.vendor_customer_code = b.vendor_customer_code
		FULL OUTER JOIN (SELECT g.vendor_customer_code, g.uniq_id, d.vendor_business_type_id,b.business_type_id, status, minority_type_id
		                 FROM subvendor_business_type d , ref_business_type b , subvendor_history e, etl.tmp_scntrc_all_vendors g
						WHERE  d.business_type_id = b.business_type_id AND e.vendor_history_id = d.vendor_history_id
						AND g.vendor_history_id = e.vendor_history_id AND g.is_new_vendor = 'N' ) as z ON a.vendor_customer_code = z.vendor_customer_code AND a.business_type_id=z.business_type_id
						AND a.status = z.status AND COALESCE(a.minority_type_id,0) = COALESCE(z.minority_type_id,0)) b WHERE b.modified_flag = 'Y') c
	ON a.vendor_customer_code = c.vendor_customer_code;
	
	
	UPDATE etl.tmp_scntrc_all_vendors a
	SET is_bus_type_changed = 'Y'
	FROM etl.tmp_scntrc_all_vendors_uniq_id b	
	WHERE a.uniq_id = b.uniq_id
	AND a.is_new_vendor = 'N'; 
	
	RAISE NOTICE 'SUBVENDOR 3';


	
	-- Inserting new Vendor records

	TRUNCATE etl.scntrc_vendor_id_seq;
	
	INSERT INTO etl.scntrc_vendor_id_seq(uniq_id)
	SELECT uniq_id
	FROM (SELECT vendor_customer_code, min(uniq_id) as uniq_id
	      FROM   etl.tmp_scntrc_all_vendors
		WHERE  is_new_vendor ='Y' 
		GROUP BY 1) a;

	
	INSERT INTO subvendor(vendor_id,vendor_customer_code,legal_name,created_load_id,created_date)
	SELECT 	b.vendor_id,a.vendor_customer_code,a.lgl_nm,p_load_id_in as created_load_id, now()::timestamp
	FROM	etl.tmp_scntrc_all_vendors a JOIN etl.scntrc_vendor_id_seq b ON a.uniq_id = b.uniq_id;
	
	GET DIAGNOSTICS l_count = ROW_COUNT;
			  	IF l_count >0 THEN
					INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
					VALUES(p_load_file_id_in,'SV',l_count,'Number of records inserted into subvendor');
	END IF;


	RAISE NOTICE 'SUBVENDOR 5';

	


	-- Inserting the records into vendor_history
	
	TRUNCATE etl.scntrc_vendor_history_id_seq;
	
	INSERT INTO etl.scntrc_vendor_history_id_seq(uniq_id)
	SELECT uniq_id
	FROM   etl.tmp_scntrc_all_vendors
	WHERE  is_new_vendor ='Y' OR is_name_changed='Y'  OR is_bus_type_changed = 'Y';


	INSERT INTO subvendor_history(vendor_history_id, vendor_id, legal_name,
	    		load_id ,created_date)
		SELECT 	b.vendor_history_id,c.vendor_id,a.lgl_nm,p_load_id_in as load_id, now()::timestamp
		FROM	etl.tmp_scntrc_all_vendors a JOIN etl.scntrc_vendor_history_id_seq b ON a.uniq_id = b.uniq_id
			JOIN subvendor c ON a.vendor_customer_code = c.vendor_customer_code ;
	
	GET DIAGNOSTICS l_count = ROW_COUNT;
			  	IF l_count >0 THEN
					INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
					VALUES(p_load_file_id_in,'SV',l_count,'Number of records inserted into subvendor_history');
	END IF;
	
	
	RAISE NOTICE 'SUBVENDOR 6';	
	
	-- Updating vendor records which have been modified
	
	TRUNCATE etl.tmp_scntrc_vendor_update ;
	
	INSERT INTO etl.tmp_scntrc_vendor_update (vendor_id, legal_name)
	SELECT vendor_id, x.lgl_nm as legal_name , x.alias_nm as alias_name
	FROM etl.tmp_scntrc_all_vendors x, etl.scntrc_vendor_history_id_seq y
	WHERE	x.uniq_id = y.uniq_id AND x.is_new_vendor ='N' 
	AND (x.is_name_changed='Y' OR x.is_bus_type_changed = 'Y') ;
	
	UPDATE subvendor a
	SET    	legal_name = b.legal_name,
			updated_load_id = p_load_id_in,
		updated_date = now()::timestamp
	FROM	
	etl.tmp_scntrc_vendor_update b
	WHERE a.vendor_id = b.vendor_id;

	RAISE NOTICE 'SUBVENDOR 7';

		
	-- Update history id in the main staging table such as stg_fmsv_vendor based on fields such as customer code through address fields for the changed non miscellaneous vendor
	
	UPDATE etl.tmp_stg_scntrc_vendor a
	SET vendor_history_id = b.vendor_history_id
	FROM
	(select y.vendor_history_id, x.vendor_customer_code, x.lgl_nm, 
						is_new_vendor, is_name_changed,  is_bus_type_changed
	FROM etl.tmp_scntrc_all_vendors x, etl.scntrc_vendor_history_id_seq  y
	WHERE x.uniq_id = y.uniq_id 
	AND (x.is_new_vendor = 'Y' OR x.is_name_changed = 'Y'  OR x.is_bus_type_changed = 'Y')
	) b
	WHERE a.vend_cust_cd = b.vendor_customer_code AND coalesce(a.lgl_nm,'') = coalesce(b.lgl_nm,'')
	 AND (b.is_new_vendor = 'Y' OR b.is_name_changed = 'Y'  OR b.is_bus_type_changed = 'Y') ;


	RAISE NOTICE 'SUBVENDOR 71';
	-- Update history id in the main staging table such as stg_fmsv_vendor based on customer code for the unchanged vendors
	
	UPDATE etl.tmp_stg_scntrc_vendor a
	SET vendor_history_id = b.vendor_history_id
	FROM
	(SELECT vendor_history_id,  vendor_customer_code
	FROM etl.tmp_scntrc_all_vendors 
	WHERE  is_new_vendor = 'N' AND is_name_changed = 'N'  AND is_bus_type_changed = 'N') b
	WHERE a.vend_cust_cd = b.vendor_customer_code ;


	RAISE NOTICE 'SUBVENDOR 72';

	
	l_update_query := 'UPDATE ' || l_vendor_stg_table || ' a SET vendor_history_id = b.vendor_history_id ' || 
	' FROM etl.tmp_stg_scntrc_vendor b ' || 
	' WHERE a.uniq_id = b.uniq_id ' ;
	
	raise notice 'l_update_query  is  %',l_update_query;
	
	EXECUTE l_update_query;
	
	RAISE NOTICE 'VENDOR 74';
	

	
	-- Inserting into  vendor_business_types table

		
	INSERT INTO subvendor_business_type(vendor_history_id,business_type_id,status,  minority_type_id,load_id,created_date)
    	SELECT  d.vendor_history_id, b.business_type_id, b.status, b.minority_type_id, p_load_id_in, now()::timestamp
    	FROM	etl.tmp_scntrc_all_vendors a JOIN subcontract_vendor_business_type b ON a.vendor_customer_code = b.vendor_customer_code    		
		JOIN etl.vendor_history_id_seq d ON a.uniq_id = d.uniq_id
		WHERE a.is_new_vendor ='Y' OR a.is_name_changed='Y'  OR a.is_bus_type_changed = 'Y';

	GET DIAGNOSTICS l_count = ROW_COUNT;
			  	IF l_count >0 THEN
					INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
					VALUES(p_load_file_id_in,'SV',l_count,'Number of records inserted into subvendor_business_type');
	END IF;
	

	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processsubvendor';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$   LANGUAGE 'plpgsql' VOLATILE;




