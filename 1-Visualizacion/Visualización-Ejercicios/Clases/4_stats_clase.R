# Visualización - Clase 4 - Stats ----------------------------------------------------------

library(tidyverse)
diamonds
?diamonds

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

# nota que en el eje de las y viene la palabra count
# esta variablo no existe en la bd
# de dónde viene?
# La gráfica de dispersión grafica los datos crudos
# no pasa lo mismo con la gráfica de barras: calculan nuevos valores

# las gráficas de barras, los histogramas, los polígonos de frecuencia.
# pone los datos en un recipiente y luego grafica el conteo de datosen cada recipiente

# gráficas suavizadoras: ajustan un modelo a los datos y luego grafican
# predicciones del modelo

# diagrama de caja y brazos:  computa un resumen robusto de la distribución
# y muestra una caja con cierto formato.

# el algoritmo para calcular nuevos valores de una gráfica se llama stat
# (transformación estadística)

?geom_bar

ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )