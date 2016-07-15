/* Formatted on 14/04/2014 13:56:20 (QP5 v5.163.1008.3004) PANDAS Copyright (c) 2013 -Davide Moraschi (davidem@eurostrategy.net)
Todos los derechos reservados. Prohibida su reproducción Total o Parcial. */
SELECT adm.fch_alta
			,tr.fch_apertura
			,tr.fch_cierre
			,cah.cah_codigo
			,cah.cah_nombre
			,adm.usuario
	FROM REP_HIS_OWN.ADM_TRASLADO@SEE41DAE tr
			,REP_HIS_OWN.ADM_ADMISION@SEE41DAE adm
			,REP_HIS_OWN.COM_UBICACION_GESTION_LOCAL@SEE41DAE loc
			,rep_pro_est.centros_ah@SEE41DAE cah
			,rep_pro_est.ubicaciones@SEE41DAE ubi
 -- ,own_kpi.uf_con_padres ufloc
 WHERE		 tr.admision = adm.admision_id
			 AND tr.ubic_terminal = loc.codigo_estructura
			 AND loc.codigo_estructura = ubi.ubi_codigo
			 AND ubi.ubi_cah_codigo = cah.cah_codigo
			 AND (tr.fch_cierre >= TRUNC (ADD_MONTHS (TRUNC (SYSDATE, 'MM'), -12), 'mm') OR tr.fch_cierre IS NULL)
			 AND adm.modalidad_asist = 1
			 AND ADM.EPIS_CONTAB = 1
			 AND TRUNC (tr.fch_apertura, 'dd') < TRUNC (SYSDATE, 'dd')
			 --AND loc.unidad_funcional = ufloc.uf_codigo
			 AND tr.fch_apertura > ADD_MONTHS (SYSDATE, -36);