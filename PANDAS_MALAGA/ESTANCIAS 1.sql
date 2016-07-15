/* Formatted on 05/06/2014 9:51:04 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
CREATE TABLE TEMP_ESTANCIAS_A102037
NOLOGGING
NOMONITORING
NOPARALLEL AS
	SELECT adm.fch_alta
				,tr.fch_apertura
				,tr.fch_cierre
				,cah.cah_codigo
				,cah.cah_nombre
				,uf.uf_padre AS uf_codigo
				,uf.uf_padre_nombre AS uf_nombre
				,adm.usuario
				,ufloc.uf_padre AS uf_codigo_loc
				,ufloc.uf_padre_nombre AS uf_nombre_loc
		FROM REP_HIS_OWN.ADM_TRASLADO@HUE40DAE tr
				,REP_HIS_OWN.ADM_ADMISION@HUE40DAE adm
				,REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@HUE40DAE loc
				,rep_pro_est.centros_ah@HUE40DAE cah
				,rep_pro_est.ubicaciones@HUE40DAE ubi
				,OWN_KPI.UF_CON_PADRES@HUE40DAE uf
				,OWN_KPI.UF_CON_PADRES@HUE40DAE ufloc
	 WHERE		 tr.admision = adm.admision_id
				 AND tr.unidad_funcional = uf.uf_codigo
				 AND tr.ubic_terminal = loc.codigo_estructura
				 AND loc.unidad_funcional = ufloc.uf_codigo
				 AND loc.codigo_estructura = ubi.ubi_codigo
				 AND ubi.ubi_cah_codigo = cah.cah_codigo
				 AND (tr.fch_cierre >= ADD_MONTHS (TRUNC (SYSDATE, 'MM'), -12) OR tr.fch_cierre IS NULL)
				 AND adm.modalidad_asist = 1
				 AND ADM.EPIS_CONTAB = 1
				 AND TRUNC (tr.fch_apertura, 'dd') < TRUNC (SYSDATE, 'dd')
				 AND tr.fch_apertura > ADD_MONTHS (SYSDATE, -36)