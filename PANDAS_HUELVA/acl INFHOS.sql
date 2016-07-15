/* Formatted on 14/03/2013 14:02:59 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_NETWORK_ACL_ADMIN.drop_acl (acl => 'mstr_INFHOS.xml');
END;
/

--login.microsoftonline.com

BEGIN
   --DBMS_NETWORK_ACL_ADMIN.drop_acl (acl => 'harvest_harvest.xml');
   DBMS_NETWORK_ACL_ADMIN.create_acl (acl           => 'mstr_INFHOS.xml',
                                      description   => 'INFHOS HTTP Access',
                                      principal     => 'MSTR_CONSULTAS',
                                      is_grant      => TRUE,
                                      PRIVILEGE     => 'connect',
                                      start_date    => NULL,
                                      end_date      => NULL);
   DBMS_NETWORK_ACL_ADMIN.add_privilege (acl          => 'mstr_INFHOS.xml',
                                         principal    => 'MSTR',
                                         is_grant     => TRUE,
                                         PRIVILEGE    => 'resolve',
                                         start_date   => NULL,
                                         end_date     => NULL);
   DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_INFHOS.xml', HOST => '10.234.23.171');
   DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_INFHOS.xml', HOST => '10.136.0.13');
   --10.234.23.117
   COMMIT;
END;
/