select FAC_FACTURALINEA.id, gcdirecta, descripcion
from rep_pro_siglo.FAC_FACTURALINEA@syg
 join rep_pro_siglo.cat_articulo@syg on (gcdirecta = cat_articulo.id )
 order by 1 desc