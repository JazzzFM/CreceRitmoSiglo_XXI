#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
    fluidRow(
        column(6,
               selectInput("calidad", "calidad", 
                choices = diamantes %>%
                dplyr::select(corte,color, claridad) %>% names)
        )
    ),
    fluidRow(
        column(6, plotOutput("caja1"))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

    
    output$caja1 <- renderPlot({
        
        data <- diamantes %>% 
            dplyr::select(input$calidad, precio)
        
        x <- input$calidad %>% as.character()
        
            ggplot(data, aes(x = {{x}}, precio)) +
            geom_boxplot()
        
    }, res = 96)
}


# Run the application 
shinyApp(ui = ui, server = server)
