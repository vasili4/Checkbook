/*
Functions defined
	updateforeignkeysforbudget
	processbudget

*/

CREATE OR REPLACE FUNCTION etl.updateforeignkeysforbudget() RETURNS INT AS $$
DECLARE
BEGIN
	/* UPDATING FOREIGN KEY VALUES	FOR BUDGET DATA*/		
	
	CREATE TEMPORARY TABLE tmp_fk_budget_values (uniq_id bigint, fund_class_id smallint, agency_history_id smallint, department_history_id integer, budget_code_id integer, object_class_history_id integer, updated_date_id smallint)
	DISTRIBUTED BY (uniq_id);
	
	-- FK:fund_class_id

	INSERT INTO tmp_fk_budget_values(uniq_id,fund_class_id)
	SELECT	a.uniq_id, b.fund_class_id as fund_class_id
	FROM etl.stg_budget a JOIN ref_fund_class b ON a.fund_class_code = b.fund_class_code;
		
	-- FK:Agency_history_id
	
	INSERT INTO tmp_fk_budget_values(uniq_id,agency_history_id)
	SELECT	a.uniq_id, max(c.agency_history_id) as agency_history_id
	FROM etl.stg_budget a JOIN ref_agency b ON a.agency_code = b.agency_code
		JOIN ref_agency_history c ON b.agency_id = c.agency_id
	GROUP BY 1;
	
	-- FK:department_history_id
	
	INSERT INTO tmp_fk_budget_values(uniq_id,department_history_id)
	SELECT	a.uniq_id, max(e.department_history_id) as department_history_id
	FROM etl.stg_budget a JOIN ref_agency b ON a.agency_code = b.agency_code
	JOIN ref_fund_class c ON a.fund_class_code = c.fund_class_code
	JOIN ref_department d ON a.department_code = d.department_code AND b.agency_id = d.agency_id AND c.fund_class_id = d.fund_class_id AND  a.budget_fiscal_year = d.fiscal_year
	JOIN ref_department_history e ON d.department_id = e.department_id
	GROUP BY 1;

	-- FK:budget_code_id

	INSERT INTO tmp_fk_budget_values(uniq_id,budget_code_id)
	SELECT	a.uniq_id, b.budget_code_id as budget_code_id
	FROM etl.stg_budget a JOIN ref_budget_code b ON a.budget_code = b.budget_code;

	-- FK:object_class_history_id

	INSERT INTO tmp_fk_budget_values(uniq_id,object_class_history_id)
	SELECT	a.uniq_id, max(c.object_class_history_id) as object_class_history_id
	FROM etl.stg_budget a JOIN ref_object_class b ON a.object_class_code = b.object_class_code
		JOIN ref_object_class_history c ON b.object_class_id = c.object_class_id
	GROUP BY 1;
	
	--FK:effective_begin_date_id
	
	INSERT INTO tmp_fk_budget_values(uniq_id,updated_date_id)
	SELECT	a.uniq_id, b.date_id
	FROM etl.stg_budget a JOIN ref_date b ON a.updated_date::date = b.date;
	
	
	
	UPDATE etl.stg_budget a
	SET	fund_class_id = ct_table.fund_class_id,
		agency_history_id = ct_table.agency_history_id,
		department_history_id = ct_table.department_history_id,
		budget_code_id = ct_table.budget_code_id,		
		object_class_history_id = ct_table.object_class_history_id,
		updated_date_id = ct_table.updated_date_id
	FROM	(SELECT uniq_id, max(fund_class_id) as fund_class_id, 
				 max(agency_history_id) as agency_history_id,
				 max(department_history_id) as department_history_id,
				 max(budget_code_id) as budget_code_id,
				 max(object_class_history_id) as object_class_history_id,
				 max(updated_date_id) as updated_date_id
		 FROM	tmp_fk_budget_values
		 GROUP BY 1) ct_table
	WHERE	a.uniq_id = ct_table.uniq_id;	
	
	RETURN 1;
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in updateForeignKeysForBudget';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;

---------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION etl.processbudget(p_load_file_id_in integer, p_load_id_in bigint) RETURNS INT AS $$
DECLARE
	l_fk_update int;

