/* Formatted on 26/08/2013 18:32:43 (QP5 v5.163.1008.3004) */
--DROP TABLE TMP_GA02B_01;

--/

CREATE TABLE TMP_GA02B_01
NOLOGGING
AS
     SELECT B.FECHAENTREGA NATID_DIA, PED.ORGANOGESTOR NATID_ORGANOGESTOR, SUM (PL.IMPORTELINEA) GA02B
       FROM REP_PRO_SEV.PED_PEDIDOLINEA@SIG PL
            JOIN (  SELECT MIN (ENT.FECHAENTREGA) FECHAENTREGA, ENT.PEDIDOLINEA
                      FROM REP_PRO_SEV.PED_PROGRAMENTREGA@SIG ENT
                     WHERE ENT.ACTIVO = 'T'
                  GROUP BY ENT.PEDIDOLINEA) B
               ON (PEDIDOLINEA = PL.ID)
            JOIN REP_PRO_SEV.PED_PEDIDO@SIG PED
               ON (PED.ID = PL.PEDIDO)
      WHERE PL.ACTIVO = 'T'
   GROUP BY B.FECHAENTREGA, PED.ORGANOGESTOR;

/

INSERT INTO TMP_GA02B_01
     SELECT B.FECHAENTREGA NATID_DIA, PED.ORGANOGESTOR NATID_ORGANOGESTOR, SUM (PL.IMPORTELINEA) GA02B
       FROM REP_PRO_SEV.PED_PEDIDOLINEA@SIG PL
            JOIN (  SELECT MIN (ENT.FECHAENTREGA) FECHAENTREGA, ENT.PEDIDOLINEA
                      FROM REP_PRO_SEV.PED_PROGRAMENTREGA@SIG ENT
                     WHERE ENT.ACTIVO = 'F'
                  GROUP BY ENT.PEDIDOLINEA) B
               ON (PEDIDOLINEA = PL.ID)
            JOIN REP_PRO_SEV.PED_PEDIDO@SIG PED
               ON (PED.ID = PL.PEDIDO)
      WHERE PL.ACTIVO = 'T'
   GROUP BY B.FECHAENTREGA, PED.ORGANOGESTOR;

/

INSERT INTO TMP_GA02B_01
     SELECT PED.FECHAPEDIDO NATID_DIA, PED.ORGANOGESTOR NATID_ORGANOGESTOR, SUM (PL.IMPORTELINEA) GA02B
       FROM REP_PRO_SEV.PED_PEDIDO@SIG PED JOIN REP_PRO_SEV.PED_PEDIDOLINEA@SIG PL ON (PL.PEDIDO = PED.ID)
      WHERE PL.ACTIVO = 'T'
            AND PL.ID NOT IN (SELECT DISTINCT ENT.PEDIDOLINEA
                                FROM REP_PRO_SEV.PED_PROGRAMENTREGA@SIG ENT)
   GROUP BY PED.FECHAPEDIDO, PED.ORGANOGESTOR;

/


DROP TABLE MSTR_DET_GA02B;

/

CREATE TABLE MSTR_DET_GA02B
NOLOGGING
AS
     SELECT NATID_DIA, NATID_ORGANOGESTOR, SUM (GA02B) GA02B
       FROM TMP_GA02B_01
   GROUP BY NATID_DIA, NATID_ORGANOGESTOR;

/

DROP TABLE TMP_GA02B_01;

/

   PURGE RECYCLEBIN;