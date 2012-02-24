create language plpgsql;

/* Sequences for reference tables*/
CREATE SEQUENCE seq_etl_data_load_load_id;
CREATE SEQUENCE seq_ref_agency_agency_id;
CREATE SEQUENCE seq_ref_fund_class_fund_class_id;
CREATE SEQUENCE seq_ref_department_department_id;
CREATE SEQUENCE seq_ref_award_category_award_category_id;
CREATE SEQUENCE seq_ref_award_level_award_level_id;
CREATE SEQUENCE seq_ref_award_method_award_method_id;
CREATE SEQUENCE seq_ref_award_status_award_status_id;
CREATE SEQUENCE seq_ref_balance_number_balance_number_id;
CREATE SEQUENCE seq_ref_budget_code_budget_code_id;
CREATE SEQUENCE seq_ref_business_type_business_type_id;
CREATE SEQUENCE seq_ref_commodity_type_commodity_type_id;
CREATE SEQUENCE seq_ref_document_code_document_code_id;
CREATE SEQUENCE seq_ref_document_function_code_document_function_code_id;
CREATE SEQUENCE seq_ref_employee_category_employee_category_id;
CREATE SEQUENCE seq_ref_employee_classification_employee_classification_id;
CREATE SEQUENCE seq_ref_employee_sub_category_employee_sub_category_id;
CREATE SEQUENCE seq_ref_event_type_event_type_id;
CREATE SEQUENCE seq_ref_expenditure_cancel_reason_expenditure_cancel_reason_id;
CREATE SEQUENCE seq_ref_expenditure_cancel_type_expenditure_cancel_type_id;
CREATE SEQUENCE seq_ref_agreement_type_agreement_type_id;
CREATE SEQUENCE seq_ref_expenditure_object_expendtiure_object_id;
CREATE SEQUENCE seq_ref_expenditure_privacy_type_expenditure_privacy_type_id;
CREATE SEQUENCE seq_ref_expenditure_status_expenditure_status_id;
CREATE SEQUENCE seq_ref_fund_fund_id;
CREATE SEQUENCE seq_ref_funding_class_funding_class_id;
CREATE SEQUENCE seq_ref_funding_source_funding_source_id;
CREATE SEQUENCE seq_ref_location_location_id;
CREATE SEQUENCE seq_ref_object_class_object_class_id;
CREATE SEQUENCE seq_ref_payroll_frequency_payroll_frequency_id;
CREATE SEQUENCE seq_ref_payroll_number_payroll_number_id;
CREATE SEQUENCE seq_ref_payroll_object_payroll_object_id;
CREATE SEQUENCE seq_ref_payroll_payment_payroll_payment_id;
CREATE SEQUENCE seq_ref_payroll_reporting_payroll_reporting_id;
CREATE SEQUENCE seq_ref_pay_type_pay_type_id;
CREATE SEQUENCE seq_ref_procurement_type_procurement_type_id;
CREATE SEQUENCE seq_ref_pay_cycle_pay_cycle_id;
CREATE SEQUENCE seq_ref_revenue_category_revenue_category_id;
CREATE SEQUENCE seq_ref_revenue_class_revenue_class_id;
CREATE SEQUENCE seq_ref_revenue_source_revenue_source_id;
CREATE SEQUENCE seq_ref_worksite_worksite_id;
CREATE SEQUENCE seq_ref_address_type_address_type_id;
CREATE SEQUENCE seq_ref_date_date_id;
CREATE SEQUENCE seq_budget_budget_id;
CREATE SEQUENCE seq_vendor_address_vendor_address_id;
CREATE SEQUENCE seq_vendor_bus_type_vendor_bus_type_id;
CREATE SEQUENCE seq_vendor_history_vendor_history_id;
CREATE SEQUENCE seq_ref_misc_vendor_misc_vendor_id;
CREATE SEQUENCE seq_agreement_commodity_agreement_commodity_id;
CREATE SEQUENCE seq_agreement_worksite_agreement_worksite_id;
CREATE SEQUENCE seq_agreement_accounting_line_id;
CREATE SEQUENCE seq_disbursement_line_item_id;
CREATE SEQUENCE seq_ref_department_history_id;
CREATE SEQUENCE seq_ref_agency_history_id;
CREATE SEQUENCE seq_ref_expenditure_object_history_id;
CREATE SEQUENCE seq_ref_location_history_id;
CREATE SEQUENCE seq_ref_object_class_history_id;
CREATE SEQUENCE seq_ref_year_year_id;
CREATE SEQUENCE seq_ref_month_month_id;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Sequences for FMSV data feed*/

CREATE SEQUENCE seq_address_address_id;
CREATE SEQUENCE seq_vendor_vendor_id;
CREATE SEQUENCE seq_vendor_vendor_sub_code;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Sequence for CON data feed*/

CREATE SEQUENCE seq_agreement_agreement_id;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Sequence for FMS data feed*/

CREATE SEQUENCE seq_expenditure_expenditure_id;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* Sequence for PMS data feed*/

CREATE SEQUENCE seq_payroll_summary_payroll_summary_id;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* REVENUE */

CREATE SEQUENCE seq_revenue_revenue_id;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*Lookup Tables
*/

CREATE TABLE etl_data_load (
    load_id integer PRIMARY KEY DEFAULT nextval('seq_etl_data_load_load_id'::regclass) NOT NULL,
    data_source_code character(1),
    publish_start_time timestamp without time zone,
    publish_end_time timestamp without time zone,
    is_published bit(1)
) distributed by (load_id);

 
CREATE TABLE ref_data_source (
  data_source_code varchar(2) ,
  description varchar(40) ,
  created_date timestamp 
) DISTRIBUTED BY (data_source_code);

CREATE TABLE ref_agency (
    agency_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_agency_agency_id'::regclass) NOT NULL,
    agency_code character varying(20),
    agency_name character varying(50),
    original_agency_name character varying(50),
    created_date timestamp without time zone,
    updated_date timestamp,
    created_load_id integer,
    updated_load_id integer
) distributed by (agency_id);

 ALTER TABLE  ref_agency ADD constraint fk_ref_agency_etl_data_load FOREIGN KEY(created_load_id) references etl_data_load(load_id);
 ALTER TABLE  ref_agency ADD constraint fk_ref_agency_etl_data_load_2 FOREIGN KEY(updated_load_id) references etl_data_load(load_id);

CREATE TABLE ref_agency_history (
    agency_history_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_agency_history_id'::regclass) NOT NULL,
    agency_id smallint,    
    agency_name character varying(50),
    created_date timestamp without time zone,
    load_id integer
) distributed by (agency_history_id);

 ALTER TABLE  ref_agency_history ADD constraint fk_ref_agency_history_etl_data_load FOREIGN KEY(load_id) references etl_data_load(load_id);
 ALTER TABLE  ref_agency_history ADD constraint fk_ref_agency_history_ref_agency FOREIGN KEY(agency_id) references ref_agency(agency_id);

CREATE TABLE ref_year(
	year_id smallint PRIMARY KEY default nextval('seq_ref_year_year_id'),
	year_value smallint
	)
DISTRIBUTED BY (year_id);
	
