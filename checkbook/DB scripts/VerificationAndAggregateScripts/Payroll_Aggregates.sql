DROP TABLE IF EXISTS aggregateon_payroll_employee_agency;

CREATE TABLE aggregateon_payroll_employee_agency(
	employee_id bigint,
	agency_id smallint,
	fiscal_year_id smallint,
	type_of_year char(1),
	pay_frequency varchar,
	type_of_employment varchar,
	start_date date,	
	annual_salary numeric(16,2),
	base_pay numeric(16,2),
	overtime_pay numeric(16,2),
	other_payments numeric(16,2),
	gross_pay numeric(16,2) )
DISTRIBUTED BY (employee_id);


INSERT INTO aggregateon_payroll_employee_agency
SELECT e.employee_id,e.agency_id,e.fiscal_year_id,'B' as type_of_year,
	pay_frequency,
	(CASE WHEN amount_basis_name='ANNUAL' THEN 'Salaried' ELSE 'Non-Salaried' END) as type_of_employment,
	min(e.agency_start_date) as agency_start_date,
	max(annual_sal_table.annual_salary) as annual_salary,
	SUM(base_pay) as base_pay,
	sum(overtime_pay) as overtime_pay,
	sum(other_payments) as other_payments,
	SUM(gross_pay) as gross_pay_ytd	
FROM payroll e JOIN (SELECT d.employee_id,d.payroll_number,d.job_sequence_number,d.fiscal_year,d.agency_id, max(d.annual_salary) as annual_salary
		     FROM (SELECT employee_id,payroll_number,job_sequence_number,fiscal_year,agency_id, max(pay_date) as pay_date
		     	   FROM payroll a 
		     	   JOIN ref_amount_basis f ON a.amount_basis_id = f.amount_basis_id		     	   
		           GROUP BY 1,2,3,4,5) c JOIN payroll d ON d.employee_id = c.employee_id
					     AND d.payroll_number = c.payroll_number 
					     AND d.job_sequence_number = c.job_sequence_number
					     AND d.fiscal_year = c.fiscal_year
						 AND d.agency_id = c.agency_id
					     AND d.pay_date = c.pay_date GROUP BY 1,2,3,4,5) annual_sal_table ON e.employee_id = annual_sal_table.employee_id
		     			AND e.payroll_number = annual_sal_table.payroll_number 
		     			AND e.fiscal_year = annual_sal_table.fiscal_year
		     			AND e.job_sequence_number = annual_sal_table.job_sequence_number
						AND e.agency_id = annual_sal_table.agency_id
	JOIN ref_amount_basis z ON e.amount_basis_id = z.amount_basis_id	
GROUP BY 1,2,3,4,5,6;


INSERT INTO aggregateon_payroll_employee_agency
SELECT e.employee_id,e.agency_id,e.calendar_fiscal_year_id,'C' as type_of_year,
	pay_frequency,
	(CASE WHEN amount_basis_name='ANNUAL' THEN 'Salaried' ELSE 'Non-Salaried' END) as type_of_employment,	
	min(e.agency_start_date) as agency_start_date,	
	min(annual_sal_table.annual_salary) as annual_salary,
	SUM(base_pay) as base_pay,
	sum(overtime_pay) as overtime_pay,
	sum(other_payments) as other_payments,
	SUM(gross_pay) as gross_pay_ytd	
FROM payroll e JOIN (SELECT d.employee_id,d.payroll_number,d.job_sequence_number,d.calendar_fiscal_year,d.agency_id,max(d.annual_salary) as annual_salary
		     FROM (SELECT employee_id,payroll_number,job_sequence_number,calendar_fiscal_year,agency_id, max(pay_date) as pay_date
		     	   FROM payroll a 
		     	   JOIN ref_amount_basis f ON a.amount_basis_id = f.amount_basis_id		     	   
		           GROUP BY 1,2,3,4,5) c JOIN payroll d ON d.employee_id = c.employee_id
					     AND d.payroll_number = c.payroll_number 
					     AND d.job_sequence_number = c.job_sequence_number
					     AND d.calendar_fiscal_year = c.calendar_fiscal_year
						 AND d.agency_id = c.agency_id
					     AND d.pay_date = c.pay_date GROUP BY 1,2,3,4,5) annual_sal_table ON e.employee_id = annual_sal_table.employee_id
		     			AND e.payroll_number = annual_sal_table.payroll_number 
		     			AND e.calendar_fiscal_year = annual_sal_table.calendar_fiscal_year
		     			AND e.job_sequence_number = annual_sal_table.job_sequence_number
						AND e.agency_id = annual_sal_table.agency_id
	JOIN ref_amount_basis z ON e.amount_basis_id = z.amount_basis_id	
