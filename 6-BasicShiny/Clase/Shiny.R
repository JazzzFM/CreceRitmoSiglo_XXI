# Clase 1: UI -----------------------------------------------------------------

## Conceptos de UI
"
(**front-end**) 
(**back-end**).

Nos centraremos en la interfaz
"

library(shiny)

### Inputs
"
Utiliza funciones como `sliderInput()`,
`selectInput()`, `textInput()` y `numericInput()`

El mismo primer argumento: `inputId`. 

El `inputId` tiene dos restricciones:
* Debe ser una cadena simple 
* Debe ser único
"

sliderInput("min", "Limite (mínimo)", value = 50, min = 0, max = 100)


### Texto libre
"
Texto con `textInput()`, 
Contraseñas con `passwordInput()`, 
Los párrafos del texto con `textAreaInput()`.
"

ui <- fluidPage(
  textInput("nombre", "¿Cuál es tu nombre?"),
  passwordInput("contrasena", "¿Cuál es tu contraseña?"),
  textAreaInput("historia", "Dime sobre ti", rows = 3)
)

"
puede usar `validate()`.
"

### Entradas numéricas
"
Para recolectar valores numéricos, crea un cuadro de texto restringido con
`numericInput()` o un control deslizante con `sliderInput()`. 
"

ui <- fluidPage(
  numericInput("num", "Número uno", value = 0, min = 0, max = 100),
  sliderInput("num2", "Número dos", value = 50, min = 0, max = 100),
  sliderInput("rng", "Rango", value = c(10, 20), min = 0, max = 100)
)

"
Se recomienda usar solo controles deslizantes para rangos pequeños 
"

### Fechas
"
Recopila un solo día con `dateInput()` o un rango de dos días con 
`dateRangeInput()`. 
"

ui <- fluidPage(
  dateInput("dob", "¿Cúal es tu fecha de nacimiento?"),
  dateRangeInput("vacacio", "¿Cuándo te vas de vacaciones?")
)

"
Se ajustan de forma predeterminada a los estándares de EE.UU.
"

### Selectores
"
`selectInput()` vs `radioButtons()`.
"

animals <- c("perro", "gato", "ratón", "pájaro", 
             "otro", "Odio a los animales")

ui <- fluidPage(
  selectInput("estado", "¿Cuál es tu estado favorito?", state.name),
  radioButtons("animal", "¿Cuál es tu animal favorito?", animals)
)

"
Los `radioButtons()` tienen dos características interesantes:
muestran todas las opciones posibles,
"

ui <- fluidPage(
  radioButtons("rb", "Escoge uno:",
               choiceNames = list(
                 icon("angry"),
                 icon("smile"),
                 icon("sad-tear")
               ),
               choiceValues = list("angry", "happy", "sad")
  )
)

"
También puede establecer `multiple = TRUE` 
"

ui <- fluidPage(
  selectInput(
    "state", "¿Cuál es tu estado favorito?", state.name,
    multiple = TRUE
  )
)

"
Si tienes un conjunto muy grande de opciones posibles,
es posible que desee utilizar `selectInput()` del 'lado del servidor'

`checkboxGroupInput()`.
"

ui <- fluidPage(
  checkboxGroupInput("animal", "¿Cuáles animales te gustan?", animals)
)

"
Si deseas una sola casilla de verificación para una sola pregunta de sí/no, 
usa `checkboxInput()`:
"

ui <- fluidPage(
  checkboxInput("cleanup", "¿Está limpio?", value = TRUE),
  checkboxInput("shutdown", "Apagar")
)


### Cargas de archivos
"
También es posible que el usuario cargue un archivo con `fileInput()`:
" 

ui <- fluidPage(
  fileInput("subir", NULL)
)


"
`fileInput()` requiere un manejo especial en el lado del servidor y
se analizará con detalle posteriormente. 
"

### Botones de acción
"
Deja que el usuario realice una acción con `actionButton()` o `actionLink()`:
"  

ui <- fluidPage(
  actionButton("click", "Haz click en mi!"),
  actionButton("bebe", "Bebeme!", icon = icon("cocktail"))
)

"
Los enlaces y botones de acciones se emparejan de forma más natural 
con `observeEvent()` o `eventReactive()`. 

Cambiar el tamaño con `btn-lg`, `btn-sm`, `btn-xs`.
"

