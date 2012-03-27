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


ALTER FUNCTION public.grantaccess(username character varying, privilege character varying) OWNER TO athiagarajan;

--
-- Name: seq_address_address_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_address_address_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_address_address_id OWNER TO gpadmin;

SET default_tablespace = '';

--
-- Name: address; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE address (
    address_id integer DEFAULT nextval('seq_address_address_id'::regclass) NOT NULL,
    address_line_1 character varying(75),
    address_line_2 character varying(75),
    city character varying(60),
    state character(2),
    zip character varying(10),
    country character(3)
) DISTRIBUTED BY (address_id);


ALTER TABLE public.address OWNER TO gpadmin;

--
-- Name: aggregateon_spending_coa_entities; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE aggregateon_spending_coa_entities (
    department_id integer,
    agency_id smallint,
    spending_category_id smallint,
    expenditure_object_id integer,
    month_id smallint,
    year_id smallint,
    total_spending_amount numeric(16,2),
    total_contract_amount numeric(16,2)
) DISTRIBUTED BY (department_id);


ALTER TABLE public.aggregateon_spending_coa_entities OWNER TO gpadmin;

--
-- Name: aggregateon_spending_contract; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE aggregateon_spending_contract (
    agreement_id bigint,
    document_id character varying(20),
    vendor_id integer,
    agency_id smallint,
    description character varying(60),
    year_id smallint,
    total_spending_amount numeric(16,2),
    total_contract_amount numeric(16,2)
) DISTRIBUTED BY (agreement_id);


ALTER TABLE public.aggregateon_spending_contract OWNER TO gpadmin;

--
-- Name: aggregateon_spending_vendor; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE aggregateon_spending_vendor (
    vendor_id integer,
    agency_id smallint,
    year_id smallint,
    total_spending_amount numeric(16,2),
    total_contract_amount numeric(16,2)
) DISTRIBUTED BY (vendor_id);


ALTER TABLE public.aggregateon_spending_vendor OWNER TO gpadmin;

--
-- Name: seq_agreement_agreement_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_agreement_agreement_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_agreement_agreement_id OWNER TO gpadmin;

