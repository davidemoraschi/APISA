CREATE OR REPLACE PACKAGE MSTR.PANDAS_001_REPORT_EXECUTE_v4
AS
   const_pandas_site               CONSTANT VARCHAR2 (100) := 'HUELVA';
   --   const_pandas_site               CONSTANT VARCHAR2 (100) := 'VALME';
-- /*HTTPS*/  const_host_port                 CONSTANT VARCHAR2 (1024) := 'https://localhost:8443';
   /*HTTP*/ const_host_port                 CONSTANT VARCHAR2 (1024) := 'http://localhost:8080';
   const_intelligent_server_name   CONSTANT VARCHAR2 (1024) := 'PANDAS';
   const_intelligent_server_proj   CONSTANT VARCHAR2 (1024) := '001. Hola Mundo';
   const_intelligent_server_user   CONSTANT VARCHAR2 (1024) := 'Emeishan';
   const_intelligent_server_pass   CONSTANT VARCHAR2 (1024) := 'from300($48)to500yuan';
   const_intelligent_server_wurl   CONSTANT VARCHAR2 (1024) := '/MicroStrategy/servlet/taskProc?';
   --const_intelligent_server_wurl   CONSTANT VARCHAR2 (1024) := '/MicroStrategy/asp/TaskProc.aspx?';
   --const_intelligent_server_ntus   CONSTANT VARCHAR2 (1024) := 'VALME\abcdefg';
   --const_intelligent_server_ntpw   CONSTANT VARCHAR2 (1024) := '******';
   const_report_maxrows            CONSTANT VARCHAR2 (10) := '64000';
   con_str_wallet_path             CONSTANT VARCHAR2 (50) := 'file:/u01/app/oracle/wallet';
   con_str_wallet_pass             CONSTANT VARCHAR2 (50) := 'Lepanto1571';

   PROCEDURE png (reportId      IN VARCHAR2 DEFAULT '856B1A1A4A82A2A8A8BB8795E93AE208',
                  projectName   IN VARCHAR2 DEFAULT const_intelligent_server_proj,
                  rWidth        IN NUMBER DEFAULT 750,
                  rHeight       IN NUMBER DEFAULT 400);

   PROCEDURE htm (projectName   IN VARCHAR2 DEFAULT const_intelligent_server_proj,
                  reportId      IN VARCHAR2 DEFAULT '35B834B8479E3A3B36DC02AB3E4B56DD',
                  uniquerowid   IN VARCHAR2 DEFAULT '*');

   /*   PROCEDURE dataxml (reportId      IN VARCHAR2 DEFAULT '99A42538444D80F6B2EE58852E81BB0B',
                         projectName   IN VARCHAR2 DEFAULT const_intelligent_server_proj);*/

   PROCEDURE xml (projectName   IN VARCHAR2 DEFAULT const_intelligent_server_proj,
                  reportId      IN VARCHAR2 DEFAULT '35B834B8479E3A3B36DC02AB3E4B56DD',
                  uniquerowid   IN VARCHAR2 DEFAULT '*',
                  odataclient   IN VARCHAR2 DEFAULT 'Sharepoint');

   PROCEDURE deliver_chunks (t_content IN CLOB, l_file_etag IN VARCHAR2);

   FUNCTION return_grid_as_html (projectName   IN VARCHAR2 DEFAULT const_intelligent_server_proj,
                                 reportId      IN VARCHAR2 DEFAULT '35B834B8479E3A3B36DC02AB3E4B56DD',
                                 uniquerowid   IN VARCHAR2 DEFAULT '*')
      RETURN CLOB;

   FUNCTION return_graph_as_html (projectName   IN VARCHAR2 DEFAULT const_intelligent_server_proj,
                                  reportId      IN VARCHAR2 DEFAULT '35B834B8479E3A3B36DC02AB3E4B56DD',
                                  rWidth        IN NUMBER DEFAULT 750,
                                  rHeight       IN NUMBER DEFAULT 400)
      RETURN CLOB;

   PROCEDURE test;
END;
/