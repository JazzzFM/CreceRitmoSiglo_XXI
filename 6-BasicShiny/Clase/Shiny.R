# Clase 1
## Introducción
### ¿Qué es Shiny?
"
Shiny te permite crear fácilmente aplicaciones web,
Shiny te permite tomar tu trabajo en R y exponerlo a través de un navegador
web

En el pasado, la creación de aplicaciones web fue difícil:
  
  * Necesita un profundo conocimiento de HTML, CSS y JavaScript.

Shiny hace que sea significativamente más fácil para el programador R crear aplicaciones web por:
  
  * Proporcionar un conjunto cuidadosamente curado de funciones de interfaz de usuari
  * Se presenta un nuevo estilo de programación llamado programación reactiva 

La gente usa Shiny para:
  
  * Crear tableros de control 
  * Reemplazar cientos de páginas de PDF 
  * Comunicar modelos complejos a una audiencia no técnica
  * Proporcionar análisis de datos para flujos de trabajo comunes,
    permite a las personas cargar sus propios datos y realizar análisis estándar.

En resumen, Shiny te brinda la posibilidad de transmitir 
algunas de tus superpoderes de R a cualquier persona que pueda usar la web.
"
## Tu primer Shiny App
"
Los dos componentes clave de cada aplicación Shiny: 
  
  * La **UI** (abreviatura de interfaz de usuario) que define cómo se ve tu aplicación. 
  * La función del **servidor** que define cómo funciona tu aplicación. 

Shiny usa la **programación reactiva** para actualizar automáticamente las salidas 
cuando cambian las entradas
"
# install.packages("shiny")
# library(shiny)

### Crear directorio y archivo de la aplicación
"
Hay varias formas de crear una aplicación Shiny.
La más simple es crear un nuevo directorio para su aplicación y
poner un solo archivo llamado `app.R` en él.

Este archivo `app.R` se usará para decirle a Shiny cómo debe verse su aplicación y cómo debe comportarse.
"

library(shiny)
ui <- fluidPage(
  "Hola mundo!"
)
server <- function(input, output, session) {
  
}
shinyApp(ui, server)

"
Mirando de cerca el código anterior, nuestra `app.R` hace cuatro cosas:
  
* Llama a la biblioteca para cargar el paquete.
* Define la interfaz de usuario, la página web HTML con la que interactúan los humanos. 
* Especifica el comportamiento de nuestra aplicación con el servidor. 
* Ejecuta `shinyApp(ui, server)`
"
### Ejecutar y Detener 
"  
Hay varias formas de ejecutar esta aplicación:
  
* Haga clic en el botón **Run App** en la barra de herramientas del documento.
* Use un atajo de teclado: Cmd/Ctrl + Shift + Enter.
* Si no está usando RStudio, puedes usar (`source()`) a todo el documento

Antes de cerrar la aplicación, y observa la consola R. 
Notarás que dice algo como:
> Listening on http://127.0.0.1:3827

Esto le indica la URL donde se puede encontrar su aplicación
Observe también que R está ocupado

Para detener la app:
* Haz clic en el icono de la señal de **stop** en la barra de
  herramientas de la consola R.
* Haz clic en la consola, luego presione Esc (o presiona Ctrl + C).
"


### Agregar controles de IU
"
Agregaremos algunas entradas y salidas a nuestra interfaz
de usuario para que no sea tan mínima. 

Vamos a crear una aplicación muy simple que le
muestra todos los dataframes integrados incluidos
en el paquete de conjuntos de datos.

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
* `verbatimTextOutput()` y `tableOutput()` son controles de salida 

 Todas son formas elegantes de generar HTML,
 y si llamas a cualquiera de ellos verás HTML impreso en la consola.
"

### Adición de comportamiento
"
Daremos vida a las salidas definiéndolas en la función del servidor.
Shiny usa programación reactiva para hacer que las aplicaciones sean interactivas, por ahora, solo ten en cuenta que esto implica decirle a Shiny cómo realizar un cálculo, no ordenarle a Shiny que realmente lo haga. Es como la diferencia entre darle una receta a alguien y exigirle que te haga un sándwich.

Le diremos a Shiny cómo completar el `summary` y 
los resultados de `table` en la aplicación 
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
El lado izquierdo del operador de asignación (`<-`), salida `output$ID`
El lado derecho de la asignación usa una **función de renderización**

Por ejemplo, en esta aplicación, `renderPrint()` se empareja con
`verbatimTextOutput()` para mostrar un resumen estadístico con texto

Observa que el `summary` y la `table` se actualizan cada vez que
cambia el conjunto de datos de entrada.

Esta dependencia se crea implícitamente porque nos hemos referido a 
`input$dataset` dentro de las funciones de salida.

