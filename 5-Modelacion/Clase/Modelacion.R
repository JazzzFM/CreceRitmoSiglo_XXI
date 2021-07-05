# Introducción ------------------------------------------------------------

"
El enfoque de este curso es la exploración,
no la confirmación o la inferencia formal.

El objetivo de un modelo es proporcionar un resumen simple ...

Aquí solo cubrimos **modelos predictivos** que, como su nombre indica ...

Desarrollarás una intuición sobre cómo funcionan los modelos estadísticos ...
  
* En los **conceptos básicos** de modelación,
  aprenderás cómo funcionan los modelos de forma mecánica,
  centrándose en la importante familia de modelos lineales.

* En la **construcción de modelos**, aprenderás a usar modelos para extraer
  patrones conocidos en datos reales.

Estos temas son notables por lo que no incluyen: 
ninguna herramienta para evaluar modelos cuantitativamente.

Por ahora, dependerá de la evaluación cualitativa y de su escepticismo natural.
"


# Generación de hipótesis vs confirmación de hipótesis --------------------
"
Vamos a utilizar modelos como herramienta de exploración,

No es así como se suelen enseñar los modelos, pero como verás, 
los modelos son una herramienta importante: herramienta de exploración. 

Tradicionalmente, el enfoque del modelado está en la inferencia o 
para confirmar que una hipótesis es cierta. 

Hacer esto correctamente no es complicado, pero es difícil. 

Hay un par de ideas que debe comprender para hacer inferencias correctamente:
* Cada observación puede usarse para exploración o confirmación, no ambas.
* Puedes utilizar una observación tantas veces como desees para la exploración,
  pero solo puede utilizarla una vez para la confirmación. 

Esto es necesario porque para confirmar una hipótesis debe utilizar datos
independientes de los datos que utilizaste para generar la hipótesis.

Si realmente desea realizar un análisis confirmatorio, 
un enfoque es dividir sus datos en tres partes antes de comenzar el análisis:
  
* El 60% de sus datos va a un conjunto de entrenamiento 
* El 20% se destina a un conjunto de consultas. 
* El 20% se retiene para una prueba. 

Esta partición le permite explorar los datos de entrenamiento

Cuando esté seguro de que tiene el modelo correcto,
puede verificarlo una vez con los datos de prueba.
"

## Conceptos básicos de modelos

### Introducción
"
El objetivo de un modelo es proporcionar un resumen simple de baja
dimensión de un conjunto de datos.

Usaremos modelos para dividir datos en patrones y residuos. 

Es necesario comprender los conceptos básicos de cómo
funcionan los modelos. 

Por esa razón, esta sección solo usa conjuntos de datos simulados.
Estos conjuntos de datos son muy simples y nada interesantes, pero ayudan ...

Hay dos partes en un modelo.

**Primero** 
  Define una familia de modelos que expresan un patrón preciso,
  pero genérico

**Por ejemplo**:
  El patrón puede ser una línea recta o una curva cuadrática. E

**Segundo**:
  Genera un modelo ajustado encontrando el modelo de la familia más
  cercano a tus datos.

Es importante comprender que un modelo ajustado es solo el modelo más 
cercano de una familia de modelos. 

Eso implica que tienes el 'mejor' modelo (según algunos criterios); 
no implica que tenga un buen modelo y ciertamente no implica que el 
modelo sea 'verdadero'. 

Para un modelo de este tipo, no es necesario plantearse la pregunta 
'¿Es el modelo verdadero?'. 

Si la 'verdad' va a ser la 'verdad total', la respuesta debe ser 'No'.
La única pregunta de interés es '¿Es el modelo esclarecedor y útil?'.

El objetivo de un modelo no es descubrir la verdad, sino descubrir una
aproximación simple que aún sea útil.
"

### Requisitos previos
"
Usaremos el paquete `modelr` que envuelve las funciones de
modelado de la base R para que funcionen de forma natural en un ` %>% `
" 

library(tidyverse)
library(ggplot2)
require("maps")
library(modelr)
options(na.action = na.warn)


# Un modelo simple --------------------------------------------------------

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

