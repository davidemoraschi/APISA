CREATE OR REPLACE package MSTR.pandas_080_lync
as
   const_lync_server_ntus    CONSTANT VARCHAR2 (1024) := 'VALME\upddm0';
   const_lync_server_ntpw    CONSTANT VARCHAR2 (1024) := 'araknion';
   const_lync_service_meth   CONSTANT VARCHAR2 (10) := 'POST';
   const_lync_service_prot   CONSTANT VARCHAR2 (10) := 'HTTP/1.1';
   con_str_http_proxy              CONSTANT VARCHAR2 (50) := '10.232.32.40:3128';
   con_str_wallet_path             CONSTANT VARCHAR2 (50) := 'file:/u01/app/oracle/wallet';
   con_str_wallet_pass             CONSTANT VARCHAR2 (50) := 'Lepanto1571';

      l_http_request    UTL_HTTP.req;
      l_http_response   UTL_HTTP.resp;
function autodiscovery (p_domain in varchar2)
return varchar2;
end;
/