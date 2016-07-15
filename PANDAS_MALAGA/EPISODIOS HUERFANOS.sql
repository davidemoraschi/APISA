/* Formatted on 9/8/2014 10:27:06 AM (QP5 v5.163.1008.3004) */
SELECT * FROM REP_HIS_OWN.ADM_EPISODIO@SEE41DAE;

/

SELECT *
  FROM REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@SEE43DAE
 WHERE EPISODIO_ID NOT IN (SELECT EPISODIO_ID FROM REP_HIS_OWN.ADM_EPIS_DETALLE@SEE43DAE);

/

CREATE TABLE MSTR_DET_EPISODIOS_HERFANOS
(
   NATID_AREA_HOSPITALARIA   VARCHAR2 (10),
   NATID_FECHA               DATE,
   NATID_EPISODIO            NUMBER,
   NATID_CAMA                VARCHAR2 (24),
   CONSTRAINT MSTR_DET_EPISODIOS_HERFANOS_PK PRIMARY KEY (NATID_AREA_HOSPITALARIA, NATID_FECHA, NATID_CAMA)
)
NOLOGGING
NOMONITORING
NOPARALLEL
/

BEGIN
   FOR C1 IN (SELECT NATID_AREA_HOSPITALARIA, DB_LINK_REPLICA
                FROM MSTR_UTL_LOCAL_CODIGOS
               WHERE ENABLED = 1)
   LOOP
      EXECUTE IMMEDIATE
            'INSERT INTO MSTR_DET_EPISODIOS_HERFANOS
      SELECT /*+DRIVING_SITE(ADM_EPISODIO)*/  '
         || C1.NATID_AREA_HOSPITALARIA
         || ', TRUNC(SYSDATE), EPISODIO_ID, CODIGO_ESTRUCTURA
        FROM REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@'
         || C1.DB_LINK_REPLICA
         || '
       WHERE EPISODIO_ID NOT IN (SELECT EPISODIO_ID FROM REP_HIS_OWN.ADM_EPISODIO@'
         || C1.DB_LINK_REPLICA|| ')';
   END LOOP;
END;