ui <- fluidPage(
  fluidRow(
    actionButton("click", "Haz click en mi!", class = "btn-danger"),
    actionButton("drink", "Bebéme", class = "btn-lg btn-success")
  ),
  fluidRow(
    actionButton("eat", "Cómeme!", class = "btn-block")
  )
)

"
El argumento `class` funciona estableciendo el atributo de clase del HTML

Puede leer la documentación de Bootstrap 
"


###  Salidas

"
Si la especificación una salida con la ID `plot`,
  accederás a ella con `output$plot`.

Cada función de `output` en el front-end está acoplada con una
función de `render` en el back-end. 
"

### Texto
"
Salida de texto regular con `textOutput()` y código fijo y salida de
consola con `verbatimTextOutput()`.
"

ui <- fluidPage(
  textOutput("texto"),
  verbatimTextOutput("code")
)

server <- function(input, output, session) {
  output$texto <- renderText({ 
    "Hola amigo" 
  })
  output$code <- renderPrint({ 
    summary(1:10) 
  })
}

"
Los `{ }` solo son necesarios en las funciones
de renderizado 

Como aprenderá en breve, debe realizar el menor cálculo posible 
en sus funciones de renderizado
"  

server <- function(input, output, session) {
  output$text <- renderText("Hola amigo!")
  output$code <- renderPrint(summary(1:10))
}

"
* `renderText()`y se empareja con `textOutput()`
  
* `renderPrint()` y se empareja con `verbatimTextOutput()`.

La diferencia entre ellos
"

ui <- fluidPage(
  textOutput("texto"),
  verbatimTextOutput("imprime")
)
server <- function(input, output, session) {
  output$texto <- renderText("hello!")
  output$imprime <- renderPrint("hello!")
}

"
Esto es equivalente a la diferencia entre `cat()` e `print()` en la base R.
"

### Tablas
"
* `tableOutput()` y `renderTable()` 

* `dataTableOutput()` y `renderDataTable()` 
"

ui <- fluidPage(
  tableOutput("estatico"),
  dataTableOutput("dinamico")
)

server <- function(input, output, session) {
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDataTable(mtcars, options = list(pageLength = 5))
}


### Gráficas
"
Puede mostrar cualquier tipo de gráfico R (base, ggplot2 u otro) con
`plotOutput()` y `renderPlot()`:
"  

ui <- fluidPage(
  plotOutput("plot", width = "400px")
)
server <- function(input, output, session) {
  output$plot <- renderPlot(plot(1:5), res = 96)
}

"
Por defecto, `plotOutput()` ocupará todo el ancho de su contenedor

Puedes anular estos valores predeterminados
"

### Ejercicios: UI
"
  * 1 - Cuando el espacio es escaso, es útil etiquetar los cuadros de
    texto con un marcador de posición que aparece dentro del área de 
    entrada de texto. ¿Cómo se llama a `textInput()` para generar la 
    interfaz de usuario a continuación?


* 2 - Lee atentamente la documentación de `sliderInput()` para descubrir
  cómo crear un control deslizante de fecha, como se muestra a continuación.
  -------------------- Ver imagen en el learnr ---------------------------

* 3 - ¿Con cuál de `textOutput()` y `verbatimTextOutput()` se debe
  emparejar cada una de las siguientes funciones de renderizado?
  
* a) `renderPrint(summary(mtcars))`
* b) `renderText('Good morning!')`
* c) `renderPrint(t.test(1:5, 2:6))`
* d) `renderText(str(lm(mpg ~ wt, data = mtcars)))`

* 4 - Vuelve a crear la aplicación Shiny de la Sección de **Gráficas**, 
  esta vez configurando la altura en `300px` y el ancho en `700px`. 
  Establezca el texto 'alt' de la gráfica para que un usuario con 
  discapacidad visual pueda saber que es una gráfica de dispersión de
  cinco números aleatorios.

"

# Clase 2: El servidor -----------------------------------------------------------------
"
En Shiny, expresas la **lógica de tu servidor** mediante
**programación reactiva**. 
"
### La función de servidor

"
Como has visto, las entrañas de cada aplicación Shiny se ven así:
"

library(shiny)

ui <- fluidPage(
  # interfaz front-end
)

server <- function(input, output, session) {
  # lógica back-end 
}

shinyApp(ui, server)

"
El `server` es más complicado porque ...

Aislar las variables creadas dentro de la función. 

Las funciones del servidor toman tres parámetros: `
input`, `output`, y `session`. 

