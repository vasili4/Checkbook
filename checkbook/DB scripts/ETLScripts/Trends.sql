-- For General Fund Revenue Trend

CREATE TABLE etl.trends_gen_fund_revenue_temp
(
  category character varying,
  fy_2011 numeric(20,2),
  fy_2010 numeric(20,2),
  fy_2009 numeric(20,2),
  fy_2008 numeric(20,2),
  fy_2007 numeric(20,2),
  fy_2006 numeric(20,2),
  fy_2005 numeric(20,2),
  fy_2004 numeric(20,2),
  fy_2003 numeric(20,2),
  fy_2002 numeric(20,2),
  fy_2001 numeric(20,2),
  fy_2000 numeric(20,2),
  fy_1999 numeric(20,2),
  fy_1998 numeric(20,2),
  fy_1997 numeric(20,2),
  fy_1996 numeric(20,2),
  fy_1995 numeric(20,2),
  fy_1994 numeric(20,2),
  display_order smallint,
  highlight_yn character(1),
  amount_display_type character(1),
  indentation_level smallint
)
DISTRIBUTED BY (category);


CREATE TABLE trends_gen_fund_revenue
(
  category character varying,
  fiscal_year smallint,
  amount numeric(20,2),
  display_order smallint,
  highlight_yn character(1),
  amount_display_type character(1),
indentation_level smallint
)
DISTRIBUTED BY (category);

/*
1)	Modified the attached source excel by adding display_order,highlight_yn,amount_display_type, indentation_level columns and populating the data in those columns. And also modified the header names.
2)	Removed commas by formatting the amount fields.
3)	Created the CSV of modified excel. Removed some special characters (e.g.   — in line 20 Personal Income— (Non-Resident City Employees))
4)	And then ran the below commands to populate the data in etl. trends_gen_fund_revenue_temp table and public. trends_gen_fund_revenue tables.
*/

COPY  etl.trends_gen_fund_revenue_temp FROM '/home/gpadmin/TREDDY/TRENDS/trends_general_fund_revenues.csv' CSV HEADER QUOTE as '"';

-- 5)	Below are the commands to populate the data from trends_gen_fund_revenue_temp to trends_gen_fund_revenue table.

INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2011, fy_2011, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2010, fy_2010, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2009, fy_2009, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2008, fy_2008, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2007, fy_2007, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2006, fy_2006, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2005, fy_2005, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2004, fy_2004, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2003, fy_2003, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2002, fy_2002, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2001, fy_2001, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2000, fy_2000, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1999, fy_1999, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1998, fy_1998, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1997, fy_1997, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1996, fy_1996, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1995, fy_1995, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;
INSERT INTO trends_gen_fund_revenue (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1994, fy_1994, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_revenue_temp;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- For General Fund Expenditures

CREATE TABLE etl.trends_gen_fund_expenditure_temp
(
  category character varying,
  fy_2011 numeric(20,2),
  fy_2010 numeric(20,2),
  fy_2009 numeric(20,2),
  fy_2008 numeric(20,2),
  fy_2007 numeric(20,2),
  fy_2006 numeric(20,2),
  fy_2005 numeric(20,2),
  fy_2004 numeric(20,2),
  fy_2003 numeric(20,2),
  fy_2002 numeric(20,2),
  fy_2001 numeric(20,2),
  fy_2000 numeric(20,2),
  fy_1999 numeric(20,2),
  fy_1998 numeric(20,2),
  fy_1997 numeric(20,2),
  fy_1996 numeric(20,2),
  fy_1995 numeric(20,2),
  fy_1994 numeric(20,2),
  display_order smallint,
  highlight_yn character(1),
  amount_display_type character(1),
  indentation_level smallint
)
DISTRIBUTED BY (category);


CREATE TABLE trends_gen_fund_expenditure
(
  category character varying,
  fiscal_year smallint,
  amount numeric(20,2),
  display_order smallint,
  highlight_yn character(1),
  amount_display_type character(1),
indentation_level smallint
)
DISTRIBUTED BY (category);

/*
1)            Modified the attached source excel by adding display_order,highlight_yn,amount_display_type, indentation_level columns and populating the data in those columns. And also modified the header names.
2)            Removed commas by formatting the amount fields.
3)            Created the CSV of modified excel. Removed some special characters (e.g.   — in line 20 Personal Income— (Non-Resident City Employees))
4)            And then ran the below commands to populate the data in etl. trends_gen_fund_expenditure_temp table and public. trends_gen_fund_expenditure tables. */

COPY  etl.trends_gen_fund_expenditure_temp FROM '/home/gpadmin/TREDDY/TRENDS/trends_gen_fund_expenditures.csv' CSV HEADER QUOTE as '"';

 -- 5)            Below are the commands to populate the data from trends_gen_fund_expenditure_temp to trends_gen_fund_expenditure table.

INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2011, fy_2011, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2010, fy_2010, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2009, fy_2009, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2008, fy_2008, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2007, fy_2007, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2006, fy_2006, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2005, fy_2005, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2004, fy_2004, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2003, fy_2003, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2002, fy_2002, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2001, fy_2001, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2000, fy_2000, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1999, fy_1999, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1998, fy_1998, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1997, fy_1997, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1996, fy_1996, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1995, fy_1995, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;
INSERT INTO trends_gen_fund_expenditure (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1994, fy_1994, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_gen_fund_expenditure_temp;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- For Capital Projects

CREATE TABLE etl.trends_capital_projects_temp
(
  category character varying,
  fy_2011 numeric(20,2),
  fy_2010 numeric(20,2),
  fy_2009 numeric(20,2),
  fy_2008 numeric(20,2),
  fy_2007 numeric(20,2),
  fy_2006 numeric(20,2),
  fy_2005 numeric(20,2),
  fy_2004 numeric(20,2),
  fy_2003 numeric(20,2),
  fy_2002 numeric(20,2),
  fy_2001 numeric(20,2),
  fy_2000 numeric(20,2),
  fy_1999 numeric(20,2),
  fy_1998 numeric(20,2),
  fy_1997 numeric(20,2),
  fy_1996 numeric(20,2),
  fy_1995 numeric(20,2),
  fy_1994 numeric(20,2),
  display_order smallint,
  highlight_yn character(1),
  amount_display_type character(1),
  indentation_level smallint
)
DISTRIBUTED BY (category);


CREATE TABLE trends_capital_projects
(
  category character varying,
  fiscal_year smallint,
  amount numeric(20,2),
  display_order smallint,
  highlight_yn character(1),
  amount_display_type character(1),
  indentation_level smallint
)
DISTRIBUTED BY (category);

/* 
1)            Modified the attached source excel by adding display_order,highlight_yn,amount_display_type, indentation_level columns and populating the data in those columns. And also modified the header names.
2)            Removed commas by formatting the amount fields.
3)            Created the CSV of modified excel. Removed some special characters (e.g.   — in line 20 Personal Income— (Non-Resident City Employees))
4)            And then ran the below commands to populate the data in etl. trends_capital_projects_temp table and public. trends_capital_projects tables.  */

COPY  etl.trends_capital_projects_temp FROM '/home/gpadmin/TREDDY/TRENDS/trends_capital_projects.csv' CSV HEADER QUOTE as '"';

 -- 5)            Below are the commands to populate the data from trends_capital_projects_temp to trends_capital_projects table.

INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2011, fy_2011, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2010, fy_2010, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2009, fy_2009, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2008, fy_2008, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2007, fy_2007, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2006, fy_2006, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2005, fy_2005, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2004, fy_2004, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2003, fy_2003, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2002, fy_2002, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2001, fy_2001, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 2000, fy_2000, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1999, fy_1999, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1998, fy_1998, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1997, fy_1997, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1996, fy_1996, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1995, fy_1995, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;
INSERT INTO trends_capital_projects (category, fiscal_year, amount, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), 1994, fy_1994, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_capital_projects_temp;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- For Ratios of Outstanding debt


CREATE TABLE etl.trends_ratios_outstanding_debt_temp
(
  fiscal_year smallint,
  general_obligation_bonds numeric(20,2),
  revenue_bonds numeric(20,2),
  ECF numeric(20,2),
  MAC_debt numeric(20,2),
  TFA numeric(20,2),
  TSASC_debt numeric(20,2),
  STAR numeric(20,2),
  FSC numeric(20,2),
  SFC_debt numeric(20,2),
  HYIC_bonds_notes numeric(20,2),
  capital_leases_obligations numeric(20,2),
  IDA_bonds numeric(20,2),
  treasury_obligations numeric(20,2),
  total_primary_government numeric(20,2)
)
DISTRIBUTED BY (fiscal_year);


CREATE TABLE trends_ratios_outstanding_debt
(
  fiscal_year smallint,
  general_obligation_bonds numeric(20,2),
  revenue_bonds numeric(20,2),
  ECF numeric(20,2),
  MAC_debt numeric(20,2),
  TFA numeric(20,2),
  TSASC_debt numeric(20,2),
  STAR numeric(20,2),
  FSC numeric(20,2),
  SFC_debt numeric(20,2),
  HYIC_bonds_notes numeric(20,2),
  capital_leases_obligations numeric(20,2),
  IDA_bonds numeric(20,2),
  treasury_obligations numeric(20,2),
  total_primary_government numeric(20,2)
)
DISTRIBUTED BY (fiscal_year);

/*
1)            Modified the attached source excel y adding  the header names.
2)            Removed commas by formatting the amount fields.
3)            Created the CSV of modified excel. 
4)            And then ran the below commands to populate the data in etl.trends_ratios_outstanding_debt_temp table 

*/
COPY  etl.trends_ratios_outstanding_debt_temp FROM '/home/gpadmin/TREDDY/TRENDS/trends_ratios_outstanding_debt.csv' CSV HEADER QUOTE as '"';

