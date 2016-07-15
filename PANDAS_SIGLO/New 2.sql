/* Formatted on 30/01/2014 12:20:57 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
--http://pandas.sas.junta-andalucia.es/siglo/_vti_bin/ListData.svc/PANDAS_ETL
DECLARE
	v_elapsed NUMBER := 10;
    v_last_refresh DATE := SYSDATE;
    v_return BOOLEAN ;
BEGIN
	v_return := MSTR.PANDAS_090_POST_TO_SHAREPOINT.LISTDATA (
		listdata_url => 'http://pandas.sas.junta-andalucia.es/siglo/_vti_bin/ListData.svc/PANDAS_ETL'
	 ,listdata_payload => '{ Title: "Carga Censo de Camas", Content: "'
											 || '<table border=''1'' cellpadding=''3''><tr><td bgcolor=''#CEA539''>Última Ejecución</td><td bgcolor=''#CEA539''>Duración (min.)</td><td bgcolor=''#CEA539''>Fecha Replica</td></tr><tr><td bgcolor=''#232325''>'
											 || TO_CHAR (SYSDATE, 'dd-mon hh24:mi')
											 || '</td><td>'
											 || ROUND (v_elapsed, 2)
											 || '</td><td>'
											 || TO_CHAR (v_last_refresh, 'dd-mon hh24:mi')
											 || '</td></tr></table> '
											 || '", Result: "SUCCESS"  }');
END;