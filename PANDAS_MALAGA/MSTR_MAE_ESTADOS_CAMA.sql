/* Formatted on 20/03/2014 10:34:31 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
CREATE OR REPLACE FORCE VIEW MSTR_MAE_ESTADOS_CAMA
(
	NATID_ESTADO
 ,DESCR_ESTADO
) AS
	SELECT CODIGO NATID_ESTADO, NOMBRE DESCR_ESTADO FROM REP_HIS_OWN.COM_M_ESTADO_UBICACION@SEE41DAE;
