/* Formatted on 21/03/2013 14:01:32 (QP5 v5.163.1008.3004) */
DECLARE
   v_length                                 NUMBER;
   v_index                                  NUMBER;
   vChunkData                               VARCHAR2 (4000);
   nStart                                   NUMBER := 1;
   nEnd                                     NUMBER := 2000;
   nLength                                  NUMBER := 2000;
   nClobLength                              NUMBER;
   l_payload                                CLOB
      :=    '{ T�tulo: "Prueba de Gr�fico '
         || TO_CHAR (SYSDATE, 'hh24:mi')
         || '", Cuerpo: "' --         || PANDAS_001_REPORT_EXECUTE_v4.return_grid_as_html ('QUIRO_DESARROLLO', 'CFC2C30F484F1C387C39938808BD6152')
         || PANDAS_001_REPORT_EXECUTE_v4.return_graph_as_html ('QUIRO_DESARROLLO', '856B1A1A4A82A2A8A8BB8795E93AE208')
         || '"  }';
   x_content                                XMLTYPE;
   l_text                                   VARCHAR2 (32767);
   p_content                                CLOB;
   const_sharepoint_service_meth   CONSTANT VARCHAR2 (10) := 'POST';
   const_sharepoint_service_prot   CONSTANT VARCHAR2 (10) := 'HTTP/1.1';
   con_str_http_proxy              CONSTANT VARCHAR2 (50) := '10.136.0.13:8080';
   con_str_wallet_path             CONSTANT VARCHAR2 (50) := 'file:/u01/app/oracle/wallet';
   con_str_wallet_pass             CONSTANT VARCHAR2 (50) := 'Lepanto1571';
   l_http_request                           UTL_HTTP.req;
   l_http_response                          UTL_HTTP.resp;

   l_saml                                   VARCHAR2 (32767)
      := '<s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope"
      xmlns:a="http://www.w3.org/2005/08/addressing"
      xmlns:u="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
  <s:Header>
    <a:Action s:mustUnderstand="1">http://schemas.xmlsoap.org/ws/2005/02/trust/RST/Issue</a:Action>
    <a:ReplyTo>
      <a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address>
    </a:ReplyTo>
    <a:To s:mustUnderstand="1">https://login.microsoftonline.com/extSTS.srf</a:To>
    <o:Security s:mustUnderstand="1"
       xmlns:o="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
      <o:UsernameToken>
        <o:Username>davide@apisa365.onmicrosoft.com</o:Username>
        <o:Password>Yamato2199</o:Password>
      </o:UsernameToken>
    </o:Security>
  </s:Header>
  <s:Body>
    <t:RequestSecurityToken xmlns:t="http://schemas.xmlsoap.org/ws/2005/02/trust">
      <wsp:AppliesTo xmlns:wsp="http://schemas.xmlsoap.org/ws/2004/09/policy">
        <a:EndpointReference>
          <a:Address>https://apisa365.sharepoint.com/pandas</a:Address>
        </a:EndpointReference>
      </wsp:AppliesTo>
      <t:KeyType>http://schemas.xmlsoap.org/ws/2005/05/identity/NoProofKey</t:KeyType>
      <t:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Issue</t:RequestType>
      <t:TokenType>urn:oasis:names:tc:SAML:1.0:assertion</t:TokenType>
    </t:RequestSecurityToken>
  </s:Body>
</s:Envelope>';
   l_security_token                         VARCHAR2 (32767);
   h_name                                   VARCHAR2 (32767);
   h_value                                  VARCHAR2 (32767);
   FedAuth_cookie                           VARCHAR2 (32767);
   rtFa_cookie                              VARCHAR2 (32767);
