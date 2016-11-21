
DROP TABLE IF EXISTS subcontract_status_by_prime_contract_id;
            CREATE TABLE subcontract_status_by_prime_contract_id (
            original_agreement_id bigint,
            contract_number varchar,
            description character varying(256),
            agency_id integer,
            agency_name character varying,
            prime_vendor_type character varying,
            prime_sub_vendor_code character varying,
            prime_sub_vendor_code_by_type character varying,
            prime_sub_minority_type_id character varying,
            prime_sub_vendor_minority_type_by_name_code character varying,
            prime_vendor_id integer,
            prime_vendor_code character varying,
            prime_vendor_name character varying,
            prime_minority_type_id smallint,
            prime_minority_type_name character varying(50),
            sub_vendor_type character varying,
            sub_vendor_id integer,
            sub_vendor_code character varying,
            sub_vendor_name character varying,
            sub_minority_type_id smallint,
            sub_minority_type_name character varying(50),
            sub_contract_id character varying(20),
            aprv_sta_id smallint,
            aprv_sta_value character varying(50),
            starting_year_id smallint,
            ending_year_id smallint,
            effective_begin_year_id smallint,
            effective_end_year_id smallint,
            sort_order smallint,
            latest_flag char(1),
            award_method_id smallint,
            award_method_name character varying,
            industry_type_id smallint,
            industry_type_name character varying(50),
            award_size_id smallint
            )
            DISTRIBUTED BY (original_agreement_id);

