library(tidyverse)


# Clase 1: Variación ------------------------------------------------------

"
**EDA** no es un proceso formal con un conjunto estricto de reglas.
Más que nada, **EDA** es un estado mental.

* Generar preguntas sobre tus datos.
* Buscar respuestas visualizando, transformando y modelando sus datos.
* Utilizar lo que aprendas para refinar tus preguntas y/o generar nuevas preguntas.
"

library(dplyr)
library(ggplot2)

"
La variación es la tendencia de los valores de una variable 
para cambiar de la medición a la medición.

Cada variable tiene su propio patrón de variación ...

"

###  Visualización de distribuciones

"
La forma en que visualiza la distribución de una variable dependerá
de si la variable es categórica o continua.

Para examinar la distribución de una variable categórica,
use un gráfico de barras:
"

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

"La altura de las barras ..."
"Puedes calcular estos valores manualmente con `dplyr ::count()`:"

diamonds %>% 
  count(cut)

"
Una variable es numérica si ...

Ejemplo de variable continua ...
Para examinar la distribución de una variable continua, usa un histograma:
" 

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.1)

"
Se puede calcular esto a mano combinando `dplyr::count()` y
`ggplot2::cut_width()`:
"

diamonds %>% 
  count(cut_width(carat, 0.5))

"
Un histograma divide el eje X en contenedores igualmente espaciados y ...
Puede configurar el ancho de los intervalos en un histograma con el argumento ...
"


smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

"
Si desea superponer múltiples histogramas en la misma gráfica,
recomiendo usar `geom_freqpoly()` en lugar de `geom_histogram()`
"

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)

"
Ahora que puede visualizar la variación, ¿qué debe buscar en sus gráficos?
¿Y qué tipo de preguntas de seguimiento debería hacer? 
¿Cómo podría ser engañoso?
"

### Valores típicos
"
Las barras altas muestran los valores comunes ... 
Las barras más cortas muestran los valores menos comunes...
 
Los lugares que no tienen barras revelan ...
El histograma a continuación sugiere:

- ¿Por qué hay más diamantes de quilates enteros y fracciones comunes de
  quilates 'carat'?
- ¿Por qué hay más diamantes ligeramente a la derecha de cada pico que
  ligeramente a la izquierda de cada pico?
- ¿Por qué no hay diamantes de más de 3 quilates?
"

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

"
El siguiente histograma muestra la duración (en minutos) de 272
  erupciones del géiserOld Faithful en el Parque Nacional Yellowstone.

Los tiempos de erupción parecen agruparse en dos grupos:
  hay erupciones cortas  y erupciones largas
"

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)

"
Muchas de las preguntas anteriores le ayudarán a explorar una relación
entre variables
"


### Valores atipicos
"
Los valores atípicos son observaciones que son inusuales;
puntos de datos que no parecen ajustarse al patrón.

A veces, los valores atípicos son errores de entrada de datos;

La única evidencia de valores atípicos son los límites inusualmente amplios
en el eje x.
"

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

"
Hay tantas observaciones en los `bins` comunes que los `bins`
raros son tan cortos que no puedes verlos ...

Para que sea más fácil ver los valores inusuales, necesitamos hacer zoom...
" 

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

"
`coord_cartesian()` también tiene un argumento `xlim()` 
Esto nos permite ver que hay tres valores inusuales:
  `0, ~ 30` y `~60`
"

unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)

unusual

"
La variable `y` mide una de las tres dimensiones de estos diamantes, en mm.
Sabemos que los diamantes no pueden tener un ancho de 0 mm, 

También podríamos sospechar que las medidas de 32 mm y 59 mm son inverosímiles:

Es una buena práctica repetir su análisis con y sin valores atípicos.
Si tienen un efecto mínimo en los resultados y no puede averiguar por quéestán allí,
es razonable reemplazarlos con los valores faltantes y seguir adelante.
"
 

### Valores perdidos

"
Si ha encontrado valores inusuales en su conjunto de datos y
simplemente deseas continuar con el resto de su análisis, tienes dos opciones.
"

"
1 - Suelta toda la fila con los valores extraños:
"  
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))

"
No recomiendo esta opción porque el hecho de que una medición no sea válida no significa que todas
las mediciones lo sean.

Además, si tiene datos de baja calidad, cuando haya aplicado este enfoque a
cada variable, es posible que no le quede ningún dato.
"

"
* 2 - En su lugar, recomiendo reemplazar los valores inusuales
con valores perdidos.
"

diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

