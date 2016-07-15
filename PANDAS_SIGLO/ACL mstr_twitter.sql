/* Formatted on 30/01/2014 10:53:21 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
BEGIN
	DBMS_NETWORK_ACL_ADMIN.drop_acl (acl => 'mstr_twitter.xml');
END;
/

BEGIN
	--DBMS_NETWORK_ACL_ADMIN.drop_acl (acl => 'harvest_harvest.xml');
	DBMS_NETWORK_ACL_ADMIN.create_acl (acl => 'mstr_twitter.xml'
																		,description => 'Twitter HTTP Access'
																		,principal => 'MSTR'
																		,is_grant => TRUE
																		,PRIVILEGE => 'connect'
																		,start_date => NULL
																		,end_date => NULL);
	DBMS_NETWORK_ACL_ADMIN.add_privilege (acl => 'mstr_twitter.xml'
																			 ,principal => 'MSTR'
																			 ,is_grant => TRUE
																			 ,PRIVILEGE => 'resolve'
																			 ,start_date => NULL
																			 ,end_date => NULL);
	DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_twitter.xml', HOST => '*.twitter.com');
	DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_twitter.xml', HOST => 'proxy-hospitales.sas.junta-andalucia.es');
	--10.234.23.117
	COMMIT;
END;
/