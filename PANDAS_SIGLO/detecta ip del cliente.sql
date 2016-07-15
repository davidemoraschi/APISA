select utl_inaddr.get_host_address(host_name), host_name, sys_context( 'userenv', 'ip_address' ) from 
v$instance;
