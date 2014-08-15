--  For Graph

--from aggregate tables

-- from source tables

select sum(base_pay+other_payments) from payroll 
join ref_date on payroll.pay_date_id = ref_date.date_id
join ref_month on ref_date.calendar_month_id=ref_month.month_id 
join ref_year on ref_date.nyc_year_id = ref_year.year_id
where ref_month.month_value = 5 and fiscal_year=2011


-- TOP 5 employee by annual salary

-- From Aggregate tables

select b.first_name, b.last_name, c.agency_name, annual_salary, gross_pay, base_pay, other_payments, overtime_pay
 from  aggregateon_payroll_employee_agency a JOIN employee b ON a.employee_id = b.employee_id JOIN ref_agency c ON a.agency_id = c.agency_id
 WHERE fiscal_year_id = 113 and type_of_year = 'B' and type_of_employment = 'Salaried' order by annual_salary desc limit 20


--  From source tables

select employee.first_name, employee.last_name, ref_agency.agency_name, max(annual_salary), sum(gross_pay), sum(base_pay),sum(other_payments),sum(overtime_pay) 
from payroll
join employee_history on employee_history.employee_history_id=payroll.employee_history_id
join employee on employee_history.employee_id = employee.employee_id
join ref_agency on ref_agency.agency_id = payroll.agency_id
where fiscal_year=2012
group by payroll.employee_id,employee.first_name, employee.last_name, ref_agency.agency_name
order by 4 desc limit 10






----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- other Verification Queries


select count(*) from employee ;
select count(*) from employee_history ;
select count(*) from payroll ;
select * from payroll limit 100;



select count(*) from aggregateon_payroll_agency ;
select * from aggregateon_payroll_agency limit 100;

select count(*) from aggregateon_payroll_employee_agency ;
select * from aggregateon_payroll_employee_agency  limit 100;

select count(*) from aggregateon_payroll_dept ;
select * from aggregateon_payroll_dept limit 100;

select count(*) from aggregateon_payroll_employee_dept ;
select * from aggregateon_payroll_employee_dept limit 100 ;

select count(*) from aggregateon_payroll_coa_month ;
select * from aggregateon_payroll_coa_month limit 100;

select count(*) from aggregateon_payroll_year ;
select * from aggregateon_payroll_year limit 100;


-- 2013/01/11


select count(*) from etl.archive_payroll 

select * from etl.archive_payroll limit 10

select employee_number, count(distinct agency_code), group_concat(distinct agency_code) from etl.archive_payroll group by 1 having count(distinct agency_code) > 3

select employee_number, civil_service_code, count(distinct agency_code) from etl.archive_payroll group by 1,2 having count(distinct agency_code) > 1


select * from etl.archive_payroll where employee_number = '0991465' and fiscal_year = 2012 order by agency_code



-- 2013/01/17  for duplicates verification

select count(*), a.pay_date from etl.ext_stg_pms_data_feed  a , payroll b, ref_amount_basis c WHERE a.pay_cycle_code = b.pay_cycle_code AND a.pay_date::date = b.pay_date AND a.employee_number = b.employee_number
AND a.payroll_number = b.payroll_number AND a.job_sequence_number = b.job_sequence_number AND a.agency_code = b.agency_code AND a.pay_frequency = b.pay_frequency 
AND a.amount_basis = c.amount_basis_name AND c.amount_basis_id = b.amount_basis_id 
 group by 2 order by 2

210331;"2012-12-07"
7586;"2012-12-14"

select count(*), a.pay_date from etl.ext_stg_pms_data_feed  a , payroll b, ref_amount_basis c, ref_date d WHERE a.pay_cycle_code = b.pay_cycle_code AND a.pay_date::date = b.pay_date AND a.employee_number = b.employee_number
AND a.payroll_number = b.payroll_number AND a.job_sequence_number = b.job_sequence_number AND a.agency_code = b.agency_code AND a.pay_frequency = b.pay_frequency 
AND a.amount_basis = c.amount_basis_name AND c.amount_basis_id = b.amount_basis_id AND a.orig_pay_cycle_code = b.orig_pay_cycle_code AND a.orig_pay_date::date = d.date AND d.date_id = b.orig_pay_date_id
 group by 2 order by 2

 SELECT a.* from