GROUP BY 1,2,3,4,5,6;


DROP TABLE IF EXISTS  aggregateon_payroll_agency ;

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
DISTRIBUTED BY (agency_id) ;

INSERT INTO aggregateon_payroll_agency
SELECT X.agency_id,X.fiscal_year_id, X.type_of_year,
	  MIN(base_pay) as base_pay,
	  MIN(other_payments) as other_payments,
	  MIN(gross_pay) as gross_pay,
	  MIN(overtime_pay) as overtime_pay,
	  MIN(total_employees) as total_employees,
	  MIN(salaried_employees) as salaried_employees,
	  MIN(hourly_employees) as hourly_employees,
	  MIN(total_overtime_employees) as total_overtime_employees,
	  SUM(annual_salary) as annual_salary
FROM
(SELECT agency_id,fiscal_year_id,'B' as type_of_year, 
	SUM(base_pay) as base_pay,
	SUM(other_payments) as other_payments,
	SUM(gross_pay) as gross_pay,
       SUM(overtime_pay) as overtime_pay,
       COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) +
       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as total_employees,
       COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) as salaried_employees,
       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as hourly_employees,
       COUNT(DISTINCT (CASE WHEN overtime_pay >0 THEN employee_id END)) as total_overtime_employees
FROM payroll a JOIN ref_amount_basis b ON a.amount_basis_id = b.amount_basis_id
GROUP BY 1,2,3) X
JOIN (SELECT employee_id, agency_id, fiscal_year_id, type_of_year, max(coalesce(annual_salary,0)) as  annual_salary
			  FROM aggregateon_payroll_employee_agency 
			  WHERE type_of_year = 'B' AND type_of_employment = 'Salaried'
			  GROUP BY 1,2,3,4) Y ON X.agency_id = Y.agency_id AND X.fiscal_year_id = Y.fiscal_year_id AND X.type_of_year = Y.type_of_year
GROUP BY 1,2,3;

INSERT INTO aggregateon_payroll_agency
SELECT X.agency_id,X.calendar_fiscal_year_id, X.type_of_year,
	  MIN(base_pay) as base_pay,
	  MIN(other_payments) as other_payments,
	  MIN(gross_pay) as gross_pay,
	  MIN(overtime_pay) as overtime_pay,
	  MIN(total_employees) as total_employees,
	  MIN(salaried_employees) as salaried_employees,
	  MIN(hourly_employees) as hourly_employees,
	  MIN(total_overtime_employees) as total_overtime_employees,
	  SUM(annual_salary) as annual_salary
FROM
(SELECT agency_id,calendar_fiscal_year_id,'C' as type_of_year, 
	SUM(base_pay) as base_pay,
	SUM(other_payments) as other_payments,
	SUM(gross_pay) as gross_pay,
       SUM(overtime_pay) as overtime_pay,
       COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) +
       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as total_employees,
       COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) as salaried_employees,
       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as hourly_employees,
       COUNT(DISTINCT (CASE WHEN overtime_pay >0 THEN employee_id END)) as total_overtime_employees
FROM payroll a JOIN ref_amount_basis b ON a.amount_basis_id = b.amount_basis_id
GROUP BY 1,2,3) X
JOIN (SELECT employee_id, agency_id, fiscal_year_id, type_of_year, max(coalesce(annual_salary,0)) as  annual_salary
			  FROM aggregateon_payroll_employee_agency 
			  WHERE type_of_year = 'C' AND type_of_employment = 'Salaried'
			  GROUP BY 1,2,3,4) Y ON X.agency_id = Y.agency_id AND X.calendar_fiscal_year_id = Y.fiscal_year_id AND X.type_of_year = Y.type_of_year
GROUP BY 1,2,3 ;




DROP TABLE IF EXISTS aggregateon_payroll_coa_month;

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

INSERT INTO aggregateon_payroll_coa_month
SELECT agency_id,department_id,fiscal_year_id,calendar_month_id,'B' as type_of_year,
	SUM(base_pay) as base_pay,
	SUM(overtime_pay) as overtime_pay,
	SUM(other_payments) as other_payments,
	SUM(gross_pay) as gross_pay_ytd	
	FROM payroll a JOIN ref_date b ON a.pay_date_id = b.date_id
	GROUP BY 1,2,3,4,5;


