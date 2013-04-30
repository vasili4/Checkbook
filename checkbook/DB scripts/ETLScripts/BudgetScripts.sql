/* Function defined
updateforeignkeysforbudget
processbudget
*/


-- Function: etl.processbudget(integer, bigint)

-- DROP FUNCTION etl.processbudget(integer, bigint);

CREATE OR REPLACE FUNCTION etl.processbudget(p_load_file_id_in integer, p_load_id_in bigint)
  RETURNS integer AS
$BODY$
DECLARE
	l_fk_update int;
	l_count bigint;

BEGIN	      

	l_fk_update := etl.updateForeignKeysForBudget(p_load_file_id_in,p_load_id_in);

	IF l_fk_update <> 1 THEN
		RETURN -1;
	END IF;
	
	RAISE NOTICE 'BUDGET 1';


	UPDATE etl.stg_budget 
	SET action_flag = 'I', 
		total_expenditure_amount = coalesce(pre_encumbered_amount,0) + coalesce(encumbered_amount,0) + 
					   coalesce(accrued_expense_amount,0) + coalesce(cash_expense_amount,0) + 
					   coalesce(post_closing_adjustment_amount,0),
		remaining_budget = current_budget_amount-total_expenditure_amount;

	CREATE TEMPORARY TABLE tmp_budget_unique_keys(uniq_id bigint, budget_fiscal_year smallint, fund_class_id smallint, agency_history_id smallint,  department_history_id integer, budget_code_id integer, object_class_history_id integer, action_flag character(1), budget_id integer) 
	DISTRIBUTED BY (uniq_id);

	INSERT INTO tmp_budget_unique_keys(uniq_id, budget_fiscal_year, fund_class_id, agency_history_id,  department_history_id, 
					   budget_code_id, object_class_history_id, action_flag, budget_id)
	SELECT 	a.uniq_id, a.budget_fiscal_year, a.fund_class_id, a.agency_history_id,  a.department_history_id, 
		a.budget_code_id, a.object_class_history_id, 'U' as action_flag, b.budget_id
	FROM 	etl.stg_budget a JOIN budget b ON a.budget_fiscal_year = b.budget_fiscal_year 
		AND a.fund_class_id = b.fund_class_id  
		AND a.budget_code_id = b.budget_code_id 
		AND a.agency_id = b.agency_id
		AND a.department_id = b.department_id
		AND a.object_class_id = b.object_class_id;
		
	UPDATE etl.stg_budget a
	SET	action_flag = b.action_flag,
		budget_id = b.budget_id
	FROM	tmp_budget_unique_keys b
	WHERE 	a.uniq_id = b.uniq_id;

	CREATE TEMPORARY TABLE tmp_budget_data_to_update(budget_id integer, adopted_amount numeric(20,2), current_budget_amount numeric(20,2), 
							 pre_encumbered_amount numeric(20,2),  encumbered_amount numeric(20,2), accrued_expense_amount numeric(20,2), 
							 cash_expense_amount numeric(20,2), post_closing_adjustment_amount numeric(20,2), 	
							 total_expenditure_amount numeric(20,2),remaining_budget numeric(20,2), load_id integer,budget_fiscal_year_id smallint,
							 agency_code varchar,department_code varchar,object_class_code varchar,agency_short_name varchar,department_short_name varchar) 
	DISTRIBUTED BY (budget_id);

	INSERT INTO tmp_budget_data_to_update(budget_id, adopted_amount, current_budget_amount, 
					      pre_encumbered_amount,  encumbered_amount, accrued_expense_amount, 
					      cash_expense_amount, post_closing_adjustment_amount, 
					      total_expenditure_amount,remaining_budget,load_id,budget_fiscal_year_id,
					      agency_code,department_code,object_class_code,
					      agency_short_name,department_short_name)
	SELECT budget_id, adopted_amount, current_budget_amount, 
	       pre_encumbered_amount,  encumbered_amount, accrued_expense_amount, 
	       cash_expense_amount, post_closing_adjustment_amount, 
	       total_expenditure_amount,remaining_budget, p_load_id_in,budget_fiscal_year_id,
	       agency_code,department_code,object_class_code,
	       agency_short_name,department_short_name
	FROM etl.stg_budget 
	WHERE action_flag = 'U' AND budget_id IS NOT NULL;

	UPDATE budget a
	SET 	adopted_amount_original = b.adopted_amount,
		adopted_amount = coalesce(b.adopted_amount,0),
		current_budget_amount_original = b.current_budget_amount,
		current_budget_amount = coalesce(b.current_budget_amount,0),
		pre_encumbered_amount_original = b.pre_encumbered_amount,
		pre_encumbered_amount = coalesce(b.pre_encumbered_amount,0),
		encumbered_amount_original = b.encumbered_amount,
		encumbered_amount = coalesce(b.encumbered_amount,0),
		accrued_expense_amount_original = b.accrued_expense_amount,
		accrued_expense_amount = coalesce(b.accrued_expense_amount,0),
		cash_expense_amount_original = b.cash_expense_amount,
		cash_expense_amount = coalesce(b.cash_expense_amount,0),
		post_closing_adjustment_amount_original = b.post_closing_adjustment_amount,
		post_closing_adjustment_amount = coalesce(b.post_closing_adjustment_amount,0),
		total_expenditure_amount = b.total_expenditure_amount,
		remaining_budget = b.remaining_budget,
		updated_load_id = b.load_id,
		updated_date = now()::timestamp,
		budget_fiscal_year_id = b.budget_fiscal_year_id,
		agency_code = b.agency_code,
		department_code = b.department_code,
		object_class_code = b.object_class_code,
		agency_short_name = b.agency_short_name,
		department_short_name = b.department_short_name
	FROM 	tmp_budget_data_to_update b
	WHERE 	a.budget_id = b.budget_id;

	GET DIAGNOSTICS l_count = ROW_COUNT;
	INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
	VALUES(p_load_file_id_in,'B',l_count,'# of records updated in budget ');
	
	INSERT INTO budget(budget_fiscal_year, fund_class_id, agency_history_id, department_history_id, budget_code_id, 
			   object_class_history_id, adopted_amount_original, adopted_amount, current_budget_amount_original, current_budget_amount, 
			   pre_encumbered_amount_original, pre_encumbered_amount, encumbered_amount_original,encumbered_amount, 
			   accrued_expense_amount_original, accrued_expense_amount, cash_expense_amount_original,cash_expense_amount, 
			   post_closing_adjustment_amount_original,post_closing_adjustment_amount, total_expenditure_amount,remaining_budget, 
			   created_load_id, created_date,budget_fiscal_year_id,agency_id,object_class_id ,department_id ,
			   agency_name,object_class_name,department_name,budget_code,budget_code_name,
			   agency_code,department_code,object_class_code,agency_short_name,department_short_name)
	SELECT budget_fiscal_year, fund_class_id, agency_history_id, department_history_id, budget_code_id, 
		object_class_history_id, adopted_amount as adopted_amount_original, coalesce(adopted_amount,0) as adopted_amount, current_budget_amount as current_budget_amount_original, coalesce(current_budget_amount,0) as current_budget_amount,
		pre_encumbered_amount as pre_encumbered_amount_original, coalesce(pre_encumbered_amount,0) as pre_encumbered_amount, encumbered_amount as encumbered_amount_original, coalesce(encumbered_amount,0) as encumbered_amount, 
		accrued_expense_amount as accrued_expense_amount_original, coalesce(accrued_expense_amount,0) as accrued_expense_amount,  cash_expense_amount as cash_expense_amount_original, coalesce(cash_expense_amount,0) as cash_expense_amount, 
		post_closing_adjustment_amount as post_closing_adjustment_amount_original, coalesce(post_closing_adjustment_amount,0) as post_closing_adjustment_amount,  total_expenditure_amount, remaining_budget,
		p_load_id_in, now()::timestamp,budget_fiscal_year_id,agency_id,object_class_id ,department_id ,
		agency_name,object_class_name,department_name,budget_code,budget_code_name,
		agency_code,department_code,object_class_code,agency_short_name,department_short_name
	FROM  etl.stg_budget 
	WHERE action_flag = 'I' AND budget_id IS NULL;		

	GET DIAGNOSTICS l_count = ROW_COUNT;
	
	IF l_count>0 THEN
	INSERT INTO etl.etl_data_load_verification(load_file_id,data_source_code,num_transactions,description)
	VALUES(p_load_file_id_in,'B',l_count,'# of records inserted into budget ');
	END IF;
	
	RAISE NOTICE 'BUDGET 2';

	

	
	
	RETURN 1;
	
EXCEPTION
	WHEN OTHERS THEN
	RAISE NOTICE 'Exception Occurred in processbudget';
	RAISE NOTICE 'SQL ERRROR % and Desc is %' ,SQLSTATE,SQLERRM;	

	RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION etl.processbudget(integer, bigint)
  OWNER TO gpadmin;
