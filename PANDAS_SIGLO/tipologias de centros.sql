/* Formatted on 20/01/2014 21:42:03 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */

-- Centros de Consumo que No reparten ni Servicio ni UGC
SELECT CENTROCONSUMO, SUM(IMPORTESALIDA) FROM
REP_PRO_SIGLO.ALM_SALIDAALMACEN@SYG
WHERE CENTROCONSUMO IN
(
SELECT ID
	FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO@SYG CC
 WHERE id NOT IN (SELECT centroconsumo FROM REP_PRO_SIGLO.ORG_SERVICIOCC@SYG WHERE ESTADO = 'CONFIRMADO') AND id NOT IN (SELECT centroconsumo FROM REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICACC@SYG WHERE ESTADO = 'CONFIRMADO')
 AND CC.ESTADO = 'CONFIRMADO'
 )
 AND FECHA BETWEEN '01-JAN-2013' AND '31-DEC-2013'
 GROUP BY CENTROCONSUMO
/
-- Centros de Consumo que reparten solo a UGC
SELECT CENTROCONSUMO, SUM(IMPORTESALIDA) FROM
REP_PRO_SIGLO.ALM_SALIDAALMACEN@SYG
WHERE CENTROCONSUMO IN
(
SELECT ID
    FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO@SYG CC
 WHERE id NOT IN (SELECT centroconsumo FROM REP_PRO_SIGLO.ORG_SERVICIOCC@SYG WHERE ESTADO = 'CONFIRMADO') AND id IN (SELECT centroconsumo FROM REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICACC@SYG WHERE ESTADO = 'CONFIRMADO')
 AND CC.ESTADO = 'CONFIRMADO'
 )
 AND FECHA BETWEEN '01-JAN-2013' AND '31-DEC-2013'
 GROUP BY CENTROCONSUMO
 /
 -- Centros de Consumo qu ereparten solo a Servicio
 SELECT CENTROCONSUMO, SUM(IMPORTESALIDA) FROM
REP_PRO_SIGLO.ALM_SALIDAALMACEN@SYG
WHERE CENTROCONSUMO IN
(
SELECT ID
    FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO@SYG CC
 WHERE id  IN (SELECT centroconsumo FROM REP_PRO_SIGLO.ORG_SERVICIOCC@SYG WHERE ESTADO = 'CONFIRMADO') AND id NOT IN (SELECT centroconsumo FROM REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICACC@SYG WHERE ESTADO = 'CONFIRMADO')
 AND CC.ESTADO = 'CONFIRMADO'
  )
 AND FECHA BETWEEN '01-JAN-2013' AND '31-DEC-2013'
 GROUP BY CENTROCONSUMO
 /
 
-- Centros de Consumo que reparte a Servicios y UGC
SELECT CENTROCONSUMO, SUM(IMPORTESALIDA) FROM
REP_PRO_SIGLO.ALM_SALIDAALMACEN@SYG
WHERE CENTROCONSUMO IN
(
SELECT ID
    FROM REP_PRO_SIGLO.ORG_CENTROCONSUMO@SYG CC
 WHERE id IN (SELECT centroconsumo FROM REP_PRO_SIGLO.ORG_SERVICIOCC@SYG WHERE ESTADO = 'CONFIRMADO') AND id IN (SELECT centroconsumo FROM REP_PRO_SIGLO.ORG_UNIDADGESTIONCLINICACC@SYG WHERE ESTADO = 'CONFIRMADO')
 AND CC.ESTADO = 'CONFIRMADO'
  )
 AND FECHA BETWEEN '01-JAN-2013' AND '31-DEC-2013'
 GROUP BY CENTROCONSUMO
 /