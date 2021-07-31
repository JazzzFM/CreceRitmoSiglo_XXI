# Clase 1 -----------------------------------------------------------------

## Introducción
### ¿Qué es Shiny?
"
Fácilmente aplicaciones web

La creación de aplicaciones web fue difícil:
  * Por HTML, CSS y JavaScript.

Shiny hace más fácil:
  * Funciones de ui
  * programación reactiva 

La gente usa Shiny para:
  * Crear tableros de control 
  * Reemplazar cientos de páginas de PDF 
  * Comunicar modelos complejos 
  * Cargar sus propios datos
"
## Tu primer Shiny App
"
  * La **UI**
  * El **servidor**

programacion reactiva -> cambia salidas automaticamente
"
# install.packages("shiny")
# library(shiny)

### Crear directorio y archivo de la aplicación
"
Hay varias formas de crear una aplicación Shiny.
"

library(shiny)
ui <- fluidPage(
  "Hola mundo!"
)
server <- function(input, output, session) {
  
}
shinyApp(ui, server)

"
Mirando de cerca el código anterior, nuestra `app.R` hace cuatro cosas
"
### Ejecutar y Detener 
"  
Hay varias formas de ejecutar esta aplicación:
  
* Si no está usando RStudio, (`source()`) 

> Listening on http://127.0.0.1:3827

Para detener la app:
"


### Agregar controles de IU
"
paquete datasets 

Reemplaza su `ui` con este código:
"
ui <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)
"
Este ejemplo usa cuatro funciones nuevas:
* `fluidPage()` 
* `selectInput()` 
* `verbatimTextOutput()` y `tableOutput()`

Si llamas a cualquiera de ellos verás HTML impreso en la consola.
"

### Adición de comportamiento
"
Programación reactiva -> aplicaciones sean interactivas, 

Le diremos a Shiny cómo completar el `summary` y 
Los resultados de `table` 
"

server <- function(input, output, session) {
  output$summary <- renderPrint({
    dataset <- get(input$dataset, "package:datasets")
    summary(dataset)
  })
  
  output$table <- renderTable({
    dataset <- get(input$dataset, "package:datasets")
    dataset
  })
}


shinyApp(ui, server)

"
El operador de asignación (`<-`)
El lado derecho, **función de renderización**

`renderPrint()` se empareja con
`verbatimTextOutput()` para mostrar texto

Observa que el `summary` y la `table` se actualizan cada vez que
cambia el conjunto de datos de entrada.

`input$dataset` 
"

### Reducir la duplicación con expresiones reactivas

"
Tenemos un código duplicado: 
"

dataset <- get(input$dataset, "package:datasets")

"
Una mala práctica código duplicado; 
  Un desperdicio computacional, 
  La dificultad de mantener 

 **expresiones reactivas**.

`reactive({...})` 
"

server <- function(input, output, session) {
  # Crear expresiones reactivas
  dataset <- reactive({
    get(input$dataset, "package:datasets")
  })
  
  output$summary <- renderPrint({
    # Usar la expresion reactiva
    summary(dataset())
  })
  
  output$table <- renderTable({
    dataset()
  })
}

### Resumen
"
Haz creado una aplicación sencilla y rápida, etc ...
"

### Ejercicios
"
* 1 - Crea una aplicación que reciba al usuario por su nombre.
Aún no conoces todas las funciones que necesita para hacer esto,
así que incluímos algunas líneas de código a continuación. 
Piensa qué líneas usará y luego cópielas y péguelas en el lugar correcto
en una aplicación Shiny.
------------------------------------------------
tableOutput('mortgage')

output$greeting <- renderText({
  paste0('Hello ', input$name)
})

numericInput('age', 'How old are you?', value = NA)

textInput('name', 'What's your name?')

textOutput('greeting')
--------------------------------------------------
"

output$histogram <- renderPlot({
  hist(rnorm(1000))
}, res = 96)

"
* 2 - Supon que tu amigo quiere diseñar una aplicación que le permita
  al usuario establecer un número (x) entre 1 y 50, y muestra el resultado
  de multiplicar este número por 5. Este es su primer intento:
"  
library(shiny)

ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  "then x times 5 is",
  textOutput("product")
)