Por el momento, nos centraremos en los argumentos de `input`
y `output`
"

### Input

"
El argumento de `input` es un objeto ...

Por ejemplo,  un control con un ID de entrada de `count`, así:
" 

ui <- fluidPage(
  numericInput("conteo", label = "Número de valores", value = 100)
)

"
Luego puede acceder al valor de ese `input` con `input$count`. 

Los objetos de `input` son de solo lectura.

Si intenta modificar una `input` dentro de la función del servidor,
obtendrá un error:
"  

server <- function(input, output, session) {
  input$count <- 10  
}

shinyApp(ui, server)
#> Error: Can't modify read-only reactive value 'count'

"
el navegador es la 'única fuente de verdad' de Shiny.

Si pudieras modificar el valor en R, podría introducir inconsistencias,

Una cosa más importante sobre el `input`: 
es selectiva sobre quién puede leerla. 

Para leer desde una entrada, debe estar en un **contexto reactivo** 
"  

server <- function(input, output, session) {
  message("El valor de input$conteo es", input$conteo)
}

shinyApp(ui, server)
#> Error: Can't access reactive value 'count' outside of reactive consumer.
#> ℹ Do you need to wrap inside reactive() or observer()?


###  Output
"
El `output` es muy similar al `input`: 
también es un objeto similar a una lista nombrada de acuerdo con el ID de salida.

La principal diferencia es que ...

Siempre usa el objeto de salida junto con una función de renderizado:
"
  
ui <- fluidPage(
  textOutput("saludo")
)

server <- function(input, output, session) {
  output$saludo <- renderText("Hola gumano!")
}
"
La función de render hace dos cosas:
  
  * Establece un contexto reactivo 
  * Convierte la salida de su código R en HTML

Obtendrás un error si:
  * Olvidas la función de renderizado.
"

server <- function(input, output, session) {
  output$saludo <- "Hola Humano"
}
shinyApp(ui, server)
#> Error: Unexpected character object for output$greeting
#> ℹ Did you forget to use a render function?

"
* Intentas leer de una salida.
"

server <- function(input, output, session) {
  message("El saludo es ", output$saludo)
}
shinyApp(ui, server)
#> Error: Reading from shinyoutput object is not allowed


### Programación reactiva

ui <- fluidPage(
  textInput("nombre", "¿Cuál es tu nombre?"),
  textOutput("saludo")
)

server <- function(input, output, session) {
  output$saludo <- renderText({
    paste0("Hola ", input$nombre, "!")
  })
}


"
Esta es la gran idea en Shiny:
  no necesitas decirle a una salida cuándo actualizar,
  porque Shiny lo averigua automáticamente por ti
"  

output$greeting <- renderText({
  paste0("Hola ", input$nombre, "!")
})

"
Piénsalo: con este modelo, solo emite la instrucción una vez. 

Pero Shiny realiza la acción cada vez que actualizamos la `input$name`
"

### La Pereza
"
Una aplicación Shiny solo hará la cantidad mínima de trabajo necesaria
para actualizar los controles de salida que puede ver actualmente.
"

server <- function(input, output, session) {
  output$greting <- renderText({
    paste0("Hola ", input$nombre, "!")
  })
}
"
Esto no generará un error en Shiny, pero no hará lo que desea.

"

### Expresiones reactivas
"
Por ahora, piensa en ellos como una herramienta que reduce la duplicación
en tu código

No necesitamos una expresión reactiva en nuestra aplicación muy simple,
pero hagamoslo
"

server <- function(input, output, session) {
  string <- reactive(paste0("Hola ", input$nombre, "!"))
  output$saludo <- renderText(string())
}

"
Con suerte, las formas te ayudarán a recordar cómo encajan los componentes.
"


### La motivación de expresiones reactivas
"
Imagina que quieres comparar dos conjuntos de datos simulados con un gráfico 
y una prueba de hipótesis. 
"
library(ggplot2)

freqpoly <- function(x1, x2, binwidth = 0.1, xlim = c(-3, 3)) {
  df <- tibble::tibble(
    x = c(x1, x2),
    g = c(rep("x1", length(x1)), rep("x2", length(x2)))
  )
  
  ggplot(df, aes(x, colour = g)) +
    geom_freqpoly(binwidth = binwidth, size = 1) +
    coord_cartesian(xlim = xlim)
}

