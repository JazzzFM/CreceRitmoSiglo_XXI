# Clase 1: filter ----------------------------------------------------------
## Prerequisitos

library(nycflights13)
library(tidyverse)

"
Para explorar las funciones principales del paquete `dplyr` utilizaremos 
la base de datos `flights`: 
"

flights

"
Existen diferentes tipos de variables:

* `int`.
* `dbl`.
* `chr`.
* `dttm`.
* `lgl`.
* `fctr`.
* `date`.
"

### Funciones básicas de `dplyr`
"
* `filter()`.
* `arrange()`.
* `select()`.
* `mutate()`.
* `summarise()`.
Estas funciones se pueden utilizar en conjunto con `group_by()`.

Argumentos:
1. `data.frame`.
2. Instrucciones que hacer con los datos.

Resultados:
  Un nuevo `data.frame`.
"
## Filtrar renglones con filter()

filter(flights, month == 1, day == 1)

"
Operadores comparativos: `>` (mayor a),`>=` (mayor o igual a),
`<` (menor a),`<=` (menor o igual a),`!=` (diferente),`==` (igual)
"

"Cuidados:"
sqrt(2) ^ 2 == 2
1 / 49 * 49 == 1


"Utilizar función near()"
near(sqrt(2) ^ 2,  2)
near(1 / 49 * 49, 1)


### Operadores lógicos

filter(flights, month == 11 | month == 12)

filter(flights, month %in% c(9,12))


"
Algunas veces filtros complicados se pueden simplificar con la ley De Morgan:
* `!(x & y)` es lo mismo a `!x | !y`
* `!(x | y)` es lo mismo a `!x & !y`

Por ejemplo:
"

filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120 & dep_delay <= 120)


### Valores faltantes

NA > 1
1 == NA
NA + 1
NA / 1
NA == NA

is.na(NA)


bd <-  tibble(x = c(1:3, NA))
filter(bd, x > 2)
filter(bd, x > 2 | is.na(x))


### Ejercicios
"
1. Encuentra todos los vuelos que:
* Que tuviern un retraso de llegada de 2 horas o más
* Volaron a Houston (IAH o HOU)
* fueron operados por United, American, o Delta
* Salieron en Julio, Agosto y Septiembre
* LLegaron más de dos horas tarde pero no salieron tarde
* Salieron al menos una hora tarde pero recuperaron 30 minutos de vuelo
* Salieron de la media noche a las 6am (incluyéndo)

2. Otra función muy útil de `dplyr` es `between()`. ¿Qué hace? 
  ¿Podrías utilizarlo para simplificar el código  para responder las
  preguntas anteriores?

3. ¿Cuántos vuelos no tienen información en la variable `dep_time`? 
   ¿Qué otras variables faltan? ¿Qué podrían representar estos renglones?

4. ¿Por qué `NA ^ 0`, `NA | TRUE`, `FALSE & NA` no son valores faltantes?
  ¿Podrías descubrir una regla general? (NA * 0 tiene truco)

"

# Clase 2: select y arrange ----------------------------------------------------------

library(nycflights13)
library(dplyr)

"
Es común que manejemos datos con cientos de variables.
Seleccionar las variables que realmente interesan es la tarea de select
"

select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

"
Hay más funciones que se pueden utilizar dentro de `select()` como:
* `starts_with()` 
* `ends_with()` 
* `contains()`
* `num_range('x', 1:3)`

Revisa `?select` para mayor detalle
Si el objetivo es renombrar variables utiliza `rename()`
"

select(flights, tail_num = tailnum)
rename(flights, tail_num = tailnum)

"
Podrías utilizar la función `everything()` 
"

select(flights, year, month, day, time_hour, air_time, everything())

"
Otra forma de cambiar el orden de las columnas es con `relocate()` 
"

relocate(flights, time_hour, dep_time, .after = day)


"Revisa `?relocate` para mayor detalle."

