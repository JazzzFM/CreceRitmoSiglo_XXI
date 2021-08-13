# Transformación - Clase 2 - select y arrange ----------------------------------------------------------
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

select(flights, time_hour, air_time, everything())

"
Otra forma de cambiar el orden de las columnas es con `relocate()` 
"

relocate(flights, time_hour, dep_time, .before = year)


"Revisa `?relocate` para mayor detalle."

### Ejercicios: select

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