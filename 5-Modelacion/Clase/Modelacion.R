# Clase 1: Introducción a modelos lineales --------------------------------
"
Aquí solo cubrimos **modelos predictivos** que, como su nombre indica ...

Desarrollarás una intuición sobre cómo funcionan los modelos estadísticos ...
"

## Conceptos básicos de modelos

"
El objetivo de un modelo es proporcionar un resumen simple de baja
dimensión de un conjunto de datos.

Usaremos modelos para dividir datos en patrones y residuos. 

Esta clase solo usa conjuntos de datos simulados.

Hay dos partes en un modelo.

**Primero** 
  Define una familia de modelos que expresan un patrón preciso,
  pero genérico. Por ejemplo:
  El patrón puede ser una línea recta o una curva cuadrática. 

**Segundo**:
  Genera un modelo ajustado encontrando el modelo de la familia más
  cercano a tus datos.
"

## Requisitos previos

library(tidyverse)
library(ggplot2)
require("maps")
library(modelr)
options(na.action = na.warn)


## Un modelo simple

"
Echemos un vistazo al conjunto de datos simulado `sim1`,
incluido con el paquete `modelr`
"  

ggplot(sim1, aes(x, y)) +
  geom_point()

"
Puedes ver un patrón fuerte en los datos. 
En este caso, la relación parece lineal, 
es decir, `y = a_0 + a_1 * x`. 
"

models <- tibble(
  a0 = runif(250, -20, 40),
  a1 = runif(250, -5, 5)
)

ggplot(sim1, aes(x, y)) + 
  geom_abline(aes(intercept = a0, slope = a1), data = models, alpha = 1/4) +
  geom_point() 

"
Hay 250 modelos en esta grafica, **¡pero muchos son realmente malos!** 

Necesitamos una forma de cuantificar la distancia entre los datos y un modelo.
Luego, podemos ajustar el modelo encontrando el valor de `a_0` y `a_1` 

Esta distancia es solo la diferencia entre el valor dado por el modelo
(la predicción) y el valor de y real en los datos (la respuesta).
"

model1 <- function(a, data) {
  a[1] + data$x * a[2]
}

model1(c(7, 1.5), sim1)

"
A continuación, necesitamos alguna forma de calcular una distancia total
entre los valores predichos y reales. 

Una forma común de hacer esto en las estadísticas es utilizar la 
**La desviación de la raíz cuadrática media o el error cuadrático medio**.
"

measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}

measure_distance(c(7, 1.5), sim1)

"
Ahora podemos usar `purrr` para 
calcular la distancia para todos 
los modelos definidos anteriormente. 
"

library(purrr)
sim1_dist <- function(a0, a1) {
  measure_distance(c(a0, a1), sim1)
}

models <- models %>% 
  mutate(dist = purrr::map2_dbl(a0, a1, sim1_dist))
models

"
A continuación, superpongamos los 10 mejores modelos a los datos. 
Hemos coloreado los modelos por `-dist`:
"

ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a0, slope = a1, colour = -dist), 
    data = filter(models, min_rank(dist) <= 10)
  )

"
También podemos pensar en estos modelos como observaciones,
y visualizar con una gráfica de dispersión de `a0` vs `a1`, 
nuevamente coloreado por `-dist`. 
"

ggplot(models, aes(a0, a1)) +
  geom_point(data = filter(models, min_rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist))

"
En lugar de probar muchos modelos aleatorios, 
podríamos ser más sistemáticos y generar una
cuadrícula de puntos espaciados uniformemente
(esto se llama búsqueda de cuadrícula). 

Elegí los parámetros de la cuadrícula aproximadamente
al observar dónde estaban los mejores modelos en el gráfico de arriba.
"

grid <- expand.grid(
  a0 = seq(-5, 20, length = 25),
  a1 = seq(1, 3, length = 25)
) %>% 
  mutate(dist = purrr::map2_dbl(a0, a1, sim1_dist))

