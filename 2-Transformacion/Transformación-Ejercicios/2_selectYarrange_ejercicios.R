# Transformación: Ejercicicos 2 - select y arrange --------------------------------------------

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


### Ejercicios: arrange
"
1. ¿Cómo podría usar arrange() para ordenar todos los valores faltantes desde el principio?
   (Sugerencia: use is.na ()).

2. Ordene vuelos para encontrar los vuelos más retrasados. Encuentra los vuelos que salieron 
   antes.

3. Ordene vuelos para encontrar los vuelos más rápidos (de mayor velocidad).

4. ¿Qué vuelos viajaron más lejos? ¿Cuál viajó más corto?
"