`input$dataset` se completa con el valor actual del componente UI
con id `dataset`, y hará que las salidas se actualicen automáticamente 
cada vez que ese valor cambie.

Esta es la esencia de la **reactividad**:
las salidas reaccionan automáticamente (recalculan) cuando cambian sus entradas.
"

### Reducir la duplicación con expresiones reactivas

"
Incluso en este ejemplo simple, 
tenemos un código duplicado: la siguiente línea está presente en ambas salidas.
"

dataset <- get(input$dataset, "package:datasets")

"
En todo tipo de programación, es una mala práctica tener código duplicado; 
  puede ser un desperdicio computacional, 
  aumenta la dificultad de mantener o depurar el código.

Capturamos el valor mediante una variable o capturamos el cálculo con una función.
Desafortunadamente, ninguno de estos enfoques funciona aquí, 
y necesitamos un nuevo mecanismo: **expresiones reactivas**.

Creas una expresión reactiva envolviendo un bloque de código en
    `reactive({...})` 
y asignándolo a una variable, y usas una expresión reactiva llamándola como
una función

Podemos actualizar nuestro `server()` para usar expresiones reactivas,
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

"
Volveremos a la programación reactiva varias veces, 
pero incluso con un conocimiento superficial de entradas,
salidas y expresiones reactivas, es
posible crear aplicaciones Shiny bastante útiles.
"

### Resumen
"
Haz creado una aplicación sencilla; no es muy interesante ni útil,
pero ha visto lo fácil que es construir una aplicación web utilizando sus
onocimientos de R existentes. 
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

"
# Clase 2
## Conceptos de UI

Ahora que tienes una aplicación básica en tu haber, 
podemos comenzar a explorar los detalles que hacen que Shiny funcione.

Como viste en la sección anterior, Shiny fomenta la separación del código 
que genera la interfaz de usuario (el **front-end**) del código que impulsa 
el comportamiento de tu aplicación (el **back-end**).

En esta sección, nos centraremos en la interfaz

Aquí nos referiremos principalmente a las entradas y salidas integradas en Shiny.
Sin embargo, existe una comunidad rica y vibrante de paquetes de extensión

Cargamos primero la librería
"

library(shiny)

### Inputs
"
Como vimos en la sección anterior, utiliza funciones como `sliderInput()`,
`selectInput()`, `textInput()` y `numericInput()`

***Estructura común**
  
Todas las funciones de entrada tienen el mismo primer argumento: `inputId`. 

El `inputId` tiene dos restricciones:
  
* Debe ser una cadena simple que contenga solo letras, números y guiones bajos 
* Debe ser único. Si no es único, no tendrá forma de referirse a este

La mayoría de las funciones de entrada tienen un segundo parámetro llamado 
etiqueta

Al crear una entrada, recomiendo proporcionar el `inputId` y los argumentos de etiqueta 
por posición, y todos los demás argumentos por nombre:
"

sliderInput("min", "Limit (minimum)", value = 50, min = 0, max = 100)



### Texto libre
"
Recoge pequeñas cantidades de texto con `textInput()`, 
contraseñas con `passwordInput()`, 
y los párrafos del texto con `textAreaInput()`.
"

ui <- fluidPage(
  textInput("name", "What's your name?"),
  passwordInput("password", "What's your password?"),
  textAreaInput("story", "Tell me about yourself", rows = 3)
)
"
Si desea asegurarse de que el texto tenga ciertas propiedades, 
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
En general, se recomienda usar solo controles deslizantes para rangos
pequeños o casos en los que el valor preciso no sea tan importante. 

¡Intentar seleccionar con precisión un número en un pequeño control 
deslizante es un ejercicio de frustración!
 
Los controles deslizantes son extremadamente personalizables y
hay muchas formas de modificar su apariencia.
"

### Fechas
"
Recopila un solo día con `dateInput()` o un rango de dos días con 
`dateRangeInput()`. 

Estos proporcionan un selector de calendario conveniente y argumentos
adicionales como `datedisabled` y `daysofweekdisabled` le permiten 
restringir el conjunto de entradas válidas.
"

ui <- fluidPage(
  dateInput("dob", "When were you born?"),
  dateRangeInput("holiday", "When do you want to go on vacation next?")
)

"
El formato de fecha, el idioma y el día en que comienza la semana se
ajustan de forma predeterminada a los estándares de EE.UU.

Si estás creando una aplicación con una audiencia internacional,
el idioma y el inicio de la semana para que
las fechas sean naturales para sus usuarios.
"

### Selectores
"
Hay dos enfoques diferentes que permiten al usuario elegir entre 
un conjunto de opciones preespecificado: `selectInput()` y `radioButtons()`.
"

animals <- c("dog", "cat", "mouse", "bird", "other", "I hate animals")

