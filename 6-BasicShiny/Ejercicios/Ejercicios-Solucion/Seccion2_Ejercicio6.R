# Planteamiento del problema ----------------------------------------------
"
 2 - Vuelve a crear la aplicación Shiny de la Sección de **Gráficas**,
     esta vez configurando la altura en `300px` y el ancho en `700px`.
     
     Establezca el texto 'alt' de la gráfica para que un usuario con 
     discapacidad visual pueda saber que es una gráfica de dispersión 
     de cinco números aleatorios.
"
# Resolución del problema ----------------------------------------------
"
La función plotOutput puede tomar argumentos estáticos de width y height.
Usando la aplicación de la sección de gráficos, solo necesitamos agregar
el argumento de altura y modificar el ancho.
"
#          Ejecuta este código
# ----------------------------------------------------------------------
# library(shiny)
# 
# ui <- fluidPage(
#   plotOutput("plot", width = "700px", height = "300px")
# )
# 
# server <- function(input, output, session) {
#   output$plot <- renderPlot(plot(1:5), res = 96)
# }
# 
# shinyApp(ui, server)