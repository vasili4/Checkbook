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