CREATE TABLE ref_month(
	month_id smallint PRIMARY KEY default nextval('seq_ref_month_month_id'),
	month_value smallint,
	month_name varchar,
	year_id smallint
	)
DISTRIBUTED BY (month_id);
ALTER TABLE  ref_month ADD constraint fk_ref_month_ref_year FOREIGN KEY(year_id) references ref_year(year_id);

CREATE TABLE ref_date(
  date_id    smallint PRIMARY KEY default nextval('seq_ref_date_date_id'),
  date	     DATE,
  nyc_year_id   smallint,
  calendar_month_id smallint
 )
DISTRIBUTED BY (date_id);
ALTER TABLE  ref_date ADD constraint fk_ref_date_ref_month FOREIGN KEY(calendar_month_id) references ref_month(month_id);
ALTER TABLE  ref_date ADD constraint fk_ref_date_ref_year FOREIGN KEY(nyc_year_id) references ref_year(year_id);  
 
CREATE TABLE ref_fund_class (
  fund_class_id smallint PRIMARY KEY default nextval('seq_ref_fund_class_fund_class_id'),
  fund_class_code varchar(5),
  fund_class_name varchar(50),
  created_date timestamp
) DISTRIBUTED BY (fund_class_id);

CREATE TABLE ref_department (
    department_id integer PRIMARY KEY DEFAULT nextval('seq_ref_department_department_id'::regclass) NOT NULL,
    department_code character varying(20),
    department_name character varying(100),
    agency_id smallint,
    fund_class_id smallint,
    fiscal_year smallint,
    original_department_name character varying(50),
    created_date timestamp without time zone,
    updated_date timestamp,
    created_load_id integer,
    updated_load_id integer    
) distributed by (department_id);

 ALTER TABLE  ref_department ADD constraint fk_ref_department_ref_fund_class FOREIGN KEY(fund_class_id) references ref_fund_class (fund_class_id);
 ALTER TABLE  ref_department ADD constraint fk_ref_department_etl_data_load FOREIGN KEY(created_load_id) references etl_data_load;
 ALTER TABLE  ref_department ADD constraint fk_ref_department_ref_agency foreign key (agency_id) references ref_agency (agency_id);
 ALTER TABLE  ref_department ADD constraint fk_ref_department_etl_data_load_2 FOREIGN KEY(updated_load_id) references etl_data_load;
 
CREATE TABLE ref_department_history (
    department_history_id integer PRIMARY KEY DEFAULT nextval('seq_ref_department_history_id'::regclass) NOT NULL,
    department_id integer,
    department_name character varying(100),
    agency_id smallint,
    fund_class_id smallint,
    fiscal_year smallint,
    created_date timestamp without time zone,
    load_id integer
) distributed by (department_history_id);

 ALTER TABLE  ref_department_history ADD constraint fk_ref_department_history_ref_fund_class FOREIGN KEY(fund_class_id) references ref_fund_class (fund_class_id);
 ALTER TABLE  ref_department_history ADD constraint fk_ref_department_history_ref_agency foreign key (agency_id) references ref_agency (agency_id);
 ALTER TABLE  ref_department_history ADD constraint fk_ref_department_history_etl_data_load FOREIGN KEY(load_id) references etl_data_load;
 ALTER TABLE  ref_department_history ADD constraint fk_ref_department_history_ref_department FOREIGN KEY(department_id) references ref_department(department_id);

 CREATE TABLE ref_award_category (
  award_category_id smallint PRIMARY KEY default nextval('seq_ref_award_category_award_category_id'),
  award_category_code varchar(10) default null,
  award_category_name varchar(50) default null,
  created_date timestamp
) DISTRIBUTED BY (award_category_id);


CREATE TABLE ref_award_level (
  award_level_id smallint PRIMARY KEY default nextval('seq_ref_award_level_award_level_id'),
  award_level_code varchar(2) ,
  award_level_name varchar(50),
  created_date timestamp
) DISTRIBUTED BY (award_level_id);

CREATE TABLE ref_award_method (
  award_method_id smallint PRIMARY KEY default nextval('seq_ref_award_method_award_method_id'),
  award_method_code varchar(3) ,
  award_method_name varchar(50),
  created_date timestamp
) DISTRIBUTED BY (award_method_id);

CREATE TABLE ref_award_status (
  award_status_id smallint PRIMARY KEY,
  award_status_name varchar(50),
  created_date timestamp
) DISTRIBUTED BY (award_status_id);

CREATE TABLE ref_balance_number (
  balance_number_id smallint PRIMARY KEY default nextval('seq_ref_balance_number_balance_number_id'),
  balance_number varchar(5) ,
  description varchar(50),
  created_date timestamp 
) DISTRIBUTED BY (balance_number_id);

CREATE TABLE ref_budget_code (
    budget_code_id integer PRIMARY KEY DEFAULT nextval('seq_ref_budget_code_budget_code_id'::regclass) NOT NULL,
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
    load_id integer
) distributed by (budget_code_id);

 ALTER TABLE  ref_budget_code ADD constraint fk_ref_budget_code_ref_fund_class foreign key (fund_class_id) references ref_fund_class (fund_class_id);
 ALTER TABLE  ref_budget_code ADD constraint fk_ref_budget_code_ref_agency FOREIGN KEY (agency_id) REFERENCES ref_agency(agency_id);
 ALTER TABLE  ref_budget_code ADD constraint fk_ref_budget_code_etl_data_load foreign key (load_id) references etl_data_load (load_id);

CREATE TABLE ref_business_type (
  business_type_id smallint PRIMARY KEY default nextval('seq_ref_business_type_business_type_id'),
  business_type_code varchar(4) ,
  business_type_name varchar(50) ,
  created_date timestamp
) DISTRIBUTED BY (business_type_id);


CREATE TABLE ref_business_type_status (
  business_type_status_id smallint PRIMARY KEY ,
  business_type_status varchar(50) ,
  created_date timestamp
) DISTRIBUTED BY (business_type_status_id);

CREATE TABLE ref_commodity_type (
  commodity_type_id smallint PRIMARY KEY,
  commodity_type_name varchar(50) ,
  created_date timestamp
) DISTRIBUTED BY (commodity_type_id);

CREATE TABLE ref_document_code (
  document_code_id  smallint PRIMARY KEY default nextval('seq_ref_document_code_document_code_id'),
  document_code varchar(8) ,
  document_name varchar(100) ,
  created_date timestamp 
) DISTRIBUTED BY (document_code_id);

CREATE TABLE ref_document_function_code (
  document_function_code_id smallint PRIMARY KEY,
  document_function_name varchar(50) ,
  created_date timestamp 
) DISTRIBUTED BY (document_function_code_id);


CREATE TABLE ref_employee_category (
  employee_category_id smallint PRIMARY KEY default nextval('seq_ref_employee_category_employee_category_id'),
  employee_category_name varchar(50) ,
  created_date timestamp 
) DISTRIBUTED BY (employee_category_id);

