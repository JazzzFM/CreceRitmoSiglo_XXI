# install.packages("tidyverse")


# Primeros pasos ----------------------------------------------------------

library(tidyverse)

# ¿Los autos con un motor más grande utilizan más combustible que l
# los autos con un motor más pequeño?
# ¿Cómo se ve la relación entre el tamaño de un motor y el uso de combustible? 
# ¿Positiva, negativa, lineal, no lineal?

mpg
?mpg
# displ (tamaño del motor)
# hwy (eficiencia del uso del combustible)

# Primera gráfica

ggplot(data = mpg) + # crea un sistema de coordenadas para agregar capas
  geom_point(mapping = aes(x = displ, y = hwy)) # agrega una capa de puntos a la gráfica y crea una gráfica de dispersión

# ¿Esta gráfica comprueba o refuta tu hipótesis acerca de la eficiencia del uso del combustible y el tamaño del motor?

# Plantilla

ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

# Ejercicio 

# ¿Qué ves si sólo corres ggplot(data = mpg)?
# Cuántos renglones y columnas tiene mpg?
# ¿Qué describe la variable drv? (utiliza ?mpg)
# Has una gráfica de dispersión entre las variables hwy vs cyl.
ggplot(data = mpg) + geom_point(mapping = aes(x = hwy, y = cyl))
# ¿Qué pasa si haces una gráfica de dispersión entre class y drv? 
#¿Por qué no es útil esta gráfica?
ggplot(data = mpg) + geom_point(mapping = aes(x = class, y = drv))

# Mapear elementos estéticos ----------------------------------------------
# El mejor valor de una imagen es cuando nos forza a notar lo que nunca esperamos ver.
# John Tukey

mpg %>% mutate(rojo =case_when(hwy > 20 & displ >5~T,
T~F)) %>% ggplot() + geom_point(aes(x =displ, y = hwy, color = rojo)) +
scale_color_manual(values = c("black","red")) + theme(legend.position = "none")

# Los puntos rojos parece ser que se salen de la relación lineal. 
# ¿Cómo podrías explicar estos carros?
# Una posible hipótesis es que sean carros híbridos.

# Podemos agregar una tercera dimensión a nuestra gráfica de dos dimensiones
# mediante la estética.
# Es un elemento visual de los objetos en la gráfica. Puede ser tamaño, 
#forma, transparencia, color

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Podemos darnos cuenta que 5 de los 6 puntos que parecieran salirse de la relación es porque son carros
# de 2 plazas. En retrospectiva no podían ser híbridos pues éstos no tienen tamaños de motor tan grande

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# ¿Qué pasó con los suv? Para las formas sólo utiliza 6 diferentes 
# formas por defecto

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), size = 10)

# colores son en "string"
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "red")
# formas en número
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), shape = 1, fill = "red")
# tamaño en milímetros

# Ejercicio
# ¿qué hay de malo con este código?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

# ¿qué variables de mpg son categóricas?
# ¿qué variables de mpg son continuas?
# ¿cómo puedes saber esta información cuando corres mpg?
# mapea una variable continua para color, tamaño y forma
# qué hace la estética "stroke" pista: utiliza ?geom_point
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), shape = 21, stroke = 3, fill= "red")
# qué pasa si en lugar de poner una variable ponemos una condición, ej: aes(color = displ < 5)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = displ < 5), shape = 21)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), shape = 21)


# Problemas comunes -------------------------------------------------------

# type-o
# paréntesis
# comillas
ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = displ, y = hwy, size = year))
# + en consola
# + en renglón
# ayuda y ve ejemplos
# lee el error
# googlea el error


# Facets ------------------------------------------------------------------

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

a <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

# Ejercicio

# ¿qué pasa cuando utilizas los facets en variables continuas?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ displ, nrow = 2)
# ¿qué significan los campos vacíos en facet_grid(drv ~cyl)? 
# ¿Cómo se relacionan con esta gráfica?

b <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cyl, y = drv))

# ¿Qué gráficas realiza el siguiente código?
# ¿Qué significa .?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ drv)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~drv,ncol = 3)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

# Qué ventajas y desventajas hay al utilizar facets sobre usar la estética del color? 
# ¿Cómo podría cambiar el balance si tuviéramos una bd más grande?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# ¿Qué hace los parámetros nrow y ncol de facet_wrap. Qué otros parámetros contralan el diseño
# de los páneles individualmente?
?facet_wrap
# Cuando utilizas facet_grid debes poner la viarable
# con mayor número de categorías únicas en las columnas
# ¿por qué?


