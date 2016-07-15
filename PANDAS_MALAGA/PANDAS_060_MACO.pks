CREATE OR REPLACE PACKAGE MSTR.pandas_060_maco
AS
   --   const_lync_server_ntus    CONSTANT VARCHAR2 (1024) := 'VALME\upddm0';
   --   const_lync_server_ntpw    CONSTANT VARCHAR2 (1024) := 'araknion';
   --   const_lync_service_meth   CONSTANT VARCHAR2 (10) := 'POST';
   --   const_lync_service_prot   CONSTANT VARCHAR2 (10) := 'HTTP/1.1';
   --   con_str_http_proxy        CONSTANT VARCHAR2 (50) := '10.136.0.13:8080';
   --   con_str_wallet_path       CONSTANT VARCHAR2 (50) := 'file:/u01/app/oracle/wallet';
   --   con_str_wallet_pass       CONSTANT VARCHAR2 (50) := 'Lepanto1571';

   l_http_request    UTL_HTTP.req;
   l_http_response   UTL_HTTP.resp;

   --   l_user_href                        VARCHAR2 (32767);
   --   l_xframe_href                      VARCHAR2 (32767);
   --   l_user_OAuth_token                 VARCHAR2 (32767);

   h_name            VARCHAR2 (255);
   h_value           VARCHAR2 (1023);

   --   FUNCTION autodiscovery (p_domain IN VARCHAR2)
   --      RETURN VARCHAR2;
   --
   --   FUNCTION autodiscovery_internal (p_domain IN VARCHAR2)
   --      RETURN VARCHAR2;
   --
   --   FUNCTION authentication (p_MsRtcOAuth IN VARCHAR2)
   --      RETURN VARCHAR2;

   PROCEDURE json (p_dni IN VARCHAR2);

   PROCEDURE deliver_chunks (t_content IN CLOB, l_file_etag IN VARCHAR2);
END pandas_060_maco;
/

