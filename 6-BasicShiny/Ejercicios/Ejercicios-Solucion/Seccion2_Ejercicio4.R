"
4 - Si tienes una lista moderadamente larga en un `selectInput()`, 
    es útil crear subtítulos que dividan la lista en pedazos.
    
    Lee la documentación para descubrir cómo. 
    (Sugerencia: el HTML subyacente se llama <optgroup>)
"

# Resolución del problema ----------------------------------------------
"
Podemos establecer el intervalo entre cada valor seleccionable usando el argumento de paso.
Además, al establecer `animate = TRUE`, el control deslizante se animará automáticamente 
una vez que el usuario presione reproducir.
"

sliderInput("number", "Select a number:",
            min = 0, max = 100, value = 0, 
            step = 5, animate = TRUE)