Necesitamos encontrar los buenos modelos haciendo precisa nuestra intuición
de que un buen modelo está **cerca** de los datos. 

Necesitamos una forma de cuantificar la distancia entre los datos y un modelo.
Luego, podemos ajustar el modelo encontrando el valor de `a_0` y `a_1` 


Esta distancia es solo la diferencia entre el valor dado por el modelo
(**la predicción**) y el valor de y real en los datos (**la respuesta**).

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
    data = filter(models, rank(dist) <= 10)
  )

"
También podemos pensar en estos modelos como observaciones,
y visualizar con una gráfica de dispersión de `a0` vs `a1`, 
nuevamente coloreado por `-dist`. 
"

ggplot(models, aes(a0, a1)) +
  geom_point(data = filter(models, rank(dist) <= 10), size = 4, colour = "red") +
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

La intuición de **Newton-Raphson** es bastante simple: 
  eliges un punto de partida y miras a tu alrededor en busca de la pendiente
  más empinada. A continuación, esquías por esa pendiente un poco y luego
  repites una y otra vez, hasta que no puedas bajar más. 

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

Hay un enfoque más que podemos utilizar para este modelo,
porque es un caso especial de una familia más amplia: los modelos lineales.

Un modelo lineal tiene la forma general 
`y = a_1 + a_2 * x_1 + a_3 * x_2 + ... + a_n * x_ (n - 1)`. 

Entonces, este modelo simple es equivalente a un modelo lineal general
donde `n` es `2` y `x_1` es `x`. 

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
### Ejercicios
"
1 - Una desventaja del modelo lineal es que es sensible a valores inusuales porque la distancia incorpora un término al cuadrado. Ajusta un modelo lineal a los datos simulados a continuación y visualiza los resultados. Vuelva a ejecutar varias veces para generar diferentes conjuntos de datos simulados. ¿Qué notas sobre el modelo?
sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)


2 - Una forma de hacer que los modelos lineales sean más robustos es utilizar una medida de distancia diferente. Por ejemplo, en lugar de la distancia de la raíz cuadrada media, puede usar la distancia media absoluta:
measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  mean(abs(diff))
}

Utiliza `optim()` para ajustar este modelo a los datos simulados
anteriores y compárelo con el modelo lineal.

3 - Un desafío al realizar la optimización numérica es que solo está garantizado encontrar un óptimo local. ¿Cuál es el problema de optimizar un modelo de tres parámetros como este?
model1 <- function(a, data) {
  a[1] + data$x * a[2] + a[3]
}
"
## Visualización de modelos
"
Para modelos simples, puede averiguar qué patrón captura
el modelo estudiando cuidadosamente la familia del modelo y los coeficientes
ajustados. 

Y si alguna vez tomas un curso de estadística sobre modelado, 
es probable que dediques mucho tiempo a hacerlo.

Nos centraremos en comprender un modelo observando sus predicciones.
Esto tiene una gran ventaja:
  cada tipo de modelo predictivo hace predicciones 

También es útil ver lo que el modelo no captura
"

### Predicciones
"
Para visualizar las predicciones de un modelo, 
comenzamos generando una cuadrícula de valores 
espaciados uniformemente que cubre la región
donde se encuentran nuestros datos.

La forma más sencilla de hacerlo es usar `modelr::data_grid()`. 
Su primer argumento es un marco de datos, y para cada argumento
subsiguiente encuentra las variables únicas y luego genera todas
las combinaciones:
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
Quizás se pregunte acerca de todo este trabajo
adicional en comparación con solo usar `geom_abline()`.

Solo estás limitado por tus habilidades de visualización. 
"

ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", size = 1)


### Residuos
"
La otra cara de las predicciones son los **residuos**. 

Las predicciones le indican el patrón que ha capturado el modelo y
los residuales le indican qué se ha perdido el modelo. 

Agregamos residuos a los datos con `add_residuals()`,
que funciona de manera muy similar a `add_predictions()`.
"

sim1 <- sim1 %>% 
  add_residuals(sim1_mod)
sim1

