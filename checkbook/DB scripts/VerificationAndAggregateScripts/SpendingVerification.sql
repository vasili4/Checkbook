select * from ref_department limit 10

select * from disbursement_line_item_details limit 10


select * from ref_expenditure_object where expenditure_object_id = 15972

select * from ref_expenditure_object where expenditure_object_code = 5180 order by fiscal_year desc


select count(distinct department_id), group_concat(distinct department_id), agency_id, department_code, fiscal_year,  fund_class_id from disbursement_line_item_details  where  spending_category_id <> 2 group by 3, 4, 5, 6 having count(distinct department_id) > 1 order by fiscal_year desc
2;"38331, 40384";18;"402";2012;2


select count(distinct department_id), group_concat(distinct department_id), agency_id, department_code, calendar_fiscal_year,  fund_class_id from disbursement_line_item_details where spending_category_id <> 2 group by  3, 4, 5, 6 having count(distinct department_id) > 1  order by calendar_fiscal_year desc
2;"13456, 20607";13;"104";2012;6

select * from ref_department where department_id  in (38331, 40384)

select * from disbursement_line_item_details where spending_category_id <> 2 and department_id = 40384 and fiscal_year = 2012 and fund_class_id = 2

select * from disbursement_line_item where disbursement_line_item_id in (6922528,7075138,7074661)

select * from disbursement_line_item_details  where disbursement_line_item_id in (6922528,7075138,7074661)

select * from ref_department_history where department_history_id = 36855

select * from etl.archive_fms_accounting_line where doc_id = '20120304337' and doc_cd = 'AD' and doc_dept_cd = 'DSB' and doc_vers_no = 2 and appr_cd = '402'

select * from etl.archive_fms_header  where doc_id = '20120304337' and doc_cd = 'AD' and doc_dept_cd = 'DSB' and doc_vers_no = 2 and appr_cd = '402'



select count(distinct department_id), group_concat(distinct department_id), agency_id, department_code, fiscal_year,  fund_class_id from disbursement_line_item_details  where  spending_category_id = 2 group by 3, 4, 5, 6 having count(distinct department_id) > 1 order by fiscal_year desc

select count(distinct department_id), group_concat(distinct department_id), agency_id, department_code, calendar_fiscal_year,  fund_class_id from disbursement_line_item_details where spending_category_id = 2 group by  3, 4, 5, 6 having count(distinct department_id) > 1  order by calendar_fiscal_year desc

select distinct fiscal_year, check_eft_issued_nyc_year_id from disbursement_line_item_details where  spending_category_id <> 2
select distinct fiscal_year, check_eft_issued_nyc_year_id from disbursement_line_item_details where  spending_category_id = 2


select distinct calendar_fiscal_year, calendar_fiscal_year_id from disbursement_line_item_details where  spending_category_id <> 2 
select distinct calendar_fiscal_year, calendar_fiscal_year_id from disbursement_line_item_details where  spending_category_id = 2 

select * from ref_department where department_code = '402' order by fiscal_year desc, agency_id desc 