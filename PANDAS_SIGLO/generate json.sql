/* Formatted on 22/02/2014 12:02:51 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
--
--INSERT INTO MSTR_UTL_CLOB
--	SELECT PANDAS_001_REPORT_EXECUTE_v9.txt (reportId => 'A921426E40742431617FD2AE0ACBA7B8', projectName => 'Cuadro+de+Mando+SIGLO') FROM DUAL;
--
DECLARE
	l_clob CLOB;
	l_line VARCHAR2 (32767);
	l_output_line VARCHAR2 (32767);
	l_line_report_title VARCHAR2 (32767);
	n_amount NUMBER;
	last_amount NUMBER;
	v_name_array apex_application_global.vc_arr2;
	v_value_array apex_application_global.vc_arr2;
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
	-- Field names
	n_amount := DBMS_LOB.INSTR (lob_loc => l_clob
														 ,pattern => CHR (13) || CHR (10)
														 ,offset => last_amount + 1
														 ,nth => 1);
	l_line := REPLACE (DBMS_LOB.SUBSTR (lob_loc => l_clob, amount => n_amount - last_amount, offset => last_amount), CHR (13) || CHR (10), NULL);
	v_name_array := APEX_UTIL.string_to_table (l_line, '|');

	-- FOR i IN 1 .. v_name_array.COUNT LOOP
	-- DBMS_OUTPUT.put_line ('Col' || i || ':' || v_name_array (i));
	-- END LOOP;
	--DBMS_OUTPUT.put_line (v_name_array (1));
	--DBMS_OUTPUT.put_line (v_name_array (2));
	--DBMS_OUTPUT.put_line (v_name_array (3));
	--DBMS_OUTPUT.put_line(l_line);
	last_amount := n_amount;

	DBMS_OUTPUT.put_line ('{"d":{"results":[{');
	FOR i IN 1 .. 100 LOOP
		n_amount := DBMS_LOB.INSTR (lob_loc => l_clob
															 ,pattern => CHR (13) || CHR (10)
															 ,offset => last_amount + 1
															 ,nth => 1);
		l_line := REPLACE (DBMS_LOB.SUBSTR (lob_loc => l_clob, amount => n_amount - last_amount, offset => last_amount), CHR (13) || CHR (10), NULL);
		v_value_array := APEX_UTIL.string_to_table (l_line, '|');
		--DBMS_OUTPUT.put_line ('"line":"' || l_line || '"},{');

		FOR i IN 1 .. v_value_array.COUNT LOOP
			l_output_line := l_output_line || ('"' || NVL (v_name_array (i), 'col' || TO_CHAR (i)) || '":"' || v_value_array (i));
			IF i = v_value_array.COUNT THEN
				l_output_line := l_output_line || ('"},{');
			ELSE
				l_output_line := l_output_line || ('",');
			END IF;
		END LOOP;

		DBMS_OUTPUT.put_line (l_output_line);
		l_output_line := '';
		last_amount := n_amount;
		EXIT WHEN n_amount = 0;
	END LOOP;
	DBMS_OUTPUT.put_line ('}]}}');
END;