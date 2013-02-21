select * from ref_department where created_load_id = 332

select count(*), coalesce(updated_load_id, created_load_id) from ref_department group by 2 order by 2

select * from etl.etl_data_load_file where load_id = 332 order by load_file_id

select * from etl.etl_data_load_verification where description = 'Number of records inserted into ref_department from payroll'

select * from etl.stg_department where department_code = '003' and fiscal_year = 2013 and agency_code in ('810','040')

select * from ref_agency where agency_id in (18,191)

select * from ref_agency where agency_name ilike '%Education%'

select * from  etl.archive_department limit 10

select max(load_file_id) from etl.archive_department
select agency_code,  fiscal_year, department_code, fund_class_code, count(*) from etl.archive_department where load_file_id = 988 group by 1,2,3,4 having count(*) > 1

select * from  etl.archive_department where load_file_id = 988 and agency_code ='04A' and fiscal_year = 2010 and department_code = '210' AND FUND_CLASS_CODE = '402'