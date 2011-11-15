COPY etl.ref_data_source FROM '/home/gpadmin/athiagarajan/NYC/ref_data_source.csv' CSV QUOTE as '"';

COPY etl.ref_column_mapping FROM '/home/gpadmin/athiagarajan/NYC/ref_column_mapping.csv' CSV QUOTE as '"';

COPY etl.ref_validation_rule FROM '/home/gpadmin/athiagarajan/NYC/ref_validation_rule.csv' CSV QUOTE as '"';