server <- function(input, output, session) {
  output$product <- renderText({ 
    x * 5
  })
}

shinyApp(ui, server)
"
* Pero lamentablemente tiene un error:  ¿Puedes ayudarlos a encontrar y corregir el error?
  
  * 3 - Amplía la aplicación del ejercicio anterior para permitir que
    el usuario establezca el valor del multiplicador, y, de modo que l
    a aplicación produzca el valor de `x * y`. 
    El resultado final debería verse así:
    ----------- Ver imagen en el learnr ---------------------

* 4 - Toma la siguiente aplicación que agrega algunas funciones adicionales
  a la última aplicación descrita en el último ejercicio. ¿Qué hay de nuevo?
  ¿Cómo podría reducir la cantidad de código duplicado en la aplicación mediante
  el uso de una expresión reactiva?
"  
library(shiny)

ui <- fluidPage(
  sliderInput("x", "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", "and y is", min = 1, max = 50, value = 5),
  "then, (x * y) is", textOutput("product"),
  "and, (x * y) + 5 is", textOutput("product_plus5"),
  "and (x * y) + 10 is", textOutput("product_plus10")
)

server <- function(input, output, session) {
  output$product <- renderText({ 
    product <- input$x * input$y
    product
  })
  output$product_plus5 <- renderText({ 
    product <- input$x * input$y
    product + 5
  })
  output$product_plus10 <- renderText({ 
    product <- input$x * input$y
    product + 10
  })
}

shinyApp(ui, server)
"

* 5 - La siguiente aplicación es muy similar a una que viste
      anteriormente: seleccionas un conjunto de datos de un paquete 
      (esta vez usamos el paquete ggplot2) y la aplicación imprime un
      `summary` y un gráfico de los datos.
      También sigue las buenas prácticas y hace uso de expresiones 
      reactivas para evitar la redundancia de código. 
      Sin embargo, hay tres errores en el código que se proporciona a 
      continuación. ¿Puedes encontrarlos y arreglarlos?
"  
library(shiny)
library(ggplot2)

datasets <- c("economics", "faithfuld", "seals")
ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  tableOutput("plot")
)

server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })
  output$summmry <- renderPrint({
    summary(dataset())
  })
  output$plot <- renderPlot({
    plot(dataset)
  }, res = 96)
}

shinyApp(ui, server)

# Clase 2 -----------------------------------------------------------------

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

sliderInput("min", "Limit (minimum)", value = 50, min = 0, max = 100)


### Texto libre
"
Texto con `textInput()`, 
Contraseñas con `passwordInput()`, 
Los párrafos del texto con `textAreaInput()`.
"

ui <- fluidPage(
  textInput("name", "What's your name?"),
  passwordInput("password", "What's your password?"),
  textAreaInput("story", "Tell me about yourself", rows = 3)
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
  numericInput("num", "Number one", value = 0, min = 0, max = 100),
  sliderInput("num2", "Number two", value = 50, min = 0, max = 100),
  sliderInput("rng", "Range", value = c(10, 20), min = 0, max = 100)
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
  dateInput("dob", "When were you born?"),
  dateRangeInput("holiday", "When do you want to go on vacation next?")
)

"
Se ajustan de forma predeterminada a los estándares de EE.UU.
"

### Selectores
"
`selectInput()` vs `radioButtons()`.
"

animals <- c("dog", "cat", "mouse", "bird", "other", "I hate animals")

ui <- fluidPage(
  selectInput("state", "What's your favourite state?", state.name),
  radioButtons("animal", "What's your favourite animal?", animals)
)

"
Los `radioButtons()` tienen dos características interesantes:
muestran todas las opciones posibles,
"

ui <- fluidPage(
  radioButtons("rb", "Choose one:",
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
    "state", "What's your favourite state?", state.name,
    multiple = TRUE
  )
)

"
Si tienes un conjunto muy grande de opciones posibles,
es posible que desee utilizar `selectInput()` del 'lado del servidor'

`checkboxGroupInput()`.
"

ui <- fluidPage(
  checkboxGroupInput("animal", "What animals do you like?", animals)
)

"
Si deseas una sola casilla de verificación para una sola pregunta de sí/no, 
usa `checkboxInput()`:
"