"
 `ifelse()` tiene tres argumentos ...
"

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point() + geom_abline() + coord_fixed()

"
 Para suprimir esa advertencia, establezca `na.rm = TRUE`:
"

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

"
Otras veces, desea comprender qué hace que las observaciones 
con valores perdidos sean diferentes de las observaciones con
valores registrados.

Por ejemplo, en `nycflights13::flights`, los valores faltantes
en la variable `dep_time`indican que el vuelo fue cancelado.
"

flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x = sched_dep_time)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

"
Sin embargo, esta gráfica no es muy buena porque ...
"

###  Ejercicios: Variación 

# 1 - Explore la distribución de cada una de las variables x, y y z en diamantes.
#   ¿Qué observas? Piensa en un diamante y en cómo podría decidir qué dimensión es la longitud, el ancho y la profundidad.
# 
# 2 - Explore la distribución de `price` ¿Descubres algo inusual o sorprendente?
#     (Sugerencia: piensa detenidamente en el `binwidth` y asegúrese de probar una amplia gama de valores).
# 
# 3 - ¿Cuántos diamantes son 0,99 quilates? ¿Cuántos son 1 quilate? 
#     ¿Cuál crees que es la causa de la diferencia?
#   
# 4 - Compara y contraste `coord_cartesian()` vs `xlim()` o `ylim()` al hacer zoom en un histograma. 
#   ¿Qué sucede si deja binwidth sin configurar? 
#   ¿Qué sucede si intentas hacer zoom para que solo se muestre la mitad de una barra?
# 
# 5 - ¿Qué sucede con los valores perdidos en un histograma? 
#     ¿Qué sucede con los valores perdidos en un gráfico de barras? 
#     ¿Por qué hay una diferencia?
#   
# 6 - ¿Qué hace `na.rm = TRUE` en `mean()` y `sum()`?
#   


# Clase 2:  Covariación ----------------------------------------------------
"  
Si la variación describe el comportamiento dentro de una variable,
la covariación describe el comportamiento entre variables.

La covariación es la tendencia a que los valores de dos o más variables
varíen juntos de manera relacionada.
"

### Una variable categórica y continua
"
Es común querer explorar la distribución de una variable 
continua desglosada por una variable categórica,
como en el polígono de frecuencia anterior.

La apariencia predeterminada de `geom_freqpoly()` no es 
tan útil
"

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)


"
Es difícil ver la diferencia en la distribución
porque los recuentos generales difieren mucho:
"

ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut))

"
Para facilitar la comparación, debemos intercambiar lo 
que se muestra en el eje `y`

En lugar de mostrar el recuento, mostraremos la densidad
"

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = color), binwidth = 500)


"
Hay algo bastante sorprendente en esta grafica:
  ¡parece que los diamantes blancos (la calidad más baja) 
  tienen el precio promedio más alto!

Otra alternativa para mostrar la distribución de una variable
continua desglosada por una variable categórica es la gráfica de caja y brazos. 
"


ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

"
Vemos mucha menos información sobre la distribución,
pero los diagramas de caja son mucho más compactos,
por lo que podemos compararlos más fácilmente 

¡Apoya el hallazgo contrario a la intuición de que los
diamantes de mejor calidad son más baratos en promedio!

La variable `cut` es un factor ordenado

Muchas variables categóricas no tienen un orden tan intrínseco, 

Es posible que quieras reordenarlas 
"
  
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

"
Para que la tendencia sea más fácil de ver,
podemos reordenar la clase según el valor mediano de `hwy`:
"  

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))


"
Si tiene nombres de variables largos, 
`geom_boxplot()` funcionará mejor si lo giras 90°. 
"

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()

### Dos variables categóricas

"
Para visualizar la covariación entre variables categóricas, 
  deberá contar el número de observaciones para cada combinación. 
"

ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

"
El tamaño de cada círculo en la gráfica muestra cuántas observaciones
ocurrieron en cada combinación de valores. 

Otro enfoque es calcular el recuento con dplyr:
"  

diamonds %>% 
  count(color, cut)

"
Luego visualiza con `geom_tile()` y la estética de relleno (fill):
"  

diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

"
Si las variables categóricas no están ordenadas, 
es posible que desee utilizar el paquete de forcats

Para gráficos más grandes, es posible que desee probar los
paquetes `d3heatmap` o `heatmaply`, que crean gráficos interactivos.
"

#### Ejercicios

