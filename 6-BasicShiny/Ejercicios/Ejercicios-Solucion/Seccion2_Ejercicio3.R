# Planteamiento del problema ----------------------------------------------
"
3 - Crea una entrada de control deslizante para seleccionar valores entre 0 y 100
    donde el intervalo entre cada valor seleccionable en el control deslizante es 5.

    Luego, agrega animación al widget de entrada para que cuando el usuario presione
    reproducir, el widget de entrada se desplaza por el rango automáticamente.
"
# Resolución del problema ----------------------------------------------
"
Podemos hacer que el argumento de elecciones sea una lista de pares clave-valor 
donde las claves representan los subtítulos y los valores son listas que contienen
los elementos categorizados por claves.

A modo de ilustración, el siguiente ejemplo separa las razas de animales en dos claves
(categorías): 'perros' y 'gatos'.
"
# Código del problema ----------------------------------------------

selectInput(
  "breed",
  "Select your favorite animal breed:",
  choices =
    list(`dogs` = list('German Shepherd', 'Bulldog', 'Labrador Retriever'),
         `cats` = list('Persian cat', 'Bengal cat', 'Siamese Cat'))
)

"
Si ejecutas el fragmento de código anterior en la consola,
verás el código HTML necesario para generar la entrada. 

También puede ver el <optgroup> como se sugiere en el ejercicio.
"