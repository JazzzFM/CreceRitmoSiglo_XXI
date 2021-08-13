# Visualización - Clase 3 - Facets y Geoms ----------------------------------------------------------

# Facets
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)


# Geoms

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
  geom_smooth(mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy)) 


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
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

# se puede especificar datos específicos por geom. Los datos locales
#  reescribirá los globales para esa capa nada más