### Ejercicios
"
1. ¿Cuántas formas se te ocurren para seleccionar las variables `dep_time`,
   `dep_delay`, `arr_time` y `arr_delay` de `flights`?

2. ¿Qué pasa si incluyes el nombre de una variable múltiples veces en un sólo
    `select()`?

3. ¿Qué hace la función `any_of()`? ¿Cómo podría ayudar al tener el siguiente
    vector?
vars <- c('year', 'month', 'day', 'dep_delay', 'arr_delay')

4. ¿Te sorpende el resultado del siguiente código?

select(flights, contains('TIME'))

¿Cuál es el tratamiento de las funciones adicionales con las mayúsculas 
por defecto? ¿Cómo podrías cambiarlo?
"

## Organizar filas con arrange()

"
Se necesita un marco de datos y un conjunto de nombres de columna
(o expresiones más complicadas) para ordenar. 

Si proporciona más de un nombre de columna, cada columna adicional se
utilizará para romper los empates en los valores de las columnas anteriores:
"

arrange(flights, year, month, day)

"
Use desc () para reordenar por una columna en orden descendente:
"

arrange(flights, desc(dep_delay))

"
Los valores que faltan siempre se ordenan al final:
"

df <- tibble(x = c(5, 2, NA))

arrange(df, x)

arrange(df, desc(x))

### Ejercicios: arrange
"
1. ¿Cómo podría usar arrange() para ordenar todos los valores faltantes desde el principio?
   (Sugerencia: use is.na ()).

2. Ordene vuelos para encontrar los vuelos más retrasados. Encuentra los vuelos que salieron 
   antes.

3. Ordene vuelos para encontrar los vuelos más rápidos (de mayor velocidad).

4. ¿Qué vuelos viajaron más lejos? ¿Cuál viajó más corto?
"

# Clase 3: mutate ----------------------------------------------------------

library(nycflights13)
library(dplyr)

"
Con `mutate()`siempre se agregarán al final de la base de datos. 

Por esto es buena idea seleccionar primero las columnas más
relevantes para poder visualizar los resultados del `mutate()`
"

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time)

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60
)

"
Nota que puedes hacer referencia 
"

mutate(flights_sml,
       gain = dep_delay - arr_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)

"
Si sólo quieres mantener las columnas que acabas de
transformar utiliza `transmute()`
"

transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

### Funciones útiles para crear variables
"
La propiedad fundamental de las funciones es que debe estar vecotrizadas, 

**operaciones aritméticas**: 
`+`, `-`, `*`, `/`, `^` .

**Operaciones modulares**: 
`%/%` (el número entero al hacer una división) y `%%` el residuo.
"

transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

"
**Compensaciones** : 
  `lead()` y `lag()` (ej. `x - lag(x)` diferencias entre valores) 
    (ej2. `x != lag(x)` enconotrar los valores cuando cambian). 
"

(x <- 1:10)
lag(x)
lead(x)

"
**Operaciones acumulativas**: 
  `cumsum()`, `cumprod()`, `cummin()`, `cummax()`, `cummean()`
"

cumsum(x)
cummean(x)

"
**Comparaciones lógicas**:
  `<`, `<=`, `>`, `!=`, `==`

**Ranking**:
  `min_rank()`, `dense_rank()`
"

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))

### Ejercicios
"
1. `dep_time` y `sched_dep_time` son fáciles de ver pero difíciles de
    computar porque no son números continuos. Conviértelos a una representación
    más amigable de minutos desde la media noche.

2. Compara `air_time` con `arr_time - dep_time`. ¿Qué esperas ver? 
   ¿Qué ves en realidad? ¿Qué debes cambiar?

3. Compara `dep_time`, `sched_dep_time` y `dep_delay`.
   ¿Cómo esperas que esos 3 números se relacionen?