INSERT INTO subcontract_status_by_prime_contract_id
			(
			original_agreement_id,
			contract_number,
			description,
			agency_id,
			agency_name,
			prime_vendor_type,
			prime_vendor_id,
			prime_vendor_name,
			prime_minority_type_id,
			prime_minority_type_name,
			sub_vendor_type,
			sub_vendor_id,
			sub_vendor_name,
			sub_minority_type_id,
			sub_minority_type_name,
			sub_contract_id,
			aprv_sta_id,
			aprv_sta_value,
			starting_year_id,
			ending_year_id,
			effective_begin_year_id,
			effective_end_year_id,
			sort_order,
			latest_flag,
			prime_sub_vendor_minority_type_by_name_code,
			award_method_id,
			award_method_name,
			industry_type_id,
			industry_type_name,
			award_size_id
			)
			SELECT
			a.original_agreement_id,
			a.contract_number,
			a.description,
			a.agency_id,
			a.agency_name,
			a.vendor_type as prime_vendor_type,
			a.vendor_id as prime_vendor_id,
			a.vendor_name as prime_vendor_name,
			a.minority_type_id as prime_minority_type_id,
			CASE
				WHEN a.minority_type_id = 2 THEN 'Black American'
				WHEN a.minority_type_id = 3 THEN 'Hispanic American'
				WHEN a.minority_type_id IN (4,5) THEN 'Asian American'
				WHEN a.minority_type_id = 7 THEN 'Non-M/WBE'
				WHEN a.minority_type_id = 9 THEN 'Women'
				WHEN a.minority_type_id = 11 THEN 'Individuals and Others'
			END as prime_minority_type_name,
			b.vendor_type as sub_vendor_type,
			b.vendor_id as sub_vendor_id,
			b.vendor_name as sub_vendor_name,
			b.minority_type_id as sub_minority_type_id,
			CASE
				WHEN b.minority_type_id = 2 THEN 'Black American'
				WHEN b.minority_type_id = 3 THEN 'Hispanic American'
				WHEN b.minority_type_id IN (4,5) THEN 'Asian American'
				WHEN b.minority_type_id = 7 THEN 'Non-M/WBE'
				WHEN b.minority_type_id = 9 THEN 'Women'
				WHEN b.minority_type_id = 11 THEN 'Individuals and Others'
			END as sub_minority_type_name,
			CASE WHEN b.sub_contract_id is NULL OR b.sub_contract_id = '' THEN 'NOT PROVIDED' ELSE b.sub_contract_id END as sub_contract_id,
			c.aprv_sta_id,
			c.aprv_sta_value,
			a.starting_year_id,
			a.ending_year_id,
			a.effective_begin_year_id,
			a.effective_end_year_id,
			c.sort_order,
			a.latest_flag,
			a.vendor_type||':'||a.minority_type_id||':'||CAST(vendor.vendor_customer_code as text)||':'||a.vendor_name ||
			(CASE
			    WHEN b.vendor_name IS NULL THEN ''
			    ELSE ','||b.vendor_type||':'||b.minority_type_id||':'||CAST(subvendor.vendor_customer_code as text)||':'||b.vendor_name
			END) AS prime_sub_vendor_minority_type_by_name_code,
			award_method_id,
			award_method_name,
			industry_type_id,
			industry_type_name,
			award_size_id
			FROM all_agreement_transactions a
			LEFT JOIN
			(
				SELECT a.original_agreement_id, a.contract_number, a.vendor_name, a.vendor_type, a.vendor_id,a.aprv_sta as aprv_sta_id, a.minority_type_id, a.sub_contract_id
				FROM all_agreement_transactions a
				WHERE (a.is_prime_or_sub = 'S' AND a.latest_flag = 'Y')
			) b on b.contract_number = a.contract_number
			LEFT JOIN subcontract_approval_status c ON c.aprv_sta_id = COALESCE(b.aprv_sta_id,6)
			JOIN ref_document_code rd ON rd.document_code_id = a.document_code_id
			JOIN
			(
				SELECT v.vendor_id, v.legal_name, v.vendor_customer_code FROM vendor v
				JOIN (SELECT vendor_id, MAX(vendor_history_id) AS vendor_history_id FROM vendor_history WHERE miscellaneous_vendor_flag::BIT = 0 ::BIT  GROUP BY 1) vh ON v.vendor_id = vh.vendor_id
			) vendor on vendor.vendor_id = a.vendor_id
			LEFT JOIN
			(
				SELECT v.vendor_id, v.legal_name, v.vendor_customer_code FROM subvendor v
				JOIN (SELECT vendor_id, MAX(vendor_history_id) AS vendor_history_id FROM subvendor_history GROUP BY 1) vh ON v.vendor_id = vh.vendor_id
			) subvendor on subvendor.vendor_id = b.vendor_id
			WHERE (a.is_prime_or_sub = 'P' 
				--AND a.latest_flag = 'Y' 
				AND a.scntrc_status = 2 
				AND rd.document_code IN ('CTA1','CT1','CT2'));


			UPDATE subcontract_status_by_prime_contract_id tbl1
			SET prime_sub_vendor_code = tbl2.prime_sub_vendor_code,
			prime_sub_vendor_code_by_type = tbl2.prime_sub_vendor_code_by_type,
			prime_vendor_code = tbl2.prime_vendor_code,
			sub_vendor_code = tbl2.sub_vendor_code,
			prime_sub_minority_type_id = tbl2.prime_sub_minority_type_id
			-- SELECT *
			FROM
			(
				SELECT
				contract_number,
				prime_vendor_id,
				COALESCE(sub_vendor_id, 0) as sub_vendor_id,
				b.vendor_customer_code as prime_vendor_code,
				c.vendor_customer_code as sub_vendor_code,
				CASE
					WHEN c.vendor_customer_code IS NULL THEN CAST(b.vendor_customer_code as text)
					ELSE CAST(b.vendor_customer_code as text) || ',' || CAST(c.vendor_customer_code as text)
				END AS prime_sub_vendor_code,
				CASE
					WHEN a.prime_minority_type_id IN (7,11) THEN 'P:'||CAST(b.vendor_customer_code as text)
					ELSE 'PM:'||CAST(b.vendor_customer_code as text)
				END ||
				CASE
					WHEN a.sub_minority_type_id IS NULL THEN ''
					WHEN a.sub_minority_type_id IN (7,11) THEN ',S:'||CAST(c.vendor_customer_code as text)
					ELSE ',SM:'||CAST(c.vendor_customer_code as text)
				END AS prime_sub_vendor_code_by_type,
				CASE
					WHEN a.prime_minority_type_id IN (7,11) THEN 'P:'||a.prime_minority_type_id
					ELSE 'PM:'||a.prime_minority_type_id
				END ||
				CASE
					WHEN a.sub_minority_type_id IS NULL THEN ''
					WHEN a.sub_minority_type_id IN (7,11) THEN ',S:'||a.sub_minority_type_id
					ELSE ',SM:'||a.sub_minority_type_id
				END AS prime_sub_minority_type_id
				FROM subcontract_status_by_prime_contract_id a
				JOIN
				(
					SELECT v.vendor_id, v.legal_name, v.vendor_customer_code FROM vendor v
					JOIN (SELECT vendor_id, MAX(vendor_history_id) AS vendor_history_id FROM vendor_history WHERE miscellaneous_vendor_flag::BIT = 0 ::BIT  GROUP BY 1) vh ON v.vendor_id = vh.vendor_id
				) b on b.vendor_id = a.prime_vendor_id
				LEFT JOIN
				(
					SELECT v.vendor_id, v.legal_name, v.vendor_customer_code FROM subvendor v
					JOIN (SELECT vendor_id, MAX(vendor_history_id) AS vendor_history_id FROM subvendor_history GROUP BY 1) vh ON v.vendor_id = vh.vendor_id
				) c on c.vendor_id = a.sub_vendor_id
			) tbl2
			WHERE tbl2.contract_number = tbl1.contract_number
			AND tbl2.prime_vendor_id = tbl1.prime_vendor_id
			AND tbl2.sub_vendor_id = COALESCE(tbl1.sub_vendor_id, 0);



select etl.grantaccess('webuser1','SELECT');
