# Planteamiento del problema ----------------------------------------------
"2 - Supon que tu amigo quiere diseñar una aplicación que le permita al
    usuario establecer un número (x) entre 1 y 50, y muestra el resultado
    de multiplicar este número por 5. Este es su primer intento:
"
#          Ejecuta este código
# ----------------------------
# library(shiny)
# 
# ui <- fluidPage(
#   sliderInput("x", label = "Si x es", min = 1, max = 50, value = 30),
#   "entoces x multiplicado por 5 es",
#   textOutput("product")
# )
# 
# server <- function(input, output, session) {
#   output$product <- renderText({
#     x * 5
#   })
# }
# 
# shinyApp(ui, server)
# ----------------------------
# Pero lamentablemente tiene un error:
# ¿Puedes ayudarlos a encontrar y corregir el error?

# Resolución del problema ----------------------------------------------
"
El error aquí surge porque en el lado del servidor necesitamos escribir
input$x en lugar de x. Al escribir x, buscamos el elemento x que no existe
en el entorno Shiny; x solo existe dentro de la entrada del objeto de solo lectura.
"
#          Ejecuta este código
# ----------------------------------------------------------------------
# library(shiny)
# 
# ui <- fluidPage(
#   sliderInput("x", label = "Si x es", min = 1, max = 50, value = 30),
#   "entoces x multiplicado por 5 es",
#   textOutput("product")
# )
# 
# server <- function(input, output, session) {
#   output$product <- renderText({ 
#     input$x * 5
#   })
# }
# 
# shinyApp(ui, server)
# -----------------------------------------------------------------------