4. Encuentra los vuelos más retrasados utilizando alguna función de ranking.
  ¿Cómo quieres manejar los empates? Lee cuidadosamente la documentación 
  `min_rank()`

5. ¿Cuál es el resultado de `1:3 + 1:10`. ¿Por qué?

"


# Clase 4: summarise y conteos ----------------------------------------------------------
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

flights %>% group_by(year, month, day) %>% 
  summarise(delay = mean(dep_delay, na.rm = T))
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

flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL") %>%
  ggplot(aes(x = dist, y = delay)) + 
  geom_point(aes(size = count), alpha = 1/3) + geom_smooth(se = F)
"
Es much más fácil de leer: agrupas, luego resumes, luego filtras.
"

### Valores faltantes
"
¿Qué pasa si no escribimos el argumento `na.rm` en el ejemplo anterior?
"  

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay),
            vuelos =)

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
    delay = mean(arr_delay),
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



# Clase 5: summarise y mutates ----------------------------------------------------------

## Funciones de resúmenes útiles
"
**Medidas de localización**: 
  `mean()`, `median()`. 

A veces es útil combinar las agregaciones con filtros lógicos 
"
 
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

"
**Medidas de dispersión**:
  `sd()`, `IQR()` 

¿Por qué la distancia a ciertos destinos son más variables que otros?
" 

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

"
**Medidas de rango**: 
  `min()`, `quantile(x,0.25)`, `max()`.

¿Cuándo es  el primer vuelo y el último salen todos los días?
"  

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )


"
También es posible lograr la misma tarea con filter
"

not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))

"
**Conteos**:
  Hemos visto que utilizar `n()`, que no recibe argumentos.
  Para contar el número de categorías únicas podemos utilizar `n_distinct()`
"

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

"
Los conteos son tan útiles que dplyr ofrece una función en particular
"

not_cancelled %>% 
  count(dest,carrier, sort = T) %>% count(dest, sort = T)

"
Opcionalmente puedes proveer una variable de peso. 
"

not_cancelled %>% 
  count(tailnum, wt = distance)

not_cancelled %>% group_by(tailnum) %>% summarise(millas = sum(distance))

"
**Conteos y proporciones de valores lógicos**: 
  `sum(x>10)`, `mean(y == 0)`. 

¿Cuántos vuelos salieron antes de las 5am por día?
" 

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

"
¿Qué proporción de vuelos se retrasaron por más de una hora por día?
"

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = mean(arr_delay > 60))


### Agrupando por múltiples variables

library(nycflights13)
library(dplyr)

daily <- group_by(flights, year, month, day)
(per_day   <- summarise(daily, flights = n()))
(per_month <- summarise(per_day, flights = sum(flights)))
(per_year  <- summarise(per_month, flights = sum(flights)))

"
Hacer esta progresión no es lo mismo cuando queremos calcular 
promedios, medianas, varianzas, etc. 

Tendríamos que penar en los pesos con medias y varianzas y
no es posible realizarlo con la mediana. 

En otras palabras, la suma de grupos es efectivamente la suma de todo, 
pero la mediana de de las medianas de un grupo no es la mediana global.

Si quieres desagrupar sólo utiliza la función `ungroup()`
"

mediana_dia <- not_cancelled %>% group_by(year, month, day) %>% 
  summarise(mediana_d = median(distance))

mm <- mediana_dia %>% summarise(mediana_m = median(mediana_d))

mediana_mes <- not_cancelled %>% group_by(year, month) %>% 
  summarise(mediana_m = median(distance))

mm %>% left_join(mediana_mes, by = c("year","month"))

daily %>% 
  ungroup() %>%             
  summarise(flights = n())  


### Ejercicios 1
"

1. Intenta obtener el mismo resultado que dan los siguientes códigos 
  `not_cancelled %>% count(dest)` y `not_cancelled %>% count(tailnum, wt = distance)` 
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

## Mutates y filters agrupados
"
Encontrar los peores miembros de un grupo
"

