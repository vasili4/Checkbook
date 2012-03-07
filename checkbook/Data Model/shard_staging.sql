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
    state bpchar,
    zip character varying,
    country bpchar
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.address to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.address__0 OWNER TO gpadmin;

--
-- Name: address; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW address AS
    SELECT address__0.address_id, address__0.address_line_1, address__0.address_line_2, address__0.city, address__0.state, address__0.zip, address__0.country FROM ONLY address__0;


ALTER TABLE staging.address OWNER TO gpadmin;

--
-- Name: aggregateon_spending_coa_entities__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE aggregateon_spending_coa_entities__0 (
    department_id integer,
    agency_id smallint,
    spending_category_id smallint,
    expenditure_object_id integer,
    month_id smallint,
    year_id smallint,
    total_spending_amount numeric,
    total_contract_amount numeric
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_spending_coa_entities to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.aggregateon_spending_coa_entities__0 OWNER TO gpadmin;

--
-- Name: aggregateon_spending_coa_entities; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW aggregateon_spending_coa_entities AS
    SELECT aggregateon_spending_coa_entities__0.department_id, aggregateon_spending_coa_entities__0.agency_id, aggregateon_spending_coa_entities__0.spending_category_id, aggregateon_spending_coa_entities__0.expenditure_object_id, aggregateon_spending_coa_entities__0.month_id, aggregateon_spending_coa_entities__0.year_id, aggregateon_spending_coa_entities__0.total_spending_amount, aggregateon_spending_coa_entities__0.total_contract_amount FROM ONLY aggregateon_spending_coa_entities__0;


ALTER TABLE staging.aggregateon_spending_coa_entities OWNER TO gpadmin;

--
-- Name: aggregateon_spending_contract__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE aggregateon_spending_contract__0 (
    agreement_id bigint,
    document_id character varying,
    vendor_id integer,
    agency_id smallint,
    description character varying,
    year_id smallint,
    total_spending_amount numeric,
    total_contract_amount numeric
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_spending_contract to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.aggregateon_spending_contract__0 OWNER TO gpadmin;

--
-- Name: aggregateon_spending_contract; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW aggregateon_spending_contract AS
    SELECT aggregateon_spending_contract__0.agreement_id, aggregateon_spending_contract__0.document_id, aggregateon_spending_contract__0.vendor_id, aggregateon_spending_contract__0.agency_id, aggregateon_spending_contract__0.description, aggregateon_spending_contract__0.year_id, aggregateon_spending_contract__0.total_spending_amount, aggregateon_spending_contract__0.total_contract_amount FROM ONLY aggregateon_spending_contract__0;


ALTER TABLE staging.aggregateon_spending_contract OWNER TO gpadmin;

--
-- Name: aggregateon_spending_vendor__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE aggregateon_spending_vendor__0 (
    vendor_id integer,
    agency_id smallint,
    year_id smallint,
    total_spending_amount numeric,
    total_contract_amount numeric
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.aggregateon_spending_vendor to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.aggregateon_spending_vendor__0 OWNER TO gpadmin;

--
-- Name: aggregateon_spending_vendor; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW aggregateon_spending_vendor AS
    SELECT aggregateon_spending_vendor__0.vendor_id, aggregateon_spending_vendor__0.agency_id, aggregateon_spending_vendor__0.year_id, aggregateon_spending_vendor__0.total_spending_amount, aggregateon_spending_vendor__0.total_contract_amount FROM ONLY aggregateon_spending_vendor__0;


ALTER TABLE staging.aggregateon_spending_vendor OWNER TO gpadmin;

--
-- Name: agreement__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
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


ALTER EXTERNAL TABLE staging.agreement__0 OWNER TO gpadmin;

--
-- Name: agreement; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW agreement AS
    SELECT agreement__0.agreement_id, agreement__0.master_agreement_id, agreement__0.document_code_id, agreement__0.agency_history_id, agreement__0.document_id, agreement__0.document_version, agreement__0.tracking_number, agreement__0.record_date_id, agreement__0.budget_fiscal_year, agreement__0.document_fiscal_year, agreement__0.document_period, agreement__0.description, agreement__0.actual_amount, agreement__0.obligated_amount, agreement__0.maximum_contract_amount, agreement__0.amendment_number, agreement__0.replacing_agreement_id, agreement__0.replaced_by_agreement_id, agreement__0.award_status_id, agreement__0.procurement_id, agreement__0.procurement_type_id, agreement__0.effective_begin_date_id, agreement__0.effective_end_date_id, agreement__0.reason_modification, agreement__0.source_created_date_id, agreement__0.source_updated_date_id, agreement__0.document_function_code_id, agreement__0.award_method_id, agreement__0.award_level_id, agreement__0.agreement_type_id, agreement__0.contract_class_code, agreement__0.award_category_id_1, agreement__0.award_category_id_2, agreement__0.award_category_id_3, agreement__0.award_category_id_4, agreement__0.award_category_id_5, agreement__0.number_responses, agreement__0.location_service, agreement__0.location_zip, agreement__0.borough_code, agreement__0.block_code, agreement__0.lot_code, agreement__0.council_district_code, agreement__0.vendor_history_id, agreement__0.vendor_preference_level, agreement__0.original_contract_amount, agreement__0.registered_date_id, agreement__0.oca_number, agreement__0.number_solicitation, agreement__0.document_name, agreement__0.original_term_begin_date_id, agreement__0.original_term_end_date_id, agreement__0.privacy_flag, agreement__0.created_load_id, agreement__0.updated_load_id, agreement__0.created_date, agreement__0.updated_date FROM ONLY agreement__0;


ALTER TABLE staging.agreement OWNER TO athiagarajan;

--
-- Name: agreement_accounting_line__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE agreement_accounting_line__0 (
    agreement_accounting_line_id bigint,
    agreement_id bigint,
    line_number integer,
    event_type_id smallint,
    description character varying,
    line_amount numeric,
    budget_fiscal_year smallint,
    fiscal_year smallint,
    fiscal_period bpchar,
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    expenditure_object_history_id integer,
    revenue_source_id smallint,
    location_code character varying,
    budget_code_id integer,
    reporting_code character varying,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement_accounting_line to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.agreement_accounting_line__0 OWNER TO gpadmin;

--
-- Name: agreement_accounting_line; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW agreement_accounting_line AS
    SELECT agreement_accounting_line__0.agreement_accounting_line_id, agreement_accounting_line__0.agreement_id, agreement_accounting_line__0.line_number, agreement_accounting_line__0.event_type_id, agreement_accounting_line__0.description, agreement_accounting_line__0.line_amount, agreement_accounting_line__0.budget_fiscal_year, agreement_accounting_line__0.fiscal_year, agreement_accounting_line__0.fiscal_period, agreement_accounting_line__0.fund_class_id, agreement_accounting_line__0.agency_history_id, agreement_accounting_line__0.department_history_id, agreement_accounting_line__0.expenditure_object_history_id, agreement_accounting_line__0.revenue_source_id, agreement_accounting_line__0.location_code, agreement_accounting_line__0.budget_code_id, agreement_accounting_line__0.reporting_code, agreement_accounting_line__0.load_id, agreement_accounting_line__0.created_date, agreement_accounting_line__0.updated_date FROM ONLY agreement_accounting_line__0;


ALTER TABLE staging.agreement_accounting_line OWNER TO gpadmin;

--
-- Name: agreement_commodity__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE agreement_commodity__0 (
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
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement_commodity to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.agreement_commodity__0 OWNER TO gpadmin;

--
-- Name: agreement_commodity; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW agreement_commodity AS
    SELECT agreement_commodity__0.agreement_commodity_id, agreement_commodity__0.agreement_id, agreement_commodity__0.line_number, agreement_commodity__0.master_agreement_yn, agreement_commodity__0.description, agreement_commodity__0.commodity_code, agreement_commodity__0.commodity_type_id, agreement_commodity__0.quantity, agreement_commodity__0.unit_of_measurement, agreement_commodity__0.unit_price, agreement_commodity__0.contract_amount, agreement_commodity__0.commodity_specification, agreement_commodity__0.load_id, agreement_commodity__0.created_date, agreement_commodity__0.updated_date FROM ONLY agreement_commodity__0;


ALTER TABLE staging.agreement_commodity OWNER TO gpadmin;

--
-- Name: agreement_worksite__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE agreement_worksite__0 (
    agreement_worksite_id bigint,
    agreement_id bigint,
    worksite_id integer,
    percentage numeric,
    amount numeric,
    master_agreement_yn bpchar,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.agreement_worksite to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.agreement_worksite__0 OWNER TO gpadmin;

--
-- Name: agreement_worksite; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW agreement_worksite AS
    SELECT agreement_worksite__0.agreement_worksite_id, agreement_worksite__0.agreement_id, agreement_worksite__0.worksite_id, agreement_worksite__0.percentage, agreement_worksite__0.amount, agreement_worksite__0.master_agreement_yn, agreement_worksite__0.load_id, agreement_worksite__0.created_date, agreement_worksite__0.updated_date FROM ONLY agreement_worksite__0;


ALTER TABLE staging.agreement_worksite OWNER TO gpadmin;

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
    adopted_amount numeric,
    current_budget_amount numeric,
    pre_encumbered_amount numeric,
    encumbered_amount numeric,
    accrued_expense_amount numeric,
    cash_expense_amount numeric,
    post_closing_adjustment_amount numeric,
    total_expenditure_amount numeric,
    updated_date_id smallint,
    load_id integer,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.budget to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.budget__0 OWNER TO gpadmin;

--
-- Name: budget; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW budget AS
    SELECT budget__0.budget_id, budget__0.budget_fiscal_year, budget__0.fund_class_id, budget__0.agency_history_id, budget__0.department_history_id, budget__0.budget_code_id, budget__0.object_class_history_id, budget__0.adopted_amount, budget__0.current_budget_amount, budget__0.pre_encumbered_amount, budget__0.encumbered_amount, budget__0.accrued_expense_amount, budget__0.cash_expense_amount, budget__0.post_closing_adjustment_amount, budget__0.total_expenditure_amount, budget__0.updated_date_id, budget__0.load_id, budget__0.created_date FROM ONLY budget__0;


ALTER TABLE staging.budget OWNER TO gpadmin;

--
-- Name: disbursement__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE disbursement__0 (
    disbursement_id integer,
    document_code_id smallint,
    agency_history_id smallint,
    document_id character varying,
    document_version integer,
    record_date_id smallint,
    budget_fiscal_year smallint,
    document_fiscal_year smallint,
    document_period bpchar,
    check_eft_amount numeric,
    check_eft_issued_date_id smallint,
    check_eft_record_date_id smallint,
    expenditure_status_id smallint,
    expenditure_cancel_type_id smallint,
    expenditure_cancel_reason_id integer,
    total_accounting_line_amount numeric,
    vendor_history_id integer,
    retainage_amount numeric,
    privacy_flag bpchar,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.disbursement to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.disbursement__0 OWNER TO gpadmin;

--
-- Name: disbursement; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW disbursement AS
    SELECT disbursement__0.disbursement_id, disbursement__0.document_code_id, disbursement__0.agency_history_id, disbursement__0.document_id, disbursement__0.document_version, disbursement__0.record_date_id, disbursement__0.budget_fiscal_year, disbursement__0.document_fiscal_year, disbursement__0.document_period, disbursement__0.check_eft_amount, disbursement__0.check_eft_issued_date_id, disbursement__0.check_eft_record_date_id, disbursement__0.expenditure_status_id, disbursement__0.expenditure_cancel_type_id, disbursement__0.expenditure_cancel_reason_id, disbursement__0.total_accounting_line_amount, disbursement__0.vendor_history_id, disbursement__0.retainage_amount, disbursement__0.privacy_flag, disbursement__0.load_id, disbursement__0.created_date, disbursement__0.updated_date FROM ONLY disbursement__0;


ALTER TABLE staging.disbursement OWNER TO gpadmin;

--
-- Name: disbursement_line_item__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE disbursement_line_item__0 (
    disbursement_line_item_id bigint,
    disbursement_id integer,
    line_number integer,
    budget_fiscal_year smallint,
    fiscal_year smallint,
    fiscal_period bpchar,
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    expenditure_object_history_id integer,
    budget_code_id integer,
    fund_id smallint,
    reporting_code character varying,
    check_amount numeric,
    agreement_id bigint,
    agreement_accounting_line_number integer,
    location_history_id integer,
    retainage_amount numeric,
    check_eft_issued_nyc_year_id smallint,
    created_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    updated_load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.disbursement_line_item to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.disbursement_line_item__0 OWNER TO gpadmin;

--
-- Name: disbursement_line_item; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW disbursement_line_item AS
    SELECT disbursement_line_item__0.disbursement_line_item_id, disbursement_line_item__0.disbursement_id, disbursement_line_item__0.line_number, disbursement_line_item__0.budget_fiscal_year, disbursement_line_item__0.fiscal_year, disbursement_line_item__0.fiscal_period, disbursement_line_item__0.fund_class_id, disbursement_line_item__0.agency_history_id, disbursement_line_item__0.department_history_id, disbursement_line_item__0.expenditure_object_history_id, disbursement_line_item__0.budget_code_id, disbursement_line_item__0.fund_id, disbursement_line_item__0.reporting_code, disbursement_line_item__0.check_amount, disbursement_line_item__0.agreement_id, disbursement_line_item__0.agreement_accounting_line_number, disbursement_line_item__0.location_history_id, disbursement_line_item__0.retainage_amount, disbursement_line_item__0.check_eft_issued_nyc_year_id, disbursement_line_item__0.created_load_id, disbursement_line_item__0.created_date, disbursement_line_item__0.updated_date, disbursement_line_item__0.updated_load_id FROM ONLY disbursement_line_item__0;


ALTER TABLE staging.disbursement_line_item OWNER TO gpadmin;

--
-- Name: fact_agreement__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE fact_agreement__0 (
    agreement_id bigint,
    master_agreement_id bigint,
    document_code_id smallint,
    agency_id smallint,
    document_id character varying,
    document_version integer,
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
    registered_date_id smallint,
    maximum_contract_amount numeric,
    award_method_id smallint,
    vendor_id integer,
    original_contract_amount numeric,
    master_agreement_yn bpchar,
    description character varying,
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
	tracking_number varchar    
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.fact_agreement to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.fact_agreement__0 OWNER TO gpadmin;

--
-- Name: fact_agreement; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW fact_agreement AS
    SELECT fact_agreement__0.agreement_id, fact_agreement__0.master_agreement_id, fact_agreement__0.document_code_id, fact_agreement__0.agency_id, fact_agreement__0.document_id, fact_agreement__0.document_version, fact_agreement__0.effective_begin_date_id, fact_agreement__0.effective_end_date_id, fact_agreement__0.registered_date_id, fact_agreement__0.maximum_contract_amount, fact_agreement__0.award_method_id, fact_agreement__0.vendor_id, fact_agreement__0.original_contract_amount, fact_agreement__0.master_agreement_yn, fact_agreement__0.description ,
    fact_agreement__0.document_code,fact_agreement__0.master_document_id,fact_agreement__0.amount_spent,fact_agreement__0.agency_history_id,fact_agreement__0.agency_name,fact_agreement__0.vendor_history_id,fact_agreement__0.vendor_name,fact_agreement__0.worksites_name,fact_agreement__0.agreement_type_id,fact_agreement__0.award_category_id_1,fact_agreement__0.expenditure_objects_name,fact_agreement__0.record_date,fact_agreement__0.effective_begin_date,fact_agreement__0.effective_end_date,fact_agreement__0.tracking_number FROM ONLY fact_agreement__0;


ALTER TABLE staging.fact_agreement OWNER TO gpadmin;

--
-- Name: fact_agreement_accounting_line__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE fact_agreement_accounting_line__0 (
    agreement_id bigint,
    line_amount numeric
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.fact_agreement_accounting_line to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.fact_agreement_accounting_line__0 OWNER TO gpadmin;

--
-- Name: fact_agreement_accounting_line; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW fact_agreement_accounting_line AS
    SELECT fact_agreement_accounting_line__0.agreement_id, fact_agreement_accounting_line__0.line_amount FROM ONLY fact_agreement_accounting_line__0;


ALTER TABLE staging.fact_agreement_accounting_line OWNER TO gpadmin;

--
-- Name: fact_disbursement_line_item__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE fact_disbursement_line_item__0 (
    disbursement_line_item_id bigint,
    disbursement_id integer,
    line_number integer,
    check_eft_issued_date_id smallint,
    check_eft_issued_nyc_year_id smallint,
    check_eft_issued_cal_month_id smallint,
    agreement_id bigint,
    master_agreement_id bigint,
    fund_class_id smallint,
    check_amount numeric,
    agency_id smallint,
    expenditure_object_id integer,
    vendor_id integer,
    department_id integer,
    maximum_contract_amount numeric,
    maximum_spending_limit numeric    
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.fact_disbursement_line_item to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.fact_disbursement_line_item__0 OWNER TO gpadmin;

--
-- Name: fact_disbursement_line_item; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW fact_disbursement_line_item AS
    SELECT fact_disbursement_line_item__0.disbursement_line_item_id, fact_disbursement_line_item__0.disbursement_id, fact_disbursement_line_item__0.line_number, fact_disbursement_line_item__0.check_eft_issued_date_id, fact_disbursement_line_item__0.check_eft_issued_nyc_year_id, fact_disbursement_line_item__0.check_eft_issued_cal_month_id, fact_disbursement_line_item__0.agreement_id, fact_disbursement_line_item__0.master_agreement_id, fact_disbursement_line_item__0.fund_class_id, fact_disbursement_line_item__0.check_amount, fact_disbursement_line_item__0.agency_id, fact_disbursement_line_item__0.expenditure_object_id, fact_disbursement_line_item__0.vendor_id, fact_disbursement_line_item__0.department_id,fact_disbursement_line_item__0.maximum_contract_amount, fact_disbursement_line_item__0.maximum_spending_limit FROM ONLY fact_disbursement_line_item__0;


ALTER TABLE staging.fact_disbursement_line_item OWNER TO gpadmin;

--
-- Name: fact_disbursement_line_item_new__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE fact_disbursement_line_item_new__0 (
    disbursement_line_item_id bigint,
    disbursement_id integer,
    line_number integer,
    check_eft_issued_date_id smallint,
    check_eft_issued_nyc_year_id smallint,
    check_eft_issued_cal_month_id smallint,
    agreement_id bigint,
    master_agreement_id bigint,
    fund_class_id smallint,
    check_amount numeric,
    agency_id smallint,
    expenditure_object_id integer,
    vendor_id integer,
    maximum_contract_amount numeric,
    maximum_spending_limit numeric
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.fact_disbursement_line_item_new to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.fact_disbursement_line_item_new__0 OWNER TO gpadmin;

--
-- Name: fact_disbursement_line_item_new; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW fact_disbursement_line_item_new AS
    SELECT fact_disbursement_line_item_new__0.disbursement_line_item_id, fact_disbursement_line_item_new__0.disbursement_id, fact_disbursement_line_item_new__0.line_number, fact_disbursement_line_item_new__0.check_eft_issued_date_id, fact_disbursement_line_item_new__0.check_eft_issued_nyc_year_id, fact_disbursement_line_item_new__0.check_eft_issued_cal_month_id, fact_disbursement_line_item_new__0.agreement_id, fact_disbursement_line_item_new__0.master_agreement_id, fact_disbursement_line_item_new__0.fund_class_id, fact_disbursement_line_item_new__0.check_amount, fact_disbursement_line_item_new__0.agency_id, fact_disbursement_line_item_new__0.expenditure_object_id, fact_disbursement_line_item_new__0.vendor_id, fact_disbursement_line_item_new__0.maximum_contract_amount, fact_disbursement_line_item_new__0.maximum_spending_limit FROM ONLY fact_disbursement_line_item_new__0;


ALTER TABLE staging.fact_disbursement_line_item_new OWNER TO gpadmin;

--
-- Name: fact_revenue__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE fact_revenue__0 (
    revenue_id bigint,
    fiscal_year smallint,
    fiscal_period bpchar,
    posting_amount numeric,
    revenue_category_id smallint,
    revenue_source_id smallint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.fact_revenue to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.fact_revenue__0 OWNER TO gpadmin;

--
-- Name: fact_revenue; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW fact_revenue AS
    SELECT fact_revenue__0.revenue_id, fact_revenue__0.fiscal_year, fact_revenue__0.fiscal_period, fact_revenue__0.posting_amount, fact_revenue__0.revenue_category_id, fact_revenue__0.revenue_source_id FROM ONLY fact_revenue__0;


ALTER TABLE staging.fact_revenue OWNER TO gpadmin;

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
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.history_agreement to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.history_agreement__0 OWNER TO gpadmin;

--
-- Name: history_agreement; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW history_agreement AS
    SELECT history_agreement__0.agreement_id, history_agreement__0.master_agreement_id, history_agreement__0.document_code_id, history_agreement__0.agency_history_id, history_agreement__0.document_id, history_agreement__0.document_version, history_agreement__0.tracking_number, history_agreement__0.record_date_id, history_agreement__0.budget_fiscal_year, history_agreement__0.document_fiscal_year, history_agreement__0.document_period, history_agreement__0.description, history_agreement__0.actual_amount, history_agreement__0.obligated_amount, history_agreement__0.maximum_contract_amount, history_agreement__0.amendment_number, history_agreement__0.replacing_agreement_id, history_agreement__0.replaced_by_agreement_id, history_agreement__0.award_status_id, history_agreement__0.procurement_id, history_agreement__0.procurement_type_id, history_agreement__0.effective_begin_date_id, history_agreement__0.effective_end_date_id, history_agreement__0.reason_modification, history_agreement__0.source_created_date_id, history_agreement__0.source_updated_date_id, history_agreement__0.document_function_code_id, history_agreement__0.award_method_id, history_agreement__0.award_level_id, history_agreement__0.agreement_type_id, history_agreement__0.contract_class_code, history_agreement__0.award_category_id_1, history_agreement__0.award_category_id_2, history_agreement__0.award_category_id_3, history_agreement__0.award_category_id_4, history_agreement__0.award_category_id_5, history_agreement__0.number_responses, history_agreement__0.location_service, history_agreement__0.location_zip, history_agreement__0.borough_code, history_agreement__0.block_code, history_agreement__0.lot_code, history_agreement__0.council_district_code, history_agreement__0.vendor_history_id, history_agreement__0.vendor_preference_level, history_agreement__0.original_contract_amount, history_agreement__0.registered_date_id, history_agreement__0.oca_number, history_agreement__0.number_solicitation, history_agreement__0.document_name, history_agreement__0.original_term_begin_date_id, history_agreement__0.original_term_end_date_id, history_agreement__0.privacy_flag, history_agreement__0.created_load_id, history_agreement__0.updated_load_id, history_agreement__0.created_date, history_agreement__0.updated_date FROM ONLY history_agreement__0;


ALTER TABLE staging.history_agreement OWNER TO athiagarajan;

--
-- Name: history_agreement_accounting_line__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE history_agreement_accounting_line__0 (
    agreement_accounting_line_id bigint,
    agreement_id bigint,
    line_number integer,
    event_type_id smallint,
    description character varying,
    line_amount numeric,
    budget_fiscal_year smallint,
    fiscal_year smallint,
    fiscal_period bpchar,
    fund_class_id smallint,
    agency_history_id smallint,
    department_history_id integer,
    expenditure_object_history_id integer,
    revenue_source_id smallint,
    location_code character varying,
    budget_code_id integer,
    reporting_code character varying,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.history_agreement_accounting_line to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.history_agreement_accounting_line__0 OWNER TO gpadmin;

--
-- Name: history_agreement_accounting_line; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW history_agreement_accounting_line AS
    SELECT history_agreement_accounting_line__0.agreement_accounting_line_id, history_agreement_accounting_line__0.agreement_id, history_agreement_accounting_line__0.line_number, history_agreement_accounting_line__0.event_type_id, history_agreement_accounting_line__0.description, history_agreement_accounting_line__0.line_amount, history_agreement_accounting_line__0.budget_fiscal_year, history_agreement_accounting_line__0.fiscal_year, history_agreement_accounting_line__0.fiscal_period, history_agreement_accounting_line__0.fund_class_id, history_agreement_accounting_line__0.agency_history_id, history_agreement_accounting_line__0.department_history_id, history_agreement_accounting_line__0.expenditure_object_history_id, history_agreement_accounting_line__0.revenue_source_id, history_agreement_accounting_line__0.location_code, history_agreement_accounting_line__0.budget_code_id, history_agreement_accounting_line__0.reporting_code, history_agreement_accounting_line__0.load_id, history_agreement_accounting_line__0.created_date, history_agreement_accounting_line__0.updated_date FROM ONLY history_agreement_accounting_line__0;


ALTER TABLE staging.history_agreement_accounting_line OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.history_agreement_commodity__0 OWNER TO gpadmin;

--
-- Name: history_agreement_commodity; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW history_agreement_commodity AS
    SELECT history_agreement_commodity__0.agreement_commodity_id, history_agreement_commodity__0.agreement_id, history_agreement_commodity__0.line_number, history_agreement_commodity__0.master_agreement_yn, history_agreement_commodity__0.description, history_agreement_commodity__0.commodity_code, history_agreement_commodity__0.commodity_type_id, history_agreement_commodity__0.quantity, history_agreement_commodity__0.unit_of_measurement, history_agreement_commodity__0.unit_price, history_agreement_commodity__0.contract_amount, history_agreement_commodity__0.commodity_specification, history_agreement_commodity__0.load_id, history_agreement_commodity__0.created_date, history_agreement_commodity__0.updated_date FROM ONLY history_agreement_commodity__0;


ALTER TABLE staging.history_agreement_commodity OWNER TO gpadmin;

--
-- Name: history_agreement_worksite__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE history_agreement_worksite__0 (
    agreement_worksite_id bigint,
    agreement_id bigint,
    worksite_id integer,
    percentage numeric,
    amount numeric,
    master_agreement_yn bpchar,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.history_agreement_worksite to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.history_agreement_worksite__0 OWNER TO gpadmin;

--
-- Name: history_agreement_worksite; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW history_agreement_worksite AS
    SELECT history_agreement_worksite__0.agreement_worksite_id, history_agreement_worksite__0.agreement_id, history_agreement_worksite__0.worksite_id, history_agreement_worksite__0.percentage, history_agreement_worksite__0.amount, history_agreement_worksite__0.master_agreement_yn, history_agreement_worksite__0.load_id, history_agreement_worksite__0.created_date, history_agreement_worksite__0.updated_date FROM ONLY history_agreement_worksite__0;


ALTER TABLE staging.history_agreement_worksite OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.history_master_agreement__0 OWNER TO gpadmin;

--
-- Name: history_master_agreement; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW history_master_agreement AS
    SELECT history_master_agreement__0.master_agreement_id, history_master_agreement__0.document_code_id, history_master_agreement__0.agency_history_id, history_master_agreement__0.document_id, history_master_agreement__0.document_version, history_master_agreement__0.tracking_number, history_master_agreement__0.record_date_id, history_master_agreement__0.budget_fiscal_year, history_master_agreement__0.document_fiscal_year, history_master_agreement__0.document_period, history_master_agreement__0.description, history_master_agreement__0.actual_amount, history_master_agreement__0.total_amount, history_master_agreement__0.replacing_master_agreement_id, history_master_agreement__0.replaced_by_master_agreement_id, history_master_agreement__0.award_status_id, history_master_agreement__0.procurement_id, history_master_agreement__0.procurement_type_id, history_master_agreement__0.effective_begin_date_id, history_master_agreement__0.effective_end_date_id, history_master_agreement__0.reason_modification, history_master_agreement__0.source_created_date_id, history_master_agreement__0.source_updated_date_id, history_master_agreement__0.document_function_code_id, history_master_agreement__0.award_method_id, history_master_agreement__0.agreement_type_id, history_master_agreement__0.award_category_id_1, history_master_agreement__0.award_category_id_2, history_master_agreement__0.award_category_id_3, history_master_agreement__0.award_category_id_4, history_master_agreement__0.award_category_id_5, history_master_agreement__0.number_responses, history_master_agreement__0.location_service, history_master_agreement__0.location_zip, history_master_agreement__0.borough_code, history_master_agreement__0.block_code, history_master_agreement__0.lot_code, history_master_agreement__0.council_district_code, history_master_agreement__0.vendor_history_id, history_master_agreement__0.vendor_preference_level, history_master_agreement__0.board_approved_award_no, history_master_agreement__0.board_approved_award_date_id, history_master_agreement__0.original_contract_amount, history_master_agreement__0.oca_number, history_master_agreement__0.original_term_begin_date_id, history_master_agreement__0.original_term_end_date_id, history_master_agreement__0.registered_date_id, history_master_agreement__0.maximum_amount, history_master_agreement__0.maximum_spending_limit, history_master_agreement__0.award_level_id, history_master_agreement__0.contract_class_code, history_master_agreement__0.number_solicitation, history_master_agreement__0.document_name, history_master_agreement__0.privacy_flag, history_master_agreement__0.created_load_id, history_master_agreement__0.updated_load_id, history_master_agreement__0.created_date, history_master_agreement__0.updated_date FROM ONLY history_master_agreement__0;


ALTER TABLE staging.history_master_agreement OWNER TO athiagarajan;

--
-- Name: master_agreement__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE master_agreement__0 (
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
    created_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone,
    privacy_flag bpchar,
    updated_load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.master_agreement to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.master_agreement__0 OWNER TO gpadmin;

--
-- Name: master_agreement; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW master_agreement AS
    SELECT master_agreement__0.master_agreement_id, master_agreement__0.document_code_id, master_agreement__0.agency_history_id, master_agreement__0.document_id, master_agreement__0.document_version, master_agreement__0.tracking_number, master_agreement__0.record_date_id, master_agreement__0.budget_fiscal_year, master_agreement__0.document_fiscal_year, master_agreement__0.document_period, master_agreement__0.description, master_agreement__0.actual_amount, master_agreement__0.total_amount, master_agreement__0.replacing_master_agreement_id, master_agreement__0.replaced_by_master_agreement_id, master_agreement__0.award_status_id, master_agreement__0.procurement_id, master_agreement__0.procurement_type_id, master_agreement__0.effective_begin_date_id, master_agreement__0.effective_end_date_id, master_agreement__0.reason_modification, master_agreement__0.source_created_date_id, master_agreement__0.source_updated_date_id, master_agreement__0.document_function_code_id, master_agreement__0.award_method_id, master_agreement__0.agreement_type_id, master_agreement__0.award_category_id_1, master_agreement__0.award_category_id_2, master_agreement__0.award_category_id_3, master_agreement__0.award_category_id_4, master_agreement__0.award_category_id_5, master_agreement__0.number_responses, master_agreement__0.location_service, master_agreement__0.location_zip, master_agreement__0.borough_code, master_agreement__0.block_code, master_agreement__0.lot_code, master_agreement__0.council_district_code, master_agreement__0.vendor_history_id, master_agreement__0.vendor_preference_level, master_agreement__0.board_approved_award_no, master_agreement__0.board_approved_award_date_id, master_agreement__0.original_contract_amount, master_agreement__0.oca_number, master_agreement__0.original_term_begin_date_id, master_agreement__0.original_term_end_date_id, master_agreement__0.registered_date_id, master_agreement__0.maximum_amount, master_agreement__0.maximum_spending_limit, master_agreement__0.award_level_id, master_agreement__0.contract_class_code, master_agreement__0.number_solicitation, master_agreement__0.document_name, master_agreement__0.created_load_id, master_agreement__0.created_date, master_agreement__0.updated_date, master_agreement__0.privacy_flag, master_agreement__0.updated_load_id FROM ONLY master_agreement__0;


ALTER TABLE staging.master_agreement OWNER TO gpadmin;

--
-- Name: payroll_summary__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE payroll_summary__0 (
    payroll_summary_id bigint,
    agency_history_id smallint,
    pay_cycle_id smallint,
    expenditure_object_history_id integer,
    payroll_number_id smallint,
    department_history_id integer,
    fiscal_year smallint,
    budget_code_id integer,
    total_amount numeric,
    pay_date_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.payroll_summary to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.payroll_summary__0 OWNER TO gpadmin;

--
-- Name: payroll_summary; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW payroll_summary AS
    SELECT payroll_summary__0.payroll_summary_id, payroll_summary__0.agency_history_id, payroll_summary__0.pay_cycle_id, payroll_summary__0.expenditure_object_history_id, payroll_summary__0.payroll_number_id, payroll_summary__0.department_history_id, payroll_summary__0.fiscal_year, payroll_summary__0.budget_code_id, payroll_summary__0.total_amount, payroll_summary__0.pay_date_id, payroll_summary__0.load_id, payroll_summary__0.created_date, payroll_summary__0.updated_date FROM ONLY payroll_summary__0;


ALTER TABLE staging.payroll_summary OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_address_type__0 OWNER TO gpadmin;

--
-- Name: ref_address_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_address_type AS
    SELECT ref_address_type__0.address_type_id, ref_address_type__0.address_type_code, ref_address_type__0.address_type_name, ref_address_type__0.created_date FROM ONLY ref_address_type__0;


ALTER TABLE staging.ref_address_type OWNER TO gpadmin;

--
-- Name: ref_agency__0; Type: EXTERNAL TABLE; Schema: staging; Owner: athiagarajan; Tablespace: 
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


ALTER EXTERNAL TABLE staging.ref_agency__0 OWNER TO athiagarajan;

--
-- Name: ref_agency; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW ref_agency AS
    SELECT ref_agency__0.agency_id, ref_agency__0.agency_code, ref_agency__0.agency_name, ref_agency__0.original_agency_name, ref_agency__0.created_date, ref_agency__0.updated_date, ref_agency__0.created_load_id, ref_agency__0.updated_load_id FROM ONLY ref_agency__0;


ALTER TABLE staging.ref_agency OWNER TO athiagarajan;

--
-- Name: ref_agency_history__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_agency_history__0 (
    agency_history_id smallint,
    agency_id smallint,
    agency_name character varying,
    created_date timestamp without time zone,
    load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_agency_history to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_agency_history__0 OWNER TO gpadmin;

--
-- Name: ref_agency_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_agency_history AS
    SELECT ref_agency_history__0.agency_history_id, ref_agency_history__0.agency_id, ref_agency_history__0.agency_name, ref_agency_history__0.created_date, ref_agency_history__0.load_id FROM ONLY ref_agency_history__0;


ALTER TABLE staging.ref_agency_history OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_agreement_type__0 OWNER TO gpadmin;

--
-- Name: ref_agreement_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_agreement_type AS
    SELECT ref_agreement_type__0.agreement_type_id, ref_agreement_type__0.agreement_type_code, ref_agreement_type__0.agreement_type_name, ref_agreement_type__0.created_date FROM ONLY ref_agreement_type__0;


ALTER TABLE staging.ref_agreement_type OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_award_category__0 OWNER TO gpadmin;

--
-- Name: ref_award_category; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_award_category AS
    SELECT ref_award_category__0.award_category_id, ref_award_category__0.award_category_code, ref_award_category__0.award_category_name, ref_award_category__0.created_date FROM ONLY ref_award_category__0;


ALTER TABLE staging.ref_award_category OWNER TO gpadmin;

--
-- Name: ref_award_level__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_award_level__0 (
    award_level_id smallint,
    award_level_code character varying,
    award_level_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_award_level to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_award_level__0 OWNER TO gpadmin;

--
-- Name: ref_award_level; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_award_level AS
    SELECT ref_award_level__0.award_level_id, ref_award_level__0.award_level_code, ref_award_level__0.award_level_name, ref_award_level__0.created_date FROM ONLY ref_award_level__0;


ALTER TABLE staging.ref_award_level OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_award_method__0 OWNER TO gpadmin;

--
-- Name: ref_award_method; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_award_method AS
    SELECT ref_award_method__0.award_method_id, ref_award_method__0.award_method_code, ref_award_method__0.award_method_name, ref_award_method__0.created_date FROM ONLY ref_award_method__0;


ALTER TABLE staging.ref_award_method OWNER TO gpadmin;

--
-- Name: ref_award_status__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_award_status__0 (
    award_status_id smallint,
    award_status_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_award_status to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_award_status__0 OWNER TO gpadmin;

--
-- Name: ref_award_status; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_award_status AS
    SELECT ref_award_status__0.award_status_id, ref_award_status__0.award_status_name, ref_award_status__0.created_date FROM ONLY ref_award_status__0;


ALTER TABLE staging.ref_award_status OWNER TO gpadmin;

--
-- Name: ref_balance_number__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_balance_number__0 (
    balance_number_id smallint,
    balance_number character varying,
    description character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_balance_number to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_balance_number__0 OWNER TO gpadmin;

--
-- Name: ref_balance_number; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_balance_number AS
    SELECT ref_balance_number__0.balance_number_id, ref_balance_number__0.balance_number, ref_balance_number__0.description, ref_balance_number__0.created_date FROM ONLY ref_balance_number__0;


ALTER TABLE staging.ref_balance_number OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_budget_code__0 OWNER TO gpadmin;

--
-- Name: ref_budget_code; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_budget_code AS
    SELECT ref_budget_code__0.budget_code_id, ref_budget_code__0.fiscal_year, ref_budget_code__0.budget_code, ref_budget_code__0.agency_id, ref_budget_code__0.fund_class_id, ref_budget_code__0.budget_code_name, ref_budget_code__0.attribute_name, ref_budget_code__0.attribute_short_name, ref_budget_code__0.responsibility_center, ref_budget_code__0.control_category, ref_budget_code__0.ua_funding_flag, ref_budget_code__0.payroll_default_flag, ref_budget_code__0.budget_function, ref_budget_code__0.description, ref_budget_code__0.created_date, ref_budget_code__0.load_id, ref_budget_code__0.updated_date, ref_budget_code__0.updated_load_id FROM ONLY ref_budget_code__0;


ALTER TABLE staging.ref_budget_code OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_business_type__0 OWNER TO gpadmin;

--
-- Name: ref_business_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_business_type AS
    SELECT ref_business_type__0.business_type_id, ref_business_type__0.business_type_code, ref_business_type__0.business_type_name, ref_business_type__0.created_date FROM ONLY ref_business_type__0;


ALTER TABLE staging.ref_business_type OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_business_type_status__0 OWNER TO gpadmin;

--
-- Name: ref_business_type_status; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_business_type_status AS
    SELECT ref_business_type_status__0.business_type_status_id, ref_business_type_status__0.business_type_status, ref_business_type_status__0.created_date FROM ONLY ref_business_type_status__0;


ALTER TABLE staging.ref_business_type_status OWNER TO gpadmin;

--
-- Name: ref_commodity_type__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_commodity_type__0 (
    commodity_type_id smallint,
    commodity_type_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_commodity_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_commodity_type__0 OWNER TO gpadmin;

--
-- Name: ref_commodity_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_commodity_type AS
    SELECT ref_commodity_type__0.commodity_type_id, ref_commodity_type__0.commodity_type_name, ref_commodity_type__0.created_date FROM ONLY ref_commodity_type__0;


ALTER TABLE staging.ref_commodity_type OWNER TO gpadmin;

--
-- Name: ref_data_source__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_data_source__0 (
    data_source_code character varying,
    description character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_data_source to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_data_source__0 OWNER TO gpadmin;

--
-- Name: ref_data_source; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_data_source AS
    SELECT ref_data_source__0.data_source_code, ref_data_source__0.description, ref_data_source__0.created_date FROM ONLY ref_data_source__0;


ALTER TABLE staging.ref_data_source OWNER TO gpadmin;

--
-- Name: ref_date__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_date__0 (
    date_id smallint,
    date date,
    nyc_year_id smallint,
    calendar_month_id smallint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_date to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_date__0 OWNER TO gpadmin;

--
-- Name: ref_date; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_date AS
    SELECT ref_date__0.date_id, ref_date__0.date, ref_date__0.nyc_year_id, ref_date__0.calendar_month_id FROM ONLY ref_date__0;


ALTER TABLE staging.ref_date OWNER TO gpadmin;

--
-- Name: ref_department__0; Type: EXTERNAL TABLE; Schema: staging; Owner: athiagarajan; Tablespace: 
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


ALTER EXTERNAL TABLE staging.ref_department__0 OWNER TO athiagarajan;

--
-- Name: ref_department; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW ref_department AS
    SELECT ref_department__0.department_id, ref_department__0.department_code, ref_department__0.department_name, ref_department__0.agency_id, ref_department__0.fund_class_id, ref_department__0.fiscal_year, ref_department__0.original_department_name, ref_department__0.created_date, ref_department__0.updated_date, ref_department__0.created_load_id, ref_department__0.updated_load_id FROM ONLY ref_department__0;


ALTER TABLE staging.ref_department OWNER TO athiagarajan;

--
-- Name: ref_department_history__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_department_history__0 (
    department_history_id integer,
    department_id integer,
    department_name character varying,
    agency_id smallint,
    fund_class_id smallint,
    fiscal_year smallint,
    created_date timestamp without time zone,
    load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_department_history to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_department_history__0 OWNER TO gpadmin;

--
-- Name: ref_department_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_department_history AS
    SELECT ref_department_history__0.department_history_id, ref_department_history__0.department_id, ref_department_history__0.department_name, ref_department_history__0.agency_id, ref_department_history__0.fund_class_id, ref_department_history__0.fiscal_year, ref_department_history__0.created_date, ref_department_history__0.load_id FROM ONLY ref_department_history__0;


ALTER TABLE staging.ref_department_history OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_document_code__0 OWNER TO gpadmin;

--
-- Name: ref_document_code; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_document_code AS
    SELECT ref_document_code__0.document_code_id, ref_document_code__0.document_code, ref_document_code__0.document_name, ref_document_code__0.created_date FROM ONLY ref_document_code__0;


ALTER TABLE staging.ref_document_code OWNER TO gpadmin;

--
-- Name: ref_document_function_code__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_document_function_code__0 (
    document_function_code_id smallint,
    document_function_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_document_function_code to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_document_function_code__0 OWNER TO gpadmin;

--
-- Name: ref_document_function_code; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_document_function_code AS
    SELECT ref_document_function_code__0.document_function_code_id, ref_document_function_code__0.document_function_name, ref_document_function_code__0.created_date FROM ONLY ref_document_function_code__0;


ALTER TABLE staging.ref_document_function_code OWNER TO gpadmin;

--
-- Name: ref_employee_category__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_employee_category__0 (
    employee_category_id smallint,
    employee_category_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_employee_category to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_employee_category__0 OWNER TO gpadmin;

--
-- Name: ref_employee_category; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_employee_category AS
    SELECT ref_employee_category__0.employee_category_id, ref_employee_category__0.employee_category_name, ref_employee_category__0.created_date FROM ONLY ref_employee_category__0;


ALTER TABLE staging.ref_employee_category OWNER TO gpadmin;

--
-- Name: ref_employee_classification__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_employee_classification__0 (
    employee_classification_id smallint,
    employee_classification_code character varying,
    employee_classification_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_employee_classification to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_employee_classification__0 OWNER TO gpadmin;

--
-- Name: ref_employee_classification; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_employee_classification AS
    SELECT ref_employee_classification__0.employee_classification_id, ref_employee_classification__0.employee_classification_code, ref_employee_classification__0.employee_classification_name, ref_employee_classification__0.created_date FROM ONLY ref_employee_classification__0;


ALTER TABLE staging.ref_employee_classification OWNER TO gpadmin;

--
-- Name: ref_employee_sub_category__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_employee_sub_category__0 (
    employee_sub_category_id smallint,
    employee_sub_category_name character varying,
    employee_category_id smallint,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_employee_sub_category to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_employee_sub_category__0 OWNER TO gpadmin;

--
-- Name: ref_employee_sub_category; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_employee_sub_category AS
    SELECT ref_employee_sub_category__0.employee_sub_category_id, ref_employee_sub_category__0.employee_sub_category_name, ref_employee_sub_category__0.employee_category_id, ref_employee_sub_category__0.created_date FROM ONLY ref_employee_sub_category__0;


ALTER TABLE staging.ref_employee_sub_category OWNER TO gpadmin;

--
-- Name: ref_event_type__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_event_type__0 (
    event_type_id smallint,
    event_type_code character varying,
    event_type_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_event_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_event_type__0 OWNER TO gpadmin;

--
-- Name: ref_event_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_event_type AS
    SELECT ref_event_type__0.event_type_id, ref_event_type__0.event_type_code, ref_event_type__0.event_type_name, ref_event_type__0.created_date FROM ONLY ref_event_type__0;


ALTER TABLE staging.ref_event_type OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_expenditure_cancel_reason__0 OWNER TO gpadmin;

--
-- Name: ref_expenditure_cancel_reason; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_expenditure_cancel_reason AS
    SELECT ref_expenditure_cancel_reason__0.expenditure_cancel_reason_id, ref_expenditure_cancel_reason__0.expenditure_cancel_reason_name, ref_expenditure_cancel_reason__0.created_date FROM ONLY ref_expenditure_cancel_reason__0;


ALTER TABLE staging.ref_expenditure_cancel_reason OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_expenditure_cancel_type__0 OWNER TO gpadmin;

--
-- Name: ref_expenditure_cancel_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_expenditure_cancel_type AS
    SELECT ref_expenditure_cancel_type__0.expenditure_cancel_type_id, ref_expenditure_cancel_type__0.expenditure_cancel_type_name, ref_expenditure_cancel_type__0.created_date FROM ONLY ref_expenditure_cancel_type__0;


ALTER TABLE staging.ref_expenditure_cancel_type OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_expenditure_object__0 OWNER TO athiagarajan;

--
-- Name: ref_expenditure_object; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW ref_expenditure_object AS
    SELECT ref_expenditure_object__0.expenditure_object_id, ref_expenditure_object__0.expenditure_object_code, ref_expenditure_object__0.expenditure_object_name, ref_expenditure_object__0.fiscal_year, ref_expenditure_object__0.original_expenditure_object_name, ref_expenditure_object__0.created_date, ref_expenditure_object__0.updated_date, ref_expenditure_object__0.created_load_id, ref_expenditure_object__0.updated_load_id FROM ONLY ref_expenditure_object__0;


ALTER TABLE staging.ref_expenditure_object OWNER TO athiagarajan;

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


ALTER EXTERNAL TABLE staging.ref_expenditure_object_history__0 OWNER TO gpadmin;

--
-- Name: ref_expenditure_object_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_expenditure_object_history AS
    SELECT ref_expenditure_object_history__0.expenditure_object_history_id, ref_expenditure_object_history__0.expenditure_object_id, ref_expenditure_object_history__0.expenditure_object_name, ref_expenditure_object_history__0.fiscal_year, ref_expenditure_object_history__0.created_date, ref_expenditure_object_history__0.load_id FROM ONLY ref_expenditure_object_history__0;


ALTER TABLE staging.ref_expenditure_object_history OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_expenditure_privacy_type__0 OWNER TO gpadmin;

--
-- Name: ref_expenditure_privacy_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_expenditure_privacy_type AS
    SELECT ref_expenditure_privacy_type__0.expenditure_privacy_type_id, ref_expenditure_privacy_type__0.expenditure_privacy_code, ref_expenditure_privacy_type__0.expenditure_privacy_name, ref_expenditure_privacy_type__0.created_date FROM ONLY ref_expenditure_privacy_type__0;


ALTER TABLE staging.ref_expenditure_privacy_type OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_expenditure_status__0 OWNER TO gpadmin;

--
-- Name: ref_expenditure_status; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_expenditure_status AS
    SELECT ref_expenditure_status__0.expenditure_status_id, ref_expenditure_status__0.expenditure_status_name, ref_expenditure_status__0.created_date FROM ONLY ref_expenditure_status__0;


ALTER TABLE staging.ref_expenditure_status OWNER TO gpadmin;

--
-- Name: ref_fund__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_fund__0 (
    fund_id smallint,
    fund_code character varying,
    fund_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_fund to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_fund__0 OWNER TO gpadmin;

--
-- Name: ref_fund; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_fund AS
    SELECT ref_fund__0.fund_id, ref_fund__0.fund_code, ref_fund__0.fund_name, ref_fund__0.created_date FROM ONLY ref_fund__0;


ALTER TABLE staging.ref_fund OWNER TO gpadmin;

--
-- Name: ref_fund_class__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_fund_class__0 (
    fund_class_id smallint,
    fund_class_code character varying,
    fund_class_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_fund_class to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_fund_class__0 OWNER TO gpadmin;

--
-- Name: ref_fund_class; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_fund_class AS
    SELECT ref_fund_class__0.fund_class_id, ref_fund_class__0.fund_class_code, ref_fund_class__0.fund_class_name, ref_fund_class__0.created_date FROM ONLY ref_fund_class__0;


ALTER TABLE staging.ref_fund_class OWNER TO gpadmin;

--
-- Name: ref_funding_class__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_funding_class__0 (
    funding_class_id smallint,
    funding_class_code character varying,
    funding_class_name character varying,
    funding_class_short_name character varying,
    category_name character varying,
    city_fund_flag bit(1),
    intra_city_flag bit(1),
    fund_allocation_required_flag bit(1),
    category_code character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_funding_class to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_funding_class__0 OWNER TO gpadmin;

--
-- Name: ref_funding_class; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_funding_class AS
    SELECT ref_funding_class__0.funding_class_id, ref_funding_class__0.funding_class_code, ref_funding_class__0.funding_class_name, ref_funding_class__0.funding_class_short_name, ref_funding_class__0.category_name, ref_funding_class__0.city_fund_flag, ref_funding_class__0.intra_city_flag, ref_funding_class__0.fund_allocation_required_flag, ref_funding_class__0.category_code, ref_funding_class__0.created_date FROM ONLY ref_funding_class__0;


ALTER TABLE staging.ref_funding_class OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_funding_source__0 OWNER TO gpadmin;

--
-- Name: ref_funding_source; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_funding_source AS
    SELECT ref_funding_source__0.funding_source_id, ref_funding_source__0.funding_source_code, ref_funding_source__0.funding_source_name, ref_funding_source__0.created_date FROM ONLY ref_funding_source__0;


ALTER TABLE staging.ref_funding_source OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_location__0 OWNER TO athiagarajan;

--
-- Name: ref_location; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW ref_location AS
    SELECT ref_location__0.location_id, ref_location__0.location_code, ref_location__0.agency_id, ref_location__0.location_name, ref_location__0.location_short_name, ref_location__0.original_location_name, ref_location__0.created_date, ref_location__0.updated_date, ref_location__0.created_load_id, ref_location__0.updated_load_id FROM ONLY ref_location__0;


ALTER TABLE staging.ref_location OWNER TO athiagarajan;

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


ALTER EXTERNAL TABLE staging.ref_location_history__0 OWNER TO gpadmin;

--
-- Name: ref_location_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_location_history AS
    SELECT ref_location_history__0.location_history_id, ref_location_history__0.location_id, ref_location_history__0.agency_id, ref_location_history__0.location_name, ref_location_history__0.location_short_name, ref_location_history__0.created_date, ref_location_history__0.load_id FROM ONLY ref_location_history__0;


ALTER TABLE staging.ref_location_history OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_minority_type__0 OWNER TO gpadmin;

--
-- Name: ref_minority_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_minority_type AS
    SELECT ref_minority_type__0.minority_type_id, ref_minority_type__0.minority_type_name, ref_minority_type__0.created_date FROM ONLY ref_minority_type__0;


ALTER TABLE staging.ref_minority_type OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.ref_miscellaneous_vendor__0 OWNER TO gpadmin;

--
-- Name: ref_miscellaneous_vendor; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_miscellaneous_vendor AS
    SELECT ref_miscellaneous_vendor__0.misc_vendor_id, ref_miscellaneous_vendor__0.vendor_customer_code, ref_miscellaneous_vendor__0.created_date FROM ONLY ref_miscellaneous_vendor__0;


ALTER TABLE staging.ref_miscellaneous_vendor OWNER TO gpadmin;

--
-- Name: ref_month__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_month__0 (
    month_id smallint,
    month_value smallint,
    month_name character varying,
    year_id smallint,
    display_order smallint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_month to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_month__0 OWNER TO gpadmin;

--
-- Name: ref_month; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_month AS
    SELECT ref_month__0.month_id, ref_month__0.month_value, ref_month__0.month_name, ref_month__0.year_id, ref_month__0.display_order FROM ONLY ref_month__0;


ALTER TABLE staging.ref_month OWNER TO gpadmin;

--
-- Name: ref_object_class__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
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


ALTER EXTERNAL TABLE staging.ref_object_class__0 OWNER TO gpadmin;

--
-- Name: ref_object_class; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW ref_object_class AS
    SELECT ref_object_class__0.object_class_id, ref_object_class__0.object_class_code, ref_object_class__0.object_class_name, ref_object_class__0.object_class_short_name, ref_object_class__0.active_flag, ref_object_class__0.effective_begin_date_id, ref_object_class__0.effective_end_date_id, ref_object_class__0.budget_allowed_flag, ref_object_class__0.description, ref_object_class__0.source_updated_date, ref_object_class__0.intra_city_flag, ref_object_class__0.contracts_positions_flag, ref_object_class__0.payroll_type, ref_object_class__0.extended_description, ref_object_class__0.related_object_class_code, ref_object_class__0.original_object_class_name, ref_object_class__0.created_date, ref_object_class__0.updated_date, ref_object_class__0.created_load_id, ref_object_class__0.updated_load_id FROM ONLY ref_object_class__0;


ALTER TABLE staging.ref_object_class OWNER TO athiagarajan;

--
-- Name: ref_object_class_history__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_object_class_history__0 (
    object_class_history_id integer,
    object_class_id integer,
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
    created_date timestamp without time zone,
    load_id integer
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_object_class_history to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_object_class_history__0 OWNER TO gpadmin;

--
-- Name: ref_object_class_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_object_class_history AS
    SELECT ref_object_class_history__0.object_class_history_id, ref_object_class_history__0.object_class_id, ref_object_class_history__0.object_class_name, ref_object_class_history__0.object_class_short_name, ref_object_class_history__0.active_flag, ref_object_class_history__0.effective_begin_date_id, ref_object_class_history__0.effective_end_date_id, ref_object_class_history__0.budget_allowed_flag, ref_object_class_history__0.description, ref_object_class_history__0.source_updated_date, ref_object_class_history__0.intra_city_flag, ref_object_class_history__0.contracts_positions_flag, ref_object_class_history__0.payroll_type, ref_object_class_history__0.extended_description, ref_object_class_history__0.related_object_class_code, ref_object_class_history__0.created_date, ref_object_class_history__0.load_id FROM ONLY ref_object_class_history__0;


ALTER TABLE staging.ref_object_class_history OWNER TO gpadmin;

--
-- Name: ref_pay_cycle__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_pay_cycle__0 (
    pay_cycle_id smallint,
    pay_cycle_code character varying,
    description character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_pay_cycle to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_pay_cycle__0 OWNER TO gpadmin;

--
-- Name: ref_pay_cycle; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_pay_cycle AS
    SELECT ref_pay_cycle__0.pay_cycle_id, ref_pay_cycle__0.pay_cycle_code, ref_pay_cycle__0.description, ref_pay_cycle__0.created_date FROM ONLY ref_pay_cycle__0;


ALTER TABLE staging.ref_pay_cycle OWNER TO gpadmin;

--
-- Name: ref_pay_type__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_pay_type__0 (
    pay_type_id smallint,
    pay_type_code character varying,
    pay_type_name character varying,
    balance_number_id smallint,
    payroll_reporting_id smallint,
    payroll_object_id smallint,
    prior_year_payroll_object_id smallint,
    fringe_indicator bpchar,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_pay_type to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_pay_type__0 OWNER TO gpadmin;

--
-- Name: ref_pay_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_pay_type AS
    SELECT ref_pay_type__0.pay_type_id, ref_pay_type__0.pay_type_code, ref_pay_type__0.pay_type_name, ref_pay_type__0.balance_number_id, ref_pay_type__0.payroll_reporting_id, ref_pay_type__0.payroll_object_id, ref_pay_type__0.prior_year_payroll_object_id, ref_pay_type__0.fringe_indicator, ref_pay_type__0.created_date FROM ONLY ref_pay_type__0;


ALTER TABLE staging.ref_pay_type OWNER TO gpadmin;

--
-- Name: ref_payroll_frequency__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_payroll_frequency__0 (
    payroll_frequency_id smallint,
    payroll_frequency_code bpchar,
    payroll_frequency_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_payroll_frequency to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_payroll_frequency__0 OWNER TO gpadmin;

--
-- Name: ref_payroll_frequency; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_payroll_frequency AS
    SELECT ref_payroll_frequency__0.payroll_frequency_id, ref_payroll_frequency__0.payroll_frequency_code, ref_payroll_frequency__0.payroll_frequency_name, ref_payroll_frequency__0.created_date FROM ONLY ref_payroll_frequency__0;


ALTER TABLE staging.ref_payroll_frequency OWNER TO gpadmin;

--
-- Name: ref_payroll_number__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_payroll_number__0 (
    payroll_number_id smallint,
    payroll_number character varying,
    payroll_name character varying,
    agency_id smallint,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_payroll_number to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_payroll_number__0 OWNER TO gpadmin;

--
-- Name: ref_payroll_number; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_payroll_number AS
    SELECT ref_payroll_number__0.payroll_number_id, ref_payroll_number__0.payroll_number, ref_payroll_number__0.payroll_name, ref_payroll_number__0.agency_id, ref_payroll_number__0.created_date FROM ONLY ref_payroll_number__0;


ALTER TABLE staging.ref_payroll_number OWNER TO gpadmin;

--
-- Name: ref_payroll_object__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_payroll_object__0 (
    payroll_object_id smallint,
    payroll_object_code character varying,
    payroll_object_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_payroll_object to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_payroll_object__0 OWNER TO gpadmin;

--
-- Name: ref_payroll_object; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_payroll_object AS
    SELECT ref_payroll_object__0.payroll_object_id, ref_payroll_object__0.payroll_object_code, ref_payroll_object__0.payroll_object_name, ref_payroll_object__0.created_date FROM ONLY ref_payroll_object__0;


ALTER TABLE staging.ref_payroll_object OWNER TO gpadmin;

--
-- Name: ref_payroll_payment_status__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_payroll_payment_status__0 (
    payroll_payment_status_id smallint,
    payroll_payment_status_code character varying,
    description character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_payroll_payment_status to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_payroll_payment_status__0 OWNER TO gpadmin;

--
-- Name: ref_payroll_payment_status; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_payroll_payment_status AS
    SELECT ref_payroll_payment_status__0.payroll_payment_status_id, ref_payroll_payment_status__0.payroll_payment_status_code, ref_payroll_payment_status__0.description, ref_payroll_payment_status__0.created_date FROM ONLY ref_payroll_payment_status__0;


ALTER TABLE staging.ref_payroll_payment_status OWNER TO gpadmin;

--
-- Name: ref_payroll_reporting__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_payroll_reporting__0 (
    payroll_reporting_id smallint,
    payroll_reporting_code character varying,
    payroll_reporting_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_payroll_reporting to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_payroll_reporting__0 OWNER TO gpadmin;

--
-- Name: ref_payroll_reporting; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_payroll_reporting AS
    SELECT ref_payroll_reporting__0.payroll_reporting_id, ref_payroll_reporting__0.payroll_reporting_code, ref_payroll_reporting__0.payroll_reporting_name, ref_payroll_reporting__0.created_date FROM ONLY ref_payroll_reporting__0;


ALTER TABLE staging.ref_payroll_reporting OWNER TO gpadmin;

--
-- Name: ref_payroll_wage__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_payroll_wage__0 (
    payroll_wage_id smallint,
    payroll_wage_code bpchar,
    payroll_wage_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_payroll_wage to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_payroll_wage__0 OWNER TO gpadmin;

--
-- Name: ref_payroll_wage; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_payroll_wage AS
    SELECT ref_payroll_wage__0.payroll_wage_id, ref_payroll_wage__0.payroll_wage_code, ref_payroll_wage__0.payroll_wage_name, ref_payroll_wage__0.created_date FROM ONLY ref_payroll_wage__0;


ALTER TABLE staging.ref_payroll_wage OWNER TO gpadmin;

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
    updated_load_id integer,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_revenue_category to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_revenue_category__0 OWNER TO gpadmin;

--
-- Name: ref_revenue_category; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_revenue_category AS
    SELECT ref_revenue_category__0.revenue_category_id, ref_revenue_category__0.revenue_category_code, ref_revenue_category__0.revenue_category_name, ref_revenue_category__0.revenue_category_short_name, ref_revenue_category__0.active_flag, ref_revenue_category__0.budget_allowed_flag, ref_revenue_category__0.description, ref_revenue_category__0.created_date, ref_revenue_category__0.updated_load_id, ref_revenue_category__0.updated_date FROM ONLY ref_revenue_category__0;


ALTER TABLE staging.ref_revenue_category OWNER TO gpadmin;

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
    updated_load_id integer,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_revenue_class to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_revenue_class__0 OWNER TO gpadmin;

--
-- Name: ref_revenue_class; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_revenue_class AS
    SELECT ref_revenue_class__0.revenue_class_id, ref_revenue_class__0.revenue_class_code, ref_revenue_class__0.revenue_class_name, ref_revenue_class__0.revenue_class_short_name, ref_revenue_class__0.active_flag, ref_revenue_class__0.budget_allowed_flag, ref_revenue_class__0.description, ref_revenue_class__0.created_date, ref_revenue_class__0.updated_load_id, ref_revenue_class__0.updated_date FROM ONLY ref_revenue_class__0;


ALTER TABLE staging.ref_revenue_class OWNER TO gpadmin;

--
-- Name: ref_revenue_source__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_revenue_source__0 (
    revenue_source_id smallint,
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
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_revenue_source to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_revenue_source__0 OWNER TO gpadmin;

--
-- Name: ref_revenue_source; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_revenue_source AS
    SELECT ref_revenue_source__0.revenue_source_id, ref_revenue_source__0.fiscal_year, ref_revenue_source__0.revenue_source_code, ref_revenue_source__0.revenue_source_name, ref_revenue_source__0.revenue_source_short_name, ref_revenue_source__0.description, ref_revenue_source__0.funding_class_id, ref_revenue_source__0.revenue_class_id, ref_revenue_source__0.revenue_category_id, ref_revenue_source__0.active_flag, ref_revenue_source__0.budget_allowed_flag, ref_revenue_source__0.operating_indicator, ref_revenue_source__0.fasb_class_indicator, ref_revenue_source__0.fhwa_revenue_credit_flag, ref_revenue_source__0.usetax_collection_flag, ref_revenue_source__0.apply_interest_late_fee, ref_revenue_source__0.apply_interest_admin_fee, ref_revenue_source__0.apply_interest_nsf_fee, ref_revenue_source__0.apply_interest_other_fee, ref_revenue_source__0.eligible_intercept_process, ref_revenue_source__0.earned_receivable_code, ref_revenue_source__0.finance_fee_override_flag, ref_revenue_source__0.allow_override_interest, ref_revenue_source__0.billing_lag_days, ref_revenue_source__0.billing_frequency, ref_revenue_source__0.billing_fiscal_year_start_month, ref_revenue_source__0.billing_fiscal_year_start_day, ref_revenue_source__0.federal_agency_code, ref_revenue_source__0.federal_agency_suffix, ref_revenue_source__0.federal_name, ref_revenue_source__0.srsrc_req, ref_revenue_source__0.created_date, ref_revenue_source__0.updated_load_id, ref_revenue_source__0.updated_date FROM ONLY ref_revenue_source__0;


ALTER TABLE staging.ref_revenue_source OWNER TO gpadmin;

--
-- Name: ref_spending_category__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_spending_category__0 (
    spending_category_id smallint,
    spending_category_code character varying,
    dspending_category_name character varying
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_spending_category to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_spending_category__0 OWNER TO gpadmin;

--
-- Name: ref_spending_category; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_spending_category AS
    SELECT ref_spending_category__0.spending_category_id, ref_spending_category__0.spending_category_code, ref_spending_category__0.dspending_category_name FROM ONLY ref_spending_category__0;


ALTER TABLE staging.ref_spending_category OWNER TO gpadmin;

--
-- Name: ref_worksite__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_worksite__0 (
    worksite_id integer,
    worksite_code character varying,
    worksite_name character varying,
    created_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_worksite to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_worksite__0 OWNER TO gpadmin;

--
-- Name: ref_worksite; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_worksite AS
    SELECT ref_worksite__0.worksite_id, ref_worksite__0.worksite_code, ref_worksite__0.worksite_name, ref_worksite__0.created_date FROM ONLY ref_worksite__0;


ALTER TABLE staging.ref_worksite OWNER TO gpadmin;

--
-- Name: ref_year__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE ref_year__0 (
    year_id smallint,
    year_value smallint
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.ref_year to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.ref_year__0 OWNER TO gpadmin;

--
-- Name: ref_year; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW ref_year AS
    SELECT ref_year__0.year_id, ref_year__0.year_value FROM ONLY ref_year__0;


ALTER TABLE staging.ref_year OWNER TO gpadmin;

--
-- Name: revenue__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE revenue__0 (
    revenue_id bigint,
    record_date_id smallint,
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
    service_start_date_id smallint,
    service_end_date_id smallint,
    reason_code character varying,
    reclassification_flag integer,
    closing_classification_code character varying,
    closing_classification_name character varying,
    revenue_category_id smallint,
    revenue_class_id smallint,
    revenue_source_id smallint,
    funding_source_id smallint,
    fund_class_id smallint,
    reporting_code character varying,
    major_cafr_revenue_type character varying,
    minor_cafr_revenue_type character varying,
    vendor_history_id integer,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.revenue to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.revenue__0 OWNER TO gpadmin;

--
-- Name: revenue; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW revenue AS
    SELECT revenue__0.revenue_id, revenue__0.record_date_id, revenue__0.fiscal_period, revenue__0.fiscal_year, revenue__0.budget_fiscal_year, revenue__0.fiscal_quarter, revenue__0.event_category, revenue__0.event_type, revenue__0.bank_account_code, revenue__0.posting_pair_type, revenue__0.posting_code, revenue__0.debit_credit_indicator, revenue__0.line_function, revenue__0.posting_amount, revenue__0.increment_decrement_indicator, revenue__0.time_of_occurence, revenue__0.balance_sheet_account_code, revenue__0.balance_sheet_account_type, revenue__0.expenditure_object_history_id, revenue__0.government_branch_code, revenue__0.cabinet_code, revenue__0.agency_history_id, revenue__0.department_history_id, revenue__0.reporting_activity_code, revenue__0.budget_code_id, revenue__0.fund_category, revenue__0.fund_type, revenue__0.fund_group, revenue__0.balance_sheet_account_class_code, revenue__0.balance_sheet_account_category_code, revenue__0.balance_sheet_account_group_code, revenue__0.balance_sheet_account_override_flag, revenue__0.object_class_history_id, revenue__0.object_category_code, revenue__0.object_type_code, revenue__0.object_group_code, revenue__0.document_category, revenue__0.document_type, revenue__0.document_code_id, revenue__0.document_agency_history_id, revenue__0.document_id, revenue__0.document_version_number, revenue__0.document_function_code_id, revenue__0.document_unit, revenue__0.commodity_line, revenue__0.accounting_line, revenue__0.document_posting_line, revenue__0.ref_document_code_id, revenue__0.ref_document_agency_history_id, revenue__0.ref_document_id, revenue__0.ref_commodity_line, revenue__0.ref_accounting_line, revenue__0.ref_posting_line, revenue__0.reference_type, revenue__0.line_description, revenue__0.service_start_date_id, revenue__0.service_end_date_id, revenue__0.reason_code, revenue__0.reclassification_flag, revenue__0.closing_classification_code, revenue__0.closing_classification_name, revenue__0.revenue_category_id, revenue__0.revenue_class_id, revenue__0.revenue_source_id, revenue__0.funding_source_id, revenue__0.fund_class_id, revenue__0.reporting_code, revenue__0.major_cafr_revenue_type, revenue__0.minor_cafr_revenue_type, revenue__0.vendor_history_id, revenue__0.load_id, revenue__0.created_date, revenue__0.updated_date FROM ONLY revenue__0;


ALTER TABLE staging.revenue OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.vendor__0 OWNER TO athiagarajan;

--
-- Name: vendor; Type: VIEW; Schema: staging; Owner: athiagarajan
--

CREATE VIEW vendor AS
    SELECT vendor__0.vendor_id, vendor__0.vendor_customer_code, vendor__0.legal_name, vendor__0.alias_name, vendor__0.miscellaneous_vendor_flag, vendor__0.vendor_sub_code, vendor__0.display_flag, vendor__0.updated_load_id, vendor__0.created_load_id, vendor__0.created_date, vendor__0.updated_date FROM ONLY vendor__0;


ALTER TABLE staging.vendor OWNER TO athiagarajan;

--
-- Name: vendor_address__0; Type: EXTERNAL TABLE; Schema: staging; Owner: gpadmin; Tablespace: 
--

CREATE EXTERNAL WEB TABLE vendor_address__0 (
    vendor_address_id bigint,
    vendor_history_id integer,
    address_id integer,
    address_type_id smallint,
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) EXECUTE E' psql -h mdw1 -p 5432  checkbook -c "copy public.vendor_address to stdout csv"' ON SEGMENT 0 
 FORMAT 'csv' (delimiter E',' null E'' escape E'"' quote E'"')
ENCODING 'UTF8';


ALTER EXTERNAL TABLE staging.vendor_address__0 OWNER TO gpadmin;

--
-- Name: vendor_address; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW vendor_address AS
    SELECT vendor_address__0.vendor_address_id, vendor_address__0.vendor_history_id, vendor_address__0.address_id, vendor_address__0.address_type_id, vendor_address__0.effective_begin_date_id, vendor_address__0.effective_end_date_id, vendor_address__0.load_id, vendor_address__0.created_date, vendor_address__0.updated_date FROM ONLY vendor_address__0;


ALTER TABLE staging.vendor_address OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.vendor_business_type__0 OWNER TO gpadmin;

--
-- Name: vendor_business_type; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW vendor_business_type AS
    SELECT vendor_business_type__0.vendor_business_type_id, vendor_business_type__0.vendor_history_id, vendor_business_type__0.business_type_id, vendor_business_type__0.status, vendor_business_type__0.minority_type_id, vendor_business_type__0.load_id, vendor_business_type__0.created_date, vendor_business_type__0.updated_date FROM ONLY vendor_business_type__0;


ALTER TABLE staging.vendor_business_type OWNER TO gpadmin;

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


ALTER EXTERNAL TABLE staging.vendor_history__0 OWNER TO gpadmin;

--
-- Name: vendor_history; Type: VIEW; Schema: staging; Owner: gpadmin
--

CREATE VIEW vendor_history AS
    SELECT vendor_history__0.vendor_history_id, vendor_history__0.vendor_id, vendor_history__0.legal_name, vendor_history__0.alias_name, vendor_history__0.miscellaneous_vendor_flag, vendor_history__0.vendor_sub_code, vendor_history__0.load_id, vendor_history__0.created_date, vendor_history__0.updated_date FROM ONLY vendor_history__0;


ALTER TABLE staging.vendor_history OWNER TO gpadmin;

--
-- Name: staging; Type: ACL; Schema: -; Owner: gpadmin
--

REVOKE ALL ON SCHEMA staging FROM PUBLIC;
REVOKE ALL ON SCHEMA staging FROM gpadmin;
GRANT ALL ON SCHEMA staging TO gpadmin;
GRANT ALL ON SCHEMA staging TO webuser1;


--
-- Name: address__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE address__0 FROM PUBLIC;
REVOKE ALL ON TABLE address__0 FROM gpadmin;
GRANT ALL ON TABLE address__0 TO gpadmin;
GRANT SELECT ON TABLE address__0 TO webuser1;


--
-- Name: address; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE address FROM PUBLIC;
REVOKE ALL ON TABLE address FROM gpadmin;
GRANT ALL ON TABLE address TO gpadmin;
GRANT SELECT ON TABLE address TO webuser1;


--
-- Name: aggregateon_spending_coa_entities__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE aggregateon_spending_coa_entities__0 FROM PUBLIC;
REVOKE ALL ON TABLE aggregateon_spending_coa_entities__0 FROM gpadmin;
GRANT ALL ON TABLE aggregateon_spending_coa_entities__0 TO gpadmin;
GRANT SELECT ON TABLE aggregateon_spending_coa_entities__0 TO webuser1;


--
-- Name: aggregateon_spending_coa_entities; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE aggregateon_spending_coa_entities FROM PUBLIC;
REVOKE ALL ON TABLE aggregateon_spending_coa_entities FROM gpadmin;
GRANT ALL ON TABLE aggregateon_spending_coa_entities TO gpadmin;
GRANT SELECT ON TABLE aggregateon_spending_coa_entities TO webuser1;


--
-- Name: aggregateon_spending_contract__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE aggregateon_spending_contract__0 FROM PUBLIC;
REVOKE ALL ON TABLE aggregateon_spending_contract__0 FROM gpadmin;
GRANT ALL ON TABLE aggregateon_spending_contract__0 TO gpadmin;
GRANT SELECT ON TABLE aggregateon_spending_contract__0 TO webuser1;


--
-- Name: aggregateon_spending_contract; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE aggregateon_spending_contract FROM PUBLIC;
REVOKE ALL ON TABLE aggregateon_spending_contract FROM gpadmin;
GRANT ALL ON TABLE aggregateon_spending_contract TO gpadmin;
GRANT SELECT ON TABLE aggregateon_spending_contract TO webuser1;


--
-- Name: aggregateon_spending_vendor__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE aggregateon_spending_vendor__0 FROM PUBLIC;
REVOKE ALL ON TABLE aggregateon_spending_vendor__0 FROM gpadmin;
GRANT ALL ON TABLE aggregateon_spending_vendor__0 TO gpadmin;
GRANT SELECT ON TABLE aggregateon_spending_vendor__0 TO webuser1;


--
-- Name: aggregateon_spending_vendor; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE aggregateon_spending_vendor FROM PUBLIC;
REVOKE ALL ON TABLE aggregateon_spending_vendor FROM gpadmin;
GRANT ALL ON TABLE aggregateon_spending_vendor TO gpadmin;
GRANT SELECT ON TABLE aggregateon_spending_vendor TO webuser1;


--
-- Name: agreement__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE agreement__0 FROM PUBLIC;
REVOKE ALL ON TABLE agreement__0 FROM gpadmin;
GRANT ALL ON TABLE agreement__0 TO gpadmin;
GRANT SELECT ON TABLE agreement__0 TO webuser1;


--
-- Name: agreement; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE agreement FROM PUBLIC;
REVOKE ALL ON TABLE agreement FROM athiagarajan;
GRANT ALL ON TABLE agreement TO athiagarajan;
GRANT SELECT ON TABLE agreement TO webuser1;


--
-- Name: agreement_accounting_line__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE agreement_accounting_line__0 FROM PUBLIC;
REVOKE ALL ON TABLE agreement_accounting_line__0 FROM gpadmin;
GRANT ALL ON TABLE agreement_accounting_line__0 TO gpadmin;
GRANT SELECT ON TABLE agreement_accounting_line__0 TO webuser1;


--
-- Name: agreement_accounting_line; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE agreement_accounting_line FROM PUBLIC;
REVOKE ALL ON TABLE agreement_accounting_line FROM gpadmin;
GRANT ALL ON TABLE agreement_accounting_line TO gpadmin;
GRANT SELECT ON TABLE agreement_accounting_line TO webuser1;


--
-- Name: agreement_commodity__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE agreement_commodity__0 FROM PUBLIC;
REVOKE ALL ON TABLE agreement_commodity__0 FROM gpadmin;
GRANT ALL ON TABLE agreement_commodity__0 TO gpadmin;
GRANT SELECT ON TABLE agreement_commodity__0 TO webuser1;


--
-- Name: agreement_commodity; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE agreement_commodity FROM PUBLIC;
REVOKE ALL ON TABLE agreement_commodity FROM gpadmin;
GRANT ALL ON TABLE agreement_commodity TO gpadmin;
GRANT SELECT ON TABLE agreement_commodity TO webuser1;


--
-- Name: agreement_worksite__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE agreement_worksite__0 FROM PUBLIC;
REVOKE ALL ON TABLE agreement_worksite__0 FROM gpadmin;
GRANT ALL ON TABLE agreement_worksite__0 TO gpadmin;
GRANT SELECT ON TABLE agreement_worksite__0 TO webuser1;


--
-- Name: agreement_worksite; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE agreement_worksite FROM PUBLIC;
REVOKE ALL ON TABLE agreement_worksite FROM gpadmin;
GRANT ALL ON TABLE agreement_worksite TO gpadmin;
GRANT SELECT ON TABLE agreement_worksite TO webuser1;


--
-- Name: budget__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE budget__0 FROM PUBLIC;
REVOKE ALL ON TABLE budget__0 FROM gpadmin;
GRANT ALL ON TABLE budget__0 TO gpadmin;
GRANT SELECT ON TABLE budget__0 TO webuser1;


--
-- Name: budget; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE budget FROM PUBLIC;
REVOKE ALL ON TABLE budget FROM gpadmin;
GRANT ALL ON TABLE budget TO gpadmin;
GRANT SELECT ON TABLE budget TO webuser1;


--
-- Name: disbursement__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE disbursement__0 FROM PUBLIC;
REVOKE ALL ON TABLE disbursement__0 FROM gpadmin;
GRANT ALL ON TABLE disbursement__0 TO gpadmin;
GRANT SELECT ON TABLE disbursement__0 TO webuser1;


--
-- Name: disbursement; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE disbursement FROM PUBLIC;
REVOKE ALL ON TABLE disbursement FROM gpadmin;
GRANT ALL ON TABLE disbursement TO gpadmin;
GRANT SELECT ON TABLE disbursement TO webuser1;


--
-- Name: disbursement_line_item__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE disbursement_line_item__0 FROM PUBLIC;
REVOKE ALL ON TABLE disbursement_line_item__0 FROM gpadmin;
GRANT ALL ON TABLE disbursement_line_item__0 TO gpadmin;
GRANT SELECT ON TABLE disbursement_line_item__0 TO webuser1;


--
-- Name: disbursement_line_item; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE disbursement_line_item FROM PUBLIC;
REVOKE ALL ON TABLE disbursement_line_item FROM gpadmin;
GRANT ALL ON TABLE disbursement_line_item TO gpadmin;
GRANT SELECT ON TABLE disbursement_line_item TO webuser1;


--
-- Name: fact_agreement__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_agreement__0 FROM PUBLIC;
REVOKE ALL ON TABLE fact_agreement__0 FROM gpadmin;
GRANT ALL ON TABLE fact_agreement__0 TO gpadmin;
GRANT SELECT ON TABLE fact_agreement__0 TO webuser1;


--
-- Name: fact_agreement; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_agreement FROM PUBLIC;
REVOKE ALL ON TABLE fact_agreement FROM gpadmin;
GRANT ALL ON TABLE fact_agreement TO gpadmin;
GRANT SELECT ON TABLE fact_agreement TO webuser1;


--
-- Name: fact_agreement_accounting_line__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_agreement_accounting_line__0 FROM PUBLIC;
REVOKE ALL ON TABLE fact_agreement_accounting_line__0 FROM gpadmin;
GRANT ALL ON TABLE fact_agreement_accounting_line__0 TO gpadmin;
GRANT SELECT ON TABLE fact_agreement_accounting_line__0 TO webuser1;


--
-- Name: fact_agreement_accounting_line; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_agreement_accounting_line FROM PUBLIC;
REVOKE ALL ON TABLE fact_agreement_accounting_line FROM gpadmin;
GRANT ALL ON TABLE fact_agreement_accounting_line TO gpadmin;
GRANT SELECT ON TABLE fact_agreement_accounting_line TO webuser1;


--
-- Name: fact_disbursement_line_item__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_disbursement_line_item__0 FROM PUBLIC;
REVOKE ALL ON TABLE fact_disbursement_line_item__0 FROM gpadmin;
GRANT ALL ON TABLE fact_disbursement_line_item__0 TO gpadmin;
GRANT SELECT ON TABLE fact_disbursement_line_item__0 TO webuser1;


--
-- Name: fact_disbursement_line_item; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_disbursement_line_item FROM PUBLIC;
REVOKE ALL ON TABLE fact_disbursement_line_item FROM gpadmin;
GRANT ALL ON TABLE fact_disbursement_line_item TO gpadmin;
GRANT SELECT ON TABLE fact_disbursement_line_item TO webuser1;


--
-- Name: fact_disbursement_line_item_new__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_disbursement_line_item_new__0 FROM PUBLIC;
REVOKE ALL ON TABLE fact_disbursement_line_item_new__0 FROM gpadmin;
GRANT ALL ON TABLE fact_disbursement_line_item_new__0 TO gpadmin;
GRANT SELECT ON TABLE fact_disbursement_line_item_new__0 TO webuser1;


--
-- Name: fact_disbursement_line_item_new; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_disbursement_line_item_new FROM PUBLIC;
REVOKE ALL ON TABLE fact_disbursement_line_item_new FROM gpadmin;
GRANT ALL ON TABLE fact_disbursement_line_item_new TO gpadmin;
GRANT SELECT ON TABLE fact_disbursement_line_item_new TO webuser1;


--
-- Name: fact_revenue__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_revenue__0 FROM PUBLIC;
REVOKE ALL ON TABLE fact_revenue__0 FROM gpadmin;
GRANT ALL ON TABLE fact_revenue__0 TO gpadmin;
GRANT SELECT ON TABLE fact_revenue__0 TO webuser1;


--
-- Name: fact_revenue; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE fact_revenue FROM PUBLIC;
REVOKE ALL ON TABLE fact_revenue FROM gpadmin;
GRANT ALL ON TABLE fact_revenue TO gpadmin;
GRANT SELECT ON TABLE fact_revenue TO webuser1;


--
-- Name: history_agreement__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE history_agreement__0 FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement__0 FROM gpadmin;
GRANT ALL ON TABLE history_agreement__0 TO gpadmin;
GRANT SELECT ON TABLE history_agreement__0 TO webuser1;


--
-- Name: history_agreement; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE history_agreement FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement FROM athiagarajan;
GRANT ALL ON TABLE history_agreement TO athiagarajan;
GRANT SELECT ON TABLE history_agreement TO webuser1;


--
-- Name: history_agreement_accounting_line__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE history_agreement_accounting_line__0 FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement_accounting_line__0 FROM gpadmin;
GRANT ALL ON TABLE history_agreement_accounting_line__0 TO gpadmin;
GRANT SELECT ON TABLE history_agreement_accounting_line__0 TO webuser1;


--
-- Name: history_agreement_accounting_line; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE history_agreement_accounting_line FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement_accounting_line FROM gpadmin;
GRANT ALL ON TABLE history_agreement_accounting_line TO gpadmin;
GRANT SELECT ON TABLE history_agreement_accounting_line TO webuser1;


--
-- Name: history_agreement_commodity__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE history_agreement_commodity__0 FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement_commodity__0 FROM gpadmin;
GRANT ALL ON TABLE history_agreement_commodity__0 TO gpadmin;
GRANT SELECT ON TABLE history_agreement_commodity__0 TO webuser1;


--
-- Name: history_agreement_commodity; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE history_agreement_commodity FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement_commodity FROM gpadmin;
GRANT ALL ON TABLE history_agreement_commodity TO gpadmin;
GRANT SELECT ON TABLE history_agreement_commodity TO webuser1;


--
-- Name: history_agreement_worksite__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE history_agreement_worksite__0 FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement_worksite__0 FROM gpadmin;
GRANT ALL ON TABLE history_agreement_worksite__0 TO gpadmin;
GRANT SELECT ON TABLE history_agreement_worksite__0 TO webuser1;


--
-- Name: history_agreement_worksite; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE history_agreement_worksite FROM PUBLIC;
REVOKE ALL ON TABLE history_agreement_worksite FROM gpadmin;
GRANT ALL ON TABLE history_agreement_worksite TO gpadmin;
GRANT SELECT ON TABLE history_agreement_worksite TO webuser1;


--
-- Name: history_master_agreement__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE history_master_agreement__0 FROM PUBLIC;
REVOKE ALL ON TABLE history_master_agreement__0 FROM gpadmin;
GRANT ALL ON TABLE history_master_agreement__0 TO gpadmin;
GRANT SELECT ON TABLE history_master_agreement__0 TO webuser1;


--
-- Name: history_master_agreement; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE history_master_agreement FROM PUBLIC;
REVOKE ALL ON TABLE history_master_agreement FROM athiagarajan;
GRANT ALL ON TABLE history_master_agreement TO athiagarajan;
GRANT SELECT ON TABLE history_master_agreement TO webuser1;


--
-- Name: master_agreement__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE master_agreement__0 FROM PUBLIC;
REVOKE ALL ON TABLE master_agreement__0 FROM gpadmin;
GRANT ALL ON TABLE master_agreement__0 TO gpadmin;
GRANT SELECT ON TABLE master_agreement__0 TO webuser1;


--
-- Name: master_agreement; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE master_agreement FROM PUBLIC;
REVOKE ALL ON TABLE master_agreement FROM gpadmin;
GRANT ALL ON TABLE master_agreement TO gpadmin;
GRANT SELECT ON TABLE master_agreement TO webuser1;


--
-- Name: payroll_summary__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE payroll_summary__0 FROM PUBLIC;
REVOKE ALL ON TABLE payroll_summary__0 FROM gpadmin;
GRANT ALL ON TABLE payroll_summary__0 TO gpadmin;
GRANT SELECT ON TABLE payroll_summary__0 TO webuser1;


--
-- Name: payroll_summary; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE payroll_summary FROM PUBLIC;
REVOKE ALL ON TABLE payroll_summary FROM gpadmin;
GRANT ALL ON TABLE payroll_summary TO gpadmin;
GRANT SELECT ON TABLE payroll_summary TO webuser1;


--
-- Name: ref_address_type__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_address_type__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_address_type__0 FROM gpadmin;
GRANT ALL ON TABLE ref_address_type__0 TO gpadmin;
GRANT SELECT ON TABLE ref_address_type__0 TO webuser1;


--
-- Name: ref_address_type; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_address_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_address_type FROM gpadmin;
GRANT ALL ON TABLE ref_address_type TO gpadmin;
GRANT SELECT ON TABLE ref_address_type TO webuser1;


--
-- Name: ref_agency__0; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_agency__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_agency__0 FROM athiagarajan;
GRANT ALL ON TABLE ref_agency__0 TO athiagarajan;
GRANT SELECT ON TABLE ref_agency__0 TO webuser1;


--
-- Name: ref_agency; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_agency FROM PUBLIC;
REVOKE ALL ON TABLE ref_agency FROM athiagarajan;
GRANT ALL ON TABLE ref_agency TO athiagarajan;
GRANT SELECT ON TABLE ref_agency TO webuser1;


--
-- Name: ref_agency_history__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_agency_history__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_agency_history__0 FROM gpadmin;
GRANT ALL ON TABLE ref_agency_history__0 TO gpadmin;
GRANT SELECT ON TABLE ref_agency_history__0 TO webuser1;


--
-- Name: ref_agency_history; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_agency_history FROM PUBLIC;
REVOKE ALL ON TABLE ref_agency_history FROM gpadmin;
GRANT ALL ON TABLE ref_agency_history TO gpadmin;
GRANT SELECT ON TABLE ref_agency_history TO webuser1;


--
-- Name: ref_agreement_type__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_agreement_type__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_agreement_type__0 FROM gpadmin;
GRANT ALL ON TABLE ref_agreement_type__0 TO gpadmin;
GRANT SELECT ON TABLE ref_agreement_type__0 TO webuser1;


--
-- Name: ref_agreement_type; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_agreement_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_agreement_type FROM gpadmin;
GRANT ALL ON TABLE ref_agreement_type TO gpadmin;
GRANT SELECT ON TABLE ref_agreement_type TO webuser1;


--
-- Name: ref_award_category__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_category__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_category__0 FROM gpadmin;
GRANT ALL ON TABLE ref_award_category__0 TO gpadmin;
GRANT SELECT ON TABLE ref_award_category__0 TO webuser1;


--
-- Name: ref_award_category; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_category FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_category FROM gpadmin;
GRANT ALL ON TABLE ref_award_category TO gpadmin;
GRANT SELECT ON TABLE ref_award_category TO webuser1;


--
-- Name: ref_award_level__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_level__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_level__0 FROM gpadmin;
GRANT ALL ON TABLE ref_award_level__0 TO gpadmin;
GRANT SELECT ON TABLE ref_award_level__0 TO webuser1;


--
-- Name: ref_award_level; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_level FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_level FROM gpadmin;
GRANT ALL ON TABLE ref_award_level TO gpadmin;
GRANT SELECT ON TABLE ref_award_level TO webuser1;


--
-- Name: ref_award_method__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_method__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_method__0 FROM gpadmin;
GRANT ALL ON TABLE ref_award_method__0 TO gpadmin;
GRANT SELECT ON TABLE ref_award_method__0 TO webuser1;


--
-- Name: ref_award_method; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_method FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_method FROM gpadmin;
GRANT ALL ON TABLE ref_award_method TO gpadmin;
GRANT SELECT ON TABLE ref_award_method TO webuser1;


--
-- Name: ref_award_status__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_status__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_status__0 FROM gpadmin;
GRANT ALL ON TABLE ref_award_status__0 TO gpadmin;
GRANT SELECT ON TABLE ref_award_status__0 TO webuser1;


--
-- Name: ref_award_status; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_award_status FROM PUBLIC;
REVOKE ALL ON TABLE ref_award_status FROM gpadmin;
GRANT ALL ON TABLE ref_award_status TO gpadmin;
GRANT SELECT ON TABLE ref_award_status TO webuser1;


--
-- Name: ref_balance_number__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_balance_number__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_balance_number__0 FROM gpadmin;
GRANT ALL ON TABLE ref_balance_number__0 TO gpadmin;
GRANT SELECT ON TABLE ref_balance_number__0 TO webuser1;


--
-- Name: ref_balance_number; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_balance_number FROM PUBLIC;
REVOKE ALL ON TABLE ref_balance_number FROM gpadmin;
GRANT ALL ON TABLE ref_balance_number TO gpadmin;
GRANT SELECT ON TABLE ref_balance_number TO webuser1;


--
-- Name: ref_budget_code__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_budget_code__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_budget_code__0 FROM gpadmin;
GRANT ALL ON TABLE ref_budget_code__0 TO gpadmin;
GRANT SELECT ON TABLE ref_budget_code__0 TO webuser1;


--
-- Name: ref_budget_code; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_budget_code FROM PUBLIC;
REVOKE ALL ON TABLE ref_budget_code FROM gpadmin;
GRANT ALL ON TABLE ref_budget_code TO gpadmin;
GRANT SELECT ON TABLE ref_budget_code TO webuser1;


--
-- Name: ref_business_type__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_business_type__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_business_type__0 FROM gpadmin;
GRANT ALL ON TABLE ref_business_type__0 TO gpadmin;
GRANT SELECT ON TABLE ref_business_type__0 TO webuser1;


--
-- Name: ref_business_type; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_business_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_business_type FROM gpadmin;
GRANT ALL ON TABLE ref_business_type TO gpadmin;
GRANT SELECT ON TABLE ref_business_type TO webuser1;


--
-- Name: ref_business_type_status__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_business_type_status__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_business_type_status__0 FROM gpadmin;
GRANT ALL ON TABLE ref_business_type_status__0 TO gpadmin;
GRANT SELECT ON TABLE ref_business_type_status__0 TO webuser1;


--
-- Name: ref_business_type_status; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_business_type_status FROM PUBLIC;
REVOKE ALL ON TABLE ref_business_type_status FROM gpadmin;
GRANT ALL ON TABLE ref_business_type_status TO gpadmin;
GRANT SELECT ON TABLE ref_business_type_status TO webuser1;


--
-- Name: ref_commodity_type__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_commodity_type__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_commodity_type__0 FROM gpadmin;
GRANT ALL ON TABLE ref_commodity_type__0 TO gpadmin;
GRANT SELECT ON TABLE ref_commodity_type__0 TO webuser1;


--
-- Name: ref_commodity_type; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_commodity_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_commodity_type FROM gpadmin;
GRANT ALL ON TABLE ref_commodity_type TO gpadmin;
GRANT SELECT ON TABLE ref_commodity_type TO webuser1;


--
-- Name: ref_data_source__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_data_source__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_data_source__0 FROM gpadmin;
GRANT ALL ON TABLE ref_data_source__0 TO gpadmin;
GRANT SELECT ON TABLE ref_data_source__0 TO webuser1;


--
-- Name: ref_data_source; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_data_source FROM PUBLIC;
REVOKE ALL ON TABLE ref_data_source FROM gpadmin;
GRANT ALL ON TABLE ref_data_source TO gpadmin;
GRANT SELECT ON TABLE ref_data_source TO webuser1;


--
-- Name: ref_date__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_date__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_date__0 FROM gpadmin;
GRANT ALL ON TABLE ref_date__0 TO gpadmin;
GRANT SELECT ON TABLE ref_date__0 TO webuser1;


--
-- Name: ref_date; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_date FROM PUBLIC;
REVOKE ALL ON TABLE ref_date FROM gpadmin;
GRANT ALL ON TABLE ref_date TO gpadmin;
GRANT SELECT ON TABLE ref_date TO webuser1;


--
-- Name: ref_department__0; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_department__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_department__0 FROM athiagarajan;
GRANT ALL ON TABLE ref_department__0 TO athiagarajan;
GRANT SELECT ON TABLE ref_department__0 TO webuser1;


--
-- Name: ref_department; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_department FROM PUBLIC;
REVOKE ALL ON TABLE ref_department FROM athiagarajan;
GRANT ALL ON TABLE ref_department TO athiagarajan;
GRANT SELECT ON TABLE ref_department TO webuser1;


--
-- Name: ref_department_history__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_department_history__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_department_history__0 FROM gpadmin;
GRANT ALL ON TABLE ref_department_history__0 TO gpadmin;
GRANT SELECT ON TABLE ref_department_history__0 TO webuser1;


--
-- Name: ref_department_history; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_department_history FROM PUBLIC;
REVOKE ALL ON TABLE ref_department_history FROM gpadmin;
GRANT ALL ON TABLE ref_department_history TO gpadmin;
GRANT SELECT ON TABLE ref_department_history TO webuser1;


--
-- Name: ref_document_code__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_document_code__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_document_code__0 FROM gpadmin;
GRANT ALL ON TABLE ref_document_code__0 TO gpadmin;
GRANT SELECT ON TABLE ref_document_code__0 TO webuser1;


--
-- Name: ref_document_code; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_document_code FROM PUBLIC;
REVOKE ALL ON TABLE ref_document_code FROM gpadmin;
GRANT ALL ON TABLE ref_document_code TO gpadmin;
GRANT SELECT ON TABLE ref_document_code TO webuser1;


--
-- Name: ref_document_function_code__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_document_function_code__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_document_function_code__0 FROM gpadmin;
GRANT ALL ON TABLE ref_document_function_code__0 TO gpadmin;
GRANT SELECT ON TABLE ref_document_function_code__0 TO webuser1;


--
-- Name: ref_document_function_code; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_document_function_code FROM PUBLIC;
REVOKE ALL ON TABLE ref_document_function_code FROM gpadmin;
GRANT ALL ON TABLE ref_document_function_code TO gpadmin;
GRANT SELECT ON TABLE ref_document_function_code TO webuser1;


--
-- Name: ref_employee_category__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_employee_category__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_employee_category__0 FROM gpadmin;
GRANT ALL ON TABLE ref_employee_category__0 TO gpadmin;
GRANT SELECT ON TABLE ref_employee_category__0 TO webuser1;


--
-- Name: ref_employee_category; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_employee_category FROM PUBLIC;
REVOKE ALL ON TABLE ref_employee_category FROM gpadmin;
GRANT ALL ON TABLE ref_employee_category TO gpadmin;
GRANT SELECT ON TABLE ref_employee_category TO webuser1;


--
-- Name: ref_employee_classification__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_employee_classification__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_employee_classification__0 FROM gpadmin;
GRANT ALL ON TABLE ref_employee_classification__0 TO gpadmin;
GRANT SELECT ON TABLE ref_employee_classification__0 TO webuser1;


--
-- Name: ref_employee_classification; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_employee_classification FROM PUBLIC;
REVOKE ALL ON TABLE ref_employee_classification FROM gpadmin;
GRANT ALL ON TABLE ref_employee_classification TO gpadmin;
GRANT SELECT ON TABLE ref_employee_classification TO webuser1;


--
-- Name: ref_employee_sub_category__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_employee_sub_category__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_employee_sub_category__0 FROM gpadmin;
GRANT ALL ON TABLE ref_employee_sub_category__0 TO gpadmin;
GRANT SELECT ON TABLE ref_employee_sub_category__0 TO webuser1;


--
-- Name: ref_employee_sub_category; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_employee_sub_category FROM PUBLIC;
REVOKE ALL ON TABLE ref_employee_sub_category FROM gpadmin;
GRANT ALL ON TABLE ref_employee_sub_category TO gpadmin;
GRANT SELECT ON TABLE ref_employee_sub_category TO webuser1;


--
-- Name: ref_event_type__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_event_type__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_event_type__0 FROM gpadmin;
GRANT ALL ON TABLE ref_event_type__0 TO gpadmin;
GRANT SELECT ON TABLE ref_event_type__0 TO webuser1;


--
-- Name: ref_event_type; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_event_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_event_type FROM gpadmin;
GRANT ALL ON TABLE ref_event_type TO gpadmin;
GRANT SELECT ON TABLE ref_event_type TO webuser1;


--
-- Name: ref_expenditure_cancel_reason__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_cancel_reason__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_cancel_reason__0 FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_cancel_reason__0 TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_cancel_reason__0 TO webuser1;


--
-- Name: ref_expenditure_cancel_reason; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_cancel_reason FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_cancel_reason FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_cancel_reason TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_cancel_reason TO webuser1;


--
-- Name: ref_expenditure_cancel_type__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_cancel_type__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_cancel_type__0 FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_cancel_type__0 TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_cancel_type__0 TO webuser1;


--
-- Name: ref_expenditure_cancel_type; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_cancel_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_cancel_type FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_cancel_type TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_cancel_type TO webuser1;


--
-- Name: ref_expenditure_object__0; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_expenditure_object__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_object__0 FROM athiagarajan;
GRANT ALL ON TABLE ref_expenditure_object__0 TO athiagarajan;
GRANT SELECT ON TABLE ref_expenditure_object__0 TO webuser1;


--
-- Name: ref_expenditure_object; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_expenditure_object FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_object FROM athiagarajan;
GRANT ALL ON TABLE ref_expenditure_object TO athiagarajan;
GRANT SELECT ON TABLE ref_expenditure_object TO webuser1;


--
-- Name: ref_expenditure_object_history__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_object_history__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_object_history__0 FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_object_history__0 TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_object_history__0 TO webuser1;


--
-- Name: ref_expenditure_object_history; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_object_history FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_object_history FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_object_history TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_object_history TO webuser1;


--
-- Name: ref_expenditure_privacy_type__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_privacy_type__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_privacy_type__0 FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_privacy_type__0 TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_privacy_type__0 TO webuser1;


--
-- Name: ref_expenditure_privacy_type; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_privacy_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_privacy_type FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_privacy_type TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_privacy_type TO webuser1;


--
-- Name: ref_expenditure_status__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_status__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_status__0 FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_status__0 TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_status__0 TO webuser1;


--
-- Name: ref_expenditure_status; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_expenditure_status FROM PUBLIC;
REVOKE ALL ON TABLE ref_expenditure_status FROM gpadmin;
GRANT ALL ON TABLE ref_expenditure_status TO gpadmin;
GRANT SELECT ON TABLE ref_expenditure_status TO webuser1;


--
-- Name: ref_fund__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_fund__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_fund__0 FROM gpadmin;
GRANT ALL ON TABLE ref_fund__0 TO gpadmin;
GRANT SELECT ON TABLE ref_fund__0 TO webuser1;


--
-- Name: ref_fund; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_fund FROM PUBLIC;
REVOKE ALL ON TABLE ref_fund FROM gpadmin;
GRANT ALL ON TABLE ref_fund TO gpadmin;
GRANT SELECT ON TABLE ref_fund TO webuser1;


--
-- Name: ref_fund_class__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_fund_class__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_fund_class__0 FROM gpadmin;
GRANT ALL ON TABLE ref_fund_class__0 TO gpadmin;
GRANT SELECT ON TABLE ref_fund_class__0 TO webuser1;


--
-- Name: ref_fund_class; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_fund_class FROM PUBLIC;
REVOKE ALL ON TABLE ref_fund_class FROM gpadmin;
GRANT ALL ON TABLE ref_fund_class TO gpadmin;
GRANT SELECT ON TABLE ref_fund_class TO webuser1;


--
-- Name: ref_funding_class__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_funding_class__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_funding_class__0 FROM gpadmin;
GRANT ALL ON TABLE ref_funding_class__0 TO gpadmin;
GRANT SELECT ON TABLE ref_funding_class__0 TO webuser1;


--
-- Name: ref_funding_class; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_funding_class FROM PUBLIC;
REVOKE ALL ON TABLE ref_funding_class FROM gpadmin;
GRANT ALL ON TABLE ref_funding_class TO gpadmin;
GRANT SELECT ON TABLE ref_funding_class TO webuser1;


--
-- Name: ref_funding_source__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_funding_source__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_funding_source__0 FROM gpadmin;
GRANT ALL ON TABLE ref_funding_source__0 TO gpadmin;
GRANT SELECT ON TABLE ref_funding_source__0 TO webuser1;


--
-- Name: ref_funding_source; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_funding_source FROM PUBLIC;
REVOKE ALL ON TABLE ref_funding_source FROM gpadmin;
GRANT ALL ON TABLE ref_funding_source TO gpadmin;
GRANT SELECT ON TABLE ref_funding_source TO webuser1;


--
-- Name: ref_location__0; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_location__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_location__0 FROM athiagarajan;
GRANT ALL ON TABLE ref_location__0 TO athiagarajan;
GRANT SELECT ON TABLE ref_location__0 TO webuser1;


--
-- Name: ref_location; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_location FROM PUBLIC;
REVOKE ALL ON TABLE ref_location FROM athiagarajan;
GRANT ALL ON TABLE ref_location TO athiagarajan;
GRANT SELECT ON TABLE ref_location TO webuser1;


--
-- Name: ref_location_history__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_location_history__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_location_history__0 FROM gpadmin;
GRANT ALL ON TABLE ref_location_history__0 TO gpadmin;
GRANT SELECT ON TABLE ref_location_history__0 TO webuser1;


--
-- Name: ref_location_history; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_location_history FROM PUBLIC;
REVOKE ALL ON TABLE ref_location_history FROM gpadmin;
GRANT ALL ON TABLE ref_location_history TO gpadmin;
GRANT SELECT ON TABLE ref_location_history TO webuser1;


--
-- Name: ref_minority_type__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_minority_type__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_minority_type__0 FROM gpadmin;
GRANT ALL ON TABLE ref_minority_type__0 TO gpadmin;
GRANT SELECT ON TABLE ref_minority_type__0 TO webuser1;


--
-- Name: ref_minority_type; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_minority_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_minority_type FROM gpadmin;
GRANT ALL ON TABLE ref_minority_type TO gpadmin;
GRANT SELECT ON TABLE ref_minority_type TO webuser1;


--
-- Name: ref_miscellaneous_vendor__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_miscellaneous_vendor__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_miscellaneous_vendor__0 FROM gpadmin;
GRANT ALL ON TABLE ref_miscellaneous_vendor__0 TO gpadmin;
GRANT SELECT ON TABLE ref_miscellaneous_vendor__0 TO webuser1;


--
-- Name: ref_miscellaneous_vendor; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_miscellaneous_vendor FROM PUBLIC;
REVOKE ALL ON TABLE ref_miscellaneous_vendor FROM gpadmin;
GRANT ALL ON TABLE ref_miscellaneous_vendor TO gpadmin;
GRANT SELECT ON TABLE ref_miscellaneous_vendor TO webuser1;


--
-- Name: ref_month__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_month__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_month__0 FROM gpadmin;
GRANT ALL ON TABLE ref_month__0 TO gpadmin;
GRANT SELECT ON TABLE ref_month__0 TO webuser1;


--
-- Name: ref_month; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_month FROM PUBLIC;
REVOKE ALL ON TABLE ref_month FROM gpadmin;
GRANT ALL ON TABLE ref_month TO gpadmin;
GRANT SELECT ON TABLE ref_month TO webuser1;


--
-- Name: ref_object_class__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_object_class__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_object_class__0 FROM gpadmin;
GRANT ALL ON TABLE ref_object_class__0 TO gpadmin;
GRANT SELECT ON TABLE ref_object_class__0 TO webuser1;


--
-- Name: ref_object_class; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE ref_object_class FROM PUBLIC;
REVOKE ALL ON TABLE ref_object_class FROM athiagarajan;
GRANT ALL ON TABLE ref_object_class TO athiagarajan;
GRANT SELECT ON TABLE ref_object_class TO webuser1;


--
-- Name: ref_object_class_history__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_object_class_history__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_object_class_history__0 FROM gpadmin;
GRANT ALL ON TABLE ref_object_class_history__0 TO gpadmin;
GRANT SELECT ON TABLE ref_object_class_history__0 TO webuser1;


--
-- Name: ref_object_class_history; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_object_class_history FROM PUBLIC;
REVOKE ALL ON TABLE ref_object_class_history FROM gpadmin;
GRANT ALL ON TABLE ref_object_class_history TO gpadmin;
GRANT SELECT ON TABLE ref_object_class_history TO webuser1;


--
-- Name: ref_pay_cycle__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_pay_cycle__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_pay_cycle__0 FROM gpadmin;
GRANT ALL ON TABLE ref_pay_cycle__0 TO gpadmin;
GRANT SELECT ON TABLE ref_pay_cycle__0 TO webuser1;


--
-- Name: ref_pay_cycle; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_pay_cycle FROM PUBLIC;
REVOKE ALL ON TABLE ref_pay_cycle FROM gpadmin;
GRANT ALL ON TABLE ref_pay_cycle TO gpadmin;
GRANT SELECT ON TABLE ref_pay_cycle TO webuser1;


--
-- Name: ref_pay_type__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_pay_type__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_pay_type__0 FROM gpadmin;
GRANT ALL ON TABLE ref_pay_type__0 TO gpadmin;
GRANT SELECT ON TABLE ref_pay_type__0 TO webuser1;


--
-- Name: ref_pay_type; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_pay_type FROM PUBLIC;
REVOKE ALL ON TABLE ref_pay_type FROM gpadmin;
GRANT ALL ON TABLE ref_pay_type TO gpadmin;
GRANT SELECT ON TABLE ref_pay_type TO webuser1;


--
-- Name: ref_payroll_frequency__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_frequency__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_frequency__0 FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_frequency__0 TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_frequency__0 TO webuser1;


--
-- Name: ref_payroll_frequency; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_frequency FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_frequency FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_frequency TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_frequency TO webuser1;


--
-- Name: ref_payroll_number__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_number__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_number__0 FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_number__0 TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_number__0 TO webuser1;


--
-- Name: ref_payroll_number; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_number FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_number FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_number TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_number TO webuser1;


--
-- Name: ref_payroll_object__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_object__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_object__0 FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_object__0 TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_object__0 TO webuser1;


--
-- Name: ref_payroll_object; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_object FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_object FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_object TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_object TO webuser1;


--
-- Name: ref_payroll_payment_status__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_payment_status__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_payment_status__0 FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_payment_status__0 TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_payment_status__0 TO webuser1;


--
-- Name: ref_payroll_payment_status; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_payment_status FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_payment_status FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_payment_status TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_payment_status TO webuser1;


--
-- Name: ref_payroll_reporting__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_reporting__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_reporting__0 FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_reporting__0 TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_reporting__0 TO webuser1;


--
-- Name: ref_payroll_reporting; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_reporting FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_reporting FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_reporting TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_reporting TO webuser1;


--
-- Name: ref_payroll_wage__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_wage__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_wage__0 FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_wage__0 TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_wage__0 TO webuser1;


--
-- Name: ref_payroll_wage; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_payroll_wage FROM PUBLIC;
REVOKE ALL ON TABLE ref_payroll_wage FROM gpadmin;
GRANT ALL ON TABLE ref_payroll_wage TO gpadmin;
GRANT SELECT ON TABLE ref_payroll_wage TO webuser1;


--
-- Name: ref_revenue_category__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_revenue_category__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_revenue_category__0 FROM gpadmin;
GRANT ALL ON TABLE ref_revenue_category__0 TO gpadmin;
GRANT SELECT ON TABLE ref_revenue_category__0 TO webuser1;


--
-- Name: ref_revenue_category; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_revenue_category FROM PUBLIC;
REVOKE ALL ON TABLE ref_revenue_category FROM gpadmin;
GRANT ALL ON TABLE ref_revenue_category TO gpadmin;
GRANT SELECT ON TABLE ref_revenue_category TO webuser1;


--
-- Name: ref_revenue_class__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_revenue_class__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_revenue_class__0 FROM gpadmin;
GRANT ALL ON TABLE ref_revenue_class__0 TO gpadmin;
GRANT SELECT ON TABLE ref_revenue_class__0 TO webuser1;


--
-- Name: ref_revenue_class; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_revenue_class FROM PUBLIC;
REVOKE ALL ON TABLE ref_revenue_class FROM gpadmin;
GRANT ALL ON TABLE ref_revenue_class TO gpadmin;
GRANT SELECT ON TABLE ref_revenue_class TO webuser1;


--
-- Name: ref_revenue_source__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_revenue_source__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_revenue_source__0 FROM gpadmin;
GRANT ALL ON TABLE ref_revenue_source__0 TO gpadmin;
GRANT SELECT ON TABLE ref_revenue_source__0 TO webuser1;


--
-- Name: ref_revenue_source; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_revenue_source FROM PUBLIC;
REVOKE ALL ON TABLE ref_revenue_source FROM gpadmin;
GRANT ALL ON TABLE ref_revenue_source TO gpadmin;
GRANT SELECT ON TABLE ref_revenue_source TO webuser1;


--
-- Name: ref_spending_category__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_spending_category__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_spending_category__0 FROM gpadmin;
GRANT ALL ON TABLE ref_spending_category__0 TO gpadmin;
GRANT SELECT ON TABLE ref_spending_category__0 TO webuser1;


--
-- Name: ref_spending_category; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_spending_category FROM PUBLIC;
REVOKE ALL ON TABLE ref_spending_category FROM gpadmin;
GRANT ALL ON TABLE ref_spending_category TO gpadmin;
GRANT SELECT ON TABLE ref_spending_category TO webuser1;


--
-- Name: ref_worksite__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_worksite__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_worksite__0 FROM gpadmin;
GRANT ALL ON TABLE ref_worksite__0 TO gpadmin;
GRANT SELECT ON TABLE ref_worksite__0 TO webuser1;


--
-- Name: ref_worksite; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_worksite FROM PUBLIC;
REVOKE ALL ON TABLE ref_worksite FROM gpadmin;
GRANT ALL ON TABLE ref_worksite TO gpadmin;
GRANT SELECT ON TABLE ref_worksite TO webuser1;


--
-- Name: ref_year__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_year__0 FROM PUBLIC;
REVOKE ALL ON TABLE ref_year__0 FROM gpadmin;
GRANT ALL ON TABLE ref_year__0 TO gpadmin;
GRANT SELECT ON TABLE ref_year__0 TO webuser1;


--
-- Name: ref_year; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE ref_year FROM PUBLIC;
REVOKE ALL ON TABLE ref_year FROM gpadmin;
GRANT ALL ON TABLE ref_year TO gpadmin;
GRANT SELECT ON TABLE ref_year TO webuser1;


--
-- Name: revenue__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE revenue__0 FROM PUBLIC;
REVOKE ALL ON TABLE revenue__0 FROM gpadmin;
GRANT ALL ON TABLE revenue__0 TO gpadmin;
GRANT SELECT ON TABLE revenue__0 TO webuser1;


--
-- Name: revenue; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE revenue FROM PUBLIC;
REVOKE ALL ON TABLE revenue FROM gpadmin;
GRANT ALL ON TABLE revenue TO gpadmin;
GRANT SELECT ON TABLE revenue TO webuser1;


--
-- Name: vendor__0; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE vendor__0 FROM PUBLIC;
REVOKE ALL ON TABLE vendor__0 FROM athiagarajan;
GRANT ALL ON TABLE vendor__0 TO athiagarajan;
GRANT SELECT ON TABLE vendor__0 TO webuser1;


--
-- Name: vendor; Type: ACL; Schema: staging; Owner: athiagarajan
--

REVOKE ALL ON TABLE vendor FROM PUBLIC;
REVOKE ALL ON TABLE vendor FROM athiagarajan;
GRANT ALL ON TABLE vendor TO athiagarajan;
GRANT SELECT ON TABLE vendor TO webuser1;


--
-- Name: vendor_address__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE vendor_address__0 FROM PUBLIC;
REVOKE ALL ON TABLE vendor_address__0 FROM gpadmin;
GRANT ALL ON TABLE vendor_address__0 TO gpadmin;
GRANT SELECT ON TABLE vendor_address__0 TO webuser1;


--
-- Name: vendor_address; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE vendor_address FROM PUBLIC;
REVOKE ALL ON TABLE vendor_address FROM gpadmin;
GRANT ALL ON TABLE vendor_address TO gpadmin;
GRANT SELECT ON TABLE vendor_address TO webuser1;


--
-- Name: vendor_business_type__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE vendor_business_type__0 FROM PUBLIC;
REVOKE ALL ON TABLE vendor_business_type__0 FROM gpadmin;
GRANT ALL ON TABLE vendor_business_type__0 TO gpadmin;
GRANT SELECT ON TABLE vendor_business_type__0 TO webuser1;


--
-- Name: vendor_business_type; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE vendor_business_type FROM PUBLIC;
REVOKE ALL ON TABLE vendor_business_type FROM gpadmin;
GRANT ALL ON TABLE vendor_business_type TO gpadmin;
GRANT SELECT ON TABLE vendor_business_type TO webuser1;


--
-- Name: vendor_history__0; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE vendor_history__0 FROM PUBLIC;
REVOKE ALL ON TABLE vendor_history__0 FROM gpadmin;
GRANT ALL ON TABLE vendor_history__0 TO gpadmin;
GRANT SELECT ON TABLE vendor_history__0 TO webuser1;


--
-- Name: vendor_history; Type: ACL; Schema: staging; Owner: gpadmin
--

REVOKE ALL ON TABLE vendor_history FROM PUBLIC;
REVOKE ALL ON TABLE vendor_history FROM gpadmin;
GRANT ALL ON TABLE vendor_history TO gpadmin;
GRANT SELECT ON TABLE vendor_history TO webuser1;


--
-- Greenplum Database database dump complete
--