"
Hay algunas formas diferentes de entender lo que nos dicen
los residuos sobre el modelo.

Una forma es simplemente dibujar un polígono de frecuencia 
para ayudarnos a comprender la dispersión de los residuos:
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

## Fórmulas y familias de modelos
"
Has visto fórmulas antes al usar `facet_wrap()` y `facet_grid()`. 

La mayoría de las funciones de modelado en R 
utilizan una conversión estándar de fórmulas a funciones. 

Ya has visto una conversión simple: 
`y ~ x` se traduce en `y = a_1 + a_2 * x`. 

`model_matrix()`.

Toma un dataframe y una fórmula y devuelve un tibble 

Para el caso más simple de `y ~ x1`, esto nos muestra algo interesante:
"


df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)

model_matrix(df, y ~ x1)

"
La forma en que R agrega la intersección al modelo es simplemente 
teniendo una columna llena de unos. De forma predeterminada, R siempre
agregará esta columna.

Si no lo desea, debe eliminarlo explícitamente con `-1`:
"

model_matrix(df, y ~ x1 - 1)

"
La matriz del modelo crece de una manera nada sorprendente 
cuando agrega más variables al modelo:
"

model_matrix(df, y ~ x1 + x2)

"
Esta notación de fórmula a veces se denomina 
**notación de Wilkinson-Rogers** 


Las siguientes secciones amplían el funcionamiento
de esta notación de fórmula para variables categóricas, 
interacciones y transformaciones.
"

### Variables categóricas

"
Generar una función a partir de una fórmula es sencillo cuando el
predictor es continuo, pero las cosas se complican un poco cuando
el predictor es categórico. 

Imagina que tienes una fórmula como `y ~ sex`, donde el `sex` puede
ser masculino o femenino. 

No tiene sentido convertir eso a una fórmula como
`y = x_0 + x_1 * sex` porque el `sex` no es un número,
¡no puedes multiplicarlo! 
  
En cambio, lo que hace R es convertirlo en 
`y = x_0 + x_1 * sex_male` donde `sex_male` 
es uno si el sexo es masculino y cero en caso contrario:
"  

df <- tribble(
  ~ sex, ~ response,
  "male", 1,
  "female", 2,
  "male", 1
)



model_matrix(df, response ~ sex)

"
Quizás te preguntes por qué R tampoco crea una columna de sexo femenino.

El problema es que crearía una columna que es perfectamente predecible 
en función de las otras columnas (es decir, `sexfemale = 1 - sexmale`).

Básicamente crea unafamilia de modelos que es demasiado flexible y
tendrá infinitos modelos que están igualmente cerca de los datos.

Si te enfocas en visualizar predicciones, no necesitas preocuparte
por la parametrización exacta. 

Veamos algunos datos y modelos para concretarlo.
" 

ggplot(sim2) + 
  geom_point(aes(x, y))

"
Podemos ajustarle un modelo y generar predicciones:
"

mod2 <- lm(y ~ x, data = sim2)

grid <- sim2 %>% 
  data_grid(x) %>% 
  add_predictions(mod2)

grid


"
Efectivamente, un modelo con una `x` categórica predecirá el valor medio 
para cada categoría.

(¿Por qué? Porque la media minimiza la distancia cuadrática media de la raíz).

Es fácil de ver si superponemos las predicciones sobre los datos originales:
"

ggplot(sim2, aes(x)) + 
  geom_point(aes(y = y)) +
  geom_point(data = grid, aes(y = pred), colour = "red", size = 4)

"
No puedes hacer predicciones sobre niveles que no observó. 

A veces, lo hará por accidente, por lo que es bueno reconocer
este mensaje de error:
"

tibble(x = "e") %>% 
  add_predictions(mod2)

### Interacciones (continuas y categóricas)
"
¿Qué sucede cuando combinas una variable continua y una categórica?
"  

ggplot(sim3, aes(x1, y)) + 
  geom_point(aes(colour = x2))

"
Hay dos modelos posibles que podría ajustar a estos datos:
"

mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)

"
Cuando agregas variables con `+`, el modelo estimará cada efecto 
independientemente de todos los demás. 