CREATE TABLE ref_employee_classification (
  employee_classification_id smallint PRIMARY KEY default nextval('seq_ref_employee_classification_employee_classification_id'),
  employee_classification_code varchar(20) ,
  employee_classification_name varchar(50) ,
  created_date timestamp 
) DISTRIBUTED BY (employee_classification_id);
 
 CREATE TABLE ref_employee_sub_category (
   employee_sub_category_id smallint PRIMARY KEY default nextval('seq_ref_employee_sub_category_employee_sub_category_id'),
   employee_sub_category_name varchar(50) ,
   employee_category_id smallint ,
   created_date timestamp 
) DISTRIBUTED BY (employee_sub_category_id);

 ALTER TABLE  ref_employee_sub_category ADD constraint fk_ref_employee_sub_category_ref_employee_category foreign key (employee_category_id) references ref_employee_category (employee_category_id);

CREATE TABLE ref_event_type (
  event_type_id smallint PRIMARY KEY default nextval('seq_ref_event_type_event_type_id'),
  event_type_code varchar(4) ,
  event_type_name varchar(50) ,
  created_date timestamp
) DISTRIBUTED BY (event_type_id);

CREATE TABLE ref_expenditure_cancel_reason (
  expenditure_cancel_reason_id smallint PRIMARY KEY default nextval('seq_ref_expenditure_cancel_reason_expenditure_cancel_reason_id'),
  expenditure_cancel_reason_name varchar(50) ,
  created_date timestamp 
  ) DISTRIBUTED BY (expenditure_cancel_reason_id);


CREATE TABLE ref_expenditure_cancel_type (
  expenditure_cancel_type_id  smallint PRIMARY KEY default nextval('seq_ref_expenditure_cancel_type_expenditure_cancel_type_id'),
  expenditure_cancel_type_name varchar(50) ,
  created_date timestamp 
) DISTRIBUTED BY (expenditure_cancel_type_id);

 
 CREATE TABLE ref_agreement_type (
   agreement_type_id SMALLINT PRIMARY KEY DEFAULT nextval('seq_ref_agreement_type_agreement_type_id'),
   agreement_type_code varchar(2),
   agreement_type_name varchar(50),
   created_date timestamp
) DISTRIBUTED BY (agreement_type_id);

CREATE TABLE ref_expenditure_object (
  expenditure_object_id INT PRIMARY KEY DEFAULT  nextval('seq_ref_expenditure_object_expendtiure_object_id'),
  expenditure_object_code varchar(4) ,
  expenditure_object_name varchar(40) ,
  fiscal_year smallint ,
  original_expenditure_object_name varchar(40) ,
  created_date timestamp ,
    updated_date timestamp,
    created_load_id integer,
    updated_load_id integer      
) DISTRIBUTED BY (expenditure_object_id);

 ALTER TABLE  ref_expenditure_object ADD constraint fk_ref_expenditure_object_etl_data_load foreign key (created_load_id) references etl_data_load (load_id);
 ALTER TABLE  ref_expenditure_object ADD constraint fk_ref_expenditure_object_etl_data_load_2 foreign key (updated_load_id) references etl_data_load (load_id);

CREATE TABLE ref_expenditure_object_history (
  expenditure_object_history_id INT PRIMARY KEY DEFAULT  nextval('seq_ref_expenditure_object_history_id'),
  expenditure_object_id INT,  
  expenditure_object_name varchar(40) ,
  fiscal_year smallint ,
  created_date timestamp ,
  load_id int
) DISTRIBUTED BY (expenditure_object_history_id);

 ALTER TABLE  ref_expenditure_object_history ADD constraint fk_ref_exp_object_history_etl_data_load foreign key (load_id) references etl_data_load (load_id);
 ALTER TABLE  ref_expenditure_object_history ADD constraint fk_ref_exp_object_history_ref_exp_object foreign key (expenditure_object_id) references ref_expenditure_object (expenditure_object_id);


CREATE TABLE ref_expenditure_privacy_type (
  expenditure_privacy_type_id SMALLINT PRIMARY KEY DEFAULT nextval('seq_ref_expenditure_privacy_type_expenditure_privacy_type_id'),
  expenditure_privacy_code varchar(1) ,
  expenditure_privacy_name varchar(20) ,
  created_date timestamp 
) DISTRIBUTED BY (expenditure_privacy_type_id);

CREATE TABLE ref_expenditure_status (
  expenditure_status_id SMALLINT PRIMARY KEY DEFAULT nextval('seq_ref_expenditure_status_expenditure_status_id'),
  expenditure_status_name varchar(50) ,
  created_date timestamp 
) DISTRIBUTED BY (expenditure_status_id);

CREATE TABLE ref_fund (
  fund_id SMALLINT PRIMARY KEY DEFAULT nextval('seq_ref_fund_fund_id'),
  fund_code varchar(20) ,
  fund_name varchar(50) ,
  created_date timestamp
) DISTRIBUTED BY (fund_id);

CREATE TABLE ref_funding_class (
    funding_class_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_funding_class_funding_class_id'::regclass) NOT NULL,
    funding_class_code character varying(4),
    funding_class_name character varying(60),
    funding_class_short_name character varying(15),
    category_name character varying(60),
    city_fund_flag bit(1),
    intra_city_flag bit(1),
    fund_allocation_required_flag bit(1),
    category_code character varying(2),
    created_date timestamp without time zone
) distributed by (funding_class_id);


CREATE TABLE ref_funding_source (
  funding_source_id SMALLINT PRIMARY KEY DEFAULT nextval('seq_ref_funding_source_funding_source_id'),
  funding_source_code varchar(5) ,
  funding_source_name varchar(20) ,
  created_date timestamp
) DISTRIBUTED BY (funding_source_id);



CREATE TABLE ref_location (
    location_id integer PRIMARY KEY DEFAULT nextval('seq_ref_location_location_id'::regclass) NOT NULL,
    location_code character varying(4),
    agency_id smallint,
    location_name character varying(60),
    location_short_name character varying(16),
    original_location_name character varying(60),
    created_date timestamp without time zone,
    updated_date timestamp,
    created_load_id integer,
    updated_load_id integer  
) distributed by (location_id);


 ALTER TABLE  ref_location ADD constraint fk_ref_location_etl_data_load foreign key (created_load_id) references etl_data_load (load_id);
 ALTER TABLE  ref_location ADD CONSTRAINT fk_ref_location_ref_agency FOREIGN KEY (agency_id) REFERENCES ref_agency(agency_id);
 ALTER TABLE  ref_location ADD constraint fk_ref_location_etl_data_load_2 foreign key (updated_load_id) references etl_data_load (load_id);

CREATE TABLE ref_location_history (
    location_history_id integer PRIMARY KEY DEFAULT nextval('seq_ref_location_history_id'::regclass) NOT NULL,
    location_id integer,
    agency_id smallint,
    location_name character varying(60),
    location_short_name character varying(16),
    created_date timestamp without time zone,
    load_id integer
) distributed by (location_history_id);


 ALTER TABLE  ref_location_history ADD constraint fk_ref_location_history_etl_data_load foreign key (load_id) references etl_data_load (load_id);
 ALTER TABLE  ref_location_history ADD CONSTRAINT fk_ref_location_history_ref_agency FOREIGN KEY (agency_id) REFERENCES ref_agency(agency_id);
 ALTER TABLE  ref_location_history ADD CONSTRAINT fk_ref_location_history_ref_location FOREIGN KEY (location_id) REFERENCES ref_location(location_id);


