DROP PUBLIC DATABASE LINK SYG;

CREATE PUBLIC DATABASE LINK SYG
 CONNECT TO LEC_STI_PANDAS
 IDENTIFIED BY "pandas"
 USING 'SIGLO_CENTRALIZADA';