(select * from etl.ext_stg_pms_data_feed where pay_date = '2012-12-07') a LEFT JOIN
(select a.* from etl.ext_stg_pms_data_feed  a , payroll b, ref_amount_basis c, ref_date d WHERE a.pay_cycle_code = b.pay_cycle_code AND a.pay_date::date = b.pay_date AND a.employee_number = b.employee_number
AND a.payroll_number = b.payroll_number AND a.job_sequence_number = b.job_sequence_number AND a.agency_code = b.agency_code AND a.pay_frequency = b.pay_frequency 
AND a.amount_basis = c.amount_basis_name AND c.amount_basis_id = b.amount_basis_id AND a.orig_pay_cycle_code = b.orig_pay_cycle_code AND a.orig_pay_date::date = d.date AND d.date_id = b.orig_pay_date_id) b
ON a.pay_cycle_code = b.pay_cycle_code AND a.pay_date = b.pay_date AND a.employee_number = b.employee_number
AND a.payroll_number = b.payroll_number AND a.job_sequence_number = b.job_sequence_number AND a.agency_code = b.agency_code AND a.pay_frequency = b.pay_frequency 
AND a.amount_basis = b.amount_basis  AND a.orig_pay_cycle_code = b.orig_pay_cycle_code AND a.orig_pay_date  = b.orig_pay_date
WHERE b.payroll_number IS NULL

select * from etl.archive_payroll  where pay_date = '2012-12-07' and employee_number = '1120278' and payroll_number='300' and agency_code ='003'

select count(*), pay_date from etl.ext_stg_pms_data_feed
 group by 2 order by 2
 
209908;"2012-12-07"
7586;"2012-12-14"

select count(*), pay_date from payroll WHERE pay_date in ('2012-12-07','2012-12-14')
 group by 2 order by 2

210028;"2012-12-07"
119046;"2012-12-14"


select * from ref_amount_basis


select count(*), pay_cycle_code, pay_date, employee_number, payroll_number, job_sequence_number, agency_code, pay_frequency, amount_basis_id, orig_pay_date_id from payroll group by 2,3,4,5,6,7,8,9,10 having count(*) > 1 limit 10

3;"Q";"2012-04-16";"0972890";"742";"1";"040";"SEMI-MONTHLY";1
8;"Q";"2010-11-15";"0445133";"742";"1";"040";"SEMI-MONTHLY";1

select * from payroll where pay_date = '2012-04-16' and employee_number = '0972890' and payroll_number = '742' and agency_code ='040' 

select * from ref_date where date_id in (34052,36218,36036)




COPY (select * from etl.ext_stg_pms_data_feed where pay_date in ('2012-12-07','2012-12-14') order by pay_date, employee_number, payroll_number, agency_code) TO '/tmp/payroll_current_data.csv' CSV HEADER 

COPY (select * from etl.archive_payroll where pay_date in ('2012-12-07','2012-12-14') order by pay_date, employee_number, payroll_number, agency_code) TO '/tmp/payroll_existing_data.csv' CSV HEADER 

COPY(select a.* from etl.ext_stg_pms_data_feed  a , payroll b, ref_amount_basis c, ref_date d WHERE a.pay_cycle_code = b.pay_cycle_code AND a.pay_date::date = b.pay_date AND a.employee_number = b.employee_number
AND a.payroll_number = b.payroll_number AND a.job_sequence_number = b.job_sequence_number AND a.agency_code = b.agency_code AND a.pay_frequency = b.pay_frequency 
AND a.amount_basis = c.amount_basis_name AND c.amount_basis_id = b.amount_basis_id AND a.orig_pay_cycle_code = b.orig_pay_cycle_code AND a.orig_pay_date::date = d.date AND d.date_id = b.orig_pay_date_id) TO '/tmp/payroll_duplicate_data.csv' CSV HEADER

COPY( SELECT a.* from
(select * from etl.ext_stg_pms_data_feed where pay_date = '2012-12-07') a LEFT JOIN
(select a.* from etl.ext_stg_pms_data_feed  a , payroll b, ref_amount_basis c, ref_date d WHERE a.pay_cycle_code = b.pay_cycle_code AND a.pay_date::date = b.pay_date AND a.employee_number = b.employee_number
AND a.payroll_number = b.payroll_number AND a.job_sequence_number = b.job_sequence_number AND a.agency_code = b.agency_code AND a.pay_frequency = b.pay_frequency 
AND a.amount_basis = c.amount_basis_name AND c.amount_basis_id = b.amount_basis_id AND a.orig_pay_cycle_code = b.orig_pay_cycle_code AND a.orig_pay_date::date = d.date AND d.date_id = b.orig_pay_date_id) b
ON a.pay_cycle_code = b.pay_cycle_code AND a.pay_date = b.pay_date AND a.employee_number = b.employee_number
AND a.payroll_number = b.payroll_number AND a.job_sequence_number = b.job_sequence_number AND a.agency_code = b.agency_code AND a.pay_frequency = b.pay_frequency 
AND a.amount_basis = b.amount_basis  AND a.orig_pay_cycle_code = b.orig_pay_cycle_code AND a.orig_pay_date  = b.orig_pay_date
WHERE b.payroll_number IS NULL) TO '/tmp/payroll_not_duplicate_data.csv' CSV HEADER



select max(load_file_id) from etl.etl_data_load_file  -- 703

select max(job_id) from etl.etl_data_load  -- 5

select * from etl.etl_data_load where job_id = 5  Payroll load_id = 92   load_file_id = 704

