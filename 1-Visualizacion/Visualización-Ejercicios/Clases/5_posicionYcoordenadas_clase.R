# Visualización - Clase 5 - Posición y Coordenadas ----------------------------------------------------------

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


# Sistema de coordenadas
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