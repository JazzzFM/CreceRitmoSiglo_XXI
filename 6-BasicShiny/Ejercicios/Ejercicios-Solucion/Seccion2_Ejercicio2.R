# Planteamiento del problema ----------------------------------------------
"
2 - Lee atentamente la documentación de `sliderInput()` para descubrir cómo crear
un control deslizante de fecha, como se muestra a continuación.
"
#          Imagen disponeible en el learnr

# Resolución del problema ----------------------------------------------
"
Para crear dicho control deslizante, necesitamos el siguiente código.
"

sliderInput(
  "dates",
  "When should we deliver?",
  min = as.Date("2019-08-09"),
  max = as.Date("2019-08-16"),
  value = as.Date("2019-08-10")
)