# Objetos geométricos -----------------------------------------------------

library(gridExtra)

a <- ggplot(mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
  
b <- ggplot(mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

grid.arrange(a,b,nrow = 1)

# diferentes geoms
# objeto geométrico para representar datos
# ej. gráfica de barras: geom de barras
# gráfica de líneas: geom de líneas
# gráfica de dispersión: geom de puntos
# la gráfica de la derecha utiliza el geom de suavidad (valores ajustados)


# izquierda
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# derecha
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

# cada geom tiene argumentos para ser mapeados.
# Sin embargo, no todos los parámetros estéticos funcionan
# para todos los geom. Ej: puedes ajustar la forma de
# un punto pero no puedes ajustar la forma de una línea

# geom_smooth dibujará diferentes tipos de línea
# con el parámetro linetype para cada valor único de la gráfica

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# a lo mejor esto lo hace más claro

ggplot(data = mpg) + 
  geom_point(aes( x = displ, y = hwy, color = drv)) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv, color = drv))

# nota que está gráfica contiene 2 geoms en una misma gráfica.
# ggplot2 provee más de 40 geoms y extensiones del paquete
# provee aún más

a <- ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

b <- ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

c <- ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

grid.arrange(a,b,c,nrow = 1)

# sólo es necesario poner + para agregar múltiples geoms
# en una misma gráfica

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
   
  

# esto genera duplicación de código

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() +
  geom_smooth()

# se pueden establecer mapeos globales

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

# cuando escribes mapeos locales para cada geom, entonces
# extienede los mapeos globales

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"))

# se puede especificar datos específicos por geom. Los datos locales
#  reescribirá los globales para esa capa nada más

# Ejercicios
# 1. Qué geom utilizarías para dibujar unagráfica de línea? Un diagrama de caja y brazos?
# Un histograma? una gráfica de área?

# 2. Corre este código en tu cabeza y has una predicción de cómo es el resultado.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

# 3. ¿Qué hace el argumento show.legend = FALSE?
# ¿Para qué crees que lo utilicé anteriormente en ésta clase?

# 4. ¿Qué hace el argumento se de la función geom_smooth()?

# 5. ¿Las siguientes dos líneas de código graficarán algo diferente? ¿Por qué?

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# 6. Recrea el código para generar las siguientes gráficas

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() + 
  geom_smooth(se = F)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(se = F, aes(group =drv)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_smooth(se = F, aes(group =drv)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(se = F)

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = drv)) +
  geom_smooth(se = F, aes(linetype = drv))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(fill = drv), stroke = 1.5, size = 4,
             color = "white", shape = 21) 


# Transformación estadística ----------------------------------------------
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
# pone los datos en un recipiente y luego grafica el conteo de datos en cada recipiente

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
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1 ))

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = mean
  )

# Ejercicio

# 1. ¿Cuál es el geom por defecto de stat_summary?
# Cómo podrías re hacer la gráfica anterior utilizando la función geom en lugar de stat
# geom_pointrange()
# el deffault de ese geom es identity pero lo podemos cambiar por summary 

ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = "summary"
  )

ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = "summary",
    fun.min = min,
    fun.max = max,
    fun = median
  )
# el default es mean y sd. no median, min y max

# 2. ¿Qué hace geom_col? Cuál es la diferencia con
# geom_bar?

diamonds %>%
  count(cut) %>%
  ggplot() +
  geom_col(aes(x = cut, y = n)) 

diamonds %>% 
  ggplot() + 
  geom_bar(aes(y = cut))

# la transformación default es identity, que
# deja los datos como estan.

# el parámetro default para stat de geom_bar es
# stat_count(), Sólo espera un valor de x para contarlo.

# 3. La mayoría de las geoms y stats vienen en parejas que casi siempre se usan
# en conjunto. Has una lista de las parejas. ¿Qué tienen en común?

# geom_bar()	stat_count()
# geom_bin2d()	stat_bin_2d()
# geom_boxplot()	stat_boxplot()
# geom_contour_filled()	stat_contour_filled()
# geom_contour()	stat_contour()
# geom_count()	stat_sum()
# geom_density_2d()	stat_density_2d()
# geom_density()	stat_density()
# geom_dotplot()	stat_bindot()
# geom_function()	stat_function()
# geom_sf()	stat_sf()
# geom_smooth()	stat_smooth()
# geom_violin()	stat_ydensity()
# geom_hex()	stat_bin_hex()
# geom_qq_line()	stat_qq_line()
# geom_qq()	stat_qq()
# geom_quantile()	stat_quantile()