BEGIN
   UTL_HTTP.set_proxy (con_str_http_proxy);
   UTL_HTTP.set_wallet (PATH => con_str_wallet_path, PASSWORD => con_str_wallet_pass);
   l_http_request :=
      UTL_HTTP.BEGIN_REQUEST ('https://login.microsoftonline.com/extSTS.srf',
                              const_sharepoint_service_meth,
                              const_sharepoint_service_prot);
   --UTL_HTTP.set_cookie_support (l_http_request, FALSE);
   --TRUE, 300, 300);
   UTL_HTTP.set_persistent_conn_support (TRUE, 5);
   UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (l_saml));
   UTL_HTTP.WRITE_TEXT (l_http_request, l_saml);
   l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
   DBMS_LOB.createtemporary (p_content, FALSE);

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

   x_content := xmltype (p_content);
   l_security_token :=
      x_content.EXTRACT (
         '/S:Envelope/S:Body/wst:RequestSecurityTokenResponse/wst:RequestedSecurityToken/wsse:BinarySecurityToken/text()',
         'xmlns:S="http://www.w3.org/2003/05/soap-envelope" xmlns:wst="http://schemas.xmlsoap.org/ws/2005/02/trust" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"').getstringval ();
   --DBMS_OUTPUT.put_line (p_content);
   --DBMS_OUTPUT.put_line (l_security_token);
   --return;
   DBMS_LOB.freetemporary (p_content);

   l_http_request :=
      UTL_HTTP.BEGIN_REQUEST ('https://apisa365.sharepoint.com/_forms/default.aspx?wa=wsignin1.0',
                              const_sharepoint_service_meth,
                              const_sharepoint_service_prot);
   --UTL_HTTP.set_cookie_support (l_http_request, TRUE);
   UTL_HTTP.SET_COOKIE_SUPPORT (TRUE, 300, 40);
   UTL_HTTP.set_persistent_conn_support (TRUE, 5);
   UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (l_security_token));
   UTL_HTTP.WRITE_TEXT (l_http_request, l_security_token);
   l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
   DBMS_LOB.createtemporary (p_content, FALSE);

   FOR i IN 1 .. UTL_HTTP.get_header_count (l_http_response)
   LOOP
      UTL_HTTP.get_header (l_http_response,
                           i,
                           h_name,
                           h_value);

      --DBMS_OUTPUT.put_line (h_name || ':' || h_value);

      IF INSTR (h_value, 'FedAuth') > 0
      THEN
         --DBMS_OUTPUT.put_line (h_name || ': ' || h_value);
         --p_FedAuth := REPLACE (h_value, ' path=/; secure; HttpOnly', '');
         FedAuth_cookie := (SUBSTR (h_value, 1, INSTR (h_value, '==;') + 1));
      --DBMS_OUTPUT.put_line (FedAuth_cookie);
      --FedAuth_cookie := REPLACE (FedAuth_cookie, 'FedAuth=', '') || ';';
      --DBMS_OUTPUT.put_line (FedAuth_cookie);
      END IF;

      IF INSTR (h_value, 'rtFa') > 0
      THEN
         --DBMS_OUTPUT.put_line (h_name || ':' || h_value);
         --DBMS_OUTPUT.put_line (h_name || ': ' || h_value);
         --p_rtFa := REPLACE (h_value, ' domain=sharepoint.com; path=/; HttpOnly', '');
         --p_rtFa := REPLACE (h_value, 'rtFa=', '');
         rtFa_cookie := (SUBSTR (h_value, 1, INSTR (h_value, '==;') + 1));
      --DBMS_OUTPUT.put_line (rtFa_cookie);
      --rtFa_cookie := REPLACE (rtFa_cookie, 'rtFa=', '') || ';';
      --DBMS_OUTPUT.put_line (rtFa_cookie);
      END IF;
   END LOOP;

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

   --RETURN;
   --DBMS_OUTPUT.put_line (p_content);
   DBMS_LOB.freetemporary (p_content);
   /*
      l_http_request := UTL_HTTP.BEGIN_REQUEST ('https://apisa365.sharepoint.com/pandas/_vti_bin/ListData.svc/Anuncios');
      --UTL_HTTP.set_cookie_support (l_http_request, TRUE);
      UTL_HTTP.set_header (l_http_request, 'Cookie', FedAuth_cookie||' '||rtFa_cookie);
      DBMS_OUTPUT.put_line (FedAuth_cookie||'; '||rtFa_cookie);
      UTL_HTTP.SET_HEADER(l_http_request, 'User-Agent', 'Mozilla/4.0');
      --DBMS_OUTPUT.put_line (rtFa_cookie);
      --UTL_HTTP.set_header (l_http_request, 'Cookie', rtFa_cookie);
      l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
      DBMS_LOB.createtemporary (p_content, FALSE);

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

      --   x_content := xmltype (p_content);
      DBMS_OUTPUT.put_line (DBMS_LOB.SUBSTR (p_content, 200, 1));
      DBMS_LOB.freetemporary (p_content);
   */
   UTL_HTTP.set_transfer_timeout (30);

   l_http_request :=
      UTL_HTTP.BEGIN_REQUEST ('https://apisa365.sharepoint.com/pandas/_vti_bin/ListData.svc/Anuncios',
                              const_sharepoint_service_meth,
                              const_sharepoint_service_prot);
   UTL_HTTP.set_header (l_http_request, 'Cookie', FedAuth_cookie || '; ' || rtFa_cookie);
   UTL_HTTP.SET_HEADER (l_http_request,
                        'User-Agent',
                        'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)');
   UTL_HTTP.set_header (l_http_request, 'Content-Length', DBMS_LOB.GETLENGTH (l_payload));
   UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=' || 'iso-8859-1');

   v_index := 1;
   v_length := NVL (LENGTH (l_payload), 0);

   WHILE v_index <= v_length
   LOOP
      UTL_HTTP.write_text (l_http_request, SUBSTR (l_payload, v_index, 4000));
      v_index := v_index + 4000;
   END LOOP;

   --   UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json');
   --UTL_HTTP.WRITE_TEXT (l_http_request, l_payload);
   /*
      LOOP
         IF nEnd > nClobLength
         THEN
            nEnd := nClobLength;
            nLength := nEnd - nStart + 1;
         END IF;

         vChunkData := NULL;
         vChunkData := DBMS_LOB.SUBSTR (l_payload, nLength, nStart);
         UTL_HTTP.WRITE_TEXT (l_http_request, vChunkData);

         IF nEnd = nClobLength
         THEN
            EXIT;
         END IF;

         nStart := nEnd + 1;
         nEnd := nStart + 2000;
      END LOOP;
   */
   --DBMS_OUTPUT.put_line (l_payload);
   l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
   DBMS_LOB.createtemporary (p_content, FALSE);

   BEGIN
      LOOP
         --UTL_HTTP.read_text (l_http_response, l_text, 32766);
         UTL_HTTP.READ_RAW (l_http_response, l_text, 32766);
      --DBMS_LOB.writeappend (p_content, LENGTH (l_text), l_text);
      END LOOP;
   EXCEPTION
      WHEN UTL_HTTP.end_of_body
      THEN
         UTL_HTTP.end_response (l_http_response);
      WHEN OTHERS
      THEN
         DBMS_OUTPUT.put_line (DBMS_UTILITY.format_error_backtrace);
         p_content := DBMS_UTILITY.format_error_backtrace;
         UTL_HTTP.end_response (l_http_response);
   END;

   --UTL_HTTP.end_response (l_http_response);

   INSERT INTO MSTR_UTL_SHAREPOINT_LOG
        VALUES ('https://apisa365.sharepoint.com/pandas/_vti_bin/ListData.svc/Anuncios',
                SYSTIMESTAMP,
                FedAuth_cookie,
                rtFa_cookie,
                p_content);

   COMMIT;
   --   x_content := xmltype (p_content);
   DBMS_OUTPUT.put_line (DBMS_LOB.SUBSTR (p_content, 2000, 1));
   DBMS_LOB.freetemporary (p_content);
--EXCEPTION
--   WHEN OTHERS
--   THEN
--      UTL_HTTP.end_response (l_http_response);
END;