grid %>% 
  ggplot(aes(a0, a1)) +
  geom_point(data = filter(grid, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist))

"
Cuando superpone los 10 mejores modelos sobre los datos originales,
todos se ven bastante bien:
" 

ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a0, slope = a1, colour = -dist), 
    data = filter(grid, rank(dist) <= 10)
  )


"
Usaremos una herramienta de minimización numérica llamada búsqueda 
de **Newton-Raphson**. 

En R, podemos hacer eso con `optim()`:
"  

best <- optim(c(0, 0), measure_distance, data = sim1)
best$par

ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(intercept = best$par[1], slope = best$par[2])

"
No se te preocupes demasiado por los detalles
de cómo funciona `optim()`. 

Es la intuición lo que es importante aquí. 

R tiene una herramienta diseñada específicamente para ajustar modelos
lineales llamada `lm()`. 

`lm()` tiene una forma especial de especificar la familia de modelos: 
fórmulas.

Las fórmulas se ven como `y ~ x`, que `lm()` se traducirá en una función
como `y = a_1 + a_2 * x`. 

Podemos ajustar el modelo y mirar el resultado:
" 

sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod)


"
¡Estos son exactamente los mismos valores que obtuvimos con `optim()`!

Detrás de escena `lm()` no usa `optim()` sino que aprovecha la
  estructura matemática de los modelos lineales. 
"

### Predicciones

"
Para visualizar las predicciones de un modelo, 
comenzamos generando una cuadrícula de valores 

La forma más sencilla de hacerlo es usar `modelr::data_grid()`. 
"  

grid <- sim1 %>% 
  data_grid(x) 

grid


"
A continuación, agregamos predicciones. 
"
 
grid <- grid %>% 
  add_predictions(sim1_mod) 

grid


"
A continuación, graficamos las predicciones. 

Solo estás limitado por tus habilidades de visualización. 
"

ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)


### Residuos
"
Las predicciones le indican el patrón que ha capturado el modelo y
los residuales le indican qué se ha perdido el modelo. 

Agregamos residuos a los datos con `add_residuals()`
"

sim1 <- sim1 %>% 
  add_residuals(sim1_mod)

sim1

"
Hay algunas formas diferentes de entender lo que nos dicen
los residuos sobre el modelo.

Una forma es simplemente dibujar un polígono de frecuencia:
"  

ggplot(sim1, aes(resid)) + 
  geom_freqpoly(binwidth = 0.5)

"
Esto ayuda a calibrar la calidad del modelo: 
¿a qué distancia están las predicciones de los valores observados?
"

ggplot(sim1, aes(x, resid)) + 
  geom_ref_line(h = 0) +
  geom_point() 


"
Esto parece un ruido aleatorio, lo que sugiere que nuestro modelo ha hecho
un buen trabajo al capturar los patrones en el conjunto de datos.
"

### Ejercicios
"
1 - En lugar de usar `lm()` para ajustar una línea recta, 
    puede usar `loess()` para ajustar una curva suave. 
    Repita el proceso de ajuste del modelo, generación de
    cuadrículas, predicciones y visualización en `sim1` 
    usando `loess()` en lugar de `lm()`. 
    ¿Cómo se compara el resultado con `geom_smooth()`?
  
  2 - `add_predictions()` está emparejado con `collect_predictions()`
      y `spread_predictions()`. ¿En qué se diferencian estas tres funciones?
  
  3 - ¿Qué hace `geom_ref_line()`? ¿De qué paquete viene? 
      ¿Por qué es útil e importante mostrar una línea de 
      referencia en los gráficos que muestran los residuos?
  
  4 - ¿Por qué querrías mirar un polígono de frecuencia de
      residuos absolutos? ¿Cuáles son los pros y los contras 
      en comparación con observar los residuos sin procesar?
"



# Clase 2: Construir un modelo --------------------------------------------
"
Esta sección se enfocará en datos reales y
te mostrará cómo puede construir progresivamente un modelo
para ayudarlo a comprender los datos.