# 4. ¿Qué variables computa stat_smooth?
# ¿Qué parámetros controla su comportamiento?
?stat_smooth
# method y formula

# 5. Por qué tenemos que poner group = 1? Cuál es el problema con estas dos gráficas?
############# pct sobre el 100% de los datos
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop), group = 1))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut,y = ..count../sum(..count..), fill = color))

diamonds %>% count(cut,color) %>% mutate(pct = n/sum(n)) %>% 
  ggplot() + geom_col(aes(x = cut, y = pct, fill = color))

########### pct sobre el grupo color
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut,y = after_stat(prop), group = color, fill = color))

diamonds %>% count(cut, color) %>% group_by(color) %>% mutate(pct = n/sum(n)) %>% 
  ggplot() + geom_col(aes(x = cut, y = pct, fill = color))
########### pct sobre el grupo cut
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, group = color, fill = color), position = "fill")

diamonds %>% count(cut, color) %>% group_by(cut) %>% mutate(pct = n / sum(n)) %>% 
  ggplot() + geom_col(aes(x = cut, y = pct, fill = color))



# Ajuste de posición ----------------------------------------------
# Es posible colorear una gráfica de barras de dos maneras
# con los parámetros color y fill

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, color = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))
# qué pasa si rellenamos con otra variable
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")
# la posición identidad es más útil en geoms
# de dos dimensiones ( es el valor por defecto)

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

# hay una posición que funciona para gráficas de dispersión y no para gráficas de barras
# en este gráfica sólo se muestran 126 puntos a pesar de que existen 234 (porque se enciman)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# agrega ruido aleatorio para saber dónde está la concentración de los datos

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
# agregar esta aleatoriedad mejora la gráfica a pesar de que es menos precisa
# a escalas pequeñas, a escalas más grandes puede ser más revelador.
# es tan funcional que existe un geom dedicado a esta posición geom_jitter()

# Ejercicios:
# 1. ¿Cuál es el problema con esta gráfica? grafica puntos por encima porque hay 
# múltiples observaciones por encima
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()
# ¿Cómo se puede mejorar?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point(position = "jitter")

# 2. Qué parámetros de geom_jitter controla
# la cantidad de vibración?
?geom_jitter
# width y height

# 3. Compara y contrasta geom_jitter con geom_count

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()


ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()

# 4. Cuál es la posición por defecto de geom_boxplot?
# Crea una visualización para demostrarla
# R= "dodge2, no cambia la posición vertical pero sí cambia la posición 
# horizontal para evitar que se superponga

ggplot(data = mpg, aes(x = drv, y = hwy)) +
  geom_boxplot()

# Sistema de coordenadas ----------------------------------------------
# El sistema de coordenadas por defecto es el Carteisano.
# Donde las posiciones de los puntos x, y actuan independiente para
# determinar la locación de cada punto.

# coord_flip cambia los ejes x y y
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()
# coord_quickmap
# pone el radio para que el aspecto sea correcto para mapas
nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

# coord_polar
# usa coordenadas polares

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

# Ejercicios
# 1. Cambia una gráfica de barras apilada por una de pie usando
# coordenadas polares
ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar()

ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y")

# 2. Qué hace la función labs? Lee la documentación

# R= agrega títulos a los ejes, títulos y pie de nota

# 3. Cuál es la diferencia entre coord_quickmap y coord_map
?coord_map
# R= coord_map usa las proyecciones  para proyectar las 3 dimensaiones de la tierra 
# en un plano de dos dimensiones.
# coord_quickmap utiliza una aproximación más rápida a la proyeción.
# ignora la curvatura de la tierra y ajusta el mapa en el radio de
# latitud y longitud

# 4. Qué te dice la siguiente gráfica de la relación entre cty y hwy?
# Es importante coord_fixed?
# Qué hace geom_abline()?

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() +
  coord_fixed()

# coord_fixed lo que hace es que asegura que la línea esté a 45 grados y es más fácil de comparar las dos variables
#  en general el ojo humano en promedio puede detectar mejor las relaciones a un ángulo de 45 grados

# Las capas de la gramática de las gráficas ----------------------------------------------

ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
    mapping = aes(<MAPPINGS>),
    stat = <STAT>, 
    position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
  
  # 1. Empezar con bd
  # 2. Hacer alguna operación (stat_count)
  # 3. Elegir un geom
  # 4. Elegir los mapeos
  # 5. Elegir el sistema de coordenadas
  # 6. Si es necesario separar gráficas en partes
