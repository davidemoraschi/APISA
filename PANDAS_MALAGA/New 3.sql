SELECT * FROM
MSTR_DET_CAMAS_HISTORICO H
WHERE H.NATID_AREA_HOSPITALARIA = '02037'
AND H.NATID_FECHA = '21-MAY-2014'
AND H.NATID_UNIDAD_FUNCIONAL3_RESP IS NULL
AND H.NATID_EPISODIO > 0;
/
SELECT * FROM
REP_HIS_OWN.ADM_EPISODIO@HUE40DAE
WHERE EPISODIO_ID = 1766908;
/
SELECT * FROM
REP_HIS_OWN.ADM_EPIS_DETALLE@HUE40DAE
WHERE EPISODIO_ID = 1766908
/
SELECT * FROM
REP_HIS_OWN.ADM_ADMISION@HUE40DAE
WHERE ADMISION_ID = 1711129
/