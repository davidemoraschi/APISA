/* Formatted on 11/11/2013 16:33:21 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE PROCEDURE send_to_SP2013
AS
   p_url                       VARCHAR2 (4000) := 'http://sp13pruebas.sas.junta-andalucia.es/_api/contextinfo';
   l_http_request              UTL_HTTP.req;
   l_http_response             UTL_HTTP.resp;
   l_text                      VARCHAR2 (32767);
   l_ntlm_auth_str             VARCHAR2 (4000);
   l_ntlm_request_digest_str   VARCHAR2 (4000);
   name                        VARCHAR2 (2000);
   VALUE                       VARCHAR2 (2000);
   p_FileContent               VARCHAR2 (32767) := 'HELLO WORLD';
BEGIN
   l_ntlm_auth_str :=
      sys.ntlm_http_pkg.begin_request (p_url,
                                       PANDAS_095_SEND_TO_SHAREP.const_sharepoint_server_ntus,
                                       PANDAS_095_SEND_TO_SHAREP.const_sharepoint_server_ntpw);
   l_http_request :=
      UTL_HTTP.begin_request (p_url,
                              PANDAS_095_SEND_TO_SHAREP.const_sharepoint_service_meth,
                              PANDAS_095_SEND_TO_SHAREP.const_sharepoint_service_prot);

   UTL_HTTP.set_header (l_http_request, 'Authorization', l_ntlm_auth_str);
   UTL_HTTP.set_header (l_http_request, 'Content-Length', 0);

   l_http_response := UTL_HTTP.get_response (l_http_request);

   BEGIN
      LOOP
         UTL_HTTP.read_text (l_http_response, l_text, 32766);
         l_ntlm_request_digest_str :=
            xmltype (l_text).EXTRACT ('/d:GetContextWebInformation/d:FormDigestValue/text()',
                                      'xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices"').getstringval ();
      END LOOP;
   EXCEPTION
      WHEN UTL_HTTP.end_of_body
      THEN
         UTL_HTTP.end_response (l_http_response);
   END;

   --   p_url := 'http://sp13pruebas.sas.junta-andalucia.es/_api/web/lists';                                                     /*OK*/
   --   p_url := 'http://sp13pruebas.sas.junta-andalucia.es/_api/web/lists(guid''22cf6289-ee97-45c1-bb50-8e789e82452a'')';       /*OK*/
   --   p_url := 'http://sp13pruebas.sas.junta-andalucia.es/_api/web/lists/GetByTitle(''Activos%20del%20sitio'')';               /*OK*/
   --   p_url := 'http://sp13pruebas.sas.junta-andalucia.es/_api/web/GetFolderByServerRelativeUrl(''/Documentos%20compartidos'')'; /*OK*/

   p_url :=
      'http://sp13pruebas.sas.junta-andalucia.es/_api/web/GetFolderByServerRelativeUrl(''/Documentos%20compartidos'')/Files/add(url=''a.txt'',overwrite=true)'; /*OK*/


   l_http_request :=
      UTL_HTTP.begin_request (p_url,
                              PANDAS_095_SEND_TO_SHAREP.const_sharepoint_service_meth,
                              PANDAS_095_SEND_TO_SHAREP.const_sharepoint_service_prot);

   --UTL_HTTP.set_header (l_http_request, 'Authorization', l_ntlm_auth_str);
   UTL_HTTP.set_header (l_http_request, 'X-RequestDigest', l_ntlm_request_digest_str);
   UTL_HTTP.set_header (l_http_request, 'Accept', 'application/json;odata=verbose');

   UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (p_FileContent));
   DBMS_OUTPUT.put_line (p_FileContent);
   UTL_HTTP.WRITE_TEXT (l_http_request, p_FileContent);

   l_http_response := UTL_HTTP.get_response (l_http_request);

   --   FOR i IN 1 .. UTL_HTTP.GET_HEADER_COUNT (l_http_response)
   --   LOOP
   --      UTL_HTTP.GET_HEADER (l_http_response,
   --                           i,
   --                           name,
   --                           VALUE);
   --      DBMS_OUTPUT.PUT_LINE (name || ': ' || VALUE);
   --   END LOOP;
   --
   BEGIN
      LOOP
         UTL_HTTP.read_text (l_http_response, l_text, 32766);
         DBMS_OUTPUT.put_line (l_text);
      END LOOP;
   EXCEPTION
      WHEN UTL_HTTP.end_of_body
      THEN
         UTL_HTTP.end_response (l_http_response);
   END;

   sys.ntlm_http_pkg.end_request;
   DBMS_OUTPUT.put_line ('ok');
EXCEPTION
   WHEN OTHERS
   THEN
      UTL_HTTP.end_response (l_http_response);
      RAISE;
END;