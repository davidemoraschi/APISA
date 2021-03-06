/* Formatted on 15/03/2013 12:19:52 (QP5 v5.163.1008.3004) */
DECLARE
   x_content                                XMLTYPE;
   l_text                                   VARCHAR2 (32767);
   p_content                                CLOB;
   const_sharepoint_service_meth   CONSTANT VARCHAR2 (10) := 'POST';
   const_sharepoint_service_prot   CONSTANT VARCHAR2 (10) := 'HTTP/1.1';
   con_str_http_proxy              CONSTANT VARCHAR2 (50) := '10.232.32.40:3128';
   con_str_wallet_path             CONSTANT VARCHAR2 (50) := 'file:/u01/app/oracle/wallet';
   --   con_str_wallet_path             CONSTANT VARCHAR2 (50) := 'file:C:\oracle\product\11.2.0';
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
          <a:Address>https://apisa365.sharepoint.com</a:Address>
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
   --UTL_HTTP.set_proxy (con_str_http_proxy);
   UTL_HTTP.set_wallet (PATH => con_str_wallet_path, PASSWORD => con_str_wallet_pass);
   l_http_request :=
      UTL_HTTP.BEGIN_REQUEST ('https://login.microsoftonline.com/extSTS.srf',
                              const_sharepoint_service_meth,
                              const_sharepoint_service_prot);
   UTL_HTTP.set_cookie_support (l_http_request, TRUE);
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
   DBMS_OUTPUT.put_line (l_security_token);
   DBMS_LOB.freetemporary (p_content);

   l_http_request :=
      UTL_HTTP.BEGIN_REQUEST ('https://apisa365.sharepoint.com/_forms/default.aspx?wa=wsignin1.0',
                              const_sharepoint_service_meth,
                              const_sharepoint_service_prot);
   UTL_HTTP.set_cookie_support (l_http_request, TRUE);
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

      IF INSTR (h_value, 'FedAuth') > 0
      THEN
         --DBMS_OUTPUT.put_line (h_name || ': ' || h_value);
         --p_FedAuth := REPLACE (h_value, ' path=/; secure; HttpOnly', '');
         FedAuth_cookie := (SUBSTR (h_value, 1, INSTR (h_value, '==;') + 1));
         --FedAuth_cookie := to_base64 (FedAuth_cookie);
         --FedAuth_cookie := REPLACE (FedAuth_cookie, '+', '%2B');
         DBMS_OUTPUT.put_line (FedAuth_cookie);
      --FedAuth_cookie := REPLACE (FedAuth_cookie, CHR (13));
      --DBMS_OUTPUT.put_line (FedAuth_cookie);
      --FedAuth_cookie := REPLACE (FedAuth_cookie, 'FedAuth=', '');
      --FedAuth_cookie := 'FedAuth=' || to_base64 (FedAuth_cookie) || ';';
      --FedAuth_cookie := h_value;
      --DBMS_OUTPUT.put_line (FedAuth_cookie);
      END IF;

      IF INSTR (h_value, 'rtFa') > 0
      THEN
         --DBMS_OUTPUT.put_line (h_name || ': ' || h_value);
         --p_rtFa := REPLACE (h_value, ' domain=sharepoint.com; path=/; HttpOnly', '');
         --p_rtFa := REPLACE (h_value, 'rtFa=', '');
         rtFa_cookie := (SUBSTR (h_value, 1, INSTR (h_value, '==;') + 1));
         --FedAuth_cookie := REPLACE (rtFa_cookie, '+', '%2B');
         DBMS_OUTPUT.put_line (rtFa_cookie);
      --         rtFa_cookie := to_base64 (rtFa_cookie);
      --rtFa_cookie := REPLACE (rtFa_cookie, CHR (10));
      --rtFa_cookie := REPLACE (rtFa_cookie, CHR (13));
      --DBMS_OUTPUT.put_line (rtFa_cookie);
      -- rtFa_cookie := REPLACE (rtFa_cookie, 'rtFa=', '');
      --rtFa_cookie := 'rtFa=' || to_base64 (rtFa_cookie) || ';';
      --rtFa_cookie := h_value;
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

   DBMS_OUTPUT.put_line (p_content);
   DBMS_LOB.freetemporary (p_content);

   l_http_request := UTL_HTTP.BEGIN_REQUEST ('https://apisa365.sharepoint.com/_vti_bin/ListData.svc');
   UTL_HTTP.set_cookie_support (l_http_request, TRUE);
   UTL_HTTP.set_header (l_http_request, 'Cookie', rtFa_cookie||';');
   UTL_HTTP.set_header (l_http_request, 'Cookie', FedAuth_cookie||';');
   --UTL_HTTP.set_header (l_http_request, 'Accept', 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');
   --UTL_HTTP.set_header (l_http_request, 'User-Agent', 'Mozilla/5.0 (Windows NT 5.1; rv:19.0) Gecko/20100101 Firefox/19.0');
   l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
   DBMS_LOB.createtemporary (p_content, FALSE);

   FOR i IN 1 .. UTL_HTTP.get_header_count (l_http_response)
   LOOP
      UTL_HTTP.get_header (l_http_response,
                           i,
                           h_name,
                           h_value);

      DBMS_OUTPUT.put_line (h_name || ':' || h_value);
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

   --   x_content := xmltype (p_content);
   DBMS_OUTPUT.put_line (DBMS_LOB.SUBSTR (p_content, 2000, 1));
   DBMS_LOB.freetemporary (p_content);
--EXCEPTION
--   WHEN OTHERS
--   THEN
--      UTL_HTTP.end_response (l_http_response);
END;