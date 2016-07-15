--/* Formatted on 11/11/2013 17:02:38 (QP5 v5.163.1008.3004) */
--SELECT PANDAS_095_SEND_TO_SHAREP.XREQUESTDIGEST ('http://sp13pruebas.sas.junta-andalucia.es/_api/contextinfo') DV FROM DUAL;
--
--/

--EXEC send_to_sp2013_textfile_v2(reportId => 'CFB0FF9411E3477D05D30080EF654A4D', projectName=>'SIGLO_DESARROLLO');
--
EXEC send_to_SP2013_excelfile_v2(reportId => 'A0A6253D4CA29DD57030D68E934D3EFA', projectName=>'SIGLO_DESARROLLO');
/
EXEC send_to_sp2013_textfile_v2(reportId => '043AF576402FE986B16A129BDC30FA87', projectName=>'SIGLO_DESARROLLO');
/
EXEC send_to_sp2013_textfile_v2(reportId => '7B6EC0B64FEDD1D2B499A6AD959F463F', projectName=>'SIGLO_DESARROLLO');
/
--EXEC send_to_sp2013_binary(reportId => 'A0A6253D4CA29DD57030D68E934D3EFA', projectName=>'SIGLO_DESARROLLO');
--/
--EXEC send_to_SP2013_long_text(reportId => 'A0A6253D4CA29DD57030D68E934D3EFA', projectName=>'SIGLO_DESARROLLO');
--/
--EXEC PANDAS_095_SEND_TO_SHAREP.TXT_FILE (p_SharePointSiteURL =>  'http://sp13pruebas.sas.junta-andalucia.es',  p_FileContent  => 'aaaa');