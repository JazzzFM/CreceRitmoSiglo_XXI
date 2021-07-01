# Planteamiento del problema ----------------------------------------------
"
1 - Cuando el espacio es escaso, es útil etiquetar los cuadros de texto con un marcador 
    de posición que aparece dentro del área de entrada de texto. 
    ¿Cómo se llama a `textInput()` para generar la interfaz de usuario a continuación?
"
#          Imagen disponeible en el learnr

# Resolución del problema ----------------------------------------------
"
Mirando la salida de ?textInput, vemos el marcador de posición del argumento que toma:

Una cadena de caracteres que le da al usuario una pista sobre 
lo que se puede ingresar en el control.

Por lo tanto, podemos usar textInput con argumentos como se muestra a continuación
para generar la interfaz de usuario deseada.
"
textInput("text", "", placeholder = "Your name")