Es un desafío saber cuándo detenerse.
  
  “Un artista necesita saber cuándo está terminada una obra. 
    No se puede ajustar algo a la perfección.
    Si no le gusta, hágalo de nuevo. 
    De lo contrario, comience algo nuevo ”.
"

### Prerrequisitos
"
Agregaremos algunos conjuntos de datos reales: vuelos de `nycflights13`. 
También necesitaremos lubridate 
"

library(tidyverse)
library(modelr)
options(na.action = na.warn)
library(nycflights13)
library(lubridate)    


### ¿Qué afecta la cantidad de vuelos diarios?
"
Comencemos contando el número de vuelos por día y visualizándolo con `ggplot2`.
"

daily <- flights %>% 
  mutate(date = make_date(year, month, day)) %>% 
  group_by(date) %>% 
  summarise(n = n())

daily


ggplot(daily, aes(date, n)) + 
  geom_line()


### Día de la semana
"
Comprender la tendencia a largo plazo es un desafío 

Comencemos observando la distribución de los números de
vuelo por día de la semana:
"

daily <- daily %>% 
  mutate(wday = wday(date, label = TRUE))

ggplot(daily, aes(wday, n)) + 
  geom_boxplot()

"
Hay menos vuelos los fines de semana porque la mayoría de los viajes
son por negocios.

El efecto es particularmente pronunciado el sábado:

Una forma de eliminar este patrón fuerte es usar un modelo. 
"

mod <- lm(n ~ wday, data = daily)

grid <- daily %>% 
  data_grid(wday) %>% 
  add_predictions(mod, "n")

ggplot(daily, aes(wday, n)) + 
  geom_boxplot() +
  geom_point(data = grid, colour = "red", size = 4)

"
A continuación, calculamos y visualizamos los residuos:
"

daily <- daily %>% 
  add_residuals(mod)

daily %>% 
  ggplot(aes(date, resid)) + 
  geom_ref_line(h = 0) + 
  geom_line()

"
Observa el cambio en el eje `y`:
  * 1 - Nuestro modelo parece fallar a partir de junio: 
"

ggplot(daily, aes(date, resid, colour = wday)) + 
  geom_ref_line(h = 0) + 
  geom_line()

"
* Nuestro modelo no puede predecir con precisión la cantidad
  de vuelos el sábado

* 2 - Hay algunos días con muchos menos vuelos de los esperados:
"

daily %>% 
  filter(resid < -100)

"
Puedes ver el día de Año Nuevo, el 4 de julio, 
  el Día de Acción de Gracias y la Navidad

* 3 - Parece haber una tendencia a largo plazo más
      suave en el transcurso de un año. 
  
Podemos resaltar esa tendencia con `geom_smooth()`:
" 

daily %>% 
  ggplot(aes(date, resid)) + 
  geom_ref_line(h = 0) + 
  geom_line(colour = "grey50") + 
  geom_smooth(se = FALSE, span = 0.20)

"
* Observación 4:
  Hay menos vuelos en enero (y diciembre) y más
  en verano (mayo-septiembre). 

No podemos hacer mucho con este patrón cuantitativamente, 
porque solo tenemos un año de datos. 
"

### Efecto sábado estacional
"
Primero, abordemos nuestro fracaso en predecir con precisión
la cantidad de vuelos el sábado. 

Un buen lugar para comenzar es volver a los números brutos,
centrándose en los sábados:
"

daily %>% 
  filter(wday == "sat") %>% 
  ggplot(aes(date, n)) + 
    geom_point() + 
    geom_line() +
    scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")

"
Se sospecha que este patrón se debe a las vacaciones de verano
¿Por qué hay más vuelos los sábados en primavera que en otoño? 

Creemos una variable de 'term' que capture aproximadamente los 
tres términos escolares y verifiquemos nuestro trabajo con una gráfica:
"

term <- function(date) {
  cut(date, 
    breaks = ymd(20130101, 20130605, 20130825, 20140101),
    labels = c("primavera", "verano", "otoño") 
  )
}

