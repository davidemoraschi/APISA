/* Formatted on 14/03/2013 14:02:59 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_NETWORK_ACL_ADMIN.drop_acl (acl => 'mstr_LyncDiscover.xml');
END;
/

--login.microsoftonline.com

BEGIN
   --DBMS_NETWORK_ACL_ADMIN.drop_acl (acl => 'harvest_harvest.xml');
   DBMS_NETWORK_ACL_ADMIN.create_acl (acl           => 'mstr_LyncDiscover.xml',
                                      description   => 'Lync HTTP Access',
                                      principal     => 'MSTR',
                                      is_grant      => TRUE,
                                      PRIVILEGE     => 'connect',
                                      start_date    => NULL,
                                      end_date      => NULL);
   DBMS_NETWORK_ACL_ADMIN.add_privilege (acl          => 'mstr_LyncDiscover.xml',
                                         principal    => 'MSTR',
                                         is_grant     => TRUE,
                                         PRIVILEGE    => 'resolve',
                                         start_date   => NULL,
                                         end_date     => NULL);
   DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_LyncDiscover.xml', HOST => '*.onmicrosoft.com');
   DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_LyncDiscover.xml', HOST => '*.online.lync.com');
   --10.234.23.117
   COMMIT;
END;
/