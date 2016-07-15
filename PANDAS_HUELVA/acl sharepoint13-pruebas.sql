/* Formatted on 03/06/2013 10:22:05 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_NETWORK_ACL_ADMIN.drop_acl (acl => 'mstr_sharepoint13-pruebas.xml');
END;
/

--login.microsoftonline.com

BEGIN
   --DBMS_NETWORK_ACL_ADMIN.drop_acl (acl => 'harvest_harvest.xml');
   DBMS_NETWORK_ACL_ADMIN.create_acl (acl           => 'mstr_sharepoint13-pruebas.xml',
                                      description   => 'mstr_sharepoint13-pruebas HTTP Access',
                                      principal     => 'MSTR',
                                      is_grant      => TRUE,
                                      PRIVILEGE     => 'connect',
                                      start_date    => NULL,
                                      end_date      => NULL);
   DBMS_NETWORK_ACL_ADMIN.add_privilege (acl          => 'mstr_sharepoint13-pruebas.xml',
                                         principal    => 'MSTR',
                                         is_grant     => TRUE,
                                         PRIVILEGE    => 'resolve',
                                         start_date   => NULL,
                                         end_date     => NULL);
   DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_sharepoint13-pruebas.xml', HOST => 'sharepoint13-pruebas');
   --DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_sharepoint13-pruebas.xml', HOST => '10.232.32.40');
   --10.234.23.117
   COMMIT;
END;
/