daily <- daily %>% 
  mutate(term = term(date)) 

daily %>% 
  filter(wday == "sat") %>% 
  ggplot(aes(date, n, colour = term)) +
  geom_point(alpha = 1/3) + 
  geom_line() +
  scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")

"
Modificamos manualmente las fechas para obtener buenos descansos en la gráfica.

Es útil ver cómo esta nueva variable afecta a los otros días de la semana:
"

daily %>% 
  ggplot(aes(wday, n, colour = term)) +
    geom_boxplot()

"
Parece que hay una variación significativa entre los términos

Esto mejora nuestro modelo, pero no tanto como podríamos esperar:
"

mod1 <- lm(n ~ wday, data = daily)

"
Explicar la interacción
"

mod2 <- lm(n ~ wday * term, data = daily)

daily %>% 
  gather_residuals(without_term = mod1, with_term = mod2) %>% 
  ggplot(aes(date, resid, colour = model)) +
    geom_line(alpha = 0.75)

"
Nuestro modelo está encontrando el efecto medio,
pero tenemos muchos valores atípicos importantes

Podemos aliviar este problema utilizando un modelo que sea
robusto al efecto de valores atípicos: `MASS::rlm()`
"

mod3 <- MASS::rlm(n ~ wday * term, data = daily)

daily %>% 
  add_residuals(mod3, "resid") %>% 
  ggplot(aes(date, resid)) + 
  geom_hline(yintercept = 0, size = 2, colour = "white") + 
  geom_line()

"
Ahora es mucho más fácil ver la tendencia a largo plazo y los
valores atípicos positivos y negativos.
"

### Ejercicios
"
  * 1 - Use sus habilidades de investigación de Google para pensar 
        en por qué hubo menos vuelos de los esperados el 20 de enero,
        el 26 de mayo y el 1 de septiembre. 
        (Pista: todos tienen la misma explicación). 
        ¿Cómo se generalizarían estos días a otro año?
  
  * 2 - ¿Qué representan los tres días con altos residuos positivos? 
        ¿Cómo se generalizarían estos días a otro año?

daily %>% 
  slice_max(n = 3, resid)

  * 3 - Crea una nueva variable que divida la variable `wday` en
        términos, pero solo para los sábados, es decir, debería 
        tener `jue`, `vie`, pero `sáb-verano`, `sáb-primavera`,
        `sáb-otoño`. ¿Cómo se compara este modelo con el modelo 
        con cada combinación de `wday` y `term`?

  * 4- Crea una nueva variable `wday` que combine el día de la semana,
       el plazo (para los sábados) y los días festivos. 
       ¿Cómo se ven los residuos de ese modelo?
"


## Modelo para Diamonds

"
**¿Por qué los diamantes de baja calidad son más caros?**
  
  Hemos visto una relación sorprendente entre la calidad de los diamantes y
  su precio: los diamantes de baja calidad tienen precios más altos.
"


ggplot(diamonds, aes(cut, price)) + geom_boxplot()

ggplot(diamonds, aes(color, price)) + geom_boxplot()

ggplot(diamonds, aes(clarity, price)) + geom_boxplot()


"
Ten en cuenta que el peor color de diamante es J (ligeramente amarillo) y
la peor claridad es I1 (inclusiones visibles a simple vista).
"

### Precio y quilates
"
Parece que los diamantes de menor calidad tienen precios más altos porque
existe una importante variable de confusión: el peso en quilates (`carat`)
del diamante. 

El peso del diamante es el factor más importante para determinar el precio
del diamante, y los diamantes de menor calidad tienden a ser más grandes.
"

ggplot(diamonds, aes(carat, price)) + 
  geom_hex(bins = 50)

"
Podemos hacer que sea más fácil ver cómo los otros atributos de un diamante
afectan su precio relativo ajustando un modelo para separar el efecto del quilate.