CREATE TABLE ref_minority_type (
  minority_type_id smallint primary key,
  minority_type_name VARCHAR(50),
  created_date timestamp
);

CREATE TABLE ref_object_class (
    object_class_id integer PRIMARY KEY DEFAULT nextval('seq_ref_object_class_object_class_id'::regclass) NOT NULL,
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
    updated_date timestamp,
    created_load_id integer,
    updated_load_id integer      
) distributed by (object_class_id);


 ALTER TABLE  ref_object_class 	ADD constraint fk_ref_object_class_ref_date foreign key (effective_begin_date_id) references ref_date (date_id);
 ALTER TABLE  ref_object_class 	ADD constraint fk_ref_object_class_ref_date_1 foreign key (effective_end_date_id) references ref_date (date_id);
 ALTER TABLE  ref_object_class ADD constraint fk_ref_object_class_etl_data_load foreign key (created_load_id) references etl_data_load (load_id);
 ALTER TABLE  ref_object_class ADD constraint fk_ref_object_class_etl_data_load_2 foreign key (updated_load_id) references etl_data_load (load_id);

CREATE TABLE ref_object_class_history (
    object_class_history_id integer PRIMARY KEY DEFAULT nextval('seq_ref_object_class_history_id'::regclass) NOT NULL,
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
) distributed by (object_class_history_id);


 ALTER TABLE  ref_object_class_history 	ADD constraint fk_ref_object_class_history_ref_date foreign key (effective_begin_date_id) references ref_date (date_id);
 ALTER TABLE  ref_object_class_history 	ADD constraint fk_ref_object_class_history_ref_date_1 foreign key (effective_end_date_id) references ref_date (date_id);
 ALTER TABLE  ref_object_class_history 	ADD constraint fk_ref_obj_class_history_ref_obj_class foreign key (object_class_id) references ref_object_class (object_class_id);
 ALTER TABLE  ref_object_class_history ADD constraint fk_ref_object_class_history_etl_data_load foreign key (load_id) references etl_data_load (load_id);

 
CREATE TABLE ref_payroll_frequency (
  payroll_frequency_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_payroll_frequency_payroll_frequency_id'),
  payroll_frequency_code char(1),
  payroll_frequency_name varchar(50) ,
  created_date timestamp 
) DISTRIBUTED BY (payroll_frequency_id);

CREATE TABLE ref_payroll_number (
    payroll_number_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_payroll_number_payroll_number_id'::regclass) NOT NULL,
    payroll_number character varying(20),
    payroll_name character varying(50),
    agency_id smallint,
    created_date timestamp without time zone
) distributed by (payroll_number_id);

 ALTER TABLE  ref_payroll_number ADD constraint fk_ref_payroll_number_ref_agency FOREIGN KEY (agency_id) REFERENCES ref_agency(agency_id);

CREATE TABLE ref_payroll_object (
  payroll_object_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_payroll_object_payroll_object_id'),
  payroll_object_code varchar(5) ,
  payroll_object_name varchar(100) ,
  created_date timestamp 
) DISTRIBUTED BY (payroll_object_id);

CREATE TABLE ref_payroll_payment_status (
  payroll_payment_status_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_payroll_payment_payroll_payment_id'),
  payroll_payment_status_code varchar(1) ,
  description varchar(50) ,
  created_date timestamp 
) DISTRIBUTED BY (payroll_payment_status_id);

CREATE TABLE ref_payroll_reporting (
  payroll_reporting_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_payroll_reporting_payroll_reporting_id'),
  payroll_reporting_code varchar(5) ,
  payroll_reporting_name varchar(100) ,
  created_date timestamp 
) DISTRIBUTED BY (payroll_reporting_id);

CREATE TABLE ref_payroll_wage (
  payroll_wage_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_payroll_reporting_payroll_reporting_id'),
  payroll_wage_code char(1),
  payroll_wage_name varchar(50) ,
  created_date timestamp
) DISTRIBUTED BY (payroll_wage_id);

CREATE TABLE ref_pay_cycle (
  pay_cycle_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_pay_cycle_pay_cycle_id'),
  pay_cycle_code varchar(20) ,
  description varchar(100) ,
  created_date timestamp
) DISTRIBUTED BY (pay_cycle_id);

CREATE TABLE ref_pay_type (
  pay_type_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_pay_type_pay_type_id'),
  pay_type_code varchar(5) ,
  pay_type_name varchar(100) ,
  balance_number_id smallint ,
  payroll_reporting_id smallint ,
  payroll_object_id smallint ,
  prior_year_payroll_object_id smallint ,
  fringe_indicator char(1) ,
  created_date timestamp 
) DISTRIBUTED BY (pay_type_id);

 ALTER TABLE  ref_pay_type ADD constraint fk_ref_pay_type_ref_balance_number foreign key (balance_number_id) references ref_balance_number (balance_number_id);
 ALTER TABLE  ref_pay_type ADD constraint fk_ref_pay_type_ref_payroll_reporting foreign key (payroll_reporting_id) references ref_payroll_reporting (payroll_reporting_id);
 ALTER TABLE  ref_pay_type ADD constraint fk_ref_pay_type_ref_payroll_object foreign key (payroll_object_id) references ref_payroll_object (payroll_object_id);

CREATE TABLE ref_procurement_type (
  procurement_type_id smallint PRIMARY KEY ,
  procurement_type_name varchar(50) ,
  created_date timestamp
) DISTRIBUTED BY (procurement_type_id);

CREATE TABLE ref_revenue_category (
    revenue_category_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_revenue_category_revenue_category_id'::regclass) NOT NULL,
    revenue_category_code character varying(4),
    revenue_category_name character varying(60),
    revenue_category_short_name character varying(15),
    active_flag bit(1),
    budget_allowed_flag bit(1),
    description character varying(100),
    created_date timestamp without time zone,
    updated_load_id integer,
updated_date timestamp without time zone
) distributed by (revenue_category_id);

CREATE TABLE ref_revenue_class (
  revenue_class_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_revenue_class_revenue_class_id'),
  revenue_class_code varchar(4) not null default '0',
  revenue_class_name varchar(60) ,
  revenue_class_short_name varchar(15) ,
  active_flag bit ,
  budget_allowed_flag bit ,
  description varchar(100),
  created_date timestamp,
    updated_load_id integer,
updated_date timestamp without time zone
) DISTRIBUTED BY (revenue_class_id);

CREATE TABLE ref_revenue_source (
    revenue_source_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_revenue_source_revenue_source_id'::regclass) NOT NULL,
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
updated_date timestamp without time zone

) distributed by (revenue_source_id);


 ALTER TABLE  ref_revenue_source ADD constraint fk_ref_revenue_source_ref_funding_class foreign key (funding_class_id) references ref_funding_class (funding_class_id);
 ALTER TABLE  ref_revenue_source ADD constraint fk_ref_revenue_source_ref_revenue_class foreign key (revenue_class_id) references ref_revenue_class (revenue_class_id);
 ALTER TABLE  ref_revenue_source ADD constraint fk_ref_revenue_source_ref_revenue_category foreign key (revenue_category_id) references ref_revenue_category (revenue_category_id);

