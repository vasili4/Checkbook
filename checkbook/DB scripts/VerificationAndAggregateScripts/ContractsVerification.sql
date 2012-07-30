select count(*) from etl.stg_con_ct_header
select count(*) from  etl.stg_con_ct_award_detail
select count(*) from etl.stg_con_ct_vendor
select count(*) from etl.stg_con_ct_accounting_line
select count(*) from etl.stg_con_po_header
select count(*) from etl.stg_con_po_award_detail
select count(*) from etl.stg_con_po_vendor
select count(*) from etl.stg_con_po_accounting_line
select count(*) from etl.stg_con_do1_header
select count(*) from etl.stg_con_do1_vendor
select count(*) from etl.stg_con_do1_accounting_line
select count(*) from etl.stg_con_do1_header
select count(*) from etl.stg_con_do1_vendor
select count(*) from etl.stg_con_do1_accounting_line


Verification queries for contracts - Registered
-----------------------------------  FY 2011 


Number of Master agreements (MA1+MMA1)
----------------------------------------

select count(distinct original_master_agreement_id) from history_master_agreement  where registered_fiscal_year_id  = 112 and document_code_id in (5,6)-- 861

Number of standalone (CT1, CTA2, POC,POD,PCC1)
----------------------------------------------

select count(distinct original_agreement_id) from history_agreement  where registered_fiscal_year_id  = 112 AND document_code_id in (1,3,9,10,11) -- 11486


Commited contracts amount MA1+MMA1+ Standalone
----------------------------------------------
Sum of the below two

select sum(maximum_spending_limit)
from
history_master_agreement b join (
select a.original_master_agreement_id, max(document_version) as document_version
from
history_master_agreement a join 
(select original_master_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year from history_master_agreement  where registered_fiscal_year_id  = 112 and document_code_id in (5,6)
and source_updated_fiscal_year <= 2011
GROUP BY 1 ) tbl1 on a.original_master_agreement_id = tbl1.original_master_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
GROUP BY 1 ) tbl2 on  b.original_master_agreement_id = tbl2.original_master_agreement_id AND b.document_version = tbl2.document_version-- 861 4321932563.09