Hagamos un par de ajustes para que sea más fácil trabajar:
* Centrarse en diamantes de menos de 2,5 quilates (99,7% de los datos)
* Transformar logarítmicamente las variables de precio y quilates.
"

diamonds2 <- diamonds %>% 
  filter(carat <= 2.5) %>% 
  mutate(lprice = log2(price), lcarat = log2(carat))

"
Juntos, estos cambios facilitan ver la relación entre el `carat` y `price`:
"

ggplot(diamonds2, aes(lcarat, lprice)) + 
  geom_hex(bins = 50)

"
La transformación logarítmica es particularmente útil aquí porque hace 
que el patrón sea lineal, y los patrones lineales son los más fáciles de
trabajar. 

Demos el siguiente paso y eliminemos ese fuerte patrón lineal.
"

mod_diamond <- lm(lprice ~ lcarat, data = diamonds2)

"
Ten en cuenta que volvemos a transformar las predicciones
"
  
grid <- diamonds2 %>% 
  data_grid(carat = seq_range(carat, 20)) %>% 
  mutate(lcarat = log2(carat)) %>% 
  add_predictions(mod_diamond, "lprice") %>% 
  mutate(price = 2 ^ lprice)

ggplot(diamonds2, aes(carat, price)) + 
  geom_hex(bins = 50) + 
  geom_line(data = grid, colour = "red", size = 1)

"
Si creemos en nuestro modelo, entonces los diamantes 
grandes son mucho más baratos de lo esperado. 

Esto probablemente se deba a que ningún diamante en 
este conjunto de datos cuesta más de **$19,000.00**.

Ahora podemos mirar los residuos
"

diamonds2 <- diamonds2 %>% 
  add_residuals(mod_diamond, "lresid")

ggplot(diamonds2, aes(lcarat, lresid)) + 
  geom_hex(bins = 50)


"
Es importante destacar que ahora podemos volver a hacer
nuestros gráficos de motivación utilizando esos residuos en lugar de `price`.
"

ggplot(diamonds2, aes(cut, lresid)) + geom_boxplot()

ggplot(diamonds2, aes(color, lresid)) + geom_boxplot()

ggplot(diamonds2, aes(clarity, lresid)) + geom_boxplot()


"
Ahora vemos la relación que esperamos: 
  a medida que aumenta la calidad del diamante,
  también lo hace su precio relativo. 

Para interpretar el eje `y`, debemos pensar en lo 
que nos dicen los residuos y en qué escala se encuentran. 

Un residuo de -1 indica que `lprice` fue 1 unidad más bajo
que una predicción basada únicamente en su peso.
"


### Ejercicios
"
* 1 - En la gráfica de `lcarat` frente a `lprice`, hay algunas franjas 
    verticales brillantes. ¿Qué representan?
  
  * 2 - Si `log(price) = a_0 + a_1 * log(carat)`, ¿qué dice eso sobre 
        la relación entre `price` y `carat`?
  
  * 3 - Extrae los diamantes que tienen residuos muy altos y muy bajos. 
      ¿Hay algo inusual en estos diamantes? ¿Son particularmente malos 
      o buenos, o cree que se trata de errores de precios?
  
"

### Aprende más sobre los modelos

"
Solo hemos arañado la superficie absoluta del modelado,
pero esperamos que haya obtenido algunas herramientas 
simples pero de propósito general que puede usar para 
mejorar sus propios análisis de datos. 

 
El modelaje realmente merece un curso por sí solo. Recomiendo:

  * **Modelado estadístico**: 
      un nuevo enfoque de Danny Kaplan, http://project-mosaic-books.com/?page_id=13. 

  * **Una introducción al aprendizaje estadístico**: de Gareth James,
      Daniela Witten, Trevor Hastie y Robert Tibshirani, 
      http://www-bcf.usc.edu/~gareth/ISL/ (disponible en línea de forma gratuita).
      
  * **Modelado predictivo aplicado** : de Max Kuhn y Kjell Johnson, 

"

  