ui <- fluidPage(
  checkboxInput("cleanup", "Clean up?", value = TRUE),
  checkboxInput("shutdown", "Shutdown?")
)


### Cargas de archivos
"
También es posible que el usuario cargue un archivo con `fileInput()`:
" 

ui <- fluidPage(
  fileInput("upload", NULL)
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
  actionButton("click", "Click me!"),
  actionButton("drink", "Drink me!", icon = icon("cocktail"))
)

"
Los enlaces y botones de acciones se emparejan de forma más natural 
con `observeEvent()` o `eventReactive()`. 

Cambiar el tamaño con `btn-lg`, `btn-sm`, `btn-xs`.
"

ui <- fluidPage(
  fluidRow(
    actionButton("click", "Click me!", class = "btn-danger"),
    actionButton("drink", "Drink me!", class = "btn-lg btn-success")
  ),
  fluidRow(
    actionButton("eat", "Eat me!", class = "btn-block")
  )
)

"
El argumento `class` funciona estableciendo el atributo de clase del HTML

Puede leer la documentación de Bootstrap 
"

### Ejercicios
"
  * 1 - Cuando el espacio es escaso, es útil etiquetar los cuadros de
    texto con un marcador de posición que aparece dentro del área de 
    entrada de texto. ¿Cómo se llama a `textInput()` para generar la 
    interfaz de usuario a continuación?
"
"
* 2 - Lee atentamente la documentación de `sliderInput()` para descubrir
  cómo crear un control deslizante de fecha, como se muestra a continuación.
  -------------------- Ver imagen en el learnr ---------------------------
"
"
* 3 - Crea una entrada de control deslizante para seleccionar valores entre
  0 y 100 donde el intervalo entre cada valor seleccionable en el control 
  deslizante es 5. Luego, agrega animación al widget de entrada para que
  cuando el usuario presione reproducir, el widget de entrada se desplaza
  por el rango automáticamente.
"
"
* 4 - Si tienes una lista moderadamente larga en un `selectInput()`,
  es útil crear subtítulos que dividan la lista en pedazos. 
  Lee la documentación para descubrir cómo. 
  (Sugerencia: el HTML subyacente se llama <optgroup>). 
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
  textOutput("text"),
  verbatimTextOutput("code")
)

server <- function(input, output, session) {
  output$text <- renderText({ 
    "Hello friend!" 
  })
  output$code <- renderPrint({ 
    # summary(1:10) 
    "hello friend"
    
    
  })
}

"
Los `{ }` solo son necesarios en las funciones
de renderizado 

Como aprenderá en breve, debe realizar el menor cálculo posible 
en sus funciones de renderizado
"  

server <- function(input, output, session) {
  output$text <- renderText("Hello friend!")
  output$code <- renderPrint(summary(1:10))
}

"
* `renderText()`y se empareja con `textOutput()`
  
* `renderPrint()` y se empareja con `verbatimTextOutput()`.

La diferencia entre ellos
"

ui <- fluidPage(
  textOutput("text"),
  verbatimTextOutput("print")
)
server <- function(input, output, session) {
  output$text <- renderText("hello!")
  output$print <- renderPrint("hello!")
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
  tableOutput("static"),
  dataTableOutput("dynamic")
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

### Descargas
"
Puedes hacer que el usuario descargue un archivo con `downloadButton()`
o `downloadLink()`.

Estos requieren nuevas técnicas en la función del servidor las cuales 
veremos más adelante.
"

### Ejercicios
"
* 1 - ¿Con cuál de `textOutput()` y `verbatimTextOutput()` se debe
  emparejar cada una de las siguientes funciones de renderizado?
  
* a) `renderPrint(summary(mtcars))`
* b) `renderText('Good morning!')`
* c) `renderPrint(t.test(1:5, 2:6))`
* d) `renderText(str(lm(mpg ~ wt, data = mtcars)))`

* 2 - Vuelve a crear la aplicación Shiny de la Sección de **Gráficas**, 
  esta vez configurando la altura en `300px` y el ancho en `700px`. 
  Establezca el texto 'alt' de la gráfica para que un usuario con 
  discapacidad visual pueda saber que es una gráfica de dispersión de
  cinco números aleatorios.

