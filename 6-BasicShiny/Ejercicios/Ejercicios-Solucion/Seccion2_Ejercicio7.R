# Planteamiento del problema ----------------------------------------------
"
  3 - Actualiza las opciones en la llamada a `renderDataTable()` a continuación 
      para que se muestren los datos, pero todos los demás controles estén suprimidos
      (es decir, elimina los comandos de búsqueda, orden y filtrado).
      
      Deberás leer `?RenderDataTable` y revisar las opciones en
      https://datatables.net/reference/option/.
"
#       Ejecute el siguiente código
#
# ui <- fluidPage(
#   dataTableOutput("table")
# )
# server <- function(input, output, session) {
#   output$table <- renderDataTable(mtcars, options = list(pageLength = 5))
# }

# Resolución del problema ----------------------------------------------
"
Podemos lograr esto estableciendo ordering y searching en FALSE dentro de la
lista de opciones.
"
# library(shiny)
# 
# ui <- fluidPage(
#   dataTableOutput("table")
# )
# 
# server <- function(input, output, session) {
#   output$table <- renderDataTable(
#     mtcars, options = list(ordering = FALSE, searching = FALSE))
# }
# 
# shinyApp(ui, server)