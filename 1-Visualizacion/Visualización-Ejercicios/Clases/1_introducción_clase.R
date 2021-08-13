# Visualización - Clase 1 - Introducción ----------------------------------------------------------
# install.packages("tidyverse")

library(tidyverse)

# ¿Los autos con un motor más grande utilizan más combustible que los autos con un motor más pequeño?
# ¿Cómo se ve la relación entre el tamaño de un motor y el uso de combustible? 
# ¿Positiva, negativa, lineal, no lineal?
mpg
?mpg

# displ (tamaño del motor)
# hwy (eficiencia del uso del combustible)

# Primera gráfica
ggplot(data = mpg) + # crea un sistema de coordenadas para agregar capas
  geom_point(mapping = aes(x = displ, y = hwy)) 

# agrega una capa de puntos a 
# la gráfica y crea una gráfica de dispersión
# ¿Esta gráfica comprueba o refuta tu hipótesis acerca de la eficiencia 
# del uso del combustible y el tamaño del motor?

# Plantilla

ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))