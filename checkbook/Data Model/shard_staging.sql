--
-- Greenplum Database database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET default_with_oids = false;

--
-- Name: staging; Type: SCHEMA; Schema: -; Owner: gpadmin
--

CREATE SCHEMA staging;


ALTER SCHEMA staging OWNER TO gpadmin;

SET search_path = staging, pg_catalog;

SET default_tablespace = '';

--
-- Name: address__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE address__0 (
    address_id integer,
    address_line_1 character varying,
    address_line_2 character varying,
    city character varying,
    state character varying,
    zip character varying,
    country character varying
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.address to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: address; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW address AS
    SELECT address__0.address_id, address__0.address_line_1, address__0.address_line_2, address__0.city, address__0.state, address__0.zip, address__0.country FROM ONLY address__0;

--
-- Name: aggregateon_spending_coa_entities__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE aggregateon_spending_coa_entities__0 (
    department_id integer,
    agency_id smallint,
    spending_category_id smallint,
    expenditure_object_id integer,
    vendor_id integer,
    month_id int,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric,
    total_disbursements integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_spending_coa_entities to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: aggregateon_spending_coa_entities; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW aggregateon_spending_coa_entities AS
    SELECT aggregateon_spending_coa_entities__0.department_id, aggregateon_spending_coa_entities__0.agency_id, aggregateon_spending_coa_entities__0.spending_category_id, 
    	aggregateon_spending_coa_entities__0.expenditure_object_id, aggregateon_spending_coa_entities__0.vendor_id, aggregateon_spending_coa_entities__0.month_id, aggregateon_spending_coa_entities__0.year_id, 
    	aggregateon_spending_coa_entities__0.type_of_year, 	aggregateon_spending_coa_entities__0.total_spending_amount,aggregateon_spending_coa_entities__0.total_disbursements FROM ONLY aggregateon_spending_coa_entities__0;

--
-- Name: aggregateon_spending_contract__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE aggregateon_spending_contract__0 (
    agreement_id bigint,
    document_id character varying,
    document_code character varying,
    vendor_id integer,
    agency_id smallint,
    description character varying,
    spending_category_id smallint,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric,
    total_contract_amount numeric
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_spending_contract to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: aggregateon_spending_contract; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW aggregateon_spending_contract AS
    SELECT aggregateon_spending_contract__0.agreement_id, aggregateon_spending_contract__0.document_id, aggregateon_spending_contract__0.document_code,aggregateon_spending_contract__0.vendor_id, 
    aggregateon_spending_contract__0.agency_id, aggregateon_spending_contract__0.description, aggregateon_spending_contract__0.spending_category_id, aggregateon_spending_contract__0.year_id,aggregateon_spending_contract__0.type_of_year, 
    aggregateon_spending_contract__0.total_spending_amount, aggregateon_spending_contract__0.total_contract_amount FROM ONLY aggregateon_spending_contract__0;

--
-- Name: aggregateon_spending_vendor__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE aggregateon_spending_vendor__0 (
    vendor_id integer,
    agency_id smallint,
    spending_category_id smallint,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric,
    total_contract_amount numeric,
    is_all_categories char(1)
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_spending_vendor to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: aggregateon_spending_vendor; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW aggregateon_spending_vendor AS
    SELECT aggregateon_spending_vendor__0.vendor_id, aggregateon_spending_vendor__0.agency_id, aggregateon_spending_vendor__0.spending_category_id, aggregateon_spending_vendor__0.year_id,
    aggregateon_spending_vendor__0.type_of_year, aggregateon_spending_vendor__0.total_spending_amount, aggregateon_spending_vendor__0.total_contract_amount, aggregateon_spending_vendor__0.is_all_categories FROM ONLY aggregateon_spending_vendor__0;


CREATE EXTERNAL WEB TABLE aggregateon_spending_vendor_exp_object__0(
	vendor_id integer,
	expenditure_object_id integer,
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2) 
)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_spending_vendor_exp_object to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

CREATE VIEW aggregateon_spending_vendor_exp_object AS
	SELECT aggregateon_spending_vendor_exp_object__0.vendor_id, aggregateon_spending_vendor_exp_object__0.expenditure_object_id, aggregateon_spending_vendor_exp_object__0.spending_category_id,
		aggregateon_spending_vendor_exp_object__0.year_id ,aggregateon_spending_vendor_exp_object__0.type_of_year ,
		aggregateon_spending_vendor_exp_object__0.total_spending_amount FROM aggregateon_spending_vendor_exp_object__0;
		
		

--
-- Name: budget__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE budget__0 (
    budget_id integer,
    budget_fiscal_year smallint,
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    budget_code_id integer,
    object_class_history_id integer,
    adopted_amount_original numeric,
    adopted_amount numeric,
    current_budget_amount_original numeric,
    current_budget_amount numeric,
    pre_encumbered_amount_original numeric,
    pre_encumbered_amount numeric,
    encumbered_amount_original numeric,
    encumbered_amount numeric,
    accrued_expense_amount_original numeric,
    accrued_expense_amount numeric,
    cash_expense_amount_original numeric,
    cash_expense_amount numeric,
    post_closing_adjustment_amount_original numeric,
    post_closing_adjustment_amount numeric,
    total_expenditure_amount numeric,
    remaining_budget numeric,
    source_updated_date_id int,
    budget_fiscal_year_id smallint,
    agency_id smallint,
    object_class_id integer,
    department_id integer,    
    agency_name varchar,
    object_class_name varchar,
    department_name varchar,    
    budget_code varchar,
    budget_code_name varchar,
    agency_code varchar,
    department_code varchar,
    object_class_code varchar,    
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    agency_short_name varchar,
    department_short_name varchar,
    job_id bigint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.budget to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: budget; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW budget AS
    SELECT budget__0.budget_id, budget__0.budget_fiscal_year, budget__0.fund_class_id, budget__0.agency_history_id, budget__0.department_history_id, budget__0.budget_code_id, 
    budget__0.object_class_history_id, budget__0.adopted_amount_original, budget__0.adopted_amount, budget__0.current_budget_amount_original, budget__0.current_budget_amount, 
    budget__0.pre_encumbered_amount_original, budget__0.pre_encumbered_amount, budget__0.encumbered_amount_original, budget__0.encumbered_amount, budget__0.accrued_expense_amount_original,budget__0.accrued_expense_amount, 
    budget__0.cash_expense_amount_original, budget__0.cash_expense_amount, budget__0.post_closing_adjustment_amount_original, budget__0.post_closing_adjustment_amount,  budget__0.total_expenditure_amount,budget__0.remaining_budget, 
    budget__0.source_updated_date_id, budget__0.budget_fiscal_year_id, budget__0.agency_id, budget__0.object_class_id, budget__0.department_id, 
    budget__0.agency_name, budget__0.object_class_name,budget__0.department_name,
    budget__0.budget_code, budget__0.budget_code_name,
    budget__0.agency_code, budget__0.department_code,budget__0.object_class_code,
    budget__0.created_load_id, budget__0.updated_load_id,budget__0.created_date,budget__0.updated_date,
    budget__0.agency_short_name, budget__0.department_short_name,budget__0.job_id
    FROM ONLY budget__0;

--
-- Name: disbursement__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE disbursement__0 (
    disbursement_id integer,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying,
    document_version integer,
    disbursement_number character varying(40),
    record_date_id int,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period bpchar,
    check_eft_amount_original numeric,
    check_eft_amount numeric,
    check_eft_issued_date_id int,
    check_eft_record_date_id int,
    expenditure_status_id smallint,
    expenditure_cancel_type_id smallint,
    expenditure_cancel_reason_id integer,
    total_accounting_line_amount_original numeric,
    total_accounting_line_amount numeric,
    vendor_history_id integer,
    retainage_amount_original numeric,
    retainage_amount numeric,
    privacy_flag bpchar,
    vendor_org_classification smallint,
    bustype_mnrt character varying(4),
	bustype_mnrt_status smallint,
	minority_type_id smallint,
	bustype_wmno character varying(4),
	bustype_wmno_status smallint,
	bustype_locb character varying(4),
	bustype_locb_status smallint,
	bustype_eent character varying(4),
	bustype_eent_status smallint,
	bustype_exmp character varying(4),
	bustype_exmp_status smallint,
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.disbursement to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: disbursement; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW disbursement AS
    SELECT disbursement__0.disbursement_id, disbursement__0.document_code_id, disbursement__0.agency_history_id, disbursement__0.document_id, 
    disbursement__0.document_version,disbursement__0.disbursement_number, disbursement__0.record_date_id, disbursement__0.budget_fiscal_year, disbursement__0.document_fiscal_year, 
    disbursement__0.document_period, disbursement__0.check_eft_amount_original, disbursement__0.check_eft_amount, disbursement__0.check_eft_issued_date_id, disbursement__0.check_eft_record_date_id, 
    disbursement__0.expenditure_status_id, disbursement__0.expenditure_cancel_type_id, disbursement__0.expenditure_cancel_reason_id, disbursement__0.total_accounting_line_amount_original, 
    disbursement__0.total_accounting_line_amount, disbursement__0.vendor_history_id, disbursement__0.retainage_amount_original, disbursement__0.retainage_amount, disbursement__0.privacy_flag, disbursement__0.vendor_org_classification,  
    disbursement__0.bustype_mnrt, disbursement__0.bustype_mnrt_status, disbursement__0.minority_type_id, disbursement__0.bustype_wmno, disbursement__0.bustype_wmno_status, 
    disbursement__0.bustype_locb, disbursement__0.bustype_locb_status, disbursement__0.bustype_eent, disbursement__0.bustype_eent_status, disbursement__0.bustype_exmp, disbursement__0.bustype_exmp_status,     
    disbursement__0.created_load_id, disbursement__0.updated_load_id, disbursement__0.created_date , disbursement__0.updated_date FROM ONLY disbursement__0;
    
--
-- Name: disbursement_line_item__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE disbursement_line_item__0 (
    disbursement_line_item_id bigint,
    disbursement_id integer,
    line_number integer,
    disbursement_number character varying(40),
    budget_fiscal_year smallint,
    fiscal_year smallint,
    fiscal_period bpchar,
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    expenditure_object_history_id integer,
    budget_code_id integer,
    fund_code varchar(4),
    reporting_code character varying,
    check_amount_original numeric,
    check_amount numeric,
    agreement_id bigint,
    agreement_accounting_line_number integer,
    agreement_commodity_line_number integer,
    agreement_vendor_line_number integer, 
    reference_document_number character varying,
    reference_document_code varchar(8),
    location_history_id integer,
    retainage_amount_original numeric,
    retainage_amount numeric,
    check_eft_issued_nyc_year_id smallint,
    file_type char(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone    
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.disbursement_line_item to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: disbursement_line_item; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW disbursement_line_item AS
    SELECT disbursement_line_item__0.disbursement_line_item_id, disbursement_line_item__0.disbursement_id, disbursement_line_item__0.line_number,disbursement_line_item__0.disbursement_number,
    disbursement_line_item__0.budget_fiscal_year, disbursement_line_item__0.fiscal_year, disbursement_line_item__0.fiscal_period, 
    disbursement_line_item__0.fund_class_id, disbursement_line_item__0.agency_history_id, disbursement_line_item__0.department_history_id, 
    disbursement_line_item__0.expenditure_object_history_id, disbursement_line_item__0.budget_code_id, disbursement_line_item__0.fund_code, 
    disbursement_line_item__0.reporting_code, disbursement_line_item__0.check_amount_original, disbursement_line_item__0.check_amount, disbursement_line_item__0.agreement_id, 
    disbursement_line_item__0.agreement_accounting_line_number, disbursement_line_item__0.agreement_commodity_line_number, disbursement_line_item__0.agreement_vendor_line_number, 
    disbursement_line_item__0.reference_document_number, disbursement_line_item__0.reference_document_code, 
    disbursement_line_item__0.location_history_id, disbursement_line_item__0.retainage_amount_original, disbursement_line_item__0.retainage_amount,
    disbursement_line_item__0.check_eft_issued_nyc_year_id, disbursement_line_item__0.file_type, disbursement_line_item__0.created_load_id,disbursement_line_item__0.updated_load_id,
    disbursement_line_item__0.created_date, disbursement_line_item__0.updated_date  FROM ONLY disbursement_line_item__0;

--
-- Name: disbursement_line_item_details__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE disbursement_line_item_details__0 (
    disbursement_line_item_id bigint,
	disbursement_id integer,
	line_number integer,
	disbursement_number character varying(40),
	check_eft_issued_date_id int,
	check_eft_issued_nyc_year_id smallint,
	fiscal_year smallint,
	check_eft_issued_cal_month_id int,
	agreement_id bigint,
	master_agreement_id bigint,
	fund_class_id smallint,
	check_amount numeric(16,2),
	agency_id smallint,
	agency_history_id smallint,
	agency_code varchar(20),
	expenditure_object_id integer,
	vendor_id integer,
	department_id integer,
	maximum_contract_amount numeric(16,2),
	maximum_contract_amount_cy numeric(16,2),
	maximum_spending_limit numeric(16,2),
	maximum_spending_limit_cy numeric(16,2),
	document_id varchar(20),
	vendor_name varchar,
	vendor_customer_code varchar(20), 
	check_eft_issued_date date,
	agency_name varchar(100),	
	agency_short_name character varying(15),  	
	location_name varchar,
	location_code varchar(4),
	department_name varchar(100),
	department_short_name character varying(15),
	department_code varchar(20),
	expenditure_object_name varchar(40),
	expenditure_object_code varchar(4),
	budget_code_id integer,
	budget_code varchar(10),
	budget_name varchar(60),
	contract_number varchar,
	master_contract_number character varying,
	master_child_contract_number character varying,
  	contract_vendor_id integer,
  	contract_vendor_id_cy integer,
  	master_contract_vendor_id integer,
  	master_contract_vendor_id_cy integer,
  	contract_agency_id smallint,
  	contract_agency_id_cy smallint,
  	master_contract_agency_id smallint,
  	master_contract_agency_id_cy smallint,
  	master_purpose character varying,
  	master_purpose_cy character varying,
	purpose varchar,
	purpose_cy varchar,
	master_child_contract_agency_id smallint,
	master_child_contract_agency_id_cy smallint,
	master_child_contract_vendor_id integer,
	master_child_contract_vendor_id_cy integer,
	reporting_code varchar(15),
	location_id integer,
	fund_class_name varchar(50),
	fund_class_code varchar(5),
	spending_category_id smallint,
	spending_category_name varchar,
	calendar_fiscal_year_id smallint,
	calendar_fiscal_year smallint,
	agreement_accounting_line_number integer,
    agreement_commodity_line_number integer,
   	agreement_vendor_line_number integer, 
   	reference_document_number character varying,    
   	reference_document_code varchar(8),
	contract_document_code varchar(8),
	master_contract_document_code varchar(8),
	minority_type_id smallint,
 	minority_type_name character varying,
 	industry_type_id smallint,
   	industry_type_name character varying,
   	agreement_type_code character varying,
   	award_method_code character varying,
   	contract_industry_type_id smallint,
	contract_industry_type_id_cy smallint,
	master_contract_industry_type_id smallint,
	master_contract_industry_type_id_cy smallint,
	contract_minority_type_id smallint,
	contract_minority_type_id_cy smallint,
	master_contract_minority_type_id smallint,
	master_contract_minority_type_id_cy smallint,
	file_type char(1),
	load_id integer,
	last_modified_date timestamp without time zone,
	job_id bigint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.disbursement_line_item_details to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';



CREATE VIEW disbursement_line_item_details AS
    SELECT disbursement_line_item_details__0.disbursement_line_item_id, disbursement_line_item_details__0.disbursement_id, disbursement_line_item_details__0.line_number,
    disbursement_line_item_details__0.disbursement_number ,disbursement_line_item_details__0.check_eft_issued_date_id, 
    disbursement_line_item_details__0.check_eft_issued_nyc_year_id, disbursement_line_item_details__0.fiscal_year, disbursement_line_item_details__0.check_eft_issued_cal_month_id, disbursement_line_item_details__0.agreement_id,
    disbursement_line_item_details__0.master_agreement_id, disbursement_line_item_details__0.fund_class_id, disbursement_line_item_details__0.check_amount, disbursement_line_item_details__0.agency_id,
    disbursement_line_item_details__0.agency_history_id,disbursement_line_item_details__0.agency_code, disbursement_line_item_details__0.expenditure_object_id, disbursement_line_item_details__0.vendor_id, 
    disbursement_line_item_details__0.department_id,disbursement_line_item_details__0.maximum_contract_amount, disbursement_line_item_details__0.maximum_contract_amount_cy,
    disbursement_line_item_details__0.maximum_spending_limit,disbursement_line_item_details__0.maximum_spending_limit_cy,
    disbursement_line_item_details__0.document_id, disbursement_line_item_details__0.vendor_name,disbursement_line_item_details__0.vendor_customer_code, disbursement_line_item_details__0.check_eft_issued_date, 
    disbursement_line_item_details__0.agency_name,disbursement_line_item_details__0.agency_short_name,
    disbursement_line_item_details__0.location_name,disbursement_line_item_details__0.location_code, disbursement_line_item_details__0.department_name,
    disbursement_line_item_details__0.department_short_name,disbursement_line_item_details__0.department_code, disbursement_line_item_details__0.expenditure_object_name,disbursement_line_item_details__0.expenditure_object_code, 
    disbursement_line_item_details__0.budget_code_id,disbursement_line_item_details__0.budget_code,
    disbursement_line_item_details__0.budget_name, disbursement_line_item_details__0.contract_number,  disbursement_line_item_details__0.master_contract_number,disbursement_line_item_details__0.master_child_contract_number,
    disbursement_line_item_details__0.contract_vendor_id,disbursement_line_item_details__0.contract_vendor_id_cy,disbursement_line_item_details__0.master_contract_vendor_id,
    disbursement_line_item_details__0.master_contract_vendor_id_cy,disbursement_line_item_details__0.contract_agency_id,disbursement_line_item_details__0.contract_agency_id_cy,
    disbursement_line_item_details__0.master_contract_agency_id,disbursement_line_item_details__0.master_contract_agency_id_cy,disbursement_line_item_details__0.master_purpose,
    disbursement_line_item_details__0.master_purpose_cy, disbursement_line_item_details__0.purpose,disbursement_line_item_details__0.purpose_cy,
    disbursement_line_item_details__0.master_child_contract_agency_id, disbursement_line_item_details__0.master_child_contract_agency_id_cy,disbursement_line_item_details__0.master_child_contract_vendor_id,disbursement_line_item_details__0.master_child_contract_vendor_id_cy,
    disbursement_line_item_details__0.reporting_code,disbursement_line_item_details__0.location_id,disbursement_line_item_details__0.fund_class_name,disbursement_line_item_details__0.fund_class_code,
    disbursement_line_item_details__0.spending_category_id,disbursement_line_item_details__0.spending_category_name,disbursement_line_item_details__0.calendar_fiscal_year_id,disbursement_line_item_details__0.calendar_fiscal_year,
    disbursement_line_item_details__0.agreement_accounting_line_number, disbursement_line_item_details__0.agreement_commodity_line_number, disbursement_line_item_details__0.agreement_vendor_line_number, 
    disbursement_line_item_details__0.reference_document_number,disbursement_line_item_details__0.reference_document_code,disbursement_line_item_details__0.contract_document_code,
    disbursement_line_item_details__0.master_contract_document_code, 
    disbursement_line_item_details__0.minority_type_id,disbursement_line_item_details__0.minority_type_name,disbursement_line_item_details__0.industry_type_id,
    disbursement_line_item_details__0.industry_type_name,disbursement_line_item_details__0.agreement_type_code,disbursement_line_item_details__0.award_method_code,
    disbursement_line_item_details__0.contract_industry_type_id,disbursement_line_item_details__0.contract_industry_type_id_cy,disbursement_line_item_details__0.master_contract_industry_type_id,
    disbursement_line_item_details__0.master_contract_industry_type_id_cy,disbursement_line_item_details__0.contract_minority_type_id,disbursement_line_item_details__0.contract_minority_type_id_cy,
    disbursement_line_item_details__0.master_contract_minority_type_id,disbursement_line_item_details__0.master_contract_minority_type_id_cy,
    disbursement_line_item_details__0.file_type,disbursement_line_item_details__0.load_id, disbursement_line_item_details__0.last_modified_date, disbursement_line_item_details__0.job_id
FROM ONLY disbursement_line_item_details__0;

--
-- Name: revenue_details__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE revenue_details__0 (
	revenue_id bigint,
	fiscal_year smallint,
	fiscal_period bpchar,
	posting_amount numeric,
	revenue_category_id smallint,
	revenue_source_id int,
	fiscal_year_id smallint,
	agency_id smallint,
	department_id integer,	
	revenue_class_id smallint,
	fund_class_id smallint,
	funding_class_id smallint,
	budget_code_id integer,
	budget_fiscal_year_id integer,
	agency_name varchar,
	revenue_category_name varchar,
	revenue_source_name varchar,
	budget_fiscal_year smallint,
	department_name varchar,
	revenue_class_name varchar,
	fund_class_name varchar,
	funding_class_name varchar,
	agency_code varchar,
	revenue_class_code varchar,
	fund_class_code varchar,
	funding_class_code varchar,
	revenue_category_code varchar,
	revenue_source_code varchar,
	closing_classification_code  varchar,
	closing_classification_name varchar,
	budget_code varchar,
    adopted_amount numeric,
    current_modified_budget_amount numeric,
    remaining_amount numeric,
	agency_short_name varchar,
	department_short_name varchar,
	agency_history_id smallint,
	object_class_id integer,
	load_id integer,
	last_modified_date timestamp without time zone,
	job_id bigint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.revenue_details to stdout csv"' ON SEGMENT 0 
FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: revenue_details; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW revenue_details AS
    SELECT revenue_details__0.revenue_id, revenue_details__0.fiscal_year, revenue_details__0.fiscal_period, revenue_details__0.posting_amount, revenue_details__0.revenue_category_id, revenue_details__0.revenue_source_id,
    revenue_details__0.fiscal_year_id , revenue_details__0.agency_id ,revenue_details__0.department_id , revenue_details__0.revenue_class_id , revenue_details__0.fund_class_id , revenue_details__0.funding_class_id , 
    revenue_details__0.budget_code_id,revenue_details__0.budget_fiscal_year_id,revenue_details__0.agency_name, revenue_details__0.revenue_category_name,revenue_details__0.revenue_source_name,
    revenue_details__0.budget_fiscal_year,revenue_details__0.department_name,revenue_details__0.revenue_class_name,revenue_details__0.fund_class_name,revenue_details__0.funding_class_name, 
    revenue_details__0.agency_code,revenue_details__0.revenue_class_code,revenue_details__0.fund_class_code,revenue_details__0.funding_class_code,revenue_details__0.revenue_category_code,
    revenue_details__0.revenue_source_code,revenue_details__0.closing_classification_code,revenue_details__0.closing_classification_name,
    revenue_details__0.budget_code,revenue_details__0.adopted_amount,revenue_details__0.current_modified_budget_amount,revenue_details__0.remaining_amount,
    revenue_details__0.agency_short_name,revenue_details__0.department_short_name,revenue_details__0.agency_history_id, revenue_details__0.object_class_id, 
    revenue_details__0.load_id,revenue_details__0.last_modified_date,revenue_details__0.job_id
    FROM  ONLY revenue_details__0;

--
-- Name: history_agreement__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE history_agreement__0 (
    agreement_id bigint,
    master_agreement_id bigint,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying,
    document_version integer,
    tracking_number character varying,
    record_date_id int,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period bpchar,
    description character varying,
    actual_amount_original numeric,
    actual_amount numeric,
    obligated_amount_original numeric,
    obligated_amount numeric,
    maximum_contract_amount_original numeric,
    maximum_contract_amount numeric,
    amendment_number character varying,
    replacing_agreement_id bigint,
    replaced_by_agreement_id bigint,
    award_status_id smallint,
    procurement_id character varying,
    procurement_type_id smallint,
    effective_begin_date_id int,
    effective_end_date_id int,
    reason_modification character varying,
    source_created_date_id int,
    source_updated_date_id int,
    document_function_code varchar,
    award_method_id smallint,
    award_level_code varchar,
    agreement_type_id smallint,
    contract_class_code character varying,
    award_category_id_1 smallint,
    award_category_id_2 smallint,
    award_category_id_3 smallint,
    award_category_id_4 smallint,
    award_category_id_5 smallint,
    number_responses integer,
    location_service character varying,
    location_zip character varying,
    borough_code character varying,
    block_code character varying,
    lot_code character varying,
    council_district_code character varying,
    vendor_history_id integer,
    vendor_preference_level integer,
    original_contract_amount_original numeric,
    original_contract_amount numeric,
    registered_date_id int,
    oca_number character varying,
    number_solicitation integer,
    document_name character varying,
    original_term_begin_date_id int,
    original_term_end_date_id int,
    brd_awd_no varchar,
    rfed_amount_original numeric,
    rfed_amount numeric,
    registered_fiscal_year smallint,
    registered_fiscal_year_id smallint, 
    registered_calendar_year smallint,
    registered_calendar_year_id smallint,
    effective_end_fiscal_year smallint,
    effective_end_fiscal_year_id smallint, 
    effective_end_calendar_year smallint,
    effective_end_calendar_year_id smallint,
    effective_begin_fiscal_year smallint,
    effective_begin_fiscal_year_id smallint,
    effective_begin_calendar_year smallint,
    effective_begin_calendar_year_id smallint,
    source_updated_fiscal_year smallint,
    source_updated_fiscal_year_id smallint, 
    source_updated_calendar_year smallint,
    source_updated_calendar_year_id smallint,
    contract_number varchar,
    original_agreement_id bigint,
    original_version_flag char(1),
    latest_flag char(1),
    privacy_flag char(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.history_agreement to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: history_agreement; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW history_agreement AS
    SELECT history_agreement__0.agreement_id, history_agreement__0.master_agreement_id, history_agreement__0.document_code_id, history_agreement__0.agency_history_id, 
    history_agreement__0.document_id, history_agreement__0.document_version, history_agreement__0.tracking_number, history_agreement__0.record_date_id, 
    history_agreement__0.budget_fiscal_year, history_agreement__0.document_fiscal_year, history_agreement__0.document_period, history_agreement__0.description, 
    history_agreement__0.actual_amount_original, history_agreement__0.actual_amount,history_agreement__0.obligated_amount_original, history_agreement__0.obligated_amount,
    history_agreement__0.maximum_contract_amount_original, history_agreement__0.maximum_contract_amount,history_agreement__0.amendment_number,
    history_agreement__0.replacing_agreement_id, history_agreement__0.replaced_by_agreement_id, history_agreement__0.award_status_id, history_agreement__0.procurement_id, 
    history_agreement__0.procurement_type_id, history_agreement__0.effective_begin_date_id, history_agreement__0.effective_end_date_id, history_agreement__0.reason_modification, 
    history_agreement__0.source_created_date_id, history_agreement__0.source_updated_date_id, history_agreement__0.document_function_code, 
    history_agreement__0.award_method_id, history_agreement__0.award_level_code, history_agreement__0.agreement_type_id, history_agreement__0.contract_class_code, 
    history_agreement__0.award_category_id_1, history_agreement__0.award_category_id_2, history_agreement__0.award_category_id_3, history_agreement__0.award_category_id_4, 
    history_agreement__0.award_category_id_5, history_agreement__0.number_responses, history_agreement__0.location_service, history_agreement__0.location_zip, 
    history_agreement__0.borough_code, history_agreement__0.block_code, history_agreement__0.lot_code, history_agreement__0.council_district_code, 
    history_agreement__0.vendor_history_id, history_agreement__0.vendor_preference_level, history_agreement__0.original_contract_amount_original, history_agreement__0.original_contract_amount,
    history_agreement__0.registered_date_id, history_agreement__0.oca_number, history_agreement__0.number_solicitation, history_agreement__0.document_name, 
    history_agreement__0.original_term_begin_date_id, history_agreement__0.original_term_end_date_id, history_agreement__0.brd_awd_no, history_agreement__0.rfed_amount_original,history_agreement__0.rfed_amount,
    history_agreement__0.registered_fiscal_year, history_agreement__0.registered_fiscal_year_id, history_agreement__0.registered_calendar_year, history_agreement__0.registered_calendar_year_id,
    history_agreement__0.effective_end_fiscal_year, history_agreement__0.effective_end_fiscal_year_id, history_agreement__0.effective_end_calendar_year, history_agreement__0.effective_end_calendar_year_id,
    history_agreement__0.effective_begin_fiscal_year, history_agreement__0.effective_begin_fiscal_year_id, history_agreement__0.effective_begin_calendar_year, history_agreement__0.effective_begin_calendar_year_id,
    history_agreement__0.source_updated_fiscal_year, history_agreement__0.source_updated_fiscal_year_id, history_agreement__0.source_updated_calendar_year, history_agreement__0.source_updated_calendar_year_id,
    history_agreement__0.contract_number, history_agreement__0.original_agreement_id, history_agreement__0.original_version_flag, history_agreement__0.latest_flag,
    history_agreement__0.privacy_flag, history_agreement__0.created_load_id, history_agreement__0.updated_load_id, history_agreement__0.created_date,
    history_agreement__0.updated_date
    FROM ONLY history_agreement__0;

--
-- Name: history_agreement_accounting_line__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE history_agreement_accounting_line__0 (
    agreement_accounting_line_id bigint,
    agreement_id bigint,
    commodity_line_number integer,
    line_number integer,
    event_type_code char(4),
    description character varying,
    line_amount_original numeric,
    line_amount numeric,
    budget_fiscal_year smallint,
    fiscal_year smallint,
    fiscal_period bpchar,
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    expenditure_object_history_id integer,
    revenue_source_id int,
    location_code character varying,
    budget_code_id integer,
    reporting_code character varying,
    rfed_line_amount_original numeric,
    rfed_line_amount numeric,
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.history_agreement_accounting_line to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: history_agreement_accounting_line; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW history_agreement_accounting_line AS
    SELECT history_agreement_accounting_line__0.agreement_accounting_line_id, history_agreement_accounting_line__0.agreement_id, history_agreement_accounting_line__0.commodity_line_number, 
    history_agreement_accounting_line__0.line_number, history_agreement_accounting_line__0.event_type_code, history_agreement_accounting_line__0.description, 
    history_agreement_accounting_line__0.line_amount_original, history_agreement_accounting_line__0.line_amount,history_agreement_accounting_line__0.budget_fiscal_year, history_agreement_accounting_line__0.fiscal_year, 
    history_agreement_accounting_line__0.fiscal_period, history_agreement_accounting_line__0.fund_class_id, history_agreement_accounting_line__0.agency_history_id, 
    history_agreement_accounting_line__0.department_history_id, history_agreement_accounting_line__0.expenditure_object_history_id, 
    history_agreement_accounting_line__0.revenue_source_id, history_agreement_accounting_line__0.location_code, history_agreement_accounting_line__0.budget_code_id, 
    history_agreement_accounting_line__0.reporting_code, history_agreement_accounting_line__0.rfed_line_amount_original, history_agreement_accounting_line__0.rfed_line_amount,
    history_agreement_accounting_line__0.created_load_id, history_agreement_accounting_line__0.updated_load_id,
    history_agreement_accounting_line__0.created_date, history_agreement_accounting_line__0.updated_date FROM ONLY history_agreement_accounting_line__0;

--
-- Name: history_agreement_commodity__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE history_agreement_commodity__0 (
    agreement_commodity_id bigint,
    agreement_id bigint,
    line_number integer,
    master_agreement_yn bpchar,
    description character varying,
    commodity_code character varying,
    commodity_type_id integer,
    quantity numeric,
    unit_of_measurement character varying,
    unit_price numeric,
    contract_amount numeric,
    commodity_specification character varying,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.history_agreement_commodity to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: history_agreement_commodity; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW history_agreement_commodity AS
    SELECT history_agreement_commodity__0.agreement_commodity_id, history_agreement_commodity__0.agreement_id, history_agreement_commodity__0.line_number, history_agreement_commodity__0.master_agreement_yn, history_agreement_commodity__0.description, history_agreement_commodity__0.commodity_code, history_agreement_commodity__0.commodity_type_id, history_agreement_commodity__0.quantity, history_agreement_commodity__0.unit_of_measurement, history_agreement_commodity__0.unit_price, history_agreement_commodity__0.contract_amount, history_agreement_commodity__0.commodity_specification, history_agreement_commodity__0.load_id, history_agreement_commodity__0.created_date, history_agreement_commodity__0.updated_date FROM ONLY history_agreement_commodity__0;

--
-- Name: history_agreement_worksite__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE history_agreement_worksite__0 (
    agreement_worksite_id bigint,
    agreement_id bigint,
    worksite_code varchar,
    percentage numeric,
    amount numeric,
    master_agreement_yn bpchar,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.history_agreement_worksite to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: history_agreement_worksite; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW history_agreement_worksite AS
    SELECT history_agreement_worksite__0.agreement_worksite_id, history_agreement_worksite__0.agreement_id, history_agreement_worksite__0.worksite_code, history_agreement_worksite__0.percentage, history_agreement_worksite__0.amount, history_agreement_worksite__0.master_agreement_yn, history_agreement_worksite__0.load_id, history_agreement_worksite__0.created_date, history_agreement_worksite__0.updated_date FROM ONLY history_agreement_worksite__0;

--
-- Name: history_master_agreement__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE history_master_agreement__0 (
    master_agreement_id bigint,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying,
    document_version integer,
    tracking_number character varying,
    record_date_id int,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period bpchar,
    description character varying,
    actual_amount_original numeric,
    actual_amount numeric,
    total_amount_original numeric,
    total_amount numeric,
    replacing_master_agreement_id bigint,
    replaced_by_master_agreement_id bigint,
    award_status_id smallint,
    procurement_id character varying,
    procurement_type_id smallint,
    effective_begin_date_id int,
    effective_end_date_id int,
    reason_modification character varying,
    source_created_date_id int,
    source_updated_date_id int,
    document_function_code varchar,
    award_method_id smallint,
    agreement_type_id smallint,
    award_category_id_1 smallint,
    award_category_id_2 smallint,
    award_category_id_3 smallint,
    award_category_id_4 smallint,
    award_category_id_5 smallint,
    number_responses integer,
    location_service character varying,
    location_zip character varying,
    borough_code character varying,
    block_code character varying,
    lot_code character varying,
    council_district_code character varying,
    vendor_history_id integer,
    vendor_preference_level integer,
    board_approved_award_no character varying,
    board_approved_award_date_id int,
    original_contract_amount_original numeric,
    original_contract_amount numeric,
    oca_number character varying,
    original_term_begin_date_id int,
    original_term_end_date_id int,
    registered_date_id int,
    maximum_amount_original numeric,
    maximum_amount numeric,
    maximum_spending_limit_original numeric,
    maximum_spending_limit numeric,
    award_level_code varchar,
    contract_class_code character varying,
    number_solicitation integer,
    document_name character varying,
  registered_fiscal_year smallint,
  registered_fiscal_year_id smallint,
  registered_calendar_year smallint,
  registered_calendar_year_id smallint,
  effective_end_fiscal_year smallint,
  effective_end_fiscal_year_id smallint,
  effective_end_calendar_year smallint,
  effective_end_calendar_year_id smallint,
  effective_begin_fiscal_year smallint,
  effective_begin_fiscal_year_id smallint,
  effective_begin_calendar_year smallint,
  effective_begin_calendar_year_id smallint,
  source_updated_fiscal_year smallint,
  source_updated_fiscal_year_id smallint,
  source_updated_calendar_year smallint,
  source_updated_calendar_year_id smallint,
  contract_number character varying,
  original_master_agreement_id bigint,
  original_version_flag character(1),
  latest_flag character(1),
  privacy_flag character(1),
  created_load_id integer,
  updated_load_id integer,
  created_date timestamp without time zone,
  updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.history_master_agreement to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: history_master_agreement; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW history_master_agreement AS
    SELECT history_master_agreement__0.master_agreement_id, history_master_agreement__0.document_code_id, history_master_agreement__0.agency_history_id, 
    history_master_agreement__0.document_id, history_master_agreement__0.document_version, history_master_agreement__0.tracking_number, 
    history_master_agreement__0.record_date_id, history_master_agreement__0.budget_fiscal_year, history_master_agreement__0.document_fiscal_year, 
    history_master_agreement__0.document_period, history_master_agreement__0.description, history_master_agreement__0.actual_amount_original, history_master_agreement__0.actual_amount, 
    history_master_agreement__0.total_amount_original,history_master_agreement__0.total_amount, history_master_agreement__0.replacing_master_agreement_id, history_master_agreement__0.replaced_by_master_agreement_id, 
    history_master_agreement__0.award_status_id, history_master_agreement__0.procurement_id, history_master_agreement__0.procurement_type_id, history_master_agreement__0.effective_begin_date_id, 
    history_master_agreement__0.effective_end_date_id, history_master_agreement__0.reason_modification, history_master_agreement__0.source_created_date_id, 
    history_master_agreement__0.source_updated_date_id, history_master_agreement__0.document_function_code, history_master_agreement__0.award_method_id, 
    history_master_agreement__0.agreement_type_id, history_master_agreement__0.award_category_id_1, history_master_agreement__0.award_category_id_2, 
    history_master_agreement__0.award_category_id_3, history_master_agreement__0.award_category_id_4, history_master_agreement__0.award_category_id_5, 
    history_master_agreement__0.number_responses, history_master_agreement__0.location_service, history_master_agreement__0.location_zip, 
    history_master_agreement__0.borough_code, history_master_agreement__0.block_code, history_master_agreement__0.lot_code, history_master_agreement__0.council_district_code, 
    history_master_agreement__0.vendor_history_id, history_master_agreement__0.vendor_preference_level, history_master_agreement__0.board_approved_award_no, 
    history_master_agreement__0.board_approved_award_date_id, history_master_agreement__0.original_contract_amount_original, history_master_agreement__0.original_contract_amount,history_master_agreement__0.oca_number, 
    history_master_agreement__0.original_term_begin_date_id, history_master_agreement__0.original_term_end_date_id, history_master_agreement__0.registered_date_id, 
    history_master_agreement__0.maximum_amount_original, history_master_agreement__0.maximum_amount, history_master_agreement__0.maximum_spending_limit_original,history_master_agreement__0.maximum_spending_limit, 
    history_master_agreement__0.award_level_code, history_master_agreement__0.contract_class_code, history_master_agreement__0.number_solicitation, history_master_agreement__0.document_name, 
    history_master_agreement__0.registered_fiscal_year, history_master_agreement__0.registered_fiscal_year_id, history_master_agreement__0.registered_calendar_year, history_master_agreement__0.registered_calendar_year_id,
    history_master_agreement__0.effective_end_fiscal_year, history_master_agreement__0.effective_end_fiscal_year_id, history_master_agreement__0.effective_end_calendar_year, history_master_agreement__0.effective_end_calendar_year_id,
    history_master_agreement__0.effective_begin_fiscal_year, history_master_agreement__0.effective_begin_fiscal_year_id, history_master_agreement__0.effective_begin_calendar_year, history_master_agreement__0.effective_begin_calendar_year_id,
    history_master_agreement__0.source_updated_fiscal_year, history_master_agreement__0.source_updated_fiscal_year_id, history_master_agreement__0.source_updated_calendar_year, history_master_agreement__0.source_updated_calendar_year_id,
    history_master_agreement__0.contract_number, history_master_agreement__0.original_master_agreement_id, history_master_agreement__0.original_version_flag, history_master_agreement__0.latest_flag,        
    history_master_agreement__0.privacy_flag, history_master_agreement__0.created_load_id, history_master_agreement__0.updated_load_id, 
    history_master_agreement__0.created_date, history_master_agreement__0.updated_date FROM ONLY history_master_agreement__0;

--
-- Name: ref_address_type__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_address_type__0 (
    address_type_id smallint,
    address_type_code character varying,
    address_type_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_address_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_address_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_address_type AS
    SELECT ref_address_type__0.address_type_id, ref_address_type__0.address_type_code, ref_address_type__0.address_type_name, ref_address_type__0.created_date FROM ONLY ref_address_type__0;

--
-- Name: ref_agency__0; Type: EXTERNAL TABLE; Schema: staging; Owner: athiagarajan; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_agency__0 (
    agency_id smallint,
    agency_code character varying,
    agency_name character varying,
    agency_short_name character varying,
    original_agency_name character varying,
    is_display char(1),
    is_oge_agency char(1),
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_agency to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_agency; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW ref_agency AS
    SELECT ref_agency__0.agency_id, ref_agency__0.agency_code, ref_agency__0.agency_name, ref_agency__0.agency_short_name,ref_agency__0.original_agency_name,ref_agency__0.is_display,
    ref_agency__0.is_oge_agency, ref_agency__0.created_date, ref_agency__0.updated_date, ref_agency__0.created_load_id, ref_agency__0.updated_load_id FROM ONLY ref_agency__0;

--
-- Name: ref_agency_history__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_agency_history__0 (
    agency_history_id smallint,
    agency_id smallint,
    agency_name character varying,
    agency_short_name character varying,
    created_date timestamp without time zone,
    load_id integer    
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_agency_history to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_agency_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_agency_history AS
    SELECT ref_agency_history__0.agency_history_id, ref_agency_history__0.agency_id, ref_agency_history__0.agency_name, ref_agency_history__0.agency_short_name,ref_agency_history__0.created_date, ref_agency_history__0.load_id FROM ONLY ref_agency_history__0;

--
-- Name: ref_agreement_type__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_agreement_type__0 (
    agreement_type_id smallint,
    agreement_type_code character varying,
    agreement_type_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_agreement_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_agreement_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_agreement_type AS
    SELECT ref_agreement_type__0.agreement_type_id, ref_agreement_type__0.agreement_type_code, ref_agreement_type__0.agreement_type_name, ref_agreement_type__0.created_date FROM ONLY ref_agreement_type__0;

--
-- Name: ref_award_category__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_award_category__0 (
    award_category_id smallint,
    award_category_code character varying,
    award_category_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_award_category to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_award_category; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_award_category AS
    SELECT ref_award_category__0.award_category_id, ref_award_category__0.award_category_code, ref_award_category__0.award_category_name, ref_award_category__0.created_date FROM ONLY ref_award_category__0;

--
-- Name: ref_award_method__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_award_method__0 (
    award_method_id smallint,
    award_method_code character varying,
    award_method_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_award_method to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_award_method; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_award_method AS
    SELECT ref_award_method__0.award_method_id, ref_award_method__0.award_method_code, ref_award_method__0.award_method_name, ref_award_method__0.created_date FROM ONLY ref_award_method__0;

--
-- Name: ref_budget_code__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_budget_code__0 (
    budget_code_id integer,
    fiscal_year smallint,
    budget_code character varying,
    agency_id smallint,
    fund_class_id smallint,
    budget_code_name character varying,
    attribute_name character varying,
    attribute_short_name character varying,
    responsibility_center character varying,
    control_category character varying,
    ua_funding_flag bit(1),
    payroll_default_flag bit(1),
    budget_function character varying,
    description character varying,
    created_date timestamp without time zone,
    load_id integer,
    updated_date timestamp without time zone,
    updated_load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_budget_code to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_budget_code; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_budget_code AS
    SELECT ref_budget_code__0.budget_code_id, ref_budget_code__0.fiscal_year, ref_budget_code__0.budget_code, ref_budget_code__0.agency_id, ref_budget_code__0.fund_class_id, ref_budget_code__0.budget_code_name, ref_budget_code__0.attribute_name, ref_budget_code__0.attribute_short_name, ref_budget_code__0.responsibility_center, ref_budget_code__0.control_category, ref_budget_code__0.ua_funding_flag, ref_budget_code__0.payroll_default_flag, ref_budget_code__0.budget_function, ref_budget_code__0.description, ref_budget_code__0.created_date, ref_budget_code__0.load_id, ref_budget_code__0.updated_date, ref_budget_code__0.updated_load_id FROM ONLY ref_budget_code__0;

--
-- Name: ref_business_type__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_business_type__0 (
    business_type_id smallint,
    business_type_code character varying,
    business_type_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_business_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_business_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_business_type AS
    SELECT ref_business_type__0.business_type_id, ref_business_type__0.business_type_code, ref_business_type__0.business_type_name, ref_business_type__0.created_date FROM ONLY ref_business_type__0;

--
-- Name: ref_business_type_status__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_business_type_status__0 (
    business_type_status_id smallint,
    business_type_status character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_business_type_status to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_business_type_status; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_business_type_status AS
    SELECT ref_business_type_status__0.business_type_status_id, ref_business_type_status__0.business_type_status, ref_business_type_status__0.created_date FROM ONLY ref_business_type_status__0;

--
-- Name: ref_data_source__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--
/*
CREATE EXTERNAL WEB TABLE ref_data_source__0 (
    data_source_code character varying,
    description character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_data_source to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';
*/
--
-- Name: ref_data_source; Type: VIEW; Schema: staging; Owner: gpadmin
--
/*
CREATE VIEW ref_data_source AS
    SELECT ref_data_source__0.data_source_code, ref_data_source__0.description, ref_data_source__0.created_date FROM ONLY ref_data_source__0;
*/
--
-- Name: ref_date__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_date__0 (
    date_id int,
    date date,
    nyc_year_id smallint,
    calendar_month_id int
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_date to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_date; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_date AS
    SELECT ref_date__0.date_id, ref_date__0.date, ref_date__0.nyc_year_id, ref_date__0.calendar_month_id FROM ONLY ref_date__0;

--
-- Name: ref_department__0; Type: EXTERNAL TABLE; Schema: staging; Owner: athiagarajan; Tablespace: 
--


CREATE EXTERNAL WEB TABLE ref_department__0 (
    department_id integer,
    department_code character varying,
    department_name character varying,
    department_short_name character varying,
    agency_id smallint,
    fund_class_id smallint,
    fiscal_year smallint,
    original_department_name character varying,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer    
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_department to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_department; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW ref_department AS
    SELECT ref_department__0.department_id, ref_department__0.department_code, ref_department__0.department_name, ref_department__0.department_short_name,ref_department__0.agency_id, ref_department__0.fund_class_id, ref_department__0.fiscal_year, ref_department__0.original_department_name, ref_department__0.created_date, ref_department__0.updated_date, ref_department__0.created_load_id, ref_department__0.updated_load_id FROM ONLY ref_department__0;

--
-- Name: ref_department_history__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_department_history__0 (
    department_history_id integer,
    department_id integer,
    department_name character varying,
    department_short_name character varying,
    agency_id smallint,
    fund_class_id smallint,
    fiscal_year smallint,
    created_date timestamp without time zone,
    load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_department_history to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_department_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_department_history AS
    SELECT ref_department_history__0.department_history_id, ref_department_history__0.department_id, ref_department_history__0.department_name, ref_department_history__0.department_short_name,ref_department_history__0.agency_id, ref_department_history__0.fund_class_id, ref_department_history__0.fiscal_year, ref_department_history__0.created_date, ref_department_history__0.load_id FROM ONLY ref_department_history__0;

--
-- Name: ref_document_code__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_document_code__0 (
    document_code_id smallint,
    document_code character varying,
    document_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_document_code to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_document_code; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_document_code AS
    SELECT ref_document_code__0.document_code_id, ref_document_code__0.document_code, ref_document_code__0.document_name, ref_document_code__0.created_date FROM ONLY ref_document_code__0;

--
-- Name: ref_expenditure_cancel_reason__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_expenditure_cancel_reason__0 (
    expenditure_cancel_reason_id smallint,
    expenditure_cancel_reason_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_expenditure_cancel_reason to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_expenditure_cancel_reason; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_expenditure_cancel_reason AS
    SELECT ref_expenditure_cancel_reason__0.expenditure_cancel_reason_id, ref_expenditure_cancel_reason__0.expenditure_cancel_reason_name, ref_expenditure_cancel_reason__0.created_date FROM ONLY ref_expenditure_cancel_reason__0;

--
-- Name: ref_expenditure_cancel_type__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_expenditure_cancel_type__0 (
    expenditure_cancel_type_id smallint,
    expenditure_cancel_type_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_expenditure_cancel_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_expenditure_cancel_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_expenditure_cancel_type AS
    SELECT ref_expenditure_cancel_type__0.expenditure_cancel_type_id, ref_expenditure_cancel_type__0.expenditure_cancel_type_name, ref_expenditure_cancel_type__0.created_date FROM ONLY ref_expenditure_cancel_type__0;

--
-- Name: ref_expenditure_object__0; Type: EXTERNAL TABLE; Schema: staging; Owner: athiagarajan; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_expenditure_object__0 (
    expenditure_object_id integer,
    expenditure_object_code character varying,
    expenditure_object_name character varying,
    fiscal_year smallint,
    original_expenditure_object_name character varying,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_expenditure_object to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_expenditure_object; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW ref_expenditure_object AS
    SELECT ref_expenditure_object__0.expenditure_object_id, ref_expenditure_object__0.expenditure_object_code, ref_expenditure_object__0.expenditure_object_name, ref_expenditure_object__0.fiscal_year, ref_expenditure_object__0.original_expenditure_object_name, ref_expenditure_object__0.created_date, ref_expenditure_object__0.updated_date, ref_expenditure_object__0.created_load_id, ref_expenditure_object__0.updated_load_id FROM ONLY ref_expenditure_object__0;

--
-- Name: ref_expenditure_object_history__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_expenditure_object_history__0 (
    expenditure_object_history_id integer,
    expenditure_object_id integer,
    expenditure_object_name character varying,
    fiscal_year smallint,
    created_date timestamp without time zone,
    load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_expenditure_object_history to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_expenditure_object_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_expenditure_object_history AS
    SELECT ref_expenditure_object_history__0.expenditure_object_history_id, ref_expenditure_object_history__0.expenditure_object_id, ref_expenditure_object_history__0.expenditure_object_name, ref_expenditure_object_history__0.fiscal_year, ref_expenditure_object_history__0.created_date, ref_expenditure_object_history__0.load_id FROM ONLY ref_expenditure_object_history__0;

--
-- Name: ref_expenditure_privacy_type__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_expenditure_privacy_type__0 (
    expenditure_privacy_type_id smallint,
    expenditure_privacy_code character varying,
    expenditure_privacy_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_expenditure_privacy_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_expenditure_privacy_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_expenditure_privacy_type AS
    SELECT ref_expenditure_privacy_type__0.expenditure_privacy_type_id, ref_expenditure_privacy_type__0.expenditure_privacy_code, ref_expenditure_privacy_type__0.expenditure_privacy_name, ref_expenditure_privacy_type__0.created_date FROM ONLY ref_expenditure_privacy_type__0;

--
-- Name: ref_expenditure_status__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_expenditure_status__0 (
    expenditure_status_id smallint,
    expenditure_status_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_expenditure_status to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_expenditure_status; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_expenditure_status AS
    SELECT ref_expenditure_status__0.expenditure_status_id, ref_expenditure_status__0.expenditure_status_name, ref_expenditure_status__0.created_date FROM ONLY ref_expenditure_status__0;

--
-- Name: ref_fund_class__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_fund_class__0 (
    fund_class_id smallint,
    fund_class_code character varying,
    fund_class_name character varying,
    created_load_id integer,
    created_date timestamp without time zone    
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_fund_class to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_fund_class; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_fund_class AS
    SELECT ref_fund_class__0.fund_class_id, ref_fund_class__0.fund_class_code, ref_fund_class__0.fund_class_name,ref_fund_class__0.created_load_id, ref_fund_class__0.created_date FROM ONLY ref_fund_class__0;

--
-- Name: ref_funding_class__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_funding_class__0 (
    funding_class_id smallint,
    funding_class_code character varying(4),
    funding_class_name character varying(60),
    funding_class_short_name character varying(15),
    category_name character varying(60),
    city_fund_flag bit(1),
    intra_city_flag bit(1),
    fund_allocation_required_flag bit(1),
    category_code character varying(2),
    created_date timestamp without time zone,
    fiscal_year smallint,
    updated_date timestamp,
    created_load_id integer,
    updated_load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_funding_class to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_funding_class; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_funding_class AS
    SELECT ref_funding_class__0.funding_class_id, ref_funding_class__0.funding_class_code, ref_funding_class__0.funding_class_name, 
    ref_funding_class__0.funding_class_short_name, ref_funding_class__0.category_name, ref_funding_class__0.city_fund_flag, 
    ref_funding_class__0.intra_city_flag, ref_funding_class__0.fund_allocation_required_flag, ref_funding_class__0.category_code, 
    ref_funding_class__0.created_date,ref_funding_class__0.fiscal_year,ref_funding_class__0.updated_date,ref_funding_class__0.created_load_id,
    ref_funding_class__0.updated_load_id FROM ONLY ref_funding_class__0;

--
-- Name: ref_funding_source__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_funding_source__0 (
    funding_source_id smallint,
    funding_source_code character varying,
    funding_source_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_funding_source to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_funding_source; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_funding_source AS
    SELECT ref_funding_source__0.funding_source_id, ref_funding_source__0.funding_source_code, ref_funding_source__0.funding_source_name, ref_funding_source__0.created_date FROM ONLY ref_funding_source__0;

--
-- Name: ref_location__0; Type: EXTERNAL TABLE; Schema: staging; Owner: athiagarajan; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_location__0 (
    location_id integer,
    location_code character varying,
    agency_id smallint,
    location_name character varying,
    location_short_name character varying,
    original_location_name character varying,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_location to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_location; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW ref_location AS
    SELECT ref_location__0.location_id, ref_location__0.location_code, ref_location__0.agency_id, ref_location__0.location_name, ref_location__0.location_short_name, ref_location__0.original_location_name, ref_location__0.created_date, ref_location__0.updated_date, ref_location__0.created_load_id, ref_location__0.updated_load_id FROM ONLY ref_location__0;

--
-- Name: ref_location_history__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_location_history__0 (
    location_history_id integer,
    location_id integer,
    agency_id smallint,
    location_name character varying,
    location_short_name character varying,
    created_date timestamp without time zone,
    load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_location_history to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_location_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_location_history AS
    SELECT ref_location_history__0.location_history_id, ref_location_history__0.location_id, ref_location_history__0.agency_id, ref_location_history__0.location_name, ref_location_history__0.location_short_name, ref_location_history__0.created_date, ref_location_history__0.load_id FROM ONLY ref_location_history__0;
    
--
-- Name: ref_minority_type__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_minority_type__0 (

    minority_type_id smallint,
    minority_type_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_minority_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_minority_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_minority_type AS
    SELECT ref_minority_type__0.minority_type_id, ref_minority_type__0.minority_type_name, ref_minority_type__0.created_date FROM ONLY ref_minority_type__0;


--
-- Name: ref_miscellaneous_vendor__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_miscellaneous_vendor__0 (
    misc_vendor_id smallint,
    vendor_customer_code character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_miscellaneous_vendor to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_miscellaneous_vendor; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_miscellaneous_vendor AS
    SELECT ref_miscellaneous_vendor__0.misc_vendor_id, ref_miscellaneous_vendor__0.vendor_customer_code, ref_miscellaneous_vendor__0.created_date FROM ONLY ref_miscellaneous_vendor__0;

--
-- Name: ref_month__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_month__0 (
    month_id int,
    month_value smallint,
    month_name character varying,
    year_id smallint,
    display_order smallint,
    month_short_name varchar(3)
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_month to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


--
-- Name: ref_month; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_month AS
    SELECT ref_month__0.month_id, ref_month__0.month_value, ref_month__0.month_name, ref_month__0.year_id, ref_month__0.display_order, ref_month__0.month_short_name FROM ONLY ref_month__0;

--
-- Name: ref_object_class__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_object_class__0 (
    object_class_id integer,
    object_class_code character varying,
    object_class_name character varying,
    object_class_short_name character varying,
    active_flag bit(1),
    effective_begin_date_id int,
    effective_end_date_id int,
    budget_allowed_flag bit(1),
    description character varying,
    source_updated_date timestamp without time zone,
    intra_city_flag bit(1),
    contracts_positions_flag bit(1),
    payroll_type integer,
    extended_description character varying,
    related_object_class_code character varying,
    original_object_class_name character varying,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_object_class to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_object_class; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW ref_object_class AS
    SELECT ref_object_class__0.object_class_id, ref_object_class__0.object_class_code, ref_object_class__0.object_class_name, ref_object_class__0.object_class_short_name, ref_object_class__0.active_flag, ref_object_class__0.effective_begin_date_id, ref_object_class__0.effective_end_date_id, ref_object_class__0.budget_allowed_flag, ref_object_class__0.description, ref_object_class__0.source_updated_date, ref_object_class__0.intra_city_flag, ref_object_class__0.contracts_positions_flag, ref_object_class__0.payroll_type, ref_object_class__0.extended_description, ref_object_class__0.related_object_class_code, ref_object_class__0.original_object_class_name, ref_object_class__0.created_date, ref_object_class__0.updated_date, ref_object_class__0.created_load_id, ref_object_class__0.updated_load_id FROM ONLY ref_object_class__0;
    
--
-- Name: ref_object_class_history__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_object_class_history__0 (
    object_class_history_id integer,
    object_class_id integer,
    object_class_name character varying,
    object_class_short_name character varying,
    active_flag bit(1),
    effective_begin_date_id int,
    effective_end_date_id int,
    budget_allowed_flag bit(1),
    description character varying,
    source_updated_date timestamp without time zone,
    intra_city_flag bit(1),
    contracts_positions_flag bit(1),
    payroll_type integer,
    extended_description character varying,
    related_object_class_code character varying,
    created_date timestamp without time zone,
    load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_object_class_history to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_object_class_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_object_class_history AS
    SELECT ref_object_class_history__0.object_class_history_id, ref_object_class_history__0.object_class_id, ref_object_class_history__0.object_class_name, ref_object_class_history__0.object_class_short_name, ref_object_class_history__0.active_flag, ref_object_class_history__0.effective_begin_date_id, ref_object_class_history__0.effective_end_date_id, ref_object_class_history__0.budget_allowed_flag, ref_object_class_history__0.description, ref_object_class_history__0.source_updated_date, ref_object_class_history__0.intra_city_flag, ref_object_class_history__0.contracts_positions_flag, ref_object_class_history__0.payroll_type, ref_object_class_history__0.extended_description, ref_object_class_history__0.related_object_class_code, ref_object_class_history__0.created_date, ref_object_class_history__0.load_id FROM ONLY ref_object_class_history__0;

--
-- Name: ref_revenue_category__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_revenue_category__0 (
    revenue_category_id smallint,
    revenue_category_code character varying,
    revenue_category_name character varying,
    revenue_category_short_name character varying,
    active_flag bit(1),
    budget_allowed_flag bit(1),
    description character varying,
    created_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_revenue_category to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_revenue_category; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_revenue_category AS
    SELECT ref_revenue_category__0.revenue_category_id, ref_revenue_category__0.revenue_category_code, ref_revenue_category__0.revenue_category_name, ref_revenue_category__0.revenue_category_short_name, ref_revenue_category__0.active_flag, ref_revenue_category__0.budget_allowed_flag, ref_revenue_category__0.description, ref_revenue_category__0.created_date, 
    ref_revenue_category__0.created_load_id,ref_revenue_category__0.updated_load_id, ref_revenue_category__0.updated_date FROM ONLY ref_revenue_category__0;

--
-- Name: ref_revenue_class__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_revenue_class__0 (
    revenue_class_id smallint,
    revenue_class_code character varying,
    revenue_class_name character varying,
    revenue_class_short_name character varying,
    active_flag bit(1),
    budget_allowed_flag bit(1),
    description character varying,
    created_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_revenue_class to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_revenue_class; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_revenue_class AS
    SELECT ref_revenue_class__0.revenue_class_id, ref_revenue_class__0.revenue_class_code, ref_revenue_class__0.revenue_class_name, ref_revenue_class__0.revenue_class_short_name, 
    ref_revenue_class__0.active_flag, ref_revenue_class__0.budget_allowed_flag, ref_revenue_class__0.description, ref_revenue_class__0.created_date, 
    ref_revenue_class__0.created_load_id,ref_revenue_class__0.updated_load_id, ref_revenue_class__0.updated_date FROM ONLY ref_revenue_class__0;

--
-- Name: ref_revenue_source__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_revenue_source__0 (
    revenue_source_id int,
    fiscal_year smallint,
    revenue_source_code character varying,
    revenue_source_name character varying,
    revenue_source_short_name character varying,
    description character varying,
    funding_class_id smallint,
    revenue_class_id smallint,
    revenue_category_id smallint,
    active_flag bit(1),
    budget_allowed_flag bit(1),
    operating_indicator integer,
    fasb_class_indicator integer,
    fhwa_revenue_credit_flag integer,
    usetax_collection_flag integer,
    apply_interest_late_fee integer,
    apply_interest_admin_fee integer,
    apply_interest_nsf_fee integer,
    apply_interest_other_fee integer,
    eligible_intercept_process integer,
    earned_receivable_code character varying,
    finance_fee_override_flag integer,
    allow_override_interest integer,
    billing_lag_days integer,
    billing_frequency integer,
    billing_fiscal_year_start_month smallint,
    billing_fiscal_year_start_day smallint,
    federal_agency_code character varying,
    federal_agency_suffix character varying,
    federal_name character varying,
    srsrc_req bpchar,
    created_date timestamp without time zone,
    updated_load_id integer,
    updated_date timestamp without time zone,
    created_load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_revenue_source to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_revenue_source; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_revenue_source AS
    SELECT ref_revenue_source__0.revenue_source_id, ref_revenue_source__0.fiscal_year, ref_revenue_source__0.revenue_source_code, ref_revenue_source__0.revenue_source_name, 
    ref_revenue_source__0.revenue_source_short_name, ref_revenue_source__0.description, ref_revenue_source__0.funding_class_id, ref_revenue_source__0.revenue_class_id, 
    ref_revenue_source__0.revenue_category_id, ref_revenue_source__0.active_flag, ref_revenue_source__0.budget_allowed_flag, ref_revenue_source__0.operating_indicator, 
    ref_revenue_source__0.fasb_class_indicator, ref_revenue_source__0.fhwa_revenue_credit_flag, ref_revenue_source__0.usetax_collection_flag, 
    ref_revenue_source__0.apply_interest_late_fee, ref_revenue_source__0.apply_interest_admin_fee, ref_revenue_source__0.apply_interest_nsf_fee, 
    ref_revenue_source__0.apply_interest_other_fee, ref_revenue_source__0.eligible_intercept_process, ref_revenue_source__0.earned_receivable_code, 
    ref_revenue_source__0.finance_fee_override_flag, ref_revenue_source__0.allow_override_interest, ref_revenue_source__0.billing_lag_days, 
    ref_revenue_source__0.billing_frequency, ref_revenue_source__0.billing_fiscal_year_start_month, ref_revenue_source__0.billing_fiscal_year_start_day, 
    ref_revenue_source__0.federal_agency_code, ref_revenue_source__0.federal_agency_suffix, ref_revenue_source__0.federal_name, ref_revenue_source__0.srsrc_req, 
    ref_revenue_source__0.created_date, ref_revenue_source__0.updated_load_id, ref_revenue_source__0.updated_date,ref_revenue_source__0.created_load_id FROM ONLY ref_revenue_source__0;

--
-- Name: ref_spending_category__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_spending_category__0 (
    spending_category_id smallint,
    spending_category_code character varying,
    spending_category_name character varying,
    display_name character varying,
    display_order smallint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_spending_category to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_spending_category; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_spending_category AS
    SELECT ref_spending_category__0.spending_category_id, ref_spending_category__0.spending_category_code, ref_spending_category__0.spending_category_name,
    ref_spending_category__0.display_name, ref_spending_category__0.display_order FROM ONLY ref_spending_category__0;

--
-- Name: ref_year__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_year__0 (
    year_id smallint,
    year_value smallint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_year to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: ref_year; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_year AS
    SELECT ref_year__0.year_id, ref_year__0.year_value FROM ONLY ref_year__0;

--
-- Name: revenue__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE revenue__0 (
    revenue_id bigint,
    record_date_id int,
    fiscal_period bpchar,
    fiscal_year smallint,
    budget_fiscal_year smallint,
    fiscal_quarter smallint,
    event_category character varying,
    event_type character varying,
    bank_account_code character varying,
    posting_pair_type character varying,
    posting_code character varying,
    debit_credit_indicator character varying,
    line_function smallint,
    posting_amount_original numeric,
    posting_amount numeric,
    increment_decrement_indicator character varying,
    time_of_occurence timestamp without time zone,
    balance_sheet_account_code character varying,
    balance_sheet_account_type smallint,
    expenditure_object_history_id integer,
    government_branch_code character varying,
    cabinet_code character varying,
    agency_history_id smallint,
    department_history_id integer,
    reporting_activity_code character varying,
    budget_code_id integer,
    fund_category character varying,
    fund_type character varying,
    fund_group character varying,
    balance_sheet_account_class_code character varying,
    balance_sheet_account_category_code character varying,
    balance_sheet_account_group_code character varying,
    balance_sheet_account_override_flag character(1),
    object_class_history_id integer,
    object_category_code character varying,
    object_type_code character varying,
    object_group_code character varying,
    document_category character varying,
    document_type character varying,
    document_code_id smallint,
    document_agency_history_id smallint,
    document_id character varying,
    document_version_number integer,
    document_function_code_id smallint,
    document_unit character varying,
    commodity_line integer,
    accounting_line integer,
    document_posting_line integer,
    ref_document_code_id smallint,
    ref_document_agency_history_id smallint,
    ref_document_id character varying,
    ref_commodity_line integer,
    ref_accounting_line integer,
    ref_posting_line integer,
    reference_type smallint,
    line_description character varying,
    service_start_date_id int,
    service_end_date_id int,
    reason_code character varying,
    reclassification_flag integer,
    closing_classification_code character varying,
    closing_classification_name character varying,
    revenue_category_id smallint,
    revenue_class_id smallint,
    revenue_source_id int,
    funding_source_id smallint,
    fund_class_id smallint,
    reporting_code character varying,
    major_cafr_revenue_type character varying,
    minor_cafr_revenue_type character varying,
    vendor_history_id integer,
    fiscal_year_id smallint,
    budget_fiscal_year_id smallint,    
    load_id integer,
    created_date timestamp without time zone  
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.revenue to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: revenue; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW revenue AS
    SELECT revenue__0.revenue_id, revenue__0.record_date_id, revenue__0.fiscal_period, revenue__0.fiscal_year, revenue__0.budget_fiscal_year, revenue__0.fiscal_quarter, revenue__0.event_category, revenue__0.event_type, revenue__0.bank_account_code, 
    revenue__0.posting_pair_type, revenue__0.posting_code, revenue__0.debit_credit_indicator, revenue__0.line_function, revenue__0.posting_amount_original,revenue__0.posting_amount, revenue__0.increment_decrement_indicator, revenue__0.time_of_occurence, revenue__0.balance_sheet_account_code, 
    revenue__0.balance_sheet_account_type, revenue__0.expenditure_object_history_id, revenue__0.government_branch_code, revenue__0.cabinet_code, revenue__0.agency_history_id, revenue__0.department_history_id, revenue__0.reporting_activity_code, 
    revenue__0.budget_code_id, revenue__0.fund_category, revenue__0.fund_type, revenue__0.fund_group, revenue__0.balance_sheet_account_class_code, revenue__0.balance_sheet_account_category_code, revenue__0.balance_sheet_account_group_code, revenue__0.balance_sheet_account_override_flag, revenue__0.object_class_history_id, revenue__0.object_category_code, revenue__0.object_type_code, revenue__0.object_group_code, revenue__0.document_category, revenue__0.document_type, revenue__0.document_code_id, revenue__0.document_agency_history_id, revenue__0.document_id, revenue__0.document_version_number, revenue__0.document_function_code_id, revenue__0.document_unit, revenue__0.commodity_line, revenue__0.accounting_line, revenue__0.document_posting_line, revenue__0.ref_document_code_id, revenue__0.ref_document_agency_history_id, revenue__0.ref_document_id, revenue__0.ref_commodity_line, revenue__0.ref_accounting_line, revenue__0.ref_posting_line, revenue__0.reference_type, revenue__0.line_description, revenue__0.service_start_date_id, revenue__0.service_end_date_id, revenue__0.reason_code, revenue__0.reclassification_flag, revenue__0.closing_classification_code, revenue__0.closing_classification_name, revenue__0.revenue_category_id, revenue__0.revenue_class_id, revenue__0.revenue_source_id, revenue__0.funding_source_id, revenue__0.fund_class_id, revenue__0.reporting_code, revenue__0.major_cafr_revenue_type, revenue__0.minor_cafr_revenue_type, revenue__0.vendor_history_id, revenue__0.fiscal_year_id, revenue__0.budget_fiscal_year_id, revenue__0.load_id,revenue__0.created_date FROM ONLY revenue__0;
    
--
-- Name: vendor__0; Type: EXTERNAL TABLE; Schema: staging; Owner: athiagarajan; Tablespace: 
--

CREATE EXTERNAL WEB TABLE vendor__0 (
    vendor_id integer,
    vendor_customer_code character varying,
    legal_name character varying,
    alias_name character varying,
    miscellaneous_vendor_flag bit(1),
    vendor_sub_code integer,
    display_flag bpchar,
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.vendor to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: vendor; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW vendor AS
    SELECT vendor__0.vendor_id, vendor__0.vendor_customer_code, vendor__0.legal_name, vendor__0.alias_name, vendor__0.miscellaneous_vendor_flag, vendor__0.vendor_sub_code, vendor__0.display_flag, vendor__0.updated_load_id, vendor__0.created_load_id, vendor__0.created_date, vendor__0.updated_date FROM ONLY vendor__0;
    
--
-- Name: vendor_address__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE vendor_address__0 (
    vendor_address_id bigint,
    vendor_history_id integer,
    address_id integer,
    address_type_id smallint,
    effective_begin_date_id int,
    effective_end_date_id int,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.vendor_address to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: vendor_address; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW vendor_address AS
    SELECT vendor_address__0.vendor_address_id, vendor_address__0.vendor_history_id, vendor_address__0.address_id, vendor_address__0.address_type_id, vendor_address__0.effective_begin_date_id, vendor_address__0.effective_end_date_id, vendor_address__0.load_id, vendor_address__0.created_date, vendor_address__0.updated_date FROM ONLY vendor_address__0;

--
-- Name: vendor_business_type__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE vendor_business_type__0 (
    vendor_business_type_id bigint,
    vendor_history_id integer,
    business_type_id smallint,
    status smallint,
    minority_type_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.vendor_business_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: vendor_business_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW vendor_business_type AS
    SELECT vendor_business_type__0.vendor_business_type_id, vendor_business_type__0.vendor_history_id, vendor_business_type__0.business_type_id, vendor_business_type__0.status, vendor_business_type__0.minority_type_id, vendor_business_type__0.load_id, vendor_business_type__0.created_date, vendor_business_type__0.updated_date FROM ONLY vendor_business_type__0;

--
-- Name: vendor_history__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE vendor_history__0 (
    vendor_history_id integer,
    vendor_id integer,
    legal_name character varying,
    alias_name character varying,
    miscellaneous_vendor_flag bit(1),
    vendor_sub_code integer,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.vendor_history to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

--
-- Name: vendor_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW vendor_history AS
    SELECT vendor_history__0.vendor_history_id, vendor_history__0.vendor_id, vendor_history__0.legal_name, vendor_history__0.alias_name, vendor_history__0.miscellaneous_vendor_flag, vendor_history__0.vendor_sub_code, vendor_history__0.load_id, vendor_history__0.created_date, vendor_history__0.updated_date FROM ONLY vendor_history__0;

    
CREATE EXTERNAL WEB TABLE vendor_details__0 (
	vendor_history_id integer,
	vendor_id		integer,
	vendor_customer_code	character varying(20),
	legal_name		character varying(60),
	alias_name		character varying(60),
	miscellaneous_vendor_flag	bit(1),
	vendor_sub_code		integer,
	address_type_code	character varying(2),
	address_type_name	character varying(50),
	address_id		integer,
	address_line_1		character varying(75),
	address_line_2		character varying(75),
	city			character varying(60),
  	state character varying(25),
  	zip character varying(25),
  	country character varying(25),
	status			smallint,
	business_type_id	smallint,
	business_type_code	character varying(4),
	business_type_name	character varying(50),
	minority_type_id	smallint,
	minority_type_name	character varying(50)
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.vendor_details to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


CREATE VIEW vendor_details AS
    SELECT vendor_details__0.vendor_history_id, vendor_details__0.vendor_id, vendor_details__0.vendor_customer_code, vendor_details__0.legal_name, vendor_details__0.alias_name, vendor_details__0.miscellaneous_vendor_flag, 
    vendor_details__0.vendor_sub_code, vendor_details__0.address_type_code, vendor_details__0.address_type_name, vendor_details__0.address_id, vendor_details__0.address_line_1, vendor_details__0.address_line_2, 
    vendor_details__0.city, vendor_details__0.state, vendor_details__0.zip, vendor_details__0.country, vendor_details__0.status, vendor_details__0.business_type_id, vendor_details__0.business_type_code, 
    vendor_details__0.business_type_name, vendor_details__0.minority_type_id, vendor_details__0.minority_type_name FROM ONLY vendor_details__0;

  
CREATE EXTERNAL WEB TABLE vendor_min_bus_type__0 (
	vendor_id integer,
  vendor_history_id integer,
  business_type_id smallint,
  minority_type_id smallint,
  business_type_code character varying,
  business_type_name character varying,
  minority_type_name character varying
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.vendor_min_bus_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

CREATE VIEW vendor_min_bus_type AS
    SELECT vendor_min_bus_type__0.vendor_id, vendor_min_bus_type__0.vendor_history_id, vendor_min_bus_type__0.business_type_id, vendor_min_bus_type__0.minority_type_id, 
    vendor_min_bus_type__0.business_type_code, vendor_min_bus_type__0.business_type_name, vendor_min_bus_type__0.minority_type_name
    FROM ONLY vendor_min_bus_type__0;
    
    
CREATE EXTERNAL WEB TABLE ref_fiscal_period__0(
	fiscal_period smallint,
	fiscal_period_name varchar
)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_fiscal_period to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

CREATE VIEW ref_fiscal_period AS
	SELECT ref_fiscal_period__0.fiscal_period, ref_fiscal_period__0.fiscal_period_name FROM ref_fiscal_period__0;
	


CREATE EXTERNAL WEB TABLE ref_pay_frequency__0(
	pay_frequency_id smallint,
	pay_frequency varchar
)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_pay_frequency to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

CREATE VIEW ref_pay_frequency AS
	SELECT ref_pay_frequency__0.pay_frequency_id, ref_pay_frequency__0.pay_frequency FROM ref_pay_frequency__0;
	
	
CREATE EXTERNAL WEB TABLE aggregateon_revenue_category_funding_class__0(
	revenue_category_code character varying,
	revenue_category_id smallint,
	funding_class_id smallint,
	funding_class_code character varying,
	agency_id smallint,
	budget_fiscal_year_id smallint,
	posting_amount numeric(16,2),
	adopted_amount numeric(16,2),
	current_modified_amount numeric(16,2)
)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_revenue_category_funding_class to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


CREATE VIEW aggregateon_revenue_category_funding_class AS
	SELECT aggregateon_revenue_category_funding_class__0.revenue_category_code,aggregateon_revenue_category_funding_class__0.revenue_category_id,
	       aggregateon_revenue_category_funding_class__0.funding_class_id,aggregateon_revenue_category_funding_class__0.funding_class_code,aggregateon_revenue_category_funding_class__0.agency_id,
	       aggregateon_revenue_category_funding_class__0.budget_fiscal_year_id,aggregateon_revenue_category_funding_class__0.posting_amount, 
	       aggregateon_revenue_category_funding_class__0.adopted_amount,aggregateon_revenue_category_funding_class__0.current_modified_amount
	FROM aggregateon_revenue_category_funding_class__0;

	

CREATE EXTERNAL WEB TABLE aggregateon_revenue_category_funding_by_year__0(
        revenue_category_code character varying,
        revenue_category_id smallint,
        funding_class_id smallint,
        funding_class_code character varying,
        agency_id smallint,
        budget_fiscal_year_id smallint,
        posting_amount_cy numeric(16,2),
        posting_amount_ny numeric(16,2),
        posting_amount_ny_1 numeric(16,2),
        posting_amount numeric(16,2),
        other_amount numeric(16,2),
        remaining_amount numeric(16,2),
        current_modified_amount numeric(16,2)
)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_revenue_category_funding_by_year to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

CREATE VIEW aggregateon_revenue_category_funding_by_year AS
	SELECT aggregateon_revenue_category_funding_by_year__0.revenue_category_code,aggregateon_revenue_category_funding_by_year__0.revenue_category_id,
	              aggregateon_revenue_category_funding_by_year__0.funding_class_id,aggregateon_revenue_category_funding_by_year__0.funding_class_code,aggregateon_revenue_category_funding_by_year__0.agency_id,
	              aggregateon_revenue_category_funding_by_year__0.budget_fiscal_year_id,aggregateon_revenue_category_funding_by_year__0.posting_amount_cy, 
	              aggregateon_revenue_category_funding_by_year__0.posting_amount_ny, aggregateon_revenue_category_funding_by_year__0.posting_amount_ny_1, aggregateon_revenue_category_funding_by_year__0.posting_amount, 
	              aggregateon_revenue_category_funding_by_year__0.other_amount,aggregateon_revenue_category_funding_by_year__0.remaining_amount,aggregateon_revenue_category_funding_by_year__0.current_modified_amount
	FROM aggregateon_revenue_category_funding_by_year__0;	


CREATE EXTERNAL WEB TABLE ref_amount_basis__0 (
  amount_basis_id smallint ,
  amount_basis_name varchar(50) ,
  created_date timestamp 
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_amount_basis to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

CREATE VIEW ref_amount_basis AS
	SELECT ref_amount_basis__0.amount_basis_id , ref_amount_basis__0.amount_basis_name , ref_amount_basis__0.created_date
	FROM 	ref_amount_basis__0;
	
CREATE EXTERNAL WEB TABLE employee__0 (
  employee_id bigint,
  employee_number varchar,
  agency_id smallint,
  first_name varchar,
  last_name varchar,
  initial varchar,
  original_first_name varchar,
  original_last_name varchar,
  original_initial varchar,
  masked_name varchar,
  civil_service_title varchar,
  civil_service_code varchar(5),
  civil_service_level varchar(2),
  civil_service_suffix varchar(2),
  created_date timestamp,
  updated_date timestamp,
  created_load_id int,
  updated_load_id int
  )
  EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.employee to stdout csv"' ON SEGMENT 0 
   FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';
  
 CREATE VIEW  employee AS
 	SELECT employee__0.employee_id , employee__0.employee_number , employee__0.agency_id ,employee__0.first_name , employee__0.last_name , 
 		employee__0.initial , employee__0.original_first_name , employee__0.original_last_name , employee__0.original_initial , 
 		employee__0.masked_name, employee__0.civil_service_title,employee__0.civil_service_code,employee__0.civil_service_level,employee__0.civil_service_suffix,
 		employee__0.created_date , employee__0.updated_date , employee__0.created_load_id , employee__0.updated_load_id 
 FROM employee__0; 		
 		
CREATE EXTERNAL WEB TABLE employee_history__0 (
  employee_history_id bigint,
  employee_id int,
  first_name varchar,
  last_name varchar,
  initial varchar,
  masked_name varchar,
  civil_service_title varchar,
  civil_service_code varchar(5),
  civil_service_level varchar(2),
  civil_service_suffix varchar(2),
  created_date timestamp,
  created_load_id int
  )
  EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.employee_history to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';

 CREATE VIEW employee_history AS
 	SELECT employee_history__0.employee_history_id , employee_history__0.employee_id , employee_history__0.first_name , employee_history__0.last_name ,
 		employee_history__0.initial , employee_history__0.masked_name, 
 		employee_history__0.civil_service_title,employee_history__0.civil_service_code,employee_history__0.civil_service_level,employee_history__0.civil_service_suffix,
 		employee_history__0.created_date , employee_history__0.created_load_id 
 	FROM   employee_history__0;
 		
CREATE EXTERNAL WEB TABLE payroll__0(
	payroll_id bigint,
	pay_cycle_code CHAR(1),
	pay_date_id int,
	employee_history_id bigint,
	employee_number varchar(70),
	payroll_number varchar,
	job_sequence_number varchar,
	agency_history_id smallint,
	fiscal_year smallint,	
	agency_start_date date,
	orig_pay_date_id int,
	pay_frequency varchar,
	department_history_id int,
	annual_salary_original numeric(16,2),
	annual_salary numeric(16,2),
	amount_basis_id smallint,
	base_pay_original numeric(16,2),
	base_pay numeric(16,2),
	overtime_pay_original numeric(16,2),
	overtime_pay numeric(16,2),
	other_payments_original numeric(16,2),
	other_payments numeric(16,2),
	gross_pay_original  numeric(16,2),
	gross_pay  numeric(16,2),
	civil_service_title varchar,
	salaried_amount numeric(16,2),
	non_salaried_amount numeric(16,2),
	orig_pay_cycle_code CHAR(1),
	agency_id smallint,
	agency_code varchar,
	agency_name varchar,
	department_id integer,
	department_code  varchar,
	department_name varchar,
	employee_id bigint,
	employee_name varchar,
	fiscal_year_id smallint,
	pay_date date,
	gross_pay_ytd numeric(16,2),
	calendar_fiscal_year_id smallint,
	calendar_fiscal_year smallint,
	gross_pay_cytd numeric(16,2),	
	agency_short_name varchar,
	department_short_name varchar,	
	created_date timestamp,
	created_load_id int,
	updated_date timestamp,
	updated_load_id int,
	job_id bigint
	)
	EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.payroll to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';	
  
 CREATE VIEW  payroll AS
 	SELECT payroll__0.payroll_id,payroll__0.pay_cycle_code,payroll__0.pay_date_id,payroll__0.employee_history_id,payroll__0.employee_number,
		payroll__0.payroll_number,payroll__0.job_sequence_number,payroll__0.agency_history_id,payroll__0.fiscal_year,
		payroll__0.agency_start_date,payroll__0.orig_pay_date_id,payroll__0.pay_frequency,payroll__0.department_history_id,payroll__0.annual_salary_original,payroll__0.annual_salary,
		payroll__0.amount_basis_id,payroll__0.base_pay_original,payroll__0.base_pay,payroll__0.overtime_pay_original,payroll__0.overtime_pay,
		payroll__0.other_payments_original,payroll__0.other_payments,payroll__0.gross_pay_original,payroll__0.gross_pay, payroll__0.civil_service_title,payroll__0.salaried_amount,payroll__0.non_salaried_amount,
		payroll__0.orig_pay_cycle_code,payroll__0.agency_id,payroll__0.agency_code,payroll__0.agency_name,payroll__0.department_id,
		payroll__0.department_code,payroll__0.department_name,payroll__0.employee_id,payroll__0.employee_name,payroll__0.fiscal_year_id,
		payroll__0.pay_date,payroll__0.gross_pay_ytd,payroll__0.calendar_fiscal_year_id,payroll__0.calendar_fiscal_year,payroll__0.gross_pay_cytd,
		payroll__0.agency_short_name,payroll__0.department_short_name,
		payroll__0.created_date,payroll__0.created_load_id,payroll__0.updated_date,
		payroll__0.updated_load_id,payroll__0.job_id
 	FROM	payroll__0;	
 	
CREATE EXTERNAL WEB TABLE aggregateon_payroll_employee_agency__0(
	employee_id bigint,
	agency_id smallint,
	fiscal_year_id smallint,
	type_of_year char(1),
	pay_frequency varchar,
	type_of_employment varchar,
	civil_service_title varchar,
	employee_number varchar(70),
	start_date date,		
	annual_salary numeric(16,2),
	base_pay numeric(16,2),
	overtime_pay numeric(16,2),
	other_payments numeric(16,2),
	gross_pay numeric(16,2) )
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_payroll_employee_agency to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
 CREATE VIEW aggregateon_payroll_employee_agency AS
  	SELECT aggregateon_payroll_employee_agency__0.employee_id, aggregateon_payroll_employee_agency__0.agency_id, aggregateon_payroll_employee_agency__0.fiscal_year_id,
  		aggregateon_payroll_employee_agency__0.type_of_year,aggregateon_payroll_employee_agency__0.pay_frequency,aggregateon_payroll_employee_agency__0.type_of_employment,aggregateon_payroll_employee_agency__0.civil_service_title,aggregateon_payroll_employee_agency__0.employee_number,
  		aggregateon_payroll_employee_agency__0.start_date,aggregateon_payroll_employee_agency__0.annual_salary, aggregateon_payroll_employee_agency__0.base_pay,
  		aggregateon_payroll_employee_agency__0.overtime_pay, aggregateon_payroll_employee_agency__0.other_payments,aggregateon_payroll_employee_agency__0.gross_pay
  	FROM	aggregateon_payroll_employee_agency__0;	
  		
CREATE EXTERNAL WEB TABLE aggregateon_payroll_agency__0(	
	agency_id smallint,	
	fiscal_year_id smallint,
	type_of_year char(1),
	base_pay numeric(16,2),
	other_payments numeric(16,2),
	gross_pay numeric(16,2),
	overtime_pay numeric(16,2),
	total_employees int,
	total_salaried_employees int,
	total_hourly_employees int,
	total_overtime_employees int,
	annual_salary numeric(16,2))
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_payroll_agency to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
 CREATE VIEW  aggregateon_payroll_agency AS
 	SELECT aggregateon_payroll_agency__0.agency_id, aggregateon_payroll_agency__0.fiscal_year_id, aggregateon_payroll_agency__0.type_of_year,
 		aggregateon_payroll_agency__0.base_pay, aggregateon_payroll_agency__0.other_payments, 
 		aggregateon_payroll_agency__0.gross_pay, aggregateon_payroll_agency__0.overtime_pay, aggregateon_payroll_agency__0.total_employees, 
 		aggregateon_payroll_agency__0.total_salaried_employees, aggregateon_payroll_agency__0.total_hourly_employees, 
 		aggregateon_payroll_agency__0.total_overtime_employees, aggregateon_payroll_agency__0.annual_salary
 	FROM 	aggregateon_payroll_agency__0;	

	
CREATE  EXTERNAL WEB TABLE aggregateon_payroll_coa_month__0(	
	agency_id smallint,
	department_id integer,
	fiscal_year_id smallint,
	month_id int,
	type_of_year char(1),	
	base_pay numeric(16,2),
	overtime_pay numeric(16,2),
	other_payments numeric(16,2),
	gross_pay numeric(16,2) )
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_payroll_coa_month to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW aggregateon_payroll_coa_month AS
  	SELECT aggregateon_payroll_coa_month__0.agency_id, aggregateon_payroll_coa_month__0.department_id, aggregateon_payroll_coa_month__0.fiscal_year_id, 
  		aggregateon_payroll_coa_month__0.month_id, aggregateon_payroll_coa_month__0.type_of_year, aggregateon_payroll_coa_month__0.base_pay, 
  		aggregateon_payroll_coa_month__0.overtime_pay, aggregateon_payroll_coa_month__0.other_payments, aggregateon_payroll_coa_month__0.gross_pay 
  	FROM aggregateon_payroll_coa_month__0;	
	
 CREATE  EXTERNAL WEB TABLE aggregateon_payroll_year__0(	
	fiscal_year_id smallint,
	type_of_year char(1),	
	total_employees int,
	total_salaried_employees int,
	total_hourly_employees int,
	total_overtime_employees int)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_payroll_year to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';	
  
  CREATE VIEW aggregateon_payroll_year AS
  	SELECT aggregateon_payroll_year__0.fiscal_year_id ,aggregateon_payroll_year__0.type_of_year ,aggregateon_payroll_year__0.total_employees ,
  		aggregateon_payroll_year__0.total_salaried_employees ,aggregateon_payroll_year__0.total_hourly_employees ,aggregateon_payroll_year__0.total_overtime_employees 
  	FROM aggregateon_payroll_year__0;	
  	
  	
  	
  	/* payroll aggregate tables for month_id */
	
  	CREATE EXTERNAL WEB TABLE aggregateon_payroll_employee_agency_month__0(
	employee_id bigint,
	agency_id smallint,
	fiscal_year_id smallint,
	type_of_year char(1),
	month_id int,
	pay_frequency varchar,
	type_of_employment varchar,
	civil_service_title varchar,
	employee_number varchar(70),
	start_date date,		
	annual_salary numeric(16,2),
	base_pay numeric(16,2),
	overtime_pay numeric(16,2),
	other_payments numeric(16,2),
	gross_pay numeric(16,2) )
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_payroll_employee_agency_month to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
 CREATE VIEW aggregateon_payroll_employee_agency_month AS
  	SELECT aggregateon_payroll_employee_agency_month__0.employee_id, aggregateon_payroll_employee_agency_month__0.agency_id, aggregateon_payroll_employee_agency_month__0.fiscal_year_id,
  		aggregateon_payroll_employee_agency_month__0.type_of_year,aggregateon_payroll_employee_agency_month__0.month_id,aggregateon_payroll_employee_agency_month__0.pay_frequency,
  		aggregateon_payroll_employee_agency_month__0.type_of_employment,aggregateon_payroll_employee_agency_month__0.civil_service_title,aggregateon_payroll_employee_agency_month__0.employee_number,
  		aggregateon_payroll_employee_agency_month__0.start_date,aggregateon_payroll_employee_agency_month__0.annual_salary, aggregateon_payroll_employee_agency_month__0.base_pay,
  		aggregateon_payroll_employee_agency_month__0.overtime_pay, aggregateon_payroll_employee_agency_month__0.other_payments,aggregateon_payroll_employee_agency_month__0.gross_pay
  	FROM	aggregateon_payroll_employee_agency_month__0;	
  		
CREATE EXTERNAL WEB TABLE aggregateon_payroll_agency_month__0(	
	agency_id smallint,	
	fiscal_year_id smallint,
	type_of_year char(1),
	month_id int,
	base_pay numeric(16,2),
	other_payments numeric(16,2),
	gross_pay numeric(16,2),
	overtime_pay numeric(16,2),
	total_employees int,
	total_salaried_employees int,
	total_hourly_employees int,
	total_overtime_employees int,
	annual_salary numeric(16,2))
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_payroll_agency_month to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
 CREATE VIEW  aggregateon_payroll_agency_month AS
 	SELECT aggregateon_payroll_agency_month__0.agency_id, aggregateon_payroll_agency_month__0.fiscal_year_id, aggregateon_payroll_agency_month__0.type_of_year,
 		aggregateon_payroll_agency_month__0.month_id,aggregateon_payroll_agency_month__0.base_pay, aggregateon_payroll_agency_month__0.other_payments, 
 		aggregateon_payroll_agency_month__0.gross_pay, aggregateon_payroll_agency_month__0.overtime_pay, aggregateon_payroll_agency_month__0.total_employees, 
 		aggregateon_payroll_agency_month__0.total_salaried_employees, aggregateon_payroll_agency_month__0.total_hourly_employees, 
 		aggregateon_payroll_agency_month__0.total_overtime_employees, aggregateon_payroll_agency_month__0.annual_salary
 	FROM 	aggregateon_payroll_agency_month__0;	

	
 CREATE  EXTERNAL WEB TABLE aggregateon_payroll_year_and_month__0(	
	fiscal_year_id smallint,
	type_of_year char(1),	
	month_id int,
	total_employees int,
	total_salaried_employees int,
	total_hourly_employees int,
	total_overtime_employees int)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_payroll_year_and_month to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';	
  
  CREATE VIEW aggregateon_payroll_year_and_month AS
  	SELECT aggregateon_payroll_year_and_month__0.fiscal_year_id ,aggregateon_payroll_year_and_month__0.type_of_year ,aggregateon_payroll_year_and_month__0.month_id ,aggregateon_payroll_year_and_month__0.total_employees ,
  		aggregateon_payroll_year_and_month__0.total_salaried_employees ,aggregateon_payroll_year_and_month__0.total_hourly_employees ,aggregateon_payroll_year_and_month__0.total_overtime_employees 
  	FROM aggregateon_payroll_year_and_month__0;	
  	
  	
	--
	-- Name: revenue_budget__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
	--
	
	
	CREATE EXTERNAL WEB TABLE revenue_budget__0
	(
	  budget_id integer,
	  budget_fiscal_year smallint,
	  budget_code character varying,
	  agency_code character varying,
	  revenue_source_code character varying,
	  adopted_amount_original numeric(20,2),
	  adopted_amount numeric(20,2),
	  current_modified_budget_amount_original numeric(20,2),
	  current_modified_budget_amount numeric(20,2),
	  fund_class_id smallint,
	  agency_history_id smallint,
	  budget_code_id integer,
	  agency_id smallint,
	  revenue_source_id integer,
	  agency_name character varying,
	  agency_short_name character varying(15),
	  revenue_source_name character varying,
	  created_load_id integer,
	  updated_load_id integer,
	  created_date timestamp without time zone,
	  updated_date timestamp without time zone,
	  budget_fiscal_year_id smallint,
	  revenue_category_id smallint,
	  revenue_category_code character varying,
	  revenue_category_name character varying,
	  funding_class_id smallint,
	  funding_class_code character varying,
	  funding_class_name character varying,
	  budget_code_name character varying

	)
	 EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.revenue_budget to stdout csv"' ON SEGMENT 0 
	 FORMAT 'csv' (delimiter ',' null '' escape '"' quote '"')
	ENCODING 'UTF8';
		
	--
	-- Name: revenue_budget; Type: VIEW; Schema: staging; Owner: gpadmin
	--
	
	
	CREATE  VIEW revenue_budget AS 
	 SELECT revenue_budget__0.budget_id, revenue_budget__0.budget_fiscal_year, revenue_budget__0.budget_code,
	 revenue_budget__0.agency_code, revenue_budget__0.revenue_source_code, revenue_budget__0.adopted_amount_original, revenue_budget__0.adopted_amount,
	 revenue_budget__0.current_modified_budget_amount_original, revenue_budget__0.current_modified_budget_amount, revenue_budget__0.fund_class_id, revenue_budget__0.agency_history_id, 
	 revenue_budget__0.budget_code_id, revenue_budget__0.agency_id, revenue_budget__0.revenue_source_id, revenue_budget__0.agency_name, 
	 revenue_budget__0.agency_short_name,revenue_budget__0.revenue_source_name, revenue_budget__0.created_load_id, revenue_budget__0.updated_load_id,
	 revenue_budget__0.created_date, revenue_budget__0.updated_date, revenue_budget__0.budget_fiscal_year_id,
	 revenue_budget__0.revenue_category_id,revenue_budget__0.revenue_category_code,revenue_budget__0.revenue_category_name,revenue_budget__0.funding_class_id,
	 revenue_budget__0.funding_class_code,revenue_budget__0.funding_class_name,revenue_budget__0.budget_code_name
	   FROM ONLY revenue_budget__0;
	
	
	
	
	
	 	
 
  	
CREATE EXTERNAL WEB TABLE payroll_summary__0 (
    payroll_summary_id bigint,
    agency_history_id smallint,
    pay_cycle_code char(1),
    expenditure_object_history_id integer,
    payroll_number varchar,
    payroll_description varchar,
    department_history_id integer,
    pms_fiscal_year smallint,
    budget_code_id integer,
    total_amount_original numeric(15,2),
    total_amount numeric(15,2),
    pay_date_id int,
    fiscal_year smallint,
    fiscal_year_id smallint,
    calendar_fiscal_year_id smallint, 
    calendar_fiscal_year smallint,
    created_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    updated_load_id integer
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.payroll_summary to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW payroll_summary AS
  	SELECT payroll_summary__0.payroll_summary_id ,payroll_summary__0.agency_history_id ,payroll_summary__0.pay_cycle_code ,payroll_summary__0.expenditure_object_history_id ,
  		payroll_summary__0.payroll_number ,payroll_summary__0.payroll_description ,payroll_summary__0. department_history_id,payroll_summary__0.pms_fiscal_year,
  		payroll_summary__0.budget_code_id ,payroll_summary__0.total_amount_original,payroll_summary__0.total_amount,payroll_summary__0.pay_date_id ,payroll_summary__0.fiscal_year ,
  		payroll_summary__0.fiscal_year_id ,payroll_summary__0.calendar_fiscal_year_id ,payroll_summary__0.calendar_fiscal_year ,payroll_summary__0.created_load_id ,
  		payroll_summary__0.created_date ,payroll_summary__0.updated_date,payroll_summary__0.updated_load_id
  	FROM payroll_summary__0;

 CREATE EXTERNAL WEB TABLE agreement_snapshot_expanded__0(
 	original_agreement_id bigint,
 	agreement_id bigint,
 	fiscal_year smallint,
 	description varchar,
 	contract_number varchar,
 	vendor_id int,
 	agency_id smallint,
 	industry_type_id smallint,
    award_size_id smallint,
 	original_contract_amount numeric(16,2) ,
 	maximum_contract_amount numeric(16,2),
 	rfed_amount numeric(16,2),
 	starting_year smallint,	
 	ending_year smallint,
 	dollar_difference numeric(16,2), 
 	percent_difference numeric(17,4),
 	award_method_id smallint,
 	document_code_id smallint,
 	master_agreement_id bigint,
 	minority_type_id smallint,
 	minority_type_name character varying,
 	master_agreement_yn character(1),
 	status_flag char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement_snapshot_expanded to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';

CREATE VIEW agreement_snapshot_expanded AS
	 SELECT agreement_snapshot_expanded__0.original_agreement_id,agreement_snapshot_expanded__0.agreement_id,agreement_snapshot_expanded__0.fiscal_year,agreement_snapshot_expanded__0.description,
	 	agreement_snapshot_expanded__0.contract_number,agreement_snapshot_expanded__0.vendor_id,agreement_snapshot_expanded__0.agency_id,agreement_snapshot_expanded__0.industry_type_id,agreement_snapshot_expanded__0.award_size_id,
	 	agreement_snapshot_expanded__0.original_contract_amount,agreement_snapshot_expanded__0.maximum_contract_amount,agreement_snapshot_expanded__0.rfed_amount,
	 	agreement_snapshot_expanded__0.starting_year,agreement_snapshot_expanded__0.ending_year,agreement_snapshot_expanded__0.dollar_difference,
	 	agreement_snapshot_expanded__0.percent_difference,agreement_snapshot_expanded__0.award_method_id,agreement_snapshot_expanded__0.document_code_id,
	 	agreement_snapshot_expanded__0.master_agreement_id,agreement_snapshot_expanded__0.minority_type_id,agreement_snapshot_expanded__0.minority_type_name,
	 	agreement_snapshot_expanded__0.master_agreement_yn,agreement_snapshot_expanded__0.status_flag
	 FROM 	agreement_snapshot_expanded__0;
	 
CREATE EXTERNAL WEB TABLE agreement_snapshot_expanded_cy__0(
	original_agreement_id bigint,
	agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	vendor_id int,
	agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	original_contract_amount numeric(16,2) ,
	maximum_contract_amount numeric(16,2),
	rfed_amount numeric(16,2),
	starting_year smallint,	
	ending_year smallint,
	dollar_difference numeric(16,2), 
	percent_difference numeric(17,4),
	award_method_id smallint,
	document_code_id smallint,
	master_agreement_id bigint,
	minority_type_id smallint,
 	minority_type_name character varying,
	master_agreement_yn character(1),
	status_flag char(1)
	)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement_snapshot_expanded_cy to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';	 
  
  CREATE VIEW agreement_snapshot_expanded_cy AS
  	SELECT agreement_snapshot_expanded_cy__0.original_agreement_id,agreement_snapshot_expanded_cy__0.agreement_id,agreement_snapshot_expanded_cy__0.fiscal_year,agreement_snapshot_expanded_cy__0.description,
  		agreement_snapshot_expanded_cy__0.contract_number,agreement_snapshot_expanded_cy__0.vendor_id,agreement_snapshot_expanded_cy__0.agency_id,agreement_snapshot_expanded_cy__0.industry_type_id,agreement_snapshot_expanded_cy__0.award_size_id,
  		agreement_snapshot_expanded_cy__0.original_contract_amount,agreement_snapshot_expanded_cy__0.maximum_contract_amount,agreement_snapshot_expanded_cy__0.rfed_amount,
  		agreement_snapshot_expanded_cy__0.starting_year,agreement_snapshot_expanded_cy__0.ending_year,agreement_snapshot_expanded_cy__0.dollar_difference,
  		agreement_snapshot_expanded_cy__0.percent_difference,agreement_snapshot_expanded_cy__0.award_method_id,agreement_snapshot_expanded_cy__0.document_code_id,
  		agreement_snapshot_expanded_cy__0.master_agreement_id,agreement_snapshot_expanded_cy__0.minority_type_id,agreement_snapshot_expanded_cy__0.minority_type_name,
  		agreement_snapshot_expanded_cy__0.master_agreement_yn,agreement_snapshot_expanded_cy__0.status_flag
  	FROM agreement_snapshot_expanded_cy__0;	
  	

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
  		aggregateon_contracts_cumulative_spending__0.status_flag,aggregateon_contracts_cumulative_spending__0.type_of_year
  	FROM 	  aggregateon_contracts_cumulative_spending__0;
  	
  CREATE EXTERNAL WEB TABLE aggregateon_contracts_spending_by_month__0
  (
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	month_id integer,
	vendor_id int,
	award_method_id smallint,
	agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	spending_amount numeric(16,2),
	status_flag char(1),
	type_of_year char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_contracts_spending_by_month to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW aggregateon_contracts_spending_by_month AS
  	SELECT aggregateon_contracts_spending_by_month__0.original_agreement_id,aggregateon_contracts_spending_by_month__0.fiscal_year,aggregateon_contracts_spending_by_month__0.fiscal_year_id,
  		aggregateon_contracts_spending_by_month__0.document_code_id,aggregateon_contracts_spending_by_month__0.month_id,
  		aggregateon_contracts_spending_by_month__0.vendor_id,aggregateon_contracts_spending_by_month__0.award_method_id,
  		aggregateon_contracts_spending_by_month__0.agency_id,aggregateon_contracts_spending_by_month__0.industry_type_id, aggregateon_contracts_spending_by_month__0.award_size_id,
  		aggregateon_contracts_spending_by_month__0.spending_amount,	aggregateon_contracts_spending_by_month__0.status_flag,aggregateon_contracts_spending_by_month__0.type_of_year
  	FROM  aggregateon_contracts_spending_by_month__0;
  	
 CREATE EXTERNAL WEB TABLE aggregateon_total_contracts__0
(
	fiscal_year smallint,
	fiscal_year_id smallint,
	vendor_id int,
	award_method_id smallint,
	agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	total_contracts bigint,
	total_commited_contracts bigint,
	total_master_agreements bigint,
	total_standalone_contracts bigint,
	total_revenue_contracts bigint,
	total_revenue_contracts_amount numeric(16,2),
	total_commited_contracts_amount numeric(16,2),
	total_contracts_amount numeric(16,2),
	total_spending_amount_disb numeric(16,2), 
	total_spending_amount numeric(16,2),
	status_flag char(1),
	type_of_year char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_total_contracts to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW aggregateon_total_contracts AS
  	SELECT aggregateon_total_contracts__0.fiscal_year,aggregateon_total_contracts__0.fiscal_year_id,aggregateon_total_contracts__0.vendor_id,aggregateon_total_contracts__0.award_method_id,
  	aggregateon_total_contracts__0.agency_id, aggregateon_total_contracts__0.industry_type_id, aggregateon_total_contracts__0.award_size_id,
  	aggregateon_total_contracts__0.total_contracts,aggregateon_total_contracts__0.total_commited_contracts,	aggregateon_total_contracts__0.total_master_agreements,
  	aggregateon_total_contracts__0.total_standalone_contracts,aggregateon_total_contracts__0.total_revenue_contracts,aggregateon_total_contracts__0.total_revenue_contracts_amount,
  	aggregateon_total_contracts__0.total_commited_contracts_amount,aggregateon_total_contracts__0.total_contracts_amount,aggregateon_total_contracts__0.total_spending_amount_disb,
  	aggregateon_total_contracts__0.total_spending_amount,aggregateon_total_contracts__0.status_flag,aggregateon_total_contracts__0.type_of_year
  	FROM   aggregateon_total_contracts__0;
 
 CREATE EXTERNAL WEB TABLE aggregateon_contracts_department__0(
 	document_code_id smallint,
 	document_agency_id smallint,
	agency_id smallint,
	department_id integer,
	fiscal_year smallint,
	fiscal_year_id smallint,
	award_method_id smallint,
	vendor_id int,
	industry_type_id smallint,
    award_size_id smallint,
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	total_contracts integer,
	status_flag char(1),
	type_of_year char(1)
) 	
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_contracts_department to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  

  CREATE VIEW aggregateon_contracts_department AS
  	SELECT aggregateon_contracts_department__0.document_code_id,aggregateon_contracts_department__0.document_agency_id,aggregateon_contracts_department__0.agency_id,aggregateon_contracts_department__0.department_id,aggregateon_contracts_department__0.fiscal_year,
  	aggregateon_contracts_department__0.fiscal_year_id,aggregateon_contracts_department__0.award_method_id,aggregateon_contracts_department__0.vendor_id,aggregateon_contracts_department__0.industry_type_id, aggregateon_contracts_department__0.award_size_id,
  	aggregateon_contracts_department__0.spending_amount_disb,aggregateon_contracts_department__0.spending_amount,aggregateon_contracts_department__0.total_contracts,aggregateon_contracts_department__0.status_flag,aggregateon_contracts_department__0.type_of_year
  	FROM   aggregateon_contracts_department__0;
  	
  	
   CREATE EXTERNAL WEB TABLE contracts_spending_transactions__0(
 	disbursement_line_item_id bigint,
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	vendor_id int,
	award_method_id smallint,
	document_agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	disb_document_id  character varying(20),
	disb_vendor_name  character varying,
	disb_check_eft_issued_date  date,
	disb_agency_name  character varying(100),
	disb_department_short_name  character varying(15),
	disb_check_amount  numeric(16,2),
	disb_expenditure_object_name  character varying(40),
	disb_budget_name  character varying(60),
	disb_contract_number  character varying,
	disb_purpose  character varying,
	disb_reporting_code  character varying(15),
	disb_spending_category_name  character varying,
	disb_agency_id  smallint,
	disb_vendor_id  integer,
	disb_expenditure_object_id  integer,
	disb_department_id  integer,
	disb_spending_category_id  smallint,
	disb_agreement_id  bigint,
	disb_contract_document_code  character varying(8),
	disb_master_agreement_id  bigint,
	disb_fiscal_year_id  smallint,
	disb_check_eft_issued_cal_month_id integer,
	disb_disbursement_number character varying(40),
	status_flag char(1),
	type_of_year char(1)
) 	
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.contracts_spending_transactions to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  

  CREATE VIEW contracts_spending_transactions AS
  	SELECT contracts_spending_transactions__0.disbursement_line_item_id,contracts_spending_transactions__0.original_agreement_id,contracts_spending_transactions__0.fiscal_year,
  	contracts_spending_transactions__0.fiscal_year_id,contracts_spending_transactions__0.document_code_id, contracts_spending_transactions__0.vendor_id,contracts_spending_transactions__0.award_method_id,
  	contracts_spending_transactions__0.document_agency_id, contracts_spending_transactions__0.industry_type_id, contracts_spending_transactions__0.award_size_id,
  	contracts_spending_transactions__0.disb_document_id,contracts_spending_transactions__0.disb_vendor_name,contracts_spending_transactions__0.disb_check_eft_issued_date,contracts_spending_transactions__0.disb_agency_name,
  	contracts_spending_transactions__0.disb_department_short_name,contracts_spending_transactions__0.disb_check_amount,contracts_spending_transactions__0.disb_expenditure_object_name,
  	contracts_spending_transactions__0.disb_budget_name,contracts_spending_transactions__0.disb_contract_number,contracts_spending_transactions__0.disb_purpose,contracts_spending_transactions__0.disb_reporting_code,
  	contracts_spending_transactions__0.disb_spending_category_name,contracts_spending_transactions__0.disb_agency_id,contracts_spending_transactions__0.disb_vendor_id,contracts_spending_transactions__0.disb_expenditure_object_id,
  	contracts_spending_transactions__0.disb_department_id,contracts_spending_transactions__0.disb_spending_category_id,contracts_spending_transactions__0.disb_agreement_id,contracts_spending_transactions__0.disb_contract_document_code,
  	contracts_spending_transactions__0.disb_master_agreement_id,contracts_spending_transactions__0.disb_fiscal_year_id,contracts_spending_transactions__0.disb_check_eft_issued_cal_month_id,contracts_spending_transactions__0.disb_disbursement_number,
  	contracts_spending_transactions__0.status_flag,contracts_spending_transactions__0.type_of_year
  	FROM   contracts_spending_transactions__0;	
  	
CREATE EXTERNAL WEB TABLE aggregateon_contracts_expense__0(
	original_agreement_id bigint,
	expenditure_object_code character varying(4),
	expenditure_object_name character varying(40),
	encumbered_amount numeric(16,2),
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	is_disbursements_exist char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_contracts_expense to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';	


   CREATE VIEW aggregateon_contracts_expense AS
     	SELECT aggregateon_contracts_expense__0.original_agreement_id,aggregateon_contracts_expense__0.expenditure_object_code,aggregateon_contracts_expense__0.expenditure_object_name,
  	aggregateon_contracts_expense__0.encumbered_amount,aggregateon_contracts_expense__0.spending_amount_disb,aggregateon_contracts_expense__0.spending_amount,aggregateon_contracts_expense__0.is_disbursements_exist
  	  	FROM   aggregateon_contracts_expense__0;	
 
  	
CREATE EXTERNAL WEB TABLE agreement_snapshot__0(
 	 original_agreement_id bigint,
	   document_version smallint,
	   document_code_id smallint,
	   agency_history_id smallint,
	   agency_id smallint,
	   agency_code character varying(20),
	   agency_name character varying(100),
	   agreement_id bigint,
	   starting_year smallint,
	   starting_year_id smallint,
	   ending_year smallint,
	   ending_year_id smallint,
	   registered_year smallint,
	   registered_year_id smallint,
	   contract_number character varying,
	   original_contract_amount numeric(16,2),
	   maximum_contract_amount numeric(16,2),	   
	   description character varying,
	   vendor_history_id integer,
	   vendor_id integer,
	   vendor_code character varying(20),
	   vendor_name character varying,
	   dollar_difference numeric(16,2),
	   percent_difference numeric(17,4),
	   master_agreement_id bigint,
	   master_contract_number character varying,
	   agreement_type_id smallint,
	   agreement_type_code character varying(2),
	   agreement_type_name character varying,
	   award_category_id smallint,
	   award_category_code character varying(10),
	   award_category_name character varying,
	   award_method_id smallint,
	   award_method_code character varying(10) ,
	   award_method_name character varying,
	   expenditure_object_codes character varying,
	   expenditure_object_names character varying,
	   industry_type_id smallint,
	   industry_type_name character varying(50),
   	   award_size_id smallint,
	   effective_begin_date date,
	   effective_begin_date_id integer,
	   effective_begin_year smallint,
	   effective_begin_year_id smallint,
	   effective_end_date date,
	   effective_end_date_id integer,
	   effective_end_year smallint,
	   effective_end_year_id smallint,
	   registered_date date,
	   registered_date_id integer,
	   brd_awd_no character varying,
	   tracking_number character varying,
	   rfed_amount numeric(16,2),
	   minority_type_id smallint,
 	   minority_type_name character varying,
	   master_agreement_yn character(1),
	   has_children character(1),
	   has_mwbe_children character(1),
	   original_version_flag character(1),
   	   latest_flag character(1),
   	  load_id integer,
      last_modified_date timestamp without time zone,
      job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement_snapshot to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW agreement_snapshot AS
  	SELECT agreement_snapshot__0.original_agreement_id,agreement_snapshot__0.document_version,agreement_snapshot__0.document_code_id,
  		agreement_snapshot__0.agency_history_id,agreement_snapshot__0.agency_id,agreement_snapshot__0.agency_code,agreement_snapshot__0.agency_name,
  		agreement_snapshot__0.agreement_id,agreement_snapshot__0.starting_year,agreement_snapshot__0.starting_year_id,agreement_snapshot__0.ending_year,
  		agreement_snapshot__0.ending_year_id,agreement_snapshot__0.registered_year,agreement_snapshot__0.registered_year_id,agreement_snapshot__0.contract_number,
  		agreement_snapshot__0.original_contract_amount,agreement_snapshot__0.maximum_contract_amount,agreement_snapshot__0.description,
  		agreement_snapshot__0.vendor_history_id,agreement_snapshot__0.vendor_id,agreement_snapshot__0.vendor_code,agreement_snapshot__0.vendor_name,
  		agreement_snapshot__0.dollar_difference,agreement_snapshot__0.percent_difference,agreement_snapshot__0.master_agreement_id,agreement_snapshot__0.master_contract_number,
  		agreement_snapshot__0.agreement_type_id,agreement_snapshot__0.agreement_type_code,agreement_snapshot__0.agreement_type_name,agreement_snapshot__0.award_category_id,agreement_snapshot__0.award_category_code,
  		agreement_snapshot__0.award_category_name,agreement_snapshot__0.award_method_id,agreement_snapshot__0.award_method_code,agreement_snapshot__0.award_method_name,
  		agreement_snapshot__0.expenditure_object_codes,agreement_snapshot__0.expenditure_object_names,agreement_snapshot__0.industry_type_id,agreement_snapshot__0.industry_type_name,agreement_snapshot__0.award_size_id,
  		agreement_snapshot__0.effective_begin_date,agreement_snapshot__0.effective_begin_date_id,
  		agreement_snapshot__0.effective_begin_year,agreement_snapshot__0.effective_begin_year_id,agreement_snapshot__0.effective_end_date,
  		agreement_snapshot__0.effective_end_date_id,agreement_snapshot__0.effective_end_year,agreement_snapshot__0.effective_end_year_id,
  		agreement_snapshot__0.registered_date,agreement_snapshot__0.registered_date_id,agreement_snapshot__0.brd_awd_no,agreement_snapshot__0.tracking_number,agreement_snapshot__0.rfed_amount,
  		agreement_snapshot__0.minority_type_id,agreement_snapshot__0.minority_type_name,
  		agreement_snapshot__0.master_agreement_yn,agreement_snapshot__0.has_children,agreement_snapshot__0.has_mwbe_children,agreement_snapshot__0.original_version_flag,agreement_snapshot__0.latest_flag,
  		agreement_snapshot__0.load_id,agreement_snapshot__0.last_modified_date,agreement_snapshot__0.job_id
  	FROM  agreement_snapshot__0;
  	
CREATE EXTERNAL WEB TABLE agreement_snapshot_cy__0(
 	original_agreement_id bigint,
	  document_version smallint,
	  document_code_id smallint,
	  agency_history_id smallint,
	  agency_id smallint,
	  agency_code character varying(20),
	  agency_name character varying(100),
	  agreement_id bigint,
	  starting_year smallint,
	  starting_year_id smallint,
	  ending_year smallint,
	  ending_year_id smallint,
	  registered_year smallint,
	  registered_year_id smallint,
	  contract_number character varying,
	  original_contract_amount numeric(16,2),
	  maximum_contract_amount numeric(16,2),
	  description character varying,
	  vendor_history_id integer,
	  vendor_id integer,
	  vendor_code character varying(20),
	  vendor_name character varying,
	  dollar_difference numeric(16,2),
	  percent_difference numeric(17,4),
	  master_agreement_id bigint,
	  master_contract_number character varying,
	  agreement_type_id smallint,
	  agreement_type_code character varying(2),
	  agreement_type_name character varying,
	  award_category_id smallint,
	  award_category_code character varying(10),
	  award_category_name character varying,
	  award_method_id smallint,
	  award_method_code character varying(10),
	  award_method_name character varying,
	  expenditure_object_codes character varying,
	  expenditure_object_names character varying,
	  industry_type_id smallint,
	  industry_type_name character varying(50),
   	  award_size_id smallint,
	  effective_begin_date date,
	  effective_begin_date_id integer,
	  effective_begin_year smallint,
	  effective_begin_year_id smallint,
	  effective_end_date date,
	  effective_end_date_id integer,
	  effective_end_year smallint,
	  effective_end_year_id smallint,
	  registered_date date,
	  registered_date_id integer,
	  brd_awd_no character varying,
	  tracking_number character varying,
	  rfed_amount numeric(16,2),
	  minority_type_id smallint,
 	minority_type_name character varying,
	  master_agreement_yn character(1),
	  has_children character(1),
	  has_mwbe_children character(1),
	  original_version_flag character(1),
  	  latest_flag character(1),
  	  load_id integer,
      last_modified_date timestamp without time zone,
      job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement_snapshot_cy to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW agreement_snapshot_cy AS
  	SELECT agreement_snapshot_cy__0.original_agreement_id,agreement_snapshot_cy__0.document_version,agreement_snapshot_cy__0.document_code_id,
  		agreement_snapshot_cy__0.agency_history_id,agreement_snapshot_cy__0.agency_id,agreement_snapshot_cy__0.agency_code,agreement_snapshot_cy__0.agency_name,
  		agreement_snapshot_cy__0.agreement_id,agreement_snapshot_cy__0.starting_year,agreement_snapshot_cy__0.starting_year_id,agreement_snapshot_cy__0.ending_year,
  		agreement_snapshot_cy__0.ending_year_id,agreement_snapshot_cy__0.registered_year,agreement_snapshot_cy__0.registered_year_id,agreement_snapshot_cy__0.contract_number,
  		agreement_snapshot_cy__0.original_contract_amount,agreement_snapshot_cy__0.maximum_contract_amount,agreement_snapshot_cy__0.description,
  		agreement_snapshot_cy__0.vendor_history_id,agreement_snapshot_cy__0.vendor_id,agreement_snapshot_cy__0.vendor_code,agreement_snapshot_cy__0.vendor_name,
  		agreement_snapshot_cy__0.dollar_difference,agreement_snapshot_cy__0.percent_difference,agreement_snapshot_cy__0.master_agreement_id,agreement_snapshot_cy__0.master_contract_number,
  		agreement_snapshot_cy__0.agreement_type_id,agreement_snapshot_cy__0.agreement_type_code,agreement_snapshot_cy__0.agreement_type_name,agreement_snapshot_cy__0.award_category_id,agreement_snapshot_cy__0.award_category_code,
  		agreement_snapshot_cy__0.award_category_name,agreement_snapshot_cy__0.award_method_id,agreement_snapshot_cy__0.award_method_code,agreement_snapshot_cy__0.award_method_name,
   		agreement_snapshot_cy__0.expenditure_object_codes,agreement_snapshot_cy__0.expenditure_object_names,agreement_snapshot_cy__0.industry_type_id,agreement_snapshot_cy__0.industry_type_name,agreement_snapshot_cy__0.award_size_id,
   		agreement_snapshot_cy__0.effective_begin_date,agreement_snapshot_cy__0.effective_begin_date_id,
  		agreement_snapshot_cy__0.effective_begin_year,agreement_snapshot_cy__0.effective_begin_year_id,agreement_snapshot_cy__0.effective_end_date,
  		agreement_snapshot_cy__0.effective_end_date_id,agreement_snapshot_cy__0.effective_end_year,agreement_snapshot_cy__0.effective_end_year_id,
  		agreement_snapshot_cy__0.registered_date,agreement_snapshot_cy__0.registered_date_id,agreement_snapshot_cy__0.brd_awd_no,agreement_snapshot_cy__0.tracking_number,agreement_snapshot_cy__0.rfed_amount,
  		agreement_snapshot_cy__0.minority_type_id,agreement_snapshot_cy__0.minority_type_name,
  		agreement_snapshot_cy__0.master_agreement_yn,agreement_snapshot_cy__0.has_children,agreement_snapshot_cy__0.has_mwbe_children,agreement_snapshot_cy__0.original_version_flag,agreement_snapshot_cy__0.latest_flag,
  		agreement_snapshot_cy__0.load_id,agreement_snapshot_cy__0.last_modified_date,agreement_snapshot_cy__0.job_id
  	FROM  agreement_snapshot_cy__0;
  	
  	
CREATE EXTERNAL WEB TABLE pending_contracts__0(
 	document_code_id smallint,
 	document_agency_id  smallint,
 	document_id  varchar,
  	parent_document_code_id smallint,
  	parent_document_agency_id  smallint,
 	parent_document_id  varchar,
 	encumbrance_amount_original numeric(15,2),
 	encumbrance_amount numeric(15,2),
 	original_maximum_amount_original numeric(15,2),
 	original_maximum_amount numeric(15,2),
 	revised_maximum_amount_original numeric(15,2),
 	revised_maximum_amount numeric(15,2),
 	registered_contract_max_amount numeric(15,2),
 	vendor_legal_name varchar(80),
 	vendor_customer_code varchar(20),
 	vendor_id int,
 	description varchar(78),
 	submitting_agency_id  smallint,
 	oaisis_submitting_agency_desc	 varchar(50),
 	submitting_agency_code	 varchar(4),
 	awarding_agency_id  smallint,
 	oaisis_awarding_agency_desc	 varchar(50),
 	awarding_agency_code	 varchar(4),
 	contract_type_name varchar(40),
 	cont_type_code  varchar(2),
 	award_method_name varchar(50),
 	award_method_code varchar(3),
 	award_method_id smallint,
 	start_date date,
 	end_date date,
 	revised_start_date date,
 	revised_end_date date,
 	cif_received_date date,
 	cif_fiscal_year smallint,
 	cif_fiscal_year_id smallint,
 	tracking_number varchar(30),
 	board_award_number varchar(15),
 	oca_number varchar(10),
	version_number varchar(5),
	fms_contract_number varchar,
	contract_number varchar,
	fms_parent_contract_number varchar,
	submitting_agency_name varchar,
	submitting_agency_short_name varchar,
	awarding_agency_name varchar,
	awarding_agency_short_name varchar,
	start_date_id int,
	end_date_id int,	
	revised_start_date_id int,
	revised_end_date_id int,	
	cif_received_date_id int,
	document_agency_code varchar, 
	document_agency_name varchar, 
	document_agency_short_name varchar ,
	funding_agency_id  smallint,
	funding_agency_code varchar, 
	funding_agency_name varchar, 
	funding_agency_short_name varchar ,
	original_agreement_id bigint,
	original_master_agreement_id bigint,
	dollar_difference numeric(16,2),
  	percent_difference numeric(17,4),
  	original_or_modified varchar,
  	original_or_modified_desc varchar,
  	award_size_id smallint,
  	award_category_id smallint,
  	industry_type_id smallint,
  	document_version smallint,
  	minority_type_id smallint,
 	minority_type_name character varying,
 	is_prime_or_sub character(1),
    is_minority_vendor character(1),
    vendor_type character(2),
  	latest_flag char(1)
	
 )
 EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.pending_contracts to stdout csv"' ON SEGMENT 0 
      FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
   ENCODING 'UTF8';
   

 
 CREATE VIEW pending_contracts AS 
 	SELECT pending_contracts__0.document_code_id,pending_contracts__0.document_agency_id,pending_contracts__0.document_id,
 		pending_contracts__0.parent_document_code_id,pending_contracts__0.parent_document_agency_id,pending_contracts__0.parent_document_id,
 		pending_contracts__0.encumbrance_amount_original,pending_contracts__0.encumbrance_amount,pending_contracts__0.original_maximum_amount_original,
 		pending_contracts__0.original_maximum_amount,pending_contracts__0.revised_maximum_amount_original,pending_contracts__0.revised_maximum_amount,pending_contracts__0.registered_contract_max_amount,
 		pending_contracts__0.vendor_legal_name,pending_contracts__0.vendor_customer_code,pending_contracts__0.vendor_id,pending_contracts__0.description,
 		pending_contracts__0.submitting_agency_id,pending_contracts__0.oaisis_submitting_agency_desc,pending_contracts__0.submitting_agency_code,
 		pending_contracts__0.awarding_agency_id,pending_contracts__0.oaisis_awarding_agency_desc,pending_contracts__0.awarding_agency_code,
 		pending_contracts__0.contract_type_name,pending_contracts__0.cont_type_code,pending_contracts__0.award_method_name,pending_contracts__0.award_method_code,pending_contracts__0.award_method_id,
 		pending_contracts__0.start_date,pending_contracts__0.end_date,pending_contracts__0.revised_start_date,pending_contracts__0.revised_end_date,
 		pending_contracts__0.cif_received_date,pending_contracts__0.cif_fiscal_year,pending_contracts__0.cif_fiscal_year_id,
 		pending_contracts__0.tracking_number,pending_contracts__0.board_award_number,pending_contracts__0.oca_number,
 		pending_contracts__0.version_number,pending_contracts__0.fms_contract_number,pending_contracts__0.contract_number,pending_contracts__0.fms_parent_contract_number,
 		pending_contracts__0.submitting_agency_name,pending_contracts__0.submitting_agency_short_name,pending_contracts__0.awarding_agency_name,
 		pending_contracts__0.awarding_agency_short_name,pending_contracts__0.start_date_id,pending_contracts__0.end_date_id,
 		pending_contracts__0.revised_start_date_id,pending_contracts__0.revised_end_date_id,pending_contracts__0.cif_received_date_id,
 		pending_contracts__0.document_agency_code,pending_contracts__0.document_agency_name,pending_contracts__0.document_agency_short_name, 		
 		pending_contracts__0.funding_agency_id,pending_contracts__0.funding_agency_code,pending_contracts__0.funding_agency_name,
 		pending_contracts__0.funding_agency_short_name,pending_contracts__0.original_agreement_id,pending_contracts__0.original_master_agreement_id,pending_contracts__0.dollar_difference,
 		pending_contracts__0.percent_difference, pending_contracts__0.original_or_modified, pending_contracts__0.original_or_modified_desc, pending_contracts__0.award_size_id, 
 		pending_contracts__0.award_category_id, pending_contracts__0.industry_type_id, pending_contracts__0.document_version,	
 		pending_contracts__0.minority_type_id, pending_contracts__0.minority_type_name, 
 		pending_contracts__0.is_prime_or_sub, pending_contracts__0.is_minority_vendor, pending_contracts__0.vendor_type, 
 		pending_contracts__0.latest_flag 		
 	FROM pending_contracts__0;
 	


CREATE EXTERNAL WEB TABLE ref_industry_type__0 (
    industry_type_id smallint ,
    industry_type_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_industry_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


CREATE VIEW ref_industry_type AS
    SELECT ref_industry_type__0.industry_type_id, ref_industry_type__0.industry_type_name, ref_industry_type__0.created_date FROM ONLY ref_industry_type__0;
    
    
  CREATE EXTERNAL WEB TABLE ref_award_size__0 (
    award_size_id smallint ,
    award_size_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_award_size to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


CREATE VIEW ref_award_size AS
    SELECT ref_award_size__0.award_size_id, ref_award_size__0.award_size_name, ref_award_size__0.created_date FROM ONLY ref_award_size__0;
    

  CREATE EXTERNAL WEB TABLE ref_award_category_industry__0 (
	award_category_industry_id smallint,
    award_category_code character varying(10),
    industry_type_id smallint,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_award_category_industry to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


CREATE VIEW ref_award_category_industry AS
    SELECT ref_award_category_industry__0.award_category_industry_id, ref_award_category_industry__0.award_category_code, ref_award_category_industry__0.industry_type_id, ref_award_category_industry__0.created_date FROM ONLY ref_award_category_industry__0;
    

CREATE EXTERNAL WEB TABLE aggregateon_budget_by_year__0
(
agency_id integer,
department_id integer,
department_code varchar,
budget_fiscal_year smallint,
budget_fiscal_year_id smallint,
object_class_id integer,
modified_budget_amount numeric(20,2),
modified_budget_amount_py numeric(20,2),
modified_budget_amount_py_1 numeric(20,2),
modified_budget_amount_py_2 numeric(20,2),
filter_type varchar(10)
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_budget_by_year to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

CREATE VIEW aggregateon_budget_by_year AS
    SELECT aggregateon_budget_by_year__0.agency_id, aggregateon_budget_by_year__0.department_id, aggregateon_budget_by_year__0.department_code, aggregateon_budget_by_year__0.budget_fiscal_year,aggregateon_budget_by_year__0.budget_fiscal_year_id, aggregateon_budget_by_year__0.object_class_id, 
    aggregateon_budget_by_year__0.modified_budget_amount, aggregateon_budget_by_year__0.modified_budget_amount_py, aggregateon_budget_by_year__0.modified_budget_amount_py_1,aggregateon_budget_by_year__0.modified_budget_amount_py_2,
    aggregateon_budget_by_year__0.filter_type
    FROM  aggregateon_budget_by_year__0;
    
CREATE EXTERNAL WEB TABLE transactions_data_by_year__0
(
year smallint,
type_of_year character(1),
domain_name varchar,
num_transactions bigint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.transactions_data_by_year to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

 CREATE VIEW transactions_data_by_year AS
    SELECT transactions_data_by_year__0.year, transactions_data_by_year__0.type_of_year, transactions_data_by_year__0.domain_name, transactions_data_by_year__0.num_transactions
    FROM  transactions_data_by_year__0;
    
    
    
-- M/WBE Aggregate Tables

 CREATE EXTERNAL WEB TABLE aggregateon_mwbe_spending_coa_entities__0 (
    department_id integer,
    agency_id smallint,
    spending_category_id smallint,
    expenditure_object_id integer,
    vendor_id integer,
    minority_type_id smallint,
	industry_type_id smallint,
    month_id int,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric,
    total_disbursements integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_spending_coa_entities to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


CREATE VIEW aggregateon_mwbe_spending_coa_entities AS
    SELECT aggregateon_mwbe_spending_coa_entities__0.department_id, aggregateon_mwbe_spending_coa_entities__0.agency_id, aggregateon_mwbe_spending_coa_entities__0.spending_category_id, 
    	aggregateon_mwbe_spending_coa_entities__0.expenditure_object_id, aggregateon_mwbe_spending_coa_entities__0.vendor_id,
    	aggregateon_mwbe_spending_coa_entities__0.minority_type_id, aggregateon_mwbe_spending_coa_entities__0.industry_type_id, 
    	aggregateon_mwbe_spending_coa_entities__0.month_id, aggregateon_mwbe_spending_coa_entities__0.year_id, 
    	aggregateon_mwbe_spending_coa_entities__0.type_of_year, 	aggregateon_mwbe_spending_coa_entities__0.total_spending_amount,aggregateon_mwbe_spending_coa_entities__0.total_disbursements FROM ONLY aggregateon_mwbe_spending_coa_entities__0;



CREATE EXTERNAL WEB TABLE aggregateon_mwbe_spending_contract__0 (
    agreement_id bigint,
    document_id character varying,
    document_code character varying,
    vendor_id integer,
    minority_type_id smallint,
	industry_type_id smallint,
    agency_id smallint,
    description character varying,
    spending_category_id smallint,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric,
    total_contract_amount numeric
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_spending_contract to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';



CREATE VIEW aggregateon_mwbe_spending_contract AS
    SELECT aggregateon_mwbe_spending_contract__0.agreement_id, aggregateon_mwbe_spending_contract__0.document_id, aggregateon_mwbe_spending_contract__0.document_code,aggregateon_mwbe_spending_contract__0.vendor_id, 
    aggregateon_mwbe_spending_contract__0.minority_type_id, aggregateon_mwbe_spending_contract__0.industry_type_id,
    aggregateon_mwbe_spending_contract__0.agency_id, aggregateon_mwbe_spending_contract__0.description, aggregateon_mwbe_spending_contract__0.spending_category_id, aggregateon_mwbe_spending_contract__0.year_id,aggregateon_mwbe_spending_contract__0.type_of_year, 
    aggregateon_mwbe_spending_contract__0.total_spending_amount, aggregateon_mwbe_spending_contract__0.total_contract_amount FROM ONLY aggregateon_mwbe_spending_contract__0;




CREATE EXTERNAL WEB TABLE aggregateon_mwbe_spending_vendor__0 (
    vendor_id integer,
    minority_type_id smallint,
	industry_type_id smallint,
    agency_id smallint,
    spending_category_id smallint,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric,
    total_contract_amount numeric,
    is_all_categories char(1)
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_spending_vendor to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


CREATE VIEW aggregateon_mwbe_spending_vendor AS
    SELECT aggregateon_mwbe_spending_vendor__0.vendor_id, 
    aggregateon_mwbe_spending_vendor__0.minority_type_id, aggregateon_mwbe_spending_vendor__0.industry_type_id,
    aggregateon_mwbe_spending_vendor__0.agency_id, aggregateon_mwbe_spending_vendor__0.spending_category_id, aggregateon_mwbe_spending_vendor__0.year_id,
    aggregateon_mwbe_spending_vendor__0.type_of_year, aggregateon_mwbe_spending_vendor__0.total_spending_amount, aggregateon_mwbe_spending_vendor__0.total_contract_amount, aggregateon_mwbe_spending_vendor__0.is_all_categories FROM ONLY aggregateon_mwbe_spending_vendor__0;





CREATE EXTERNAL WEB TABLE aggregateon_mwbe_spending_vendor_exp_object__0(
	vendor_id integer,
	minority_type_id smallint,
	industry_type_id smallint,
	expenditure_object_id integer,
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2) 
)
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_spending_vendor_exp_object to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';

CREATE VIEW aggregateon_mwbe_spending_vendor_exp_object AS
	SELECT aggregateon_mwbe_spending_vendor_exp_object__0.vendor_id, 
	aggregateon_mwbe_spending_vendor_exp_object__0.minority_type_id, aggregateon_mwbe_spending_vendor_exp_object__0.industry_type_id,
	aggregateon_mwbe_spending_vendor_exp_object__0.expenditure_object_id, aggregateon_mwbe_spending_vendor_exp_object__0.spending_category_id,
		aggregateon_mwbe_spending_vendor_exp_object__0.year_id ,aggregateon_mwbe_spending_vendor_exp_object__0.type_of_year ,
		aggregateon_mwbe_spending_vendor_exp_object__0.total_spending_amount FROM aggregateon_mwbe_spending_vendor_exp_object__0;
		
		



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
  		aggregateon_mwbe_contracts_cumulative_spending__0.status_flag,aggregateon_mwbe_contracts_cumulative_spending__0.type_of_year
  	FROM 	  aggregateon_mwbe_contracts_cumulative_spending__0;
 
 
 

 	
  CREATE EXTERNAL WEB TABLE aggregateon_mwbe_contracts_spending_by_month__0
  (
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	month_id integer,
	vendor_id int,
	minority_type_id smallint,
	award_method_id smallint,
	agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	spending_amount numeric(16,2),
	status_flag char(1),
	type_of_year char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_contracts_spending_by_month to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW aggregateon_mwbe_contracts_spending_by_month AS
  	SELECT aggregateon_mwbe_contracts_spending_by_month__0.original_agreement_id,aggregateon_mwbe_contracts_spending_by_month__0.fiscal_year,aggregateon_mwbe_contracts_spending_by_month__0.fiscal_year_id,
  		aggregateon_mwbe_contracts_spending_by_month__0.document_code_id,aggregateon_mwbe_contracts_spending_by_month__0.month_id,
  		aggregateon_mwbe_contracts_spending_by_month__0.vendor_id,aggregateon_mwbe_contracts_spending_by_month__0.minority_type_id,aggregateon_mwbe_contracts_spending_by_month__0.award_method_id,
  		aggregateon_mwbe_contracts_spending_by_month__0.agency_id,aggregateon_mwbe_contracts_spending_by_month__0.industry_type_id, aggregateon_mwbe_contracts_spending_by_month__0.award_size_id,
  		aggregateon_mwbe_contracts_spending_by_month__0.spending_amount,	aggregateon_mwbe_contracts_spending_by_month__0.status_flag,aggregateon_mwbe_contracts_spending_by_month__0.type_of_year
  	FROM  aggregateon_mwbe_contracts_spending_by_month__0;
 
 
 

 	
 CREATE EXTERNAL WEB TABLE aggregateon_mwbe_total_contracts__0
(
	fiscal_year smallint,
	fiscal_year_id smallint,
	vendor_id int,
	minority_type_id smallint,
	award_method_id smallint,
	agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	total_contracts bigint,
	total_commited_contracts bigint,
	total_master_agreements bigint,
	total_standalone_contracts bigint,
	total_revenue_contracts bigint,
	total_revenue_contracts_amount numeric(16,2),
	total_commited_contracts_amount numeric(16,2),
	total_contracts_amount numeric(16,2),
	total_spending_amount_disb numeric(16,2), 
	total_spending_amount numeric(16,2),
	status_flag char(1),
	type_of_year char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_total_contracts to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
 
 

 
  CREATE VIEW aggregateon_mwbe_total_contracts AS
  	SELECT aggregateon_mwbe_total_contracts__0.fiscal_year,aggregateon_mwbe_total_contracts__0.fiscal_year_id,aggregateon_mwbe_total_contracts__0.vendor_id, aggregateon_mwbe_total_contracts__0.minority_type_id,
  	aggregateon_mwbe_total_contracts__0.award_method_id,  	aggregateon_mwbe_total_contracts__0.agency_id, aggregateon_mwbe_total_contracts__0.industry_type_id, aggregateon_mwbe_total_contracts__0.award_size_id,
  	aggregateon_mwbe_total_contracts__0.total_contracts,aggregateon_mwbe_total_contracts__0.total_commited_contracts,	aggregateon_mwbe_total_contracts__0.total_master_agreements,
  	aggregateon_mwbe_total_contracts__0.total_standalone_contracts,aggregateon_mwbe_total_contracts__0.total_revenue_contracts,aggregateon_mwbe_total_contracts__0.total_revenue_contracts_amount,
  	aggregateon_mwbe_total_contracts__0.total_commited_contracts_amount,aggregateon_mwbe_total_contracts__0.total_contracts_amount,aggregateon_mwbe_total_contracts__0.total_spending_amount_disb,
  	aggregateon_mwbe_total_contracts__0.total_spending_amount,aggregateon_mwbe_total_contracts__0.status_flag,aggregateon_mwbe_total_contracts__0.type_of_year
  	FROM   aggregateon_mwbe_total_contracts__0;
 
  	


 CREATE EXTERNAL WEB TABLE aggregateon_mwbe_contracts_department__0(
 	document_code_id smallint,
 	document_agency_id smallint,
	agency_id smallint,
	department_id integer,
	fiscal_year smallint,
	fiscal_year_id smallint,
	award_method_id smallint,
	vendor_id int,
	minority_type_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	total_contracts integer,
	status_flag char(1),
	type_of_year char(1)
) 	
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_mwbe_contracts_department to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  


  CREATE VIEW aggregateon_mwbe_contracts_department AS
  	SELECT aggregateon_mwbe_contracts_department__0.document_code_id,aggregateon_mwbe_contracts_department__0.document_agency_id,aggregateon_mwbe_contracts_department__0.agency_id,aggregateon_mwbe_contracts_department__0.department_id,aggregateon_mwbe_contracts_department__0.fiscal_year,
  	aggregateon_mwbe_contracts_department__0.fiscal_year_id,aggregateon_mwbe_contracts_department__0.award_method_id,aggregateon_mwbe_contracts_department__0.vendor_id,
  	aggregateon_mwbe_contracts_department__0.minority_type_id,aggregateon_mwbe_contracts_department__0.industry_type_id, aggregateon_mwbe_contracts_department__0.award_size_id,
  	aggregateon_mwbe_contracts_department__0.spending_amount_disb,aggregateon_mwbe_contracts_department__0.spending_amount,aggregateon_mwbe_contracts_department__0.total_contracts,aggregateon_mwbe_contracts_department__0.status_flag,aggregateon_mwbe_contracts_department__0.type_of_year
  	FROM   aggregateon_mwbe_contracts_department__0;
  	
  	
  	

	
   CREATE EXTERNAL WEB TABLE contracts_mwbe_spending_transactions__0(
 	disbursement_line_item_id bigint,
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	vendor_id int,
	minority_type_id smallint,
	award_method_id smallint,
	document_agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	disb_document_id  character varying(20),
	disb_vendor_name  character varying,
	disb_check_eft_issued_date  date,
	disb_agency_name  character varying(100),
	disb_department_short_name  character varying(15),
	disb_check_amount  numeric(16,2),
	disb_expenditure_object_name  character varying(40),
	disb_budget_name  character varying(60),
	disb_contract_number  character varying,
	disb_purpose  character varying,
	disb_reporting_code  character varying(15),
	disb_spending_category_name  character varying,
	disb_agency_id  smallint,
	disb_vendor_id  integer,
	disb_expenditure_object_id  integer,
	disb_department_id  integer,
	disb_spending_category_id  smallint,
	disb_agreement_id  bigint,
	disb_contract_document_code  character varying(8),
	disb_master_agreement_id  bigint,
	disb_fiscal_year_id  smallint,
	disb_check_eft_issued_cal_month_id integer,
	disb_disbursement_number character varying(40),
	disb_minority_type_id smallint,
	disb_minority_type_name character varying(50),
	disb_vendor_type character(2),
	status_flag char(1),
	type_of_year char(1)
) 	
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.contracts_mwbe_spending_transactions to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  

  CREATE VIEW contracts_mwbe_spending_transactions AS
  	SELECT contracts_mwbe_spending_transactions__0.disbursement_line_item_id,contracts_mwbe_spending_transactions__0.original_agreement_id,contracts_mwbe_spending_transactions__0.fiscal_year,
  	contracts_mwbe_spending_transactions__0.fiscal_year_id,contracts_mwbe_spending_transactions__0.document_code_id, contracts_mwbe_spending_transactions__0.vendor_id, contracts_mwbe_spending_transactions__0.minority_type_id,
  	contracts_mwbe_spending_transactions__0.award_method_id, contracts_mwbe_spending_transactions__0.document_agency_id, contracts_mwbe_spending_transactions__0.industry_type_id, contracts_mwbe_spending_transactions__0.award_size_id,
  	contracts_mwbe_spending_transactions__0.disb_document_id,contracts_mwbe_spending_transactions__0.disb_vendor_name,contracts_mwbe_spending_transactions__0.disb_check_eft_issued_date,contracts_mwbe_spending_transactions__0.disb_agency_name,
  	contracts_mwbe_spending_transactions__0.disb_department_short_name,contracts_mwbe_spending_transactions__0.disb_check_amount,contracts_mwbe_spending_transactions__0.disb_expenditure_object_name,
  	contracts_mwbe_spending_transactions__0.disb_budget_name,contracts_mwbe_spending_transactions__0.disb_contract_number,contracts_mwbe_spending_transactions__0.disb_purpose,contracts_mwbe_spending_transactions__0.disb_reporting_code,
  	contracts_mwbe_spending_transactions__0.disb_spending_category_name,contracts_mwbe_spending_transactions__0.disb_agency_id,contracts_mwbe_spending_transactions__0.disb_vendor_id,contracts_mwbe_spending_transactions__0.disb_expenditure_object_id,
  	contracts_mwbe_spending_transactions__0.disb_department_id,contracts_mwbe_spending_transactions__0.disb_spending_category_id,contracts_mwbe_spending_transactions__0.disb_agreement_id,contracts_mwbe_spending_transactions__0.disb_contract_document_code,
  	contracts_mwbe_spending_transactions__0.disb_master_agreement_id,contracts_mwbe_spending_transactions__0.disb_fiscal_year_id,contracts_mwbe_spending_transactions__0.disb_check_eft_issued_cal_month_id,contracts_mwbe_spending_transactions__0.disb_disbursement_number,
  	contracts_mwbe_spending_transactions__0.disb_minority_type_id,contracts_mwbe_spending_transactions__0.disb_minority_type_name,contracts_mwbe_spending_transactions__0.disb_vendor_type,
  	contracts_mwbe_spending_transactions__0.status_flag,contracts_mwbe_spending_transactions__0.type_of_year
  	FROM   contracts_mwbe_spending_transactions__0;	
  	


CREATE EXTERNAL WEB TABLE contract_vendor_latest_mwbe_category__0 (
	vendor_id integer,
	vendor_history_id integer,
	agency_id smallint,
	minority_type_id smallint,
	is_prime_or_sub character(1),
	year_id smallint,
	type_of_year char(1)
	) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.contract_vendor_latest_mwbe_category to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
	
  CREATE VIEW contract_vendor_latest_mwbe_category AS
  	SELECT contract_vendor_latest_mwbe_category__0.vendor_id,contract_vendor_latest_mwbe_category__0.vendor_history_id,
  	contract_vendor_latest_mwbe_category__0.agency_id,contract_vendor_latest_mwbe_category__0.minority_type_id,contract_vendor_latest_mwbe_category__0.is_prime_or_sub,
  	contract_vendor_latest_mwbe_category__0.year_id, contract_vendor_latest_mwbe_category__0.type_of_year
  	FROM   contract_vendor_latest_mwbe_category__0;	
  	
  	


CREATE EXTERNAL WEB TABLE spending_vendor_latest_mwbe_category__0 (
	vendor_id integer,
	vendor_history_id integer,
	agency_id smallint,
	minority_type_id smallint,
	is_prime_or_sub character(1),
	year_id smallint,
	type_of_year char(1)
	) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.spending_vendor_latest_mwbe_category to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
 	

 CREATE VIEW spending_vendor_latest_mwbe_category AS
  	SELECT spending_vendor_latest_mwbe_category__0.vendor_id,spending_vendor_latest_mwbe_category__0.vendor_history_id,
  	spending_vendor_latest_mwbe_category__0.agency_id,spending_vendor_latest_mwbe_category__0.minority_type_id, spending_vendor_latest_mwbe_category__0.is_prime_or_sub,
  	spending_vendor_latest_mwbe_category__0.year_id, spending_vendor_latest_mwbe_category__0.type_of_year
  	FROM   spending_vendor_latest_mwbe_category__0;
  	
-- Sub Vendor Domain
  	

CREATE EXTERNAL WEB TABLE subcontract_vendor_business_type__0 (
	vendor_customer_code character varying,
	business_type_id smallint,
	status smallint,
    minority_type_id smallint,
    certification_start_date date,
    certification_end_date date, 
    initiation_date date,
    certification_no character varying(30),
    disp_certification_start_date date
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_vendor_business_type to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  

CREATE VIEW subcontract_vendor_business_type AS
    SELECT subcontract_vendor_business_type__0.vendor_customer_code, subcontract_vendor_business_type__0.business_type_id, subcontract_vendor_business_type__0.status, subcontract_vendor_business_type__0.minority_type_id,  
    subcontract_vendor_business_type__0.certification_start_date, subcontract_vendor_business_type__0.certification_end_date, subcontract_vendor_business_type__0.initiation_date, subcontract_vendor_business_type__0.certification_no, subcontract_vendor_business_type__0.disp_certification_start_date 
    FROM ONLY subcontract_vendor_business_type__0;
 
    


CREATE EXTERNAL WEB TABLE subcontract_business_type__0 (
    contract_number varchar,
    subcontract_id character varying,
	prime_vendor_customer_code character varying,
	vendor_customer_code character varying,
	business_type_id smallint,
	status smallint,
    minority_type_id smallint,
    certification_start_date date,
    certification_end_date date, 
    initiation_date date,
    certification_no character varying,
    disp_certification_start_date date,
    load_id integer,
    created_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_business_type to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  

  CREATE VIEW subcontract_business_type AS
    SELECT subcontract_business_type__0.contract_number, subcontract_business_type__0.subcontract_id, subcontract_business_type__0.prime_vendor_customer_code, subcontract_business_type__0.vendor_customer_code,  
    subcontract_business_type__0.business_type_id, subcontract_business_type__0.status, subcontract_business_type__0.minority_type_id, subcontract_business_type__0.certification_start_date, 
    subcontract_business_type__0.certification_end_date, subcontract_business_type__0.initiation_date, subcontract_business_type__0.certification_no, subcontract_business_type__0.disp_certification_start_date,
    subcontract_business_type__0.load_id,subcontract_business_type__0.created_date
    FROM ONLY subcontract_business_type__0;
    



CREATE EXTERNAL WEB TABLE subvendor__0 (
    vendor_id integer ,
    vendor_customer_code character varying,
    legal_name character varying,
    display_flag CHAR(1) ,
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subvendor to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';

  
CREATE VIEW subvendor AS
    SELECT subvendor__0.vendor_id, subvendor__0.vendor_customer_code, subvendor__0.legal_name, 
    subvendor__0.display_flag, subvendor__0.created_load_id, subvendor__0.updated_load_id, subvendor__0.created_date, subvendor__0.updated_date 
    FROM ONLY subvendor__0;
 
    


CREATE EXTERNAL WEB TABLE subvendor_history__0 (
    vendor_history_id integer,
    vendor_id integer,   
    legal_name character varying,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subvendor_history to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  CREATE VIEW subvendor_history AS
    SELECT subvendor_history__0.vendor_history_id, subvendor_history__0.vendor_id, subvendor_history__0.legal_name,  
    subvendor_history__0.load_id, subvendor_history__0.created_date, subvendor_history__0.updated_date 
    FROM ONLY subvendor_history__0;

    


CREATE EXTERNAL WEB TABLE subvendor_business_type__0 (
    vendor_business_type_id bigint ,
    vendor_history_id integer,
    business_type_id smallint,
    status smallint,
    minority_type_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subvendor_business_type to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


CREATE VIEW subvendor_business_type AS
    SELECT subvendor_business_type__0.vendor_business_type_id, subvendor_business_type__0.vendor_history_id, subvendor_business_type__0.business_type_id, subvendor_business_type__0.status, 
    subvendor_business_type__0.minority_type_id, subvendor_business_type__0.load_id, subvendor_business_type__0.created_date, subvendor_business_type__0.updated_date 
    FROM ONLY subvendor_business_type__0;

    


CREATE EXTERNAL WEB TABLE subvendor_min_bus_type__0
( vendor_id integer,
  vendor_history_id integer,
  business_type_id smallint,
  minority_type_id smallint,
  business_type_code character varying(4),
  business_type_name character varying,
  minority_type_name character varying
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subvendor_min_bus_type to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


CREATE VIEW subvendor_min_bus_type AS
    SELECT subvendor_min_bus_type__0.vendor_id, subvendor_min_bus_type__0.vendor_history_id, subvendor_min_bus_type__0.business_type_id, subvendor_min_bus_type__0.minority_type_id, 
    subvendor_min_bus_type__0.business_type_code, subvendor_min_bus_type__0.business_type_name, subvendor_min_bus_type__0.minority_type_name
    FROM ONLY subvendor_min_bus_type__0;
    
    


CREATE EXTERNAL WEB TABLE subcontract_status__0 (
    contract_number varchar,
	vendor_customer_code character varying, 
	scntrc_status smallint, 
	agreement_type_id smallint, 
	total_scntrc_max_am numeric(16,2),
	total_scntrc_pymt_am numeric(16,2),
    created_load_id integer,
    created_date timestamp without time zone,
    updated_load_id integer,
    updated_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_status to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  
CREATE VIEW subcontract_status AS
    SELECT subcontract_status__0.contract_number, subcontract_status__0.vendor_customer_code, subcontract_status__0.scntrc_status, subcontract_status__0.agreement_type_id,
    subcontract_status__0.total_scntrc_max_am, subcontract_status__0.total_scntrc_pymt_am, subcontract_status__0.created_load_id, 
    subcontract_status__0.created_date, subcontract_status__0.updated_load_id, subcontract_status__0.updated_date
    FROM ONLY subcontract_status__0;
    
    


CREATE  EXTERNAL WEB TABLE subcontract_details__0
(
  agreement_id bigint ,
  contract_number varchar,
  sub_contract_id character varying,
  agency_history_id smallint,
  document_id character varying,
  document_code_id smallint,
  document_version integer,
  vendor_history_id integer,
  prime_vendor_id integer,
  agreement_type_id smallint,  
  aprv_sta smallint,
  aprv_reas_id character varying(3),
  aprv_reas_nm character varying,
  description character varying,
  is_mwbe_cert smallint,
  industry_type_id smallint,
  effective_begin_date_id integer,
  effective_end_date_id integer,
  registered_date_id integer,
  source_updated_date_id integer,
  maximum_contract_amount_original numeric(16,2),
  maximum_contract_amount  numeric(16,2),
  original_contract_amount_original numeric(16,2),
  original_contract_amount numeric(16,2),
  rfed_amount_original numeric(16,2), 
  rfed_amount numeric(16,2),
  total_scntrc_pymt numeric(16,2),
  is_scntrc_pymt_complete smallint,
  scntrc_mode smallint,
  tracking_number character varying,
  award_method_id smallint,
  award_category_id smallint,
  brd_awd_no character varying,
  number_responses integer,
  number_solicitation integer,
  doc_ref character varying,
  registered_fiscal_year smallint,
  registered_fiscal_year_id smallint,
  registered_calendar_year smallint,
  registered_calendar_year_id smallint,
  effective_end_fiscal_year smallint,
  effective_end_fiscal_year_id smallint,
  effective_end_calendar_year smallint,
  effective_end_calendar_year_id smallint,
  effective_begin_fiscal_year smallint,
  effective_begin_fiscal_year_id smallint,
  effective_begin_calendar_year smallint,
  effective_begin_calendar_year_id smallint,
  source_updated_fiscal_year smallint,
  source_updated_fiscal_year_id smallint,
  source_updated_calendar_year smallint,
  source_updated_calendar_year_id smallint,
  original_agreement_id bigint,
  original_version_flag character(1),
  master_agreement_id bigint,  
  latest_flag character(1),
  privacy_flag character(1),
  created_load_id integer,
  updated_load_id integer,
  created_date timestamp without time zone,
  updated_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_details to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  
CREATE VIEW subcontract_details AS
    SELECT subcontract_details__0.agreement_id, subcontract_details__0.contract_number, subcontract_details__0.sub_contract_id, subcontract_details__0.agency_history_id, 
     subcontract_details__0.document_id, subcontract_details__0.document_code_id, subcontract_details__0.document_version,     subcontract_details__0.vendor_history_id, 
     subcontract_details__0.prime_vendor_id,    subcontract_details__0.agreement_type_id, subcontract_details__0.aprv_sta,      subcontract_details__0.aprv_reas_id, 
     subcontract_details__0.aprv_reas_nm, subcontract_details__0.description,  subcontract_details__0.is_mwbe_cert, subcontract_details__0.industry_type_id, 
     subcontract_details__0.effective_begin_date_id, subcontract_details__0.effective_end_date_id, subcontract_details__0.registered_date_id,
     subcontract_details__0.source_updated_date_id,     subcontract_details__0.maximum_contract_amount_original, subcontract_details__0.maximum_contract_amount,  
     subcontract_details__0.original_contract_amount_original, subcontract_details__0.original_contract_amount,     subcontract_details__0.rfed_amount_original,
     subcontract_details__0.rfed_amount, subcontract_details__0.total_scntrc_pymt,subcontract_details__0.is_scntrc_pymt_complete,     subcontract_details__0.scntrc_mode, 
     subcontract_details__0.tracking_number,    subcontract_details__0.award_method_id,    subcontract_details__0.award_category_id, subcontract_details__0.brd_awd_no, 
     subcontract_details__0.number_responses,     subcontract_details__0.number_solicitation, subcontract_details__0.doc_ref, 
    subcontract_details__0.registered_fiscal_year, subcontract_details__0.registered_fiscal_year_id, subcontract_details__0.registered_calendar_year, 
    subcontract_details__0.registered_calendar_year_id,    subcontract_details__0.effective_end_fiscal_year, subcontract_details__0.effective_end_fiscal_year_id, 
    subcontract_details__0.effective_end_calendar_year, subcontract_details__0.effective_end_calendar_year_id,    subcontract_details__0.effective_begin_fiscal_year, 
    subcontract_details__0.effective_begin_fiscal_year_id, subcontract_details__0.effective_begin_calendar_year, subcontract_details__0.effective_begin_calendar_year_id,
    subcontract_details__0.source_updated_fiscal_year, subcontract_details__0.source_updated_fiscal_year_id, subcontract_details__0.source_updated_calendar_year, 
    subcontract_details__0.source_updated_calendar_year_id,    subcontract_details__0.original_agreement_id, subcontract_details__0.original_version_flag, 
    subcontract_details__0.master_agreement_id, subcontract_details__0.latest_flag,    subcontract_details__0.privacy_flag, subcontract_details__0.created_load_id, 
    subcontract_details__0.updated_load_id, subcontract_details__0.created_date,    subcontract_details__0.updated_date
    FROM ONLY subcontract_details__0;
    
    


CREATE EXTERNAL WEB TABLE subcontract_spending__0 (
    disbursement_line_item_id bigint ,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying,
    document_version integer,
    payment_id character varying,
    disbursement_number character varying,
    check_eft_amount_original numeric(16,2),
    check_eft_amount numeric(16,2),
    check_eft_issued_date_id int,
    check_eft_issued_nyc_year_id smallint,
    payment_description character varying,
    payment_proof character varying,
    is_final_payment varchar(3),
    doc_ref character varying,
    contract_number varchar,
  	sub_contract_id character varying,
    agreement_id bigint,
    vendor_history_id integer,
    prime_vendor_id integer,     
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_spending to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


CREATE VIEW subcontract_spending AS
    SELECT subcontract_spending__0.disbursement_line_item_id, subcontract_spending__0.document_code_id,subcontract_spending__0.agency_history_id,
    subcontract_spending__0.document_id,subcontract_spending__0.document_version, subcontract_spending__0.payment_id,
    subcontract_spending__0.disbursement_number, subcontract_spending__0.check_eft_amount_original, subcontract_spending__0.check_eft_amount,  
    subcontract_spending__0.check_eft_issued_date_id,subcontract_spending__0.check_eft_issued_nyc_year_id,subcontract_spending__0.payment_description,
    subcontract_spending__0.payment_proof,subcontract_spending__0.is_final_payment,subcontract_spending__0.doc_ref,
    subcontract_spending__0.contract_number,subcontract_spending__0.sub_contract_id,subcontract_spending__0.agreement_id,
    subcontract_spending__0.vendor_history_id,subcontract_spending__0.prime_vendor_id,
    subcontract_spending__0.created_load_id,subcontract_spending__0.updated_load_id,
    subcontract_spending__0.created_date, subcontract_spending__0.updated_date  
    FROM ONLY subcontract_spending__0;





CREATE EXTERNAL WEB TABLE sub_agreement_snapshot__0
 (
   original_agreement_id bigint,
   document_version smallint,
   document_code_id smallint,
   agency_history_id smallint,
   agency_id smallint,
   agency_code character varying,
   agency_name character varying,
   agreement_id bigint,
   starting_year smallint,
   starting_year_id smallint,
   ending_year smallint,
   ending_year_id smallint,
   registered_year smallint,
   registered_year_id smallint,
   contract_number character varying,
   sub_contract_id character varying,
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying,
   vendor_name character varying,
   prime_vendor_id integer,
   prime_minority_type_id smallint,
   prime_minority_type_name character varying(50),
   dollar_difference numeric(16,2),
   percent_difference numeric(17,4),
   agreement_type_id smallint,
   agreement_type_code character varying(2),
   agreement_type_name character varying,
   award_category_id smallint,
   award_category_code character varying,
   award_category_name character varying,
   award_method_id smallint,
   award_method_code character varying ,
   award_method_name character varying,
   expenditure_object_codes character varying,
   expenditure_object_names character varying,
   industry_type_id smallint,
   industry_type_name character varying,
   award_size_id smallint,
   effective_begin_date date,
   effective_begin_date_id integer,
   effective_begin_year smallint,
   effective_begin_year_id smallint,
   effective_end_date date,
   effective_end_date_id integer,
   effective_end_year smallint,
   effective_end_year_id smallint,
   registered_date date,
   registered_date_id integer,
   brd_awd_no character varying,
   tracking_number character varying,
   rfed_amount numeric(16,2),
   minority_type_id smallint,
   minority_type_name character varying,
   original_version_flag character(1),
   master_agreement_id bigint,  
   master_contract_number character varying,
   latest_flag character(1),
   load_id integer,
   last_modified_date timestamp without time zone,
   job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.sub_agreement_snapshot to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
 
  CREATE VIEW sub_agreement_snapshot AS
  	SELECT sub_agreement_snapshot__0.original_agreement_id,sub_agreement_snapshot__0.document_version,sub_agreement_snapshot__0.document_code_id,
  		sub_agreement_snapshot__0.agency_history_id,sub_agreement_snapshot__0.agency_id,sub_agreement_snapshot__0.agency_code,sub_agreement_snapshot__0.agency_name,
  		sub_agreement_snapshot__0.agreement_id,sub_agreement_snapshot__0.starting_year,sub_agreement_snapshot__0.starting_year_id,sub_agreement_snapshot__0.ending_year,
  		sub_agreement_snapshot__0.ending_year_id,sub_agreement_snapshot__0.registered_year,sub_agreement_snapshot__0.registered_year_id,sub_agreement_snapshot__0.contract_number,
  		sub_agreement_snapshot__0.sub_contract_id,sub_agreement_snapshot__0.original_contract_amount,sub_agreement_snapshot__0.maximum_contract_amount,sub_agreement_snapshot__0.description,
  		sub_agreement_snapshot__0.vendor_history_id,sub_agreement_snapshot__0.vendor_id,sub_agreement_snapshot__0.vendor_code,sub_agreement_snapshot__0.vendor_name,sub_agreement_snapshot__0.prime_vendor_id,
  		sub_agreement_snapshot__0.prime_minority_type_id,sub_agreement_snapshot__0.prime_minority_type_name,sub_agreement_snapshot__0.dollar_difference,sub_agreement_snapshot__0.percent_difference,
  		sub_agreement_snapshot__0.agreement_type_id,sub_agreement_snapshot__0.agreement_type_code,sub_agreement_snapshot__0.agreement_type_name,sub_agreement_snapshot__0.award_category_id,sub_agreement_snapshot__0.award_category_code,
  		sub_agreement_snapshot__0.award_category_name,sub_agreement_snapshot__0.award_method_id,sub_agreement_snapshot__0.award_method_code,sub_agreement_snapshot__0.award_method_name,
  		sub_agreement_snapshot__0.expenditure_object_codes,sub_agreement_snapshot__0.expenditure_object_names,sub_agreement_snapshot__0.industry_type_id,sub_agreement_snapshot__0.industry_type_name,sub_agreement_snapshot__0.award_size_id,
  		sub_agreement_snapshot__0.effective_begin_date,sub_agreement_snapshot__0.effective_begin_date_id,
  		sub_agreement_snapshot__0.effective_begin_year,sub_agreement_snapshot__0.effective_begin_year_id,sub_agreement_snapshot__0.effective_end_date,
  		sub_agreement_snapshot__0.effective_end_date_id,sub_agreement_snapshot__0.effective_end_year,sub_agreement_snapshot__0.effective_end_year_id,
  		sub_agreement_snapshot__0.registered_date,sub_agreement_snapshot__0.registered_date_id,sub_agreement_snapshot__0.brd_awd_no,sub_agreement_snapshot__0.tracking_number,sub_agreement_snapshot__0.rfed_amount,
  		sub_agreement_snapshot__0.minority_type_id,sub_agreement_snapshot__0.minority_type_name,
  		sub_agreement_snapshot__0.original_version_flag,sub_agreement_snapshot__0.master_agreement_id,
  		sub_agreement_snapshot__0.master_contract_number,sub_agreement_snapshot__0.latest_flag,
  		sub_agreement_snapshot__0.load_id,sub_agreement_snapshot__0.last_modified_date,sub_agreement_snapshot__0.job_id
  	FROM  sub_agreement_snapshot__0;
  	
  	
  

 
CREATE EXTERNAL WEB TABLE sub_agreement_snapshot_cy__0
 (
   original_agreement_id bigint,
   document_version smallint,
   document_code_id smallint,
   agency_history_id smallint,
   agency_id smallint,
   agency_code character varying,
   agency_name character varying,
   agreement_id bigint,
   starting_year smallint,
   starting_year_id smallint,
   ending_year smallint,
   ending_year_id smallint,
   registered_year smallint,
   registered_year_id smallint,
   contract_number character varying,
   sub_contract_id character varying,
   original_contract_amount numeric(16,2),
   maximum_contract_amount numeric(16,2),
   description character varying,
   vendor_history_id integer,
   vendor_id integer,
   vendor_code character varying,
   vendor_name character varying,
   prime_vendor_id integer,
   prime_minority_type_id smallint,
   prime_minority_type_name character varying(50),
   dollar_difference numeric(16,2),
   percent_difference numeric(17,4),
   agreement_type_id smallint,
   agreement_type_code character varying(2),
   agreement_type_name character varying,
   award_category_id smallint,
   award_category_code character varying,
   award_category_name character varying,
   award_method_id smallint,
   award_method_code character varying ,
   award_method_name character varying,
   expenditure_object_codes character varying,
   expenditure_object_names character varying,
   industry_type_id smallint,
   industry_type_name character varying,
   award_size_id smallint,
   effective_begin_date date,
   effective_begin_date_id integer,
   effective_begin_year smallint,
   effective_begin_year_id smallint,
   effective_end_date date,
   effective_end_date_id integer,
   effective_end_year smallint,
   effective_end_year_id smallint,
   registered_date date,
   registered_date_id integer,
   brd_awd_no character varying,
   tracking_number character varying,
   rfed_amount numeric(16,2),
   minority_type_id smallint,
   minority_type_name character varying,
   original_version_flag character(1),
   master_agreement_id bigint,  
   master_contract_number character varying,
   latest_flag character(1),
   load_id integer,
   last_modified_date timestamp without time zone,
   job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.sub_agreement_snapshot_cy to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
 
  CREATE VIEW sub_agreement_snapshot_cy AS
  	SELECT sub_agreement_snapshot_cy__0.original_agreement_id,sub_agreement_snapshot_cy__0.document_version,sub_agreement_snapshot_cy__0.document_code_id,
  		sub_agreement_snapshot_cy__0.agency_history_id,sub_agreement_snapshot_cy__0.agency_id,sub_agreement_snapshot_cy__0.agency_code,sub_agreement_snapshot_cy__0.agency_name,
  		sub_agreement_snapshot_cy__0.agreement_id,sub_agreement_snapshot_cy__0.starting_year,sub_agreement_snapshot_cy__0.starting_year_id,sub_agreement_snapshot_cy__0.ending_year,
  		sub_agreement_snapshot_cy__0.ending_year_id,sub_agreement_snapshot_cy__0.registered_year,sub_agreement_snapshot_cy__0.registered_year_id,sub_agreement_snapshot_cy__0.contract_number,
  		sub_agreement_snapshot_cy__0.sub_contract_id,sub_agreement_snapshot_cy__0.original_contract_amount,sub_agreement_snapshot_cy__0.maximum_contract_amount,sub_agreement_snapshot_cy__0.description,
  		sub_agreement_snapshot_cy__0.vendor_history_id,sub_agreement_snapshot_cy__0.vendor_id,sub_agreement_snapshot_cy__0.vendor_code,sub_agreement_snapshot_cy__0.vendor_name,sub_agreement_snapshot_cy__0.prime_vendor_id,
  		sub_agreement_snapshot_cy__0.prime_minority_type_id,sub_agreement_snapshot_cy__0.prime_minority_type_name,sub_agreement_snapshot_cy__0.dollar_difference,sub_agreement_snapshot_cy__0.percent_difference,
  		sub_agreement_snapshot_cy__0.agreement_type_id,sub_agreement_snapshot_cy__0.agreement_type_code,sub_agreement_snapshot_cy__0.agreement_type_name,sub_agreement_snapshot_cy__0.award_category_id,sub_agreement_snapshot_cy__0.award_category_code,
  		sub_agreement_snapshot_cy__0.award_category_name,sub_agreement_snapshot_cy__0.award_method_id,sub_agreement_snapshot_cy__0.award_method_code,sub_agreement_snapshot_cy__0.award_method_name,
   		sub_agreement_snapshot_cy__0.expenditure_object_codes,sub_agreement_snapshot_cy__0.expenditure_object_names,sub_agreement_snapshot_cy__0.industry_type_id,sub_agreement_snapshot_cy__0.industry_type_name,sub_agreement_snapshot_cy__0.award_size_id,
   		sub_agreement_snapshot_cy__0.effective_begin_date,sub_agreement_snapshot_cy__0.effective_begin_date_id,
  		sub_agreement_snapshot_cy__0.effective_begin_year,sub_agreement_snapshot_cy__0.effective_begin_year_id,sub_agreement_snapshot_cy__0.effective_end_date,
  		sub_agreement_snapshot_cy__0.effective_end_date_id,sub_agreement_snapshot_cy__0.effective_end_year,sub_agreement_snapshot_cy__0.effective_end_year_id,
  		sub_agreement_snapshot_cy__0.registered_date,sub_agreement_snapshot_cy__0.registered_date_id,sub_agreement_snapshot_cy__0.brd_awd_no,sub_agreement_snapshot_cy__0.tracking_number,sub_agreement_snapshot_cy__0.rfed_amount,
  		sub_agreement_snapshot_cy__0.minority_type_id,sub_agreement_snapshot_cy__0.minority_type_name,
  		sub_agreement_snapshot_cy__0.original_version_flag,sub_agreement_snapshot_cy__0.master_agreement_id,
  		sub_agreement_snapshot_cy__0.master_contract_number,sub_agreement_snapshot_cy__0.latest_flag,
  		sub_agreement_snapshot_cy__0.load_id,sub_agreement_snapshot_cy__0.last_modified_date,sub_agreement_snapshot_cy__0.job_id
  	FROM  sub_agreement_snapshot_cy__0; 
  	
  	

 
 CREATE EXTERNAL WEB TABLE sub_agreement_snapshot_expanded__0 (
	original_agreement_id bigint,
	agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	sub_contract_id character varying,
	vendor_id int,
	prime_vendor_id int,
	prime_minority_type_id smallint,
	agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	original_contract_amount numeric(16,2) ,
	maximum_contract_amount numeric(16,2),
	rfed_amount numeric(16,2),
	starting_year smallint,	
	ending_year smallint,
	dollar_difference numeric(16,2), 
	percent_difference numeric(17,4),
	award_method_id smallint,
	document_code_id smallint,	
	minority_type_id smallint,
 	minority_type_name character varying,
	status_flag char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.sub_agreement_snapshot_expanded to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';	

CREATE VIEW sub_agreement_snapshot_expanded AS
	 SELECT sub_agreement_snapshot_expanded__0.original_agreement_id,sub_agreement_snapshot_expanded__0.agreement_id,sub_agreement_snapshot_expanded__0.fiscal_year,sub_agreement_snapshot_expanded__0.description,
	 	sub_agreement_snapshot_expanded__0.contract_number,sub_agreement_snapshot_expanded__0.sub_contract_id,sub_agreement_snapshot_expanded__0.vendor_id,sub_agreement_snapshot_expanded__0.prime_vendor_id,
	 	sub_agreement_snapshot_expanded__0.prime_minority_type_id,sub_agreement_snapshot_expanded__0.agency_id,sub_agreement_snapshot_expanded__0.industry_type_id,sub_agreement_snapshot_expanded__0.award_size_id,
	 	sub_agreement_snapshot_expanded__0.original_contract_amount,sub_agreement_snapshot_expanded__0.maximum_contract_amount,sub_agreement_snapshot_expanded__0.rfed_amount,
	 	sub_agreement_snapshot_expanded__0.starting_year,sub_agreement_snapshot_expanded__0.ending_year,sub_agreement_snapshot_expanded__0.dollar_difference,
	 	sub_agreement_snapshot_expanded__0.percent_difference,sub_agreement_snapshot_expanded__0.award_method_id,sub_agreement_snapshot_expanded__0.document_code_id,
	 	sub_agreement_snapshot_expanded__0.minority_type_id,sub_agreement_snapshot_expanded__0.minority_type_name,
	 	sub_agreement_snapshot_expanded__0.status_flag
	 FROM 	sub_agreement_snapshot_expanded__0;
 


CREATE EXTERNAL WEB TABLE sub_agreement_snapshot_expanded_cy__0 (
	original_agreement_id bigint,
	agreement_id bigint,
	fiscal_year smallint,
	description varchar,
	contract_number varchar,
	sub_contract_id character varying,
	vendor_id int,
	prime_vendor_id int,
	prime_minority_type_id smallint,
	agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	original_contract_amount numeric(16,2) ,
	maximum_contract_amount numeric(16,2),
	rfed_amount numeric(16,2),
	starting_year smallint,	
	ending_year smallint,
	dollar_difference numeric(16,2), 
	percent_difference numeric(17,4),
	award_method_id smallint,
	document_code_id smallint,	
	minority_type_id smallint,
 	minority_type_name character varying,
	status_flag char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.sub_agreement_snapshot_expanded_cy to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';

  CREATE VIEW sub_agreement_snapshot_expanded_cy AS
  	SELECT sub_agreement_snapshot_expanded_cy__0.original_agreement_id,sub_agreement_snapshot_expanded_cy__0.agreement_id,sub_agreement_snapshot_expanded_cy__0.fiscal_year,sub_agreement_snapshot_expanded_cy__0.description,
  		sub_agreement_snapshot_expanded_cy__0.contract_number,sub_agreement_snapshot_expanded_cy__0.sub_contract_id,sub_agreement_snapshot_expanded_cy__0.vendor_id,sub_agreement_snapshot_expanded_cy__0.prime_vendor_id,
  		sub_agreement_snapshot_expanded_cy__0.prime_minority_type_id,sub_agreement_snapshot_expanded_cy__0.agency_id,sub_agreement_snapshot_expanded_cy__0.industry_type_id,sub_agreement_snapshot_expanded_cy__0.award_size_id,
  		sub_agreement_snapshot_expanded_cy__0.original_contract_amount,sub_agreement_snapshot_expanded_cy__0.maximum_contract_amount,sub_agreement_snapshot_expanded_cy__0.rfed_amount,
  		sub_agreement_snapshot_expanded_cy__0.starting_year,sub_agreement_snapshot_expanded_cy__0.ending_year,sub_agreement_snapshot_expanded_cy__0.dollar_difference,
  		sub_agreement_snapshot_expanded_cy__0.percent_difference,sub_agreement_snapshot_expanded_cy__0.award_method_id,sub_agreement_snapshot_expanded_cy__0.document_code_id,
  		sub_agreement_snapshot_expanded_cy__0.minority_type_id,sub_agreement_snapshot_expanded_cy__0.minority_type_name,
  		sub_agreement_snapshot_expanded_cy__0.status_flag
  	FROM sub_agreement_snapshot_expanded_cy__0;	
  	
  	

CREATE EXTERNAL WEB TABLE subcontract_spending_details__0 (
	disbursement_line_item_id bigint,
	disbursement_number character varying,
	payment_id character varying,
	check_eft_issued_date_id int,
	check_eft_issued_nyc_year_id smallint,
	fiscal_year smallint,
	check_eft_issued_cal_month_id int,
	agreement_id bigint,
	check_amount numeric(16,2),
	agency_id smallint,
	agency_history_id smallint,
	agency_code varchar(20),
	vendor_id integer,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
    prime_minority_type_name character varying(50),
	maximum_contract_amount numeric(16,2),
	maximum_contract_amount_cy numeric(16,2),	
	document_id varchar,
	vendor_name varchar,
	vendor_customer_code varchar, 
	check_eft_issued_date date,
	agency_name varchar,	
	agency_short_name character varying,  	
	expenditure_object_name varchar,
	expenditure_object_code varchar(4),
	contract_number character varying,
	sub_contract_id character varying,
	contract_vendor_id integer,
  	contract_vendor_id_cy integer,
	contract_prime_vendor_id integer,
  	contract_prime_vendor_id_cy integer,
  	contract_agency_id smallint,
  	contract_agency_id_cy smallint,
  	purpose varchar,
	purpose_cy character varying,
	reporting_code character varying,
	spending_category_id smallint,
	spending_category_name character varying,
	calendar_fiscal_year_id smallint,
	calendar_fiscal_year smallint,
	reference_document_number character varying,
	reference_document_code varchar(8),
	contract_document_code varchar(8),
	minority_type_id smallint,
 	minority_type_name character varying,
 	industry_type_id smallint,
   	industry_type_name character varying,
   	agreement_type_code character varying(2),
   	award_method_code character varying,
   	contract_industry_type_id smallint,
	contract_industry_type_id_cy smallint,
	contract_minority_type_id smallint,
	contract_minority_type_id_cy smallint,	
	contract_prime_minority_type_id smallint,
    contract_prime_minority_type_id_cy smallint,
	master_agreement_id bigint,  
    master_contract_number character varying,
	file_type char(1),
	load_id integer,
	last_modified_date timestamp without time zone,
	job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.subcontract_spending_details to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';

  
CREATE VIEW subcontract_spending_details AS
    SELECT subcontract_spending_details__0.disbursement_line_item_id, 
    subcontract_spending_details__0.disbursement_number, subcontract_spending_details__0.payment_id, subcontract_spending_details__0.check_eft_issued_date_id, 
    subcontract_spending_details__0.check_eft_issued_nyc_year_id, subcontract_spending_details__0.fiscal_year, subcontract_spending_details__0.check_eft_issued_cal_month_id, subcontract_spending_details__0.agreement_id,
    subcontract_spending_details__0.check_amount, subcontract_spending_details__0.agency_id,
    subcontract_spending_details__0.agency_history_id,subcontract_spending_details__0.agency_code,  subcontract_spending_details__0.vendor_id, subcontract_spending_details__0.prime_vendor_id,
    subcontract_spending_details__0.prime_minority_type_id,subcontract_spending_details__0.prime_minority_type_name,subcontract_spending_details__0.maximum_contract_amount, subcontract_spending_details__0.maximum_contract_amount_cy,
    subcontract_spending_details__0.document_id, subcontract_spending_details__0.vendor_name,subcontract_spending_details__0.vendor_customer_code, subcontract_spending_details__0.check_eft_issued_date, 
    subcontract_spending_details__0.agency_name,subcontract_spending_details__0.agency_short_name,
    subcontract_spending_details__0.expenditure_object_name,subcontract_spending_details__0.expenditure_object_code, 
    subcontract_spending_details__0.contract_number,  subcontract_spending_details__0.sub_contract_id,
    subcontract_spending_details__0.contract_vendor_id,subcontract_spending_details__0.contract_vendor_id_cy,subcontract_spending_details__0.contract_prime_vendor_id,
    subcontract_spending_details__0.contract_prime_vendor_id_cy,subcontract_spending_details__0.contract_agency_id,subcontract_spending_details__0.contract_agency_id_cy,
    subcontract_spending_details__0.purpose,subcontract_spending_details__0.purpose_cy,
    subcontract_spending_details__0.reporting_code,
    subcontract_spending_details__0.spending_category_id,subcontract_spending_details__0.spending_category_name,subcontract_spending_details__0.calendar_fiscal_year_id,subcontract_spending_details__0.calendar_fiscal_year,
    subcontract_spending_details__0.reference_document_number,subcontract_spending_details__0.reference_document_code,subcontract_spending_details__0.contract_document_code,
    subcontract_spending_details__0.minority_type_id,subcontract_spending_details__0.minority_type_name,subcontract_spending_details__0.industry_type_id,
    subcontract_spending_details__0.industry_type_name,subcontract_spending_details__0.agreement_type_code,subcontract_spending_details__0.award_method_code,
    subcontract_spending_details__0.contract_industry_type_id,subcontract_spending_details__0.contract_industry_type_id_cy,
    subcontract_spending_details__0.contract_minority_type_id,subcontract_spending_details__0.contract_minority_type_id_cy,
    subcontract_spending_details__0.contract_prime_minority_type_id,subcontract_spending_details__0.contract_prime_minority_type_id_cy,
    subcontract_spending_details__0.master_agreement_id,subcontract_spending_details__0.master_contract_number,
    subcontract_spending_details__0.file_type,subcontract_spending_details__0.load_id, subcontract_spending_details__0.last_modified_date, subcontract_spending_details__0.job_id
FROM ONLY subcontract_spending_details__0;


-- sub vendor aggregate tables


CREATE EXTERNAL WEB TABLE aggregateon_subven_spending_coa_entities__0 (
	agency_id smallint,
	spending_category_id smallint,
	vendor_id integer,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
	minority_type_id smallint,
	industry_type_id smallint,
	month_id int,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2),
	total_disbursements integer
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_spending_coa_entities to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
	

CREATE VIEW aggregateon_subven_spending_coa_entities AS
    SELECT aggregateon_subven_spending_coa_entities__0.agency_id, aggregateon_subven_spending_coa_entities__0.spending_category_id, 
    	aggregateon_subven_spending_coa_entities__0.vendor_id, aggregateon_subven_spending_coa_entities__0.prime_vendor_id, aggregateon_subven_spending_coa_entities__0.prime_minority_type_id,
    	aggregateon_subven_spending_coa_entities__0.minority_type_id, aggregateon_subven_spending_coa_entities__0.industry_type_id, 
    	aggregateon_subven_spending_coa_entities__0.month_id, aggregateon_subven_spending_coa_entities__0.year_id, 
    	aggregateon_subven_spending_coa_entities__0.type_of_year, aggregateon_subven_spending_coa_entities__0.total_spending_amount,aggregateon_subven_spending_coa_entities__0.total_disbursements 
    	FROM ONLY aggregateon_subven_spending_coa_entities__0;


    	


CREATE EXTERNAL WEB TABLE aggregateon_subven_spending_contract__0 (
    agreement_id bigint,
    document_id character varying,
    sub_contract_id character varying,
    document_code character varying(8),
	vendor_id integer,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
	minority_type_id smallint,
	industry_type_id smallint,
	agency_id smallint,
	description character varying,	
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2), 
	total_contract_amount numeric(16,2)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_spending_contract to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
	

CREATE VIEW aggregateon_subven_spending_contract AS
    SELECT aggregateon_subven_spending_contract__0.agreement_id, aggregateon_subven_spending_contract__0.document_id, aggregateon_subven_spending_contract__0.sub_contract_id, 
    aggregateon_subven_spending_contract__0.document_code,aggregateon_subven_spending_contract__0.vendor_id, aggregateon_subven_spending_contract__0.prime_vendor_id,
    aggregateon_subven_spending_contract__0.prime_minority_type_id,aggregateon_subven_spending_contract__0.minority_type_id, aggregateon_subven_spending_contract__0.industry_type_id,
    aggregateon_subven_spending_contract__0.agency_id, aggregateon_subven_spending_contract__0.description, aggregateon_subven_spending_contract__0.spending_category_id, 
    aggregateon_subven_spending_contract__0.year_id,aggregateon_subven_spending_contract__0.type_of_year, 
    aggregateon_subven_spending_contract__0.total_spending_amount, aggregateon_subven_spending_contract__0.total_contract_amount 
    FROM ONLY aggregateon_subven_spending_contract__0;

    


CREATE EXTERNAL WEB TABLE aggregateon_subven_spending_vendor__0 (
	vendor_id integer,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
	minority_type_id smallint,
	industry_type_id smallint,
	agency_id smallint,
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2), 
	total_contract_amount numeric(16,2),
	total_sub_contracts integer,
	is_all_categories char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_spending_vendor to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
	

CREATE VIEW aggregateon_subven_spending_vendor AS
    SELECT aggregateon_subven_spending_vendor__0.vendor_id, aggregateon_subven_spending_vendor__0.prime_vendor_id, aggregateon_subven_spending_vendor__0.prime_minority_type_id,
    aggregateon_subven_spending_vendor__0.minority_type_id, aggregateon_subven_spending_vendor__0.industry_type_id,
    aggregateon_subven_spending_vendor__0.agency_id, aggregateon_subven_spending_vendor__0.spending_category_id, aggregateon_subven_spending_vendor__0.year_id,
    aggregateon_subven_spending_vendor__0.type_of_year, aggregateon_subven_spending_vendor__0.total_spending_amount, 
    aggregateon_subven_spending_vendor__0.total_contract_amount, aggregateon_subven_spending_vendor__0.total_sub_contracts, aggregateon_subven_spending_vendor__0.is_all_categories 
    FROM ONLY aggregateon_subven_spending_vendor__0;

  



CREATE EXTERNAL WEB TABLE aggregateon_subven_contracts_cumulative_spending__0 (
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	description varchar,
	contract_number varchar,
	sub_contract_id character varying,
	vendor_id int,
	prime_vendor_id int,
	prime_minority_type_id smallint,
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
	status_flag char(1),
	type_of_year char(1)	
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_contracts_cumulative_spending to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  CREATE VIEW aggregateon_subven_contracts_cumulative_spending AS
  	SELECT aggregateon_subven_contracts_cumulative_spending__0.original_agreement_id,aggregateon_subven_contracts_cumulative_spending__0.fiscal_year,
  		aggregateon_subven_contracts_cumulative_spending__0.fiscal_year_id,
  		aggregateon_subven_contracts_cumulative_spending__0.document_code_id,
  		aggregateon_subven_contracts_cumulative_spending__0.description,aggregateon_subven_contracts_cumulative_spending__0.contract_number,aggregateon_subven_contracts_cumulative_spending__0.sub_contract_id,
  		aggregateon_subven_contracts_cumulative_spending__0.vendor_id,aggregateon_subven_contracts_cumulative_spending__0.prime_vendor_id,aggregateon_subven_contracts_cumulative_spending__0.prime_minority_type_id,
  		aggregateon_subven_contracts_cumulative_spending__0.minority_type_id,aggregateon_subven_contracts_cumulative_spending__0.award_method_id,
  		aggregateon_subven_contracts_cumulative_spending__0.agency_id,aggregateon_subven_contracts_cumulative_spending__0.industry_type_id,aggregateon_subven_contracts_cumulative_spending__0.award_size_id,
  		aggregateon_subven_contracts_cumulative_spending__0.original_contract_amount,aggregateon_subven_contracts_cumulative_spending__0.maximum_contract_amount,aggregateon_subven_contracts_cumulative_spending__0.spending_amount_disb,
  		aggregateon_subven_contracts_cumulative_spending__0.spending_amount,aggregateon_subven_contracts_cumulative_spending__0.current_year_spending_amount,
  		aggregateon_subven_contracts_cumulative_spending__0.dollar_difference,aggregateon_subven_contracts_cumulative_spending__0.percent_difference,
  		aggregateon_subven_contracts_cumulative_spending__0.status_flag,aggregateon_subven_contracts_cumulative_spending__0.type_of_year
  	FROM 	  aggregateon_subven_contracts_cumulative_spending__0;  

  


CREATE EXTERNAL WEB TABLE aggregateon_subven_contracts_spending_by_month__0 (
 original_agreement_id bigint,
 fiscal_year smallint,
 fiscal_year_id smallint,
 document_code_id smallint,
 month_id integer,
 vendor_id int,
 prime_vendor_id int,
 prime_minority_type_id smallint,
 minority_type_id smallint,
 award_method_id smallint,
 agency_id smallint,
 industry_type_id smallint,
 award_size_id smallint,
 spending_amount numeric(16,2),
 status_flag char(1),
 type_of_year char(1) 
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_contracts_spending_by_month to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


   CREATE VIEW aggregateon_subven_contracts_spending_by_month AS
  	SELECT aggregateon_subven_contracts_spending_by_month__0.original_agreement_id,aggregateon_subven_contracts_spending_by_month__0.fiscal_year,aggregateon_subven_contracts_spending_by_month__0.fiscal_year_id,
  		aggregateon_subven_contracts_spending_by_month__0.document_code_id,aggregateon_subven_contracts_spending_by_month__0.month_id,aggregateon_subven_contracts_spending_by_month__0.vendor_id,
  		aggregateon_subven_contracts_spending_by_month__0.prime_vendor_id,aggregateon_subven_contracts_spending_by_month__0.prime_minority_type_id,aggregateon_subven_contracts_spending_by_month__0.minority_type_id,aggregateon_subven_contracts_spending_by_month__0.award_method_id,
  		aggregateon_subven_contracts_spending_by_month__0.agency_id,aggregateon_subven_contracts_spending_by_month__0.industry_type_id, aggregateon_subven_contracts_spending_by_month__0.award_size_id,
  		aggregateon_subven_contracts_spending_by_month__0.spending_amount,	aggregateon_subven_contracts_spending_by_month__0.status_flag,aggregateon_subven_contracts_spending_by_month__0.type_of_year
  	FROM  aggregateon_subven_contracts_spending_by_month__0;
  


CREATE EXTERNAL WEB TABLE aggregateon_subven_total_contracts__0
(
fiscal_year smallint,
fiscal_year_id smallint,
vendor_id int,
 prime_vendor_id int,
 prime_minority_type_id smallint,
 minority_type_id smallint,
award_method_id smallint,
agency_id smallint,
industry_type_id smallint,
award_size_id smallint,
total_contracts bigint,
total_commited_contracts bigint,
total_master_agreements bigint,
total_standalone_contracts bigint,
total_revenue_contracts bigint,
total_revenue_contracts_amount numeric(16,2),
total_commited_contracts_amount numeric(16,2),
total_contracts_amount numeric(16,2),
total_spending_amount_disb numeric(16,2), 
total_spending_amount numeric(16,2), 
status_flag char(1),
type_of_year char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_subven_total_contracts to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  CREATE VIEW aggregateon_subven_total_contracts AS
  	SELECT aggregateon_subven_total_contracts__0.fiscal_year,aggregateon_subven_total_contracts__0.fiscal_year_id,aggregateon_subven_total_contracts__0.vendor_id, aggregateon_subven_total_contracts__0.prime_vendor_id, aggregateon_subven_total_contracts__0.prime_minority_type_id,
  	aggregateon_subven_total_contracts__0.minority_type_id,  	aggregateon_subven_total_contracts__0.award_method_id,  	aggregateon_subven_total_contracts__0.agency_id, aggregateon_subven_total_contracts__0.industry_type_id, 
  	aggregateon_subven_total_contracts__0.award_size_id,   	aggregateon_subven_total_contracts__0.total_contracts,aggregateon_subven_total_contracts__0.total_commited_contracts,	aggregateon_subven_total_contracts__0.total_master_agreements,
  	aggregateon_subven_total_contracts__0.total_standalone_contracts,aggregateon_subven_total_contracts__0.total_revenue_contracts,aggregateon_subven_total_contracts__0.total_revenue_contracts_amount,
  	aggregateon_subven_total_contracts__0.total_commited_contracts_amount,aggregateon_subven_total_contracts__0.total_contracts_amount,aggregateon_subven_total_contracts__0.total_spending_amount_disb,
  	aggregateon_subven_total_contracts__0.total_spending_amount,aggregateon_subven_total_contracts__0.status_flag,aggregateon_subven_total_contracts__0.type_of_year
  	FROM   aggregateon_subven_total_contracts__0;
  	



CREATE EXTERNAL WEB TABLE contracts_subven_spending_transactions__0
(
disbursement_line_item_id bigint,
original_agreement_id bigint,
fiscal_year smallint,
fiscal_year_id smallint,
document_code_id smallint,
vendor_id int,
prime_vendor_id int,
prime_minority_type_id smallint,
minority_type_id smallint,
award_method_id smallint,
document_agency_id smallint,
industry_type_id smallint,
award_size_id smallint,
disb_document_id  character varying,
disb_vendor_name  character varying,
disb_check_eft_issued_date  date,
disb_agency_name  character varying,
disb_check_amount  numeric(16,2),
disb_contract_number  character varying,
disb_sub_contract_id  character varying,
disb_purpose  character varying,
disb_reporting_code  character varying,
disb_spending_category_name  character varying,
disb_agency_id  smallint,
disb_vendor_id  integer,
disb_spending_category_id  smallint,
disb_agreement_id  bigint,
disb_contract_document_code  character varying,
disb_fiscal_year_id  smallint,
disb_check_eft_issued_cal_month_id integer,
disb_disbursement_number character varying,
disb_minority_type_id smallint,
disb_minority_type_name character varying(50),
disb_vendor_type character(2),
disb_master_contract_number character varying,
status_flag char(1),
type_of_year char(1)
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.contracts_subven_spending_transactions to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  CREATE VIEW contracts_subven_spending_transactions AS
  	SELECT contracts_subven_spending_transactions__0.disbursement_line_item_id,contracts_subven_spending_transactions__0.original_agreement_id,contracts_subven_spending_transactions__0.fiscal_year,
  	contracts_subven_spending_transactions__0.fiscal_year_id,contracts_subven_spending_transactions__0.document_code_id, contracts_subven_spending_transactions__0.vendor_id, contracts_subven_spending_transactions__0.prime_vendor_id, contracts_subven_spending_transactions__0.prime_minority_type_id,
  	contracts_subven_spending_transactions__0.minority_type_id,  	contracts_subven_spending_transactions__0.award_method_id, contracts_subven_spending_transactions__0.document_agency_id, contracts_subven_spending_transactions__0.industry_type_id, 
  	contracts_subven_spending_transactions__0.award_size_id, 	contracts_subven_spending_transactions__0.disb_document_id,contracts_subven_spending_transactions__0.disb_vendor_name,contracts_subven_spending_transactions__0.disb_check_eft_issued_date,
  	contracts_subven_spending_transactions__0.disb_agency_name,  	contracts_subven_spending_transactions__0.disb_check_amount,  contracts_subven_spending_transactions__0.disb_contract_number,contracts_subven_spending_transactions__0.disb_sub_contract_id,
  	contracts_subven_spending_transactions__0.disb_purpose, contracts_subven_spending_transactions__0.disb_reporting_code,   	contracts_subven_spending_transactions__0.disb_spending_category_name,contracts_subven_spending_transactions__0.disb_agency_id,
  	contracts_subven_spending_transactions__0.disb_vendor_id, contracts_subven_spending_transactions__0.disb_spending_category_id,contracts_subven_spending_transactions__0.disb_agreement_id,contracts_subven_spending_transactions__0.disb_contract_document_code,
  	contracts_subven_spending_transactions__0.disb_fiscal_year_id,contracts_subven_spending_transactions__0.disb_check_eft_issued_cal_month_id,contracts_subven_spending_transactions__0.disb_disbursement_number,
  	contracts_subven_spending_transactions__0.disb_minority_type_id,contracts_subven_spending_transactions__0.disb_minority_type_name,contracts_subven_spending_transactions__0.disb_vendor_type,
  	contracts_subven_spending_transactions__0.disb_master_contract_number,contracts_subven_spending_transactions__0.status_flag,contracts_subven_spending_transactions__0.type_of_year
  	FROM   contracts_subven_spending_transactions__0;	

  	
CREATE EXTERNAL WEB TABLE aggregateon_all_contracts_cumulative_spending__0 (
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	master_agreement_yn character(1),
	description varchar,
	contract_number varchar,
	sub_contract_id character varying,
	vendor_id int,
	prime_vendor_id int,
	prime_minority_type_id smallint,
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
	status_flag char(1),
	type_of_year char(1)	
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_all_contracts_cumulative_spending to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';


  CREATE VIEW aggregateon_all_contracts_cumulative_spending AS
  	SELECT aggregateon_all_contracts_cumulative_spending__0.original_agreement_id,aggregateon_all_contracts_cumulative_spending__0.fiscal_year,
  		aggregateon_all_contracts_cumulative_spending__0.fiscal_year_id,
  		aggregateon_all_contracts_cumulative_spending__0.document_code_id, aggregateon_all_contracts_cumulative_spending__0.master_agreement_yn,
  		aggregateon_all_contracts_cumulative_spending__0.description,aggregateon_all_contracts_cumulative_spending__0.contract_number,aggregateon_all_contracts_cumulative_spending__0.sub_contract_id,
  		aggregateon_all_contracts_cumulative_spending__0.vendor_id,aggregateon_all_contracts_cumulative_spending__0.prime_vendor_id,aggregateon_all_contracts_cumulative_spending__0.prime_minority_type_id,
  		aggregateon_all_contracts_cumulative_spending__0.minority_type_id,aggregateon_all_contracts_cumulative_spending__0.award_method_id,
  		aggregateon_all_contracts_cumulative_spending__0.agency_id,aggregateon_all_contracts_cumulative_spending__0.industry_type_id,aggregateon_all_contracts_cumulative_spending__0.award_size_id,
  		aggregateon_all_contracts_cumulative_spending__0.original_contract_amount,aggregateon_all_contracts_cumulative_spending__0.maximum_contract_amount,aggregateon_all_contracts_cumulative_spending__0.spending_amount_disb,
  		aggregateon_all_contracts_cumulative_spending__0.spending_amount,aggregateon_all_contracts_cumulative_spending__0.current_year_spending_amount,
  		aggregateon_all_contracts_cumulative_spending__0.dollar_difference,aggregateon_all_contracts_cumulative_spending__0.percent_difference,
  		aggregateon_all_contracts_cumulative_spending__0.status_flag,aggregateon_all_contracts_cumulative_spending__0.type_of_year
  	FROM 	  aggregateon_all_contracts_cumulative_spending__0;  
  	
  	
-- Common transaction Tables

CREATE EXTERNAL WEB TABLE all_agreement_transactions__0(
 	 original_agreement_id bigint,
	   document_version smallint,
	   document_code_id smallint,
	   agency_history_id smallint,
	   agency_id smallint,
	   agency_code character varying(20),
	   agency_name character varying(100),
	   agreement_id bigint,
	   starting_year smallint,
	   starting_year_id smallint,
	   ending_year smallint,
	   ending_year_id smallint,
	   registered_year smallint,
	   registered_year_id smallint,
	   contract_number character varying,
	   sub_contract_id character varying,
	   original_contract_amount numeric(16,2),
	   maximum_contract_amount numeric(16,2),	   
	   description character varying,
	   vendor_history_id integer,
	   vendor_id integer,
	   vendor_code character varying(20),
	   vendor_name character varying,
	   prime_vendor_id integer,
	   prime_vendor_name character varying,
	   prime_minority_type_id smallint,
       prime_minority_type_name character varying(50),
	   dollar_difference numeric(16,2),
	   percent_difference numeric(17,4),
	   master_agreement_id bigint,
	   master_contract_number character varying,
	   agreement_type_id smallint,
	   agreement_type_code character varying(2),
	   agreement_type_name character varying,
	   award_category_id smallint,
	   award_category_code character varying(10),
	   award_category_name character varying,
	   award_method_id smallint,
	   award_method_code character varying(10) ,
	   award_method_name character varying,
	   expenditure_object_codes character varying,
	   expenditure_object_names character varying,
	   industry_type_id smallint,
	   industry_type_name character varying(50),
   	   award_size_id smallint,
	   effective_begin_date date,
	   effective_begin_date_id integer,
	   effective_begin_year smallint,
	   effective_begin_year_id smallint,
	   effective_end_date date,
	   effective_end_date_id integer,
	   effective_end_year smallint,
	   effective_end_year_id smallint,
	   registered_date date,
	   registered_date_id integer,
	   brd_awd_no character varying,
	   tracking_number character varying,
	   rfed_amount numeric(16,2),
	   minority_type_id smallint,
 	   minority_type_name character varying,
	   master_agreement_yn character(1),
	   has_children character(1),
	   has_mwbe_children character(1),
	   original_version_flag character(1),
   	   latest_flag character(1),
   	  load_id integer,
      last_modified_date timestamp without time zone,
      last_modified_year_id smallint,
      is_prime_or_sub character(1),
      is_minority_vendor character(1), 
      vendor_type character(2),
      contract_original_agreement_id bigint,
      is_subvendor character varying(3),
      associated_prime_vendor_name character varying,
      mwbe_category_ui character varying,
      job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.all_agreement_transactions to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW all_agreement_transactions AS
  	SELECT all_agreement_transactions__0.original_agreement_id,all_agreement_transactions__0.document_version,all_agreement_transactions__0.document_code_id,
  		all_agreement_transactions__0.agency_history_id,all_agreement_transactions__0.agency_id,all_agreement_transactions__0.agency_code,all_agreement_transactions__0.agency_name,
  		all_agreement_transactions__0.agreement_id,all_agreement_transactions__0.starting_year,all_agreement_transactions__0.starting_year_id,all_agreement_transactions__0.ending_year,
  		all_agreement_transactions__0.ending_year_id,all_agreement_transactions__0.registered_year,all_agreement_transactions__0.registered_year_id,all_agreement_transactions__0.contract_number,all_agreement_transactions__0.sub_contract_id,
  		all_agreement_transactions__0.original_contract_amount,all_agreement_transactions__0.maximum_contract_amount,all_agreement_transactions__0.description,
  		all_agreement_transactions__0.vendor_history_id,all_agreement_transactions__0.vendor_id,all_agreement_transactions__0.vendor_code,all_agreement_transactions__0.vendor_name,all_agreement_transactions__0.prime_vendor_id,all_agreement_transactions__0.prime_vendor_name,
  		all_agreement_transactions__0.prime_minority_type_id, all_agreement_transactions__0.prime_minority_type_name,	all_agreement_transactions__0.dollar_difference,all_agreement_transactions__0.percent_difference,all_agreement_transactions__0.master_agreement_id,all_agreement_transactions__0.master_contract_number,
  		all_agreement_transactions__0.agreement_type_id,all_agreement_transactions__0.agreement_type_code,all_agreement_transactions__0.agreement_type_name,all_agreement_transactions__0.award_category_id,all_agreement_transactions__0.award_category_code,
  		all_agreement_transactions__0.award_category_name,all_agreement_transactions__0.award_method_id,all_agreement_transactions__0.award_method_code,all_agreement_transactions__0.award_method_name,
  		all_agreement_transactions__0.expenditure_object_codes,all_agreement_transactions__0.expenditure_object_names,all_agreement_transactions__0.industry_type_id,all_agreement_transactions__0.industry_type_name,all_agreement_transactions__0.award_size_id,
  		all_agreement_transactions__0.effective_begin_date,all_agreement_transactions__0.effective_begin_date_id,
  		all_agreement_transactions__0.effective_begin_year,all_agreement_transactions__0.effective_begin_year_id,all_agreement_transactions__0.effective_end_date,
  		all_agreement_transactions__0.effective_end_date_id,all_agreement_transactions__0.effective_end_year,all_agreement_transactions__0.effective_end_year_id,
  		all_agreement_transactions__0.registered_date,all_agreement_transactions__0.registered_date_id,all_agreement_transactions__0.brd_awd_no,all_agreement_transactions__0.tracking_number,all_agreement_transactions__0.rfed_amount,
  		all_agreement_transactions__0.minority_type_id,all_agreement_transactions__0.minority_type_name,
  		all_agreement_transactions__0.master_agreement_yn,all_agreement_transactions__0.has_children,all_agreement_transactions__0.has_mwbe_children,all_agreement_transactions__0.original_version_flag,all_agreement_transactions__0.latest_flag,
  		all_agreement_transactions__0.load_id,all_agreement_transactions__0.last_modified_date,all_agreement_transactions__0.last_modified_year_id,all_agreement_transactions__0.is_prime_or_sub,
  		all_agreement_transactions__0.is_minority_vendor, all_agreement_transactions__0.vendor_type, all_agreement_transactions__0.contract_original_agreement_id, 
  		all_agreement_transactions__0.is_subvendor, all_agreement_transactions__0.associated_prime_vendor_name, all_agreement_transactions__0.mwbe_category_ui, 
  		all_agreement_transactions__0.job_id
  	FROM  all_agreement_transactions__0;




CREATE EXTERNAL WEB TABLE all_agreement_transactions_cy__0(
 	original_agreement_id bigint,
	  document_version smallint,
	  document_code_id smallint,
	  agency_history_id smallint,
	  agency_id smallint,
	  agency_code character varying(20),
	  agency_name character varying(100),
	  agreement_id bigint,
	  starting_year smallint,
	  starting_year_id smallint,
	  ending_year smallint,
	  ending_year_id smallint,
	  registered_year smallint,
	  registered_year_id smallint,
	  contract_number character varying,
	  sub_contract_id character varying, 
	  original_contract_amount numeric(16,2),
	  maximum_contract_amount numeric(16,2),
	  description character varying,
	  vendor_history_id integer,
	  vendor_id integer,
	  vendor_code character varying(20),
	  vendor_name character varying,
	  prime_vendor_id integer,
	  prime_vendor_name character varying,
	  prime_minority_type_id smallint,
      prime_minority_type_name character varying(50),
	  dollar_difference numeric(16,2),
	  percent_difference numeric(17,4),
	  master_agreement_id bigint,
	  master_contract_number character varying,
	  agreement_type_id smallint,
	  agreement_type_code character varying(2),
	  agreement_type_name character varying,
	  award_category_id smallint,
	  award_category_code character varying(10),
	  award_category_name character varying,
	  award_method_id smallint,
	  award_method_code character varying(10),
	  award_method_name character varying,
	  expenditure_object_codes character varying,
	  expenditure_object_names character varying,
	  industry_type_id smallint,
	  industry_type_name character varying(50),
   	  award_size_id smallint,
	  effective_begin_date date,
	  effective_begin_date_id integer,
	  effective_begin_year smallint,
	  effective_begin_year_id smallint,
	  effective_end_date date,
	  effective_end_date_id integer,
	  effective_end_year smallint,
	  effective_end_year_id smallint,
	  registered_date date,
	  registered_date_id integer,
	  brd_awd_no character varying,
	  tracking_number character varying,
	  rfed_amount numeric(16,2),
	  minority_type_id smallint,
 	minority_type_name character varying,
	  master_agreement_yn character(1),
	  has_children character(1),
	  has_mwbe_children character(1),
	  original_version_flag character(1),
  	  latest_flag character(1),
  	  load_id integer,
      last_modified_date timestamp without time zone,
      last_modified_year_id smallint,
      is_prime_or_sub character(1),
      is_minority_vendor character(1), 
      vendor_type character(2),
      contract_original_agreement_id bigint,
      is_subvendor character varying(3),
      associated_prime_vendor_name character varying,
      mwbe_category_ui character varying,
      job_id bigint
) 
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.all_agreement_transactions_cy to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  
  CREATE VIEW all_agreement_transactions_cy AS
  	SELECT all_agreement_transactions_cy__0.original_agreement_id,all_agreement_transactions_cy__0.document_version,all_agreement_transactions_cy__0.document_code_id,
  		all_agreement_transactions_cy__0.agency_history_id,all_agreement_transactions_cy__0.agency_id,all_agreement_transactions_cy__0.agency_code,all_agreement_transactions_cy__0.agency_name,
  		all_agreement_transactions_cy__0.agreement_id,all_agreement_transactions_cy__0.starting_year,all_agreement_transactions_cy__0.starting_year_id,all_agreement_transactions_cy__0.ending_year,
  		all_agreement_transactions_cy__0.ending_year_id,all_agreement_transactions_cy__0.registered_year,all_agreement_transactions_cy__0.registered_year_id,all_agreement_transactions_cy__0.contract_number,all_agreement_transactions_cy__0.sub_contract_id,
  		all_agreement_transactions_cy__0.original_contract_amount,all_agreement_transactions_cy__0.maximum_contract_amount,all_agreement_transactions_cy__0.description,
  		all_agreement_transactions_cy__0.vendor_history_id,all_agreement_transactions_cy__0.vendor_id,all_agreement_transactions_cy__0.vendor_code,all_agreement_transactions_cy__0.vendor_name,all_agreement_transactions_cy__0.prime_vendor_id,all_agreement_transactions_cy__0.prime_vendor_name,
  		all_agreement_transactions_cy__0.prime_minority_type_id, all_agreement_transactions_cy__0.prime_minority_type_name,	all_agreement_transactions_cy__0.dollar_difference,all_agreement_transactions_cy__0.percent_difference,all_agreement_transactions_cy__0.master_agreement_id,all_agreement_transactions_cy__0.master_contract_number,
  		all_agreement_transactions_cy__0.agreement_type_id,all_agreement_transactions_cy__0.agreement_type_code,all_agreement_transactions_cy__0.agreement_type_name,all_agreement_transactions_cy__0.award_category_id,all_agreement_transactions_cy__0.award_category_code,
  		all_agreement_transactions_cy__0.award_category_name,all_agreement_transactions_cy__0.award_method_id,all_agreement_transactions_cy__0.award_method_code,all_agreement_transactions_cy__0.award_method_name,
   		all_agreement_transactions_cy__0.expenditure_object_codes,all_agreement_transactions_cy__0.expenditure_object_names,all_agreement_transactions_cy__0.industry_type_id,all_agreement_transactions_cy__0.industry_type_name,all_agreement_transactions_cy__0.award_size_id,
   		all_agreement_transactions_cy__0.effective_begin_date,all_agreement_transactions_cy__0.effective_begin_date_id,
  		all_agreement_transactions_cy__0.effective_begin_year,all_agreement_transactions_cy__0.effective_begin_year_id,all_agreement_transactions_cy__0.effective_end_date,
  		all_agreement_transactions_cy__0.effective_end_date_id,all_agreement_transactions_cy__0.effective_end_year,all_agreement_transactions_cy__0.effective_end_year_id,
  		all_agreement_transactions_cy__0.registered_date,all_agreement_transactions_cy__0.registered_date_id,all_agreement_transactions_cy__0.brd_awd_no,all_agreement_transactions_cy__0.tracking_number,all_agreement_transactions_cy__0.rfed_amount,
  		all_agreement_transactions_cy__0.minority_type_id,all_agreement_transactions_cy__0.minority_type_name,
  		all_agreement_transactions_cy__0.master_agreement_yn,all_agreement_transactions_cy__0.has_children,all_agreement_transactions_cy__0.has_mwbe_children,all_agreement_transactions_cy__0.original_version_flag,all_agreement_transactions_cy__0.latest_flag,
  		all_agreement_transactions_cy__0.load_id,all_agreement_transactions_cy__0.last_modified_date,all_agreement_transactions_cy__0.last_modified_year_id,all_agreement_transactions_cy__0.is_prime_or_sub,
  		all_agreement_transactions_cy__0.is_minority_vendor, all_agreement_transactions_cy__0.vendor_type, all_agreement_transactions_cy__0.contract_original_agreement_id, 
  		all_agreement_transactions_cy__0.is_subvendor, all_agreement_transactions_cy__0.associated_prime_vendor_name, all_agreement_transactions_cy__0.mwbe_category_ui, all_agreement_transactions_cy__0.job_id
  	FROM  all_agreement_transactions_cy__0; 
  	
  	


 CREATE EXTERNAL WEB TABLE all_disbursement_transactions__0 (
    disbursement_line_item_id bigint,
	disbursement_id integer,
	line_number integer,
	disbursement_number character varying(40),
	payment_id character varying,
	check_eft_issued_date_id int,
	check_eft_issued_nyc_year_id smallint,
	fiscal_year smallint,
	check_eft_issued_cal_month_id int,
	agreement_id bigint,
	master_agreement_id bigint,
	fund_class_id smallint,
	check_amount numeric(16,2),
	agency_id smallint,
	agency_history_id smallint,
	agency_code varchar(20),
	expenditure_object_id integer,
	vendor_id integer,
	prime_vendor_id integer, 
	prime_vendor_name character varying,
	prime_minority_type_id smallint,
    prime_minority_type_name character varying(50),
	department_id integer,
	maximum_contract_amount numeric(16,2),
	maximum_contract_amount_cy numeric(16,2),
	maximum_spending_limit numeric(16,2),
	maximum_spending_limit_cy numeric(16,2),
	document_id varchar(20),
	vendor_name varchar,
	vendor_customer_code varchar(20), 
	check_eft_issued_date date,
	agency_name varchar(100),	
	agency_short_name character varying(15),  	
	location_name varchar,
	location_code varchar(4),
	department_name varchar(100),
	department_short_name character varying(15),
	department_code varchar(20),
	expenditure_object_name varchar(40),
	expenditure_object_code varchar(4),
	budget_code_id integer,
	budget_code varchar(10),
	budget_name varchar(60),
	contract_number varchar,
	sub_contract_id character varying,
	master_contract_number character varying,
	master_child_contract_number character varying,
  	contract_vendor_id integer,
  	contract_vendor_id_cy integer,
  	contract_prime_vendor_id integer,  
	contract_prime_vendor_id_cy integer,
  	master_contract_vendor_id integer,
  	master_contract_vendor_id_cy integer,
  	contract_agency_id smallint,
  	contract_agency_id_cy smallint,
  	master_contract_agency_id smallint,
  	master_contract_agency_id_cy smallint,
  	master_purpose character varying,
  	master_purpose_cy character varying,
	purpose varchar,
	purpose_cy varchar,
	master_child_contract_agency_id smallint,
	master_child_contract_agency_id_cy smallint,
	master_child_contract_vendor_id integer,
	master_child_contract_vendor_id_cy integer,
	reporting_code varchar(15),
	location_id integer,
	fund_class_name varchar(50),
	fund_class_code varchar(5),
	spending_category_id smallint,
	spending_category_name varchar,
	calendar_fiscal_year_id smallint,
	calendar_fiscal_year smallint,
	agreement_accounting_line_number integer,
    agreement_commodity_line_number integer,
   	agreement_vendor_line_number integer, 
   	reference_document_number character varying,    
   	reference_document_code varchar(8),
	contract_document_code varchar(8),
	master_contract_document_code varchar(8),
	minority_type_id smallint,
 	minority_type_name character varying,
 	industry_type_id smallint,
   	industry_type_name character varying,
   	agreement_type_code character varying,
   	award_method_code character varying,
   	contract_industry_type_id smallint,
	contract_industry_type_id_cy smallint,
	master_contract_industry_type_id smallint,
	master_contract_industry_type_id_cy smallint,
	contract_minority_type_id smallint,
	contract_minority_type_id_cy smallint,
	master_contract_minority_type_id smallint,
	master_contract_minority_type_id_cy smallint,
	file_type char(1),
	load_id integer,
	last_modified_date timestamp without time zone,
	last_modified_fiscal_year_id smallint,
	last_modified_calendar_year_id smallint,
	is_prime_or_sub character(1),
	is_minority_vendor character(1), 
    vendor_type character(2),
    contract_original_agreement_id bigint,
    is_subvendor character varying(3),
    associated_prime_vendor_name character varying,
    mwbe_category_ui character varying,
	job_id bigint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.all_disbursement_transactions to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';



CREATE VIEW all_disbursement_transactions AS
    SELECT all_disbursement_transactions__0.disbursement_line_item_id, all_disbursement_transactions__0.disbursement_id, all_disbursement_transactions__0.line_number,
    all_disbursement_transactions__0.disbursement_number ,all_disbursement_transactions__0.payment_id, all_disbursement_transactions__0.check_eft_issued_date_id, 
    all_disbursement_transactions__0.check_eft_issued_nyc_year_id, all_disbursement_transactions__0.fiscal_year, all_disbursement_transactions__0.check_eft_issued_cal_month_id, all_disbursement_transactions__0.agreement_id,
    all_disbursement_transactions__0.master_agreement_id, all_disbursement_transactions__0.fund_class_id, all_disbursement_transactions__0.check_amount, all_disbursement_transactions__0.agency_id,
    all_disbursement_transactions__0.agency_history_id,all_disbursement_transactions__0.agency_code, all_disbursement_transactions__0.expenditure_object_id, all_disbursement_transactions__0.vendor_id, 
    all_disbursement_transactions__0.prime_vendor_id, all_disbursement_transactions__0.prime_vendor_name,all_disbursement_transactions__0.prime_minority_type_id, all_disbursement_transactions__0.prime_minority_type_name,
    all_disbursement_transactions__0.department_id,all_disbursement_transactions__0.maximum_contract_amount, all_disbursement_transactions__0.maximum_contract_amount_cy,
    all_disbursement_transactions__0.maximum_spending_limit,all_disbursement_transactions__0.maximum_spending_limit_cy,
    all_disbursement_transactions__0.document_id, all_disbursement_transactions__0.vendor_name,all_disbursement_transactions__0.vendor_customer_code, all_disbursement_transactions__0.check_eft_issued_date, 
    all_disbursement_transactions__0.agency_name,all_disbursement_transactions__0.agency_short_name,
    all_disbursement_transactions__0.location_name,all_disbursement_transactions__0.location_code, all_disbursement_transactions__0.department_name,
    all_disbursement_transactions__0.department_short_name,all_disbursement_transactions__0.department_code, all_disbursement_transactions__0.expenditure_object_name,all_disbursement_transactions__0.expenditure_object_code, 
    all_disbursement_transactions__0.budget_code_id,all_disbursement_transactions__0.budget_code,
    all_disbursement_transactions__0.budget_name, all_disbursement_transactions__0.contract_number,  all_disbursement_transactions__0.sub_contract_id, all_disbursement_transactions__0.master_contract_number,all_disbursement_transactions__0.master_child_contract_number,
    all_disbursement_transactions__0.contract_vendor_id,all_disbursement_transactions__0.contract_vendor_id_cy,all_disbursement_transactions__0.contract_prime_vendor_id,all_disbursement_transactions__0.contract_prime_vendor_id_cy,
    all_disbursement_transactions__0.master_contract_vendor_id,    all_disbursement_transactions__0.master_contract_vendor_id_cy,all_disbursement_transactions__0.contract_agency_id,all_disbursement_transactions__0.contract_agency_id_cy,
    all_disbursement_transactions__0.master_contract_agency_id,all_disbursement_transactions__0.master_contract_agency_id_cy,all_disbursement_transactions__0.master_purpose,
    all_disbursement_transactions__0.master_purpose_cy, all_disbursement_transactions__0.purpose,all_disbursement_transactions__0.purpose_cy,
    all_disbursement_transactions__0.master_child_contract_agency_id, all_disbursement_transactions__0.master_child_contract_agency_id_cy,all_disbursement_transactions__0.master_child_contract_vendor_id,all_disbursement_transactions__0.master_child_contract_vendor_id_cy,
    all_disbursement_transactions__0.reporting_code,all_disbursement_transactions__0.location_id,all_disbursement_transactions__0.fund_class_name,all_disbursement_transactions__0.fund_class_code,
    all_disbursement_transactions__0.spending_category_id,all_disbursement_transactions__0.spending_category_name,all_disbursement_transactions__0.calendar_fiscal_year_id,all_disbursement_transactions__0.calendar_fiscal_year,
    all_disbursement_transactions__0.agreement_accounting_line_number, all_disbursement_transactions__0.agreement_commodity_line_number, all_disbursement_transactions__0.agreement_vendor_line_number, 
    all_disbursement_transactions__0.reference_document_number,all_disbursement_transactions__0.reference_document_code,all_disbursement_transactions__0.contract_document_code,
    all_disbursement_transactions__0.master_contract_document_code, 
    all_disbursement_transactions__0.minority_type_id,all_disbursement_transactions__0.minority_type_name,all_disbursement_transactions__0.industry_type_id,
    all_disbursement_transactions__0.industry_type_name,all_disbursement_transactions__0.agreement_type_code,all_disbursement_transactions__0.award_method_code,
    all_disbursement_transactions__0.contract_industry_type_id,all_disbursement_transactions__0.contract_industry_type_id_cy,all_disbursement_transactions__0.master_contract_industry_type_id,
    all_disbursement_transactions__0.master_contract_industry_type_id_cy,all_disbursement_transactions__0.contract_minority_type_id,all_disbursement_transactions__0.contract_minority_type_id_cy,
    all_disbursement_transactions__0.master_contract_minority_type_id,all_disbursement_transactions__0.master_contract_minority_type_id_cy,
    all_disbursement_transactions__0.file_type,all_disbursement_transactions__0.load_id, all_disbursement_transactions__0.last_modified_date, 
    all_disbursement_transactions__0.last_modified_fiscal_year_id, all_disbursement_transactions__0.last_modified_calendar_year_id, all_disbursement_transactions__0.is_prime_or_sub, 
    all_disbursement_transactions__0.is_minority_vendor, all_disbursement_transactions__0.vendor_type,  all_disbursement_transactions__0.contract_original_agreement_id, 
    all_disbursement_transactions__0.is_subvendor, all_disbursement_transactions__0.associated_prime_vendor_name,  all_disbursement_transactions__0.mwbe_category_ui,
    all_disbursement_transactions__0.job_id
FROM ONLY all_disbursement_transactions__0; 


 CREATE EXTERNAL WEB TABLE contracts_all_spending_transactions__0(
 	disbursement_line_item_id bigint,
	original_agreement_id bigint,
	fiscal_year smallint,
	fiscal_year_id smallint,
	document_code_id smallint,
	vendor_id int,
	prime_vendor_id integer,
	prime_minority_type_id smallint,
	minority_type_id smallint,
	award_method_id smallint,
	document_agency_id smallint,
	industry_type_id smallint,
    award_size_id smallint,
	disb_document_id  character varying(20),
	disb_vendor_name  character varying,
	disb_check_eft_issued_date  date,
	disb_agency_name  character varying(100),
	disb_department_short_name  character varying(15),
	disb_check_amount  numeric(16,2),
	disb_expenditure_object_name  character varying(40),
	disb_budget_name  character varying(60),
	disb_contract_number  character varying,
	disb_sub_contract_id character varying,
	disb_purpose  character varying,
	disb_reporting_code  character varying(15),
	disb_spending_category_name  character varying,
	disb_agency_id  smallint,
	disb_vendor_id  integer,
	disb_expenditure_object_id  integer,
	disb_department_id  integer,
	disb_spending_category_id  smallint,
	disb_agreement_id  bigint,
	disb_contract_document_code  character varying(8),
	disb_master_agreement_id  bigint,
	disb_fiscal_year_id  smallint,
	disb_check_eft_issued_cal_month_id integer,
	disb_disbursement_number character varying(40),
	disb_minority_type_id smallint,
	disb_minority_type_name character varying(50),
	disb_vendor_type character(2),
	status_flag char(1),
	type_of_year char(1),
	is_prime_or_sub character(1)
) 	
EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.contracts_all_spending_transactions to stdout csv"' ON SEGMENT 0 
     FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
  ENCODING 'UTF8';
  

  CREATE VIEW contracts_all_spending_transactions AS
  	SELECT contracts_all_spending_transactions__0.disbursement_line_item_id,contracts_all_spending_transactions__0.original_agreement_id,contracts_all_spending_transactions__0.fiscal_year,
  	contracts_all_spending_transactions__0.fiscal_year_id,contracts_all_spending_transactions__0.document_code_id, contracts_all_spending_transactions__0.vendor_id, 
  	contracts_all_spending_transactions__0.prime_vendor_id,contracts_all_spending_transactions__0.prime_minority_type_id,contracts_all_spending_transactions__0.minority_type_id,
  	contracts_all_spending_transactions__0.award_method_id, contracts_all_spending_transactions__0.document_agency_id, contracts_all_spending_transactions__0.industry_type_id, contracts_all_spending_transactions__0.award_size_id,
  	contracts_all_spending_transactions__0.disb_document_id,contracts_all_spending_transactions__0.disb_vendor_name,contracts_all_spending_transactions__0.disb_check_eft_issued_date,contracts_all_spending_transactions__0.disb_agency_name,
  	contracts_all_spending_transactions__0.disb_department_short_name,contracts_all_spending_transactions__0.disb_check_amount,contracts_all_spending_transactions__0.disb_expenditure_object_name,
  	contracts_all_spending_transactions__0.disb_budget_name,contracts_all_spending_transactions__0.disb_contract_number,contracts_all_spending_transactions__0.disb_sub_contract_id,contracts_all_spending_transactions__0.disb_purpose,contracts_all_spending_transactions__0.disb_reporting_code,
  	contracts_all_spending_transactions__0.disb_spending_category_name,contracts_all_spending_transactions__0.disb_agency_id,contracts_all_spending_transactions__0.disb_vendor_id,contracts_all_spending_transactions__0.disb_expenditure_object_id,
  	contracts_all_spending_transactions__0.disb_department_id,contracts_all_spending_transactions__0.disb_spending_category_id,contracts_all_spending_transactions__0.disb_agreement_id,contracts_all_spending_transactions__0.disb_contract_document_code,
  	contracts_all_spending_transactions__0.disb_master_agreement_id,contracts_all_spending_transactions__0.disb_fiscal_year_id,contracts_all_spending_transactions__0.disb_check_eft_issued_cal_month_id,contracts_all_spending_transactions__0.disb_disbursement_number,
  	contracts_all_spending_transactions__0.disb_minority_type_id,contracts_all_spending_transactions__0.disb_minority_type_name,contracts_all_spending_transactions__0.disb_vendor_type,
  	contracts_all_spending_transactions__0.status_flag,contracts_all_spending_transactions__0.type_of_year,contracts_all_spending_transactions__0.is_prime_or_sub
  	FROM   contracts_all_spending_transactions__0;