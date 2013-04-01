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
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: gpadmin
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

--
-- Name: grantaccess(character varying, character varying); Type: FUNCTION; Schema: public; Owner: athiagarajan
--

CREATE FUNCTION grantaccess(username character varying, privilege character varying) RETURNS integer
    AS $$
DECLARE
        l_etl_tables RECORD;
        l_public_tables RECORD;
        l_grant_str VARCHAR;
BEGIN

        For l_etl_tables IN     SELECT  a.relname
                        FROM pg_class a ,
                        pg_namespace b where a.relnamespace = b.oid and b.nspname='staging' and relkind <> 'i'

        LOOP

                l_grant_str := 'GRANT ' || privilege || ' ON staging.' || l_etl_tables.relname || ' TO '  || username ;

                RAISE notice 'l_grant_str %',l_grant_str;

                EXECUTE l_grant_str;

        END LOOP;

        For l_public_tables IN  SELECT  a.relname
                        FROM pg_class a ,
                        pg_namespace b where a.relnamespace = b.oid and b.nspname='public'      and relkind <> 'i'


        LOOP

                l_grant_str := 'GRANT ' || privilege || ' ON public.' || l_public_tables.relname || ' TO '  || username ;

                RAISE notice 'l_grant_str %',l_grant_str;

                EXECUTE l_grant_str;

        END LOOP;


        RETURN 1;

EXCEPTION
        WHEN OTHERS THEN
        RAISE NOTICE 'Exception Occurred in grantaccess';
        RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;

        RETURN 0;
END;
$$
    LANGUAGE plpgsql;

--
-- Name: address; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE address (
    address_id integer NOT NULL,
    address_line_1 character varying(75),
    address_line_2 character varying(75),
    city character varying(60),
 	state character varying(25),
  	zip character varying(25),
  	country character varying(25)
) DISTRIBUTED BY (address_id);


--
-- Name: aggregateon_spending_coa_entities; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE aggregateon_spending_coa_entities (
    department_id integer,
    agency_id smallint,
    spending_category_id smallint,
    expenditure_object_id integer,
    vendor_id integer,
    month_id int,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric(16,2),
    total_disbursements integer
)WITH(appendonly=true)
DISTRIBUTED BY (department_id);

--
-- Name: aggregateon_spending_contract; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE aggregateon_spending_contract (
    agreement_id bigint,
    document_id character varying(20),
    document_code character varying(8),
    vendor_id integer,
    agency_id smallint,
    description character varying(60),
    spending_category_id smallint,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric(16,2),
    total_contract_amount numeric(16,2)
) DISTRIBUTED BY (agreement_id);

--
-- Name: aggregateon_spending_vendor; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE aggregateon_spending_vendor (
    vendor_id integer,
    agency_id smallint,
    spending_category_id smallint,
    year_id smallint,
    type_of_year char(1),
    total_spending_amount numeric(16,2),
    total_contract_amount numeric(16,2),
    is_all_categories char(1)
) DISTRIBUTED BY (vendor_id);

CREATE TABLE aggregateon_spending_vendor_exp_object(
	vendor_id integer,
	expenditure_object_id integer,
	spending_category_id smallint,
	year_id smallint,
	type_of_year char(1),
	total_spending_amount numeric(16,2) )
DISTRIBUTED BY (expenditure_object_id);	


--
-- Name: budget; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE budget (
    budget_id integer NOT NULL,
    budget_fiscal_year smallint,
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    budget_code_id integer,
    object_class_history_id integer,
	adopted_amount_original numeric(20,2),
    adopted_amount numeric(20,2),
    current_budget_amount_original numeric(20,2),
    current_budget_amount numeric(20,2),
    pre_encumbered_amount_original numeric(20,2),
    pre_encumbered_amount numeric(20,2),
    encumbered_amount_original numeric(20,2),
    encumbered_amount numeric(20,2),
    accrued_expense_amount_original numeric(20,2),
    accrued_expense_amount numeric(20,2),
    cash_expense_amount_original numeric(20,2),
    cash_expense_amount numeric(20,2),
    post_closing_adjustment_amount_original numeric(20,2),
    post_closing_adjustment_amount numeric(20,2),
    total_expenditure_amount numeric(20,2),
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
    department_short_name varchar
) DISTRIBUTED BY (budget_id);

