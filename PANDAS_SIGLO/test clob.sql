/* Formatted on 21/02/2014 11:45:56 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
create or replace procedure write_txt as
	l_clob NCLOB;
	v_file UTL_FILE.FILE_TYPE;
	l_clob_len NUMBER;
	l_pos NUMBER := 1;
	l_buffer RAW (32000);
	l_amount BINARY_INTEGER := 32000;
	x NUMBER;
	RecordsAffected PLS_INTEGER := 0;
-- n_endline NUMBER;
-- l_buffer VARCHAR2 (32767);
-- var_clob_line_count NUMBER;
-- v_from NUMBER;
-- v_len NUMBER;
-- var_clob_line VARCHAR2 (4000);
BEGIN
	l_clob := PANDAS_001_REPORT_EXECUTE_v9.txt (reportId => 'A921426E40742431617FD2AE0ACBA7B8', projectName => 'Cuadro+de+Mando+SIGLO');
	l_clob_len := DBMS_LOB.getlength (l_clob);
	x := l_clob_len;
	-- Open the destination file.

	-- v_name := Rec.image_name || '.' || Rec.image_extension;
	v_file := UTL_FILE.FOPEN ('MSTR_SEND_TO_SHAREPOINT'
													 ,'2456710A921426E40742431617FD2AE0ACBA7B8.txt'
													 ,'wb'
													 ,32767);
	IF l_clob_len < 32000 THEN
		DBMS_LOB.read (l_clob
									,l_clob_len
									,l_pos
									,l_buffer);
		UTL_FILE.put_raw (v_file, l_buffer, TRUE);
		UTL_FILE.fflush (v_file);
	ELSE
		WHILE l_pos < l_clob_len AND l_amount > 0 LOOP
			DBMS_LOB.read (l_clob
										,l_amount
										,l_pos
										,l_buffer);
			UTL_FILE.put_raw (v_file, l_buffer, TRUE);
			UTL_FILE.fflush (v_file);
			-- set the start position for the next cut
			l_pos := l_pos + l_amount;
			-- set the end position if less than 32000 bytes
			x := x - l_amount;
			IF x < 32000 THEN
				l_amount := x;
			END IF;
		END LOOP;
		l_pos := 1;
		l_buffer := NULL;
		l_clob := NULL;
		l_amount := 32000;
	END IF;
	RecordsAffected := RecordsAffected + 1;
	UTL_FILE.FCLOSE (v_file);
--end if;
END;