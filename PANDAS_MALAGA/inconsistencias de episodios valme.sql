/* Formatted on 9/9/2014 1:33:37 PM (QP5 v5.163.1008.3004) */
SELECT '02017' AREA,
       TRUNC (SYSDATE) NATID_FECHA,
       EPISODIO_ID,
       CODIGO_ESTRUCTURA,
       UBI_NOMBRE
  FROM REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@GRE43DAE JOIN REP_PRO_EST.UBICACIONES@GRE43DAE ON (CODIGO_ESTRUCTURA = UBI_CODIGO)
 WHERE EPISODIO_ID NOT IN (SELECT EPISODIO_ID FROM REP_HIS_OWN.ADM_EPISODIO@GRE43DAE);

 --SEE43DAE

SELECT '02004' AREA,
       TRUNC (SYSDATE) NATID_FECHA,
       EPISODIO_ID,
       CODIGO_ESTRUCTURA,
       UBI_NOMBRE
  FROM REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@SEE43DAE JOIN REP_PRO_EST.UBICACIONES@SEE43DAE ON (CODIGO_ESTRUCTURA = UBI_CODIGO)
 WHERE EPISODIO_ID NOT IN (SELECT EPISODIO_ID FROM REP_HIS_OWN.ADM_EPISODIO@SEE43DAE);