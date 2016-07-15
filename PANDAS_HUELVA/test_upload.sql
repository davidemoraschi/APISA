/* Formatted on 02/05/2013 13:38:59 (QP5 v5.163.1008.3004) */
EXEC PANDAS_091_UPLOAD_TO_SHAREP.RETRY_N_TIMES(p_payload => '<table border="1"><tr><th>Header 1</th><th>Header 2</th></tr><tr><td>row 1, cell 1</td><td>row 1, cell 2</td></tr><tr><td>row 2, cell 1</td><td>row 2, cell 2</td></tr></table> ' ,p_filename => 'PANDAS_Report',p_fileext => '.htm');

--select PANDAS_091_UPLOAD_TO_SHAREP.TEXT_FILE() from dual;

create package body PANDAS_092_MAKE_CALL
as
end; 
/