select sum(maximum_contract_amount)
from
history_agreement b join (
select a.original_agreement_id, max(document_version) as document_version
from
history_agreement a join 
(select original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year from history_agreement  where registered_fiscal_year_id  = 112 and document_code_id in (1,3,9,10,11)
and source_updated_fiscal_year <= 2011
GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
GROUP BY 1 ) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version --12860289803.67

Total contracts spending till date
----------------------------------
select sum(b.check_amount)
from
(select distinct original_agreement_id
from history_agreement  
where registered_fiscal_year_id  = 112 ) a join disbursement_line_item b on a.original_agreement_id = b.agreement_id
join disbursement c on b.disbursement_id = c.disbursement_id
join ref_date d on c.check_eft_issued_date_id = d.date_id
join ref_year e on d.nyc_year_id = e.year_id
where e.year_value <=2011

Top 5 Master agreements
-----------------------

select b.original_master_agreement_id,b.contract_number,b.maximum_spending_limit,original_contract_amount,sum(c.check_amount)
from
history_master_agreement b join (
	select a.original_master_agreement_id, max(document_version) as document_version
	from
	history_master_agreement a join 
		(select original_master_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_master_agreement  
		where registered_fiscal_year_id  = 112 and document_code_id in (5,6)
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_master_agreement_id = tbl1.original_master_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_master_agreement_id = tbl2.original_master_agreement_id AND b.document_version = tbl2.document_version
	JOIN disbursement_line_item_details c ON b.original_master_agreement_id = c.master_agreement_id AND c.fiscal_year <=2011
	group by 1,2,3,4
ORDER BY 1

Top 5 Contracts
----------------

select b.original_agreement_id,b.contract_number,b.maximum_contract_amount,original_contract_amount,sum(c.check_amount)
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  
		where registered_fiscal_year_id  = 112 
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version
	JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2011
	group by 1,2,3,4
ORDER BY 5 desc

Top 5 Contracts Award Modifications
-----------------------------------

select b.original_agreement_id,b.contract_number,b.maximum_contract_amount,original_contract_amount,b.maximum_contract_amount-original_contract_amount,
ROUND((b.maximum_contract_amount-original_contract_amount) *100 / original_contract_amount,2) as percentage,
sum(c.check_amount)
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  
		where registered_fiscal_year_id  = 112 
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version
	JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2011
	group by 1,2,3,4
ORDER BY 5 desc

Top 5 Vendors
-------------

select d.vendor_id,COUNT(distinct b.original_agreement_id ),SUM(distinct b.maximum_contract_amount),SUM(distinct original_contract_amount),sum(c.check_amount),
group_concat(b.original_agreement_id)
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  
		where registered_fiscal_year_id  = 112 
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version
	JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2011
	JOIN vendor_history d ON b.vendor_history_id = d.vendor_history_id
	group by 1
ORDER BY 3 desc


Top 5 Vendors (Modified)
-------------
a) From Source tables

select f.vendor_id,COUNT(*),SUM(f.original_contract_amount),SUM(f.maximum_contract_amount),sum(f.spending_amount),  group_concat(original_agreement_id)
FROM
(SELECT b.original_agreement_id, d.vendor_id, MIN(b.original_contract_amount) as original_contract_amount, MIN(b.maximum_contract_amount) as maximum_contract_amount, sum(c.check_amount) as spending_amount
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  
		where registered_fiscal_year_id  = 112 
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version
	LEFT JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2011
	JOIN vendor_history d ON b.vendor_history_id = d.vendor_history_id
	group by 1,2) f 
GROUP BY 1
ORDER BY 4 desc LIMIT 5






b) From aggregate table

SELECT vendor_id, count(original_agreement_id), sum(original_contract_amount), sum(maximum_contract_amount), sum(spending_amount) ,  group_concat(original_agreement_id)
FROM aggregateon_contracts_cumulative_spending
WHERE status_flag = 'R' AND type_of_year = 'B' AND fiscal_year = 2011 AND master_agreement_yn = 'N'
Group by 1 ORDER BY 4 desc LIMIT 5


Top 5 award methods
-------------------

a) From Source tables

select f.award_method_id,COUNT(*),SUM(f.original_contract_amount),SUM(f.maximum_contract_amount),sum(f.spending_amount),  group_concat(original_agreement_id)
FROM
(SELECT b.original_agreement_id, b.award_method_id, MIN(b.original_contract_amount) as original_contract_amount, MIN(b.maximum_contract_amount) as maximum_contract_amount, sum(c.check_amount) as spending_amount
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  
		where registered_fiscal_year_id  = 112 
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version
	LEFT JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2011
	group by 1,2) f 
GROUP BY 1
ORDER BY 4 desc LIMIT 5



b) From aggregate table

SELECT award_method_id, count(original_agreement_id), sum(original_contract_amount), sum(maximum_contract_amount), sum(spending_amount) ,  group_concat(original_agreement_id)
FROM aggregateon_contracts_cumulative_spending
WHERE status_flag = 'R' AND type_of_year = 'B' AND fiscal_year = 2011 AND master_agreement_yn = 'N'
Group by 1 ORDER BY 4 desc LIMIT 5



Top 5 Agencies
--------------------

a) From Source tables

SELECT g.agency_id,COUNT(*),SUM(g.original_contract_amount),SUM(g.maximum_contract_amount),sum(g.spending_amount),  group_concat(original_agreement_id)
FROM
(select f.original_agreement_id, f.agency_id, MIN(f.original_contract_amount) as original_contract_amount, MIN(f.maximum_contract_amount) as maximum_contract_amount, sum(f.spending_amount) as spending_amount
FROM
(SELECT b.original_agreement_id, 
last_value(c.agency_id) over (partition by b.original_agreement_id  ORDER BY c.fiscal_year asc) as agency_id, 
b.original_contract_amount as original_contract_amount,
b.maximum_contract_amount as maximum_contract_amount, 
c.check_amount as spending_amount
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  
		where registered_fiscal_year_id  = 112 
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version
	LEFT JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2011
	) f 
GROUP BY 1,2) g WHERE agency_id IS NOT NULL
GROUP BY 1
ORDER BY 4 desc LIMIT 5