INSERT INTO aggregateon_payroll_coa_month
SELECT agency_id,department_id,calendar_fiscal_year_id,calendar_month_id,'C' as type_of_year,
	SUM(base_pay) as base_pay,
	SUM(overtime_pay) as overtime_pay,
	SUM(other_payments) as other_payments,
	SUM(gross_pay) as gross_pay_ytd	
	FROM payroll a JOIN ref_date b ON a.pay_date_id = b.date_id
	GROUP BY 1,2,3,4,5;
	

	
/*	

DROP TABLE IF EXISTS aggregateon_payroll_dept ;

CREATE TABLE aggregateon_payroll_dept(	
	agency_id smallint,	
	department_id integer,
	fiscal_year_id smallint,
	type_of_year char(1),
	base_pay numeric(16,2),
	other_payments numeric(16,2),	
	gross_pay numeric(16,2),
	overtime_pay numeric(16,2),
	total_employees int,
	total_salaried_employees int,
	total_hourly_employees int,
	total_overtime_employees int)
DISTRIBUTED BY (agency_id) ;

INSERT INTO aggregateon_payroll_dept
SELECT agency_id,department_id,fiscal_year_id,'B' as type_of_year, 
	SUM(base_pay) as base_pay,
	SUM(other_payments) as other_payments,
	SUM(gross_pay) as gross_pay,
       SUM(overtime_pay) as overtime_pay,
       COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) +
       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as total_employees,
       COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) as salaried_employees,
       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as hourly_employees,
       COUNT(DISTINCT (CASE WHEN overtime_pay >0 THEN employee_id END)) as total_overtime_employees
FROM payroll a JOIN ref_amount_basis b ON a.amount_basis_id = b.amount_basis_id
GROUP BY 1,2,3,4;

INSERT INTO aggregateon_payroll_dept
SELECT agency_id,department_id,calendar_fiscal_year_id,'C' as type_of_year, 
	SUM(base_pay) as base_pay,
	SUM(other_payments) as other_payments,
	SUM(gross_pay) as gross_pay,
       SUM(overtime_pay) as overtime_pay,
       COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) +
       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as total_employees,
       COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) as salaried_employees,
       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as hourly_employees,
       COUNT(DISTINCT (CASE WHEN overtime_pay >0 THEN employee_id END)) as total_overtime_employees
FROM payroll a JOIN ref_amount_basis b ON a.amount_basis_id = b.amount_basis_id
GROUP BY 1,2,3,4;






						
		

		
DROP TABLE IF EXISTS aggregateon_payroll_employee_dept;

CREATE TABLE aggregateon_payroll_employee_dept(
	employee_id bigint,
	agency_id smallint,
	department_id integer,
	fiscal_year_id smallint,
	type_of_year char(1),
	pay_frequency varchar,
	type_of_employment varchar,	
	annual_salary numeric(16,2),
	base_pay numeric(16,2),
	overtime_pay numeric(16,2),
	other_payments numeric(16,2),
	gross_pay numeric(16,2) )
DISTRIBUTED BY (employee_id);

INSERT INTO aggregateon_payroll_employee_dept
SELECT e.employee_id,e.agency_id,e.department_id,e.fiscal_year_id,'B' as type_of_year,
	pay_frequency,
	(CASE WHEN amount_basis_name='ANNUAL' THEN 'Salaried' ELSE 'Non-Salaried' END) as type_of_employment,		
	min(annual_sal_table.annual_salary) as annual_salary,
	SUM(base_pay) as base_pay,
	sum(overtime_pay) as overtime_pay,
	sum(other_payments) as other_payments,
	SUM(gross_pay) as gross_pay_ytd	
FROM payroll e JOIN (SELECT d.employee_id,d.payroll_number,d.job_sequence_number,d.fiscal_year,d.agency_id, max(d.annual_salary) as annual_salary
		     FROM (SELECT employee_id,payroll_number,job_sequence_number,fiscal_year,agency_id, max(pay_date) as pay_date
		     	   FROM payroll a 
		     	   JOIN ref_amount_basis f ON a.amount_basis_id = f.amount_basis_id		     	   
		           GROUP BY 1,2,3,4,5) c JOIN payroll d ON d.employee_id = c.employee_id
					     AND d.payroll_number = c.payroll_number 
					     AND d.job_sequence_number = c.job_sequence_number
					     AND d.fiscal_year = c.fiscal_year
						 AND d.agency_id = c.agency_id
					     AND d.pay_date = c.pay_date  GROUP BY 1,2,3,4,5) annual_sal_table ON e.employee_id = annual_sal_table.employee_id
		     			AND e.payroll_number = annual_sal_table.payroll_number 
		     			AND e.fiscal_year = annual_sal_table.fiscal_year
		     			AND e.job_sequence_number = annual_sal_table.job_sequence_number
						AND e.agency_id = annual_sal_table.agency_id
	JOIN ref_amount_basis z ON e.amount_basis_id = z.amount_basis_id	
GROUP BY 1,2,3,4,5,6,7;


INSERT INTO aggregateon_payroll_employee_dept
SELECT e.employee_id,e.agency_id,e.department_id,e.calendar_fiscal_year_id,'C' as type_of_year,
	pay_frequency,
	(CASE WHEN amount_basis_name='ANNUAL' THEN 'Salaried' ELSE 'Non-Salaried' END) as type_of_employment,		
	min(annual_sal_table.annual_salary) as annual_salary,
	SUM(base_pay) as base_pay,
	sum(overtime_pay) as overtime_pay,
	sum(other_payments) as other_payments,
	SUM(gross_pay) as gross_pay_ytd	
FROM payroll e JOIN (SELECT d.employee_id,d.payroll_number,d.job_sequence_number,d.calendar_fiscal_year,d.agency_id,max(d.annual_salary) as annual_salary
		     FROM (SELECT employee_id,payroll_number,job_sequence_number,calendar_fiscal_year,agency_id, max(pay_date) as pay_date
		     	   FROM payroll a 
		     	   JOIN ref_amount_basis f ON a.amount_basis_id = f.amount_basis_id		     	   
		           GROUP BY 1,2,3,4,5) c JOIN payroll d ON d.employee_id = c.employee_id
					     AND d.payroll_number = c.payroll_number 
					     AND d.job_sequence_number = c.job_sequence_number
					     AND d.calendar_fiscal_year = c.calendar_fiscal_year
						 AND d.agency_id = c.agency_id
					     AND d.pay_date = c.pay_date GROUP BY 1,2,3,4,5) annual_sal_table ON e.employee_id = annual_sal_table.employee_id
		     			AND e.payroll_number = annual_sal_table.payroll_number 
		     			AND e.calendar_fiscal_year = annual_sal_table.calendar_fiscal_year
		     			AND e.job_sequence_number = annual_sal_table.job_sequence_number
						AND e.agency_id = annual_sal_table.agency_id
	JOIN ref_amount_basis z ON e.amount_basis_id = z.amount_basis_id	
GROUP BY 1,2,3,4,5,6,7;

*/