--
-- Name: disbursement; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE disbursement (
    disbursement_id integer,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying(20),
    document_version integer,
    disbursement_number character varying(40),
    record_date_id int,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period character(2),
    check_eft_amount_original numeric(16,2),
    check_eft_amount numeric(16,2),
    check_eft_issued_date_id int,
    check_eft_record_date_id int,
    expenditure_status_id smallint,
    expenditure_cancel_type_id smallint,
    expenditure_cancel_reason_id integer,
    total_accounting_line_amount_original numeric(16,2),
    total_accounting_line_amount numeric(16,2),
    vendor_history_id integer,
    retainage_amount_original numeric(16,2),
    retainage_amount numeric(16,2),
    privacy_flag char(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
)WITH(appendonly=true)
distributed by (disbursement_id);


--
-- Name: disbursement_line_item; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE disbursement_line_item (
    disbursement_line_item_id bigint,
    disbursement_id integer,
    line_number integer,
    disbursement_number character varying(40),
    budget_fiscal_year smallint,
    fiscal_year smallint,
    fiscal_period character(2),
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    expenditure_object_history_id integer,
    budget_code_id integer,
    fund_code varchar(4),
    reporting_code character varying(15),
    check_amount_original numeric(16,2),
    check_amount numeric(16,2),
    agreement_id bigint,
    agreement_accounting_line_number integer,
    agreement_commodity_line_number integer,
    agreement_vendor_line_number integer, 
    reference_document_number character varying,
    reference_document_code varchar(8),
    location_history_id integer,
    retainage_amount_original numeric(16,2),
    retainage_amount numeric(16,2),
    check_eft_issued_nyc_year_id smallint,
    file_type char(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) WITH (appendonly=true,orientation=column)
distributed by (disbursement_line_item_id);

--
-- Name: disbursement_line_item_details; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE disbursement_line_item_details(
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
	file_type char(1),
	load_id integer,
    last_modified_date timestamp without time zone,
    job_id bigint
	)WITH(appendonly=true,orientation=column)
DISTRIBUTED BY (disbursement_line_item_id);


--
-- Name: revenue_details; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE revenue_details
(	revenue_id bigint,
	fiscal_year smallint,
	fiscal_period char(2),
	posting_amount decimal(16,2),
	revenue_category_id smallint,
	revenue_source_id int,
	fiscal_year_id smallint,
	agency_id smallint,
	department_id integer,	
	revenue_class_id smallint,
	fund_class_id smallint,
	funding_class_id smallint,
	budget_code_id integer,
	budget_fiscal_year_id smallint,
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
	agency_short_name varchar,
	department_short_name varchar,
	agency_history_id smallint,
	load_id integer,
    last_modified_date timestamp without time zone
) DISTRIBUTED BY (revenue_id);

--
-- Name: history_agreement; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE history_agreement (
    agreement_id bigint,
    master_agreement_id bigint,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying(20),
    document_version integer,
    tracking_number character varying(30),
    record_date_id int,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period character(2),
    description character varying(60),
    actual_amount_original numeric(16,2),
    actual_amount numeric(16,2),
    obligated_amount_original numeric(16,2),
    obligated_amount numeric(16,2),
    maximum_contract_amount_original numeric(16,2),
    maximum_contract_amount numeric(16,2),
    amendment_number character varying(19),
    replacing_agreement_id bigint,
    replaced_by_agreement_id bigint,
    award_status_id smallint,
    procurement_id character varying(20),
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
    contract_class_code character varying(2),
    award_category_id_1 smallint,
    award_category_id_2 smallint,
    award_category_id_3 smallint,
    award_category_id_4 smallint,
    award_category_id_5 smallint,
    number_responses integer,
    location_service character varying(255),
    location_zip character varying(10),
    borough_code character varying(10),
    block_code character varying(10),
    lot_code character varying(10),
    council_district_code character varying(10),
    vendor_history_id integer,
    vendor_preference_level integer,
    original_contract_amount_original numeric(16,2),
    original_contract_amount numeric(16,2),
    registered_date_id int,
    oca_number character varying(20),
    number_solicitation integer,
    document_name character varying(60),
    original_term_begin_date_id int,
    original_term_end_date_id int,    
    brd_awd_no varchar,
    rfed_amount_original numeric(16,2),
    rfed_amount numeric(16,2),
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
)WITH(appendonly=true ,orientation=column)
distributed by (agreement_id);

--
-- Name: history_agreement_accounting_line; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE history_agreement_accounting_line (
    agreement_accounting_line_id bigint,
    agreement_id bigint,
    commodity_line_number integer,
    line_number integer,
    event_type_code char(4),
    description character varying(100),
    line_amount_original numeric(16,2),
    line_amount numeric(16,2),
    budget_fiscal_year smallint,
    fiscal_year smallint,
    fiscal_period character(2),
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    expenditure_object_history_id integer,
    revenue_source_id int,
    location_code character varying(4),
    budget_code_id integer,
    reporting_code character varying(15),
    rfed_line_amount_original numeric(16,2),
    rfed_line_amount numeric(16,2),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
)WITH(appendonly=true) 
distributed by (agreement_id);

--
-- Name: history_agreement_commodity; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE history_agreement_commodity (
    agreement_commodity_id bigint  ,
    agreement_id bigint,
    line_number integer,
    master_agreement_yn character(1),
    description character varying(60),
    commodity_code character varying(14),
    commodity_type_id integer,
    quantity numeric(27,5),
    unit_of_measurement character varying(4),
    unit_price numeric(28,6),
    contract_amount numeric(16,2),
    commodity_specification character varying,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (agreement_id);



--
-- Name: history_agreement_worksite; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE history_agreement_worksite (
    agreement_worksite_id bigint,
    agreement_id bigint,
    worksite_code varchar(3),
    percentage numeric(17,4),
    amount numeric(17,4),
    master_agreement_yn character(1),
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (agreement_id);

--
-- Name: history_master_agreement; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE history_master_agreement
(
  master_agreement_id bigint,
  document_code_id smallint,
  agency_history_id smallint,
  document_id character varying(20),
  document_version integer,
  tracking_number character varying(30),
  record_date_id int,
  budget_fiscal_year smallint,
  document_fiscal_year smallint,
  document_period character(2),
  description character varying(60),
  actual_amount_original numeric(16,2),
  actual_amount numeric(16,2),
  total_amount_original numeric(16,2),
  total_amount numeric(16,2),
  replacing_master_agreement_id bigint,
  replaced_by_master_agreement_id bigint,
  award_status_id smallint,
  procurement_id character varying(20),
  procurement_type_id smallint,
  effective_begin_date_id int,
  effective_end_date_id int,
  reason_modification character varying,
  source_created_date_id int,
  source_updated_date_id int,
  document_function_code character varying,
  award_method_id smallint,
  agreement_type_id smallint,
  award_category_id_1 smallint,
  award_category_id_2 smallint,
  award_category_id_3 smallint,
  award_category_id_4 smallint,
  award_category_id_5 smallint,
  number_responses integer,
  location_service character varying(255),
  location_zip character varying(10),
  borough_code character varying(10),
  block_code character varying(10),
  lot_code character varying(10),
  council_district_code character varying(10),
  vendor_history_id integer,
  vendor_preference_level integer,
  board_approved_award_no character varying(15),
  board_approved_award_date_id int,
  original_contract_amount_original numeric(20,2),
  original_contract_amount numeric(20,2),
  oca_number character varying(20),
  original_term_begin_date_id int,
  original_term_end_date_id int,
  registered_date_id int,
  maximum_amount_original numeric(20,2),
  maximum_amount numeric(20,2),
  maximum_spending_limit_original numeric(20,2),
  maximum_spending_limit numeric(20,2),
  award_level_code character(2),
  contract_class_code character varying(2),
  number_solicitation integer,
  document_name character varying(60),
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
  updated_date timestamp without time zone)
DISTRIBUTED BY (master_agreement_id);

--
-- Name: ref_address_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_address_type (
    address_type_id smallint NOT NULL,
    address_type_code character varying(2),
    address_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (address_type_id);

--
-- Name: ref_agency; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_agency (
    agency_id smallint NOT NULL,
    agency_code character varying(20),
    agency_name character varying(100),
    agency_short_name character varying(15),
    original_agency_name character varying(100),
    is_display char(1) ,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) DISTRIBUTED BY (agency_id);

--
-- Name: ref_agency_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_agency_history (
    agency_history_id smallint NOT NULL,
    agency_id smallint,
    agency_name character varying(100),
    agency_short_name character varying(15),
    created_date timestamp without time zone,
    load_id integer
) DISTRIBUTED BY (agency_history_id);

--
-- Name: ref_agreement_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_agreement_type (
    agreement_type_id smallint NOT NULL,
    agreement_type_code character varying(2),
    agreement_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (agreement_type_id);

--
-- Name: ref_award_category; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_award_category (
    award_category_id smallint NOT NULL,
    award_category_code character varying(10),
    award_category_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (award_category_id);

--
-- Name: ref_award_method; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_award_method (
    award_method_id smallint NOT NULL,
    award_method_code character varying(3),
    award_method_name character varying,
    created_date timestamp without time zone
) DISTRIBUTED BY (award_method_id);

--
-- Name: ref_budget_code; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_budget_code (
    budget_code_id integer NOT NULL,
    fiscal_year smallint,
    budget_code character varying(10),
    agency_id smallint,
    fund_class_id smallint,
    budget_code_name character varying(60),
    attribute_name character varying(60),
    attribute_short_name character varying(15),
    responsibility_center character varying(4),
    control_category character varying(4),
    ua_funding_flag bit(1),
    payroll_default_flag bit(1),
    budget_function character varying(5),
    description character varying,
    created_date timestamp without time zone,
    load_id integer,
    updated_date timestamp without time zone,
    updated_load_id integer
) DISTRIBUTED BY (budget_code_id);

--
-- Name: ref_business_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_business_type (
    business_type_id smallint NOT NULL,
    business_type_code character varying(4),
    business_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (business_type_id);

--
-- Name: ref_business_type_status; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_business_type_status (
    business_type_status_id smallint NOT NULL,
    business_type_status character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (business_type_status_id);

--
-- Name: ref_data_source; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--
/*
CREATE TABLE ref_data_source (
    data_source_code character varying(2),
    description character varying(40),
    created_date timestamp without time zone
) DISTRIBUTED BY (data_source_code);
*/
--
-- Name: ref_date; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_date (
    date_id int NOT NULL,
    date date,
    nyc_year_id smallint,
    calendar_month_id int
) DISTRIBUTED BY (date_id);

--
-- Name: ref_department; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_department (
    department_id integer NOT NULL,
    department_code character varying(20),
    department_name character varying(100),
    department_short_name character varying(15),
    agency_id smallint,
    fund_class_id smallint,
    fiscal_year smallint,
    original_department_name character varying(50),
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
)WITH(appendonly=true) 
DISTRIBUTED BY (department_id);

--
-- Name: ref_department_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_department_history (
    department_history_id integer NOT NULL,
    department_id integer,
    department_name character varying(100),
    department_short_name character varying,
    agency_id smallint,
    fund_class_id smallint,
    fiscal_year smallint,
    created_date timestamp without time zone,
    load_id integer
) DISTRIBUTED BY (department_history_id);

--
-- Name: ref_document_code; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_document_code (
    document_code_id smallint NOT NULL,
    document_code character varying(8),
    document_name character varying(100),
    created_date timestamp without time zone
) DISTRIBUTED BY (document_code_id);


--
-- Name: ref_expenditure_cancel_reason; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_expenditure_cancel_reason (
    expenditure_cancel_reason_id smallint NOT NULL,
    expenditure_cancel_reason_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (expenditure_cancel_reason_id);

--
-- Name: ref_expenditure_cancel_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_expenditure_cancel_type (
    expenditure_cancel_type_id smallint NOT NULL,
    expenditure_cancel_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (expenditure_cancel_type_id);

--
-- Name: ref_expenditure_object; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_expenditure_object (
    expenditure_object_id integer NOT NULL,
    expenditure_object_code character varying(4),
    expenditure_object_name character varying(40),
    fiscal_year smallint,
    original_expenditure_object_name character varying(40),
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) DISTRIBUTED BY (expenditure_object_id);

--
-- Name: ref_expenditure_object_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_expenditure_object_history (
    expenditure_object_history_id integer NOT NULL,
    expenditure_object_id integer,
    expenditure_object_name character varying(40),
    fiscal_year smallint,
    created_date timestamp without time zone,
    load_id integer
) DISTRIBUTED BY (expenditure_object_history_id);

--
-- Name: ref_expenditure_privacy_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_expenditure_privacy_type (
    expenditure_privacy_type_id smallint NOT NULL,
    expenditure_privacy_code character varying(1),
    expenditure_privacy_name character varying(20),
    created_date timestamp without time zone
) DISTRIBUTED BY (expenditure_privacy_type_id);

--
-- Name: ref_expenditure_status; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_expenditure_status (
    expenditure_status_id smallint NOT NULL,
    expenditure_status_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (expenditure_status_id);


--
-- Name: ref_fund_class; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_fund_class (
    fund_class_id smallint NOT NULL,
    fund_class_code character varying(5),
    fund_class_name character varying(50),
    created_load_id integer,
    created_date timestamp without time zone
) DISTRIBUTED BY (fund_class_id);

--
-- Name: ref_funding_class; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_funding_class (
    funding_class_id smallint NOT NULL,
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
) DISTRIBUTED BY (funding_class_id);

--
-- Name: ref_funding_source; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_funding_source (
    funding_source_id smallint NOT NULL,
    funding_source_code character varying(5),
    funding_source_name character varying(20),
    created_date timestamp without time zone
) DISTRIBUTED BY (funding_source_id);

--
-- Name: ref_location; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_location (
    location_id integer NOT NULL,
    location_code character varying(4),
    agency_id smallint,
    location_name character varying(60),
    location_short_name character varying(16),
    original_location_name character varying(60),
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) DISTRIBUTED BY (location_id);

--
-- Name: ref_location_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_location_history (
    location_history_id integer NOT NULL,
    location_id integer,
    agency_id smallint,
    location_name character varying(60),
    location_short_name character varying(16),
    created_date timestamp without time zone,
    load_id integer
) DISTRIBUTED BY (location_history_id);

--
-- Name: ref_minority_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_minority_type (
    minority_type_id smallint NOT NULL,
    minority_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (minority_type_id);

--
-- Name: ref_miscellaneous_vendor; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_miscellaneous_vendor (
    misc_vendor_id smallint NOT NULL,
    vendor_customer_code character varying(20),
    created_date timestamp without time zone
) DISTRIBUTED BY (misc_vendor_id);

--
-- Name: ref_month; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_month (
    month_id int NOT NULL,
    month_value smallint,
    month_name character varying,
    year_id smallint,
    display_order smallint,
    month_short_name varchar(3)
) DISTRIBUTED BY (month_id);

--
-- Name: ref_object_class; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_object_class (
    object_class_id integer NOT NULL,
    object_class_code character varying(4),
    object_class_name character varying(60),
    object_class_short_name character varying(15),
    active_flag bit(1),
    effective_begin_date_id int,
    effective_end_date_id int,
    budget_allowed_flag bit(1),
    description character varying(100),
    source_updated_date timestamp without time zone,
    intra_city_flag bit(1),
    contracts_positions_flag bit(1),
    payroll_type integer,
    extended_description character varying,
    related_object_class_code character varying(4),
    original_object_class_name character varying(60),
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) DISTRIBUTED BY (object_class_id);

--
-- Name: ref_object_class_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_object_class_history (
    object_class_history_id integer NOT NULL,
    object_class_id integer,
    object_class_name character varying(60),
    object_class_short_name character varying(15),
    active_flag bit(1),
    effective_begin_date_id int,
    effective_end_date_id int,
    budget_allowed_flag bit(1),
    description character varying(100),
    source_updated_date timestamp without time zone,
    intra_city_flag bit(1),
    contracts_positions_flag bit(1),
    payroll_type integer,
    extended_description character varying,
    related_object_class_code character varying(4),
    created_date timestamp without time zone,
    load_id integer
) DISTRIBUTED BY (object_class_history_id);

--
-- Name: ref_revenue_category; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_revenue_category (
    revenue_category_id smallint NOT NULL,
    revenue_category_code character varying(4),
    revenue_category_name character varying(60),
    revenue_category_short_name character varying(15),
    active_flag bit(1),
    budget_allowed_flag bit(1),
    description character varying(100),
    created_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer,
    updated_date timestamp without time zone
) DISTRIBUTED BY (revenue_category_id);

--
-- Name: ref_revenue_class; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_revenue_class (
    revenue_class_id smallint NOT NULL,
    revenue_class_code character varying(4) DEFAULT '0'::character varying NOT NULL,
    revenue_class_name character varying(60),
    revenue_class_short_name character varying(15),
    active_flag bit(1),
    budget_allowed_flag bit(1),
    description character varying(100),
    created_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer,
    updated_date timestamp without time zone
) DISTRIBUTED BY (revenue_class_id);

--
-- Name: ref_revenue_source; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_revenue_source (
    revenue_source_id int NOT NULL,
    fiscal_year smallint,
    revenue_source_code character varying(5),
    revenue_source_name character varying(60),
    revenue_source_short_name character varying(15),
    description character varying(100),
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
    earned_receivable_code character varying(4),
    finance_fee_override_flag integer,
    allow_override_interest integer,
    billing_lag_days integer,
    billing_frequency integer,
    billing_fiscal_year_start_month smallint,
    billing_fiscal_year_start_day smallint,
    federal_agency_code character varying(2),
    federal_agency_suffix character varying(3),
    federal_name character varying(60),
    srsrc_req character(1),
    created_date timestamp without time zone,
    updated_load_id integer,
    updated_date timestamp without time zone,
    created_load_id integer
) DISTRIBUTED BY (revenue_source_id);

--
-- Name: ref_spending_category; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_spending_category (
    spending_category_id smallint NOT NULL,
    spending_category_code character varying(2),
    spending_category_name character varying(100),
    display_name character varying(100),
    display_order smallint
) DISTRIBUTED BY (spending_category_id);


--
-- Name: ref_year; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_year (
    year_id smallint NOT NULL,
    year_value smallint
) DISTRIBUTED BY (year_id);

--
-- Name: revenue; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE revenue (
    revenue_id bigint NOT NULL,
    record_date_id int,
    fiscal_period character(2),
    fiscal_year smallint,
    budget_fiscal_year smallint,
    fiscal_quarter smallint,
    event_category character varying(4),
    event_type character varying(4),
    bank_account_code character varying(4),
    posting_pair_type character varying(1),
    posting_code character varying(4),
    debit_credit_indicator character varying(1),
    line_function smallint,
    posting_amount_original numeric(16,2),
    posting_amount numeric(16,2),
    increment_decrement_indicator character varying(1),
    time_of_occurence timestamp without time zone,
    balance_sheet_account_code character varying(4),
    balance_sheet_account_type smallint,
    expenditure_object_history_id integer,
    government_branch_code character varying(4),
    cabinet_code character varying(4),
    agency_history_id smallint,
    department_history_id integer,
    reporting_activity_code character varying(10),
    budget_code_id integer,
    fund_category character varying(4),
    fund_type character varying(4),
    fund_group character varying(4),
    balance_sheet_account_class_code character varying(4),
    balance_sheet_account_category_code character varying(4),
    balance_sheet_account_group_code character varying(4),
    balance_sheet_account_override_flag character(1),
    object_class_history_id integer,
    object_category_code character varying(4),
    object_type_code character varying(4),
    object_group_code character varying(4),
    document_category character varying(8),
    document_type character varying(8),
    document_code_id smallint,
    document_agency_history_id smallint,
    document_id character varying(20),
    document_version_number integer,
    document_function_code_id smallint,
    document_unit character varying(8),
    commodity_line integer,
    accounting_line integer,
    document_posting_line integer,
    ref_document_code_id smallint,
    ref_document_agency_history_id smallint,
    ref_document_id character varying(20),
    ref_commodity_line integer,
    ref_accounting_line integer,
    ref_posting_line integer,
    reference_type smallint,
    line_description character varying(100),
    service_start_date_id int,
    service_end_date_id int,
    reason_code character varying(8),
    reclassification_flag integer,
    closing_classification_code character varying(2),
    closing_classification_name character varying(45),
    revenue_category_id smallint,
    revenue_class_id smallint,
    revenue_source_id int,
    funding_source_id smallint,
    fund_class_id smallint,
    reporting_code character varying(15),
    major_cafr_revenue_type character varying(4),
    minor_cafr_revenue_type character varying(4),
    vendor_history_id integer,
    fiscal_year_id smallint,
    budget_fiscal_year_id smallint,    
    load_id integer,
    created_date timestamp without time zone  
) DISTRIBUTED BY (revenue_id);


CREATE TABLE ref_fiscal_period(
	fiscal_period smallint,
	fiscal_period_name varchar
)
DISTRIBUTED BY (fiscal_period);

CREATE TABLE ref_pay_frequency(
	pay_frequency_id smallint,
	pay_frequency varchar
)
DISTRIBUTED BY (pay_frequency);


CREATE TABLE aggregateon_revenue_category_funding_class(
	revenue_category_id smallint,
	funding_class_id smallint,
	funding_class_code character varying,
	agency_id character varying,
	budget_fiscal_year_id smallint,
	posting_amount numeric(16,2),
	adopted_amount numeric(16,2),
	current_modified_amount numeric(16,2))
DISTRIBUTED BY (revenue_category_id);	



--
-- Name: vendor; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE vendor (
    vendor_id integer NOT NULL,
    vendor_customer_code character varying(20),
    legal_name character varying(60),
    alias_name character varying(60),
    miscellaneous_vendor_flag bit(1),
    vendor_sub_code integer,
    display_flag character(1) DEFAULT 'Y'::bpchar,
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (vendor_id);

--
-- Name: vendor_address; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE vendor_address (
    vendor_address_id bigint NOT NULL,
    vendor_history_id integer,
    address_id integer,
    address_type_id smallint,
    effective_begin_date_id int,
    effective_end_date_id int,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (vendor_address_id);

--
-- Name: vendor_business_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE vendor_business_type (
    vendor_business_type_id bigint NOT NULL,
    vendor_history_id integer,
    business_type_id smallint,
    status smallint,
    minority_type_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (vendor_business_type_id);

--
-- Name: vendor_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE vendor_history (
    vendor_history_id integer NOT NULL,
    vendor_id integer,
    legal_name character varying(60),
    alias_name character varying(60),
    miscellaneous_vendor_flag bit(1),
    vendor_sub_code integer,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (vendor_history_id);


CREATE TABLE vendor_details (
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
	state			character(2),
	zip			character varying(10),
	country			character(3),
	status			smallint,
	business_type_id	smallint,
	business_type_code	character varying(4),
	business_type_name	character varying(50),
	minority_type_id	smallint,
	minority_type_name	character varying(50)
)
DISTRIBUTED BY (vendor_history_id);


CREATE TABLE ref_amount_basis (
  amount_basis_id smallint,
  amount_basis_name varchar(50) ,
  created_date timestamp 
) DISTRIBUTED BY (amount_basis_id);

CREATE TABLE employee (
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
  DISTRIBUTED BY (employee_id);
  
CREATE TABLE employee_history (
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
  DISTRIBUTED BY (employee_history_id);


CREATE TABLE payroll(
	payroll_id bigint,
	pay_cycle_code CHAR(1),
	pay_date_id int,
	employee_history_id bigint,
	employee_number varchar(10),
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
) WITH (appendonly=true,orientation=column)
DISTRIBUTED BY (payroll_id)
PARTITION BY RANGE (calendar_fiscal_year) 
(START (2010) END (2014) EVERY (1),
DEFAULT PARTITION outlying_years);

CREATE TABLE payroll_summary (
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
) distributed by (payroll_summary_id);

CREATE TABLE aggregateon_payroll_employee_agency(
	employee_id bigint,
	agency_id smallint,
	fiscal_year_id smallint,
	type_of_year char(1),
	pay_frequency varchar,
	type_of_employment varchar,
	employee_number varchar(10),
	start_date date,	
	annual_salary numeric(16,2),
	base_pay numeric(16,2),
	overtime_pay numeric(16,2),
	other_payments numeric(16,2),
	gross_pay numeric(16,2)
	)WITH(appendonly=true)
DISTRIBUTED BY (employee_id);

CREATE TABLE aggregateon_payroll_agency(	
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
DISTRIBUTED BY (agency_id);


CREATE TABLE aggregateon_payroll_coa_month(	
	agency_id smallint,
	department_id integer,
	fiscal_year_id smallint,
	month_id int,
	type_of_year char(1),	
	base_pay numeric(16,2),
	overtime_pay numeric(16,2),
	other_payments numeric(16,2),
	gross_pay numeric(16,2) )
DISTRIBUTED BY (agency_id);

CREATE TABLE aggregateon_payroll_year(	
	fiscal_year_id smallint,
	type_of_year char(1),	
	total_employees int,
	total_salaried_employees int,
	total_hourly_employees int,
	total_overtime_employees int)
DISTRIBUTED BY (fiscal_year_id);


/* payroll aggregate tables for month_id */

CREATE TABLE aggregateon_payroll_employee_agency_month(
	employee_id bigint,
	agency_id smallint,
	fiscal_year_id smallint,
	type_of_year char(1),
	month_id int,
	pay_frequency varchar,
	type_of_employment varchar,
	employee_number varchar(10),
	start_date date,	
	annual_salary numeric(16,2),
	base_pay numeric(16,2),
	overtime_pay numeric(16,2),
	other_payments numeric(16,2),
	gross_pay numeric(16,2)
	)WITH (appendonly=true,orientation=column)
DISTRIBUTED BY (employee_id);

CREATE TABLE aggregateon_payroll_agency_month(	
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
DISTRIBUTED BY (agency_id);


CREATE TABLE aggregateon_payroll_year_and_month(	
	fiscal_year_id smallint,
	type_of_year char(1),
	month_id int,
	total_employees int,
	total_salaried_employees int,
	total_hourly_employees int,
	total_overtime_employees int)
DISTRIBUTED BY (fiscal_year_id);


CREATE TABLE revenue_budget
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
  revenue_source_id int,
  agency_name character varying,
  agency_short_name character varying,
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
DISTRIBUTED BY (budget_id);



-- Contracts Aggregate Tables

 CREATE TABLE agreement_snapshot_expanded(
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
	master_agreement_yn character(1),
	status_flag char(1)
	)WITH(appendonly=true)
DISTRIBUTED BY (original_agreement_id);	


CREATE TABLE agreement_snapshot_expanded_cy(
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
	master_agreement_yn character(1),
	status_flag char(1)
	)
DISTRIBUTED BY (original_agreement_id);	


CREATE TABLE aggregateon_contracts_cumulative_spending(
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
) DISTRIBUTED BY (vendor_id);	


CREATE TABLE aggregateon_contracts_spending_by_month(
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
) DISTRIBUTED BY (vendor_id);	



CREATE TABLE aggregateon_total_contracts(
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
) DISTRIBUTED BY (fiscal_year);	


CREATE TABLE aggregateon_contracts_department(
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
) DISTRIBUTED BY (department_id);	

CREATE TABLE contracts_spending_transactions(
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
)WITH (appendonly=true,orientation=column)
DISTRIBUTED BY (disbursement_line_item_id)
PARTITION BY RANGE (fiscal_year) 
(START (2010) END (2015) EVERY (1),
DEFAULT PARTITION outlying_years);


CREATE TABLE aggregateon_contracts_expense(
	original_agreement_id bigint,
	expenditure_object_code character varying(4),
	expenditure_object_name character varying(40),
	encumbered_amount numeric(16,2),
	spending_amount_disb numeric(16,2),
	spending_amount numeric(16,2),
	is_disbursements_exist char(1)
) DISTRIBUTED BY (original_agreement_id);	

-- End Contract Aggregate Tables


CREATE TABLE agreement_snapshot(
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
	  master_agreement_yn character(1),
	  has_children character(1),
	  original_version_flag character(1),
  	  latest_flag character(1),
  	  load_id integer,
          last_modified_date timestamp without time zone,
          job_id bigint
)WITH(appendonly=true,orientation=column) 
DISTRIBUTED BY (original_agreement_id);

CREATE TABLE agreement_snapshot_cy (LIKE agreement_snapshot) DISTRIBUTED BY (original_agreement_id);

 CREATE TABLE pending_contracts(
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
  	latest_flag char(1)
 ) DISTRIBUTED BY (document_code_id);
 
 -- tables for contracts by industry and contracts by size
 
 CREATE TABLE ref_industry_type (
    industry_type_id smallint NOT NULL,
    industry_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (industry_type_id);
 
 CREATE TABLE ref_award_size (
    award_size_id smallint NOT NULL,
    award_size_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (award_size_id);

CREATE TABLE ref_award_category_industry (
    award_category_industry_id smallint NOT NULL,
    award_category_code character varying(10),
    industry_type_id smallint,
    created_date timestamp without time zone
) DISTRIBUTED BY (award_category_industry_id);

 ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- creating indexes
 
 CREATE INDEX idx_original_agreement_id_history_agreement ON history_agreement(original_agreement_id);
 CREATE INDEX idx_master_agreement_id_history_agreement ON history_agreement(master_agreement_id);
 CREATE INDEX idx_latest_flag_history_agreement ON history_agreement(latest_flag);
 
 
 CREATE INDEX idx_original_master_agreement_id_history_master_agreement ON history_master_agreement(original_master_agreement_id);
 CREATE INDEX idx_latest_flag_history_master_agreement ON history_master_agreement(latest_flag);
 
 CREATE INDEX idx_agreement_id_disbursement_line_item_details ON disbursement_line_item_details(agreement_id);
 
 CREATE INDEX idx_agreement_id_disbursement_line_item ON disbursement_line_item(agreement_id);
 
 -- 10/12/2012
 
 CREATE INDEX idx_ma_agreement_id_disbursement_line_item_details ON disbursement_line_item_details(master_agreement_id);
 
 CREATE INDEX idx_disb_agreement_id_contracts_spending_transactions ON contracts_spending_transactions(disb_agreement_id);
 
 CREATE INDEX idx_orig_agr_id_aggregateon_contracts_cumulative_spending ON aggregateon_contracts_cumulative_spending(original_agreement_id);
 
 
 -- 11/01/2012
 
 CREATE INDEX idx_fiscal_year_id_contracts_spending_transactions ON contracts_spending_transactions(fiscal_year_id);
 CREATE INDEX idx_disb_fiscal_year_id_contracts_spending_transactions ON contracts_spending_transactions(disb_fiscal_year_id);
 CREATE INDEX idx_disb_cont_doc_code_contracts_spending_transactions ON contracts_spending_transactions(disb_contract_document_code);
 CREATE INDEX idx_document_agency_id_contracts_spending_transactions ON contracts_spending_transactions(document_agency_id);
 CREATE INDEX idx_disb_cal_month_id_contracts_spending_transactions ON contracts_spending_transactions(disb_check_eft_issued_cal_month_id);
 CREATE INDEX idx_document_code_id_contracts_spending_transactions ON contracts_spending_transactions(document_code_id);
    
 
 -- 12/11/2012
 
 CREATE INDEX idx_employee_id_employee_history ON employee_history(employee_id);
 CREATE INDEX idx_employee_id_payroll ON payroll(employee_id);
 CREATE INDEX idx_employee_number_payroll ON payroll(employee_number);
  CREATE INDEX idx_agency_id_payroll ON payroll(agency_id);
 CREATE INDEX idx_amount_basis_id_payroll ON payroll(amount_basis_id);
 CREATE INDEX idx_fiscal_year_idpayroll ON payroll(fiscal_year_id);
 CREATE INDEX idx_calendar_fiscal_year_id_payroll ON payroll(calendar_fiscal_year_id);
 
 
 
 CREATE INDEX idx_agency_id_agg_payroll_employee_agency ON aggregateon_payroll_employee_agency(agency_id);
 CREATE INDEX idx_fiscal_year_id_agg_payroll_employee_agency ON aggregateon_payroll_employee_agency(fiscal_year_id);
 CREATE INDEX idx_type_of_employment_agg_payroll_employee_agency ON aggregateon_payroll_employee_agency(type_of_employment);
   
 CREATE INDEX idx_fiscal_year_id_agg_payroll_agency ON aggregateon_payroll_agency(fiscal_year_id);
 
 CREATE INDEX idx_department_id_agg_payroll_coa_month ON aggregateon_payroll_coa_month(department_id);
 CREATE INDEX idx_fiscal_year_id_agg_payroll_coa_month ON aggregateon_payroll_coa_month(fiscal_year_id);
 
 
 CREATE INDEX idx_agency_id_agg_payroll_employee_agency_month ON aggregateon_payroll_employee_agency_month(agency_id);
 CREATE INDEX idx_fiscal_year_id_agg_payroll_employee_agency_month ON aggregateon_payroll_employee_agency_month(fiscal_year_id);
 CREATE INDEX idx_month_id_agg_payroll_employee_agency_month ON aggregateon_payroll_employee_agency_month(month_id);
 CREATE INDEX idx_type_of_employment_agg_payroll_employee_agency_month ON aggregateon_payroll_employee_agency_month(type_of_employment);
   
 CREATE INDEX idx_fiscal_year_id_agg_payroll_agency_month ON aggregateon_payroll_agency_month(fiscal_year_id);
 CREATE INDEX idx_month_id_agg_payroll_agency_month ON aggregateon_payroll_agency_month(month_id);
 
 CREATE INDEX idx_month_id_agg_payroll_year_and_month ON aggregateon_payroll_year_and_month(month_id);
 
 -- 03/21/2013
 
 CREATE INDEX idx_agency_id_disbursement_line_item_details ON disbursement_line_item_details USING btree (agency_id);
 CREATE INDEX idx_check_eft_nyc_year_id_disbursement_line_item_details ON disbursement_line_item_details USING btree (check_eft_issued_nyc_year_id);