CREATE OR REPLACE PACKAGE MSTR.PANDAS_094_SHAREP_ON_PREMISE
AS
   const_sharep_onpremise_site      CONSTANT VARCHAR2 (1024) := 'sharepoint13-pruebas';
   const_sharep_onpremise_subsite   CONSTANT VARCHAR2 (1024) := 'pandas';
   const_sharep_onpremise_ntus      CONSTANT VARCHAR2 (1024) := 'HJRJ\Emeishan';
   const_sharep_onpremise_ntpw      CONSTANT VARCHAR2 (1024) := 'from300($48)to500yuan';
   const_sharep_onpremise_meth      CONSTANT VARCHAR2 (10) := 'POST';
   const_sharep_onpremise_prot      CONSTANT VARCHAR2 (10) := 'HTTP/1.1';
   const_sharep_listdata_charset    CONSTANT VARCHAR2 (10) := 'iso-8859-1';

   --   con_str_http_proxy              CONSTANT VARCHAR2 (50) := '10.232.32.40:3128';
   --   con_str_wallet_path             CONSTANT VARCHAR2 (50) := 'file:C:\oracle\product\11.2.0';
   --   con_str_wallet_pass             CONSTANT VARCHAR2 (50) := 'Lepanto1571';
   PROCEDURE POST_TO_LIST (p_listdata_ws_url IN VARCHAR2, p_payload IN CLOB);
END;
/