--
-- Name: agreement; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE agreement (
    agreement_id bigint DEFAULT nextval('seq_agreement_agreement_id'::regclass) NOT NULL,
    master_agreement_id bigint,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying(20),
    document_version integer,
    tracking_number character varying(30),
    record_date_id smallint,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period character(2),
    description character varying(60),
    actual_amount numeric(16,2),
    obligated_amount numeric(16,2),
    maximum_contract_amount numeric(16,2),
    amendment_number character varying(19),
    replacing_agreement_id bigint,
    replaced_by_agreement_id bigint,
    award_status_id smallint,
    procurement_id character varying(20),
    procurement_type_id smallint,
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
    reason_modification character varying,
    source_created_date_id smallint,
    source_updated_date_id smallint,
    document_function_code_id smallint,
    award_method_id smallint,
    award_level_id smallint,
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
    original_contract_amount numeric(16,2),
    registered_date_id smallint,
    oca_number character varying(20),
    number_solicitation integer,
    document_name character varying(60),
    original_term_begin_date_id smallint,
    original_term_end_date_id smallint,
    privacy_flag character(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (agreement_id);


ALTER TABLE public.agreement OWNER TO athiagarajan;

--
-- Name: agreement__0; Type: EXTERNAL TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE EXTERNAL WEB TABLE agreement__0 (
    agreement_id bigint,
    master_agreement_id bigint,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying,
    document_version integer,
    tracking_number character varying,
    record_date_id smallint,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period bpchar,
    description character varying,
    actual_amount numeric,
    obligated_amount numeric,
    maximum_contract_amount numeric,
    amendment_number character varying,
    replacing_agreement_id bigint,
    replaced_by_agreement_id bigint,
    award_status_id smallint,
    procurement_id character varying,
    procurement_type_id smallint,
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
    reason_modification character varying,
    source_created_date_id smallint,
    source_updated_date_id smallint,
    document_function_code_id smallint,
    award_method_id smallint,
    award_level_id smallint,
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
    original_contract_amount numeric,
    registered_date_id smallint,
    oca_number character varying,
    number_solicitation integer,
    document_name character varying,
    original_term_begin_date_id smallint,
    original_term_end_date_id smallint,
    privacy_flag bpchar,
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE public.agreement__0 OWNER TO athiagarajan;

--
-- Name: agreement_accounting_line; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE agreement_accounting_line (
    agreement_accounting_line_id bigint NOT NULL,
    agreement_id bigint,
    line_number integer,
    event_type_id smallint,
    description character varying(100),
    line_amount numeric(16,2),
    budget_fiscal_year smallint,
    fiscal_year smallint,
    fiscal_period character(2),
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    expenditure_object_history_id integer,
    revenue_source_id smallint,
    location_code character varying(4),
    budget_code_id integer,
    reporting_code character varying(15),
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (agreement_id);


ALTER TABLE public.agreement_accounting_line OWNER TO gpadmin;

--
-- Name: agreement_commodity; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE agreement_commodity (
    agreement_commodity_id bigint NOT NULL,
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
) DISTRIBUTED BY (agreement_id);


ALTER TABLE public.agreement_commodity OWNER TO gpadmin;

--
-- Name: agreement_worksite; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE agreement_worksite (
    agreement_worksite_id bigint NOT NULL,
    agreement_id bigint,
    worksite_id integer,
    percentage numeric(17,4),
    amount numeric(17,4),
    master_agreement_yn character(1),
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (agreement_id);


ALTER TABLE public.agreement_worksite OWNER TO gpadmin;

--
-- Name: seq_budget_budget_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_budget_budget_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_budget_budget_id OWNER TO gpadmin;

--
-- Name: budget; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE budget (
    budget_id integer DEFAULT nextval('seq_budget_budget_id'::regclass) NOT NULL,
    budget_fiscal_year smallint,
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    budget_code_id integer,
    object_class_history_id integer,
    adopted_amount numeric(20,2),
    current_budget_amount numeric(20,2),
    pre_encumbered_amount numeric(20,2),
    encumbered_amount numeric(20,2),
    accrued_expense_amount numeric(20,2),
    cash_expense_amount numeric(20,2),
    post_closing_adjustment_amount numeric(20,2),
    total_expenditure_amount numeric(20,2),
    source_updated_date_id smallint,
    budget_fiscal_year_id smallint,
    agency_id smallint,
    object_class_id integer,
    department_id integer,        
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (budget_id);


ALTER TABLE public.budget OWNER TO gpadmin;

--
-- Name: disbursement; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE disbursement (
    disbursement_id integer NOT NULL,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying(20),
    document_version integer,
    record_date_id smallint,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period character(2),
    check_eft_amount numeric(16,2),
    check_eft_issued_date_id smallint,
    check_eft_record_date_id smallint,
    expenditure_status_id smallint,
    expenditure_cancel_type_id smallint,
    expenditure_cancel_reason_id integer,
    total_accounting_line_amount numeric(16,2),
    vendor_history_id integer,
    retainage_amount numeric(16,2),
    privacy_flag character(1),
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (disbursement_id);


ALTER TABLE public.disbursement OWNER TO gpadmin;

--
-- Name: disbursement_line_item; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE disbursement_line_item (
    disbursement_line_item_id bigint NOT NULL,
    disbursement_id integer,
    line_number integer,
    budget_fiscal_year smallint,
    fiscal_year smallint,
    fiscal_period character(2),
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    expenditure_object_history_id integer,
    budget_code_id integer,
    fund_id smallint,
    reporting_code character varying(15),
    check_amount numeric(16,2),
    agreement_id bigint,
    agreement_accounting_line_number integer,
    location_history_id integer,
    retainage_amount numeric(16,2),
    check_eft_issued_nyc_year_id smallint,
    created_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    updated_load_id integer
) DISTRIBUTED BY (disbursement_line_item_id);


ALTER TABLE public.disbursement_line_item OWNER TO gpadmin;

--
-- Name: fact_agreement; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE fact_agreement (
    agreement_id bigint,
    master_agreement_id bigint,
    document_code_id smallint,
    agency_id smallint,
    document_id character varying(20),
    document_version integer,
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
    registered_date_id smallint,
    maximum_contract_amount numeric(16,2),
    award_method_id smallint,
    vendor_id integer,
    original_contract_amount numeric(16,2),
    master_agreement_yn character(1),
    description character varying(60),
    	document_code varchar,
    	master_document_id  varchar,
    	amount_spent numeric(16,2),
    	agency_history_id smallint,
    	agency_name varchar,
    	vendor_history_id integer,
    	vendor_name varchar,
    	worksites_name varchar,
    	agreement_type_id smallint,
    	award_category_id_1 smallint,
    	expenditure_objects_name varchar,
    	record_date date,
    	effective_begin_date date,
    	effective_end_date date,
	tracking_number varchar,
	registered_date date,
	has_parent_yn char(1)
) DISTRIBUTED BY (agreement_id);


ALTER TABLE public.fact_agreement OWNER TO gpadmin;

--
-- Name: fact_agreement_accounting_line; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE fact_agreement_accounting_line (
    agreement_id bigint,
    line_amount numeric(16,2)
) DISTRIBUTED BY (agreement_id);


ALTER TABLE public.fact_agreement_accounting_line OWNER TO gpadmin;

--
-- Name: fact_disbursement_line_item; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE fact_disbursement_line_item (
    disbursement_line_item_id bigint,
    disbursement_id integer,
    line_number integer,
    check_eft_issued_date_id smallint,
    check_eft_issued_nyc_year_id smallint,
    check_eft_issued_cal_month_id smallint,
    agreement_id bigint,
    master_agreement_id bigint,
    fund_class_id smallint,
    check_amount numeric(16,2),
    agency_id smallint,
    expenditure_object_id integer,
    vendor_id integer,
    department_id integer,
    maximum_contract_amount numeric(16,2),
    maximum_spending_limit numeric(16,2)    
) DISTRIBUTED BY (disbursement_line_item_id);


ALTER TABLE public.fact_disbursement_line_item OWNER TO gpadmin;

--
-- Name: fact_disbursement_line_item_new; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE fact_disbursement_line_item_new (
    disbursement_line_item_id bigint,
    disbursement_id integer,
    line_number integer,
    check_eft_issued_date_id smallint,
    check_eft_issued_nyc_year_id smallint,
    check_eft_issued_cal_month_id smallint,
    agreement_id bigint,
    master_agreement_id bigint,
    fund_class_id smallint,
    check_amount numeric(16,2),
    agency_id smallint,
    expenditure_object_id integer,
    vendor_id integer,
    maximum_contract_amount numeric(16,2),
    maximum_spending_limit numeric(16,2)
) DISTRIBUTED BY (fund_class_id);


ALTER TABLE public.fact_disbursement_line_item_new OWNER TO gpadmin;

--
-- Name: fact_revenue; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE fact_revenue
(	revenue_id bigint,
	fiscal_year smallint,
	fiscal_period char(2),
	posting_amount decimal(16,2),
	revenue_category_id smallint,
	revenue_source_id smallint,
	fiscal_year_id smallint,
	agency_id smallint,
	department_id integer,	
	revenue_class_id smallint,
	fund_class_id smallint,
	funding_class_id smallint,
	budget_code_id integer,
	budget_year_id integer
) DISTRIBUTED BY (revenue_id);


ALTER TABLE public.fact_revenue OWNER TO gpadmin;

--
-- Name: history_agreement; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE history_agreement (
    agreement_id bigint NOT NULL,
    master_agreement_id bigint,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying(20),
    document_version integer,
    tracking_number character varying(30),
    record_date_id smallint,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period character(2),
    description character varying(60),
    actual_amount numeric(16,2),
    obligated_amount numeric(16,2),
    maximum_contract_amount numeric(16,2),
    amendment_number character varying(19),
    replacing_agreement_id bigint,
    replaced_by_agreement_id bigint,
    award_status_id smallint,
    procurement_id character varying(20),
    procurement_type_id smallint,
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
    reason_modification character varying,
    source_created_date_id smallint,
    source_updated_date_id smallint,
    document_function_code_id smallint,
    award_method_id smallint,
    award_level_id smallint,
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
    original_contract_amount numeric(16,2),
    registered_date_id smallint,
    oca_number character varying(20),
    number_solicitation integer,
    document_name character varying(60),
    original_term_begin_date_id smallint,
    original_term_end_date_id smallint,
    privacy_flag character(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (agreement_id);


ALTER TABLE public.history_agreement OWNER TO athiagarajan;

--
-- Name: history_agreement_accounting_line; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE history_agreement_accounting_line (
    agreement_accounting_line_id bigint NOT NULL,
    agreement_id bigint,
    line_number integer,
    event_type_id smallint,
    description character varying(100),
    line_amount numeric(16,2),
    budget_fiscal_year smallint,
    fiscal_year smallint,
    fiscal_period character(2),
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    expenditure_object_history_id integer,
    revenue_source_id smallint,
    location_code character varying(4),
    budget_code_id integer,
    reporting_code character varying(15),
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (agreement_id);


ALTER TABLE public.history_agreement_accounting_line OWNER TO gpadmin;

--
-- Name: history_agreement_commodity; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE history_agreement_commodity (
    agreement_commodity_id bigint NOT NULL,
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
) DISTRIBUTED BY (agreement_id);


ALTER TABLE public.history_agreement_commodity OWNER TO gpadmin;

--
-- Name: history_agreement_worksite; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE history_agreement_worksite (
    agreement_worksite_id bigint NOT NULL,
    agreement_id bigint,
    worksite_id integer,
    percentage numeric(17,4),
    amount numeric(17,4),
    master_agreement_yn character(1),
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (agreement_id);


ALTER TABLE public.history_agreement_worksite OWNER TO gpadmin;

--
-- Name: history_master_agreement; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE history_master_agreement (
    master_agreement_id bigint NOT NULL,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying(20),
    document_version integer,
    tracking_number character varying(30),
    record_date_id smallint,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period character(2),
    description character varying(60),
    actual_amount numeric(16,2),
    total_amount numeric(16,2),
    replacing_master_agreement_id bigint,
    replaced_by_master_agreement_id bigint,
    award_status_id smallint,
    procurement_id character varying(20),
    procurement_type_id smallint,
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
    reason_modification character varying,
    source_created_date_id smallint,
    source_updated_date_id smallint,
    document_function_code_id smallint,
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
    board_approved_award_date_id smallint,
    original_contract_amount numeric(20,2),
    oca_number character varying(20),
    original_term_begin_date_id smallint,
    original_term_end_date_id smallint,
    registered_date_id smallint,
    maximum_amount numeric(20,2),
    maximum_spending_limit numeric(20,2),
    award_level_id smallint,
    contract_class_code character varying(2),
    number_solicitation integer,
    document_name character varying(60),
    privacy_flag character(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (master_agreement_id);


ALTER TABLE public.history_master_agreement OWNER TO athiagarajan;

--
-- Name: history_master_agreement__0; Type: EXTERNAL TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE EXTERNAL WEB TABLE history_master_agreement__0 (
    master_agreement_id bigint,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying,
    document_version integer,
    tracking_number character varying,
    record_date_id smallint,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period bpchar,
    description character varying,
    actual_amount numeric,
    total_amount numeric,
    replacing_master_agreement_id bigint,
    replaced_by_master_agreement_id bigint,
    award_status_id smallint,
    procurement_id character varying,
    procurement_type_id smallint,
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
    reason_modification character varying,
    source_created_date_id smallint,
    source_updated_date_id smallint,
    document_function_code_id smallint,
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
    board_approved_award_date_id smallint,
    original_contract_amount numeric,
    oca_number character varying,
    original_term_begin_date_id smallint,
    original_term_end_date_id smallint,
    registered_date_id smallint,
    maximum_amount numeric,
    maximum_spending_limit numeric,
    award_level_id smallint,
    contract_class_code character varying,
    number_solicitation integer,
    document_name character varying,
    privacy_flag bpchar,
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.history_master_agreement to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE public.history_master_agreement__0 OWNER TO athiagarajan;

--
-- Name: master_agreement; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE master_agreement (
    master_agreement_id bigint DEFAULT nextval('seq_agreement_agreement_id'::regclass) NOT NULL,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying(20),
    document_version integer,
    tracking_number character varying(30),
    record_date_id smallint,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period character(2),
    description character varying(60),
    actual_amount numeric(16,2),
    total_amount numeric(16,2),
    replacing_master_agreement_id bigint,
    replaced_by_master_agreement_id bigint,
    award_status_id smallint,
    procurement_id character varying(20),
    procurement_type_id smallint,
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
    reason_modification character varying,
    source_created_date_id smallint,
    source_updated_date_id smallint,
    document_function_code_id smallint,
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
    board_approved_award_date_id smallint,
    original_contract_amount numeric(20,2),
    oca_number character varying(20),
    original_term_begin_date_id smallint,
    original_term_end_date_id smallint,
    registered_date_id smallint,
    maximum_amount numeric(20,2),
    maximum_spending_limit numeric(20,2),
    award_level_id smallint,
    contract_class_code character varying(2),
    number_solicitation integer,
    document_name character varying(60),
    privacy_flag character(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (master_agreement_id);


ALTER TABLE public.master_agreement OWNER TO athiagarajan;

--
-- Name: seq_payroll_summary_payroll_summary_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_payroll_summary_payroll_summary_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_payroll_summary_payroll_summary_id OWNER TO gpadmin;

--
-- Name: payroll_summary; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE payroll_summary (
    payroll_summary_id bigint DEFAULT nextval('seq_payroll_summary_payroll_summary_id'::regclass) NOT NULL,
    agency_history_id smallint,
    pay_cycle_id smallint,
    expenditure_object_history_id integer,
    payroll_number_id smallint,
    department_history_id integer,
    fiscal_year smallint,
    budget_code_id integer,
    total_amount numeric(15,2),
    pay_date_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (payroll_summary_id);


ALTER TABLE public.payroll_summary OWNER TO gpadmin;

--
-- Name: seq_ref_address_type_address_type_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_address_type_address_type_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_address_type_address_type_id OWNER TO gpadmin;

--
-- Name: ref_address_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_address_type (
    address_type_id smallint DEFAULT nextval('seq_ref_address_type_address_type_id'::regclass) NOT NULL,
    address_type_code character varying(2),
    address_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (address_type_id);


ALTER TABLE public.ref_address_type OWNER TO gpadmin;

--
-- Name: seq_ref_agency_agency_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_agency_agency_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_agency_agency_id OWNER TO gpadmin;

--
-- Name: ref_agency; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_agency (
    agency_id smallint DEFAULT nextval('seq_ref_agency_agency_id'::regclass) NOT NULL,
    agency_code character varying(20),
    agency_name character varying(50),
    original_agency_name character varying(50),
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) DISTRIBUTED BY (agency_id);


ALTER TABLE public.ref_agency OWNER TO athiagarajan;

--
-- Name: ref_agency__0; Type: EXTERNAL TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_agency__0 (
    agency_id smallint,
    agency_code character varying,
    agency_name character varying,
    original_agency_name character varying,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_agency to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE public.ref_agency__0 OWNER TO athiagarajan;

--
-- Name: seq_ref_agency_history_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_agency_history_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_agency_history_id OWNER TO gpadmin;

--
-- Name: ref_agency_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_agency_history (
    agency_history_id smallint DEFAULT nextval('seq_ref_agency_history_id'::regclass) NOT NULL,
    agency_id smallint,
    agency_name character varying(50),
    created_date timestamp without time zone,
    load_id integer
) DISTRIBUTED BY (agency_history_id);


ALTER TABLE public.ref_agency_history OWNER TO gpadmin;

--
-- Name: seq_ref_agreement_type_agreement_type_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_agreement_type_agreement_type_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_agreement_type_agreement_type_id OWNER TO gpadmin;

--
-- Name: ref_agreement_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_agreement_type (
    agreement_type_id smallint DEFAULT nextval('seq_ref_agreement_type_agreement_type_id'::regclass) NOT NULL,
    agreement_type_code character varying(2),
    agreement_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (agreement_type_id);


ALTER TABLE public.ref_agreement_type OWNER TO gpadmin;

--
-- Name: seq_ref_award_category_award_category_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_award_category_award_category_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_award_category_award_category_id OWNER TO gpadmin;

--
-- Name: ref_award_category; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_award_category (
    award_category_id smallint DEFAULT nextval('seq_ref_award_category_award_category_id'::regclass) NOT NULL,
    award_category_code character varying(10),
    award_category_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (award_category_id);


ALTER TABLE public.ref_award_category OWNER TO gpadmin;

--
-- Name: seq_ref_award_level_award_level_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_award_level_award_level_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_award_level_award_level_id OWNER TO gpadmin;

--
-- Name: ref_award_level; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_award_level (
    award_level_id smallint DEFAULT nextval('seq_ref_award_level_award_level_id'::regclass) NOT NULL,
    award_level_code character varying(2),
    award_level_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (award_level_id);


ALTER TABLE public.ref_award_level OWNER TO gpadmin;

--
-- Name: seq_ref_award_method_award_method_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_award_method_award_method_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_award_method_award_method_id OWNER TO gpadmin;

--
-- Name: ref_award_method; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_award_method (
    award_method_id smallint DEFAULT nextval('seq_ref_award_method_award_method_id'::regclass) NOT NULL,
    award_method_code character varying(3),
    award_method_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (award_method_id);


ALTER TABLE public.ref_award_method OWNER TO gpadmin;

--
-- Name: seq_ref_award_status_award_status_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_award_status_award_status_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_award_status_award_status_id OWNER TO gpadmin;

--
-- Name: ref_award_status; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_award_status (
    award_status_id smallint DEFAULT nextval('seq_ref_award_status_award_status_id'::regclass) NOT NULL,
    award_status_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (award_status_id);


ALTER TABLE public.ref_award_status OWNER TO gpadmin;

--
-- Name: seq_ref_balance_number_balance_number_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_balance_number_balance_number_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_balance_number_balance_number_id OWNER TO gpadmin;

--
-- Name: ref_balance_number; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_balance_number (
    balance_number_id smallint DEFAULT nextval('seq_ref_balance_number_balance_number_id'::regclass) NOT NULL,
    balance_number character varying(5),
    description character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (balance_number_id);


ALTER TABLE public.ref_balance_number OWNER TO gpadmin;

--
-- Name: seq_ref_budget_code_budget_code_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_budget_code_budget_code_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_budget_code_budget_code_id OWNER TO gpadmin;

--
-- Name: ref_budget_code; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_budget_code (
    budget_code_id integer DEFAULT nextval('seq_ref_budget_code_budget_code_id'::regclass) NOT NULL,
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


ALTER TABLE public.ref_budget_code OWNER TO gpadmin;

--
-- Name: seq_ref_business_type_business_type_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_business_type_business_type_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_business_type_business_type_id OWNER TO gpadmin;

--
-- Name: ref_business_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_business_type (
    business_type_id smallint DEFAULT nextval('seq_ref_business_type_business_type_id'::regclass) NOT NULL,
    business_type_code character varying(4),
    business_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (business_type_id);


ALTER TABLE public.ref_business_type OWNER TO gpadmin;

--
-- Name: ref_business_type_status; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_business_type_status (
    business_type_status_id smallint NOT NULL,
    business_type_status character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (business_type_status_id);


ALTER TABLE public.ref_business_type_status OWNER TO gpadmin;

--
-- Name: seq_ref_commodity_type_commodity_type_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_commodity_type_commodity_type_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_commodity_type_commodity_type_id OWNER TO gpadmin;

--
-- Name: ref_commodity_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_commodity_type (
    commodity_type_id smallint DEFAULT nextval('seq_ref_commodity_type_commodity_type_id'::regclass) NOT NULL,
    commodity_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (commodity_type_id);


ALTER TABLE public.ref_commodity_type OWNER TO gpadmin;

--
-- Name: ref_data_source; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_data_source (
    data_source_code character varying(2),
    description character varying(40),
    created_date timestamp without time zone
) DISTRIBUTED BY (data_source_code);


ALTER TABLE public.ref_data_source OWNER TO gpadmin;

--
-- Name: seq_ref_date_date_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_date_date_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_date_date_id OWNER TO gpadmin;

--
-- Name: ref_date; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_date (
    date_id smallint DEFAULT nextval('seq_ref_date_date_id'::regclass) NOT NULL,
    date date,
    nyc_year_id smallint,
    calendar_month_id smallint
) DISTRIBUTED BY (date_id);


ALTER TABLE public.ref_date OWNER TO gpadmin;

--
-- Name: seq_ref_department_department_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_department_department_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_department_department_id OWNER TO gpadmin;

--
-- Name: ref_department; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_department (
    department_id integer DEFAULT nextval('seq_ref_department_department_id'::regclass) NOT NULL,
    department_code character varying(20),
    department_name character varying(100),
    agency_id smallint,
    fund_class_id smallint,
    fiscal_year smallint,
    original_department_name character varying(50),
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) DISTRIBUTED BY (department_id);


ALTER TABLE public.ref_department OWNER TO athiagarajan;

--
-- Name: ref_department__0; Type: EXTERNAL TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_department__0 (
    department_id integer,
    department_code character varying,
    department_name character varying,
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


ALTER EXTERNAL TABLE public.ref_department__0 OWNER TO athiagarajan;

--
-- Name: seq_ref_department_history_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_department_history_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_department_history_id OWNER TO gpadmin;

--
-- Name: ref_department_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_department_history (
    department_history_id integer DEFAULT nextval('seq_ref_department_history_id'::regclass) NOT NULL,
    department_id integer,
    department_name character varying(100),
    agency_id smallint,
    fund_class_id smallint,
    fiscal_year smallint,
    created_date timestamp without time zone,
    load_id integer
) DISTRIBUTED BY (department_history_id);


ALTER TABLE public.ref_department_history OWNER TO gpadmin;

--
-- Name: seq_ref_document_code_document_code_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_document_code_document_code_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_document_code_document_code_id OWNER TO gpadmin;

--
-- Name: ref_document_code; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_document_code (
    document_code_id smallint DEFAULT nextval('seq_ref_document_code_document_code_id'::regclass) NOT NULL,
    document_code character varying(8),
    document_name character varying(100),
    created_date timestamp without time zone
) DISTRIBUTED BY (document_code_id);


ALTER TABLE public.ref_document_code OWNER TO gpadmin;

--
-- Name: seq_ref_document_function_code_document_function_code_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_document_function_code_document_function_code_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_document_function_code_document_function_code_id OWNER TO gpadmin;

--
-- Name: ref_document_function_code; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_document_function_code (
    document_function_code_id smallint DEFAULT nextval('seq_ref_document_function_code_document_function_code_id'::regclass) NOT NULL,
    document_function_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (document_function_code_id);


ALTER TABLE public.ref_document_function_code OWNER TO gpadmin;

--
-- Name: seq_ref_employee_category_employee_category_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_employee_category_employee_category_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_employee_category_employee_category_id OWNER TO gpadmin;

--
-- Name: ref_employee_category; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_employee_category (
    employee_category_id smallint DEFAULT nextval('seq_ref_employee_category_employee_category_id'::regclass) NOT NULL,
    employee_category_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (employee_category_id);


ALTER TABLE public.ref_employee_category OWNER TO gpadmin;

--
-- Name: seq_ref_employee_classification_employee_classification_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_employee_classification_employee_classification_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_employee_classification_employee_classification_id OWNER TO gpadmin;

--
-- Name: ref_employee_classification; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_employee_classification (
    employee_classification_id smallint DEFAULT nextval('seq_ref_employee_classification_employee_classification_id'::regclass) NOT NULL,
    employee_classification_code character varying(20),
    employee_classification_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (employee_classification_id);


ALTER TABLE public.ref_employee_classification OWNER TO gpadmin;

--
-- Name: seq_ref_employee_sub_category_employee_sub_category_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_employee_sub_category_employee_sub_category_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_employee_sub_category_employee_sub_category_id OWNER TO gpadmin;

--
-- Name: ref_employee_sub_category; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_employee_sub_category (
    employee_sub_category_id smallint DEFAULT nextval('seq_ref_employee_sub_category_employee_sub_category_id'::regclass) NOT NULL,
    employee_sub_category_name character varying(50),
    employee_category_id smallint,
    created_date timestamp without time zone
) DISTRIBUTED BY (employee_sub_category_id);


ALTER TABLE public.ref_employee_sub_category OWNER TO gpadmin;

--
-- Name: seq_ref_event_type_event_type_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_event_type_event_type_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_event_type_event_type_id OWNER TO gpadmin;

--
-- Name: ref_event_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_event_type (
    event_type_id smallint DEFAULT nextval('seq_ref_event_type_event_type_id'::regclass) NOT NULL,
    event_type_code character varying(4),
    event_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (event_type_id);


ALTER TABLE public.ref_event_type OWNER TO gpadmin;

--
-- Name: seq_ref_expenditure_cancel_reason_expenditure_cancel_reason_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_expenditure_cancel_reason_expenditure_cancel_reason_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_expenditure_cancel_reason_expenditure_cancel_reason_id OWNER TO gpadmin;

--
-- Name: ref_expenditure_cancel_reason; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_expenditure_cancel_reason (
    expenditure_cancel_reason_id smallint DEFAULT nextval('seq_ref_expenditure_cancel_reason_expenditure_cancel_reason_id'::regclass) NOT NULL,
    expenditure_cancel_reason_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (expenditure_cancel_reason_id);


ALTER TABLE public.ref_expenditure_cancel_reason OWNER TO gpadmin;

--
-- Name: seq_ref_expenditure_cancel_type_expenditure_cancel_type_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_expenditure_cancel_type_expenditure_cancel_type_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_expenditure_cancel_type_expenditure_cancel_type_id OWNER TO gpadmin;

--
-- Name: ref_expenditure_cancel_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_expenditure_cancel_type (
    expenditure_cancel_type_id smallint DEFAULT nextval('seq_ref_expenditure_cancel_type_expenditure_cancel_type_id'::regclass) NOT NULL,
    expenditure_cancel_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (expenditure_cancel_type_id);


ALTER TABLE public.ref_expenditure_cancel_type OWNER TO gpadmin;

--
-- Name: seq_ref_expenditure_object_expendtiure_object_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_expenditure_object_expendtiure_object_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_expenditure_object_expendtiure_object_id OWNER TO gpadmin;

--
-- Name: ref_expenditure_object; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_expenditure_object (
    expenditure_object_id integer DEFAULT nextval('seq_ref_expenditure_object_expendtiure_object_id'::regclass) NOT NULL,
    expenditure_object_code character varying(4),
    expenditure_object_name character varying(40),
    fiscal_year smallint,
    original_expenditure_object_name character varying(40),
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    created_load_id integer,
    updated_load_id integer
) DISTRIBUTED BY (expenditure_object_id);


ALTER TABLE public.ref_expenditure_object OWNER TO athiagarajan;

--
-- Name: ref_expenditure_object__0; Type: EXTERNAL TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
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


ALTER EXTERNAL TABLE public.ref_expenditure_object__0 OWNER TO athiagarajan;

--
-- Name: seq_ref_expenditure_object_history_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_expenditure_object_history_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_expenditure_object_history_id OWNER TO gpadmin;

--
-- Name: ref_expenditure_object_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_expenditure_object_history (
    expenditure_object_history_id integer DEFAULT nextval('seq_ref_expenditure_object_history_id'::regclass) NOT NULL,
    expenditure_object_id integer,
    expenditure_object_name character varying(40),
    fiscal_year smallint,
    created_date timestamp without time zone,
    load_id integer
) DISTRIBUTED BY (expenditure_object_history_id);


ALTER TABLE public.ref_expenditure_object_history OWNER TO gpadmin;

--
-- Name: seq_ref_expenditure_privacy_type_expenditure_privacy_type_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_expenditure_privacy_type_expenditure_privacy_type_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_expenditure_privacy_type_expenditure_privacy_type_id OWNER TO gpadmin;

--
-- Name: ref_expenditure_privacy_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_expenditure_privacy_type (
    expenditure_privacy_type_id smallint DEFAULT nextval('seq_ref_expenditure_privacy_type_expenditure_privacy_type_id'::regclass) NOT NULL,
    expenditure_privacy_code character varying(1),
    expenditure_privacy_name character varying(20),
    created_date timestamp without time zone
) DISTRIBUTED BY (expenditure_privacy_type_id);


ALTER TABLE public.ref_expenditure_privacy_type OWNER TO gpadmin;

--
-- Name: seq_ref_expenditure_status_expenditure_status_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_expenditure_status_expenditure_status_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_expenditure_status_expenditure_status_id OWNER TO gpadmin;

--
-- Name: ref_expenditure_status; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_expenditure_status (
    expenditure_status_id smallint DEFAULT nextval('seq_ref_expenditure_status_expenditure_status_id'::regclass) NOT NULL,
    expenditure_status_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (expenditure_status_id);


ALTER TABLE public.ref_expenditure_status OWNER TO gpadmin;

--
-- Name: seq_ref_fund_fund_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_fund_fund_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_fund_fund_id OWNER TO gpadmin;

--
-- Name: ref_fund; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_fund (
    fund_id smallint DEFAULT nextval('seq_ref_fund_fund_id'::regclass) NOT NULL,
    fund_code character varying(20),
    fund_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (fund_id);


ALTER TABLE public.ref_fund OWNER TO gpadmin;

--
-- Name: seq_ref_fund_class_fund_class_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_fund_class_fund_class_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_fund_class_fund_class_id OWNER TO gpadmin;

--
-- Name: ref_fund_class; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_fund_class (
    fund_class_id smallint DEFAULT nextval('seq_ref_fund_class_fund_class_id'::regclass) NOT NULL,
    fund_class_code character varying(5),
    fund_class_name character varying(50),
    created_load_id integer,
    created_date timestamp without time zone
) DISTRIBUTED BY (fund_class_id);


ALTER TABLE public.ref_fund_class OWNER TO gpadmin;

--
-- Name: seq_ref_funding_class_funding_class_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_funding_class_funding_class_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_funding_class_funding_class_id OWNER TO gpadmin;

--
-- Name: ref_funding_class; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_funding_class (
    funding_class_id smallint DEFAULT nextval('seq_ref_funding_class_funding_class_id'::regclass) NOT NULL,
    funding_class_code character varying(4),
    funding_class_name character varying(60),
    funding_class_short_name character varying(15),
    category_name character varying(60),
    city_fund_flag bit(1),
    intra_city_flag bit(1),
    fund_allocation_required_flag bit(1),
    category_code character varying(2),
    created_date timestamp without time zone
) DISTRIBUTED BY (funding_class_id);


ALTER TABLE public.ref_funding_class OWNER TO gpadmin;

--
-- Name: seq_ref_funding_source_funding_source_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_funding_source_funding_source_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_funding_source_funding_source_id OWNER TO gpadmin;

--
-- Name: ref_funding_source; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_funding_source (
    funding_source_id smallint DEFAULT nextval('seq_ref_funding_source_funding_source_id'::regclass) NOT NULL,
    funding_source_code character varying(5),
    funding_source_name character varying(20),
    created_date timestamp without time zone
) DISTRIBUTED BY (funding_source_id);


ALTER TABLE public.ref_funding_source OWNER TO gpadmin;

--
-- Name: seq_ref_location_location_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_location_location_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_location_location_id OWNER TO gpadmin;

--
-- Name: ref_location; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_location (
    location_id integer DEFAULT nextval('seq_ref_location_location_id'::regclass) NOT NULL,
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


ALTER TABLE public.ref_location OWNER TO athiagarajan;

--
-- Name: ref_location__0; Type: EXTERNAL TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
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


ALTER EXTERNAL TABLE public.ref_location__0 OWNER TO athiagarajan;

--
-- Name: seq_ref_location_history_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_location_history_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_location_history_id OWNER TO gpadmin;

--
-- Name: ref_location_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_location_history (
    location_history_id integer DEFAULT nextval('seq_ref_location_history_id'::regclass) NOT NULL,
    location_id integer,
    agency_id smallint,
    location_name character varying(60),
    location_short_name character varying(16),
    created_date timestamp without time zone,
    load_id integer
) DISTRIBUTED BY (location_history_id);


ALTER TABLE public.ref_location_history OWNER TO gpadmin;

--
-- Name: ref_minority_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_minority_type (
    minority_type_id smallint NOT NULL,
    minority_type_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (minority_type_id);


ALTER TABLE public.ref_minority_type OWNER TO gpadmin;

--
-- Name: seq_ref_misc_vendor_misc_vendor_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_misc_vendor_misc_vendor_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_misc_vendor_misc_vendor_id OWNER TO gpadmin;

--
-- Name: ref_miscellaneous_vendor; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_miscellaneous_vendor (
    misc_vendor_id smallint DEFAULT nextval('seq_ref_misc_vendor_misc_vendor_id'::regclass) NOT NULL,
    vendor_customer_code character varying(20),
    created_date timestamp without time zone
) DISTRIBUTED BY (misc_vendor_id);


ALTER TABLE public.ref_miscellaneous_vendor OWNER TO gpadmin;

--
-- Name: seq_ref_month_month_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_month_month_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_month_month_id OWNER TO gpadmin;

--
-- Name: ref_month; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_month (
    month_id smallint DEFAULT nextval('seq_ref_month_month_id'::regclass) NOT NULL,
    month_value smallint,
    month_name character varying,
    year_id smallint,
    display_order smallint
) DISTRIBUTED BY (month_id);


ALTER TABLE public.ref_month OWNER TO athiagarajan;

--
-- Name: seq_ref_object_class_object_class_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_object_class_object_class_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_object_class_object_class_id OWNER TO gpadmin;

--
-- Name: ref_object_class; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE ref_object_class (
    object_class_id integer DEFAULT nextval('seq_ref_object_class_object_class_id'::regclass) NOT NULL,
    object_class_code character varying(4),
    object_class_name character varying(60),
    object_class_short_name character varying(15),
    active_flag bit(1),
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
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


ALTER TABLE public.ref_object_class OWNER TO athiagarajan;

--
-- Name: ref_object_class__0; Type: EXTERNAL TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_object_class__0 (
    object_class_id integer,
    object_class_code character varying,
    object_class_name character varying,
    object_class_short_name character varying,
    active_flag bit(1),
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
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


ALTER EXTERNAL TABLE public.ref_object_class__0 OWNER TO athiagarajan;

--
-- Name: seq_ref_object_class_history_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_object_class_history_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_object_class_history_id OWNER TO gpadmin;

--
-- Name: ref_object_class_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_object_class_history (
    object_class_history_id integer DEFAULT nextval('seq_ref_object_class_history_id'::regclass) NOT NULL,
    object_class_id integer,
    object_class_name character varying(60),
    object_class_short_name character varying(15),
    active_flag bit(1),
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
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


ALTER TABLE public.ref_object_class_history OWNER TO gpadmin;

--
-- Name: seq_ref_pay_cycle_pay_cycle_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_pay_cycle_pay_cycle_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_pay_cycle_pay_cycle_id OWNER TO gpadmin;

--
-- Name: ref_pay_cycle; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_pay_cycle (
    pay_cycle_id smallint DEFAULT nextval('seq_ref_pay_cycle_pay_cycle_id'::regclass) NOT NULL,
    pay_cycle_code character varying(20),
    description character varying(100),
    created_date timestamp without time zone
) DISTRIBUTED BY (pay_cycle_id);


ALTER TABLE public.ref_pay_cycle OWNER TO gpadmin;

--
-- Name: seq_ref_pay_type_pay_type_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_pay_type_pay_type_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_pay_type_pay_type_id OWNER TO gpadmin;

--
-- Name: ref_pay_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_pay_type (
    pay_type_id smallint DEFAULT nextval('seq_ref_pay_type_pay_type_id'::regclass) NOT NULL,
    pay_type_code character varying(5),
    pay_type_name character varying(100),
    balance_number_id smallint,
    payroll_reporting_id smallint,
    payroll_object_id smallint,
    prior_year_payroll_object_id smallint,
    fringe_indicator character(1),
    created_date timestamp without time zone
) DISTRIBUTED BY (pay_type_id);


ALTER TABLE public.ref_pay_type OWNER TO gpadmin;

--
-- Name: seq_ref_payroll_frequency_payroll_frequency_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_payroll_frequency_payroll_frequency_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_payroll_frequency_payroll_frequency_id OWNER TO gpadmin;

--
-- Name: ref_payroll_frequency; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_payroll_frequency (
    payroll_frequency_id smallint DEFAULT nextval('seq_ref_payroll_frequency_payroll_frequency_id'::regclass) NOT NULL,
    payroll_frequency_code character(1),
    payroll_frequency_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (payroll_frequency_id);


ALTER TABLE public.ref_payroll_frequency OWNER TO gpadmin;

--
-- Name: seq_ref_payroll_number_payroll_number_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_payroll_number_payroll_number_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_payroll_number_payroll_number_id OWNER TO gpadmin;

--
-- Name: ref_payroll_number; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_payroll_number (
    payroll_number_id smallint DEFAULT nextval('seq_ref_payroll_number_payroll_number_id'::regclass) NOT NULL,
    payroll_number character varying(20),
    payroll_name character varying(50),
    agency_id smallint,
    created_date timestamp without time zone
) DISTRIBUTED BY (payroll_number_id);


ALTER TABLE public.ref_payroll_number OWNER TO gpadmin;

--
-- Name: seq_ref_payroll_object_payroll_object_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_payroll_object_payroll_object_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_payroll_object_payroll_object_id OWNER TO gpadmin;

--
-- Name: ref_payroll_object; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_payroll_object (
    payroll_object_id smallint DEFAULT nextval('seq_ref_payroll_object_payroll_object_id'::regclass) NOT NULL,
    payroll_object_code character varying(5),
    payroll_object_name character varying(100),
    created_date timestamp without time zone
) DISTRIBUTED BY (payroll_object_id);


ALTER TABLE public.ref_payroll_object OWNER TO gpadmin;

--
-- Name: seq_ref_payroll_payment_payroll_payment_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_payroll_payment_payroll_payment_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_payroll_payment_payroll_payment_id OWNER TO gpadmin;

--
-- Name: ref_payroll_payment_status; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_payroll_payment_status (
    payroll_payment_status_id smallint DEFAULT nextval('seq_ref_payroll_payment_payroll_payment_id'::regclass) NOT NULL,
    payroll_payment_status_code character varying(1),
    description character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (payroll_payment_status_id);


ALTER TABLE public.ref_payroll_payment_status OWNER TO gpadmin;

--
-- Name: seq_ref_payroll_reporting_payroll_reporting_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_payroll_reporting_payroll_reporting_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_payroll_reporting_payroll_reporting_id OWNER TO gpadmin;

--
-- Name: ref_payroll_reporting; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_payroll_reporting (
    payroll_reporting_id smallint DEFAULT nextval('seq_ref_payroll_reporting_payroll_reporting_id'::regclass) NOT NULL,
    payroll_reporting_code character varying(5),
    payroll_reporting_name character varying(100),
    created_date timestamp without time zone
) DISTRIBUTED BY (payroll_reporting_id);


ALTER TABLE public.ref_payroll_reporting OWNER TO gpadmin;

--
-- Name: ref_payroll_wage; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_payroll_wage (
    payroll_wage_id smallint DEFAULT nextval('seq_ref_payroll_reporting_payroll_reporting_id'::regclass) NOT NULL,
    payroll_wage_code character(1),
    payroll_wage_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (payroll_wage_id);


ALTER TABLE public.ref_payroll_wage OWNER TO gpadmin;

--
-- Name: seq_ref_revenue_category_revenue_category_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_revenue_category_revenue_category_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_revenue_category_revenue_category_id OWNER TO gpadmin;

--
-- Name: ref_revenue_category; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_revenue_category (
    revenue_category_id smallint DEFAULT nextval('seq_ref_revenue_category_revenue_category_id'::regclass) NOT NULL,
    revenue_category_code character varying(4),
    revenue_category_name character varying(60),
    revenue_category_short_name character varying(15),
    active_flag bit(1),
    budget_allowed_flag bit(1),
    description character varying(100),
    created_date timestamp without time zone,
    updated_load_id integer,
    updated_date timestamp without time zone
) DISTRIBUTED BY (revenue_category_id);


ALTER TABLE public.ref_revenue_category OWNER TO gpadmin;

--
-- Name: seq_ref_revenue_class_revenue_class_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_revenue_class_revenue_class_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_revenue_class_revenue_class_id OWNER TO gpadmin;

--
-- Name: ref_revenue_class; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_revenue_class (
    revenue_class_id smallint DEFAULT nextval('seq_ref_revenue_class_revenue_class_id'::regclass) NOT NULL,
    revenue_class_code character varying(4) DEFAULT '0'::character varying NOT NULL,
    revenue_class_name character varying(60),
    revenue_class_short_name character varying(15),
    active_flag bit(1),
    budget_allowed_flag bit(1),
    description character varying(100),
    created_date timestamp without time zone,
    updated_load_id integer,
    updated_date timestamp without time zone
) DISTRIBUTED BY (revenue_class_id);


ALTER TABLE public.ref_revenue_class OWNER TO gpadmin;

--
-- Name: seq_ref_revenue_source_revenue_source_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_revenue_source_revenue_source_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_revenue_source_revenue_source_id OWNER TO gpadmin;

--
-- Name: ref_revenue_source; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_revenue_source (
    revenue_source_id smallint DEFAULT nextval('seq_ref_revenue_source_revenue_source_id'::regclass) NOT NULL,
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


ALTER TABLE public.ref_revenue_source OWNER TO gpadmin;

--
-- Name: ref_spending_category; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_spending_category (
    spending_category_id smallint NOT NULL,
    spending_category_code character varying(2),
    spending_category_name character varying(100)
) DISTRIBUTED BY (spending_category_id);


ALTER TABLE public.ref_spending_category OWNER TO gpadmin;

--
-- Name: seq_ref_worksite_worksite_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_worksite_worksite_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_worksite_worksite_id OWNER TO gpadmin;

--
-- Name: ref_worksite; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_worksite (
    worksite_id integer DEFAULT nextval('seq_ref_worksite_worksite_id'::regclass) NOT NULL,
    worksite_code character varying(3),
    worksite_name character varying(50),
    created_date timestamp without time zone
) DISTRIBUTED BY (worksite_id);


ALTER TABLE public.ref_worksite OWNER TO gpadmin;

--
-- Name: seq_ref_year_year_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_year_year_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_year_year_id OWNER TO gpadmin;

--
-- Name: ref_year; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE ref_year (
    year_id smallint DEFAULT nextval('seq_ref_year_year_id'::regclass) NOT NULL,
    year_value smallint
) DISTRIBUTED BY (year_id);


ALTER TABLE public.ref_year OWNER TO gpadmin;

--
-- Name: seq_revenue_revenue_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_revenue_revenue_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_revenue_revenue_id OWNER TO gpadmin;

--
-- Name: revenue; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE revenue (
    revenue_id bigint DEFAULT nextval('seq_revenue_revenue_id'::regclass) NOT NULL,
    record_date_id smallint,
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
    service_start_date_id smallint,
    service_end_date_id smallint,
    reason_code character varying(8),
    reclassification_flag integer,
    closing_classification_code character varying(2),
    closing_classification_name character varying(45),
    revenue_category_id smallint,
    revenue_class_id smallint,
    revenue_source_id smallint,
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


ALTER TABLE public.revenue OWNER TO gpadmin;

--
-- Name: seq_agreement_accounting_line_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_agreement_accounting_line_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_agreement_accounting_line_id OWNER TO gpadmin;

--
-- Name: seq_agreement_commodity_agreement_commodity_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_agreement_commodity_agreement_commodity_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_agreement_commodity_agreement_commodity_id OWNER TO gpadmin;

--
-- Name: seq_agreement_worksite_agreement_worksite_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_agreement_worksite_agreement_worksite_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_agreement_worksite_agreement_worksite_id OWNER TO gpadmin;

--
-- Name: seq_disbursement_line_item_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_disbursement_line_item_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_disbursement_line_item_id OWNER TO gpadmin;

--
-- Name: seq_expenditure_expenditure_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_expenditure_expenditure_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_expenditure_expenditure_id OWNER TO gpadmin;

--
-- Name: seq_ref_budget_budget_code_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_budget_budget_code_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_budget_budget_code_id OWNER TO gpadmin;

--
-- Name: seq_ref_procurement_type_procurement_type_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_ref_procurement_type_procurement_type_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_ref_procurement_type_procurement_type_id OWNER TO gpadmin;

--
-- Name: seq_stg_budget_code_uniq_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_stg_budget_code_uniq_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_stg_budget_code_uniq_id OWNER TO gpadmin;

--
-- Name: seq_test; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_test
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_test OWNER TO gpadmin;

--
-- Name: seq_vendor_address_vendor_address_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_vendor_address_vendor_address_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_vendor_address_vendor_address_id OWNER TO gpadmin;

--
-- Name: seq_vendor_bus_type_vendor_bus_type_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_vendor_bus_type_vendor_bus_type_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_vendor_bus_type_vendor_bus_type_id OWNER TO gpadmin;

--
-- Name: seq_vendor_history_vendor_history_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_vendor_history_vendor_history_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_vendor_history_vendor_history_id OWNER TO gpadmin;

--
-- Name: seq_vendor_vendor_id; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_vendor_vendor_id
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_vendor_vendor_id OWNER TO gpadmin;

--
-- Name: seq_vendor_vendor_sub_code; Type: SEQUENCE; Schema: public; Owner: gpadmin
--

CREATE SEQUENCE seq_vendor_vendor_sub_code
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.seq_vendor_vendor_sub_code OWNER TO gpadmin;

--
-- Name: vendor; Type: TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
--

CREATE TABLE vendor (
    vendor_id integer DEFAULT nextval('seq_vendor_vendor_id'::regclass) NOT NULL,
    vendor_customer_code character varying(20),
    legal_name character varying(60),
    alias_name character varying(60),
    miscellaneous_vendor_flag bit(1),
    vendor_sub_code integer DEFAULT nextval('seq_vendor_vendor_sub_code'::regclass),
    display_flag character(1) DEFAULT 'Y'::bpchar,
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (vendor_id);


ALTER TABLE public.vendor OWNER TO athiagarajan;

--
-- Name: vendor__0; Type: EXTERNAL TABLE; Schema: public; Owner: athiagarajan; Tablespace: 
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


ALTER EXTERNAL TABLE public.vendor__0 OWNER TO athiagarajan;

--
-- Name: vendor_address; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE vendor_address (
    vendor_address_id bigint DEFAULT nextval('seq_vendor_address_vendor_address_id'::regclass) NOT NULL,
    vendor_history_id integer,
    address_id integer,
    address_type_id smallint,
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (vendor_address_id);


ALTER TABLE public.vendor_address OWNER TO gpadmin;

--
-- Name: vendor_business_type; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE vendor_business_type (
    vendor_business_type_id bigint DEFAULT nextval('seq_vendor_bus_type_vendor_bus_type_id'::regclass) NOT NULL,
    vendor_history_id integer,
    business_type_id smallint,
    status smallint,
    minority_type_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (vendor_business_type_id);


ALTER TABLE public.vendor_business_type OWNER TO gpadmin;

--
-- Name: vendor_history; Type: TABLE; Schema: public; Owner: gpadmin; Tablespace: 
--

CREATE TABLE vendor_history (
    vendor_history_id integer DEFAULT nextval('seq_vendor_history_vendor_history_id'::regclass) NOT NULL,
    vendor_id integer,
    legal_name character varying(60),
    alias_name character varying(60),
    miscellaneous_vendor_flag bit(1),
    vendor_sub_code integer DEFAULT nextval('seq_vendor_vendor_sub_code'::regclass),
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) DISTRIBUTED BY (vendor_history_id);


ALTER TABLE public.vendor_history OWNER TO gpadmin;

--
-- Name: public; Type: ACL; Schema: -; Owner: gpadmin
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM gpadmin;
GRANT ALL ON SCHEMA public TO gpadmin;
GRANT ALL ON SCHEMA public TO PUBLIC;
GRANT ALL ON SCHEMA public TO webuser1;


--
-- Name: seq_address_address_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_address_address_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_address_address_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_address_address_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_address_address_id TO webuser1;


--
-- Name: address; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE address FROM PUBLIC;
REVOKE ALL ON TABLE address FROM gpadmin;
GRANT ALL ON TABLE address TO gpadmin;
GRANT SELECT ON TABLE address TO webuser1;


--
-- Name: aggregateon_spending_coa_entities; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE aggregateon_spending_coa_entities FROM PUBLIC;
REVOKE ALL ON TABLE aggregateon_spending_coa_entities FROM gpadmin;
GRANT ALL ON TABLE aggregateon_spending_coa_entities TO gpadmin;
GRANT SELECT ON TABLE aggregateon_spending_coa_entities TO webuser1;


--
-- Name: aggregateon_spending_contract; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE aggregateon_spending_contract FROM PUBLIC;
REVOKE ALL ON TABLE aggregateon_spending_contract FROM gpadmin;
GRANT ALL ON TABLE aggregateon_spending_contract TO gpadmin;
GRANT SELECT ON TABLE aggregateon_spending_contract TO webuser1;


--
-- Name: aggregateon_spending_vendor; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE aggregateon_spending_vendor FROM PUBLIC;
REVOKE ALL ON TABLE aggregateon_spending_vendor FROM gpadmin;
GRANT ALL ON TABLE aggregateon_spending_vendor TO gpadmin;
GRANT SELECT ON TABLE aggregateon_spending_vendor TO webuser1;


--
-- Name: seq_agreement_agreement_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_agreement_agreement_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_agreement_agreement_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_agreement_agreement_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_agreement_agreement_id TO webuser1;


--
-- Name: agreement; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE agreement FROM PUBLIC;
REVOKE ALL ON TABLE agreement FROM athiagarajan;
GRANT ALL ON TABLE agreement TO athiagarajan;
GRANT SELECT ON TABLE agreement TO webuser1;


--
-- Name: agreement__0; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE agreement__0 FROM PUBLIC;
REVOKE ALL ON TABLE agreement__0 FROM athiagarajan;
GRANT ALL ON TABLE agreement__0 TO athiagarajan;
GRANT SELECT ON TABLE agreement__0 TO webuser1;


--
-- Name: agreement_accounting_line; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE agreement_accounting_line FROM PUBLIC;
REVOKE ALL ON TABLE agreement_accounting_line FROM gpadmin;
GRANT ALL ON TABLE agreement_accounting_line TO gpadmin;
GRANT SELECT ON TABLE agreement_accounting_line TO webuser1;


--
-- Name: agreement_commodity; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE agreement_commodity FROM PUBLIC;
REVOKE ALL ON TABLE agreement_commodity FROM gpadmin;
GRANT ALL ON TABLE agreement_commodity TO gpadmin;
GRANT SELECT ON TABLE agreement_commodity TO webuser1;


--
-- Name: agreement_worksite; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE agreement_worksite FROM PUBLIC;
REVOKE ALL ON TABLE agreement_worksite FROM gpadmin;
GRANT ALL ON TABLE agreement_worksite TO gpadmin;
GRANT SELECT ON TABLE agreement_worksite TO webuser1;


--
-- Name: seq_budget_budget_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_budget_budget_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_budget_budget_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_budget_budget_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_budget_budget_id TO webuser1;


--
-- Name: budget; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE budget FROM PUBLIC;
REVOKE ALL ON TABLE budget FROM gpadmin;
GRANT ALL ON TABLE budget TO gpadmin;
GRANT SELECT ON TABLE budget TO webuser1;


--
-- Name: disbursement; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE disbursement FROM PUBLIC;
REVOKE ALL ON TABLE disbursement FROM gpadmin;
GRANT ALL ON TABLE disbursement TO gpadmin;
GRANT SELECT ON TABLE disbursement TO webuser1;


--
-- Name: disbursement_line_item; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE disbursement_line_item FROM PUBLIC;
REVOKE ALL ON TABLE disbursement_line_item FROM gpadmin;
GRANT ALL ON TABLE disbursement_line_item TO gpadmin;
GRANT SELECT ON TABLE disbursement_line_item TO webuser1;


--
-- Name: fact_agreement; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_agreement FROM PUBLIC;
REVOKE ALL ON TABLE fact_agreement FROM gpadmin;
GRANT ALL ON TABLE fact_agreement TO gpadmin;
GRANT SELECT ON TABLE fact_agreement TO webuser1;


--
-- Name: fact_agreement_accounting_line; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_agreement_accounting_line FROM PUBLIC;
REVOKE ALL ON TABLE fact_agreement_accounting_line FROM gpadmin;
GRANT ALL ON TABLE fact_agreement_accounting_line TO gpadmin;
GRANT SELECT ON TABLE fact_agreement_accounting_line TO webuser1;


--
-- Name: fact_disbursement_line_item; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_disbursement_line_item FROM PUBLIC;
REVOKE ALL ON TABLE fact_disbursement_line_item FROM gpadmin;
GRANT ALL ON TABLE fact_disbursement_line_item TO gpadmin;
GRANT SELECT ON TABLE fact_disbursement_line_item TO webuser1;


--
-- Name: fact_disbursement_line_item_new; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_disbursement_line_item_new FROM PUBLIC;
REVOKE ALL ON TABLE fact_disbursement_line_item_new FROM gpadmin;
GRANT ALL ON TABLE fact_disbursement_line_item_new TO gpadmin;
GRANT SELECT ON TABLE fact_disbursement_line_item_new TO webuser1;


--
-- Name: fact_revenue; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_revenue FROM PUBLIC;
REVOKE ALL ON TABLE fact_revenue FROM gpadmin;
GRANT ALL ON TABLE fact_revenue TO gpadmin;
GRANT SELECT ON TABLE fact_revenue TO webuser1;


--
-- Name: history_agreement; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE history_agreement FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement FROM athiagarajan;
GRANT ALL ON TABLE history_agreement TO athiagarajan;
GRANT SELECT ON TABLE history_agreement TO webuser1;


--
-- Name: history_agreement_accounting_line; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE history_agreement_accounting_line FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement_accounting_line FROM gpadmin;
GRANT ALL ON TABLE history_agreement_accounting_line TO gpadmin;
GRANT SELECT ON TABLE history_agreement_accounting_line TO webuser1;


--
-- Name: history_agreement_commodity; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE history_agreement_commodity FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement_commodity FROM gpadmin;
GRANT ALL ON TABLE history_agreement_commodity TO gpadmin;
GRANT SELECT ON TABLE history_agreement_commodity TO webuser1;


--
-- Name: history_agreement_worksite; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE history_agreement_worksite FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement_worksite FROM gpadmin;
GRANT ALL ON TABLE history_agreement_worksite TO gpadmin;
GRANT SELECT ON TABLE history_agreement_worksite TO webuser1;


--
-- Name: history_master_agreement; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE history_master_agreement FROM PUBLIC;
REVOKE ALL ON TABLE history_master_agreement FROM athiagarajan;
GRANT ALL ON TABLE history_master_agreement TO athiagarajan;
GRANT SELECT ON TABLE history_master_agreement TO webuser1;


--
-- Name: history_master_agreement__0; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE history_master_agreement__0 FROM PUBLIC;
REVOKE ALL ON TABLE history_master_agreement__0 FROM athiagarajan;
GRANT ALL ON TABLE history_master_agreement__0 TO athiagarajan;
GRANT SELECT ON TABLE history_master_agreement__0 TO webuser1;


--
-- Name: master_agreement; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE master_agreement FROM PUBLIC;
REVOKE ALL ON TABLE master_agreement FROM athiagarajan;
GRANT ALL ON TABLE master_agreement TO athiagarajan;
GRANT SELECT ON TABLE master_agreement TO webuser1;


--
-- Name: seq_payroll_summary_payroll_summary_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_payroll_summary_payroll_summary_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_payroll_summary_payroll_summary_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_payroll_summary_payroll_summary_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_payroll_summary_payroll_summary_id TO webuser1;


--
-- Name: payroll_summary; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE payroll_summary FROM PUBLIC;
REVOKE ALL ON TABLE payroll_summary FROM gpadmin;
GRANT ALL ON TABLE payroll_summary TO gpadmin;
GRANT SELECT ON TABLE payroll_summary TO webuser1;


--
-- Name: seq_ref_address_type_address_type_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_address_type_address_type_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_address_type_address_type_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_address_type_address_type_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_address_type_address_type_id TO webuser1;


--
-- Name: ref_address_type; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_address_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_address_type FROM gpadmin;
GRANT ALL ON TABLE ref_address_type TO gpadmin;
GRANT SELECT ON TABLE ref_address_type TO webuser1;


--
-- Name: seq_ref_agency_agency_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_agency_agency_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_agency_agency_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_agency_agency_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_agency_agency_id TO webuser1;


--
-- Name: ref_agency; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_agency FROM PUBLIC;
REVOKE ALL ON TABLE ref_agency FROM athiagarajan;
GRANT ALL ON TABLE ref_agency TO athiagarajan;
GRANT SELECT ON TABLE ref_agency TO webuser1;


--
-- Name: ref_agency__0; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_agency__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_agency__0 FROM athiagarajan;
GRANT ALL ON TABLE ref_agency__0 TO athiagarajan;
GRANT SELECT ON TABLE ref_agency__0 TO webuser1;


--
-- Name: seq_ref_agency_history_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_agency_history_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_agency_history_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_agency_history_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_agency_history_id TO webuser1;


--
-- Name: ref_agency_history; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_agency_history FROM PUBLIC;
REVOKE ALL ON TABLE ref_agency_history FROM gpadmin;
GRANT ALL ON TABLE ref_agency_history TO gpadmin;
GRANT SELECT ON TABLE ref_agency_history TO webuser1;


--
-- Name: seq_ref_agreement_type_agreement_type_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_agreement_type_agreement_type_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_agreement_type_agreement_type_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_agreement_type_agreement_type_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_agreement_type_agreement_type_id TO webuser1;


--
-- Name: ref_agreement_type; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_agreement_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_agreement_type FROM gpadmin;
GRANT ALL ON TABLE ref_agreement_type TO gpadmin;
GRANT SELECT ON TABLE ref_agreement_type TO webuser1;


--
-- Name: seq_ref_award_category_award_category_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_award_category_award_category_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_award_category_award_category_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_award_category_award_category_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_award_category_award_category_id TO webuser1;


--
-- Name: ref_award_category; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_category FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_category FROM gpadmin;
GRANT ALL ON TABLE ref_award_category TO gpadmin;
GRANT SELECT ON TABLE ref_award_category TO webuser1;


--
-- Name: seq_ref_award_level_award_level_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_award_level_award_level_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_award_level_award_level_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_award_level_award_level_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_award_level_award_level_id TO webuser1;


--
-- Name: ref_award_level; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_level FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_level FROM gpadmin;
GRANT ALL ON TABLE ref_award_level TO gpadmin;
GRANT SELECT ON TABLE ref_award_level TO webuser1;


--
-- Name: seq_ref_award_method_award_method_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_award_method_award_method_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_award_method_award_method_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_award_method_award_method_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_award_method_award_method_id TO webuser1;


--
-- Name: ref_award_method; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_method FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_method FROM gpadmin;
GRANT ALL ON TABLE ref_award_method TO gpadmin;
GRANT SELECT ON TABLE ref_award_method TO webuser1;


--
-- Name: seq_ref_award_status_award_status_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_award_status_award_status_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_award_status_award_status_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_award_status_award_status_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_award_status_award_status_id TO webuser1;


--
-- Name: ref_award_status; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_status FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_status FROM gpadmin;
GRANT ALL ON TABLE ref_award_status TO gpadmin;
GRANT SELECT ON TABLE ref_award_status TO webuser1;


--
-- Name: seq_ref_balance_number_balance_number_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_balance_number_balance_number_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_balance_number_balance_number_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_balance_number_balance_number_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_balance_number_balance_number_id TO webuser1;


--
-- Name: ref_balance_number; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_balance_number FROM PUBLIC;
REVOKE ALL ON TABLE ref_balance_number FROM gpadmin;
GRANT ALL ON TABLE ref_balance_number TO gpadmin;
GRANT SELECT ON TABLE ref_balance_number TO webuser1;


--
-- Name: seq_ref_budget_code_budget_code_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_budget_code_budget_code_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_budget_code_budget_code_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_budget_code_budget_code_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_budget_code_budget_code_id TO webuser1;


--
-- Name: ref_budget_code; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_budget_code FROM PUBLIC;
REVOKE ALL ON TABLE ref_budget_code FROM gpadmin;
GRANT ALL ON TABLE ref_budget_code TO gpadmin;
GRANT SELECT ON TABLE ref_budget_code TO webuser1;


--
-- Name: seq_ref_business_type_business_type_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_business_type_business_type_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_business_type_business_type_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_business_type_business_type_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_business_type_business_type_id TO webuser1;


--
-- Name: ref_business_type; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_business_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_business_type FROM gpadmin;
GRANT ALL ON TABLE ref_business_type TO gpadmin;
GRANT SELECT ON TABLE ref_business_type TO webuser1;


--
-- Name: ref_business_type_status; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_business_type_status FROM PUBLIC;
REVOKE ALL ON TABLE ref_business_type_status FROM gpadmin;
GRANT ALL ON TABLE ref_business_type_status TO gpadmin;
GRANT SELECT ON TABLE ref_business_type_status TO webuser1;


--
-- Name: seq_ref_commodity_type_commodity_type_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_commodity_type_commodity_type_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_commodity_type_commodity_type_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_commodity_type_commodity_type_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_commodity_type_commodity_type_id TO webuser1;


--
-- Name: ref_commodity_type; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_commodity_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_commodity_type FROM gpadmin;
GRANT ALL ON TABLE ref_commodity_type TO gpadmin;
GRANT SELECT ON TABLE ref_commodity_type TO webuser1;


--
-- Name: ref_data_source; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_data_source FROM PUBLIC;
REVOKE ALL ON TABLE ref_data_source FROM gpadmin;
GRANT ALL ON TABLE ref_data_source TO gpadmin;
GRANT SELECT ON TABLE ref_data_source TO webuser1;


--
-- Name: seq_ref_date_date_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_date_date_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_date_date_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_date_date_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_date_date_id TO webuser1;


--
-- Name: ref_date; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_date FROM PUBLIC;
REVOKE ALL ON TABLE ref_date FROM gpadmin;
GRANT ALL ON TABLE ref_date TO gpadmin;
GRANT SELECT ON TABLE ref_date TO webuser1;


--
-- Name: seq_ref_department_department_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_department_department_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_department_department_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_department_department_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_department_department_id TO webuser1;


--
-- Name: ref_department; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_department FROM PUBLIC;
REVOKE ALL ON TABLE ref_department FROM athiagarajan;
GRANT ALL ON TABLE ref_department TO athiagarajan;
GRANT SELECT ON TABLE ref_department TO webuser1;


--
-- Name: ref_department__0; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_department__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_department__0 FROM athiagarajan;
GRANT ALL ON TABLE ref_department__0 TO athiagarajan;
GRANT SELECT ON TABLE ref_department__0 TO webuser1;


--
-- Name: seq_ref_department_history_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_department_history_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_department_history_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_department_history_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_department_history_id TO webuser1;


--
-- Name: ref_department_history; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_department_history FROM PUBLIC;
REVOKE ALL ON TABLE ref_department_history FROM gpadmin;
GRANT ALL ON TABLE ref_department_history TO gpadmin;
GRANT SELECT ON TABLE ref_department_history TO webuser1;


--
-- Name: seq_ref_document_code_document_code_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_document_code_document_code_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_document_code_document_code_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_document_code_document_code_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_document_code_document_code_id TO webuser1;


--
-- Name: ref_document_code; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_document_code FROM PUBLIC;
REVOKE ALL ON TABLE ref_document_code FROM gpadmin;
GRANT ALL ON TABLE ref_document_code TO gpadmin;
GRANT SELECT ON TABLE ref_document_code TO webuser1;


--
-- Name: seq_ref_document_function_code_document_function_code_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_document_function_code_document_function_code_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_document_function_code_document_function_code_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_document_function_code_document_function_code_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_document_function_code_document_function_code_id TO webuser1;


--
-- Name: ref_document_function_code; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_document_function_code FROM PUBLIC;
REVOKE ALL ON TABLE ref_document_function_code FROM gpadmin;
GRANT ALL ON TABLE ref_document_function_code TO gpadmin;
GRANT SELECT ON TABLE ref_document_function_code TO webuser1;


--
-- Name: seq_ref_employee_category_employee_category_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_employee_category_employee_category_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_employee_category_employee_category_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_employee_category_employee_category_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_employee_category_employee_category_id TO webuser1;


--
-- Name: ref_employee_category; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_employee_category FROM PUBLIC;
REVOKE ALL ON TABLE ref_employee_category FROM gpadmin;
GRANT ALL ON TABLE ref_employee_category TO gpadmin;
GRANT SELECT ON TABLE ref_employee_category TO webuser1;


--
-- Name: seq_ref_employee_classification_employee_classification_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_employee_classification_employee_classification_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_employee_classification_employee_classification_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_employee_classification_employee_classification_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_employee_classification_employee_classification_id TO webuser1;


--
-- Name: ref_employee_classification; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_employee_classification FROM PUBLIC;
REVOKE ALL ON TABLE ref_employee_classification FROM gpadmin;
GRANT ALL ON TABLE ref_employee_classification TO gpadmin;
GRANT SELECT ON TABLE ref_employee_classification TO webuser1;


--
-- Name: seq_ref_employee_sub_category_employee_sub_category_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_employee_sub_category_employee_sub_category_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_employee_sub_category_employee_sub_category_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_employee_sub_category_employee_sub_category_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_employee_sub_category_employee_sub_category_id TO webuser1;


--
-- Name: ref_employee_sub_category; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_employee_sub_category FROM PUBLIC;
REVOKE ALL ON TABLE ref_employee_sub_category FROM gpadmin;
GRANT ALL ON TABLE ref_employee_sub_category TO gpadmin;
GRANT SELECT ON TABLE ref_employee_sub_category TO webuser1;


--
-- Name: seq_ref_event_type_event_type_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_event_type_event_type_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_event_type_event_type_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_event_type_event_type_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_event_type_event_type_id TO webuser1;


--
-- Name: ref_event_type; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_event_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_event_type FROM gpadmin;
GRANT ALL ON TABLE ref_event_type TO gpadmin;
GRANT SELECT ON TABLE ref_event_type TO webuser1;


--
-- Name: seq_ref_expenditure_cancel_reason_expenditure_cancel_reason_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_expenditure_cancel_reason_expenditure_cancel_reason_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_expenditure_cancel_reason_expenditure_cancel_reason_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_expenditure_cancel_reason_expenditure_cancel_reason_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_expenditure_cancel_reason_expenditure_cancel_reason_id TO webuser1;


--
-- Name: ref_expenditure_cancel_reason; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_cancel_reason FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_cancel_reason FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_cancel_reason TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_cancel_reason TO webuser1;


--
-- Name: seq_ref_expenditure_cancel_type_expenditure_cancel_type_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_expenditure_cancel_type_expenditure_cancel_type_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_expenditure_cancel_type_expenditure_cancel_type_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_expenditure_cancel_type_expenditure_cancel_type_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_expenditure_cancel_type_expenditure_cancel_type_id TO webuser1;


--
-- Name: ref_expenditure_cancel_type; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_cancel_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_cancel_type FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_cancel_type TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_cancel_type TO webuser1;


--
-- Name: seq_ref_expenditure_object_expendtiure_object_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_expenditure_object_expendtiure_object_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_expenditure_object_expendtiure_object_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_expenditure_object_expendtiure_object_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_expenditure_object_expendtiure_object_id TO webuser1;


--
-- Name: ref_expenditure_object; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_expenditure_object FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_object FROM athiagarajan;
GRANT ALL ON TABLE ref_expenditure_object TO athiagarajan;
GRANT SELECT ON TABLE ref_expenditure_object TO webuser1;


--
-- Name: ref_expenditure_object__0; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_expenditure_object__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_object__0 FROM athiagarajan;
GRANT ALL ON TABLE ref_expenditure_object__0 TO athiagarajan;
GRANT SELECT ON TABLE ref_expenditure_object__0 TO webuser1;


--
-- Name: seq_ref_expenditure_object_history_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_expenditure_object_history_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_expenditure_object_history_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_expenditure_object_history_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_expenditure_object_history_id TO webuser1;


--
-- Name: ref_expenditure_object_history; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_object_history FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_object_history FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_object_history TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_object_history TO webuser1;


--
-- Name: seq_ref_expenditure_privacy_type_expenditure_privacy_type_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_expenditure_privacy_type_expenditure_privacy_type_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_expenditure_privacy_type_expenditure_privacy_type_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_expenditure_privacy_type_expenditure_privacy_type_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_expenditure_privacy_type_expenditure_privacy_type_id TO webuser1;


--
-- Name: ref_expenditure_privacy_type; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_privacy_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_privacy_type FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_privacy_type TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_privacy_type TO webuser1;


--
-- Name: seq_ref_expenditure_status_expenditure_status_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_expenditure_status_expenditure_status_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_expenditure_status_expenditure_status_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_expenditure_status_expenditure_status_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_expenditure_status_expenditure_status_id TO webuser1;


--
-- Name: ref_expenditure_status; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_status FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_status FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_status TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_status TO webuser1;


--
-- Name: seq_ref_fund_fund_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_fund_fund_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_fund_fund_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_fund_fund_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_fund_fund_id TO webuser1;


--
-- Name: ref_fund; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_fund FROM PUBLIC;
REVOKE ALL ON TABLE ref_fund FROM gpadmin;
GRANT ALL ON TABLE ref_fund TO gpadmin;
GRANT SELECT ON TABLE ref_fund TO webuser1;


--
-- Name: seq_ref_fund_class_fund_class_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_fund_class_fund_class_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_fund_class_fund_class_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_fund_class_fund_class_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_fund_class_fund_class_id TO webuser1;


--
-- Name: ref_fund_class; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_fund_class FROM PUBLIC;
REVOKE ALL ON TABLE ref_fund_class FROM gpadmin;
GRANT ALL ON TABLE ref_fund_class TO gpadmin;
GRANT SELECT ON TABLE ref_fund_class TO webuser1;


--
-- Name: seq_ref_funding_class_funding_class_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_funding_class_funding_class_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_funding_class_funding_class_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_funding_class_funding_class_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_funding_class_funding_class_id TO webuser1;


--
-- Name: ref_funding_class; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_funding_class FROM PUBLIC;
REVOKE ALL ON TABLE ref_funding_class FROM gpadmin;
GRANT ALL ON TABLE ref_funding_class TO gpadmin;
GRANT SELECT ON TABLE ref_funding_class TO webuser1;


--
-- Name: seq_ref_funding_source_funding_source_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_funding_source_funding_source_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_funding_source_funding_source_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_funding_source_funding_source_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_funding_source_funding_source_id TO webuser1;


--
-- Name: ref_funding_source; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_funding_source FROM PUBLIC;
REVOKE ALL ON TABLE ref_funding_source FROM gpadmin;
GRANT ALL ON TABLE ref_funding_source TO gpadmin;
GRANT SELECT ON TABLE ref_funding_source TO webuser1;


--
-- Name: seq_ref_location_location_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_location_location_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_location_location_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_location_location_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_location_location_id TO webuser1;


--
-- Name: ref_location; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_location FROM PUBLIC;
REVOKE ALL ON TABLE ref_location FROM athiagarajan;
GRANT ALL ON TABLE ref_location TO athiagarajan;
GRANT SELECT ON TABLE ref_location TO webuser1;


--
-- Name: ref_location__0; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_location__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_location__0 FROM athiagarajan;
GRANT ALL ON TABLE ref_location__0 TO athiagarajan;
GRANT SELECT ON TABLE ref_location__0 TO webuser1;


--
-- Name: seq_ref_location_history_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_location_history_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_location_history_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_location_history_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_location_history_id TO webuser1;


--
-- Name: ref_location_history; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_location_history FROM PUBLIC;
REVOKE ALL ON TABLE ref_location_history FROM gpadmin;
GRANT ALL ON TABLE ref_location_history TO gpadmin;
GRANT SELECT ON TABLE ref_location_history TO webuser1;


--
-- Name: ref_minority_type; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_minority_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_minority_type FROM gpadmin;
GRANT ALL ON TABLE ref_minority_type TO gpadmin;
GRANT SELECT ON TABLE ref_minority_type TO webuser1;


--
-- Name: seq_ref_misc_vendor_misc_vendor_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_misc_vendor_misc_vendor_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_misc_vendor_misc_vendor_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_misc_vendor_misc_vendor_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_misc_vendor_misc_vendor_id TO webuser1;


--
-- Name: ref_miscellaneous_vendor; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_miscellaneous_vendor FROM PUBLIC;
REVOKE ALL ON TABLE ref_miscellaneous_vendor FROM gpadmin;
GRANT ALL ON TABLE ref_miscellaneous_vendor TO gpadmin;
GRANT SELECT ON TABLE ref_miscellaneous_vendor TO webuser1;


--
-- Name: seq_ref_month_month_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_month_month_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_month_month_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_month_month_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_month_month_id TO webuser1;


--
-- Name: ref_month; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_month FROM PUBLIC;
REVOKE ALL ON TABLE ref_month FROM athiagarajan;
GRANT ALL ON TABLE ref_month TO athiagarajan;
GRANT SELECT ON TABLE ref_month TO webuser1;


--
-- Name: seq_ref_object_class_object_class_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_object_class_object_class_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_object_class_object_class_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_object_class_object_class_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_object_class_object_class_id TO webuser1;


--
-- Name: ref_object_class; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_object_class FROM PUBLIC;
REVOKE ALL ON TABLE ref_object_class FROM athiagarajan;
GRANT ALL ON TABLE ref_object_class TO athiagarajan;
GRANT SELECT ON TABLE ref_object_class TO webuser1;


--
-- Name: ref_object_class__0; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_object_class__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_object_class__0 FROM athiagarajan;
GRANT ALL ON TABLE ref_object_class__0 TO athiagarajan;
GRANT SELECT ON TABLE ref_object_class__0 TO webuser1;


--
-- Name: seq_ref_object_class_history_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_object_class_history_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_object_class_history_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_object_class_history_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_object_class_history_id TO webuser1;


--
-- Name: ref_object_class_history; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_object_class_history FROM PUBLIC;
REVOKE ALL ON TABLE ref_object_class_history FROM gpadmin;
GRANT ALL ON TABLE ref_object_class_history TO gpadmin;
GRANT SELECT ON TABLE ref_object_class_history TO webuser1;


--
-- Name: seq_ref_pay_cycle_pay_cycle_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_pay_cycle_pay_cycle_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_pay_cycle_pay_cycle_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_pay_cycle_pay_cycle_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_pay_cycle_pay_cycle_id TO webuser1;


--
-- Name: ref_pay_cycle; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_pay_cycle FROM PUBLIC;
REVOKE ALL ON TABLE ref_pay_cycle FROM gpadmin;
GRANT ALL ON TABLE ref_pay_cycle TO gpadmin;
GRANT SELECT ON TABLE ref_pay_cycle TO webuser1;


--
-- Name: seq_ref_pay_type_pay_type_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_pay_type_pay_type_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_pay_type_pay_type_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_pay_type_pay_type_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_pay_type_pay_type_id TO webuser1;


--
-- Name: ref_pay_type; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_pay_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_pay_type FROM gpadmin;
GRANT ALL ON TABLE ref_pay_type TO gpadmin;
GRANT SELECT ON TABLE ref_pay_type TO webuser1;


--
-- Name: seq_ref_payroll_frequency_payroll_frequency_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_payroll_frequency_payroll_frequency_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_payroll_frequency_payroll_frequency_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_payroll_frequency_payroll_frequency_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_payroll_frequency_payroll_frequency_id TO webuser1;


--
-- Name: ref_payroll_frequency; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_frequency FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_frequency FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_frequency TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_frequency TO webuser1;


--
-- Name: seq_ref_payroll_number_payroll_number_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_payroll_number_payroll_number_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_payroll_number_payroll_number_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_payroll_number_payroll_number_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_payroll_number_payroll_number_id TO webuser1;


--
-- Name: ref_payroll_number; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_number FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_number FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_number TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_number TO webuser1;


--
-- Name: seq_ref_payroll_object_payroll_object_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_payroll_object_payroll_object_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_payroll_object_payroll_object_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_payroll_object_payroll_object_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_payroll_object_payroll_object_id TO webuser1;


--
-- Name: ref_payroll_object; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_object FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_object FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_object TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_object TO webuser1;


--
-- Name: seq_ref_payroll_payment_payroll_payment_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_payroll_payment_payroll_payment_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_payroll_payment_payroll_payment_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_payroll_payment_payroll_payment_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_payroll_payment_payroll_payment_id TO webuser1;


--
-- Name: ref_payroll_payment_status; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_payment_status FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_payment_status FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_payment_status TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_payment_status TO webuser1;


--
-- Name: seq_ref_payroll_reporting_payroll_reporting_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_payroll_reporting_payroll_reporting_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_payroll_reporting_payroll_reporting_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_payroll_reporting_payroll_reporting_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_payroll_reporting_payroll_reporting_id TO webuser1;


--
-- Name: ref_payroll_reporting; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_reporting FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_reporting FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_reporting TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_reporting TO webuser1;


--
-- Name: ref_payroll_wage; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_wage FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_wage FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_wage TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_wage TO webuser1;


--
-- Name: seq_ref_revenue_category_revenue_category_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_revenue_category_revenue_category_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_revenue_category_revenue_category_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_revenue_category_revenue_category_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_revenue_category_revenue_category_id TO webuser1;


--
-- Name: ref_revenue_category; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_revenue_category FROM PUBLIC;
REVOKE ALL ON TABLE ref_revenue_category FROM gpadmin;
GRANT ALL ON TABLE ref_revenue_category TO gpadmin;
GRANT SELECT ON TABLE ref_revenue_category TO webuser1;


--
-- Name: seq_ref_revenue_class_revenue_class_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_revenue_class_revenue_class_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_revenue_class_revenue_class_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_revenue_class_revenue_class_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_revenue_class_revenue_class_id TO webuser1;


--
-- Name: ref_revenue_class; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_revenue_class FROM PUBLIC;
REVOKE ALL ON TABLE ref_revenue_class FROM gpadmin;
GRANT ALL ON TABLE ref_revenue_class TO gpadmin;
GRANT SELECT ON TABLE ref_revenue_class TO webuser1;


--
-- Name: seq_ref_revenue_source_revenue_source_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_revenue_source_revenue_source_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_revenue_source_revenue_source_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_revenue_source_revenue_source_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_revenue_source_revenue_source_id TO webuser1;


--
-- Name: ref_revenue_source; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_revenue_source FROM PUBLIC;
REVOKE ALL ON TABLE ref_revenue_source FROM gpadmin;
GRANT ALL ON TABLE ref_revenue_source TO gpadmin;
GRANT SELECT ON TABLE ref_revenue_source TO webuser1;


--
-- Name: ref_spending_category; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_spending_category FROM PUBLIC;
REVOKE ALL ON TABLE ref_spending_category FROM gpadmin;
GRANT ALL ON TABLE ref_spending_category TO gpadmin;
GRANT SELECT ON TABLE ref_spending_category TO webuser1;


--
-- Name: seq_ref_worksite_worksite_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_worksite_worksite_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_worksite_worksite_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_worksite_worksite_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_worksite_worksite_id TO webuser1;


--
-- Name: ref_worksite; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_worksite FROM PUBLIC;
REVOKE ALL ON TABLE ref_worksite FROM gpadmin;
GRANT ALL ON TABLE ref_worksite TO gpadmin;
GRANT SELECT ON TABLE ref_worksite TO webuser1;


--
-- Name: seq_ref_year_year_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_year_year_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_year_year_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_year_year_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_year_year_id TO webuser1;


--
-- Name: ref_year; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_year FROM PUBLIC;
REVOKE ALL ON TABLE ref_year FROM gpadmin;
GRANT ALL ON TABLE ref_year TO gpadmin;
GRANT SELECT ON TABLE ref_year TO webuser1;


--
-- Name: seq_revenue_revenue_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_revenue_revenue_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_revenue_revenue_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_revenue_revenue_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_revenue_revenue_id TO webuser1;


--
-- Name: revenue; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE revenue FROM PUBLIC;
REVOKE ALL ON TABLE revenue FROM gpadmin;
GRANT ALL ON TABLE revenue TO gpadmin;
GRANT SELECT ON TABLE revenue TO webuser1;


--
-- Name: seq_agreement_accounting_line_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_agreement_accounting_line_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_agreement_accounting_line_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_agreement_accounting_line_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_agreement_accounting_line_id TO webuser1;


--
-- Name: seq_agreement_commodity_agreement_commodity_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_agreement_commodity_agreement_commodity_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_agreement_commodity_agreement_commodity_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_agreement_commodity_agreement_commodity_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_agreement_commodity_agreement_commodity_id TO webuser1;


--
-- Name: seq_agreement_worksite_agreement_worksite_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_agreement_worksite_agreement_worksite_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_agreement_worksite_agreement_worksite_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_agreement_worksite_agreement_worksite_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_agreement_worksite_agreement_worksite_id TO webuser1;


--
-- Name: seq_disbursement_line_item_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_disbursement_line_item_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_disbursement_line_item_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_disbursement_line_item_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_disbursement_line_item_id TO webuser1;


--
-- Name: seq_expenditure_expenditure_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_expenditure_expenditure_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_expenditure_expenditure_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_expenditure_expenditure_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_expenditure_expenditure_id TO webuser1;


--
-- Name: seq_ref_budget_budget_code_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_budget_budget_code_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_budget_budget_code_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_budget_budget_code_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_budget_budget_code_id TO webuser1;


--
-- Name: seq_ref_procurement_type_procurement_type_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_ref_procurement_type_procurement_type_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_ref_procurement_type_procurement_type_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_ref_procurement_type_procurement_type_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_ref_procurement_type_procurement_type_id TO webuser1;


--
-- Name: seq_stg_budget_code_uniq_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_stg_budget_code_uniq_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_stg_budget_code_uniq_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_stg_budget_code_uniq_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_stg_budget_code_uniq_id TO webuser1;


--
-- Name: seq_test; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_test FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_test FROM gpadmin;
GRANT ALL ON SEQUENCE seq_test TO gpadmin;
GRANT SELECT ON SEQUENCE seq_test TO webuser1;


--
-- Name: seq_vendor_address_vendor_address_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_vendor_address_vendor_address_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_vendor_address_vendor_address_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_vendor_address_vendor_address_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_vendor_address_vendor_address_id TO webuser1;


--
-- Name: seq_vendor_bus_type_vendor_bus_type_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_vendor_bus_type_vendor_bus_type_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_vendor_bus_type_vendor_bus_type_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_vendor_bus_type_vendor_bus_type_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_vendor_bus_type_vendor_bus_type_id TO webuser1;


--
-- Name: seq_vendor_history_vendor_history_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_vendor_history_vendor_history_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_vendor_history_vendor_history_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_vendor_history_vendor_history_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_vendor_history_vendor_history_id TO webuser1;


--
-- Name: seq_vendor_vendor_id; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_vendor_vendor_id FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_vendor_vendor_id FROM gpadmin;
GRANT ALL ON SEQUENCE seq_vendor_vendor_id TO gpadmin;
GRANT SELECT ON SEQUENCE seq_vendor_vendor_id TO webuser1;


--
-- Name: seq_vendor_vendor_sub_code; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON SEQUENCE seq_vendor_vendor_sub_code FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_vendor_vendor_sub_code FROM gpadmin;
GRANT ALL ON SEQUENCE seq_vendor_vendor_sub_code TO gpadmin;
GRANT SELECT ON SEQUENCE seq_vendor_vendor_sub_code TO webuser1;


--
-- Name: vendor; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE vendor FROM PUBLIC;
REVOKE ALL ON TABLE vendor FROM athiagarajan;
GRANT ALL ON TABLE vendor TO athiagarajan;
GRANT SELECT ON TABLE vendor TO webuser1;


--
-- Name: vendor__0; Type: ACL; Schema: public; Owner: athiagarajan
--

REVOKE ALL ON TABLE vendor__0 FROM PUBLIC;
REVOKE ALL ON TABLE vendor__0 FROM athiagarajan;
GRANT ALL ON TABLE vendor__0 TO athiagarajan;
GRANT SELECT ON TABLE vendor__0 TO webuser1;


--
-- Name: vendor_address; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE vendor_address FROM PUBLIC;
REVOKE ALL ON TABLE vendor_address FROM gpadmin;
GRANT ALL ON TABLE vendor_address TO gpadmin;
GRANT SELECT ON TABLE vendor_address TO webuser1;


--
-- Name: vendor_business_type; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE vendor_business_type FROM PUBLIC;
REVOKE ALL ON TABLE vendor_business_type FROM gpadmin;
GRANT ALL ON TABLE vendor_business_type TO gpadmin;
GRANT SELECT ON TABLE vendor_business_type TO webuser1;


--
-- Name: vendor_history; Type: ACL; Schema: public; Owner: gpadmin
--

REVOKE ALL ON TABLE vendor_history FROM PUBLIC;
REVOKE ALL ON TABLE vendor_history FROM gpadmin;
GRANT ALL ON TABLE vendor_history TO gpadmin;
GRANT SELECT ON TABLE vendor_history TO webuser1;


--
-- Greenplum Database database dump complete
--

