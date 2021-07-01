# Planteamiento del problema ----------------------------------------------
" 3 - Amplía la aplicación del ejercicio anterior para permitir que el usuario 
      establezca el valor del multiplicador, y, de modo que la aplicación produzca 
      el valor de `x * y`. El resultado final debería verse así:
      -------- Revisa la imagen planteada el learnr ---------------
"

# Resolución del problema ----------------------------------------------
"
Agreguemos otro sliderInput con ID y, y usemos la input$x y la input$y para 
calcular la output$product.
"
#          Ejecuta este código
# ----------------------------------------------------------------------
# library(shiny)
# 
# ui <- fluidPage(
#   sliderInput("x", label = "Si x es", min = 1, max = 50, value = 30),
#   sliderInput("y", label = "y además y es", min = 1, max = 50, value = 30),
#   "Entonces x es multiplicado por y es",
#   textOutput("product")
# )
# 
# server <- function(input, output, session) {
#   output$product <- renderText({ 
#     input$x * input$y
#   })
# }
# 
# shinyApp(ui, server)
# -----------------------------------------------------------------------