* 3 - Actualiza las opciones en la llamada a `renderDataTable()` a
  continuación para que se muestren los datos, pero todos los demás 
  controles estén suprimidos (es decir, elimina los comandos de búsqueda,
  orden y filtrado). Deberás leer `?RenderDataTable` y revisar las opciones 
  en https://datatables.net/reference/option/.
"
ui <- fluidPage(
  dataTableOutput("table")
)
server <- function(input, output, session) {
  output$table <- renderDataTable(mtcars, options = list(pageLength = 5))
}
"
* 4 - Alternativamente, lee sobre reactable y convierte la aplicación 
anterior para usarla en su lugar. 
"
### Resumen
"
En su lugar, vuelve a esta sección cuando estés buscando un componente específico:

En la próxima sección, pasaremos al **back-end** de una aplicación Shiny
"

# Clase 3 -----------------------------------------------------------------


## Reactividad: El servidor

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

Para lograr esta independencia, Shiny invoca su función `server()`
cada vez que se inicia una nueva sesión .... 

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
  numericInput("count", label = "Number of values", value = 100)
)

"
Luego puede acceder al valor de ese `input` con `input$count`. 

Inicialmente contendrá el valor 100 

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
  message("The value of input$count is ", input$count)
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
  textOutput("greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText("Hello human!")
}
"
La función de render hace dos cosas:
  
  * Establece un contexto reactivo 
  * Convierte la salida de su código R en HTML

Obtendrás un error si:
  * Olvidas la función de renderizado.
"

server <- function(input, output, session) {
  output$greeting <- "Hello human"
}
shinyApp(ui, server)
#> Error: Unexpected character object for output$greeting
#> ℹ Did you forget to use a render function?

"
* Intentas leer de una salida.
"

server <- function(input, output, session) {
  message("The greeting is ", output$greeting)
}
shinyApp(ui, server)
#> Error: Reading from shinyoutput object is not allowed


### Programación reactiva

ui <- fluidPage(
  textInput("name", "¿Cuál es tu nombre?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste0("Hello ", input$name, "!")
  })
}


"
Esta es la gran idea en Shiny:
  no necesitas decirle a una salida cuándo actualizar,
  porque Shiny lo averigua automáticamente por ti
"  

output$greeting <- renderText({
  paste0("Hola ", input$name, "!")
})

"
Piénsalo: con este modelo, solo emite la instrucción una vez. 

Pero Shiny realiza la acción cada vez que actualizamos la `input$name`
"

### Programación imperativa vs declarativa
"
Diferencias clave entre dos estilos importantes de programación:

  * En la **programación imperativa** (usual)

  * En la **programación declarativa** (shiny), tu expresas objetivos de
    y confía en alguien más para decidir cómo y/o cuándo traducir eso en acción. 
"

### Laziness
"
Una aplicación Shiny solo hará la cantidad mínima de trabajo necesaria
para actualizar los controles de salida que puede ver actualmente.
"

server <- function(input, output, session) {
  output$greting <- renderText({
    paste0("Hello ", input$name, "!")
  })
}
"
Esto no generará un error en Shiny, pero no hará lo que desea.

"

### El grafo reactivo
"
En la mayoría de los códigos R, puedes comprender 
el orden de ejecución leyendo el código de arriba a abajo.

Eso no funciona en Shiny,  porque el código solo se
ejecuta cuando es necesario.

El grafo reactivo de la aplicación anterior es muy simple 

---------- Ver imagen en la seccion 3 learnr sobre el grafo reactivo ----

El grafo reactivo contiene un símbolo para cada entrada y salida, y conectamos 
una entrada a una salida cada vez que la salida accede a la entrada.

---------- Ver imagen en la seccion 3 learnr sobre el grafo reactivo ----
"

### Expresiones reactivas
"
Por ahora, piensa en ellos como una herramienta que reduce la duplicación
en tu código

No necesitamos una expresión reactiva en nuestra aplicación muy simple,
pero hagamoslo
"

server <- function(input, output, session) {
  string <- reactive(paste0("Hello ", input$name, "!"))
  output$greeting <- renderText(string())
}

"
Con suerte, las formas te ayudarán a recordar cómo encajan los componentes.
"

