CREATE PUBLIC DATABASE LINK EXP
 CONNECT TO CONS_REP_HUVR
 IDENTIFIED BY <PWD>
 USING 'SEE41DAE';
CREATE PUBLIC DATABASE LINK RND
 CONNECT TO OPERACIONALES
 IDENTIFIED BY <PWD>
 USING 'RND';
CREATE PUBLIC DATABASE LINK VAL
 CONNECT TO CONSULTA_REPLICA
 IDENTIFIED BY <PWD>
 USING 'HUV40DAE';
