CREATE OR REPLACE PACKAGE BODY MSTR.PANDAS_094_SHAREP_ON_PREMISE
AS
   PROCEDURE POST_TO_LIST (p_listdata_ws_url IN VARCHAR2, p_payload IN CLOB)
   IS
      l_ntlm_auth_str   VARCHAR2 (2000);
      l_http_request    UTL_HTTP.req;
      l_http_response   UTL_HTTP.resp;
      p_content         CLOB;
      l_text            VARCHAR2 (32767);
   BEGIN
      l_ntlm_auth_str :=
         sys.ntlm_http_pkg.begin_request (p_listdata_ws_url, const_sharep_onpremise_ntus, const_sharep_onpremise_ntpw);
      DBMS_OUTPUT.put_line ('Authorization=' || l_ntlm_auth_str);
      l_http_request := UTL_HTTP.BEGIN_REQUEST (p_listdata_ws_url, const_sharep_onpremise_meth, const_sharep_onpremise_prot);
      UTL_HTTP.set_header (l_http_request, 'Authorization', l_ntlm_auth_str);
      --      UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=utf-8');--charset=iso-8859-1
      UTL_HTTP.set_header (l_http_request, 'Content-Type', 'application/json; charset=' || const_sharep_listdata_charset);
      UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (p_payload));
      UTL_HTTP.WRITE_TEXT (l_http_request, p_payload);
      l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
      DBMS_LOB.createtemporary (p_content, FALSE);

      -- Copy the response into the CLOB.
      BEGIN
         LOOP
            UTL_HTTP.read_text (l_http_response, l_text, 32766);
            DBMS_LOB.writeappend (p_content, LENGTH (l_text), l_text);
         END LOOP;
      EXCEPTION
         WHEN UTL_HTTP.end_of_body
         THEN
            UTL_HTTP.end_response (l_http_response);
      END;

      DBMS_OUTPUT.put_line ('resp=' || p_content);
      DBMS_LOB.freetemporary (p_content);
      --      DBMS_OUTPUT.put_line ('resp.status_code=' || l_http_response.status_code);
      sys.ntlm_http_pkg.end_request;
   END;
END;
/