-- 5)            Below are the commands to populate the data from trends_ratios_outstanding_debt_temp to trends_ratios_outstanding_debt table.

INSERT INTO trends_ratios_outstanding_debt  select * from etl.trends_ratios_outstanding_debt_temp;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- For Property tax Levies

CREATE TABLE etl.trends_property_tax_levies_temp
(
  fiscal_year smallint,
  tax_levied numeric(20,2),
  amount numeric(20,2),
  percentage_levy numeric(4,2),
  collected_subsequent_years numeric(20,2),
  levy_non_cash_adjustments numeric(20,2),
  collected_amount numeric(20,2),
  collected_percentage_levy numeric(4,2),
  uncollected_amount numeric(20,2)
)
DISTRIBUTED BY (fiscal_year);


CREATE TABLE trends_property_tax_levies
(
  fiscal_year smallint,
  tax_levied numeric(20,2),
  amount numeric(20,2),
  percentage_levy numeric(4,2),
  collected_subsequent_years numeric(20,2),
  levy_non_cash_adjustments numeric(20,2),
  collected_amount numeric(20,2),
  collected_percentage_levy numeric(4,2),
  uncollected_amount numeric(20,2)
)
DISTRIBUTED BY (fiscal_year);

/*
1)            Modified the attached source excel y adding  the header names.
2)            Removed commas by formatting the amount fields.
3)            Created the CSV of modified excel. 
4)            And then ran the below commands to populate the data in etl.trends_property_tax_levies_temp table 
*/

COPY  etl.trends_property_tax_levies_temp FROM '/home/gpadmin/TREDDY/TRENDS/trends_property_tax_levies.csv' CSV HEADER QUOTE as '"';

-- 5)            Below are the commands to populate the data from trends_property_tax_levies_temp to trends_property_tax_levies table.

INSERT INTO trends_property_tax_levies  select * from etl.trends_property_tax_levies_temp;


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- For Personal Income


CREATE TABLE etl.trends_personal_income_temp
(
  fips character varying,
  area character varying,
  line_code character varying,
  category character varying,
  fy_1980 int,
  fy_1981 int,
  fy_1982 int,
  fy_1983 int,
  fy_1984 int,
  fy_1985 int,
  fy_1986 int,
  fy_1987 int,
  fy_1988 int,
  fy_1989 int,
  fy_1990 int,
  fy_1991 int,
  fy_1992 int,
  fy_1993 int,
  fy_1994 int,
  fy_1995 int,
  fy_1996 int,
  fy_1997 int,
  fy_1998 int,
  fy_1999 int,
  fy_2000 int,
  fy_2001 int,
  fy_2002 int,
  fy_2003 int,
  fy_2004 int,
  fy_2005 int,
  fy_2006 int,
  fy_2007 int,
  fy_2008 int,  
  fy_2009 int,
  display_order smallint,
  highlight_yn character(1),
  amount_display_type character(1),
  indentation_level smallint
)
DISTRIBUTED BY (category);


CREATE TABLE trends_personal_income
(
  category character varying,
  fips character varying,
  area character varying,
  line_code character varying,
  fiscal_year smallint,
  income_or_population int,
  display_order smallint,
  highlight_yn character(1),
  amount_display_type character(1),
indentation_level smallint
)
DISTRIBUTED BY (category);

/*

1)            Modified the attached source excel by adding display_order,highlight_yn,amount_display_type, indentation_level columns and populating the data in those columns. And also modified the header names.
2)            Removed commas by formatting the amount fields.
3)            Created the CSV of modified excel. 
4)            And then ran the below commands to populate the data in etl. trends_personal_income_temp table and public. trends_personal_income tables.

*/

COPY  etl.trends_personal_income_temp FROM '/home/gpadmin/TREDDY/TRENDS/trends_personal_incomes.csv' CSV HEADER QUOTE as '"';

-- 5)            Below are the commands to populate the data from trends_personal_income_temp to trends_personal_income table.

INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2011, 0, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2010, 0, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2009, fy_2009, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2008, fy_2008, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2007, fy_2007, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2006, fy_2006, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2005, fy_2005, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2004, fy_2004, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2003, fy_2003, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2002, fy_2002, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2001, fy_2001, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 2000, fy_2000, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1999, fy_1999, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1998, fy_1998, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1997, fy_1997, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1996, fy_1996, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1995, fy_1995, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1994, fy_1994, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1993, fy_1993, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1992, fy_1992, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1991, fy_1991, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1990, fy_1990, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1989, fy_1989, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1988, fy_1988, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1987, fy_1987, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1986, fy_1986, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1985, fy_1985, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1984, fy_1984, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1983, fy_1983, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1982, fy_1982, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1981, fy_1981, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;
INSERT INTO trends_personal_income (category, fips, area, line_code, fiscal_year, income_or_population, display_order, highlight_yn, amount_display_type, indentation_level) select trim(category), fips, area, line_code, 1980, fy_1980, display_order, highlight_yn, amount_display_type, indentation_level from etl.trends_personal_income_temp;


