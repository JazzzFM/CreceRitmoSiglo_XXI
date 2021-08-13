# Visualización: Ejercicicos 3 - Facets y Geoms --------------------------------------------

#Facets

# 1. ¿Qué pasa cuando utilizas los facets en variables continuas?
# 2. ¿Qué significan los campos vacíos en facet_grid(drv ~cyl)?
#    ¿Cómo se relacionan con esta gráfica?
# 3. ¿Qué gráficas realiza el siguiente código? ¿Qué significa .?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)


"
Soluciones Facets 

1. Veamos que:
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(. ~ cty)
  
La variable continua se convierte en una variable categórica y el gráfico 
contiene una faceta para cada valor distinto.

2.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cty)) +
  facet_grid(drv ~ cyl)
  
Las celdas vacías (facetas) de este gráfico son combinaciones de drv y cyl que no
tienen observaciones. Estas son las mismas ubicaciones en el diagrama de dispersión
de drv y cyl que no tienen puntos.

ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))

3. El símbolo . ignora esa dimensión al facetar. Por ejemplo, drv ~. faceta por valores 
   de drv en el eje y.
   
   ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
  
  Tiempo, . ~ cyl se facetará por los valores de cyl en el eje x.
  
  ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
"

# Geoms

# 1. ¿Qué geom utilizarías para dibujar unagráfica de línea? Un diagrama de caja y brazos?
#    ¿Un histograma? ¿Una gráfica de área?
# 2. Corre este código en tu cabeza y has una predicción de cómo es el resultado.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)
# 3. ¿Qué hace el argumento show.legend = FALSE?
#    ¿Para qué crees que lo utilicé anteriormente en ésta clase?
# 4. ¿Qué hace el argumento se de la función geom_smooth()?
# 5. ¿Las siguientes dos líneas de código graficarán algo diferente? ¿Por qué?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# 6. Recrea el código para generar las siguientes gráficas
# ----------------------- Ver gráficas en el lernr ------------------------------------


"
Soluciones Geoms

1. Lista:

gráfico de líneas: geom_line()
diagrama de caja: geom_boxplot()
histograma: geom_histogram()
gráfico de áreas: geom_area()

2. ----

3. Resultados de traducción. La opción de tema show.legend = FALSE oculta el cuadro de leyenda.

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, colour = drv),
    show.legend = FALSE
  )

En esa gráfica, no hay leyenda. Eliminar el argumento show.legend o configurar
show.legend = TRUE dará como resultado que el gráfico tenga una leyenda que muestre
el mapeo entre colores y drv. 

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, colour = drv))
  
4. Agrega bandas de error estándar a las líneas.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, colour = drv)) +
  geom_point() +
  geom_smooth(se = TRUE)
  
Por defecto se = TRUE;
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, colour = drv)) +
  geom_point() +
  geom_smooth()
  
5. No. Porque tanto geom_point() como geom_smooth() usarán los mismos datos y asignaciones.
  Heredarán esas opciones del objeto ggplot (), por lo que no es necesario volver a 
  especificar las asignaciones.
  
6. Los código son:

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
             color = 'white', shape = 21) 

"