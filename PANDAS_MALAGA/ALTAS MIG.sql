/* Formatted on 10/6/2014 1:43:31 PM (QP5 v5.163.1008.3004) */
  SELECT TRUNC (fch_alta, 'MONTH'), COUNT (1)
    FROM REP_HIS_OWN.ADM_ADMISION@SEE41DAE
   WHERE modalidad_asist = 1 AND epis_contab = 1 AND fch_alta IS NOT NULL AND TRUNC (fch_alta) > TRUNC (ADD_MONTHS (SYSDATE, -12), 'MM')
GROUP BY TRUNC (fch_alta, 'MONTH');