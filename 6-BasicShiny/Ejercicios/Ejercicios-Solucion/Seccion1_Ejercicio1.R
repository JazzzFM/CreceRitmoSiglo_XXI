# Planteamiento del problema ----------------------------------------------
"
1 - Crea una aplicación que reciba al usuario por su nombre.
  Aún no conoces todas las funciones que necesita para hacer esto,
  así que incluímos algunas líneas de código a continuación.
  Piensa qué líneas usará y luego cópielas y péguelas en el lugar
  correcto en una aplicación Shiny.
"
#          Lee este código
# ----------------------------
# tableOutput("mortgage")
# 
# output$greeting <- renderText({
#   paste0("Hello ", input$name)
# })
# 
# numericInput("age", "How old are you?", value = NA)
# 
# textInput("name", "What's your name?")
# 
# textOutput("greeting")
# 
# output$histogram <- renderPlot({
#   hist(rnorm(1000))
# }, res = 96)
# ----------------------------

# Resolución del problema ----------------------------------------------
"
En la interfaz de usuario, necesitaremos un textInput para que el usuario ingrese
texto y un textOutput para generar cualquier texto personalizado en la aplicación.

La función de servidor correspondiente a textOutput es renderText, que podemos usar
para componer el elemento de salida que hemos llamado 'saludo'.
"
#          Ejecuta este código
# ----------------------------------------------------------------------
# library(shiny)
# 
# ui <- fluidPage(
#   textInput("nombre", "¿Cuál es tu nombre?"),
#   textOutput("saludo")
# )
# 
# server <- function(input, output, session) {
#   output$saludo <- renderText({
#     paste0("Hola ", input$nombre)
#   })
# }
# 
# shinyApp(ui, server)
# -----------------------------------------------------------------------