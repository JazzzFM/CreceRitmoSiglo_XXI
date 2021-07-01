# Planteamiento del problema ----------------------------------------------
"
 4 - Toma la siguiente aplicación que agrega algunas funciones adicionales a la última 
aplicación descrita en el último ejercicio. ¿Qué hay de nuevo?
¿Cómo podría reducir la cantidad de código duplicado en la aplicación
mediante el uso de una expresión reactiva?
"
#          Ejecuta este código
# ----------------------------
# library(shiny)
# 
# ui <- fluidPage(
#   sliderInput("x", "Si x es", min = 1, max = 50, value = 30),
#   sliderInput("y", "y además y es", min = 1, max = 50, value = 5),
#   "Entonces, (x * y) es", textOutput("product"),
#   "y (x * y) + 5 es", textOutput("product_plus5"),
#   "y (x * y) + 10 es", textOutput("product_plus10")
# )
# 
# server <- function(input, output, session) {
#   output$product <- renderText({ 
#     product <- input$x * input$y
#     product
#   })
#   output$product_plus5 <- renderText({ 
#     product <- input$x * input$y
#     product + 5
#   })
#   output$product_plus10 <- renderText({ 
#     product <- input$x * input$y
#     product + 10
#   })
# }
# 
# shinyApp(ui, server)

# Resolución del problema ----------------------------------------------
"
La aplicación anterior tiene dos entradas numéricas, input$x e input$y.

Calcula tres valores: x * y, x * y + 5, y x * y + 10. 
Podemos reducir la duplicación haciendo que la variable de producto sea un valor 
reactivo y usándola dentro de las tres salidas.
"

#          Ejecuta este código
# ----------------------------------------------------------------------
# ui <- fluidPage(
#   sliderInput("x", "Si x es", min = 1, max = 50, value = 30),
#   sliderInput("y", "y además y es", min = 1, max = 50, value = 5),
#   "Entonces (x * y) es", textOutput("product"),
#   "y, (x * y) + 5 es", textOutput("product_plus5"),
#   "y (x * y) + 10 es", textOutput("product_plus10")
# )
# 
# server <- function(input, output, session) {
#   output$product <- renderText({ 
#     product <- input$x * input$y
#     product
#   })
#   output$product_plus5 <- renderText({ 
#     product <- input$x * input$y
#     product + 5
#   })
#   output$product_plus10 <- renderText({ 
#     product <- input$x * input$y
#     product + 10
#   })
# }
# -----------------------------------------------------------------------