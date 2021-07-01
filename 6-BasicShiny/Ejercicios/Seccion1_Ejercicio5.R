# Planteamiento del problema ----------------------------------------------
"5 - La siguiente aplicación es muy similar a una que viste anteriormente: 
seleccionas un conjunto de datos de un paquete (esta vez usamos el paquete ggplot2) y
la aplicación imprime un `summary` y un gráfico de los datos. 

También sigue las buenas prácticas y hace uso de expresiones reactivas para evitar la
redundancia de código. Sin embargo, hay tres errores en el código que se proporciona 
a continuación. ¿Puedes encontrarlos y arreglarlos?
"
#          Ejecuta este código
# ----------------------------
# library(shiny)
# library(ggplot2)
# 
# datasets <- c("economics", "faithfuld", "seals")
# ui <- fluidPage(
#   selectInput("dataset", "Dataset", choices = datasets),
#   verbatimTextOutput("summary"),
#   tableOutput("plot")
# )
# 
# server <- function(input, output, session) {
#   dataset <- reactive({
#     get(input$dataset, "package:ggplot2")
#   })
#   output$summmry <- renderPrint({
#     summary(dataset())
#   })
#   output$plot <- renderPlot({
#     plot(dataset)
#   }, res = 96)
# }
# 
# shinyApp(ui, server)

# Resolución del problema ----------------------------------------------
"
La aplicación contiene los siguientes tres errores:
  En la interfaz de usuario, el objeto tableOutput debería ser realmente un plotOutput. 
  En el servidor, la palabra 'summry' en output$summry está mal escrita.
  En el servidor, la función plot en la output$plot debería llamar a dataset()
  en lugar del objeto reactivo.
  La aplicación fija tiene el siguiente aspecto:
"
#          Ejecuta este código
# ----------------------------------------------------------------------
library(ggplot2)
datasets <- data(package = "ggplot2")$results[c(2, 4, 10), "Item"]

ui <- fluidPage(
  selectInput("dataset", "Dataset", choices = datasets),
  verbatimTextOutput("summary"),
  # 1. Change tableOutput to plotOutput.
  plotOutput("plot")
)

server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:ggplot2")
  })

    output$summary <- renderPrint({
      # -------------------
  })
  output$plot <- renderPlot({
    # -------------------
  })
}

shinyApp(ui, server)
# -----------------------------------------------------------------------