Es posible ajustar la llamada interacción usando `*`. 

Por ejemplo, `y ~ x1 * x2` se traduce en 
`y = a_0 + a_1 * x1 + a_2 * x2 + a_12 * x1 * x2`.

Ten en cuenta que siempre que utilices `*`, 
tanto la interacción como los componentes individuales se incluyen en el modelo.

Para visualizar estos modelos necesitamos dos nuevos trucos:
  
* Tenemos dos predictores, por lo que necesitamos dar `data_grid()` 
* Para generar predicciones de ambos modelos simultáneamente, 
  podemos usar `collect_predictions()` 
"

grid <- sim3 %>% 
  data_grid(x1, x2) %>% 
  gather_predictions(mod1, mod2)
grid

"
Podemos visualizar los resultados para ambos modelos en una
gráfica usando facets:
"  

ggplot(sim3, aes(x1, y, colour = x2)) + 
  geom_point() + 
  geom_line(data = grid, aes(y = pred)) + 
  facet_wrap(~ model)

"
Ten en cuenta que el modelo que usa `+` tiene la misma pendiente para
cada línea, pero diferentes intersecciones.

El modelo que usa `*` tiene una pendiente e intersección diferentes 
para cada línea.

¿Qué modelo es mejor para estos datos?
  Podemos echar un vistazo a los residuos. 
"

sim3 <- sim3 %>% 
  gather_residuals(mod1, mod2)

ggplot(sim3, aes(x1, resid, colour = x2)) + 
  geom_point() + 
  facet_grid(model ~ x2)

