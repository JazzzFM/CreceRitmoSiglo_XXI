# Planteamiento del problema ----------------------------------------------
"
 3 - Proporciona una forma de recorrer cada narrativa de forma sistemática con botones de
     avance y retroceso.
"

# Resolución del problema ----------------------------------------------
"
Podemos agregar dos botones de acción prev_story y next_story para iterar a través de la
narrativa. Podemos aprovechar el hecho de que cada vez que hace clic en un botón de acción
en Shiny, el botón almacena cuántas veces se ha hecho clic en ese botón. 

Para calcular el índice de la historia actual, podemos restar el recuento almacenado del
botón next_story del botón previous_story. Luego, al usar el operador de módulo, podemos
aumentar la posición actual en la narración sin ir nunca más allá del intervalo 
[1, longitud de la narración].
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
    column(2, actionButton("prev_story", "Previous story")),
    column(2, actionButton("next_story", "Next story")),
    column(8, textOutput("narrative"))
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
  )
  
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
  
  # Almacene el máximo número posible de historias.
  max_no_stories <- reactive(length(selected()$narrative))
  
  story <- reactiveVal(1)
  
  # Reinicie el contador de historias si el usuario cambia el código del producto.
  observeEvent(input$code, {
    # -------------------
  })
  
  # Cuando el usuario hace clic en "Siguiente historia", aumenta la posición actual en el
  # narrativa, pero nunca vaya más allá del intervalo [1, longitud de la narración].
  # Tenga en cuenta que la función mod (%%) se mantiene `` actual '' dentro de este intervalo.
  observeEvent(input$next_story, {
    # -------------------
  })
  
  # Cuando el usuario hace clic en "Historia anterior", disminuya la posición actual en el
  # narrativa. Tenga en cuenta que también aprovechamos la función mod.
  observeEvent(input$prev_story, {
    # -------------------
    })
  
  output$narrative <- renderText({
    # -------------------
      })
}

shinyApp(ui, server)