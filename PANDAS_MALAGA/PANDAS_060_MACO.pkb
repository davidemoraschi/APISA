CREATE OR REPLACE PACKAGE BODY MSTR.pandas_060_maco
AS
   PROCEDURE json (p_dni IN VARCHAR2)
   IS
      v_PER_CODIGO      VARCHAR2 (250);
      v_PER_NOMBRE      VARCHAR2 (250);
      v_PER_APELLIDO1   VARCHAR2 (250);
      v_PER_APELLIDO2   VARCHAR2 (250);
      v_OPE_USER        VARCHAR2 (250);
      l_file_etag       VARCHAR2 (100);
      l_header_etag     VARCHAR2 (100);
      b_primero         BOOLEAN := TRUE;
      l_clob            CLOB;
      l_text            VARCHAR2 (32767);
   BEGIN
      DBMS_APPLICATION_INFO.set_client_info (
         OWA_UTIL.get_cgi_env ('HTTP_USER_AGENT'));
      DBMS_SESSION.set_identifier ('Pandas Connector');
      DBMS_APPLICATION_INFO.set_module ('PANDAS_MACO_CONNECTOR', 'json');
      l_file_etag := TO_CHAR (SYSTIMESTAMP, 'J') || p_dni;
      l_header_etag := OWA_UTIL.get_cgi_env ('HTTP_IF_NONE_MATCH');

      IF l_file_etag = l_header_etag /* check if file is newer, if not returns status 304 = read from browser cache*/
      THEN
         OWA_UTIL.status_line (NSTATUS         => 304,
                               CREASON         => 'Not Modified',
                               BCLOSE_HEADER   => TRUE);
         DBMS_APPLICATION_INFO.set_module ('REPORT_EXECUTE', NULL);
         RETURN;
      ELSE
         SELECT PER_CODIGO,
                PER_NOMBRE,
                PER_APELLIDO1,
                PER_APELLIDO2,
                OPE_USER
           INTO v_PER_CODIGO,
                v_PER_NOMBRE,
                v_PER_APELLIDO1,
                v_PER_APELLIDO2,
                v_OPE_USER
           FROM    REP_PRO_MAC.PERSONAS@MAE44DAE
                JOIN
                   REP_PRO_MAC.OPERADOR@MAE44DAE
                ON (PERSONAS.PER_CODIGO = OPERADOR.OPE_PER_CODIGO)
          WHERE PER_ID_DOCUMENTO = UPPER (p_dni);

         OWA_UTIL.mime_header ('application/json; charset=utf-8', FALSE);
         HTP.p ('Access-Control-Allow-Origin: *');
         --HTP.p ('Access-Control-Allow-Origin: http://foo.example');
         HTP.p ('Access-Control-Allow-Methods: POST, GET, OPTIONS');
         HTP.p ('Access-Control-Allow-Headers: X-PINGOTHER');
         HTP.p ('Access-Control-Max-Age: 1728000');
         HTP.p (
               'Date: '
            || TO_CHAR (SYSTIMESTAMP, 'Dy, DD Mon RRRR hh24:mi:ss')
            || ' GMT');

         HTP.p (
               'Last-Modified: '
            || TO_CHAR (SYSTIMESTAMP, 'Dy, DD Mon YYYY  "00:00:00"')
            || ' GMT');
         HTP.p ('ETag: ' || l_file_etag);
         HTP.p (
               'Expires: '
            || TO_CHAR (SYSTIMESTAMP + 1, 'Dy, DD Mon RRRR "00:00:00"')
            || ' GMT');
         HTP.p ('Cache-Control: max-age=300');

         OWA_UTIL.http_header_close;
         DBMS_LOB.createtemporary (l_clob, FALSE);
         l_text := ('{"operador": "' || v_OPE_USER || '", "modulos": [');
         DBMS_LOB.writeappend (l_clob, LENGTH (l_text), l_text);

         FOR c1 IN (SELECT CODIGO,
                           NOMBRE,
                           UF_AH_CODIGO,
                           AH_DESCRIPCION,
                           NVL (UF_CODIGO, UNIDAD) UF_CODIGO,
                           UF_NOMBRE
                      FROM REP_PRO_MAC.OPERADORUNIDADFUNCIONAL@MAE44DAE
                           JOIN REP_PRO_MAC.MODULO@MAE44DAE
                              ON (MODULO = CODIGO)
                           LEFT JOIN REP_PRO_EST.UNIDADES_FUNCIONALES@MAE44DAE
                              ON (UNIDAD = UF_CODIGO)
                           LEFT JOIN REP_PRO_EST.AREAS_HOSPITALARIAS@MAE44DAE
                              ON (UF_AH_CODIGO = AH_CODIGO)
                     WHERE OPERADOR = v_PER_CODIGO)
         LOOP
            IF NOT b_primero
            THEN
               l_text := ', ';
               DBMS_LOB.writeappend (l_clob, LENGTH (l_text), l_text);
            ELSE
               b_primero := FALSE;
            END IF;

            l_text :=
                  '{"natid_modulo": "'
               || c1.CODIGO
               || '", "descr_modulo": "'
               || c1.NOMBRE
               || '", "natid_area_hospitalaria": "'
               || c1.UF_AH_CODIGO
               || '", "descr_area_hospitalaria": "'
               || c1.AH_DESCRIPCION
               || '", "natid_unidad_funcional": "'
               || c1.UF_CODIGO
               || '", "descr_unidad_funcional": "'
               || c1.UF_NOMBRE
               || '"}';
            DBMS_LOB.writeappend (l_clob, LENGTH (l_text), l_text);
         END LOOP;

         l_text := ']';
         DBMS_LOB.writeappend (l_clob, LENGTH (l_text), l_text);

         l_text := '}';
         DBMS_LOB.writeappend (l_clob, LENGTH (l_text), l_text);

         deliver_chunks (l_clob, l_file_etag);
         DBMS_LOB.freetemporary (l_clob);
      END IF;
   END json;

   --   FUNCTION autodiscovery (p_domain IN VARCHAR2)
   --      RETURN VARCHAR2
   --   IS
   --      p_content   CLOB;
   --      l_text      VARCHAR2 (32767);
   --      obj         json;
   --      objxml      XMLTYPE;
   --      p_FedAuth   VARCHAR2 (4000);
   --   BEGIN
   --      UTL_HTTP.set_proxy (con_str_http_proxy);
   --
   --      l_http_request := UTL_HTTP.BEGIN_REQUEST ('http://LyncDiscover.' || p_domain, 'GET', const_lync_service_prot);
   --      --UTL_HTTP.set_header (l_http_request, 'Authorization', l_ntlm_auth_str);
   --      --      UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=utf-8');--charset=iso-8859-1
   --      --UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=' || listdata_charset);
   --      --UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (listdata_payload));
   --      --UTL_HTTP.WRITE_TEXT (l_http_request, listdata_payload);
   --      l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
   --      DBMS_LOB.createtemporary (p_content, FALSE);
   --
   --      -- Copy the response into the CLOB.
   --      BEGIN
   --         LOOP
   --            UTL_HTTP.read_text (l_http_response, l_text, 32766);
   --            DBMS_LOB.writeappend (p_content, LENGTH (l_text), l_text);
   --         END LOOP;
   --      EXCEPTION
   --         WHEN UTL_HTTP.end_of_body
   --         THEN
   --            UTL_HTTP.end_response (l_http_response);
   --      END;
   --
   --      --DBMS_OUTPUT.put_line (p_content);
   --      --RETURN p_content;
   --      --report_len  := length(report_clob);
   --      --report      := TO_CHAR(dbms_lob.substr(report_clob, report_len, 1 ));
   --      obj := json (TO_CHAR (DBMS_LOB.SUBSTR (p_content, LENGTH (p_content), 4)));
   --      --obj.print;
   --      --dbms_output.put_line(json_ext.get_string(obj, '_links'));
   --      objxml := json_xml.json_to_xml (obj);
   --
   --      DBMS_LOB.freetemporary (p_content);
   --      l_user_href := (REPLACE (objxml.EXTRACT ('/root/_links/user/href/text()').getstringval (), '&quot;', ''));
   --      l_xframe_href := (REPLACE (objxml.EXTRACT ('/root/_links/xframe/href/text()').getstringval (), '&quot;', ''));
   --      --return l_user_href;
   --      --DBMS_OUTPUT.put_line ('l_xframe_hrefe=' || l_xframe_href);
   --
   --      UTL_HTTP.set_wallet (PATH => con_str_wallet_path, PASSWORD => con_str_wallet_pass);
   --
   --      l_http_request := UTL_HTTP.BEGIN_REQUEST (l_user_href, 'GET', const_lync_service_prot);
   --
   --      UTL_HTTP.set_header (l_http_request, 'Referer', l_xframe_href);
   --      --      UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=utf-8');--charset=iso-8859-1
   --      --UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=' || listdata_charset);
   --      --UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (listdata_payload));
   --      --UTL_HTTP.WRITE_TEXT (l_http_request, listdata_payload);
   --      l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
   --      DBMS_LOB.createtemporary (p_content, FALSE);
   --
   --      FOR i IN 1 .. UTL_HTTP.get_header_count (l_http_response)
   --      LOOP
   --         UTL_HTTP.get_header (l_http_response,
   --                              i,
   --                              h_name,
   --                              h_value);
   --
   --         --DBMS_OUTPUT.put_line (h_name || ': ' || h_value);
   --         IF INSTR (h_value, 'MsRtcOAuth') > 0
   --         THEN
   --            --DBMS_OUTPUT.put_line (h_name || ': ' || h_value);
   --            p_FedAuth := REPLACE (h_value, 'MsRtcOAuth href="', '');
   --            p_FedAuth := REPLACE (p_FedAuth, '"', '');
   --            p_FedAuth := SUBSTR (p_FedAuth, 1, INSTR (p_FedAuth, ',') - 1);
   --         END IF;
   --      END LOOP;
   --
   --      -- Copy the response into the CLOB.
   --      BEGIN
   --         LOOP
   --            UTL_HTTP.read_text (l_http_response, l_text, 32766);
   --            DBMS_LOB.writeappend (p_content, LENGTH (l_text), l_text);
   --         END LOOP;
   --      EXCEPTION
   --         WHEN UTL_HTTP.end_of_body
   --         THEN
   --            UTL_HTTP.end_response (l_http_response);
   --      END;
   --
   --      --dbms_output.put_line (p_content);
   --      RETURN p_FedAuth;
   --      DBMS_LOB.freetemporary (p_content);
   --   -- return (REPLACE (objxml.extract('/root/_links/user/href/text()').getstringval(),'&quot;',''));
   --   END;
   --
   --   FUNCTION autodiscovery_internal (p_domain IN VARCHAR2)
   --      RETURN VARCHAR2
   --   IS
   --      p_content       CLOB;
   --      l_text          VARCHAR2 (32767);
   --      obj             json;
   --      objxml          XMLTYPE;
   --      l_user_href     VARCHAR2 (32767);
   --      l_xframe_href   VARCHAR2 (32767);
   --      h_name          VARCHAR2 (255);
   --      h_value         VARCHAR2 (1023);
   --      p_FedAuth       VARCHAR2 (4000);
   --   BEGIN
   --      UTL_HTTP.set_proxy (con_str_http_proxy);
   --
   --      l_http_request := UTL_HTTP.BEGIN_REQUEST ('http://LyncDiscoverInternal.' || p_domain, 'GET', const_lync_service_prot);
   --      --UTL_HTTP.set_header (l_http_request, 'Authorization', l_ntlm_auth_str);
   --      --      UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=utf-8');--charset=iso-8859-1
   --      --UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=' || listdata_charset);
   --      --UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (listdata_payload));
   --      --UTL_HTTP.WRITE_TEXT (l_http_request, listdata_payload);
   --      l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
   --      DBMS_LOB.createtemporary (p_content, FALSE);
   --
   --      -- Copy the response into the CLOB.
   --      BEGIN
   --         LOOP
   --            UTL_HTTP.read_text (l_http_response, l_text, 32766);
   --            DBMS_LOB.writeappend (p_content, LENGTH (l_text), l_text);
   --         END LOOP;
   --      EXCEPTION
   --         WHEN UTL_HTTP.end_of_body
   --         THEN
   --            UTL_HTTP.end_response (l_http_response);
   --      END;
   --
   --      --DBMS_OUTPUT.put_line (p_content);
   --      RETURN p_content;
   --      --report_len  := length(report_clob);
   --      --report      := TO_CHAR(dbms_lob.substr(report_clob, report_len, 1 ));
   --      obj := json (TO_CHAR (DBMS_LOB.SUBSTR (p_content, LENGTH (p_content), 4)));
   --      --obj.print;
   --      --dbms_output.put_line(json_ext.get_string(obj, '_links'));
   --      objxml := json_xml.json_to_xml (obj);
   --
   --      DBMS_LOB.freetemporary (p_content);
   --      l_user_href := (REPLACE (objxml.EXTRACT ('/root/_links/user/href/text()').getstringval (), '&quot;', ''));
   --      l_xframe_href := (REPLACE (objxml.EXTRACT ('/root/_links/xframe/href/text()').getstringval (), '&quot;', ''));
   --      --return l_user_href;
   --      DBMS_OUTPUT.put_line ('l_xframe_hrefe=' || l_xframe_href);
   --
   --      UTL_HTTP.set_wallet (PATH => con_str_wallet_path, PASSWORD => con_str_wallet_pass);
   --
   --      l_http_request := UTL_HTTP.BEGIN_REQUEST (l_user_href, 'GET', const_lync_service_prot);
   --
   --      UTL_HTTP.set_header (l_http_request, 'Referer', l_xframe_href);
   --      --      UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=utf-8');--charset=iso-8859-1
   --      --UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=' || listdata_charset);
   --      --UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (listdata_payload));
   --      --UTL_HTTP.WRITE_TEXT (l_http_request, listdata_payload);
   --      l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
   --      DBMS_LOB.createtemporary (p_content, FALSE);
   --
   --      FOR i IN 1 .. UTL_HTTP.get_header_count (l_http_response)
   --      LOOP
   --         UTL_HTTP.get_header (l_http_response,
   --                              i,
   --                              h_name,
   --                              h_value);
   --
   --         --DBMS_OUTPUT.put_line (h_name || ': ' || h_value);
   --         IF INSTR (h_value, 'MsRtcOAuth') > 0
   --         THEN
   --            DBMS_OUTPUT.put_line (h_name || ': ' || h_value);
   --            p_FedAuth := REPLACE (h_value, 'MsRtcOAuth href="', '');
   --            p_FedAuth := REPLACE (p_FedAuth, '"', '');
   --         END IF;
   --      END LOOP;
   --
   --      -- Copy the response into the CLOB.
   --      BEGIN
   --         LOOP
   --            UTL_HTTP.read_text (l_http_response, l_text, 32766);
   --            DBMS_LOB.writeappend (p_content, LENGTH (l_text), l_text);
   --         END LOOP;
   --      EXCEPTION
   --         WHEN UTL_HTTP.end_of_body
   --         THEN
   --            UTL_HTTP.end_response (l_http_response);
   --      END;
   --
   --      --dbms_output.put_line (p_content);
   --      RETURN p_FedAuth;
   --      DBMS_LOB.freetemporary (p_content);
   --   -- return (REPLACE (objxml.extract('/root/_links/user/href/text()').getstringval(),'&quot;',''));
   --   END;
   --
   --   FUNCTION authentication (p_MsRtcOAuth IN VARCHAR2)
   --      RETURN VARCHAR2
   --   IS
   --      listdata_payload   VARCHAR2 (32767)
   --         := 'grant_type=urn:microsoft.rtc:anonmeeting&password=9WN6F08G&ms_rtc_conferenceuri=sip:davide@apisa365.onmicrosoft.com;gruu;opaque=app:conf:focus:id:9WN6F08G';
   --      p_content          CLOB;
   --      l_text             VARCHAR2 (32767);
   --      obj                json;
   --      objxml             XMLTYPE;
   --   BEGIN
   --      UTL_HTTP.set_proxy (con_str_http_proxy);
   --
   --      l_http_request := UTL_HTTP.BEGIN_REQUEST (p_MsRtcOAuth, 'POST', const_lync_service_prot);
   --      --UTL_HTTP.set_header (l_http_request, 'Authorization', l_ntlm_auth_str);
   --      --      UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=utf-8');--charset=iso-8859-1
   --      UTL_HTTP.set_header (l_http_request, 'Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
   --      UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (listdata_payload));
   --      UTL_HTTP.WRITE_TEXT (l_http_request, listdata_payload);
   --      l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
   --      DBMS_LOB.createtemporary (p_content, FALSE);
   --
   --      -- Copy the response into the CLOB.
   --      BEGIN
   --         LOOP
   --            UTL_HTTP.read_text (l_http_response, l_text, 32766);
   --            DBMS_LOB.writeappend (p_content, LENGTH (l_text), l_text);
   --         END LOOP;
   --      EXCEPTION
   --         WHEN UTL_HTTP.end_of_body
   --         THEN
   --            UTL_HTTP.end_response (l_http_response);
   --      END;
   --
   --      --DBMS_OUTPUT.put_line (p_content);
   --      --RETURN p_content;
   --      --report_len  := length(report_clob);
   --      --report      := TO_CHAR(dbms_lob.substr(report_clob, report_len, 1 ));
   --      obj := json (TO_CHAR (DBMS_LOB.SUBSTR (p_content, LENGTH (p_content), 1)));
   --      obj.print;
   --      objxml := json_xml.json_to_xml (obj);
   --      dbms_output.put_line(objxml.extract('/').getstringval());
   --
   --      DBMS_LOB.freetemporary (p_content);
   --      l_user_OAuth_token := REPLACE (objxml.EXTRACT ('/root/access_token/text()').getstringval (), '&quot;', '');
   --      DBMS_OUTPUT.put_line (l_user_OAuth_token);
   --      UTL_HTTP.set_wallet (PATH => con_str_wallet_path, PASSWORD => con_str_wallet_pass);
   --      l_http_request := UTL_HTTP.BEGIN_REQUEST (l_user_href, 'GET', const_lync_service_prot);
   --      --      UTL_HTTP.set_header (l_http_request, 'Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
   --      UTL_HTTP.set_header (l_http_request, 'Referer', l_xframe_href);
   --      --Authorization: Bearer cwt=AAEB...buHc
   --      UTL_HTTP.set_header (l_http_request, 'Authorization', 'Bearer ' || l_user_OAuth_token);
   --      DBMS_OUTPUT.put_line (l_user_href);
   --      DBMS_OUTPUT.put_line (l_user_OAuth_token);
   --      DBMS_OUTPUT.put_line (l_xframe_href);
   --
   --      --      UTL_HTTP.set_header (l_http_request, 'content-type', 'application/json; charset=utf-8');--charset=iso-8859-1
   --      --UTL_HTTP.set_header (l_http_request, 'Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8');
   --      --UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (listdata_payload));
   --      --UTL_HTTP.WRITE_TEXT (l_http_request, listdata_payload);
   --      l_http_response := UTL_HTTP.GET_RESPONSE (l_http_request);
   --      DBMS_LOB.createtemporary (p_content, FALSE);
   --
   --      FOR i IN 1 .. UTL_HTTP.get_header_count (l_http_response)
   --      LOOP
   --         UTL_HTTP.get_header (l_http_response,
   --                              i,
   --                              h_name,
   --                              h_value);
   --
   --         DBMS_OUTPUT.put_line (h_name || ': ' || h_value);
   --      --         IF INSTR (h_value, 'MsRtcOAuth') > 0
   --      --         THEN
   --      --            --DBMS_OUTPUT.put_line (h_name || ': ' || h_value);
   --      --            p_FedAuth := REPLACE (h_value, 'MsRtcOAuth href="', '');
   --      --            p_FedAuth := REPLACE (p_FedAuth, '"', '');
   --      --            p_FedAuth := SUBSTR (p_FedAuth, 1, INSTR (p_FedAuth, ',') - 1);
   --      --         END IF;
   --      END LOOP;
   --
   --      -- Copy the response into the CLOB.
   --      BEGIN
   --         LOOP
   --            UTL_HTTP.read_text (l_http_response, l_text, 32766);
   --            DBMS_LOB.writeappend (p_content, LENGTH (l_text), l_text);
   --         END LOOP;
   --      EXCEPTION
   --         WHEN UTL_HTTP.end_of_body
   --         THEN
   --            UTL_HTTP.end_response (l_http_response);
   --      END;
   --
   --      DBMS_OUTPUT.put_line (p_content);
   --      --report_len  := length(report_clob);
   --      --report      := TO_CHAR(dbms_lob.substr(report_clob, report_len, 1 ));
   --      --obj := json (TO_CHAR (DBMS_LOB.SUBSTR (p_content, LENGTH (p_content), 1)));
   --      --obj.print;
   --      --objxml := json_xml.json_to_xml (obj);
   --      --dbms_output.put_line(objxml.extract('/').getstringval());
   --
   --      RETURN p_content;
   --      DBMS_LOB.freetemporary (p_content);
   --   --RETURN REPLACE (objxml.EXTRACT ('/root/access_token/text()').getstringval (), '&quot;', '');
   --   END;
   PROCEDURE deliver_chunks (t_content IN CLOB, l_file_etag IN VARCHAR2)
   IS
      -- v_offset NUMBER := 1;
      -- v_length NUMBER;
      -- v_clob CLOB;
      -- v_amount NUMBER := 4000;
      -- v_buffer VARCHAR2 (4002);
      l_offset   NUMBER := 1;
      v_xml      CLOB;
   BEGIN
      v_xml := t_content;

      LOOP
         EXIT WHEN l_offset > DBMS_LOB.getlength (v_xml);
         HTP.prn (DBMS_LOB.SUBSTR (v_xml, 8000, l_offset)); -- (REPLACE (REPLACE (DBMS_LOB.SUBSTR (v_xml, 255, l_offset), CHR (10)), CHR (13))); -- (DBMS_LOB.SUBSTR (v_xml, 255, l_offset)); --DBMS_OUTPUT.PUT_LINE (DBMS_LOB.SUBSTR (v_xml, 255, l_offset));
         l_offset := l_offset + 8000;
      END LOOP;
   /*
    DBMS_LOB.createtemporary (lob_loc => v_clob, cache => FALSE, dur => DBMS_LOB.session);
    v_clob := t_content;

    v_length := DBMS_LOB.getlength (v_clob);

    WHILE v_offset <= v_length
    LOOP
    BEGIN
    DBMS_LOB.read (v_clob,
    v_amount,
    v_offset,
    v_buffer);
    HTP.p (v_buffer);
    v_offset := v_offset + v_amount;
    END;
    END LOOP;

    DBMS_LOB.freetemporary (lob_loc => v_clob);
    */
   END;
END pandas_060_maco;
/