t_test <- function(x1, x2) {
  test <- t.test(x1, x2)
  
  # usa sprintf() para formatear los resultados de t.test() de manera compacta
  sprintf(
    "p value: %0.3f\n[%0.2f, %0.2f]",
    test$p.value, test$conf.int[1], test$conf.int[2]
  )
}

"
Si tienes algunos datos simulados, puedo usar estas funciones para comparar
dos variables:
"  

x1 <- rnorm(100, mean = 0, sd = 0.5)
x2 <- rnorm(200, mean = 0.15, sd = 0.9)

freqpoly(x1, x2)
cat(t_test(x1, x2))


### La aplicación

"
Poedemos modificar interactivamente las entradas a continuación

Comencemos con la interfaz de usuario. 

No profundizaremos a lo que hacen exactamente `fluidRow()` y `column()`; 
pero puedes adivinar su propósito por sus nombres.
"

ui <- fluidPage(
  fluidRow(
    column(4, 
           "Distribución 1",
           numericInput("n1", label = "n", value = 1000, min = 1),
           numericInput("mean1", label = "µ", value = 0, step = 0.1),
           numericInput("sd1", label = "σ", value = 0.5, min = 0.1, step = 0.1)
    ),
    column(4, 
           "Distribución 2",
           numericInput("n2", label = "n", value = 1000, min = 1),
           numericInput("mean2", label = "µ", value = 0, step = 0.1),
           numericInput("sd2", label = "σ", value = 0.5, min = 0.1, step = 0.1)
    ),
    column(4,
           "Polígono de frecuencia",
           numericInput("binwidth", label = "Bin width", value = 0.1, step = 0.1),
           sliderInput("range", label = "range", value = c(-3, 3), min = -5, max = 5)
    )
  ),
  fluidRow(
    column(9, plotOutput("hist")),
    column(3, verbatimTextOutput("ttest"))
  )
)

"
La función del servidor combina llamadas a las funciones `freqpoly()` y
`t_test()` después de extraer de las distribuciones especificadas:
"  

server <- function(input, output, session) {
  output$hist <- renderPlot({
    x1 <- rnorm(input$n1, input$mean1, input$sd1)
    x2 <- rnorm(input$n2, input$mean2, input$sd2)
    
    freqpoly(x1, x2, binwidth = input$binwidth, xlim = input$range)
  }, res = 96)
  
  output$ttest <- renderText({
    x1 <- rnorm(input$n1, input$mean1, input$sd1)
    x2 <- rnorm(input$n2, input$mean2, input$sd2)
    
    t_test(x1, x2)
  })    
}

### Refactorizamos el código existente
"
Para crear una expresión reactiva, llamamos `reactive()` y
asignamos los resultados a una variable.

Usarla posteriormente
"

server <- function(input, output, session) {
  x1 <- reactive(rnorm(input$n1, input$mean1, input$sd1))
  x2 <- reactive(rnorm(input$n2, input$mean2, input$sd2))
  
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = input$binwidth, xlim = input$range)
  }, res = 96)
  
  output$ttest <- renderText({
    t_test(x1(), x2())
  })
}

"
Esta reescritura también hace que la aplicación sea mucho más
eficiente, ya que realiza muchos menos cálculos.
"

### ¿Por qué necesitamos expresiones reactivas?
"
¿Por qué no puedes utilizar tus herramientas existentes para
reducir la duplicación de código?
  ¿Crear nuevas variables y escribir funciones? 
  
Desafortunadamente, ninguna de estas técnicas funciona 
  en un entorno reactivo.

Si intentas utilizar una variable para reducir la duplicación, 
puede escribir algo como esto:
"

server <- function(input, output, session) {
  x1 <- rnorm(input$n1, input$mean1, input$sd1)
  x2 <- rnorm(input$n2, input$mean2, input$sd2)
  
  output$hist <- renderPlot({
    freqpoly(x1, x2, binwidth = input$binwidth, xlim = input$range)
  }, res = 96)
  
  output$ttest <- renderText({
    t_test(x1, x2)
  })
}

"
Si ejecutas este código, obtendrá un error porque está 
intentando acceder a los valores de entrada fuera de un 
contexto reactivo. 

Incluso si no recibieras ese error, aún tendrías un problema: 
"

server <- function(input, output, session) { 
  x1 <- function() rnorm(input$n1, input$mean1, input$sd1)
  x2 <- function() rnorm(input$n2, input$mean2, input$sd2)
  
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = input$binwidth, xlim = input$range)
  }, res = 96)
  
  output$ttest <- renderText({
    t_test(x1(), x2())
  })
}

