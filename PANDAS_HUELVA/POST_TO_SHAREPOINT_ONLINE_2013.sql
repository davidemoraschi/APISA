/* Formatted on 26/04/2013 13:17:01 (QP5 v5.163.1008.3004) */
/*         || TO_DATE (SYSDATE, 'dd-mon hh24:mi')
                                                                                                                                                 || ', duración m '
                                                                                                                                                 || TO_CHAR (SYSTIMESTAMP, 'hhmiss')*/

DECLARE
   l_payload          VARCHAR2 (32767)
      := '{ Title: "Test Payload HTML", Content: "'
         --|| '<table border=''1''><tr><th>row 1, cell 1</th><th>row 1, cell 2</th></tr><tr><td>row 2, cell 1</td><td>row 2, cell 2</td></tr></table>'
         || '<table border=''1''><tr><td><h2>Month</h2></td><td><h2>Savings</td></td></tr><tr><td bgcolor=''#232325''>January</td><td>$100</td></tr></table> '
         || '", Result: "SUCCESS"  }';
   FedAuth_cookie     VARCHAR2 (32767);
   rtFa_cookie        VARCHAR2 (32767);
   h_name             VARCHAR2 (32767);
   h_value            VARCHAR2 (32767);
   l_security_token   VARCHAR2 (32767);
   x_content          XMLTYPE;
   l_text             VARCHAR2 (32767);
   p_content          CLOB;
   p_user             VARCHAR2 (32767) := PANDAS_090_POST_TO_SHAREP_v3.con_str_sharepoint_user;
   p_password         VARCHAR2 (32767) := PANDAS_090_POST_TO_SHAREP_v3.con_str_sharepoint_pass;
   l_http_request     UTL_HTTP.req;
   l_http_response    UTL_HTTP.resp;

   l_saml             VARCHAR2 (32767)
      :=    '<s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope"
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
        <o:Username>'
         || p_user
         || '</o:Username>
        <o:Password>'
         || p_password
         || '</o:Password>
      </o:UsernameToken>
    </o:Security>
  </s:Header>
  <s:Body>
    <t:RequestSecurityToken xmlns:t="http://schemas.xmlsoap.org/ws/2005/02/trust">
      <wsp:AppliesTo xmlns:wsp="http://schemas.xmlsoap.org/ws/2004/09/policy">
        <a:EndpointReference>
          <a:Address>https://pandasbi.sharepoint.com</a:Address>
        </a:EndpointReference>
      </wsp:AppliesTo>
      <t:KeyType>http://schemas.xmlsoap.org/ws/2005/05/identity/NoProofKey</t:KeyType>
      <t:RequestType>http://schemas.xmlsoap.org/ws/2005/02/trust/Issue</t:RequestType>
      <t:TokenType>urn:oasis:names:tc:SAML:1.0:assertion</t:TokenType>
    </t:RequestSecurityToken>
  </s:Body>
</s:Envelope>';
   l_result           VARCHAR2 (32767);
BEGIN
   UTL_HTTP.set_proxy (PANDAS_090_POST_TO_SHAREP_v3.con_str_http_proxy);
   UTL_HTTP.set_wallet (PATH       => PANDAS_090_POST_TO_SHAREP_v3.con_str_wallet_path,
                        PASSWORD   => PANDAS_090_POST_TO_SHAREP_v3.con_str_wallet_pass);
   l_http_request :=
      UTL_HTTP.BEGIN_REQUEST ('https://login.microsoftonline.com/extSTS.srf',
                              PANDAS_090_POST_TO_SHAREP_v3.const_sharepoint_service_meth,
                              PANDAS_090_POST_TO_SHAREP_v3.const_sharepoint_service_prot);
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
   --DBMS_OUTPUT.put_line ('l_security_token:' || l_security_token);
   DBMS_LOB.freetemporary (p_content);

   l_http_request :=
      UTL_HTTP.BEGIN_REQUEST (
            'https://'
         || PANDAS_090_POST_TO_SHAREP_v3.con_str_sharepoint_domain
         || '.sharepoint.com/_forms/default.aspx?wa=wsignin1.0',
         PANDAS_090_POST_TO_SHAREP_v3.const_sharepoint_service_meth,
         PANDAS_090_POST_TO_SHAREP_v3.const_sharepoint_service_prot);
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

      DBMS_OUTPUT.put_line (h_name || ': ' || h_value);

      IF INSTR (h_value, 'FedAuth') > 0
      THEN
         --DBMS_OUTPUT.put_line (h_name || ':' || h_value);
         --p_FedAuth := REPLACE (h_value, ' path=/; secure; HttpOnly', '');
         FedAuth_cookie := (SUBSTR (h_value, 1, INSTR (h_value, '+;') + 0));
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

   --DBMS_OUTPUT.put_line (p_content);
   DBMS_LOB.freetemporary (p_content);

   l_http_request :=
      UTL_HTTP.BEGIN_REQUEST (
            'https://'
         || PANDAS_090_POST_TO_SHAREP_v3.con_str_sharepoint_domain
         || '.sharepoint.com/_api/web/lists/getbytitle(''PANDAS_ETL'')/items',
         PANDAS_090_POST_TO_SHAREP_v3.const_sharepoint_service_meth,
         PANDAS_090_POST_TO_SHAREP_v3.const_sharepoint_service_prot);
   UTL_HTTP.set_header (l_http_request, 'Cookie', FedAuth_cookie || '; ' || rtFa_cookie);
   UTL_HTTP.SET_HEADER (l_http_request,
                        'User-Agent',
                        'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0)');
   UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (l_payload));
   UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=' || 'iso-8859-1');
   UTL_HTTP.WRITE_TEXT (l_http_request, l_payload);
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
   --RETURN (DBMS_LOB.SUBSTR (p_content, 2000, 1));
   DBMS_OUTPUT.put_line (DBMS_LOB.SUBSTR (p_content, 2000, 1));
   DBMS_LOB.freetemporary (p_content);
END;