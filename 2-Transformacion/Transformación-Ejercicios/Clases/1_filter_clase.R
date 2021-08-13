# Transformación - Clase 1 - filter ----------------------------------------------------------
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

filter(flights, month %in% c(11,12))


"
Algunas veces filtros complicados se pueden simplificar con la ley De Morgan:
* `!(x & y)` es lo mismo a `!x | !y`
* `!(x | y)` es lo mismo a `!x & !y`

Por ejemplo:
"

filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)


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