DROP EXTERNAL TABLE etl.ext_stg_budget_feed;

CREATE EXTERNAL TABLE etl.ext_stg_budget_feed
(
  budget_fiscal_year character varying(10),
  fund_class_code character varying(4),
  agency_code character varying(4),
  department_code character varying(9),
  budget_code character varying(10),
  object_class_code character varying(4),
  adopted_amount character varying(60),
  current_budget_amount character varying(60),
  pre_encumbered_amount character varying(60),
  encumbered_amount character varying(60),
  accrued_expense_amount character varying(60),
  cash_expense_amount character varying(60),
  post_closing_adjustment_amount character varying(60),
  updated_date character varying(60),
  col15 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/BUDGET_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_budget_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_budget_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_budget_feed TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_coa_agency_feed;

CREATE EXTERNAL TABLE etl.ext_stg_coa_agency_feed
(
  agency_code character varying,
  agency_name character varying,
  col3 character varying,
  agency_short_name character varying,
  col5 character varying,
  col6 character varying,
  col7 character varying,
  col8 character varying,
  col9 character varying,
  col10 character varying,
  col11 character varying,
  col12 character varying,
  col13 character varying,
  col14 character varying,
  col15 character varying,
  col16 character varying,
  col17 character varying,
  col18 character varying,
  col19 character varying,
  col20 character varying,
  col21 character varying,
  col22 character varying,
  col23 character varying,
  col24 character varying,
  col25 character varying,
  col26 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/COA_agency_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_coa_agency_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_agency_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_agency_feed TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_coa_budget_code_feed;

CREATE EXTERNAL TABLE etl.ext_stg_coa_budget_code_feed
(
  fy character varying,
  fcls_cd character varying,
  fcls_nm character varying,
  dept_cd character varying,
  dept_nm character varying,
  func_cd character varying,
  func_nm character varying,
  func_attr_nm character varying,
  func_attr_sh_nm character varying,
  resp_ctr character varying,
  func_anlys_unit character varying,
  cntrl_cat character varying,
  local_svc_dist character varying,
  ua_fund_fl character varying,
  pyrl_dflt_fl character varying,
  bud_cat_a character varying,
  bud_cat_b character varying,
  bud_func character varying,
  dscr_ext character varying,
  tbl_last_dt character varying,
  func_attr_nm_up character varying,
  fin_plan_sav_fl character varying,
  col23 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/COA_budget_code_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_coa_budget_code_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_budget_code_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_budget_code_feed TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_coa_department_feed;

CREATE EXTERNAL TABLE etl.ext_stg_coa_department_feed
(
  agency_code character varying,
  fund_class_code character varying,
  fiscal_year character varying,
  department_code character varying,
  department_name character varying,
  col6 character varying,
  col7 character varying,
  department_short_name character varying,
  col9 character varying,
  col10 character varying,
  col11 character varying,
  col12 character varying,
  col13 character varying,
  col14 character varying,
  col15 character varying,
  col16 character varying,
  col17 character varying,
  col18 character varying,
  col19 character varying,
  col20 character varying,
  col21 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/COA_department_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_coa_department_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_department_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_department_feed TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_coa_expenditure_object_feed;

CREATE EXTERNAL TABLE etl.ext_stg_coa_expenditure_object_feed
(
  col1 character varying,
  fiscal_year character varying,
  expenditure_object_code character varying,
  expenditure_object_name character varying,
  col5 character varying,
  col6 character varying,
  col7 character varying,
  col8 character varying,
  col9 character varying,
  col10 character varying,
  col11 character varying,
  col12 character varying,
  col13 character varying,
  col14 character varying,
  col15 character varying,
  col16 character varying,
  col17 character varying,
  col18 character varying,
  col19 character varying,
  col20 character varying,
  col21 character varying,
  col22 character varying,
  col23 character varying,
  col24 character varying,
  col25 character varying,
  col26 character varying,
  col27 character varying,
  col28 character varying,
  col29 character varying,
  col30 character varying,
  col31 character varying,
  col32 character varying,
  col33 character varying,
  col34 character varying,
  col35 character varying,
  col36 character varying,
  col37 character varying,
  col38 character varying,
  col39 character varying,
  col40 character varying,
  col41 character varying,
  col42 character varying,
  col43 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/COA_expenditure_object_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_coa_expenditure_object_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_expenditure_object_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_expenditure_object_feed TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_coa_location_feed;

CREATE EXTERNAL TABLE etl.ext_stg_coa_location_feed
(
  agency_code character varying(20),
  location_code character varying(4),
  location_name character varying(60),
  location_short_name character varying(16),
  upper_case_name character varying(60),
  col6 character varying(100),
  col7 character varying(100),
  col8 character varying(100),
  col9 character varying(100),
  col10 character varying(100),
  col11 character varying(100),
  col12 character varying(100),
  col13 character varying(100),
  col14 character varying(100),
  col15 character varying(100),
  col16 character varying,
  col17 character varying(1)
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/COA_location_object_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_coa_location_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_location_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_location_feed TO webuser1;





DROP EXTERNAL TABLE etl.ext_stg_coa_object_class_feed;

CREATE EXTERNAL TABLE etl.ext_stg_coa_object_class_feed
(
  doc_dept_cd character varying,
  object_class_code character varying(3),
  object_class_name character varying(100),
  short_name character varying(100),
  act_fl character(1),
  effective_begin_date character varying(20),
  effective_end_date character varying(20),
  alw_bud_fl character(1),
  description character varying(100),
  cntac_cd character varying(100),
  object_class_name_up character varying(100),
  tbl_last_dt character varying(20),
  intr_cty_fl character(1),
  cntrc_pos_fl character(1),
  pyrl_typ character(1),
  dscr_ext character varying(100),
  rltd_ocls_cd character varying(3),
  col18 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/COA_object_class_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_coa_object_class_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_object_class_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_object_class_feed TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_coa_revenue_category_feed;

CREATE EXTERNAL TABLE etl.ext_stg_coa_revenue_category_feed
(
  doc_dept_cd character varying,
  rscat_cd character varying,
  rscat_nm character varying,
  rscat_sh_nm character varying,
  act_fl character varying,
  efbgn_dt character varying,
  efend_dt character varying,
  alw_bud_fl character varying,
  rscat_dscr character varying,
  cntac_cd character varying,
  rscat_nm_up character varying,
  tbl_last_dt character varying,
  col13 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/COA_revenue_category_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_coa_revenue_category_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_revenue_category_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_revenue_category_feed TO webuser1;




DROP EXTERNAL TABLE etl.ext_stg_coa_revenue_class_feed;

CREATE EXTERNAL TABLE etl.ext_stg_coa_revenue_class_feed
(
  doc_dept_cd character varying,
  rscls_cd character varying,
  rscls_nm character varying,
  rscls_sh_nm character varying,
  act_fl character varying,
  efbgn_dt character varying,
  efend_dt character varying,
  alw_bud_fl character varying,
  rscls_dscr character varying,
  cntac_cd character varying,
  rscls_nm_up character varying,
  tbl_last_dt character varying,
  col13 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/COA_revenue_class_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_coa_revenue_class_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_revenue_class_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_revenue_class_feed TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_coa_revenue_source_feed;

CREATE EXTERNAL TABLE etl.ext_stg_coa_revenue_source_feed
(
  doc_dept_cd character varying,
  fy character varying,
  rsrc_cd character varying,
  rsrc_nm character varying,
  rsrc_sh_nm character varying,
  act_fl character varying,
  efbgn_dt character varying,
  efend_dt character varying,
  alw_bud_fl character varying,
  oper_ind character varying,
  fasb_cls_ind character varying,
  fhwa_rev_cr_fl character varying,
  usetax_coll_fl character varying,
  rscls_cd character varying,
  rscat_cd character varying,
  rstyp_cd character varying,
  rsgrp_cd character varying,
  mjr_crtyp_cd character varying,
  mnr_crtyp_cd character varying,
  rsrc_dscr character varying,
  cntac_cd character varying,
  billu_rcvb_cd character varying,
  billu_rcvb_s character varying,
  bille_rcvb_cd character varying,
  bille_rcvb_s character varying,
  billu_rev_cd character varying,
  billu_rev_s character varying,
  collu_rev_cd character varying,
  collu_rev_s character varying,
  alw_bdebt_cd character varying,
  alw_bdebt_s character varying,
  bdebt_exp_obj character varying,
  bdebt_exp_obj_s character varying,
  bill_dps_cd character varying,
  bill_dps_s character varying,
  coll_dps_cd character varying,
  coll_dps_s character varying,
  nsf_ckcg_rsrc character varying,
  nsf_ckcg_rsrc_s character varying,
  intch_rsrc character varying,
  intch_rsrc_s character varying,
  lat_chrg_rsrc character varying,
  lat_chrg_rsrc_s character varying,
  cc_fee_rsrc character varying,
  cc_fee_rsrc_s character varying,
  cc_fee_obj character varying,
  cc_fee_obj_s character varying,
  fin_chrg_fee1_cd character varying,
  fin_chrg_fee2_cd character varying,
  fin_chrg_fee3_cd character varying,
  fin_chrg_fee4_cd character varying,
  fin_chrg_fee5_cd character varying,
  apy_intr_lat_fee character varying,
  apy_intr_admn_fee character varying,
  apy_intr_nsf_fee character varying,
  apy_intr_othr_fee character varying,
  elg_inct_fl character varying,
  rsrc_xfer_fl character varying,
  bill_vend_rfnd_cd character varying,
  bill_vend_rfnd_s character varying,
  uern_rcvb_wo_cd character varying,
  uern_rcvb_wo_s character varying,
  dps_rcvb_wo_cd character varying,
  dps_rcvb_wo_s character varying,
  uern_rev_wo_cd character varying,
  uern_rev_wo_s character varying,
  dps_wo_cd character varying,
  dps_wo_s character varying,
  vrfnd_rcvb_wo_cd character varying,
  vrfnd_rcvb_wo_s character varying,
  vrfnd_wo_cd character varying,
  vrfnd_wo_s character varying,
  ernrev_to_coll_cd character varying,
  ernrev_to_coll_s character varying,
  vrfnd_to_coll_cd character varying,
  vrfnd_to_coll_s character varying,
  vend_rha_cd character varying,
  vend_rha_s character varying,
  rs_opay_cd character varying,
  rs_opay_s character varying,
  urs_opay_cd character varying,
  urs_opay_s character varying,
  bill_dps_rec_cd character varying,
  bill_dps_rec_s character varying,
  earn_rcvb_cd character varying,
  earn_rcvb_s character varying,
  rsrc_nm_up character varying,
  rsrc_sh_nm_up character varying,
  fin_fee_ov_fl character varying,
  apy_intr_ov character varying,
  tbl_last_dt character varying,
  ext_rep_nm character varying,
  fund_cls character varying,
  fund_cls_nm character varying,
  grnt_id character varying,
  bill_lag_dy character varying,
  bill_freq character varying,
  bill_fy_strt_mnth character varying,
  bill_fy_strt_dy character varying,
  fed_agcy_cd character varying,
  fed_agcy_sfx character varying,
  fed_nm character varying,
  ext_rep_num character varying,
  dscr_ext character varying,
  srsrc_req character varying,
  col106 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/COA_revenue_source_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_coa_revenue_source_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_revenue_source_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_coa_revenue_source_feed TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_con_data_feed;

CREATE EXTERNAL TABLE etl.ext_stg_con_data_feed
(
  record_type character(1),
  doc_cd character varying(8),
  doc_dept_cd character varying(20),
  doc_id character varying(20),
  doc_vers_no character varying,
  col6 character varying(100),
  col7 character varying(100),
  col8 character varying(100),
  col9 character varying(100),
  col10 character varying(100),
  col11 character varying,
  col12 character varying(100),
  col13 character varying(100),
  col14 character varying,
  col15 character varying(100),
  col16 character varying(100),
  col17 character varying(100),
  col18 character varying(255),
  col19 character varying(255),
  col20 character varying(100),
  col21 character varying(100),
  col22 character varying(100),
  col23 character varying(100),
  col24 character varying,
  col25 character varying(100),
  col26 character varying(100),
  col27 character varying(100),
  col28 character varying(100),
  col29 character varying(100),
  col30 character varying(100),
  col31 character varying,
  col32 character varying,
  col33 character varying(500),
  col34 character varying(100),
  col35 character varying(100),
  col36 character varying(100),
  col37 character varying(100),
  col38 character varying(100),
  col39 character varying(255),
  col40 character varying(100),
  col41 character varying(100),
  col42 character varying(100),
  col43 character varying(100),
  col44 character varying(100),
  col45 character varying(100),
  col46 character varying(100),
  col47 character varying(100),
  col48 character varying(100),
  col49 character varying(100),
  col50 character varying(100),
  col51 character varying(100),
  col52 character varying(100),
  col53 character varying(100),
  col54 character varying(100),
  col55 character varying(100),
  col56 character varying(100),
  col57 character varying(100),
  col58 character varying(100),
  col59 character varying(100),
  col60 character varying(100),
  col61 character varying(100),
  col62 character varying(100),
  col63 character varying(100),
  col64 character varying(100),
  col65 character varying(100),
  col66 character varying(100),
  col67 character varying(100),
  col68 character varying(100),
  col69 character varying(100),
  col70 character varying,
  col71 character varying(100),
  col72 character varying,
  col73 character varying,
  col74 character varying,
  col75 character varying,
  col76 character varying,
  col77 character varying,
  col78 character varying(100),
  col79 character varying(100),
  col80 character varying(100),
  col81 character varying(100),
  col82 character varying(100),
  col83 character varying(100),
  col84 character varying(100),
  col85 character varying(100),
  col86 character varying(100),
  col87 character varying(100),
  col88 character varying(100),
  col89 character varying(100),
  col90 character varying(100),
  col91 character varying,
  col92 character varying(100),
  col93 character varying(100),
  col94 character varying(100),
  col95 character varying,
  col96 character varying(100),
  col97 character varying(100),
  col98 character varying(100),
  col99 character varying(100),
  col100 character varying(100),
  col101 character varying,
  col102 character varying(100),
  col103 character varying,
  col104 character varying(100),
  col105 character varying(100),
  col106 character varying(100),
  col107 character varying(100),
  col108 character varying(100),
  col109 character varying(100),
  col110 character varying(100),
  col111 character varying(100),
  col112 character varying(100),
  col113 character varying(100),
  col114 character varying(100),
  col115 character varying(100),
  col116 character varying(100),
  col117 character varying(100),
  col118 character varying(100),
  col119 character varying(100),
  col120 character varying(100),
  col121 character varying(100),
  col122 character varying(100),
  col123 character varying(100),
  col124 character varying(100),
  col125 character varying(100),
  col126 character varying(100),
  col127 character varying(100),
  col128 character varying(100),
  col129 character varying(100),
  col130 character varying(100),
  col131 character varying(100),
  col132 character varying(100),
  col133 character varying(100),
  col134 character varying(100),
  col135 character varying(100),
  col136 character varying(100),
  col137 character varying(100),
  col138 character varying(100),
  col139 character varying(100),
  col140 character varying(100),
  col141 character varying(100),
  col142 character varying(100),
  col143 character varying(100),
  col144 character varying(100),
  col145 character varying(100),
  col146 character varying(100),
  col147 character varying(100),
  col148 character varying(100),
  col149 character varying(100),
  col150 character varying(100),
  col151 character varying(100),
  col152 character varying(100),
  col153 character varying(100),
  col154 character varying(100),
  col155 character varying(100),
  col156 character varying(100),
  col157 character varying(100),
  col158 character varying(100),
  col159 character varying(100),
  col160 character varying(100),
  col161 character varying(100),
  col162 character varying(100),
  col163 character varying(100),
  col164 character varying(100),
  col165 character varying(100),
  col166 character varying(100),
  col167 character varying(100),
  col168 character varying(100),
  col169 character varying(100),
  col170 character varying(100),
  col171 character varying(100),
  col172 character varying(100)
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/CON_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_con_data_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_con_data_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_con_data_feed TO webuser1;


DROP EXTERNAL TABLE etl.ext_stg_fms_data_feed;

CREATE EXTERNAL TABLE etl.ext_stg_fms_data_feed
(
  record_type character(1),
  doc_cd character varying(8),
  doc_dept_cd character varying(4),
  doc_id character varying(20),
  doc_vers_no character varying,
  col6 character varying(100),
  col7 character varying(100),
  col8 character varying(100),
  col9 character varying(250),
  col10 character varying(100),
  col11 character varying(100),
  col12 character varying(100),
  col13 character varying(100),
  col14 character varying(100),
  col15 character varying(100),
  col16 character varying(100),
  col17 character varying(100),
  col18 character varying(100),
  col19 character varying(100),
  col20 character varying(100),
  col21 character varying(100),
  col22 character varying(100),
  col23 character varying(100),
  col24 character varying(100),
  col25 character varying(100),
  col26 character varying(100),
  col27 character varying(100),
  col28 character varying(100),
  col29 character varying(100),
  col30 character varying(100),
  col31 character varying(100),
  col32 character varying(100),
  col33 character varying(100),
  col34 character varying(100),
  col35 character varying(100),
  col36 character varying(100),
  col37 character varying(100),
  col38 character varying(100),
  col39 character varying(100),
  col40 character varying(100),
  col41 character varying(100),
  col42 character varying(100),
  col43 character varying(100),
  col44 character varying(100),
  col45 character varying(100),
  col46 character varying(100),
  col47 character varying(100),
  col48 character varying(100),
  col49 character varying(100)
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/FMS_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_fms_data_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_fms_data_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_fms_data_feed TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_fmsv_data_feed;

CREATE EXTERNAL TABLE etl.ext_stg_fmsv_data_feed
(
  record_type character(1),
  doc_dept_cd character varying,
  vend_cust_cd character varying,
  bus_typ character varying,
  bus_typ_sta character varying,
  min_typ character varying,
  disp_cert_strt_dt character varying,
  cert_end_dt character varying,
  init_dt character varying,
  col10 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/FMSV_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_fmsv_data_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_fmsv_data_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_fmsv_data_feed TO webuser1;


DROP EXTERNAL TABLE etl.ext_stg_funding_class;

CREATE EXTERNAL TABLE etl.ext_stg_funding_class
(
  doc_dept_cd character varying,
  fy character varying,
  funding_class_code character varying,
  funding_class_name character varying,
  short_name character varying,
  category_name character varying,
  cty_fund_fl character varying,
  intr_cty_fl character varying,
  fund_aloc_req_fl character varying,
  tbl_last_dt character varying,
  ams_row_vers_no character varying,
  rsfcls_nm_up character varying,
  fund_category character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/COA_funding_class_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_funding_class OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_funding_class TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_funding_class TO webuser1;


DROP EXTERNAL TABLE etl.ext_stg_mag_data_feed;

CREATE EXTERNAL TABLE etl.ext_stg_mag_data_feed
(
  record_type character(1),
  doc_cd character varying(8),
  doc_dept_cd character varying(20),
  doc_id character varying(20),
  doc_vers_no character varying,
  col6 character varying(100),
  col7 character varying(100),
  col8 character varying(100),
  col9 character varying(100),
  col10 character varying(100),
  col11 character varying,
  col12 character varying(100),
  col13 character varying,
  col14 character varying(100),
  col15 character varying(100),
  col16 character varying(255),
  col17 character varying(100),
  col18 character varying(100),
  col19 character varying(100),
  col20 character varying(255),
  col21 character varying(100),
  col22 character varying(100),
  col23 character varying(100),
  col24 character varying(100),
  col25 character varying(100),
  col26 character varying(100),
  col27 character varying(100),
  col28 character varying(100),
  col29 character varying(100),
  col30 character varying(100),
  col31 character varying(100),
  col32 character varying,
  col33 character varying,
  col34 character varying(100),
  col35 character varying(100),
  col36 character varying(100),
  col37 character varying(100),
  col38 character varying(100),
  col39 character varying(100),
  col40 character varying(255),
  col41 character varying(100),
  col42 character varying(100),
  col43 character varying(100),
  col44 character varying(100),
  col45 character varying(100),
  col46 character varying,
  col47 character varying(100),
  col48 character varying(100),
  col49 character varying(100),
  col50 character varying(100),
  col51 character varying(100),
  col52 character varying(100),
  col53 character varying(100),
  col54 character varying(100),
  col55 character varying(100),
  col56 character varying(100),
  col57 character varying,
  col58 character varying(100),
  col59 character varying,
  col60 character varying,
  col61 character varying,
  col62 character varying,
  col63 character varying,
  col64 character varying,
  col65 character varying(100),
  col66 character varying(100),
  col67 character varying(100),
  col68 character varying(100),
  col69 character varying(100),
  col70 character varying(100),
  col71 character varying(100),
  col72 character varying,
  col73 character varying(100),
  col74 character varying(100),
  col75 character varying(100),
  col76 character varying(100),
  col77 character varying(100),
  col78 character varying,
  col79 character varying(100),
  col80 character varying,
  col81 character varying(100),
  col82 character varying(100),
  col83 character varying(100),
  col84 character varying(100),
  col85 character varying(100),
  col86 character varying(100),
  col87 character varying(100),
  col88 character varying(100),
  col89 character varying(100),
  col90 character varying(100),
  col91 character varying(100),
  col92 character varying(100),
  col93 character varying(100),
  col94 character varying(100),
  col95 character varying(100),
  col96 character varying(100),
  col97 character varying(100),
  col98 character varying(100),
  col99 character varying(100),
  col100 character varying(100),
  col101 character varying(100),
  col102 character varying(100),
  col103 character varying(100),
  col104 character varying(100),
  col105 character varying(100),
  col106 character varying(100),
  col107 character varying(100),
  col108 character varying(100),
  col109 character varying(100)
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/MAG_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_mag_data_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_mag_data_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_mag_data_feed TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_oaisis_feed;

CREATE EXTERNAL TABLE etl.ext_stg_oaisis_feed
(
  con_trans_code character varying,
  con_trans_ad_code character varying,
  con_no character varying,
  con_par_trans_code character varying,
  con_par_ad_code character varying,
  con_par_reg_num character varying,
  con_cur_encumbrance character varying,
  con_original_max character varying,
  con_rev_max character varying,
  vc_legal_name character varying,
  con_vc_code character varying,
  con_purpose character varying,
  submitting_agency_desc character varying,
  submitting_agency_code character varying,
  awarding_agency_desc character varying,
  awarding_agency_code character varying,
  cont_desc character varying,
  cont_code character varying,
  am_desc character varying,
  am_code character varying,
  con_term_from character varying,
  con_term_to character varying,
  con_rev_start_dt character varying,
  con_rev_end_dt character varying,
  con_cif_received_date character varying,
  con_pin character varying,
  con_internal_pin character varying,
  con_batch_suffix character varying,
  con_version character varying,
  original_or_modified character varying,
  award_category_code character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/OAISIS_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_oaisis_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_oaisis_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_oaisis_feed TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_pension_fund;

CREATE EXTERNAL TABLE etl.ext_stg_pension_fund
(
  doc_dept_cd character varying,
  doc_id character varying,
  doc_vers_no character varying,
  chk_amt character varying,
  chk_amt_fixed character varying,
  chk_amt_variable character varying,
  fcls_cd character varying,
  appr_cd character varying,
  appr_desc character varying,
  obj_cd character varying,
  obj_desc character varying,
  chk_eft_rec_dt character varying,
  chk_status character varying,
  doc_bfy integer,
  doc_cd character varying,
  purchase_order character varying,
  payee_nm character varying,
  payee_id character varying,
  payee_addr1 character varying,
  payee_addr2 character varying,
  payee_city character varying,
  payee_state character varying,
  payee_zip character varying(11),
  reserved1 character varying(60),
  reserved2 character varying(60),
  reserved3 character varying(60),
  reserved4 character varying(60),
  reserved5 character varying(60),
  reserved6 character varying(60),
  reserved7 character varying(60),
  reserved8 character varying(60),
  reserved9 character varying(60),
  reserved10 character varying(60)
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/police_pension_fund.txt'
)
 FORMAT 'text' (delimiter ',' null '\\N' escape '"' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_pension_fund OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_pension_fund TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_pension_fund TO webuser1;


DROP EXTERNAL TABLE etl.ext_stg_pms_data_feed;

CREATE EXTERNAL TABLE etl.ext_stg_pms_data_feed
(
  pay_cycle_code character(1),
  pay_date character varying,
  employee_number character varying,
  payroll_number character varying,
  job_sequence_number character varying,
  agency_code character varying,
  agency_start_date character varying,
  fiscal_year character varying,
  orig_pay_cycle_code character(1),
  orig_pay_date character varying,
  pay_frequency character varying,
  last_name character varying,
  department_code character varying,
  annual_salary character varying,
  amount_basis character varying,
  base_pay character varying,
  overtime_pay character varying,
  other_payments character varying,
  gross_pay character varying,
  civil_service_code character varying,
  civil_service_level character varying,
  civil_service_suffix character varying,
  civil_service_title character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/PMS_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_pms_data_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_pms_data_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_pms_data_feed TO webuser1;


DROP EXTERNAL TABLE etl.ext_stg_pms_summary_data_feed;

CREATE EXTERNAL TABLE etl.ext_stg_pms_summary_data_feed
(
  pay_cycle character varying(20),
  pay_date character varying(10),
  pyrl_no character varying(20),
  pyrl_desc character varying(50),
  uoa character varying(20),
  uoa_name character varying(100),
  fy character varying,
  "object" character varying(4),
  object_desc character varying(40),
  agency character varying(20),
  agency_name character varying(100),
  bud_code character varying(10),
  bud_code_desc character varying(100),
  total_amt character varying,
  col15 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/PMS_summary_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_pms_summary_data_feed OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_pms_summary_data_feed TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_pms_summary_data_feed TO webuser1;


DROP EXTERNAL TABLE etl.ext_stg_revenue;

CREATE EXTERNAL TABLE etl.ext_stg_revenue
(
  doc_rec_dt character varying(50),
  per_dc character(2),
  fy_dc character varying(11),
  bfy character varying(11),
  fqtr character varying(11),
  evnt_cat_id character varying(4),
  evnt_typ_id character varying(4),
  bank_acct_cd character varying(4),
  pstng_pr_typ character varying(1),
  pstng_cd_id character varying(4),
  drcr_ind character varying(1),
  ln_func_cd character varying(11),
  pstng_am character varying(25),
  incr_dcrs_ind character varying(1),
  run_tmdt character varying(50),
  fund_cd character varying(4),
  sfund_cd character varying(4),
  bsa_cd character varying(4),
  sbsa_cd character varying(4),
  bsa_typ_ind character varying(11),
  obj_cd character varying(4),
  sobj_cd character varying(4),
  rsrc_cd character varying(5),
  srsrc_cd character varying(5),
  govt_brn_cd character varying(4),
  cab_cd character varying(4),
  dept_cd character varying(4),
  div_cd character varying(4),
  gp_cd character varying(4),
  sect_cd character varying(4),
  dstc_cd character varying(4),
  bur_cd character varying(4),
  unit_cd character varying(8),
  sunit_cd character varying(4),
  mjr_prog_cd character varying(6),
  prog_cd character varying(10),
  phase_cd character varying(6),
  task_ord_cd character varying(6),
  task_cd character varying(4),
  stask_cd character varying(4),
  ppc_cd character varying(6),
  fprfl_cd character varying(6),
  fline_cd character varying(20),
  fprty_cd character varying(20),
  appr_cd character varying(9),
  actv_cd character varying(10),
  sactv_cd character varying(4),
  func_cd character varying(10),
  sfunc_cd character varying(4),
  rpt_cd character varying(15),
  srpt_cd character varying(4),
  dobj_cd character varying(5),
  drsrc_cd character varying(4),
  loc_cd character varying(4),
  sloc_cd character varying(4),
  ig_fund_cd character varying(4),
  ig_sfund_cd character varying(4),
  ig_dept_cd character varying(4),
  fcls_cd character varying(4),
  fcat_cd character varying(4),
  ftyp_cd character varying(4),
  fgrp_cd character varying(4),
  cafrfgrp_cd character varying(4),
  cafrftyp_cd character varying(4),
  bscl_cd character varying(4),
  bsct_cd character varying(4),
  bst_cd character varying(4),
  bsg_cd character varying(4),
  cmjrbgrp_cd character varying(4),
  cmnrbgrp_cd character varying(4),
  bsa_ov_fl character(1),
  ocls_cd character varying(4),
  ocat_cd character varying(4),
  otyp_cd character varying(4),
  ogrp_cd character varying(4),
  mjr_cetyp_cd character varying(4),
  mnr_cetyp_cd character varying(4),
  rscls_cd character varying(4),
  rscat_cd character varying(4),
  rstyp_cd character varying(4),
  rsgrp_cd character varying(4),
  mjr_crtyp_cd character varying(4),
  mnr_crtyp_cd character varying(4),
  apcls_cd character varying(4),
  apcat_cd character varying(4),
  aptyp_cd character varying(4),
  apgrp_cd character varying(4),
  lcls_cd character varying(3),
  lcat_cd character varying(4),
  ltyp_cd character varying(4),
  cnty_cd character varying(5),
  acls_cd character varying(6),
  acat_cd character varying(4),
  atyp_cd character varying(10),
  agrp_cd character varying(4),
  caunit_cd character varying(4),
  mjr_catyp_cd character varying(4),
  mnr_catyp_cd character varying(4),
  fncls_cd character varying(4),
  fncat_cd character varying(4),
  fntyp_cd character varying(4),
  fngrp_cd character varying(4),
  rcls_cd character varying(4),
  rcat_cd character varying(9),
  rtyp_cd character varying(4),
  rgrp_cd character varying(4),
  docls_cd character varying(4),
  docat_cd character varying(4),
  dotyp_cd character varying(4),
  dogrp_cd character varying(4),
  drscls_cd character varying(4),
  drscat_cd character varying(4),
  drstyp_cd character varying(4),
  drsgrp_cd character varying(4),
  mjr_pcls_cd character varying(4),
  mjr_pcat_cd character varying(4),
  mjr_ptyp_cd character varying(4),
  mjr_pgrp_cd character varying(4),
  pcls_cd character varying(4),
  pcat_cd character varying(4),
  ptyp_cd character varying(4),
  pgrp_cd character varying(4),
  doc_cat character varying(8),
  doc_typ character varying(8),
  doc_cd character varying(8),
  doc_dept_cd character varying(4),
  doc_id character varying(20),
  doc_vers_no character varying(11),
  doc_func_cd character varying(11),
  doc_vend_ln_no character varying(11),
  doc_unit_cd character varying(8),
  doc_comm_ln_no character varying(11),
  doc_actg_ln_no character varying(11),
  doc_pstng_ln_no character varying(11),
  doc_last_usid character varying(20),
  rfed_doc_cd character varying(8),
  rfed_doc_dept_cd character varying(4),
  rfed_doc_id character varying(20),
  rfed_vend_ln_no character varying(11),
  rfed_comm_ln_no character varying(11),
  rfed_actg_ln_no character varying(11),
  rfed_pstng_ln_no character varying(11),
  rf_typ character varying(11),
  stpf_cd character varying(2),
  assoc_inv_no character varying(30),
  assoc_inv_ln_no character varying(11),
  assoc_inv_dt character varying(50),
  vend_cust_cd character varying(20),
  vend_cust_ind character varying(1),
  lgl_nm character varying(60),
  bpro_cd character varying(5),
  actg_ln_dscr character varying(100),
  misc3 character varying(20),
  svc_frm_dt character varying(50),
  svc_to_dt character varying(50),
  whse_cd character varying(8),
  comm_cd character varying(14),
  stk_itm_sfx character varying(3),
  reas_cd character varying(8),
  tin character varying(9),
  tin_typ character varying(1),
  chk_eft_no character varying(15),
  reclass_ind_fl character varying(11),
  pscd_clos_cl_cd character varying(2),
  pscd_clos_cl_nm character varying(45),
  col character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/Revenue_feed.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_revenue OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_revenue TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_revenue TO webuser1;



DROP EXTERNAL TABLE etl.ext_stg_revenue_budget;

CREATE EXTERNAL TABLE etl.ext_stg_revenue_budget
(
  bfy character varying,
  fcls_cd character varying,
  dept_cd character varying,
  func_cd character varying,
  revenue_source character varying,
  adpt_am character varying,
  curr_bud_am character varying,
  col8 character varying,
  col9 character varying
)
 LOCATION (
    'gpfdist://mdw1:8081/datafiles/revenue_budget.txt'
)
 FORMAT 'text' (delimiter '|' null '\\N' escape '~' fill missing fields)
ENCODING 'UTF8';
ALTER TABLE etl.ext_stg_revenue_budget OWNER TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_revenue_budget TO gpadmin;
GRANT SELECT ON TABLE etl.ext_stg_revenue_budget TO webuser1;