### Orden de ejecución
"
Es importante comprender que el orden en que se ejecuta el código está
determinado únicamente por el grafo reactivo. 

Esto es diferente de la mayoría de los códigos R 
"

server <- function(input, output, session) {
  output$greeting <- renderText(string())
  string <- reactive(paste0("Hola ", input$name, "!"))
}

"
Podría pensar que esto produciría un error porque `output$greeting`
se refiere a una expresión reactiva, `string`, que aún no se ha creado.

Pero recuerde que Shiny es perezoso 
"

### Ejercicios
"
  * 1 - Dada esta interfaz de usuario:
"
ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)
"
  * 2 - Corrije los errores simples que se encuentran en cada una de  
  las tres funciones del servidor a continuación. Primero intente detectar
  el problema con solo leer el código; luego ejecute el código para asegurarse
  de haberlo solucionado.
"

server1 <- function(input, output, server) {
  input$greeting <- renderText(paste0("Hello ", name))
}

server2 <- function(input, output, server) {
  greeting <- paste0("Hello ", input$name)
  output$greeting <- renderText(greeting)
}

server3 <- function(input, output, server) {
  output$greting <- paste0("Hello", input$name)
}
"
  * 2 - Dibuja el grafo reactivo para las siguientes funciones de servidor:
"

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

"
  * 3 - ¿Por qué fallará este código?
"  

var <- reactive(df[[input$var]])
range <- reactive(range(var(), na.rm = TRUE))

"  
* ¿Por qué los nombres de range() y var() son malos para `reactive`? 
"

# Clase 4 -----------------------------------------------------------------

## Expresiones reactivas
"

Las expresiones reactivas son importantes porque brindan a Shiny
más información para que pueda hacer menos recálculos cuando
cambian las entradas, por eficiencia

Las expresiones reactivas tienen una variedad de entradas y salidas:
  
* Al igual que los `inputs`, pueden utilizar los resultados de una expresión
  reactiva en una salida.

* Al igual que los `output`, las expresiones reactivas dependen de las entradas
  y saben automáticamente cuándo necesitan actualizarse.

Esta dualidad significa que necesitamos un vocabulario nuevo: 
usarémos productores para referirnos a entradas y expresiones reactivas, 
y consumidores para referirnos a expresiones y salidas reactivas.

La figura siguiente muestra esta relación con un diagrama de Venn.

---------------- Ver imagen en el learnr seccion 4 ------------------------
"

### La motivación
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

x1 <- rnorm(10000, mean = 0, sd = 0.5)
x2 <- rnorm(20000, mean = 0, sd = 1.9)

freqpoly(x1, x2)
cat(t_test(x1, x2))



