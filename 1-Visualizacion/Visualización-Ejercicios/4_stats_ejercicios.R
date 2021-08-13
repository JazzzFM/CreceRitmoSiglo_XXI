# Visualización: Ejercicicos 4 - Stats --------------------------------------------

# 1. ¿Cuál es el geom por defecto de stat_summary? 
#    ¿Cómo podrías re hacer la gráfica anterior utilizando la
#    función geom en lugar de stat geom_pointrange()?
#    el deffault de ese geom es identity pero lo podemos cambiar por summary 
#    el default es mean y sd. no median, min y max
# 2. ¿Qué hace geom_col? Cuál es la diferencia con geom_bar?
#    La transformación default es identity, que deja los datos como estan.
#    El parámetro default para stat de geom_bar es stat_count().
#    Sólo espera un valor de x para contarlo.
# 3. La mayoría de las geoms y stats vienen en parejas que casi siempre se usan
#    en conjunto. Has una lista de las parejas. ¿Qué tienen en común?
# 4. ¿Qué variables computa stat_smooth?
#    ¿Qué parámetros controla su comportamiento? ?stat_smooth  method y formula

########### pct sobre el grupo color
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut,y = after_stat(prop), group = color, fill = color))

diamonds %>% count(cut, color) %>% group_by(color) %>% mutate(pct = n/sum(n)) %>% 
  ggplot() + geom_col(aes(x = cut, y = pct, fill = color))
########### pct sobre el grupo cut
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, group = color, fill = color), position = "fill")

diamonds %>% count(cut, color) %>% group_by(cut) %>% mutate(pct = n / sum(n)) %>% 
  ggplot() + geom_col(aes(x = cut, y = pct, fill = color))


"
Soluciones Stats:
1. La gráfica anterior a la que se hace referencia en la pregunta es la siguiente.

ggplot(data = diamonds) +
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )
  
  Los argumentos fun.ymin, fun.ymax y fun.y han sido obsoletos y 
  reemplazados por fun.min, fun.max y fun en ggplot2 v 3.3.0.

La geom predeterminada para stat_summary() es geom_pointrange().
La estadística predeterminada para geom_pointrange() es identity()
pero podemos agregar el argumento stat = 'summary' para usar 
stat_summary() en lugar de stat_identity()

ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = 'summary'
  )

El mensaje resultante dice que stat_summary() usa la media y sd para calcular el 
punto medio y los puntos finales de la línea. Sin embargo, en el gráfico original
se utilizaron los valores mínimo y máximo para los criterios de valoración. 

Para recrear la gráfica original, necesitamos especificar valores para
fun.min, fun.max y fun.

ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = 'summary',
    fun.min = min,
    fun.max = max,
    fun = median
  )
  
2. La función geom_col() tiene una estadística predeterminada diferente a geom_bar().
La estadística predeterminada de geom_col() es stat_identity(), que deja los datos
como están. La función geom_col() espera que los datos contengan valores xy valores 
y que representan la altura de la barra.

3. Las siguientes tablas enumeran los pares de geoms y
estadísticas que casi siempre se usan en conjunto.

geom_bar()	stat_count()
geom_bin2d()	stat_bin_2d()
geom_boxplot()	stat_boxplot()
geom_contour_filled()	stat_contour_filled()
geom_contour()	stat_contour()
geom_count()	stat_sum()
geom_density_2d()	stat_density_2d()
geom_density()	stat_density()
geom_dotplot()	stat_bindot()
geom_function()	stat_function()
geom_sf()	stat_sf()
geom_sf()	stat_sf()
geom_smooth()	stat_smooth()
geom_violin()	stat_ydensity()
geom_hex()	stat_bin_hex()
geom_qq_line()	stat_qq_line()
geom_qq()	stat_qq()
geom_quantile()	stat_quantile()

Estos pares de geoms y estadísticas tienden a tener sus nombres en común, 
como stat_smooth() y geom_smooth() y se documentan en la misma página de ayuda.

Los pares de geoms y estadísticas que se usan en conjunto a menudo se tienen
entre sí como la estadística predeterminada (para una geom) o geom (para una estadística).

Las siguientes tablas contienen geoms y estadísticas en ggplot2 y sus valores 
predeterminados a partir de la versión 3.3.0. Muchas geoms tienen stat_identity()
como estadística predeterminada.

4. La función stat_smooth () calcula las siguientes variables:

y: valor predicho
ymin: valor más bajo del intervalo de confianza
ymax: valor superior del intervalo de confianza
se: error estándar

La sección 'Variables calculadas' de la documentación de stat_smooth()
contiene estas variables.

Los parámetros que controlan el comportamiento de stat_smooth() incluyen:

método: Este es el método utilizado para calcular la línea de suavizado. 
Si es NULL, se usa un método predeterminado basado en el tamaño de la muestra: 
stats::loess() cuando hay menos de 1,000 observaciones en un grupo, y mgcv::gam()

fórmula: cuando se proporciona un argumento de método personalizado, 
la fórmula a utilizar. El valor predeterminado es y ~ x. 
Por ejemplo, para usar la línea implícita en lm (y ~ x + I (x ^ 2) + I (x ^ 3)),
use método = 'lm' o método = lm y fórmula = y ~ x + I (x ^ 2) + I (x ^ 3).

method.arg (): Argumentos distintos a la fórmula, que ya está especificada en el 
argumento de la fórmula, para pasar a la función inmethod.

se: Si es VERDADERO, muestra las bandas de error estándar; si es FALSO, solo muestra la línea.

na.rm: si es FALSO, los valores faltantes se eliminan con una advertencia; si es TRUE,
se eliminan silenciosamente. El valor predeterminado es FALSE para facilitar la depuración. 

Si se sabe que hay valores perdidos en los datos, se pueden ignorar, pero si no se
anticipan los valores perdidos, esta advertencia puede ayudar a detectar errores.

"