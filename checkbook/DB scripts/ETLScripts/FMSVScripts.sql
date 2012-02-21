/*
Functions defined
	processFMSVVendor
*/
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
			   vendor_sub_code,created_load_id,created_date)
	SELECT 	b.vendor_id,a.vendor_customer_code,a.legal_name,a.alias_name,a.miscellaneous_vendor_flag,
		NULL as vendor_sub_code,p_load_id_in as load_id, now()::timestamp
	FROM	tmp_vendor a JOIN etl.vendor_id_seq b ON a.uniq_id = b.uniq_id;


	RAISE NOTICE '2';
	
	-- Updating vendor records which have been modified
	
	CREATE TEMPORARY TABLE tmp_vendor_update(vendor_id int, legal_name varchar, alias_name varchar)
	DISTRIBUTED BY (vendor_id);
	
	UPDATE vendor a
	SET    legal_name = b.legal_name,
		alias_name = b.alias_name,
		updated_load_id = p_load_id_in,
		updated_date = now()::timestamp
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