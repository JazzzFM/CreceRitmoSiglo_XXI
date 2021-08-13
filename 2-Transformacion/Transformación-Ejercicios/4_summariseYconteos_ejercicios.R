# Transformación: Ejercicicos 4 - summarise y conteos --------------------------------------------


### Ejercicios: resumenes y conteos
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