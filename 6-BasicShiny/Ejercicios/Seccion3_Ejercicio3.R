"
3 - ¿Por qué fallará este código?
-----------------------
"
var <- reactive(df[[input$var]])
range <- reactive(range(var(), na.rm = TRUE))
"
----------
¿Por qué los nombres de range() y var() son malos para `reactive`? 
"