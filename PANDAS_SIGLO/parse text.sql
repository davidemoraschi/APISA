/* Formatted on 21/02/2014 14:00:18 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
--
--INSERT INTO MSTR_UTL_CLOB
--	SELECT PANDAS_001_REPORT_EXECUTE_v9.txt (reportId => 'A921426E40742431617FD2AE0ACBA7B8', projectName => 'Cuadro+de+Mando+SIGLO') FROM DUAL;
--
DECLARE
	l_clob CLOB;
	l_line VARCHAR2 (32767);
	l_line_report_title VARCHAR2 (32767);
	n_amount NUMBER;
	last_amount NUMBER;
BEGIN
	SELECT c_clob INTO l_clob FROM MSTR_UTL_CLOB;
	-- l_clob := PANDAS_001_REPORT_EXECUTE_v9.txt (reportId => 'A921426E40742431617FD2AE0ACBA7B8', projectName => 'Cuadro+de+Mando+SIGLO');
	n_amount := DBMS_LOB.INSTR (lob_loc => l_clob
														 ,pattern => CHR (13) || CHR (10)
														 ,offset => 1
														 ,nth => 1);
	l_line_report_title := DBMS_LOB.SUBSTR (lob_loc => l_clob, amount => n_amount, offset => 1);
	last_amount := n_amount; -- + 1;
	n_amount := DBMS_LOB.INSTR (lob_loc => l_clob
														 ,pattern => CHR (13) || CHR (10)
														 ,offset => last_amount + 1
														 ,nth => 1);
	l_line := DBMS_LOB.SUBSTR (lob_loc => l_clob, amount => n_amount - last_amount, offset => last_amount);
	last_amount := n_amount;
	DBMS_OUTPUT.put_line ('{"d":{"results":[{');
	FOR i IN 1 .. 20 LOOP
		n_amount := DBMS_LOB.INSTR (lob_loc => l_clob
															 ,pattern => CHR (13) || CHR (10)
															 ,offset => last_amount + 1
															 ,nth => 1);
		l_line := REPLACE (DBMS_LOB.SUBSTR (lob_loc => l_clob, amount => n_amount - last_amount, offset => last_amount), CHR (13) || CHR (10), NULL);
		DBMS_OUTPUT.put_line ('"line":"' || l_line || '"},{');
		last_amount := n_amount;
		EXIT WHEN n_amount = 0;
	END LOOP;
	DBMS_OUTPUT.put_line ('}]}}');
END;