b) From aggregate table

SELECT agency_id, count(original_agreement_id), sum(original_contract_amount), sum(maximum_contract_amount), sum(spending_amount) ,  group_concat(original_agreement_id)
FROM aggregateon_contracts_cumulative_spending
WHERE status_flag = 'R' AND type_of_year = 'B' AND fiscal_year = 2011 AND master_agreement_yn = 'N' AND  coalesce(agency_id,0) <> 0
Group by 1 ORDER BY 4 desc LIMIT 5

-- needs to modify the aggregate scripts to put the agency_id value NULL instead of 0


Verification queries for contracts - Active
-----------------------------------  FY 2011 


Top 5 Master agreements
-----------------------

a) From Source Tables

select b.original_master_agreement_id,b.contract_number,b.maximum_spending_limit,original_contract_amount,sum(c.check_amount)
from
history_master_agreement b join (
	select a.original_master_agreement_id, max(document_version) as document_version
	from
	history_master_agreement a join 
		(select original_master_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_master_agreement  
		where 2011 between effective_begin_fiscal_year  AND effective_end_fiscal_year  and document_code_id in (5,6)
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_master_agreement_id = tbl1.original_master_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_master_agreement_id = tbl2.original_master_agreement_id AND b.document_version = tbl2.document_version
	LEFT JOIN disbursement_line_item_details c ON b.original_master_agreement_id = c.master_agreement_id AND c.fiscal_year <=2011
	group by 1,2,3,4
ORDER BY 3 desc limit 5


b) From Aggregate Table

select original_agreement_id, contract_number, maximum_contract_amount, original_contract_amount, spending_amount
FROM aggregateon_contracts_cumulative_spending 
WHERE status_flag = 'A' AND type_of_year = 'B' AND fiscal_year = 2011 AND master_agreement_yn = 'Y' and document_code_id in (5,6)
ORDER BY 3 desc LIMIT 5


Top 5 Contracts
----------------

a) From Source Tables

select b.original_agreement_id,b.contract_number,b.maximum_contract_amount,original_contract_amount,sum(c.check_amount)
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  
		where 2011 between effective_begin_fiscal_year  AND effective_end_fiscal_year
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version AND 2011 between b.effective_begin_fiscal_year  AND b.effective_end_fiscal_year
	LEFT JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2011
	WHERE b.maximum_contract_amount IS NOT NULL
	group by 1,2,3,4
ORDER BY 3 desc limit 5


b) From Aggregate Table

select original_agreement_id, contract_number, maximum_contract_amount, original_contract_amount, spending_amount
FROM aggregateon_contracts_cumulative_spending 
WHERE status_flag = 'A' AND type_of_year = 'B' AND fiscal_year = 2011 AND master_agreement_yn = 'N' AND maximum_contract_amount IS NOT NULL
ORDER BY 3 desc LIMIT 5


Top 5 Contracts Award Modifications
-----------------------------------

a) From Source Tables

select b.original_agreement_id,b.contract_number,b.maximum_contract_amount,original_contract_amount,coalesce(b.maximum_contract_amount,0)-coalesce(b.original_contract_amount,0) as dollar_difference,
(CASE WHEN coalesce(b.original_contract_amount,0) = 0 THEN 0 ELSE 
		ROUND((( coalesce(b.maximum_contract_amount,0) - coalesce(b.original_contract_amount,0)) * 100 )::decimal / b.original_contract_amount,2) END) as percentage_difference,
sum(c.check_amount)
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  
		where 2011 between effective_begin_fiscal_year  AND effective_end_fiscal_year
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version 
	LEFT JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2011
	WHERE b.original_contract_amount IS NOT NULL 
	group by 1,2,3,4,5,6