# 1 - ¿Cómo podría cambiar la escala del conjunto de datos de conteo anterior para mostrar más claramente 
#     la distribución del corte dentro del color o el color dentro del corte?
#   
# 2 - Utilice `geom_tile()` junto con `dplyr` para explorar cómo las demoras promedio de los vuelos varían
#     según el destino y el mes del año. ¿Qué hace que la grafica sea difícil de leer? 
#     ¿Cómo podrías mejorarlo?
#   
# 3 - ¿Por qué es un poco mejor usar `aes(x = color, y = cut)` en lugar de `aes(x = cut, y = color)`
#     en el ejemplo anterior?
  

## Dos variables continuas

"
Puede ver la covariación como un patrón en los puntos.

Por ejemplo, puedes ver una relación exponencial entre el
tamaño en quilates y el precio de un diamante.
"

ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))

"
Los diagramas de dispersión (**Scatterplots**)
 se vuelven menos inútiles a medida que aumenta el tamaño
de su conjunto de datos, porque ...

Ya has visto una forma de solucionar el problema:
"

ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price), alpha = 1 / 100)

"
Pero el uso de la transparencia puede ser un desafío para
conjuntos de datos muy grandes.

Otra solución es usar bin.  Ahora aprenderá a usar `geom_bin2d()` y
`geom_hex()` para agrupar en dos dimensiones.
 
Necesitará instalar el paquete `hexbin` para usar `geom_hex()`
"

ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))


library(hexbin)

ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))

"
Otra opción es agrupar una variable continua para que actúe
como una variable categórica.
"
  
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, .1)))


"
`cut_width(x, width)`, como se usó anteriormente, divide `x` 
en contenedores de ancho `width`. 

Otro enfoque es mostrar aproximadamente el mismo número de 
puntos en cada contenedor
"

ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))


#### Ejercicios: Covariación Categorica

# 1 - Utilice lo que ha aprendido para mejorar la visualización de las horas de
#     salida de los vuelos cancelados frente a los no cancelados.
#     
# 2 - ¿Qué variable del conjunto de datos de `diamonds` es más importante para
#     predecir el precio de un diamante? ¿Cómo se correlaciona esa variable con `cut`? 
#     ¿Por qué la combinación de esas dos relaciones hace que los diamantes de menor calidad sean más caros?
#       
# 3 - Instale el paquete `ggstance` y cree un diagrama de caja horizontal. 
#     ¿Cómo se compara esto con el uso de `coord_flip()`?
#       
# 4 - Un problema con los diagramas de caja es que se desarrollaron en una era de 
#     conjuntos de datos mucho más pequeños y tienden a mostrar una cantidad prohibitivamente 
#     grande de "valores periféricos".
#     Un enfoque para remediar este problema es la gráfica del valor de las letras. 
#     Instale el paquete `lvplot` e intente usar `geom_lv()` para mostrar la distribución
#     de precio frente a corte. ¿Qué aprendes? ¿Cómo interpretas las graficas?
#       
# 5 - Compare y contraste `geom_violin()` con un `geom_histogram()` facetado, o un `geom_freqpoly()`
#     de color. ¿Cuáles son los pros y los contras de cada método?
#       
# 6 - Si tiene un conjunto de datos pequeño, a veces es útil usar `geom_jitter()` para ver 
#     la relación entre una variable continua y categórica. El paquete `ggbeeswarm` proporciona 
#     varios métodos similares a `geom_jitter()`. Enumere y describa brevemente lo que hace cada uno.


### Ejercicios: Covariación Numérica

# 1 - En lugar de resumir la distribución condicional con una gráfica de caja, podría usar un polígono de 
#     frecuencia. ¿Qué debe tener en cuenta al usar `cut_width()` vs `cut_number()`? 
#       ¿Cómo afecta eso a la visualización de la distribución 2d de `carat` y `price`?
#       
# 2 - Visualice la distribución de `carat`, dividida por `price`.
# 
# 3 - ¿Cómo se compara la distribución de precios de los diamantes muy grandes con la de los diamantes
#     pequeños? ¿Es como esperabas o te sorprende?
#   
# 4 - Combine dos de las técnicas que ha aprendido para visualizar la distribución combinada de `cut`, 
#       `carat` y `price`.
# 
# 5 - Los gráficos bidimensionales revelan valores atípicos que no son visibles en los gráficos 
#     unidimensionales. Por ejemplo, algunos puntos en la gráfica siguiente tienen una combinación inusual
#     de valores `x` e `y`, lo que hace que los puntos sean atípicos aunque sus valores xey parezcan normales
#     cuando se examinan por separado.