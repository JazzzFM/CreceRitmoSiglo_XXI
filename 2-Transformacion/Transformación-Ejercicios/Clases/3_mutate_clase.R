# Transformación: Clase 3 - mutate --------------------------------------------

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
**Operaciones cumulativas**: 
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

6. ¿Qué funciones trigonométricas provee R?
"