BEGIN	      

	l_fk_update := etl.updateForeignKeysForBudget();

	RAISE NOTICE 'BUDGET 1';

	UPDATE etl.stg_budget 
	SET action_flag = 'I', 
	total_expenditure_amount = coalesce(pre_encumbered_amount,0) + coalesce(encumbered_amount,0) + coalesce(accrued_expense_amount,0) + coalesce(cash_expense_amount,0) + coalesce(post_closing_adjustment_amount,0) ;

	CREATE TEMPORARY TABLE tmp_budget_unique_keys(uniq_id bigint, budget_fiscal_year smallint, fund_class_id smallint, agency_history_id smallint,  department_history_id integer, budget_code_id integer, object_class_history_id integer, action_flag character(1), budget_id integer) 
	DISTRIBUTED BY (uniq_id);

	INSERT INTO tmp_budget_unique_keys(uniq_id, budget_fiscal_year, fund_class_id, agency_history_id,  department_history_id, budget_code_id, object_class_history_id, action_flag, budget_id)
	SELECT a.uniq_id, a.budget_fiscal_year, a.fund_class_id, a.agency_history_id,  a.department_history_id, a.budget_code_id, a.object_class_history_id, 'U' as action_flag, b.budget_id
	FROM etl.stg_budget a, budget b, ref_agency c, ref_agency_history d, ref_department e, ref_department_history f, ref_object_class g, ref_object_class_history h
	WHERE a.budget_fiscal_year = b.budget_fiscal_year AND a.fund_class_id = b.fund_class_id  AND a.budget_code_id = b.budget_code_id 
	 AND a.agency_history_id = d.agency_history_id AND  b.agency_history_id = d.agency_history_id  AND d.agency_id = c.agency_id 
	 AND a.department_history_id = f.department_history_id AND b.department_history_id = f.department_history_id AND e.department_id = f.department_id
	 AND a.object_class_history_id = h.object_class_history_id  AND b.object_class_history_id = h.object_class_history_id AND g.object_class_id = h.object_class_id;

	UPDATE etl.stg_budget a
	SET	action_flag = b.action_flag,
		budget_id = b.budget_id
	FROM	tmp_budget_unique_keys b
	WHERE 	a.uniq_id = b.uniq_id;

	CREATE TEMPORARY TABLE tmp_budget_data_to_update(budget_id integer, adopted_amount numeric(20,2), current_budget_amount numeric(20,2), pre_encumbered_amount numeric(20,2),  encumbered_amount numeric(20,2), accrued_expense_amount numeric(20,2), cash_expense_amount numeric(20,2), 
	post_closing_adjustment_amount numeric(20,2), 	total_expenditure_amount numeric(20,2), updated_date_id smallint, load_id integer) 
	DISTRIBUTED BY (budget_id);

	INSERT INTO tmp_budget_data_to_update(budget_id, adopted_amount, current_budget_amount, pre_encumbered_amount,  encumbered_amount, accrued_expense_amount, cash_expense_amount, 
	post_closing_adjustment_amount, total_expenditure_amount, updated_date_id, load_id )
	SELECT budget_id, adopted_amount, current_budget_amount, pre_encumbered_amount,  encumbered_amount, accrued_expense_amount, cash_expense_amount, 
	post_closing_adjustment_amount, total_expenditure_amount, updated_date_id, p_load_id_in
	FROM etl.stg_budget 
	WHERE action_flag = 'U' AND budget_id IS NOT NULL;

	UPDATE budget a
	SET adopted_amount = b.adopted_amount,
	current_budget_amount = b.current_budget_amount,
	pre_encumbered_amount = b.pre_encumbered_amount,
	encumbered_amount = b.encumbered_amount,
	accrued_expense_amount = b.accrued_expense_amount,
	cash_expense_amount = b.cash_expense_amount,
	post_closing_adjustment_amount = b.post_closing_adjustment_amount,
	total_expenditure_amount = b.total_expenditure_amount,
	updated_date_id = b.updated_date_id,
	load_id = b.load_id
	FROM tmp_budget_data_to_update b
	WHERE a.budget_id = b.budget_id;

	INSERT INTO budget(budget_fiscal_year, fund_class_id, agency_history_id, department_history_id, budget_code_id, object_class_history_id, adopted_amount, current_budget_amount, pre_encumbered_amount, encumbered_amount, accrued_expense_amount, cash_expense_amount, 
	post_closing_adjustment_amount, total_expenditure_amount, updated_date_id, load_id, created_date)
	SELECT budget_fiscal_year, fund_class_id, agency_history_id, department_history_id, budget_code_id, object_class_history_id, adopted_amount, current_budget_amount, pre_encumbered_amount, encumbered_amount, accrued_expense_amount, cash_expense_amount, 
	post_closing_adjustment_amount, total_expenditure_amount, updated_date_id , p_load_id_in, now()::timestamp
	FROM  etl.stg_budget 
	WHERE action_flag = 'I' AND budget_id IS NULL;
	
	

	RAISE NOTICE 'BUDGET 2';
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processbudget';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$$ language plpgsql;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

