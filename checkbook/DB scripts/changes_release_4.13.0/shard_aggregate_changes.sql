-- shard changes for aggregate tables

SET search_path = public;

DROP TABLE IF EXISTS aggregateon_contracts_cumulative_spending;

CREATE TABLE aggregateon_contracts_cumulative_spending
(
  original_agreement_id bigint,
  fiscal_year smallint,
  fiscal_year_id smallint,
  document_code_id smallint,
  master_agreement_yn character(1),
  description character varying,
  contract_number character varying,
  vendor_id integer,
  award_method_id smallint,
  agency_id smallint,
  industry_type_id smallint,
  award_size_id smallint,
  original_contract_amount numeric(16,2),
  maximum_contract_amount numeric(16,2),
  spending_amount_disb numeric(16,2),
  spending_amount numeric(16,2),
  current_year_spending_amount numeric(16,2),
  dollar_difference numeric(16,2),
  percent_difference numeric(16,2),
  scntrc_status smallint,
  status_flag character(1),
  type_of_year character(1)
)DISTRIBUTED BY (vendor_id);

CREATE INDEX idx_orig_agr_id_aggregateon_contracts_cumulative_spending ON aggregateon_contracts_cumulative_spending(original_agreement_id);
CREATE INDEX idx_vendor_id_aggregateon_contracts_cumulative_spending ON aggregateon_contracts_cumulative_spending(vendor_id);
CREATE INDEX idx_agency_id_aggregateon_contracts_cumulative_spending ON aggregateon_contracts_cumulative_spending(agency_id);
CREATE INDEX idx_fiscal_year_id_aggregateon_contracts_cumulative_spending ON aggregateon_contracts_cumulative_spending(fiscal_year_id);

SET search_path = staging;
DROP  VIEW  IF EXISTS aggregateon_contracts_cumulative_spending;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_contracts_cumulative_spending__0;


