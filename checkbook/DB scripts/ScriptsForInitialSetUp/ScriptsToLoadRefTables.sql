COPY etl.ref_data_source FROM '/home/gpadmin/athiagarajan/NYC/ref_data_source.csv' CSV QUOTE as '"';

COPY etl.ref_column_mapping FROM '/home/gpadmin/athiagarajan/NYC/ref_column_mapping.csv' CSV QUOTE as '"';

COPY etl.ref_validation_rule FROM '/home/gpadmin/athiagarajan/NYC/ref_validation_rule.csv' CSV QUOTE as '"';


INSERT INTO ref_address_type(address_type_code,address_type_name,created_date) VALUES('BI','Billing',now()::timestamp),
											('PA','Payment',now()::timestamp),
											('PR','Ordering',now()::timestamp),
											('WR','Account Administrator',now()::timestamp),
											('OT','Other',now()::timestamp);
											
  
COPY etl.stg_agreement_type FROM '/home/gpadmin/athiagarajan/NYC/datafiles/AgreementTypeFromSQLServer.csv' DELIMITER AS ',' ;
  
insert into ref_agreement_type(agreement_type_code,agreement_type_name,created_date) SELECT agreement_type_code,name,now()::timestamp from etl.stg_agreement_type;											

COPY etl.stg_award_category FROM '/home/gpadmin/athiagarajan/NYC/datafiles/AgreementCategoryFromSQLServer.csv' CSV QUOTE as '"' ;

INSERT INTO ref_award_category(award_category_code,award_category_name,created_date) SELECT award_category_code, award_method_name,now()::timestamp  from etl.stg_award_category;  

COPY etl.stg_award_method FROM '/home/gpadmin/athiagarajan/NYC/datafiles/AwardMethodFromSQLServer.csv' CSV QUOTE as '"' ;

INSERT INTO ref_award_method(award_method_code,award_method_name,created_date) SELECT  award_method_code,award_method_name,now()::timestamp  FROM etl.stg_award_method;


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
				     
INSERT INTO ref_miscellaneous_vendor(vendor_customer_code,created_date) values ('JUDGCLAIMS',now()::timestamp),('MISCPAYVEN',now()::timestamp);
				     