"
Pero tiene el mismo problema que el código original:

Las expresiones reactivas almacenan automáticamente sus resultados
en caché y solo se actualizan cuando cambian sus entradas.

las expresiones reactivas calculan el valor solo cuando podría
haber cambiado.
"

### Controlar el momento de la evaluación

"
Usaremos una distribución con un solo parámetro y forzaremos a ambas muestras a
compartir la misma `n`. 

También eliminaremos los controles de la gráfica. 
"

ui <- fluidPage(
  fluidRow(
    column(3, 
           numericInput("lambda1", label = "lambda1", value = 3),
           numericInput("lambda2", label = "lambda2", value = 5),
           numericInput("n", label = "n", value = 1e4, min = 0)
    ),
    column(9, plotOutput("hist"))
  )
)
server <- function(input, output, session) {
  x1 <- reactive(rpois(input$n, input$lambda1))
  x2 <- reactive(rpois(input$n, input$lambda2))
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
  }, res = 96)
}


### Al hacer clic
"
Es posible que desees solicitar el usuario que opte por realizar el costoso cálculo solicitándole que haga
clic en un botón. 

Este es un gran caso de uso para un `actionButton()`: 
"  

ui <- fluidPage(
  fluidRow(
    column(3, 
           numericInput("lambda1", label = "lambda1", value = 3),
           numericInput("lambda2", label = "lambda2", value = 5),
           numericInput("n", label = "n", value = 1e4, min = 0),
           actionButton("simulate", "Simula!")
    ),
    column(9, plotOutput("hist"))
  )
)

"
Para usar el botón de acción, necesitamos aprender una nueva
herramienta.
"

server <- function(input, output, session) {
  x1 <- reactive({
    input$simulate
    rpois(input$n, input$lambda1)
  })
  x2 <- reactive({
    input$simulate
    rpois(input$n, input$lambda2)
  })
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
  }, res = 96)
}

"
Queremos reemplazar las dependencias existentes, no agregarlas.

Para resolver este problema, necesitamos una nueva herramienta: 
Necesitamos `eventReactive()`, que tiene dos argumentos:
 
Eso permite que esta aplicación solo calcule `x1()`  y `x2()` 
cuando se hace clic en `simulate`:
"
 
server <- function(input, output, session) {
  x1 <- eventReactive(input$simulate, {
    rpois(input$n, input$lambda1)
  })
  x2 <- eventReactive(input$simulate, {
    rpois(input$n, input$lambda2)
  })
  
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
  }, res = 96)
}

"
Ten en cuenta que, como se desee, `x1` y `x2` ya no tienen una dependencia
reactiva de `lambda1`, `lambda2` y `n`: 
cambiar sus valores no activará el cálculo. 
"

### Observers
"
Hay varias formas de crear un observador. 

Por ahora, vamos a mostrarte cómo usar `observeEvent()`

`observeEvent()` es muy similar a `eventReactive()`. 

Tiene dos argumentos importantes: `eventExpr` y `handlerExpr`. 
p.ej.
"  

ui <- fluidPage(
  textInput("nombre", "¿Cuál es tu nombre?"),
  textOutput("saludo")
)

server <- function(input, output, session) {
  string <- reactive(paste0("Hola ", input$name, "!"))
  
  output$greeting <- renderText(string())
  observeEvent(input$nombre, {
    message("Saludo realizado")
  })
}

"
Hay dos diferencias importantes entre `observeEvent()` y `eventReactive()`:
  
* No puedes asignar el resultado de `observeEvent()` a una variable
* No puedes consultarlo desde otros consumidores reactivos.

"

### Ejercicios
"
  * 1 - Dada esta interfaz de usuario:

ui <- fluidPage(
  textInput('nombre', 'What's your name?'),
  textOutput('saludo')
)

  * 2 - Corrije los errores simples que se encuentran en cada una de  
  las tres funciones del servidor a continuación. Primero intente detectar
  el problema con solo leer el código; luego ejecute el código para asegurarse
  de haberlo solucionado.


server1 <- function(input, output, server) {
  input$greeting <- renderText(paste0('Hola ', nombre))
}

server2 <- function(input, output, server) {
  greeting <- paste0('Hola ', input$nombre)
  output$greeting <- renderText(saludo)
}

server3 <- function(input, output, server) {
  output$greting <- paste0('Hola ', input$nombre)
}

  * 2 - Dibuja el grafo reactivo para las siguientes funciones de servidor:


server1 <- function(input, output, session) {
  c <- reactive(input$a + input$b)
  e <- reactive(c() + input$d)
  output$f <- renderText(e())
}

server2 <- function(input, output, session) {
  x <- reactive(input$x1 + input$x2 + input$x3)
  y <- reactive(input$y1 + input$y2)
  output$z <- renderText(x() / y())
}

server3 <- function(input, output, session) {
  d <- reactive(c() ^ input$d)
  a <- reactive(input$a * 10)
  c <- reactive(b() / input$c) 
  b <- reactive(a() + input$b)
}


  * 3 - ¿Por qué fallará este código?
  
var <- reactive(df[[input$var]])
range <- reactive(range(var(), na.rm = TRUE))

  
* ¿Por qué los nombres de range() y var() son malos para `reactive`? 
"


# Clase 3: Un caso de estudio 1 -----------------------------------------------------------------


## Caso de estudio: lesiones en urgencias
"
En esta sección, complementaremos Shiny con `vroom` 
"

library(shiny)
library(vroom)
library(tidyverse)


### Los datos
"
Vamos a explorar los datos del Sistema Nacional de Vigilancia 
Electrónica de Lesiones (NEISS),
"

dir.create("neiss")

download <- function(name) {
  url <- "https://github.com/hadley/mastering-shiny/raw/master/neiss/"
  download.file(paste0(url, name), paste0("neiss/", name), quiet = TRUE)
}

download("injuries.tsv.gz")
download("population.tsv")
download("products.tsv")

"
El principal conjunto de datos que usaremos son las lesiones `injuries`, 
"
injuries <- vroom::vroom("neiss/injuries.tsv.gz")
injuries

"
Cada fila representa un solo accidente con 10 variables:
* `trmt_date` es la fecha en que se vio a la persona en el hospital
* ``age`, `sex`, y `race` 
* `body_part` es la ubicación de la lesión en el cuerpo 
* `diag` da el diagnóstico básico 
* `prod_code` asociado con la lesión.
* La variable `weight` es el peso estadístico
* La variable `narrative` es una breve historia 
"

products <- vroom::vroom("neiss/products.tsv")
products

population <- vroom::vroom("neiss/population.tsv")
population


### Exploración
"
Comenzaremos mirando un producto con una historia interesante: 649, "toilets". 
" 
selected <- injuries %>% filter(prod_code == 649)
nrow(selected)

"
algunos resúmenes básicos 
"

selected %>%
  count(location, wt = weight, sort = TRUE)


selected %>%
  count(body_part, wt = weight, sort = TRUE)


selected %>% 
  count(diag, wt = weight, sort = TRUE)

"
las lesiones relacionadas con los inodoros mayor frecuencia en el hogar. 

También podemos explorar el patrón según la edad y el sexo. 
"

summary <- selected %>% 
  count(age, sex, wt = weight)
summary

summary %>% 
  ggplot(aes(age, n, colour = sex)) + 
  geom_line() + 
  labs(y = "Número estimado de lesiones")

"
un punto máximo a los 3 años, 
y luego un aumento (particularmente para las mujeres) a partir de la mediana edad, 
"

summary <- selected %>% 
  count(age, sex, wt = weight) %>% 
  left_join(population, by = c("age", "sex")) %>% 
  mutate(rate = n / population * 1e4)

summary

"
Al trazar la tasa,
una tendencia sorprendentemente diferente después de los 50 años: 
Esto se debe a que las mujeres tienden a vivir más que los hombres, 
"

summary %>% 
  ggplot(aes(age, rate, colour = sex)) + 
  geom_line(na.rm = TRUE) + 
  labs(y = "Lesiones por cada 10.000 personas")

"
Finalmente, podemos mirar algunas de las narrativas. 
"

selected %>% 
  sample_n(10) %>% 
  pull(narrative)

"
Habiendo hecho esta exploración para un producto, 
sería muy bueno si pudiéramos hacerlo fácilmente para otros productos,
"

### Prototipo
" 
comenzar de la manera más simple posible, 

Al diseñar un primer prototipo  hacerlo “lo más simple posible”.
"

prod_codes <- setNames(products$prod_code, products$title)

ui <- fluidPage(
  fluidRow(
    column(6,
           selectInput("code", "Product", choices = prod_codes)
    )
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  )
)

"
Todavía no hemos hablado de `fluidRoW()` y `column()`,
La función del servidor es relativamente sencilla. 
A menudo, es una buena idea dedicar un poco de tiempo a limpiar
tu código de análisis
"

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  
  output$diag <- renderTable(
    selected() %>% count(diag, wt = weight, sort = TRUE)
  )
  output$body_part <- renderTable(
    selected() %>% count(body_part, wt = weight, sort = TRUE)
  )
  output$location <- renderTable(
    selected() %>% count(location, wt = weight, sort = TRUE)
  )
  
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 1e4)
  })
  
  output$age_sex <- renderPlot({
    summary() %>%
      ggplot(aes(age, n, colour = sex)) +
      geom_line() +
      labs(y = "Numero estimado de lesiones")
  }, res = 96)
}

"
Crear el reactivo de resumen no es estrictamente necesario  
"

### Resumir las tablas

"
Elegimos hacer eso con una combinación de funciones `forcats`:
"  

injuries %>%
  mutate(diag = fct_lump(fct_infreq(diag), n = 5)) %>%
  group_by(diag) %>%
  summarise(n = as.integer(sum(weight)))

"
Escribimos una pequeña función para automatizar esto para cualquier variable.
Podemo resolver el problema con copiar y pegar
"

count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

"
Luego usamos esto en la función del servidor:
"  

output$diag <- renderTable(count_top(selected(), diag), width = "100%")
output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
output$location <- renderTable(count_top(selected(), location), width = "100%")

"
Hice otro cambio para mejorar la estética de la aplicación
En la a continuación se muestra una captura de pantalla de
la aplicación resultante.
"

### Rate vs Count
"
Nos gustaría darle al usuario la opción de visualizar
el número de lesiones o la tasa estandarizada por población. 

Primero agregamos un control a la interfaz de usuario. 

Aquí elegímos usar un `selectInput()` 
"

fluidRow(
  column(8,
         selectInput("code", "Product",
                     choices = setNames(products$prod_code, products$title),
                     width = "100%"
         )
  ),
  column(2, selectInput("y", "Y axis", c("rate", "count")))
)

"
 `rate` de forma predeterminada 
"

output$age_sex <- renderPlot({
  if (input$y == "count") {
    summary() %>%
      ggplot(aes(age, n, colour = sex)) +
      geom_line() +
      labs(y = "Estimated number of injuries")
  } else {
    summary() %>%
      ggplot(aes(age, rate, colour = sex)) +
      geom_line(na.rm = TRUE) +
      labs(y = "Injuries per 10,000 people")
  }
}, res = 96)


### Narrativa
"
Queremos proporcionar alguna forma de acceder a las
narrativas porque son muy interesantes 

Utilizamos un botón de acción para activar una nueva historia y
pongo la narrativa en un `textOutput()`:
"

fluidRow(
  column(2, actionButton("story", "Tell me a story")),
  column(10, textOutput("narrative"))
)


"
Luego usamos `eventReactive()` para 
"

narrative_sample <- eventReactive(
  list(input$story, selected()),
  selected() %>% pull(narrative) %>% sample(1)
)
output$narrative <- renderText(narrative_sample())


### Ejercicios
"
* 1 - ¿Qué sucede si inviertes `fct_infreq()` y `fct_lump()` en el código
      que reduce las tablas de resumen?
  
* 2 - Agrega un control de entrada que le permita al usuario decidir
      cuántas filas mostrar en las tablas de resumen.

* 3 - Proporciona una forma de recorrer cada narrativa de forma sistemática
      con botones de avance y retroceso.

* 4 - **Avanzado**: Haz que la lista de narrativas sea 'circular' para que
      avanzar desde la última narración lo lleve a la primera.
"



# Clase 3: Una app para diamonds ------------------------------------------
# install.packages("datos")
library(datos)

"
¿Por qué los diamantes de baja calidad son más caros?
  En el capítulo anterior vimos una sorprendente relación 
  entre la calidad de los diamantes y su precio: 
  diamantes de baja calidad (cortes pobres, colores malos, y claridad inferior)
  tienen más altos precios.
"

ggplot(diamantes, aes(corte, precio)) + geom_boxplot()
ggplot(diamantes, aes(color, precio)) + geom_boxplot()
ggplot(diamantes, aes(claridad, precio)) + geom_boxplot()