flights_sml %>% 
  group_by(year, month, day) %>%
  filter(min_rank(desc(arr_delay)) <= 10)

"
Encontrar grupos que son mayores a un umbral
"

popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_dests

flights %>% count(dest) %>% filter(n < 365)
"
Calcular las métricas por grupo
"

popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)


# Funciones que trabajan naturalmente con mutates y filters
# agrupados se conocen como funciones ventana. 
# 
# Lee la siguiente documentación `vignette("window-functions")`

### Ejercicios 2

flights %>% group_by(tailnum) %>% 
  summarise(prop_vuelos_retrasados = mean(arr_delay > 0 & !is.na(arr_delay)),
            prop_vuelos_cancelados = mean(is.na(arr_delay)),
            n_vuelos  = n()) %>% 
  mutate(prop_vuelos_retr_mas_cancelados = prop_vuelos_retrasados + prop_vuelos_cancelados) %>% 
  arrange(desc(prop_vuelos_retrasados)) %>%
  filter(n_vuelos > 25)

flights %>% filter(arr_delay > 0) %>% group_by(tailnum) %>% 
  summarise(promedio_retraso = mean(arr_delay,na.rm = T),
            n_vuelos  = n()) %>% 
  arrange(desc(promedio_retraso)) %>%
  filter(n_vuelos > 25)

### Ejercicios: Mutates y filters agrupados

"
1. ¿Qué avión (`tailnum`) tiene el peor record de llegadas a tiempo? 
    (proporción de vuelos retrasados al llegar o cancelados o 
    media del retraso de llegada)

2. ¿En qué hora deberías tomar un vuelo para evitar retrasos lo más posible?

flights %>%
filter(dep_delay <= 0, arr_delay <= 0)

flights %>% 
group_by(hour) %>% 
summarise(n = n(),
arr_delay_prom = mean(arr_delay, na.rm = TRUE)) %>% 
arrange(arr_delay_prom)

flights %>% filter(!is.na(arr_delay)) %>% mutate(hora = dep_time %/% 100) %>% group_by(hora) %>%
summarise(vuelos = n(), prop = mean(arr_delay > 0),promedio = mean(arr_delay)) %>% arrange(prop) %>%
ggplot(aes(x = hora, y = prop, size = vuelos)) + geom_point()

3. Para cada destino, calcula el total de minutos retrasados.
  Para cada vuelo, calcula la proporción del total de retraso para su destino.

flights %>% 
filter(arr_delay > 0) %>% 
group_by(dest) %>% 
mutate(arr_delay_total = sum(arr_delay),
arr_delay_prop = arr_delay/arr_delay_total) %>% 
select(dest, arr_delay_total, arr_delay_prop)


4. Los retrasos normalmente estan correlacionados en el tiempo,
  es decir, a pesar de que el problema que causó el retraso inicial se resolvió, 
  los vuelos posteriores se retrasan para permitir que los vuelos retrasados salgan. 
  Utiliza `lag()`, explora cómo el retraso de un vuelo está relacionado al retraso 
  del vuelo que seguía.

flights %>% 
arrange(origin, month, day, dep_time, dep_delay) %>% 
group_by(origin) %>% 
mutate(dep_delay_lag = lag(dep_delay)) %>% 
filter(!is.na(dep_delay_lag), !is.na(dep_delay))

5. Ve cada destino. Podrías encontrar vuelos que son sospechosamente rápidos? 
  (es decir, vuelos que representan datos erróneos).
  Calcula el tiempo en aire de un vuelo relativo al vuelo más corto a ese destino. 
  ¿Qué vuelos fueron más retrasados en el aire?

6. Encuentra todos los destinos que existen vuelos de al menos dos compañías.
   Usa esa información para rankearlos.

7. Para cada avión, cuenta el número de vuelos  anteriores al primer
   retraso mayor a 1 hora.
"