ui <- fluidPage(
  selectInput("state", "What's your favourite state?", state.name),
  radioButtons("animal", "What's your favourite animal?", animals)
)

"
Los `radioButtons()` tienen dos características interesantes:
muestran todas las opciones posibles, 
lo que las hace adecuadas para listas cortas y, 
los argumentos `choiceNames`/`choiceValues`, pueden mostrar opciones distintas al texto sin formato.

`choiceNames` determina lo que se muestra al usuario; `choiceValues` 
determina lo que se devuelve en la función de tu servidor.
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
Los menús desplegables creados con `selectInput()` ocupan la misma 
cantidad de espacio, independientemente del número de opciones,
lo que los hace más adecuados para opciones más largas. 

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
para que el conjunto completo de opciones posibles no esté incrustado 
en la interfaz de usuario


No hay forma de seleccionar varios valores con botones de opción,
pero existe una alternativa que es conceptualmente similar:
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
con `observeEvent()` o `eventReactive()` en la función de su servidor. 


Puedes personalizar la apariencia usando el argumento de clase usando 
uno de `btn-primary`, `btn-success`, `btn-info`, `btn-warning` o `btn-danger`. 

También puedes cambiar el tamaño con `btn-lg`, `btn-sm`, `btn-xs`.

Finalmente, puede hacer que los botones abarquen todo el ancho del
elemento en el que están incrustados usando `btn-block`.
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
subyacente, lo que afecta el estilo del elemento. 

Para ver otras opciones, puede leer la documentación de Bootstrap, 
el sistema de diseño CSS utilizado por Shiny
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
Al igual que las entradas, las salidas toman una ID única como primer argumento:
  si la especificación de la interfaz de usuario crea una salida con la ID `plot`,
  accederás a ella en la función del servidor con la `output$plot`.

Cada función de `output` en el front-end está acoplada con una
función de `render` en el back-end. 

Hay tres tipos principales de resultados, que se corresponden con
las tres cosas que suele incluir en un informe: texto, tablas y gráficos. 

Las siguientes secciones le muestran los conceptos básicos de las
funciones de salida en el front-end, junto con las funciones de `render`
correspondientes en el back-end.
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
    summary(1:10) 
  })
}

"
Ten en cuenta que los `{ }` solo son necesarios en las funciones
de renderizado si es necesario ejecutar varias líneas de código. 

Como aprenderá en breve, debe realizar el menor cálculo posible 
en sus funciones de renderizado

Así es como se vería la función del servidor anterior
si se escribiera de manera más compacta:
"  

server <- function(input, output, session) {
  output$text <- renderText("Hello friend!")
  output$code <- renderPrint(summary(1:10))
}

"
Ten en cuenta que hay dos funciones de renderizado que se 
comportan de forma ligeramente diferente:
  
* `renderText()` combina el resultado en un solo string,
  y generalmente se empareja con `textOutput()`
  
* `renderPrint()` imprime el resultado, como si estuviera en una consola R, 
  y normalmente se empareja con `verbatimTextOutput()`.

Podemos ver la diferencia con una aplicación:
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
Hay dos opciones para mostrar marcos de datos en tablas:
  
* `tableOutput()` y `renderTable()` representan una tabla estática de datos

* `dataTableOutput()` y `renderDataTable()` representan una tabla dinámica, 
  mostrando un número fijo de filas junto con controles para cambiar qué filas
  son visibles.

`tableOutput()` es más útil para resúmenes pequeños y fijos 
(por ejemplo, coeficientes de modelo); `dataTableOutput()` es más apropiado
si desea exponer un dataframe

Si deseas un mayor control sobre la salida de `dataTableOutput()`,
te recomiendo encarecidamente el paquete `reactable`.
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
(más sobre eso en breve) y tendrá 400 píxeles de alto. 

Puedes anular estos valores predeterminados con los argumentos de alto y ancho. 

Los gráficos son especiales porque son salidas que también pueden actuar
como entradas.

`plotOutput()` tiene varios argumentos como `click`, `dblclick` y `hover`.
Si les pasa una cadena, como `click = 'plot_click'`,
crearán una entrada reactiva (`input$lot_click`) que puede usar para
manejar la interacción del usuario en la gráfica, 

p. Ej. haciendo clic en la gráfica.
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
Este sección le ha presentado las principales funciones de entrada y salida
que componen la interfaz de una aplicación Shiny. Este fue un gran volcado de
información, así que no esperes recordar todo después de una sola lectura.

En su lugar, vuelve a esta sección cuando esté buscando un componente específico:
puede escanear rápidamente las figuras y luego encontrar el código que necesita.

En la próxima sección, pasaremos al **back-end** de una aplicación Shiny: 
el código R que hace que su interfaz de usuario cobre vida.
"
