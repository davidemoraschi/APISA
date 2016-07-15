/* Formatted on 29/05/2013 15:51:58 (QP5 v5.163.1008.3004) */
SELECT xmltype (ETL_UTIL_CLIENTE_CITAWEB.SOAP_MESSAGE) soap_message FROM DUAL;

SELECT DBMS_XMLGEN.CONVERT ( (ETL_UTIL_CLIENTE_CITAWEB.SOAP_MESSAGE)) soap_message FROM DUAL;

SELECT xmltype (
          '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><m:Solicitud xmlns:m="http://tempuri.org/usuarioBDU/message/"><sXML>'
          || DBMS_XMLGEN.CONVERT ( (ETL_UTIL_CLIENTE_CITAWEB.SOAP_MESSAGE))
          || '</sXML></m:Solicitud></SOAP-ENV:Body></SOAP-ENV:Envelope>')
  FROM DUAL;

DECLARE
   v_soap_message   CLOB := '<ok />';
BEGIN
   v_soap_message :=
      xmltype (
         '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" SOAP-ENV:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><SOAP-ENV:Body><m:Solicitud xmlns:m="http://tempuri.org/usuarioBDU/message/"><sXML>'
         || DBMS_XMLGEN.CONVERT ( (ETL_UTIL_CLIENTE_CITAWEB.SOAP_MESSAGE))
         || '</sXML></m:Solicitud></SOAP-ENV:Body></SOAP-ENV:Envelope>').getclobval ();
   --     INTO v_soap_message
   --     FROM DUAL;

   ETL_UTIL_CLIENTE_CITAWEB.dpr_clobToFile (p_fileName   => 'SOAP-ENV.XML',
                                            p_dir        => 'MSTR_CONSULTAS_INFHOS_FILES',
                                            p_clob       => v_soap_message);
END;

EXEC ETL_UTIL_CLIENTE_CITAWEB.SAVE_SOAP_ENVELOPE;

DECLARE
   v_xml   XMLTYPE;
BEGIN
   ETL_UTIL_CLIENTE_CITAWEB.get_xml_file_from_os (oracle_directory => 'MSTR_CONSULTAS_INFHOS_FILES', filename => 'citaweb.xml', o_xml => v_xml);
END;


exec UTL_FILE.fremove ('MSTR_CONSULTAS_INFHOS_FILES', 'citaweb.xml');