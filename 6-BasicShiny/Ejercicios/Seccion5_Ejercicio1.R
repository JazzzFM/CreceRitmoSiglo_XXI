# Planteamiento del problema ----------------------------------------------
"
1 - ¿Qué sucede si inviertes `fct_infreq()` y `fct_lump()` en el código que reduce
    las tablas de resumen?
"

# Resolución del problema ----------------------------------------------
"
Como usaremos los conjuntos de datos sobre lesiones,
productos y población que aparecen aquí:
https://github.com/hadley/mastering-shiny/blob/master/neiss/data.R.

Cambiar el orden de fct_infreq() y fct_lump() solo cambiará el orden
de los niveles de los factores.

En particular, la función fct_infreq() ordena los niveles de los factores
por frecuencia, y la función fct_lump() también ordena los niveles de los
factores por frecuencia, pero solo mantendrá los n factores principales y
etiquetará el resto como Other.

Veamos los cinco niveles principales en términos de recuento dentro de la
columna de diagnóstico en el conjunto de datos de lesiones:
"
____ %>%
  group_by(___) %>%
  count() %>%
  arrange(-n) %>%
  head(5)
"
Si aplicamos fct_infreq() primero, reordenará los niveles de factor en orden
descendente como se ve en la salida anterior. Si luego aplicamos fct_lump(),
entonces agrupará todo después del enésimo nivel más comúnmente visto.
"
diag <- ___ %>%
  mutate(____ = fct_lump(fct_infreq(___), n = 5)) %>%
  pull(___)

levels(___)

"
Por el contrario, si aplicamos fct_lump() primero, etiquetará el nivel de factor
visto con más frecuencia como 'Other'. 

Si luego aplicamos fct_infreq(), entonces etiquetará el primer nivel como “Other”
y no como “Other o no declarado”, como era el caso del código anterior.
"
diag <- ___ %>%
  mutate(___ = fct_infreq(fct_lump(___, n = 5))) %>%
  pull(___)

levels(___)