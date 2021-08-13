# Transformación: Clase 4 - summarise y conteos --------------------------------------------

##  Resúmenes por grupos utilizando `summarise()`

library(nycflights13)
library(dplyr)

"
El último verbo clave es `summarise()`. 
Colapsa una marco de datos en un solo renglón:
"  

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

"
Más adelante ahondaremos en el parámetro `na.rm = TRUE`

`summarise()` no es tan útil a menos que se utilice en conjunto con `group_by()`.
"

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

"
Estas últimas herramientas son las que utilizarás más comúnmente cuando 
trabajes con `dplyr`. Antes de continuar quisiera hacer un paréntesis
acerca del 'pipe'.
"

### Combinar múltiples operacioines con el pipe
"
Imagina que queremos explorar las relaciones entre la distancia 
y el retraso promedio para cada destino.
"

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)

delay <- filter(delay, count > 20, dest != "HNL")

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

"Más aún, en una sola línea sería"

ggplot(data = filter(
  summarise(
    group_by(flights, dest),
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ),
  count > 20, dest != "HNL"),
  mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

"
Los pasos que seguí para preparar los datos fueron los siguientes:
1 Agrupar los vuelos por destino
2 Resumir y computar la distancia, el retraso promedio y el número de vuelos.
3 Filtrar para remover puntos ruidosos y el aeropuerto de Honolulu, que está casi al doble de distancia que el aeropuerto más cercano a éste.

Es frustrante esta estrategia por el paso intermedio.
Una forma diferente de resolverlo es utilizando el pipe, `%>%`:
"

delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

"
Es much más fácil de leer: agrupas, luego resumes, luego filtras.
"

### Valores faltantes
"
¿Qué pasa si no escribimos el argumento `na.rm` en el ejemplo anterior?
"  

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

"
Obtenemos muchos valores faltantes.
"

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))

"
En este caso, donde hay valores faltantes representa a los vuelos cancelados. 
También podríamos resolver el problema al remover los vuelos cancelados y guardar
este conjunto de datos para reutilizarlo después
"

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))


### Conteos
"
Una buena práctica cuando realizas cualquier aggregación es incluir 
un conteo de observaciones o grupo o un conteo de valores no faltantes.
" 

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

"
Hay aviones que tienen un promedio de retraso de 300 minutos. 
Podemos ver mayor detalle si hacemos una gráfica de dispersión 
del número de vuelos vs. retraso promedio por avión.
"

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

"
Por lo general, cuando graficas el promedio  vs 
el tamaño del grupo, verás que la variación decrece mientras el tamaño incrementa.

Usualmente es útil filtrar los grupos con el menor número de observaciones
para poder ver mejor el patrón y menos la variación extrema de los grupos pequeños.
"

delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)


### Ejercicios: resumenes agrupados
"

1. Intenta obtener el mismo resultado que dan los siguientes códigos 
  `not_cncelled %>% count(dest)` y `not_cancelled %>% count(tailnum, wt = distnace)` 
  (sin utilizar la función `count()`)

2. La definición de vuels cancelados es (`is.na(dep_delay) | is.na(arr_delay)`)
   no es óptima, ligeramente. ¿Por qué? ¿Cuál es la columna más importante?

3. Revisa el número de vuelos cancelados por día. ¿Existe algún patrón?
   ¿Está la proporción de vuelos cancelados relacionado con el retraso promedio?

4. ¿Qué aerolínea tiene los peores retrasos?
   Reto: podrías descubrir el efecto de malos aeropuertos vs. malas aerolíneas?
   ¿Por qué o por qué no? 
   (Tip: peinsa en `flights %>% group_by(carrier, dest) %>% summarise(n())`)

5. ¿Qué hace el argumento `sort` en la función `count()`?
"