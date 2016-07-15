/* Formatted on 28/05/2013 12:08:59 (QP5 v5.163.1008.3004) */
BEGIN
   DBMS_NETWORK_ACL_ADMIN.drop_acl (acl => 'mstr_hospitalizacion_EUROSTRATEGY.xml');
END;
/

--eurostrategy.net

BEGIN
   DBMS_NETWORK_ACL_ADMIN.create_acl (acl           => 'mstr_hospitalizacion_EUROSTRATEGY.xml',
                                      description   => 'EUROSTRATEGY HTTP Access',
                                      principal     => 'MSTR_HOSPITALIZACION',
                                      is_grant      => TRUE,
                                      PRIVILEGE     => 'connect',
                                      start_date    => NULL,
                                      end_date      => NULL);
   DBMS_NETWORK_ACL_ADMIN.add_privilege (acl          => 'mstr_hospitalizacion_EUROSTRATEGY.xml',
                                         principal    => 'MSTR_HOSPITALIZACION',
                                         is_grant     => TRUE,
                                         PRIVILEGE    => 'resolve',
                                         start_date   => NULL,
                                         end_date     => NULL);
   DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_hospitalizacion_EUROSTRATEGY.xml', HOST => 'eurostrategy.net');
   DBMS_NETWORK_ACL_ADMIN.assign_acl (acl => 'mstr_hospitalizacion_EUROSTRATEGY.xml', HOST => '10.136.0.13');
   --10.234.23.117
   COMMIT;
END;
/