/* Formatted on 20/03/2013 12:22:33 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_NETWORK_ACL_ADMIN.drop_acl (acl => 'mstr_microsoftonline.xml');
END;
/

--login.microsoftonline.com

BEGIN
   --DBMS_NETWORK_ACL_ADMIN.drop_acl (acl => 'harvest_harvest.xml');
   DBMS_NETWORK_ACL_ADMIN.create_acl (acl           => 'mstr_microsoftonline.xml',
                                      description   => 'microsoftonline HTTP Access',
                                      principal     => 'MSTR',
                                      is_grant      => TRUE,
                                      PRIVILEGE     => 'connect',
                                      start_date    => NULL,
                                      end_date      => NULL);
   DBMS_NETWORK_ACL_ADMIN.add_privilege (acl          => 'mstr_microsoftonline.xml',
                                         principal    => 'MSTR',
                                         is_grant     => TRUE,
                                         PRIVILEGE    => 'resolve',
                                         start_date   => NULL,
                                         end_date     => NULL);
   DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_microsoftonline.xml', HOST => 'login.microsoftonline.com');
   DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_microsoftonline.xml', HOST => 'apisa365.sharepoint.com');
   DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_microsoftonline.xml', HOST => '10.136.0.13');
   --10.234.23.117
   COMMIT;
END;
/