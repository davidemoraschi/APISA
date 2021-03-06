/* Formatted on 27/03/2014 10:44:33 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
DROP TABLE MSTR_MAE_TIPOS_CAMA;
CREATE TABLE MSTR_MAE_TIPOS_CAMA
(
	NATID_TIPO_CAMA
 ,DESCR_TIPO_CAMA
 ,CONSTRAINT MSTR_MAE_TIPOS_CAMA_PK PRIMARY KEY (NATID_TIPO_CAMA)
)
ORGANIZATION INDEX
NOLOGGING
NOMONITORING
NOPARALLEL
STORAGE (BUFFER_POOL KEEP) AS
	SELECT TUBI_CODIGO NATID_TIPO_CAMA, TUBI_DESCRIPCION DESCR_TIPO_CAMA FROM REP_PRO_EST.TIPOS_UBICACION@SEE41DAE;