ORDER BY 5 desc limit 5

b) From Aggregate Table


select original_agreement_id, contract_number, maximum_contract_amount, original_contract_amount, spending_amount, dollar_difference, percent_difference
FROM aggregateon_contracts_cumulative_spending 
WHERE status_flag = 'A' AND type_of_year = 'B' AND fiscal_year = 2011 AND master_agreement_yn = 'N' AND original_contract_amount IS NOT NULL
ORDER BY 6 desc LIMIT 5


-- may be we need to change the MAG and CON scripts of inserting the data into agreement_snapshot table to replace 

from

(CASE WHEN coalesce(b.original_contract_amount,0) = 0 THEN 0 ELSE 
		ROUND((( b.maximum_spending_limit - b.original_contract_amount) * 100 )::decimal / b.original_contract_amount,2) END)
		
to
(CASE WHEN coalesce(b.original_contract_amount,0) = 0 THEN 0 ELSE 
		ROUND((( coalesce(b.maximum_contract_amount,0) - coalesce(b.original_contract_amount,0)) * 100 )::decimal / b.original_contract_amount,2) END)	
		
		

Top 5 Vendors 
-------------
a) From Source tables

select f.vendor_id,COUNT(*),SUM(f.original_contract_amount),SUM(f.maximum_contract_amount),sum(f.spending_amount),  group_concat(original_agreement_id)
FROM
(SELECT b.original_agreement_id, d.vendor_id, MIN(b.original_contract_amount) as original_contract_amount, MIN(b.maximum_contract_amount) as maximum_contract_amount, sum(c.check_amount) as spending_amount
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select ha1.original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  ha1 ,
		(select original_agreement_id
		from history_agreement 
		WHERE latest_flag = 'Y' AND 2011 between effective_begin_fiscal_year  AND effective_end_fiscal_year) ha2
		where ha1.original_agreement_id = ha2.original_agreement_id 
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version 
	LEFT JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2011
	JOIN vendor_history d ON b.vendor_history_id = d.vendor_history_id
	group by 1,2) f 
GROUP BY 1
ORDER BY 4 desc LIMIT 5


b) From aggregate table

SELECT vendor_id, count(original_agreement_id), sum(original_contract_amount), sum(maximum_contract_amount), sum(spending_amount) ,  group_concat(original_agreement_id)
FROM aggregateon_contracts_cumulative_spending
WHERE status_flag = 'A' AND type_of_year = 'B' AND fiscal_year = 2011 AND master_agreement_yn = 'N'
GROUP BY 1 ORDER BY 4 desc LIMIT 5


select count(distinct original_agreement_id) from (select original_agreement_id, fiscal_year, starting_year, ending_year, maximum_contract_amount from agreement_snapshot_expanded where status_flag = 'A' and original_agreement_id in (374654) order by original_agreement_id, fiscal_year) X


Top 5 award methods
-------------------

a) From Source tables

select f.award_method_id,COUNT(*),SUM(f.original_contract_amount),SUM(f.maximum_contract_amount),sum(f.spending_amount),  group_concat(original_agreement_id)
FROM
(SELECT b.original_agreement_id, b.award_method_id, MIN(b.original_contract_amount) as original_contract_amount, MIN(b.maximum_contract_amount) as maximum_contract_amount, sum(c.check_amount) as spending_amount
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select ha1.original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  ha1 ,
		(select original_agreement_id
		from history_agreement 
		WHERE latest_flag = 'Y' AND 2011 between effective_begin_fiscal_year  AND effective_end_fiscal_year) ha2
		where ha1.original_agreement_id = ha2.original_agreement_id 
		and source_updated_fiscal_year <= 2011
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year 
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version 
	LEFT JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2011
	group by 1,2) f 
GROUP BY 1
ORDER BY 4 desc LIMIT 5



b) From aggregate table