CREATE EXTERNAL WEB TABLE aggregateon_contracts_cumulative_spending__0(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	master_agreement_yn character(1),
	description varchar,
	contract_number varchar,
	vendor_id int,
	award_method_id smallint,
	agency_id smallint,
	industry_type_id smallint,
        award_size_id smallint,
	original_contract_amount numeric(16,2),
	maximum_contract_amount numeric(16,2),
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	current_year_spending_amount numeric(16,2),
	dollar_difference numeric(16,2),
	percent_difference numeric(16,2),
        scntrc_status smallint,
	status_flag char(1),
	type_of_year char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_contracts_cumulative_spending to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';	 
  
  CREATE VIEW aggregateon_contracts_cumulative_spending AS
  	SELECT aggregateon_contracts_cumulative_spending__0.original_agreement_id,aggregateon_contracts_cumulative_spending__0.fiscal_year,
  	aggregateon_contracts_cumulative_spending__0.fiscal_year_id,
  		aggregateon_contracts_cumulative_spending__0.document_code_id,aggregateon_contracts_cumulative_spending__0.master_agreement_yn,
  		aggregateon_contracts_cumulative_spending__0.description,aggregateon_contracts_cumulative_spending__0.contract_number,
  		aggregateon_contracts_cumulative_spending__0.vendor_id,aggregateon_contracts_cumulative_spending__0.award_method_id,
  		aggregateon_contracts_cumulative_spending__0.agency_id,aggregateon_contracts_cumulative_spending__0.industry_type_id,aggregateon_contracts_cumulative_spending__0.award_size_id,
  		aggregateon_contracts_cumulative_spending__0.original_contract_amount,aggregateon_contracts_cumulative_spending__0.maximum_contract_amount,aggregateon_contracts_cumulative_spending__0.spending_amount_disb,
  		aggregateon_contracts_cumulative_spending__0.spending_amount,aggregateon_contracts_cumulative_spending__0.current_year_spending_amount,
  		aggregateon_contracts_cumulative_spending__0.dollar_difference,aggregateon_contracts_cumulative_spending__0.percent_difference,
  		aggregateon_contracts_cumulative_spending__0.scntrc_status,aggregateon_contracts_cumulative_spending__0.status_flag,aggregateon_contracts_cumulative_spending__0.type_of_year
  	FROM aggregateon_contracts_cumulative_spending__0;


SET search_path = public;

DROP TABLE IF EXISTS aggregateon_mwbe_contracts_cumulative_spending;

CREATE TABLE aggregateon_mwbe_contracts_cumulative_spending
(
  original_agreement_id bigint,
  fiscal_year smallint,
  fiscal_year_id smallint,
  document_code_id smallint,
  master_agreement_yn character(1),
  description character varying,
  contract_number character varying,
  vendor_id integer,
  minority_type_id smallint,
  award_method_id smallint,
  agency_id smallint,
  industry_type_id smallint,
  award_size_id smallint,
  original_contract_amount numeric(16,2),
  maximum_contract_amount numeric(16,2),
  spending_amount_disb numeric(16,2),
  spending_amount numeric(16,2),
  current_year_spending_amount numeric(16,2),
  dollar_difference numeric(16,2),
  percent_difference numeric(16,2),
  scntrc_status smallint,
  status_flag character(1),
  type_of_year character(1)
)DISTRIBUTED BY (vendor_id);


CREATE INDEX idx_orig_agr_id_aggon_mwbe_contracts_cumulative_spending ON aggregateon_mwbe_contracts_cumulative_spending(original_agreement_id);
CREATE INDEX idx_vendor_id_aggon_mwbe_contracts_cumulative_spending ON aggregateon_mwbe_contracts_cumulative_spending(vendor_id);
CREATE INDEX idx_agency_id_aggon_mwbe_contracts_cumulative_spending ON aggregateon_mwbe_contracts_cumulative_spending(agency_id);
CREATE INDEX idx_fiscal_year_id_aggon_mwbe_contracts_cumulative_spending ON aggregateon_mwbe_contracts_cumulative_spending(fiscal_year_id);

SET search_path = staging;
DROP  VIEW  IF EXISTS aggregateon_mwbe_contracts_cumulative_spending;
DROP EXTERNAL WEB TABLE IF EXISTS aggregateon_mwbe_contracts_cumulative_spending__0;


  	CREATE EXTERNAL WEB TABLE aggregateon_mwbe_contracts_cumulative_spending__0(
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	master_agreement_yn character(1),
	description varchar,
	contract_number varchar,
	vendor_id int,
	minority_type_id smallint,
	award_method_id smallint,
	agency_id smallint,
	industry_type_id smallint,
        award_size_id smallint,
	original_contract_amount numeric(16,2),
	maximum_contract_amount numeric(16,2),
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	current_year_spending_amount numeric(16,2),
	dollar_difference numeric(16,2),
	percent_difference numeric(16,2),
        scntrc_status smallint,
	status_flag char(1),
	type_of_year char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_contracts_cumulative_spending to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';	 
  
  CREATE VIEW aggregateon_mwbe_contracts_cumulative_spending AS
  	SELECT aggregateon_mwbe_contracts_cumulative_spending__0.original_agreement_id,aggregateon_mwbe_contracts_cumulative_spending__0.fiscal_year,
  	aggregateon_mwbe_contracts_cumulative_spending__0.fiscal_year_id,
  		aggregateon_mwbe_contracts_cumulative_spending__0.document_code_id,aggregateon_mwbe_contracts_cumulative_spending__0.master_agreement_yn,
  		aggregateon_mwbe_contracts_cumulative_spending__0.description,aggregateon_mwbe_contracts_cumulative_spending__0.contract_number,
  		aggregateon_mwbe_contracts_cumulative_spending__0.vendor_id,aggregateon_mwbe_contracts_cumulative_spending__0.minority_type_id,aggregateon_mwbe_contracts_cumulative_spending__0.award_method_id,
  		aggregateon_mwbe_contracts_cumulative_spending__0.agency_id,aggregateon_mwbe_contracts_cumulative_spending__0.industry_type_id,aggregateon_mwbe_contracts_cumulative_spending__0.award_size_id,
  		aggregateon_mwbe_contracts_cumulative_spending__0.original_contract_amount,aggregateon_mwbe_contracts_cumulative_spending__0.maximum_contract_amount,aggregateon_mwbe_contracts_cumulative_spending__0.spending_amount_disb,
  		aggregateon_mwbe_contracts_cumulative_spending__0.spending_amount,aggregateon_mwbe_contracts_cumulative_spending__0.current_year_spending_amount,
  		aggregateon_mwbe_contracts_cumulative_spending__0.dollar_difference,aggregateon_mwbe_contracts_cumulative_spending__0.percent_difference,
  		aggregateon_mwbe_contracts_cumulative_spending__0.scntrc_status,aggregateon_mwbe_contracts_cumulative_spending__0.status_flag,aggregateon_mwbe_contracts_cumulative_spending__0.type_of_year
  	FROM aggregateon_mwbe_contracts_cumulative_spending__0;

SET search_path = public;
select grantaccess('webuser1','SELECT');