"
Hay poco patrón obvio en los residuos de ``mod2`. 

Los residuos de `mod1` muestran que el modelo claramente
ha perdido algún patrón en `b`, y menos, pero todavía está
presente el patrón en `c` y `d`.

Quizás se pregunte si existe una forma precisa de saber cuál de
`mod1` o `mod2` es mejor.

Lo hay, pero requiere mucha formación matemática,
y realmente no nos importa. 
"

### Interacciones (Dos continuas)
"
Echemos un vistazo al modelo equivalente para dos variables continuas.
Inicialmente, las cosas proceden de manera casi idéntica al ejemplo anterior:
"

mod1 <- lm(y ~ x1 + x2, data = sim4)
mod2 <- lm(y ~ x1 * x2, data = sim4)

grid <- sim4 %>% 
  data_grid(
    x1 = seq_range(x1, 5), 
    x2 = seq_range(x2, 5) 
  ) %>% 
  gather_predictions(mod1, mod2)

grid

"
Ten en cuenta el uso de `seq_range()` dentro de `data_grid()`.

Probablemente no sea muy importante aquí,
pero es una técnica útil en general. 
Hay otros dos argumentos útiles para `seq_range()`:
  
  * `pretty = TRUE` 
"

seq_range(c(0.0123, 0.923423), n = 5)

seq_range(c(0.0123, 0.923423), n = 5, pretty = TRUE)

"
* `trim = 0.1` recortará el `10%` de los valores finales. 

Esto es útil si las variables tienen una distribución de cola larga
y desea enfocarse en generar valores cerca del centro:
" 

x1 <- rcauchy(100)
seq_range(x1, n = 5)

seq_range(x1, n = 5, trim = 0.10)

seq_range(x1, n = 5, trim = 0.25)

seq_range(x1, n = 5, trim = 0.50)

"
* `expand = 0.1` es en cierto sentido lo opuesto a `trim()` 
"

x2 <- c(0, 1)
seq_range(x2, n = 5)

seq_range(x2, n = 5, expand = 0.10)

seq_range(x2, n = 5, expand = 0.25)

seq_range(x2, n = 5, expand = 0.50)

"
A continuación, intentemos visualizar ese modelo.

Tenemos dos predictores continuos

Podríamos mostrar eso usando `geom_tile()`:
"  

ggplot(grid, aes(x1, x2)) + 
  geom_tile(aes(fill = pred)) + 
  facet_wrap(~ model)

"
¡Eso no sugiere que los modelos sean muy diferentes! 
  Pero eso es en parte una ilusión: 
  nuestros ojos y cerebros no son muy buenos para
  comparar con precisión tonos de color. 
  
  En lugar de mirar la superficie desde la parte superior,
  podríamos mirarla desde cualquier lado, mostrando múltiples cortes:
" 

ggplot(grid, aes(x1, pred, colour = x2, group = x2)) + 
  geom_line() +
  facet_wrap(~ model)

ggplot(grid, aes(x2, pred, colour = x1, group = x1)) + 
  geom_line() +
  facet_wrap(~ model)

"
Esto le muestra que la interacción entre dos variables continuas
funciona básicamente de la misma manera que para una variable 
categórica y continua. 

Una interacción dice que no hay un desplazamiento fijo: 
  debe considerar ambos valores de `x1` y `x2` simultáneamente 
  para predecir `y`.

Pero eso es razonable: 
  ¡no debería esperar que sea fácil entender cómo
  interactúan tres o más variables simultáneamente! 
  
El modelo no tiene que ser perfecto, solo tiene que 
  ayudarlo a revelar un poco más sobre sus datos.

Pasé algún tiempo mirando los residuos 
"

### Transformaciones
"
También puede realizar transformaciones dentro de la fórmula del modelo.

Por ejemplo, `log (y) ~ sqrt (x1) + x2` se transforma en 
    `log (y) = a_1 + a_2 * sqrt (x1) + a_3 * x2`.

Si su transformación incluye `+`, `*`, `^` o `-`, 
    deberá envolverla en `I()` para que R no la trate como parte de
    la especificación del modelo. 

Por ejemplo, `y ~ x + I (x ^ 2)` se traduce en
  `y = a_1 + a_2 * x + a_3 * x ^ 2`. 
  
Si olvida `I()` y especifica `y ~ x ^ 2 + x`, 
  R calculará `y ~ x * x + x`.

`x * x` significa la interacción de `x` consigo mismo, 
  que es lo mismo que `x`.

R descarta automáticamente las variables redundantes para
  que `x + x` se convierta en x, lo que significa que 
  `y ~ x ^ 2 + x` especifica la función `y = a_1 + a_2 * x`.
  
  ¡Probablemente eso no sea lo que pretendías!
  
Nuevamente, si te confunde acerca de lo que está haciendo tu modelo, 
  siempre puedes usar `model_matrix()` para ver exactamente qué ecuación `lm()`
"

df <- tribble(
  ~y, ~x,
  1,  1,
  2,  2, 
  3,  3
)

model_matrix(df, y ~ x^2 + x)

model_matrix(df, y ~ I(x^2) + x)

"
Las transformaciones son útiles porque puede usarlas para aproximar 
funciones no lineales. 

Si has tomado una clase de cálculo, es posible que haya oído hablar del
  teorema de Taylor

Escribir esa secuencia a mano es tedioso, por lo que R proporciona una
  función auxiliar: `poly()`:
"

model_matrix(df, y ~ poly(x, 2))

"
Sin embargo, hay un problema importante con el uso de `poly()`:
  fuera del rango de los datos, los polinomios se disparan rápidamente
  al infinito positivo o negativo. 

Una alternativa más segura es utilizar la spline natural, `splines::ns()`.
"

library(splines)

model_matrix(df, y ~ ns(x, 2))

"
Veamos cómo se ve cuando intentamos aproximar una función no lineal:
"

sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(length(x))
)

ggplot(sim5, aes(x, y)) +
  geom_point()

"
Vamos a ajustar cinco modelos a estos datos.
"

mod1 <- lm(y ~ ns(x, 1), data = sim5)
mod2 <- lm(y ~ ns(x, 2), data = sim5)
mod3 <- lm(y ~ ns(x, 3), data = sim5)
mod4 <- lm(y ~ ns(x, 4), data = sim5)
mod5 <- lm(y ~ ns(x, 5), data = sim5)

grid <- sim5 %>% 
  data_grid(x = seq_range(x, n = 50, expand = 0.1)) %>% 
  gather_predictions(mod1, mod2, mod3, mod4, mod5, .pred = "y")

ggplot(sim5, aes(x, y)) + 
  geom_point() +
  geom_line(data = grid, colour = "red") +
  facet_wrap(~ model)

"
Tenga en cuenta que la extrapolación fuera del rango de los datos es
claramente mala.
"

### Ejercicios
"
  1 - Lo que sucede si repite el análisis de SIM2 usando un modelo sin
      una intersección. ¿Qué pasa con la ecuación modelo? 
      ¿Qué pasa con las predicciones?
  
  2 - Usa `Model_Matrix()` para explorar las ecuaciones generadas para
      los modelos que apto para `SIM3` y `SIM4`. 
      ¿Por qué es `*` una buena taquigrafía para la interacción?
  
  3  - Usando los principios básicos, convertir las fórmulas en los
      siguientes dos modelos en funciones. (Pista: Comience con la
      conversión de la variable categórica en variables 0-1).

mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)


4 - Para `SIM4`, ¿cuál de `mod1` y `mod2` es mejor? Creo que `MOD2` hace
    un trabajo ligeramente mejor para eliminar los patrones, pero es bastante
    sutil. ¿Puedes llegar a una gráfica para apoyar mi reclamo?
"
  
### Valores faltantes
" 
  Los valores faltantes, obviamente, no pueden transmitir
  ninguna información sobre la relación entre las variables, 
"

df <- tribble(
  ~x, ~y,
  1, 2.2,
  2, NA,
  3, 3.5,
  4, 8.3,
  NA, 10
)

mod <- lm(y ~ x, data = df)

"
Para suprimir la advertencia, configure `na.action = na.exclude`:
"

mod <- lm(y ~ x, data = df, na.action = na.exclude)

"
Siempre puedes ver exactamente cuántas observaciones se utilizaron
con `nobs()`:
"

nobs(mod)


### Otras familias modelos
"
Esta sección se ha centrado exclusivamente en la clase de modelos lineales, 
que asume una relación de la forma `y = A_1 * x1 + A_2 * X2 + ... + A_N * XN`. 

Además, los modelos lineales asumen además que los residuos tienen una 
distribución normal, a la que no hemos hablado. 

Hay un gran conjunto de clases modelo que extienden el modelo lineal de varias
maneras interesantes. Algunos de ellos son:
  
* **Modelos lineales generalizados**,
    por ejemplo. `stats::glm()`. 

* **Modelos aditivos generalizados**,
  por ejemplo. `glmnet::glmnet()`

* **Modelos lineales penalizados**,
  por ejemplo. `glmnet::glmnet()`

* **Modelos lineales robustos**,
  por ejemplo. `MASS::rlm()`

* **Árboles**, 
  por ejemplo. `rpart::rpart()`


Todos estos modelos funcionan de manera similar desde una perspectiva
de programación. 

Una vez que haya dominado modelos lineales, debe encontrar fácil dominar
los mecánicos de estas otras clases de modelos.
"

## Construir un modelo

"
Esta sección se enfocará en datos reales y
te mostrará cómo puede construir progresivamente un modelo
para ayudarlo a comprender los datos.

Aprovecharemos el hecho de que puede pensar en un modelo que
particione tus datos en patrones y residuos. 

Encontraremos patrones con visualización,

Luego, repetiremos el proceso

Ciertamente, existen enfoques alternativos: 
  un enfoque más de aprendizaje automático 
  es simplemente centrarse en la capacidad predictiva del modelo. 
  
Estos enfoques tienden a producir cajas negras

Este es un enfoque totalmente razonable, pero dificulta la aplicación 
de tu conocimiento del mundo real al modelo.

Es un desafío saber cuándo detenerse.
  
  “Un artista necesita saber cuándo está terminada una obra. 
    No se puede ajustar algo a la perfección.
    Si no le gusta, hágalo de nuevo. 
    De lo contrario, comience algo nuevo ”.

“Una costurera pobre comete muchos errores. 
  Una buena costurera trabaja duro para corregir esos errores.
  Una gran costurera no tiene miedo de tirar la prenda y empezar de nuevo ".

""

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
Hay menos vuelos en enero (y diciembre) y más en verano (mayo-septiembre). 
No podemos hacer mucho con este patrón cuantitativamente, 
porque solo tenemos un año de datos. 

Lluvia de ideas
"

### Efecto sábado estacional
"
Primero, abordemos nuestro fracaso en predecir con precisión
la cantidad de vuelos el sábado. 

Un buen lugar para comenzar es volver a los números brutos,
centrándose en los sábados:
"

daily %>% 
  filter(wday == "sáb") %>% 
  ggplot(aes(date, n)) + 
    geom_point() + 
    geom_line() +
    scale_x_date(NULL, date_breaks = "1 month", date_labels = "%b")

"
(Hemos utilizado puntos y líneas para aclarar qué son datos y
  qué es interpolación).

Se sospecha que este patrón se debe a las vacaciones de verano:

Eso parece coincidir bastante bien con las escolares del estado
¿Por qué hay más vuelos los sábados en primavera que en otoño? 
Le pregunté a algunos amigos estadounidenses y me sugirieron que
es menos común planificar las vacaciones familiares durante el 
otoño debido a las grandes fiestas de Acción de Gracias y Navidad.

No tenemos los datos para saberlo con certeza,
pero parece una hipótesis de trabajo plausible.

Creemos una variable de 'término' que capture aproximadamente los 
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
  filter(wday == "sáb") %>% 
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
Parece que hay una variación significativa entre los términos, 
por lo que es razonable ajustar un efecto de día de la semana 
por separado para cada término. 

Esto mejora nuestro modelo, pero no tanto como podríamos esperar:
"

mod1 <- lm(n ~ wday, data = daily)
mod2 <- lm(n ~ wday * term, data = daily)

daily %>% 
  gather_residuals(without_term = mod1, with_term = mod2) %>% 
  ggplot(aes(date, resid, colour = model)) +
    geom_line(alpha = 0.75)

"
Nuestro modelo está encontrando el efecto medio,
pero tenemos muchos valores atípicos importantes,
por lo que la media tiende a estar muy lejos del valor típico.

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

### Variables calculadas
"
Si está experimentando con muchos modelos y muchas visualizaciones, 
es una buena idea agrupar la creación de variables en una función

Por ejemplo, podríamos escribir:
"
compute_vars <- function(data) {
  data %>% 
    mutate(
      term = term(date), 
      wday = wday(date, label = TRUE)
    )
}


"
Otra opción es poner las transformaciones directamente en la fórmula del modelo:
"

wday2 <- function(x) wday(x, label = TRUE)
mod3 <- lm(n ~ wday2(date) * term(date), data = daily)

"
Cualquiera de los dos enfoques es razonable. 

Hacer explícita la variable transformada es útil si desea verificar su
trabajo o usarlos en una visualización. 

Incluir las transformaciones en la función del modelo facilita un poco la vida
cuando se trabaja con muchos conjuntos de datos diferentes porque el modelo es
autónomo.
"

### Época del año: un enfoque alternativo
"
Una alternativa a utilizar nuestro conocimiento explícitamente
en el modelo es dar a los datos más espacio para hablar. 

Podríamos usar un modelo más flexible y permitir que capture el
patrón que nos interesa.

Una tendencia lineal simple no es adecuada, 
por lo que podríamos intentar usar una spline natural para ajustar
una curva suave a lo largo del año:
"

library(splines)
mod <- MASS::rlm(n ~ wday * ns(date, 5), data = daily)

daily %>% 
  data_grid(wday, date = seq_range(date, n = 13)) %>% 
  add_predictions(mod) %>% 
  ggplot(aes(date, pred, colour = wday)) + 
    geom_line() +
    geom_point()

"
Vemos un patrón fuerte en el número de vuelos de los sábados.
Esto es tranquilizador, porque también vimos ese patrón en los
datos sin procesar. 

Es una buena señal cuando recibe la misma señal desde diferentes
enfoques.
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

Hagamos un par de ajustes en el conjunto de datos de diamantes
para que sea más fácil trabajar con:
  
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

Primero hacemos explícito el patrón ajustando un modelo:
"

mod_diamond <- lm(lprice ~ lcarat, data = diamonds2)

"
Luego miramos lo que nos dice el modelo sobre los datos. 

Ten en cuenta que vuelvo a transformar las predicciones
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

Ahora podemos mirar los residuos, lo que verifica que 
hemos eliminado con éxito el patrón lineal fuerte:
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

`2^-1` es 1/2, los puntos con un valor de -1 son la mitad 
del precio esperado y los residuos con valor 1 son el doble
del precio pronosticado.
"

### Un modelo más complicado
"
Si quisiéramos, podríamos continuar construyendo nuestro modelo, 
moviendo los efectos que hemos observado en el modelo para hacerlos
explícitos.

Por ejemplo, podríamos incluyendo `color`, `cut` y `clarity` en
el modelo para que también hagamos explícito el efecto de estas
tres variables categóricas:
"

mod_diamond2 <- lm(lprice ~ lcarat + color + cut + clarity,
                   data = diamonds2)

"
Este modelo ahora incluye cuatro predictores

Actualmente todos son independientes, lo que significa
que podemos trazarlos individualmente en cuatro gráficas 

Para facilitar un poco el proceso, usaremos el argumento 
`.model` para `data_grid`:
"

grid <- diamonds2 %>% 
  data_grid(cut, .model = mod_diamond2) %>% 
  add_predictions(mod_diamond2)
grid

ggplot(grid, aes(cut, pred)) + 
  geom_point()

"
Si el modelo necesita variables que no ha proporcionado explícitamente,
`data_grid()` las completará automáticamente con el valor 'típico'. 

Para las variables continuas, usa la mediana y las variables categóricas 
usa el valor más común (o valores, si hay un empate).
"

diamonds2 <- diamonds2 %>% 
  add_residuals(mod_diamond2, "lresid2")

ggplot(diamonds2, aes(lcarat, lresid2)) + 
  geom_hex(bins = 50)

"
Este gráfico indica que hay algunos diamantes con residuos
bastante grandes; recuerde que un residuo de 2 indica que 
el precio del diamante es 4 veces superior al que esperábamos. 

A menudo, es útil observar valores inusuales de forma individual:
"

diamonds2 %>% 
  filter(abs(lresid2) > 1) %>% 
  add_predictions(mod_diamond2) %>% 
  mutate(pred = round(2 ^ pred)) %>% 
  select(price, pred, carat:table, x:z) %>% 
  arrange(price)

"
Nada llama la atención aquí, pero probablemente valga la pena dedicar
tiempo a considerar si esto indica un problema con nuestro modelo o si 
hay errores en los datos. 

Si hay errores en los datos, esta podría ser una oportunidad para
comprar diamantes cuyo precio es bajo de manera incorrecta. 
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
  
  * 4 - ¿El modelo final, `mod_diamond2`, hace un buen trabajo al predecir
        los precios de los diamantes? ¿Confiaría en que le dirá cuánto gastar 
        si está comprando un diamante?
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

  * 5 - ¿Qué sucede si ajusta un efecto de día de la semana que 
        varía según el mes (es decir, ` n ~ wday * month`)? 
        ¿Por qué esto no es muy útil?

  * 6 - ¿Cómo esperaría que se vea el modelo `n ~ wday + ns(date, 5)`?
        Sabiendo lo que sabe sobre los datos, 
        ¿por qué esperaría que no fueran particularmente efectivos?

  * 7 - Presumimos que las personas que se van los domingos tienen
        más probabilidades de ser viajeros de negocios que necesitan
        estar en algún lugar el lunes. Explore esa hipótesis al ver 
        cómo se descompone en función de la distancia y el tiempo: 
        si es cierto, esperaría ver más vuelos los domingos por la 
        noche a lugares que están lejos.

  * 8 - Es un poco frustrante que el domingo y el sábado estén en
        extremos separados de la trama. Escribe una pequeña función
        para establecer los niveles del factor para que la semana
        comience el lunes.
"  