# Transfomración: Clase 5 - summarise y mutates --------------------------------------------


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

¿Cuándo es que el primer vuelo y el último salen todos los días?
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
  count(dest)

"
Opcionalmente puedes proveer una variable de peso. 
"

not_cancelled %>% 
  count(tailnum, wt = distance)

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

daily %>% 
  ungroup() %>%             
  summarise(flights = n())  



## Mutates y filters agrupados
"
Encontrar los peores miembros de un grupo
"

flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

"
Encontrar grupos que son mayores a un umbral
"

popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_dests

"
Calcular las métricas por grupo
"

popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)


Funciones que trabajan naturalmente con mutates y filters
agrupados se conocen como funciones ventana. 

Lee la siguiente documentación `vignette("window-functions")`

### Ejercicios: summarise y mutates
"
1. ¿Qué avión (`tailnum`) tiene el peor record de llegadas a tiempo? 
    (proporción de vuelos no retrasados o cancelados o media del retraso de llegada)

2. ¿En qué hora deberías tomar un vuelo para evitar retrasos lo más posible?

flights %>%
filter(dep_delay <= 0, arr_delay <= 0)

flights %>% 
group_by(hour) %>% 
summarise(n = n(),
arr_delay_prom = mean(arr_delay, na.rm = TRUE)) %>% 
arrange(arr_delay_prom)

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