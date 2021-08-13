# Visualización: Ejercicicos Introducción --------------------------------------------

# 1. ¿Qué ves si sólo corres ggplot(data = mpg)?
# 2. ¿Cuántos renglones y columnas tiene mpg?
# 3. ¿Qué describe la variable drv? (utiliza ?mpg)
# 4. Has una gráfica de dispersión entre las variables hwy vs cyl.
# 5. ¿Qué pasa si haces una gráfica de dispersión entre class y drv?
#    ¿Por qué no es útil esta gráfica?








"
Soluciones:
1. Sale una gráfica vacía
2. 234 y 11
3. El tipo de tren de transmisión, donde f = tracción delantera, r = tracción trasera, 4 = 4wd
4. ggplot(data = mpg) + geom_point(mapping = aes(x = hwy, y = cyl))
5. La gráfica de dispersión resultante tiene solo unos pocos puntos.
ggplot(mpg, aes(x = class, y = drv)) +
  geom_point()
  
Un diagrama de dispersión no es una visualización útil de estas variables ya que tanto drv
como class son variables categóricas. Dado que las variables categóricas generalmente toman
una pequeña cantidad de valores, hay una cantidad limitada de combinaciones únicas de valores
(x, y) que se pueden mostrar. En estos datos, drv toma 3 valores y la clase toma 7 valores,
lo que significa que solo hay 21 valores que podrían trazarse en un diagrama de dispersión 
de drv vs. class. En estos datos, se observan 12 valores de (drv, class)
"