SELECT award_method_id, count(original_agreement_id), sum(original_contract_amount), sum(maximum_contract_amount), sum(spending_amount) ,  group_concat(original_agreement_id)
FROM aggregateon_contracts_cumulative_spending
WHERE status_flag = 'A' AND type_of_year = 'B' AND fiscal_year = 2011 AND master_agreement_yn = 'N'
GROUP BY 1 ORDER BY 4 desc LIMIT 5



Top 5 Agencies
--------------------

a) From Source tables

SELECT g.agency_id,COUNT(*),SUM(g.original_contract_amount),SUM(g.maximum_contract_amount),sum(g.spending_amount),  group_concat(original_agreement_id)
FROM
(select f.original_agreement_id, f.agency_id, MIN(f.original_contract_amount) as original_contract_amount, MIN(f.maximum_contract_amount) as maximum_contract_amount, sum(f.spending_amount) as spending_amount
FROM
(SELECT b.original_agreement_id, 
first_value(c.agency_id) over (partition by b.original_agreement_id  ORDER BY c.check_eft_issued_date desc,c.agency_id asc) as agency_id, 
b.original_contract_amount as original_contract_amount,
b.maximum_contract_amount as maximum_contract_amount, 
c.check_amount as spending_amount
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select ha1.original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  ha1 ,
		(select original_agreement_id
		from history_agreement 
		WHERE latest_flag = 'Y' AND 2012 between effective_begin_fiscal_year  AND effective_end_fiscal_year) ha2
		where ha1.original_agreement_id = ha2.original_agreement_id 
		and source_updated_fiscal_year <= 2012
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version
	LEFT JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2012
	) f 
GROUP BY 1,2) g WHERE agency_id IS NOT NULL
GROUP BY 1
ORDER BY 4 desc LIMIT 5



b) From aggregate table

SELECT agency_id, count(original_agreement_id), sum(original_contract_amount), sum(maximum_contract_amount), sum(spending_amount) ,  group_concat(original_agreement_id)
FROM aggregateon_contracts_cumulative_spending
WHERE status_flag = 'A' AND type_of_year = 'B' AND fiscal_year = 2011 AND master_agreement_yn = 'N' AND  coalesce(agency_id,0) <> 0
Group by 1 ORDER BY 4 desc LIMIT 5



SELECT X.agency_id, X.total_spent_amount - Y.total_spent_amount as difference_amount
FROM
(SELECT g.agency_id,sum(g.spending_amount) as total_spent_amount
FROM
(select f.original_agreement_id, f.agency_id, MIN(f.original_contract_amount) as original_contract_amount, MIN(f.maximum_contract_amount) as maximum_contract_amount, sum(f.spending_amount) as spending_amount
FROM
(SELECT b.original_agreement_id, 
first_value(c.agency_id) over (partition by b.original_agreement_id  ORDER BY c.check_eft_issued_date desc,c.agency_id asc) as agency_id, 
b.original_contract_amount as original_contract_amount,
b.maximum_contract_amount as maximum_contract_amount, 
c.check_amount as spending_amount
from
history_agreement b join (
	select a.original_agreement_id, max(document_version) as document_version
	from
	history_agreement a join 
		(select ha1.original_agreement_id,max(source_updated_fiscal_year) as source_updated_fiscal_year 
		from history_agreement  ha1 ,
		(select original_agreement_id
		from history_agreement 
		WHERE latest_flag = 'Y' AND 2012 between effective_begin_fiscal_year  AND effective_end_fiscal_year) ha2
		where ha1.original_agreement_id = ha2.original_agreement_id 
		and source_updated_fiscal_year <= 2012
		GROUP BY 1 ) tbl1 on a.original_agreement_id = tbl1.original_agreement_id AND a.source_updated_fiscal_year = tbl1.source_updated_fiscal_year
	GROUP BY 1 order by 1) tbl2 on  b.original_agreement_id = tbl2.original_agreement_id AND b.document_version = tbl2.document_version
	LEFT JOIN disbursement_line_item_details c ON b.original_agreement_id = c.agreement_id AND c.fiscal_year <=2012
	) f 
GROUP BY 1,2) g WHERE agency_id IS NOT NULL
GROUP BY 1) X,
(SELECT agency_id,  sum(spending_amount) as total_spent_amount
FROM aggregateon_contracts_department
WHERE status_flag = 'A'
AND type_of_year = 'B'
AND fiscal_year = 2012 
GROUP BY 1) Y
WHERE X.agency_id = Y.agency_id order by 2 desc



