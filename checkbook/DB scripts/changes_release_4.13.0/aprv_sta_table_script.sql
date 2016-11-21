-- Table used for mapping 'aprv_sta' 

DROP TABLE IF EXISTS subcontract_approval_status;

CREATE TABLE subcontract_approval_status 
(
aprv_sta_id smallint,
aprv_sta_value character varying,
sort_order smallint
)DISTRIBUTED BY(aprv_sta_id);


INSERT INTO subcontract_approval_status(
	aprv_sta_id, aprv_sta_value, sort_order
)VALUES(6,'No Subcontract Information Submitted',1);


INSERT INTO subcontract_approval_status(
	aprv_sta_id, aprv_sta_value, sort_order
)VALUES(1, 'No Subcontract Payments Submitted', 2);

INSERT INTO subcontract_approval_status(
	aprv_sta_id, aprv_sta_value, sort_order
)VALUES(4, 'ACCO Approved Sub Vendor', 3);

INSERT INTO subcontract_approval_status(
	aprv_sta_id, aprv_sta_value, sort_order
)VALUES(3, 'ACCO Reviewing Sub Vendor', 4);

INSERT INTO subcontract_approval_status(
	aprv_sta_id, aprv_sta_value, sort_order
)VALUES(2, 'ACCO Rejected Sub Vendor', 5);

INSERT INTO subcontract_approval_status(
	aprv_sta_id, aprv_sta_value, sort_order
)VALUES(5, 'ACCO Canceled Sub Vendor', 6);

GRANT ALL ON TABLE subcontract_approval_status TO gpadmin;
GRANT SELECT ON TABLE subcontract_approval_status TO webuser1;
