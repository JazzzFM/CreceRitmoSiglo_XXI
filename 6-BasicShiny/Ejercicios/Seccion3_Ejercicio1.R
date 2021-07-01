"
  * 1 - Dada esta interfaz de usuario:
"
# ---------------------------
ui <- fluidPage(
  textInput("name", "What's your name?"),
  textOutput("greeting")
)
# --------------------------
"
Corrije los errores simples que se encuentran en cada una de las tres funciones
del servidor a continuación. Primero intente detectar el problema con solo leer
el código; luego ejecute el código para asegurarse de haberlo solucionado.
"
# -----------------------------------------------
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
# -----------------------------------------------

# Resolución del problema ----------------------------------------------
