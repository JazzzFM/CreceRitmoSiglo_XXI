"
2 - Agrega un control de entrada que le permita al usuario decidir cuántas filas
    mostrar en las tablas de resumen.
"
# Resolución del problema ----------------------------------------------
"
Nuestra función count_top es responsable de agrupar nuestras variables en un
número determinado de factores, agrupando el resto de los valores en “Other”.

La función tiene un argumento n que se establece en 5. 
Al crear una entrada numérica llamada filas, podemos permitir que el usuario 
establezca el número de fct_infreq dinámicamente. 

Sin embargo, debido a que fct_infreq es el número de factores +Other, necesitamos
restar 1 de lo que el usuario selecciona para mostrar el número de filas que ingresan.

Más sobre el texto fuenteSe requiere el texto fuente para obtener información
adicional sobre la traducción
"
library(shiny)
library(forcats)
library(dplyr)
library(ggplot2)

# Nota: estos ejercicios utilizan los conjuntos de datos `lesiones`,` productos` y
# `población` como se crea aquí:
# https://github.com/hadley/mastering-shiny/blob/master/neiss/data.R

count_top <- function(df, var, n = 5) {
  df %>%
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

ui <- fluidPage(
  fluidRow(
    column(8, selectInput("code", "Product",
                          choices = setNames(products$prod_code, products$title),
                          width = "100%")
    ),
    column(2, numericInput("rows", "Number of Rows",
                           min = 1, max = 10, value = 5)),
    column(2, selectInput("y", "Y Axis", c("rate", "count")))
  ),
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  fluidRow(
    column(2, actionButton("story", "Tell me a story")),
    column(10, textOutput("narrative"))
  )
)

server <- function(input, output, session) {
  selected <- reactive(injuries %>% filter(prod_code == input$code))
  
  # Encuentra la máxima posible de filas.
  max_no_rows <- reactive(
    # -------------------
  )
  
  # Actualice el valor máximo de numericInput basado en max_no_rows().
  observeEvent(input$code, {
    # -------------------
  })
  
  table_rows <- reactive(input$rows - 1)
  
  output$diag <- renderTable(
    # -------------------
    , width = "100%")
  
  output$body_part <- renderTable(
    # -------------------
   , width = "100%")
  
  output$location <- renderTable(
    # -------------------
    , width = "100%")
  
  summary <- reactive({
    # -------------------
  })
  
  output$age_sex <- renderPlot({
    if (input$y == "count") {
      # -------------------
    } else {
      # -------------------
    }
  })
  
  output$narrative <- renderText({
    # -------------------
  })
}

shinyApp(ui, server)

