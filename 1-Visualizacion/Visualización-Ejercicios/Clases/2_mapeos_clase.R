# Visualización - Clase 2 - Mapear elementos estéticos ----------------------------------------------------------
# El mejor valor de una imagen es cuando nos forza a notar lo que nunca esperamos ver.
# John Tukey
mpg %>%
mutate(
rojo = case_when( hwy > 20 & displ >5~T, T~F) 
) %>%
ggplot() + 
geom_point(aes(x =displ, y = hwy, color = rojo)) +
scale_color_manual(values = c("black","red")) + theme(legend.position = "none")

# Los puntos rojos parece ser que se salen de la relación lineal.
# ¿Cómo podrías explicar estos carros?
# Una posible hipótesis es que sean carros híbridos.

# Podemos agregar una tercera dimensión a nuestra gráfica de dos dimensiones
# mediante la estética.
# Es un elemento visual de los objetos en la gráfica. Puede ser tamaño, forma,
# transparencia, color
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

# ¿Qué pasó con los suv? Para las formas sólo utiliza 6 diferentes formas por defecto
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), size = 10)

# colores son en "string"
# formas en número
# tamaño en milímetros

# Problemas comunes

# type-o
# paréntesis
# comillas
# + en consola
# + en renglón
# ayuda y ve ejemplos
# lee el error
# googlea el error