select a.* from etl.etl_data_load_file a JOIN etl.etl_data_load b ON a.load_id = b.load_id where job_id = 5

select * from etl.etl_data_load_file where load_file_id = 704
select * from etl.etl_data_load where load_id = 92
update etl.etl_data_load  set files_available_flag = 'Y' where load_id = 92

INSERT INTO etl.etl_data_load_file(load_file_id, load_id, file_name, file_timestamp, type_of_feed, consume_flag, pattern_matched_flag, processed_flag) values(767, 152, 'PAYROLL_A015_MODIFIED_PPRG4792_20130116103737.txt','20130116103737','D','Y','Y','N')


select count(*) from etl.ext_stg_pms_data_feed


-- 2013-02-15

select count(*), pay_date, pay_cycle_code from payroll where gross_pay_ytd IS NULL  group by 2,3 order by 2 
7526;"2013-02-08";"A"
245;"2013-02-14";"Y"
17491;"2013-02-14";"E"
964;"2013-02-14";"R"
7519;"2013-02-15";"A"
172282;"2013-02-15";"D"
111065;"2013-02-15";"Q"



select count(*), pay_date, pay_cycle_code from payroll where pay_date > '2013-02-01' group by 2,3 order by pay_date

18;"2013-02-06";"X"
7526;"2013-02-08";"A"
587;"2013-02-14";"X"
245;"2013-02-14";"Y"
17491;"2013-02-14";"E"
964;"2013-02-14";"R"
172571;"2013-02-15";"D"
7519;"2013-02-15";"A"
111065;"2013-02-15";"Q"
37441;"2013-02-20";"T"



-- PAyroll summary data into disbursements table


INSERT INTO ref_expenditure_object(expenditure_object_id, expenditure_object_code, expenditure_object_name, fiscal_year, original_expenditure_object_name, created_date, created_load_id)
VALUES(nextval('seq_ref_expenditure_object_expendtiure_object_id'),'!PS!','Payroll Summary',2015, 'Payroll Summary', now()::timestamp, 0);

INSERT INTO ref_expenditure_object(expenditure_object_id, expenditure_object_code, expenditure_object_name, fiscal_year, original_expenditure_object_name, created_date, created_load_id)
VALUES(nextval('seq_ref_expenditure_object_expendtiure_object_id'),'!PS!','Payroll Summary',2016, 'Payroll Summary', now()::timestamp, 0);

INSERT INTO ref_expenditure_object_history(expenditure_object_history_id, expenditure_object_id, expenditure_object_name, fiscal_year, created_date, load_id)
SELECT nextval('seq_ref_expenditure_object_history_id'), expenditure_object_id, expenditure_object_name, fiscal_year, created_date, created_load_id
FROM ref_expenditure_object WHERE expenditure_object_code = '!PS!' and fiscal_year in (2015,2016);

DELETE FROM disbursement_line_item_details WHERE spending_category_id = 2 and fiscal_year = 2015 ;

INSERT INTO disbursement_line_item_details(disbursement_line_item_id,check_eft_issued_date_id,check_eft_issued_nyc_year_id,check_eft_issued_cal_month_id,
				fund_class_id,check_amount,agency_id,agency_code,expenditure_object_id,department_id,check_eft_issued_date,
				agency_name,department_name,vendor_name,department_code,expenditure_object_name,expenditure_object_code,budget_code_id,
				budget_code,budget_name,fund_class_code,spending_category_id,
				spending_category_name,calendar_fiscal_year_id,calendar_fiscal_year,fiscal_year,
				agency_short_name,department_short_name,load_id)
	SELECT 	payroll_summary_id,pay_date_id,fiscal_year_id,b.calendar_month_id,
		2 as fund_class_id,total_amount as check_amount,h.agency_id,h.agency_code,f.expenditure_object_id,j.department_id,b.date,
		h.agency_name,j.department_name,j.department_name,j.department_code,f.expenditure_object_name,f.expenditure_object_code,a.budget_code_id,
		k.budget_code,k.budget_code_name,'001',2 as spending_category_id,
		'Payroll',calendar_fiscal_year_id,calendar_fiscal_year,a.fiscal_year,
		h.agency_short_name,j.department_short_name,coalesce(a.updated_load_id, a.created_load_id)
	FROM 	payroll_summary a 
	JOIN ref_date b ON a.pay_date_id = b.date_id
	JOIN (select * from ref_expenditure_object where expenditure_object_code = '!PS!') f ON  a.pms_fiscal_year = f.fiscal_year
	JOIN ref_agency_history g ON a.agency_history_id = g.agency_history_id
	JOIN ref_agency h ON g.agency_id = h.agency_id
	JOIN ref_department_history i ON a.department_history_id = i.department_history_id
	JOIN ref_department j ON i.department_id = j.department_id
	JOIN ref_budget_code k ON a.budget_code_id = k.budget_code_id
	WHERE a.fiscal_year = 2015 ;