-- Reloading MAG, CON and FMS data

-- delete the data 

TRUNCATE history_master_agreement CASCADE;

TRUNCATE history_agreement CASCADE;

TRUNCATE history_agreement_accounting_line CASCADE;

TRUNCATE history_agreement_commodity CASCADE;

TRUNCATE history_agreement_worksite CASCADE;

TRUNCATE agreement_snapshot CASCADE;

TRUNCATE agreement_snapshot_cy CASCADE;

TRUNCATE vendor CASCADE;

TRUNCATE vendor_address CASCADE;

TRUNCATE vendor_business_type CASCADE;

TRUNCATE vendor_history CASCADE;

TRUNCATE disbursement CASCADE;

TRUNCATE disbursement_line_item CASCADE;

TRUNCATE disbursement_line_item_deleted CASCADE;

DELETE FROM disbursement_line_item_details WHERE spending_category_id != 2 ;


INSERT INTO  etl.etl_data_load (job_id, data_source_code) VALUES (3, 'M'),(3,'C'),(3,'F'),(3,'F');

INSERT INTO etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag) values(27,'AIEF_DLY_PCOP_MA_20120523225810.txt','20120523195328','D','Y','Y','N');
INSERT INTO etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag) values(28,'AIE2_DLY_PCO_PO_20120523191824.txt','20120523195328','D','Y','Y','N');
INSERT INTO etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag) values(29,'AIE0_DLY_MMDSB_AD_20120523195328.txt','20120523195328','D','Y','Y','N');
INSERT INTO etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag) values(30,'AIE0_DLY_MMDSB_MD_20120523195328.txt','20120523195328','D','Y','Y','N');


DATA_SOURCE_CODE  		LOAD_ID			LOAD_FILE_ID           DOC_TYPE
 M						 27					31		
 C						 28					32
 F						 29					33					 AD
 F						 30					34					 MD
 
 
 gpfdist -d /home/gpadmin/athiagarajan/NYC/ -p 8081 -l /home/gpadmin/athiagarajan/log
 psql -c " copy (select * from etl.stg_con_po_award_detail) to stdout " checkbook_new | psql -c "copy etl.stg_con_po_award_detail from stdin "  checkbook
 
 
 CREATE USER webuser1 WITH PASSWORD 'webuser1';
CREATE USER qa_user WITH PASSWORD 'qa_user';
CREATE USER datafeeduser WITH PASSWORD 'datafeeduser';


GRANT ALL ON database checkbook_uat TO webuser1;
GRANT ALL ON database checkbook_uat TO qa_user;
GRANT ALL ON database checkbook_uat TO datafeeduser;


GRANT ALL ON SCHEMA etl TO webuser1;
GRANT ALL ON SCHEMA public TO webuser1;


GRANT ALL ON ALL TABLES IN SCHEMA etl TO webuser1;
GRANT ALL ON ALL TABLES IN SCHEMA public TO webuser1;


GRANT ALL ON ALL SEQUENCES IN SCHEMA etl TO webuser1;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO webuser1;

GRANT ALL ON ALL FUNCTIONS IN SCHEMA etl TO webuser1;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO webuser1;

INSERT INTO etl.etl_data_load_file(load_id,file_name,file_timestamp,type_of_feed,consume_flag,pattern_matched_flag,processed_flag) values(13,'OASIS_feed.txt','20120523195328','D','Y','Y','N');

/*
 nohup pg_dump "checkbook_new" -vFc -f checkbook_07_27.dump 1>1.out 2>2.err &
 nohup pg_restore -d "checkbook_mtr" -v checkbook_07_27.dump 1>1.out 2>2.err &
 
 */
 