DROP TABLE IF EXISTS  aggregateon_payroll_year;

CREATE TABLE aggregateon_payroll_year(	
	fiscal_year_id smallint,
	type_of_year char(1),	
	total_employees int,
	total_salaried_employees int,
	total_hourly_employees int,
	total_overtime_employees int)
DISTRIBUTED BY (fiscal_year_id);


INSERT INTO aggregateon_payroll_year
SELECT fiscal_year_id,'B' as type_of_year,
	COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) +
	       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as total_employees,
	       COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) as salaried_employees,
	       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as hourly_employees,
	       COUNT(DISTINCT (CASE WHEN overtime_pay >0 THEN employee_id END)) as total_overtime_employees
	FROM payroll a JOIN ref_amount_basis b ON a.amount_basis_id = b.amount_basis_id
	GROUP BY 1,2;


INSERT INTO aggregateon_payroll_year
SELECT calendar_fiscal_year_id,'C' as type_of_year,
	COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) +
	       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as total_employees,
	       COUNT(DISTINCT (CASE WHEN  amount_basis_name='ANNUAL' THEN employee_id END)) as salaried_employees,
	       ROUND((COUNT(DISTINCT (CASE WHEN  amount_basis_name IN ('DAILY','HOURLY') THEN employee_id END)) )::DECIMAL /2) as hourly_employees,
	       COUNT(DISTINCT (CASE WHEN overtime_pay >0 THEN employee_id END)) as total_overtime_employees
	FROM payroll a JOIN ref_amount_basis b ON a.amount_basis_id = b.amount_basis_id
	GROUP BY 1,2;
