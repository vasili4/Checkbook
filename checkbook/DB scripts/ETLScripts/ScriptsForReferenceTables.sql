CREATE OR REPLACE FUNCTION etl.initializedate(p_start_date_in date, p_end_date_in date) RETURNS INT AS $$
DECLARE
	l_no_of_days int;
BEGIN
	l_no_of_days := p_end_date_in - p_start_date_in;
	
	IF l_no_of_days > 0 THEN
		INSERT INTO ref_date(date)
		SELECT p_start_date_in + s.a as dates 
		FROM   generate_series(1,l_no_of_days,1) as s(a);

		RETURN 1;
	ELSE
		RETURN 2;
	END IF;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in etl.initializedate';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;	
END;
$$ language plpgsql;

--------------------------------------------------------------------------------------------------------------------------------

INSERT INTO ref_address_type(address_type_code,address_type_name,created_date) VALUES('BI','Billing',now()::timestamp),
											('PA','Payment',now()::timestamp),
											('PR','Ordering',now()::timestamp),
											('WR','Account Administrator',now()::timestamp),
											('OT','Other',now()::timestamp);
											
INSERT INTO ref_business_type(business_type_code,business_type_name,created_date) values ('EENT','Emerging Enterprises Business',now()::timestamp),
				     ('EXMP','Exempt From MWBE Rpt Card',now()::timestamp),
				     ('LOCB','Local Business',now()::timestamp),
				     ('MNRT','Minority Owned',now()::timestamp),
				     ('WMNO','Woman Owned',now()::timestamp);
				     
INSERT INTO ref_minority_type values (1,'Unspecified MWBE',now()::timestamp),
				     (2,'African American',now()::timestamp),
				     (3,'Hispanic American',now()::timestamp),
				     (4,'Asian-Pacific',now()::timestamp),
				     (5,'Asian-Indian',now()::timestamp),
				     (6,'Native',now()::timestamp),
				     (7,'Non-Minority',now()::timestamp),
				     (8,'Other',now()::timestamp),
				     (9,'Caucasian Woman',now()::timestamp),
				     (10,'Asian American',now()::timestamp);		
				     
INSERT INTO ref_business_type_status values (1,'Requested',now()::timestamp),
					(2,'Accepted',now()::timestamp),
					(3,'Rejected',now()::timestamp);