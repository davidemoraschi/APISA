DROP TABLE MSTR_DET_CO01B;

CREATE TABLE MSTR_DET_CO01B
AS
SELECT NVL(TRUNC(PED.FECHAPEDIDO), TO_DATE('01/01/1900','DD/MM/YYYY')) NATID_DIA, PED.EMPRESA NATID_PROVEEDOR, NVL(DEC.DES,-1) NATID_ORGANOGESTOR,  (CASE WHEN NIV.NIVEL <> 15 THEN -1 ELSE PRO.ECONOMICA END) NATID_ECONOMICA_N4, LIN.ARTICULO NATID_ARTICULO, COUNT(LIN.ID) CO01B
FROM REP_PRO_SIGLO.PED_PEDIDO@SYG PED,  
          REP_PRO_SIGLO.PED_PEDIDOLINEA@SYG LIN, 
          REP_PRO_SIGLO.PED_PROPUESTASL@SYG PRO, 
          REP_PRO_SIGLO.CTR_EXPEDIENTE@SYG EXP,
          (SELECT CONNECT_BY_ROOT ID ORI, ID DES  
          FROM REP_PRO_SIGLO.ORG_ORGANOGESTOR@SYG
          WHERE PLATAFORMA IS NULL AND TIPO = 5012
          CONNECT BY PRIOR PLATAFORMA=ID) DEC,
          REP_PRO_SIGLO.CAT_NIVELVALOR@SYG NIV
WHERE PED.ID=LIN.PEDIDO AND
LIN.PROPUESTALINEA=PRO.ID AND
PED.EXPEDIENTE=EXP.ID (+) AND
PED.ORGANOGESTOR=DEC.ORI(+) AND
NIV.ID=PRO.ECONOMICA
GROUP BY NVL(TRUNC(PED.FECHAPEDIDO), TO_DATE('01/01/1900','DD/MM/YYYY')), PED.EMPRESA, DEC.DES, (CASE WHEN NIV.NIVEL <> 15 THEN -1 ELSE PRO.ECONOMICA END), LIN.ARTICULO;


DROP TABLE MSTR_DET_CO02B;          
          
CREATE TABLE MSTR_DET_CO02B
AS          
SELECT NVL(TRUNC(PED.FECHAPEDIDO), TO_DATE('01/01/1900','DD/MM/YYYY')) NATID_DIA, PED.EMPRESA NATID_PROVEEDOR, NVL(DEC.DES,-1) NATID_ORGANOGESTOR,  (CASE WHEN NIV.NIVEL <> 15 THEN -1 ELSE PRO.ECONOMICA END) NATID_ECONOMICA_N4, LIN.ARTICULO NATID_ARTICULO, SUM(LIN.IMPORTELINEA) CO02B
FROM REP_PRO_SIGLO.PED_PEDIDO@SYG PED,  
          REP_PRO_SIGLO.PED_PEDIDOLINEA@SYG LIN, 
          REP_PRO_SIGLO.PED_PROPUESTASL@SYG PRO, 
          REP_PRO_SIGLO.CTR_EXPEDIENTE@SYG EXP,
          (SELECT CONNECT_BY_ROOT ID ORI, ID DES  
          FROM REP_PRO_SIGLO.ORG_ORGANOGESTOR@SYG
          WHERE PLATAFORMA IS NULL AND TIPO = 5012
          CONNECT BY PRIOR PLATAFORMA=ID) DEC,
          REP_PRO_SIGLO.CAT_NIVELVALOR@SYG NIV
WHERE PED.ID=LIN.PEDIDO AND
LIN.PROPUESTALINEA=PRO.ID AND
PED.EXPEDIENTE=EXP.ID (+) AND
PED.ORGANOGESTOR=DEC.ORI(+) AND
NIV.ID=PRO.ECONOMICA
GROUP BY NVL(TRUNC(PED.FECHAPEDIDO), TO_DATE('01/01/1900','DD/MM/YYYY')), PED.EMPRESA, DEC.DES, (CASE WHEN NIV.NIVEL <> 15 THEN -1 ELSE PRO.ECONOMICA END), LIN.ARTICULO;


DROP TABLE MSTR_DET_CO07B;          
          
CREATE TABLE MSTR_DET_CO07B
AS          
SELECT NVL(TRUNC(PED.FECHAPEDIDO), TO_DATE('01/01/1900','DD/MM/YYYY')) NATID_DIA, PED.EMPRESA NATID_PROVEEDOR, NVL(DEC.DES,-1) NATID_ORGANOGESTOR,  (CASE WHEN NIV.NIVEL <> 15 THEN -1 ELSE PRO.ECONOMICA END) NATID_ECONOMICA_N4, LIN.ARTICULO NATID_ARTICULO, COUNT(DISTINCT LIN.PEDIDO) CO07B
FROM REP_PRO_SIGLO.PED_PEDIDO@SYG PED,  
          REP_PRO_SIGLO.PED_PEDIDOLINEA@SYG LIN, 
          REP_PRO_SIGLO.PED_PROPUESTASL@SYG PRO, 
          REP_PRO_SIGLO.CTR_EXPEDIENTE@SYG EXP,
          (SELECT CONNECT_BY_ROOT ID ORI, ID DES  
          FROM REP_PRO_SIGLO.ORG_ORGANOGESTOR@SYG
          WHERE PLATAFORMA IS NULL AND TIPO = 5012
          CONNECT BY PRIOR PLATAFORMA=ID) DEC,
          REP_PRO_SIGLO.CAT_NIVELVALOR@SYG NIV
WHERE PED.ID=LIN.PEDIDO AND
LIN.PROPUESTALINEA=PRO.ID AND
PED.EXPEDIENTE=EXP.ID (+) AND
PED.ORGANOGESTOR=DEC.ORI(+) AND
NIV.ID=PRO.ECONOMICA
GROUP BY NVL(TRUNC(PED.FECHAPEDIDO), TO_DATE('01/01/1900','DD/MM/YYYY')), PED.EMPRESA, DEC.DES, (CASE WHEN NIV.NIVEL <> 15 THEN -1 ELSE PRO.ECONOMICA END), LIN.ARTICULO;