CREATE TABLE ref_worksite (
  worksite_id int PRIMARY KEY DEFAULT nextval('seq_ref_worksite_worksite_id'),
  worksite_code varchar(3) ,
  worksite_name varchar(50) ,
  created_date timestamp
) DISTRIBUTED BY (worksite_id);

CREATE TABLE ref_address_type (
  address_type_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_address_type_address_type_id'),
  address_type_code varchar(2),
  address_type_name varchar(50),
  created_date timestamp
);

CREATE TABLE ref_miscellaneous_vendor(
   misc_vendor_id smallint PRIMARY KEY DEFAULT nextval('seq_ref_misc_vendor_misc_vendor_id'),
   vendor_customer_code varchar(20),
   created_date timestamp
  );

  
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
FMSV data feed
*/

CREATE TABLE address (
  address_id int PRIMARY KEY DEFAULT nextval('seq_address_address_id'),
  address_line_1 varchar(75) ,
  address_line_2 varchar(75) ,
  city varchar(60) ,
  state varchar(2) ,
  zip varchar(10) ,
  country varchar(3) 
) distributed by(address_id);

CREATE TABLE vendor (
    vendor_id integer PRIMARY KEY DEFAULT nextval('seq_vendor_vendor_id'::regclass) NOT NULL,
    vendor_customer_code character varying(20),
    legal_name character varying(60),
    alias_name character varying(60),
    miscellaneous_vendor_flag bit(1),
    vendor_sub_code integer DEFAULT nextval('seq_vendor_vendor_sub_code'::regclass),
    display_flag CHAR(1) DEFAULT 'Y',
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (vendor_id);

ALTER TABLE vendor ADD constraint fk_vendor_etl_data_load foreign key (created_load_id) references etl_data_load (load_id);

CREATE TABLE vendor_history (
    vendor_history_id integer PRIMARY KEY DEFAULT nextval('seq_vendor_history_vendor_history_id'::regclass) NOT NULL,
    vendor_id integer,   
    legal_name character varying(60),
    alias_name character varying(60),
    miscellaneous_vendor_flag bit(1),
    vendor_sub_code integer DEFAULT nextval('seq_vendor_vendor_sub_code'::regclass),
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (vendor_history_id);

ALTER TABLE vendor_history ADD CONSTRAINT fk_vendor_history_vendor FOREIGN KEY (vendor_id) references vendor(vendor_id);



CREATE TABLE vendor_address (
    vendor_address_id bigint PRIMARY KEY DEFAULT nextval('seq_vendor_address_vendor_address_id') NOT NULL,
    vendor_history_id integer,
    address_id integer,
    address_type_id smallint,
    effective_begin_date_id smallint,
    effective_end_date_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (vendor_address_id);

ALTER TABLE vendor_address ADD constraint fk_vendor_address_vendor_history foreign key (vendor_history_id) references vendor_history (vendor_history_id);
ALTER TABLE vendor_address ADD constraint fk_vendor_address_address foreign key (address_id) references address (address_id);
ALTER TABLE vendor_address ADD constraint fk_vendor_address_ref_address_type foreign key (address_type_id) references ref_address_type (address_type_id);
ALTER TABLE vendor_address ADD constraint fk_vendor_address_etl_data_load foreign key (load_id) references etl_data_load (load_id);
ALTER TABLE vendor_address ADD constraint fk_vendor_addressr_ref_date foreign key (effective_begin_date_id) references ref_date (date_id);
ALTER TABLE vendor_address ADD constraint fk_vendor_address_ref_date_1 foreign key (effective_end_date_id) references ref_date (date_id);


CREATE TABLE vendor_business_type (
    vendor_business_type_id bigint PRIMARY KEY DEFAULT nextval('seq_vendor_bus_type_vendor_bus_type_id') NOT NULL,
    vendor_history_id integer,
    business_type_id smallint,
    status smallint,
    minority_type_id smallint,
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (vendor_business_type_id);



ALTER TABLE vendor_business_type ADD constraint fk_vendor_business_type_vendor_history foreign key (vendor_history_id) references vendor_history (vendor_history_id);
ALTER TABLE vendor_business_type ADD constraint fk_vendor_business_type_ref_business_type foreign key (business_type_id) references ref_business_type (business_type_id);
ALTER TABLE vendor_business_type ADD constraint fk_vendor_business_type_etl_data_load foreign key (load_id) references etl_data_load (load_id);
ALTER TABLE vendor_business_type ADD constraint fk_vendor_business_type_ref_minority_type foreign key (minority_type_id) references ref_minority_type (minority_type_id);

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
MAG Data feed
*/

CREATE TABLE master_agreement (
    master_agreement_id bigint  PRIMARY KEY DEFAULT nextval('seq_agreement_agreement_id'::regclass) NOT NULL,
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
    privacy_flag char(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (master_agreement_id);

 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_etl_data_load FOREIGN KEY (created_load_id) REFERENCES etl_data_load(load_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_agency_history FOREIGN KEY (agency_history_id) REFERENCES ref_agency_history(agency_history_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_agreement_type FOREIGN KEY (agreement_type_id) REFERENCES ref_agreement_type(agreement_type_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_award_category_1 FOREIGN KEY (award_category_id_1) REFERENCES ref_award_category(award_category_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_award_category_2 FOREIGN KEY (award_category_id_2) REFERENCES ref_award_category(award_category_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_award_category_3 FOREIGN KEY (award_category_id_3) REFERENCES ref_award_category(award_category_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_award_category_4 FOREIGN KEY (award_category_id_4) REFERENCES ref_award_category(award_category_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_award_category_5 FOREIGN KEY (award_category_id_5) REFERENCES ref_award_category(award_category_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_award_level FOREIGN KEY (award_level_id) REFERENCES ref_award_level(award_level_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_award_method FOREIGN KEY (award_method_id) REFERENCES ref_award_method(award_method_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_award_status FOREIGN KEY (award_status_id) REFERENCES ref_award_status(award_status_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_document_code FOREIGN KEY (document_code_id) REFERENCES ref_document_code(document_code_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_document_function_code FOREIGN KEY (document_function_code_id) REFERENCES ref_document_function_code(document_function_code_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_ref_procurement_type FOREIGN KEY (procurement_type_id) REFERENCES ref_procurement_type(procurement_type_id);
 ALTER TABLE  master_agreement ADD CONSTRAINT fk_master_agreement_vendor_history FOREIGN KEY (vendor_history_id) REFERENCES vendor_history(vendor_history_id);
  ALTER TABLE  master_agreement ADD constraint fk_master_agreement_ref_date foreign key (record_date_id) references ref_date (date_id);
  ALTER TABLE  master_agreement ADD constraint fk_master_agreement_ref_date_1 foreign key (effective_begin_date_id) references ref_date (date_id);
  ALTER TABLE  master_agreement ADD constraint fk_master_agreement_ref_date_2 foreign key (effective_end_date_id) references ref_date (date_id);
  ALTER TABLE  master_agreement ADD constraint fk_master_agreement_ref_date_3 foreign key (source_created_date_id) references ref_date (date_id);
  ALTER TABLE  master_agreement ADD constraint fk_master_agreement_ref_date_4 foreign key (source_updated_date_id) references ref_date (date_id);
  ALTER TABLE  master_agreement ADD constraint fk_master_agreement_ref_date_5 foreign key (board_approved_award_date_id) references ref_date (date_id);
  ALTER TABLE  master_agreement ADD constraint fk_master_agreement_ref_date_6 foreign key (original_term_begin_date_id) references ref_date (date_id);
  ALTER TABLE  master_agreement ADD constraint fk_master_agreement_ref_date_7 foreign key (original_term_end_date_id) references ref_date (date_id);
  ALTER TABLE  master_agreement ADD constraint fk_master_agreement_ref_date_8 foreign key (registered_date_id) references ref_date (date_id);
 
 
CREATE TABLE all_agreement_commodity (
    agreement_commodity_id bigint  DEFAULT nextval('seq_agreement_commodity_agreement_commodity_id'::regclass) NOT NULL,
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


 
CREATE TABLE all_agreement_worksite (
    agreement_worksite_id bigint DEFAULT nextval('seq_agreement_worksite_agreement_worksite_id'::regclass) NOT NULL,
    agreement_id bigint,
    worksite_id integer,
    percentage numeric(17,4),
    amount numeric(17,4),
    master_agreement_yn character(1),
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (agreement_id);


 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* CON data feed */

CREATE TABLE agreement (
    agreement_id bigint  PRIMARY KEY DEFAULT nextval('seq_agreement_agreement_id'::regclass) NOT NULL,
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
    privacy_flag char(1),
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (agreement_id);

 ALTER TABLE  agreement ADD constraint fk_agreement_master_agreement foreign key (master_agreement_id) references master_agreement (master_agreement_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_document_code foreign key (document_code_id) references ref_document_code (document_code_id);
 ALTER TABLE  agreement ADD CONSTRAINT fk_agreement_ref_agency_history FOREIGN KEY (agency_history_id) REFERENCES ref_agency_history(agency_history_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_status foreign key (award_status_id) references ref_award_status (award_status_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_procurement_type foreign key (procurement_type_id) references ref_procurement_type (procurement_type_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_document_function_code foreign key (document_function_code_id) references ref_document_function_code (document_function_code_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_method foreign key (award_method_id) references ref_award_method (award_method_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_agreement_type foreign key (agreement_type_id) references ref_agreement_type (agreement_type_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_category_1 foreign key (award_category_id_1) references ref_award_category (award_category_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_category_2 foreign key (award_category_id_2) references ref_award_category (award_category_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_category_3 foreign key (award_category_id_3) references ref_award_category (award_category_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_category_4 foreign key (award_category_id_4) references ref_award_category (award_category_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_category_5 foreign key (award_category_id_5) references ref_award_category (award_category_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_vendor_history foreign key (vendor_history_id) references vendor_history (vendor_history_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_etl_data_load foreign key (created_load_id) references etl_data_load (load_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_level foreign key (award_level_id) references ref_award_level (award_level_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_date foreign key (award_level_id) references ref_award_level (award_level_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_ref_date foreign key (record_date_id) references ref_date (date_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_ref_date_1 foreign key (effective_begin_date_id) references ref_date (date_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_ref_date_2 foreign key (effective_end_date_id) references ref_date (date_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_ref_date_3 foreign key (source_created_date_id) references ref_date (date_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_ref_date_4 foreign key (source_updated_date_id) references ref_date (date_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_ref_date_5 foreign key (registered_date_id) references ref_date (date_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_ref_date_6 foreign key (original_term_begin_date_id) references ref_date (date_id);
 ALTER TABLE  agreement ADD constraint fk_agreement_ref_award_ref_date_7 foreign key (original_term_end_date_id) references ref_date (date_id);


 

CREATE TABLE all_agreement_accounting_line (
    agreement_accounting_line_id bigint DEFAULT nextval('seq_agreement_accounting_line_id'::regclass) NOT NULL,
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
) distributed by (agreement_id);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE all_disbursement (
    disbursement_id integer  PRIMARY KEY DEFAULT nextval('seq_expenditure_expenditure_id'::regclass) NOT NULL,
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
    privacy_flag char(1),
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (disbursement_id);



CREATE TABLE all_disbursement_line_item (
    disbursement_line_item_id bigint  PRIMARY KEY DEFAULT nextval('seq_disbursement_line_item_id'::regclass) NOT NULL,
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
    created_load_id integer,
    updated_load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (disbursement_line_item_id);



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE payroll_summary (
    payroll_summary_id bigint  PRIMARY KEY DEFAULT nextval('seq_payroll_summary_payroll_summary_id'::regclass) NOT NULL,
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
) distributed by (payroll_summary_id);


ALTER TABLE  payroll_summary ADD constraint fk_payroll_summary_ref_pay_cycle foreign key (pay_cycle_id) references ref_pay_cycle (pay_cycle_id);
ALTER TABLE  payroll_summary ADD constraint fk_payroll_summary_ref_exp_object_history foreign key (expenditure_object_history_id) references ref_expenditure_object_history (expenditure_object_history_id);
ALTER TABLE  payroll_summary ADD constraint fk_payroll_summary_ref_payroll_number foreign key (payroll_number_id) references ref_payroll_number (payroll_number_id);
ALTER TABLE  payroll_summary ADD constraint fk_payroll_summary_ref_department_history FOREIGN KEY (department_history_id) REFERENCES ref_department_history(department_history_id);
ALTER TABLE  payroll_summary ADD constraint fk_payroll_summary_ref_budget_code foreign key (budget_code_id) references ref_budget_code (budget_code_id);
ALTER TABLE  payroll_summary ADD constraint fk_payroll_summary_etl_data_load foreign key (load_id) references etl_data_load (load_id);
ALTER TABLE  payroll_summary ADD constraint fk_payroll_summary_ref_agency_summary foreign key (agency_history_id) references ref_agency_history (agency_history_id);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE revenue (
    revenue_id bigint  PRIMARY KEY  DEFAULT nextval('seq_revenue_revenue_id'::regclass) NOT NULL,
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
    balance_sheet_account_override_flag bit(1),
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
    load_id integer,
    created_date timestamp without time zone,
    updated_date timestamp without time zone
) distributed by (revenue_id);

ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_etl_data_load FOREIGN KEY (load_id) REFERENCES etl_data_load(load_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_agency_history FOREIGN KEY (agency_history_id) REFERENCES ref_agency_history(agency_history_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_agency_history_2 FOREIGN KEY (document_agency_history_id) REFERENCES ref_agency_history(agency_history_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_agency_history_3 FOREIGN KEY (ref_document_agency_history_id) REFERENCES ref_agency_history(agency_history_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_budget_code FOREIGN KEY (budget_code_id) REFERENCES ref_budget_code(budget_code_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_department_history FOREIGN KEY (department_history_id) REFERENCES ref_department_history(department_history_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_document_code FOREIGN KEY (document_code_id) REFERENCES ref_document_code(document_code_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_document_code_2 FOREIGN KEY (ref_document_code_id) REFERENCES ref_document_code(document_code_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_document_function_code FOREIGN KEY (document_function_code_id) REFERENCES ref_document_function_code(document_function_code_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_exp_object_history FOREIGN KEY (expenditure_object_history_id) REFERENCES ref_expenditure_object_history(expenditure_object_history_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_fund_class FOREIGN KEY (fund_class_id) REFERENCES ref_fund_class(fund_class_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_funding_source FOREIGN KEY (funding_source_id) REFERENCES ref_funding_source(funding_source_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_object_class_history FOREIGN KEY (object_class_history_id) REFERENCES ref_object_class_history(object_class_history_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_revenue_category FOREIGN KEY (revenue_category_id) REFERENCES ref_revenue_category(revenue_category_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_revenue_class FOREIGN KEY (revenue_class_id) REFERENCES ref_revenue_class(revenue_class_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_revenue_source FOREIGN KEY (revenue_source_id) REFERENCES ref_revenue_source(revenue_source_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_vendor_history FOREIGN KEY (vendor_history_id) REFERENCES vendor_history(vendor_history_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_date FOREIGN KEY (record_date_id) REFERENCES ref_date(date_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_date_1 FOREIGN KEY (service_start_date_id) REFERENCES ref_date(date_id);
ALTER TABLE  revenue ADD CONSTRAINT fk_revenue_ref_date_2 FOREIGN KEY (service_end_date_id) REFERENCES ref_date(date_id);

CREATE TABLE budget (
    budget_id integer PRIMARY KEY DEFAULT nextval('seq_budget_budget_id'::regclass) NOT NULL,
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
    updated_date_id smallint,
    load_id integer,
    created_date timestamp without time zone
) distributed by (budget_id);
	
ALTER TABLE  budget ADD constraint fk_budget_ref_fund_class foreign key (fund_class_id) references ref_fund_class (fund_class_id);
ALTER TABLE  budget ADD constraint fk_budget_ref_agency_history FOREIGN KEY (agency_history_id) REFERENCES ref_agency_history(agency_history_id);
ALTER TABLE  budget ADD constraint fk_budget_ref_department_history FOREIGN KEY (department_history_id) REFERENCES ref_department_history(department_history_id);
ALTER TABLE  budget ADD constraint fk_budget_ref_budget_code foreign key (budget_code_id) references ref_budget_code (budget_code_id);
ALTER TABLE  budget ADD constraint fk_budget_ref_object_class_history foreign key (object_class_history_id) references ref_object_class_history (object_class_history_id);
ALTER TABLE  budget ADD constraint fk_budget_etl_data_load foreign key (load_id) references etl_data_load (load_id);
ALTER TABLE  budget ADD constraint fk_budget_ref_date foreign key (updated_date_id) references ref_date (date_id);

----------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE fact_agreement
(
	agreement_id bigint,
	master_agreement_id bigint,
	document_code_id smallint,
	agency_id smallint ,
	document_id VARCHAR(20),
	document_version integer ,
	effective_begin_date_id smallint,
	effective_end_date_id smallint,
	registered_date_id smallint,
	maximum_contract_amount numeric(16,2),
	award_method_id smallint,
	vendor_id integer,
	original_contract_amount  numeric(16,2),
	master_agreement_yn char(1)	
) DISTRIBUTED BY (agreement_id);

ALTER TABLE fact_agreement ADD constraint fk_fact_agreement_ref_document_code FOREIGN KEY (document_code_id) REFERENCES ref_document_code(document_code_id);
ALTER TABLE fact_agreement ADD constraint fk_fact_agreement_ref_agency FOREIGN KEY (agency_id) REFERENCES ref_agency(agency_id);
ALTER TABLE fact_agreement ADD constraint fk_fact_agreement_ref_award_method FOREIGN KEY (award_method_id) REFERENCES ref_award_method(award_method_id);
ALTER TABLE fact_agreement ADD constraint fk_fact_agreement_vendor FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id);
ALTER TABLE fact_agreement ADD constraint fk_fact_agreement_ref_date FOREIGN KEY (effective_begin_date_id) REFERENCES ref_date(date_id);
ALTER TABLE fact_agreement ADD constraint fk_fact_agreement_ref_date_2 FOREIGN KEY (effective_begin_date_id) REFERENCES ref_date(date_id);
ALTER TABLE fact_agreement ADD constraint fk_fact_agreement_ref_date_3 FOREIGN KEY (effective_begin_date_id) REFERENCES ref_date(date_id);

CREATE TABLE fact_agreement_accounting_line
(	
	agreement_id bigint,		
	line_amount numeric(16,2)	
) DISTRIBUTED BY (agreement_id);

CREATE TABLE fact_revenue
(	revenue_id bigint,
	fiscal_year smallint,
	fiscal_period char(2),
	posting_amount decimal(16,2),
	revenue_category_id smallint,
	revenue_source_id smallint
) DISTRIBUTED BY (revenue_id);


ALTER TABLE  fact_revenue ADD CONSTRAINT fk_fact_revenue_ref_revenue_category FOREIGN KEY (revenue_category_id) REFERENCES ref_revenue_category(revenue_category_id);
ALTER TABLE  fact_revenue ADD CONSTRAINT fk_fact_revenue_ref_revenue_source FOREIGN KEY (revenue_source_id) REFERENCES ref_revenue_source(revenue_source_id);
ALTER TABLE  fact_revenue ADD CONSTRAINT fk_fact_revenue_revenue FOREIGN KEY (revenue_id) REFERENCES revenue(revenue_id);

-----------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE history_master_agreement (LIKE master_agreement) DISTRIBUTED BY (master_agreement_id);
CREATE TABLE all_master_agreement (LIKE master_agreement) DISTRIBUTED BY (master_agreement_id);
CREATE TABLE history_all_master_agreement (LIKE master_agreement) DISTRIBUTED BY (master_agreement_id);


CREATE TABLE history_agreement (LIKE agreement) DISTRIBUTED BY (agreement_id);
CREATE TABLE all_agreement (LIKE agreement) DISTRIBUTED BY (agreement_id);
CREATE TABLE history_all_agreement (LIKE agreement) DISTRIBUTED BY (agreement_id);

CREATE TABLE agreement_accounting_line (LIKE all_agreement_accounting_line) DISTRIBUTED BY (agreement_id);
CREATE TABLE history_agreement_accounting_line (LIKE agreement_accounting_line) DISTRIBUTED BY (agreement_id);
CREATE TABLE history_all_agreement_accounting_line (LIKE agreement_accounting_line) DISTRIBUTED BY (agreement_id);
ALTER TABLE history_all_agreement_accounting_line alter COLUMN agreement_accounting_line_id SET DEFAULT NEXTVAL('seq_agreement_accounting_line_id');


CREATE TABLE agreement_commodity (LIKE all_agreement_commodity) DISTRIBUTED BY (agreement_id);
CREATE TABLE history_agreement_commodity (LIKE agreement_commodity) DISTRIBUTED BY (agreement_id);
CREATE TABLE history_all_agreement_commodity (LIKE agreement_commodity) DISTRIBUTED BY (agreement_id);
ALTER TABLE history_all_agreement_commodity alter COLUMN agreement_commodity_id SET DEFAULT NEXTVAL('seq_agreement_commodity_agreement_commodity_id');


CREATE TABLE agreement_worksite (LIKE all_agreement_worksite) DISTRIBUTED BY (agreement_id);
CREATE TABLE history_agreement_worksite (LIKE agreement_worksite) DISTRIBUTED BY (agreement_id);
CREATE TABLE history_all_agreement_worksite (LIKE agreement_worksite) DISTRIBUTED BY (agreement_id);
ALTER TABLE history_all_agreement_worksite alter COLUMN agreement_worksite_id SET DEFAULT NEXTVAL('seq_agreement_worksite_agreement_worksite_id');

ALTER TABLE  agreement_commodity ADD constraint fk_agreement_commodity_ref_commodity_type foreign key (commodity_type_id) references ref_commodity_type (commodity_type_id);
ALTER TABLE  agreement_commodity ADD constraint fk_agreement_commodity_etl_data_load foreign key (load_id) references etl_data_load (load_id);

ALTER TABLE  agreement_worksite ADD constraint fk_agreement_worksite_ref_commodity_type foreign key (worksite_id) references ref_worksite (worksite_id);
ALTER TABLE  agreement_worksite ADD constraint fk_agreement_worksite_etl_data_load foreign key (load_id) references etl_data_load (load_id);

 ALTER TABLE  agreement_accounting_line ADD constraint fk_agreement_accounting_agreement foreign key (agreement_id) references agreement (agreement_id);
 ALTER TABLE  agreement_accounting_line ADD CONSTRAINT fk_agreement_accounting_line_etl_data_load FOREIGN KEY (load_id) REFERENCES etl_data_load(load_id);
 ALTER TABLE  agreement_accounting_line ADD CONSTRAINT fk_agreement_accounting_line_ref_agency_history FOREIGN KEY (agency_history_id) REFERENCES ref_agency_history(agency_history_id);
 ALTER TABLE  agreement_accounting_line ADD CONSTRAINT fk_agreement_accounting_line_ref_budget_code FOREIGN KEY (budget_code_id) REFERENCES ref_budget_code(budget_code_id);
 ALTER TABLE  agreement_accounting_line ADD CONSTRAINT fk_agreement_accounting_line_ref_department_history FOREIGN KEY (department_history_id) REFERENCES ref_department_history(department_history_id);
 ALTER TABLE  agreement_accounting_line ADD CONSTRAINT fk_agreement_accounting_line_ref_event_type FOREIGN KEY (event_type_id) REFERENCES ref_event_type(event_type_id);
 ALTER TABLE  agreement_accounting_line ADD CONSTRAINT fk_agreement_acc_line_ref_exp_object_history FOREIGN KEY (expenditure_object_history_id) REFERENCES ref_expenditure_object_history(expenditure_object_history_id);
 ALTER TABLE  agreement_accounting_line ADD CONSTRAINT fk_agreement_accounting_line_ref_fund_class FOREIGN KEY (fund_class_id) REFERENCES ref_fund_class(fund_class_id);
 ALTER TABLE  agreement_accounting_line ADD CONSTRAINT fk_agreement_accounting_line_ref_revenue_source FOREIGN KEY (revenue_source_id) REFERENCES ref_revenue_source(revenue_source_id);

CREATE TABLE disbursement (LIKE all_disbursement) DISTRIBUTED BY (disbursement_id);

ALTER TABLE  disbursement ADD CONSTRAINT pk_disbursement PRIMARY KEY(disbursement_id);

ALTER TABLE  disbursement ADD CONSTRAINT fk_disbursement_ref_agency_history FOREIGN KEY (agency_history_id) REFERENCES ref_agency_history(agency_history_id);
ALTER TABLE  disbursement ADD CONSTRAINT fk_disbursement_ref_document_code FOREIGN KEY (document_code_id) REFERENCES ref_document_code(document_code_id);
ALTER TABLE  disbursement ADD CONSTRAINT fk_disbursement_ref_expenditure_cancel_reason FOREIGN KEY (expenditure_cancel_reason_id) REFERENCES ref_expenditure_cancel_reason(expenditure_cancel_reason_id);
ALTER TABLE  disbursement ADD CONSTRAINT fk_disbursement_ref_expenditure_cancel_type FOREIGN KEY (expenditure_cancel_type_id) REFERENCES ref_expenditure_cancel_type(expenditure_cancel_type_id);
ALTER TABLE  disbursement ADD CONSTRAINT fk_disbursement_ref_expenditure_status FOREIGN KEY (expenditure_status_id) REFERENCES ref_expenditure_status(expenditure_status_id);
ALTER TABLE  disbursement ADD CONSTRAINT fk_disbursement_vendor_history FOREIGN KEY (vendor_history_id) REFERENCES vendor_history(vendor_history_id);
ALTER TABLE  disbursement ADD constraint fk_disbursement_etl_data_load foreign key (load_id) references etl_data_load (load_id);
ALTER TABLE  disbursement ADD constraint fk_disbursement_ref_date foreign key (record_date_id) references ref_date (date_id);
ALTER TABLE  disbursement ADD constraint fk_disbursement_ref_date_1 foreign key (check_eft_issued_date_id) references ref_date (date_id);
ALTER TABLE  disbursement ADD constraint fk_disbursement_ref_date_2 foreign key (check_eft_record_date_id) references ref_date (date_id);

CREATE TABLE disbursement_line_item (LIKE all_disbursement_line_item) DISTRIBUTED BY (disbursement_line_item_id);

 ALTER TABLE  disbursement_line_item ADD constraint fk_disbursement_line_item_expenditure foreign key (disbursement_id) references disbursement (disbursement_id);
 ALTER TABLE  disbursement_line_item ADD constraint fk_disbursement_line_item_ref_fund_class foreign key (fund_class_id) references ref_fund_class (fund_class_id);
 ALTER TABLE  disbursement_line_item ADD constraint fk_disbursement_line_item_ref_agency_history FOREIGN KEY (agency_history_id) REFERENCES ref_agency_history(agency_history_id);
 ALTER TABLE  disbursement_line_item ADD constraint fk_disbursement_line_item_ref_department_history FOREIGN KEY (department_history_id) REFERENCES ref_department_history(department_history_id);
 ALTER TABLE  disbursement_line_item ADD constraint fk_disb_line_item_ref_exp_object_history foreign key (expenditure_object_history_id) references ref_expenditure_object_history (expenditure_object_history_id);
 ALTER TABLE  disbursement_line_item ADD constraint fk_disbursement_line_item_ref_budget_code foreign key (budget_code_id) references ref_budget_code (budget_code_id);
 ALTER TABLE  disbursement_line_item ADD constraint fk_disbursement_line_item_ref_fund foreign key (fund_id) references ref_fund (fund_id);
 ALTER TABLE  disbursement_line_item ADD constraint fk_disbursement_line_item_agreement foreign key (agreement_id) references agreement (agreement_id);
 ALTER TABLE  disbursement_line_item ADD constraint fk_disbursement_line_item_etl_data_load foreign key (created_load_id) references etl_data_load (load_id);
 ALTER TABLE  disbursement_line_item ADD constraint fk_disbursement_line_item_ref_location_history foreign key (location_history_id) references ref_location_history (location_history_id);


CREATE TABLE fact_disbursement_line_item(
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
	maximum_spending_limit numeric(16,2))
DISTRIBUTED BY (disbursement_line_item_id);