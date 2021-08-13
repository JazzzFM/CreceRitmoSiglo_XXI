# Visualización: Ejercicicos Introducción --------------------------------------------

# 1. Encuentra todos los vuelos que:
# * Que tuviern un retraso de llegada de 2 horas o más
# * Volaron a Houston (IAH o HOU)
# * fueron operados por United, American, o Delta
# * Salieron en Julio, Agosto y Septiembre
# * LLegaron más de dos horas tarde pero no salieron tarde
# * Salieron al menos una hora tarde pero recuperaron 30 minutos de vuelo
# * Salieron de la media noche a las 6am (incluyéndo)
# 
# 2. Otra función muy útil de `dplyr` es `between()`. ¿Qué hace? 
#   ¿Podrías utilizarlo para simplificar el código  para responder las
#   preguntas anteriores?
#   
# 3. ¿Cuántos vuelos no tienen información en la variable `dep_time`? 
#    ¿Qué otras variables faltan? ¿Qué podrían representar estos renglones?
#   
# 4. ¿Por qué `NA ^ 0`, `NA | TRUE`, `FALSE & NA` no son valores faltantes?
#    ¿Podrías descubrir una regla general? (NA * 0 tiene truco)



"
Soluciones:
1. 
  1.1 filter(flights, arr_delay >= 120)
  1.2 filter(flights, dest == 'IAH' | dest == 'HOU') o bien 
      filter(flights, dest %in% c('IAH', 'HOU'))
  1.3 filter(flights, carrier %in% c('AA', 'DL', 'UA'))
  1.4 filter(flights, month >= 7, month <= 9) o bien filter(flights, month %in% 7:9)
      filter(flights, month == 7 | month == 8 | month == 9)
  1.5 filter(flights, arr_delay > 120, dep_delay <= 0)
  1.6 filter(flights, dep_delay >= 60, dep_delay - arr_delay > 30)
 
  1.7 Se retrasaron al menos una hora, pero recuperaron más de 30 minutos en vuelo. 
      Si un vuelo se retrasó al menos una hora, entonces dep_delay> = 60. Si el vuelo
      no recuperaba ningún tiempo en el aire, su llegada se retrasaría en la misma cantidad
      que su salida, es decir, dep_delay == arr_delay o, alternativamente, 
      dep_delay - arr_delay == 0. 
      
      Si supera los 30 minutos en el aire, la demora de llegada debe ser al menos 30 
      minutos menor que la demora de salida, que se indica como dep_delay - arr_delay> 30.
      
      filter(flights, dep_delay >= 60, dep_delay - arr_delay > 30)
      
    1.8 Encontrar vuelos que partieron entre la medianoche y las 6 a.m. es complicado por
        la forma en que se representan las horas en los datos.
        
        En dep_time, la medianoche está representada por 2400, no 0. Puede verificar esto 
        marcando el mínimo y el máximo de dep_time.
        
        summary(flights$dep_time)
        
        Este es un ejemplo de por qué siempre es bueno verificar las estadísticas resumidas
        de sus datos. Desafortunadamente, esto significa que no podemos simplemente verificar
        que dep_time <600, porque también tenemos que considerar el caso especial de la
        medianoche.
    
        filter(flights, dep_time <= 600 | dep_time == 2400)
        
        Alternativamente, podríamos usar el operador de módulo, %%. El operador de módulo 
        devuelve el resto de la división. Veamos cómo afecta esto a nuestros tiempos.
        
        c(600, 1200, 2400) %% 2400
        
        Dado que 2400 %% 2400 == 0 y todos los demás tiempos se dejan sin cambios, 
        podemos comparar el resultado de la operación de módulo con 600,

        filter(flights, dep_time %% 2400 <= 600)
        
        Esta expresión de filtro es más compacta, pero su legibilidad depende de la 
        familiaridad del lector con la aritmética modular.

2.  La expresión between(x, izquierda, derecha) es equivalente a x >= izquierda y x <= derecha.

    De las respuestas de la pregunta anterior, podríamos simplificar el enunciado de partió en 
    verano (mes> = 7 y mes <= 9) usando la función between().
    
    filter(flights, between(month, 7, 9))
    
3. Encuentre las filas de vuelos con una hora de salida faltante (dep_time) 
   usando la función is.na ().
    
    filter(flights, is.na(dep_time))
    
   En particular, la hora de llegada (arr_time) también falta para estas filas.
   Estos parecen ser vuelos cancelados.

  La salida de la función summary() incluye el número de valores perdidos para
  todas las variables que no son caracteres.
  
    summary(flights)  
    
4. Dado que x ∗ 0 = 0 para todos los números finitos, podríamos esperar NA * 0 == 0,
   pero ese no es el caso. La razón por la que NA * 0! = 0 es que 0 * ∞ y 0 * - ∞ no
   están definidos.
   
   R representa resultados indefinidos como NaN, que es una abreviatura de 'no es un número'.
   
   Inf * 0
  -Inf * 0
"