"
Extraer el código imperativo en funciones es una técnica 
importante para todas las aplicaciones Shiny: 
cuanto más código pueda extraer de su aplicación, más fácil será de entender.
"

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
           "Distribution 1",
           numericInput("n1", label = "n", value = 1000, min = 1),
           numericInput("mean1", label = "µ", value = 0, step = 0.1),
           numericInput("sd1", label = "σ", value = 0.5, min = 0.1, step = 0.1)
    ),
    column(4, 
           "Distribution 2",
           numericInput("n2", label = "n", value = 1000, min = 1),
           numericInput("mean2", label = "µ", value = 0, step = 0.1),
           numericInput("sd2", label = "σ", value = 0.5, min = 0.1, step = 0.1)
    ),
    column(4,
           "Frequency polygon",
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



"
------------ Ver imagen en el learnr Seccion 4 ---------------------------------
" 

### El grafo reactivo
"
Shiny es lo suficientemente inteligente como para actualizar 
una salida solo cuando las entradas a las que se refiere cambian;


En otras palabras, las salidas son atómicas: 
se ejecutan o no como un todo.
"  

x1 <- rnorm(input$n1, input$mean1, input$sd1)
x2 <- rnorm(input$n2, input$mean2, input$sd2)
t_test(x1, x2)

"
Shiny, sin embargo, solo mira la salida como un todo

---------------- Ver imagen en el learnr seccion 4 ------------------------

* La aplicación es difícil de entender porque hay muchas conexiones. 

* La aplicación es ineficiente porque hace más trabajo del necesario. 

Hay otra falla importante en la aplicación:
el polígono de frecuencia y la t-test usan sorteos aleatorios separados. 
"

### Simplificar el grafo
"
Refactorizamos el código existente

Para crear una expresión reactiva, llamamos `reactive()` y asignamos los
resultados a una variable.

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
Esta transformación produce el grafo sustancialmente más simple que el anterior.

Esta reescritura también hace que la aplicación sea mucho más eficiente,
ya que realiza muchos menos cálculos.

---------------- Ver imagen en el learnr seccion 4 ------------------------

Para enfatizar esta modularidad

Los módulos le permiten extraer código repetido para su reutilización,

---------------- Ver imagen en el learnr seccion 4 ------------------------

siempre que copie y pegue algo tres veces,
  debes averiguar cómo reducir la duplicación (normalmente escribiendo una función). 

Esto es importante porque reduce la cantidad de duplicados en tu código

"

### ¿Por qué necesitamos expresiones reactivas?
"
¿Por qué no puedes utilizar tus herramientas existentes para reducir la
duplicación de código: crear nuevas variables y escribir funciones? 
  
Desafortunadamente, ninguna de estas técnicas funciona en un entorno reactivo.

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
Si ejecutas este código, obtendrá un error porque está intentando acceder
a los valores de entrada fuera de un contexto reactivo. 

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

Las expresiones reactivas almacenan automáticamente sus resultados en caché 
y solo se actualizan cuando cambian sus entradas.

Mientras que las variables calculan el valor solo una vez y las funciones
calculan el valor cada vez que se llaman

las expresiones reactivas calculan el valor solo cuando podría haber cambiado.
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

"
----------------- Ver imagen del learnr sección 4 -------------------------

Esto genera la aplicación que se muestra arriba y el grafo reactivo que se
muestra en la siguiente.

----------------- Ver imagen del learnr sección 4 -------------------------

"

### Invalidación cronometrada
"
Podemos aumentar la frecuencia de las actualizaciones con una nueva función:
`reactiveTimer()`.

Puede usar un `reactiveTimer()` cuando desee que una expresión reactiva se
invalide a sí misma con más frecuencia de lo que lo haría de otra manera.

----------------- Ver imagen del learnr sección 4 -------------------------

"

server <- function(input, output, session) {
  timer <- reactiveTimer(500)
  
  x1 <- reactive({
    timer()
    rpois(input$n, input$lambda1)
  })
  x2 <- reactive({
    timer()
    rpois(input$n, input$lambda2)
  })
  
  output$hist <- renderPlot({
    freqpoly(x1(), x2(), binwidth = 1, xlim = c(0, 40))
  }, res = 96)
}

"
Esto permite que `x1` y `x2` adopten una dependencia reactiva del temporizador,
sin preocuparse por el valor exacto que devuelve.
"

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
           actionButton("simulate", "Simulate!")
    ),
    column(9, plotOutput("hist"))
  )
)

"
Para usar el botón de acción, necesitamos aprender una nueva herramienta.
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

----------------- Ver imagen del learnr sección 4 -------------------------

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
  textInput("name", "What's your name?"),
  textOutput("greeting")
)

server <- function(input, output, session) {
  string <- reactive(paste0("Hello ", input$name, "!"))
  
  output$greeting <- renderText(string())
  observeEvent(input$name, {
    message("Greeting performed")
  })
}

"
Hay dos diferencias importantes entre `observeEvent()` y `eventReactive()`:
  
* No puedes asignar el resultado de `observeEvent()` a una variable
* No puedes consultarlo desde otros consumidores reactivos.

----------------- Ver imagen del learnr sección 4 -------------------------

"

###  Resumen
"
Este sección deberías haber mejorado tu comprensión del backend de las
aplicaciones Shiny, el código del `server()` que responde a las acciones
del usuario. 

También has dado los primeros pasos para dominar el paradigma de programación
reactiva que sustenta a Shiny. 
"

# Clase 5 -----------------------------------------------------------------


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

selected %>% count(location, wt = weight, sort = TRUE)


selected %>% count(body_part, wt = weight, sort = TRUE)


selected %>% count(diag, wt = weight, sort = TRUE)

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