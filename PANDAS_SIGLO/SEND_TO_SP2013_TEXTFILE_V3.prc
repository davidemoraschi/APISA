/* Formatted on 14/11/2013 15:39:58 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
CREATE OR REPLACE PROCEDURE MSTR.send_to_SP2013_textfile_v3 (reportId IN VARCHAR2 DEFAULT '856B1A1A4A82A2A8A8BB8795E93AE208',
																														 projectName IN VARCHAR2 DEFAULT PANDAS_001_REPORT_EXECUTE_v7.const_intelligent_server_proj,
																														 p_delimiter IN VARCHAR2 DEFAULT '|') AS
	p_url VARCHAR2 (4000) := 'http://sp13pruebas.sas.junta-andalucia.es/_api/contextinfo';
	l_http_request UTL_HTTP.req;
	l_http_response UTL_HTTP.resp;
	l_text VARCHAR2 (32767);
	l_ntlm_auth_str VARCHAR2 (4000);
	l_ntlm_request_digest_str VARCHAR2 (4000);
	l_mstr_sessionState VARCHAR2 (4000);
	name VARCHAR2 (2000);
	VALUE VARCHAR2 (2000);
	-- p_FileContent VARCHAR2 (32767) := 'HELLO WORLD';
	p_content CLOB;
	l_report_blob BLOB;
	l_raw RAW (32767);
	l_offset NUMBER := 1;
	v_txt BLOB;
	l_gzcompressed_blob BLOB;
--l_uncompressed_blob BLOB;
BEGIN
	l_ntlm_auth_str := sys.ntlm_http_pkg.begin_request (p_url,
																											PANDAS_095_SEND_TO_SHAREP.const_sharepoint_server_ntus,
																											PANDAS_095_SEND_TO_SHAREP.const_sharepoint_server_ntpw);
	l_http_request := UTL_HTTP.begin_request (p_url,
																						PANDAS_095_SEND_TO_SHAREP.const_sharepoint_service_meth,
																						PANDAS_095_SEND_TO_SHAREP.const_sharepoint_service_prot);

	UTL_HTTP.set_header (l_http_request, 'Authorization', l_ntlm_auth_str);
	UTL_HTTP.set_header (l_http_request, 'Content-Length', 0);

	l_http_response := UTL_HTTP.get_response (l_http_request);

	BEGIN
		LOOP
			UTL_HTTP.read_text (l_http_response, l_text, 32766);
			l_ntlm_request_digest_str := xmltype (l_text).EXTRACT ('/d:GetContextWebInformation/d:FormDigestValue/text()',
																														 'xmlns:d="http://schemas.microsoft.com/ado/2007/08/dataservices"').getstringval ();
		END LOOP;
	EXCEPTION
		WHEN UTL_HTTP.end_of_body THEN
			UTL_HTTP.end_response (l_http_response);
	END;

	p_url :=		PANDAS_001_REPORT_EXECUTE_v7.const_host_port
					 || PANDAS_001_REPORT_EXECUTE_v7.const_intelligent_server_wurl
					 || 'taskId=login&taskEnv=xml&taskContentType=xml&server='
					 || PANDAS_001_REPORT_EXECUTE_v7.const_intelligent_server_name
					 || '&project='
					 || UTL_URL.escape (projectName)
					 || '&userid='
					 || PANDAS_001_REPORT_EXECUTE_v7.const_intelligent_server_user
					 || '&password='
					 || UTL_URL.escape (PANDAS_001_REPORT_EXECUTE_v7.const_intelligent_server_pass);
	DBMS_LOB.createtemporary (p_content, FALSE);
	l_http_request := UTL_HTTP.begin_request (p_url);
	l_http_response := UTL_HTTP.get_response (l_http_request);

	BEGIN
		LOOP
			UTL_HTTP.read_text (l_http_response, l_text, 32766);
			DBMS_LOB.writeappend (p_content, LENGTH (l_text), l_text);
		END LOOP;
	EXCEPTION
		WHEN UTL_HTTP.end_of_body THEN
			UTL_HTTP.end_response (l_http_response);
	END;

	l_mstr_sessionState := xmltype (p_content).EXTRACT ('taskResponse/root/sessionState/text()').getstringval ();
	--DBMS_OUTPUT.put_line (l_mstr_sessionState);
	DBMS_LOB.freetemporary (p_content);

	p_url :=		PANDAS_001_REPORT_EXECUTE_v7.const_host_port
					 || PANDAS_001_REPORT_EXECUTE_v7.const_intelligent_server_wurl
					 || 'taskId=exportReport&taskEnv=xml&taskContentType=xml&sessionState='
					 || UTL_URL.escape (l_mstr_sessionState)
					 || '&executionMode=4&plainTextDelimiter='
					 || p_delimiter
					 || '&maxRows='
					 || PANDAS_001_REPORT_EXECUTE_v7.const_report_maxrows
					 || '&maxCols='
					 || PANDAS_001_REPORT_EXECUTE_v7.const_report_maxcols
					 || '&reportID='
					 || reportId;
	DBMS_LOB.createtemporary (l_report_blob, FALSE);
	UTL_HTTP.set_transfer_timeout (300);
	l_http_request := UTL_HTTP.begin_request (p_url);
	l_http_response := UTL_HTTP.get_response (l_http_request);

	BEGIN
		LOOP
			UTL_HTTP.read_raw (l_http_response, l_raw, 32766);
			DBMS_LOB.writeappend (l_report_blob, UTL_RAW.LENGTH (l_raw), l_raw);
		--UTL_HTTP.read_text (l_http_response, l_text, 32766);
		--DBMS_LOB.writeappend (l_report_clob, LENGTH (l_text), l_text);
		END LOOP;
	EXCEPTION
		WHEN UTL_HTTP.end_of_body THEN
			UTL_HTTP.end_response (l_http_response);
	END;

	p_url :=		'http://sp13pruebas.sas.junta-andalucia.es/_api/web/GetFolderByServerRelativeUrl(''/Documentos%20compartidos'')/Files/add(url='''
					 || reportId --|| '_'
					 --|| TO_CHAR (SYSDATE, 'YYMMDD_HH24MMSS')
					 || '.txt'',overwrite=true)';
	UTL_HTTP.set_transfer_timeout (300);
	l_http_request := UTL_HTTP.begin_request (p_url,
																						PANDAS_095_SEND_TO_SHAREP.const_sharepoint_service_meth,
																						PANDAS_095_SEND_TO_SHAREP.const_sharepoint_service_prot);

	UTL_HTTP.set_header (l_http_request, 'X-RequestDigest', l_ntlm_request_digest_str);
	--UTL_HTTP.set_header (l_http_request, 'Accept', 'application/json;odata=verbose');
	--UTL_HTTP.set_header (l_http_request, 'Connection', 'keep-alive');
	--UTL_HTTP.set_header (l_http_request, 'Content-Encoding', 'gzip');
	UTL_HTTP.set_header (l_http_request, 'Transfer-Encoding', 'chunked');

	--DBMS_LOB.createtemporary (l_gzcompressed_blob, FALSE);
	--UTL_COMPRESS.lz_compress (src => l_report_blob, dst => l_gzcompressed_blob);
    --UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (l_gzcompressed_blob));
    UTL_HTTP.set_header (l_http_request, 'Content-Length', LENGTH (l_report_blob));

	v_txt := l_report_blob;
	--v_txt := l_gzcompressed_blob;

	LOOP
		EXIT WHEN l_offset > DBMS_LOB.getlength (v_txt);
		UTL_HTTP.WRITE_RAW (l_http_request, DBMS_LOB.SUBSTR (v_txt, 512, l_offset));
		l_offset := l_offset + 512;
	END LOOP;

	l_http_response := UTL_HTTP.get_response (l_http_request);

	FOR i IN 1 .. UTL_HTTP.GET_HEADER_COUNT (l_http_response) LOOP
		UTL_HTTP.GET_HEADER (l_http_response,
												 i,
												 name,
												 VALUE);
		DBMS_OUTPUT.PUT_LINE (name || ': ' || VALUE);
	END LOOP;

	BEGIN
		LOOP
			UTL_HTTP.read_text (l_http_response, l_text, 32766);
			--DBMS_OUTPUT.put_line ('resp: ' || l_text);
			UPDATE MSTR_UTL_SHAREPOINT_LOG
				 SET SP_RESPONSE = l_text;
		END LOOP;
	EXCEPTION
		WHEN UTL_HTTP.end_of_body THEN
			UTL_HTTP.end_response (l_http_response);
	END;

	sys.ntlm_http_pkg.end_request;
	DBMS_LOB.freetemporary (l_report_blob);
	DBMS_LOB.freetemporary (l_gzcompressed_blob);
	COMMIT;
--EXCEPTION
-- WHEN OTHERS THEN
-- UTL_HTTP.end_response (l_http_response);
-- RAISE;
END;
/