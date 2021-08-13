# Visualización: Ejercicicos 5 - Posición y Coordenadas --------------------------------------------

# Posición Ejercicios
# 1. ¿Cuál es el problema con esta gráfica? grafica puntos por encima porque hay 
#    múltiples observaciones por encima? ¿Cómo se puede mejorar?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()
# 2. ¿Qué parámetros de geom_jitter controla la cantidad de vibración? ?geom_jitter
# width y height
# 3. Compara y contrasta geom_jitter con geom_count
# 4. ¿Cuál es la posición por defecto de geom_boxplot?

"
Soluciones Posición

1.  Hay sobretrazado porque hay múltiples observaciones para cada combinación de
    valores cty y hwy. Mejoraría la gráfica usando un ajuste de posición de jitter
    para disminuir la sobreimpresión
    
    ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point(position = 'jitter')

    La relación entre cty y hwy es clara incluso sin alterar los puntos, pero la
    alteración muestra los lugares donde hay más observaciones.

2.  De la documentación de geom_jitter(), hay dos argumentos para jitter:
    width: controla la cantidad de desplazamiento horizontal, y
    height: controla la cantidad de desplazamiento vertical.
    Los valores predeterminados de ancho y alto introducirán ruido en ambas direcciones. 
    Así es como se ve el gráfico con los valores predeterminados de alto y ancho.
    
    ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point(position = position_jitter())
    
    Sin embargo, podemos cambiar estos parámetros. Aquí hay algunos ejemplos para 
    comprender cómo estos parámetros afectan la cantidad de jittering. Cuando
    width = 0 no hay fluctuación horizontal.
    
    ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_jitter(width = 0)
    
3. El geom geom_jitter () agrega variación aleatoria a los puntos de ubicación del gráfico. 
En otras palabras, 'agita' ligeramente la ubicación de los puntos. Este método reduce el
trazado excesivo, ya que es poco probable que dos puntos con la misma ubicación tengan la
misma variación aleatoria.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()
  
4. La posición predeterminada para geom_boxplot () es 'dodge2', que es un atajo para
   position_dodge2. Este ajuste de posición no cambia la posición vertical de una geom,
   pero mueve la geom horizontalmente para evitar superponer otras geom. Consulte la 
   documentación de position_dodge2() para obtener más información sobre cómo funciona.
  
  Cuando agregamos color = class al diagrama de caja, los diferentes niveles de la variable
  drv se colocan uno al lado del otro, es decir, se esquivan.
  
  ggplot(data = mpg, aes(x = drv, y = hwy, colour = class)) +
  geom_boxplot()
  
  Si se usa position_identity (), los diagramas de caja se superponen.
  
  ggplot(data = mpg, aes(x = drv, y = hwy, colour = class)) +
  geom_boxplot(position = 'identity')
"

# Coordenadas Ejercicicos
# 1. Cambia una gráfica de barras apilada por una de pie usando coordenadas polares
# 2. Qué hace la función labs? Lee la documentación
# 3. Cuál es la diferencia entre coord_quickmap y coord_map ?coord_map
# 4. Qué te dice la siguiente gráfica de la relación entre cty y hwy?
#    ¿Es importante coord_fixed? ¿Qué hace geom_abline()?


"
Soluciones Coordenadas

1. 
ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar()

ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar(theta = 'y')
  
2. 
Agrega títulos a los ejes, títulos y pie de nota

3. 
  coord_map usa las proyecciones  para proyectar las 3 dimensaiones de la tierra
  en un plano de dos dimensiones.
  
  coord_quickmap utiliza una aproximación más rápida a la proyeción ignora la
  curvatura de la tierra y ajusta el mapa en el radio de latitud y longitud

4. 
  ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point() + 
    geom_abline() +
    coord_fixed()

coord_fixed lo que hace es que asegura que la línea esté a 45 grados y es más
fácil de comparar las dos variables en general el ojo humano en promedio puede
detectar mejor las relaciones a un ángulo de 45 grados
"