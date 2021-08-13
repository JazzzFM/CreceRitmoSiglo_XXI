# Clase 1: Importación ----------------------------------------------------

## Introducción

library(tidyverse) 
# O bien
library(readr) 


#   La mayoría de las funciones de readr están relacionadas
#   con convertir archivos planos en dataframes:
# * `read_csv()` y `read_csv2()`  
# * `read_tsv()` 
# * `read_delim()` 
# * `read_fwf()`  
# * `read_log()` 
#   El primer argumento de `read_csv()` es el más importante:
#   es la ruta al archivo a leer.


heights <- read_csv("data/heights.csv")

"
Crear ejemplos reproducibles
para compartir con otros:
" 

read_csv("
a,b,c
1,2,3
4,5,6
")


# 1 - Puede usar `skip = n` para omitir las primeras n líneas;  o use `comment = '#'
# para eliminar todas las líneas que comienzan con (p. ej.) `#`


read_csv("Primer linea de metadatos
  La segunda linea de metadatos
  x,y,z
  1,2,3", skip = 2)

read_csv("# Un comentario que quiero quitar
  x,y,z
  1,2,3", comment = "#")


# 2 - Es posible que los datos no tengan nombres de columna. 
# Puedes usar `col_names = FALSE` 


read_csv("1,2,3\n4,5,6", col_names = FALSE)


# (`\n` es un atajo conveniente para agregar una nueva línea.
# Alternativamente, puede pasar `col_names` un vector 


read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))


# Otra opción que comúnmente necesita ajustes es `na`:
  

read_csv("a,b,c\n1,2,.", na = ".")


# Esto es todo lo que necesita saber para leer aproximadamente el 75% de
# los archivos CSV que encontrarás en la práctica.


## Analizadores 

# Debemos desviarnos un poco para hablar sobre las funciones `parse_*()`
# Estas funciones toman un vector de caracteres y devuelven un vector más
# especializado

  
str(parse_logical(c("TRUE", "FALSE", "NA")))

str(parse_integer(c("1", "2", "3")))

str(parse_date(c("2010-01-01", "1979-10-14")))


# Las funciones `parse_*()` son uniformes: el primer argumento es un vector
# de caracteres para analizar, y el argumento `NA` especifica qué cadenas 
# deben tratarse como faltantes:

parse_integer(c("1", "231", ".", "456"), na = ".")

# Si el análisis falla, recibirá una advertencia:

x <- parse_integer(c("123", "345", "abc", "123.45"))

# Y faltarán las fallas en la salida:
  
x

# Si hay muchas fallas de análisis, necesitará usar `problem()`

problems(x)

# Hay ocho analizadores particularmente importantes:

# - `parse_logical()` y `parse_integer()` analizan lógicos y
#    enteros respectivamente. 
# 
# - `parse_double()` es un analizador numérico estricto y `parse_number()` 
#    es un analizador numérico flexible.
# 
# - `parse_character()` parece tan simple que no debería ser necesario.
# 
# - `parse_factor()` crea factores, la estructura de datos que R usa para representar
#    variables categóricas con valores fijos y conocidos.
# 
# - `parse_datetime()`, `parse_date()` y `parse_time()` le permiten analizar varias 
#    especificaciones de fecha y hora. 

### Analizar números

parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))


# La configuración regional predeterminada de readr está centrada en EE. UU.
#    `parse_number()` aborda el segundo problema: 
#    ignora los caracteres no numéricos antes y después del número. 

parse_number("$100")
parse_number("20%")
parse_number("Esto cuesta $123.45")

# Usada en America
parse_number("$123,456,789")

# Usada en muchas partes de Europa
parse_number("123.456.789", locale = locale(grouping_mark = "."))

# Usada en Suiza
parse_number("123'456'789", locale = locale(grouping_mark = "'"))

# Analizar fechas

parse_date("01/02/15", "%m/%d/%y")

parse_date("01/02/15", "%d/%m/%y")

parse_date("01/02/15", "%y/%m/%d")

parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))


### Escribir a un archivo

# `readr` también viene con dos funciones útiles para escribir datos en el disco: 
#   `write_csv()` y `write_tsv ()`. 
# 
#  Siempre codificando cadenas en UTF-8.
#  Guardar fechas y fechas y horas en formato ISO8601 
# 

write_csv(mtcars, "mtcars.csv")
write_tsv(mtcars, "mtcars.tsv")

#### Otros tipos de datos
#  `haven` lee archivos **SPSS**, **Stata** y **SAS**.
#  `readxl` lee archivos de **Excel** (tanto **.xls** como **.xlsx**).

read_excel(readxl_example("clippy.xlsx"), col_types = c("text", "list"))

#  `DBI`, junto con un backend específico de la base de datos 
#   (por ejemplo, **RMySQL**, **RSQLite**, **RPostgreSQL**, etc.) 
#  Para datos jerárquicos: usa `jsonlite` (de Jeroen Ooms) para **json** 
#  `xml2` para **XML**. 


# Ejercicios: importación
"
1.  ¿Qué función usarías para leer un archivo donde los campos estuvieran separados con '|'?
2.  Aparte de `file`, `skip` y `comment`, ¿Qué otros argumentos tienen en común
    `read_csv()` y `read_tsv()`? 
3.  ¿Cuáles son los argumentos más importantes para read_fwf()?
4.  ¿Qué sucede si intentas establecer `decimal_mark` y `grouping_mark` en el mismo carácter?
5.  ¿Qué sucede con el valor predeterminado de `decimal_mark` cuando establece el 
    `grouping_mark` en `.` ?
"

# Clase 2: joins ----------------------------------------------------------
# Para ayudarlo a aprender cómo funcionan las uniones, usaré una representación visual:
# __ Ver imagen-1 en la carpeta images ____
  
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)


# La columna de color representa la variable "key": 
#   se utilizan para hacer coincidir las filas entre las tablas.
# 
# Una combinación es una forma de conectar cada fila en x con cero, una o más filas en y.
#  __ Ver imagen-2 en la carpeta images ____

### Inner join
# El tipo de combinación más simple es la combinación interna

x %>% 
  inner_join(y, by = "key")

# La propiedad más importante de una combinación interna es que las filas no coincidentes 
# no se incluyen en el resultado

### Combinaciones externas
# Hay tres tipos de combinaciones externas:
# - Un left_join mantiene todas las observaciones en x.

band_members %>%
  left_join(band_instruments)

# - Un right_join mantiene todas las observaciones en y.

band_members %>%
  right_join(band_instruments)

# - Un full_join mantiene todas las observaciones en x e y.

band_members %>%
  full_join(band_instruments)

# Gráficamente, ver  ___ imagen-3 ___ 
# La combinación que se usa con más frecuencia es un left_join()  
# Claves duplicadas --

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)

left_join(x, y, by = "key")


# Definición de las columnas clave ---
# Hasta ahora, los pares de tablas siempre han estado unidos por una sola variable, 
# pero existen otras

# 1 . El valor predeterminado, by = NULL
library(nycflights13)

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2 %>% 
  left_join(weather)

# 2. Un vector de caracteres nombrado

flights2 %>% 
  left_join(airports, c("dest" = "faa"))

flights2 %>% 
  left_join(airports, c("origin" = "faa"))


### Ejercicios: joins
"
1. Calcula el retraso promedio por destino, luego únase al marco de datos de los aeropuertos
    para que pueda mostrar la distribución espacial de los retrasos. A continuación, se muestra
    unaforma sencilla de dibujar un mapa de Estados Unidos:
    
    airports %>%
    semi_join(flights, c('faa' = 'dest')) %>%
    ggplot(aes(lon, lat)) +
    borders('state') +
    geom_point() +
    coord_quickmap()
    
2. Agregue la ubicación del origen y el destino (es decir, la latitud y la longitud) a 
   los vuelos.

3. ¿Existe una relación entre la antigüedad de un avión y sus retrasos?

4. ¿Qué condiciones meteorológicas hacen que sea más probable que se produzcan retrasos?

5. ¿Qué pasó el 13 de junio de 2013? Muestre el patrón espacial de retrasos y luego use
   Google para hacer una referencia cruzada con el clima.
"
# Clase 3: Pivots ---------------------------------------------------------

library(tidyverse)
# O bien
library(tidyr)

# Hay tres reglas interrelacionadas que hacen que un conjunto de datos sea ordenado:
# - Cada variable debe tener su propia columna.
# - Cada observación debe tener su propia fila.
# - Cada valor debe tener su propia celda.

# Pueden haber varios problemas al incio de la importación
# - Una variable puede estar distribuida en varias columnas.
# - Una observación puede estar dispersa en varias filas.

### Alargar (Longer)

# Un problema común es un conjunto de datos donde algunos de los nombres de las columnas no
# son nombres de variables, sino valores de una variable. Ejemplo:

table4a

# Necesitamos girar las columnas en un nuevo par de variables. Los parámetros necesarios son:
# - El conjunto de columnas cuyos nombres son valores, no variables.
# - El nombre de la variable a la que mover los nombres de las columnas.
# - El nombre de la variable a la que mover los valores de la columna. 

table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "año", values_to = "casos")

# `año` y `casos` no existen en `table4a` por lo que ponemos sus nombres entre comillas.
# `pivot_longer()` alarga los conjuntos de datos aumentando el número de filas y
#  disminuyendo el número de columnas. Otro ejemplo:

table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "año", values_to = "poblacion")


# Para combinar las versiones ordenadas de `table4a` y `table4b` en un solo tibble,
# necesitamos usar `left_join()`

tidy4a <- table4a %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "año", values_to = "casos")

tidy4b <- table4b %>% 
  pivot_longer(c(`1999`, `2000`), names_to = "año", values_to = "poblacion")

left_join(tidy4a, tidy4b)


### Ampliar (Wider)

# `pivot_wider()` es lo opuesto a `pivot_longer()`.
# Se usa cuando una observación está dispersa en varias filas. Por ejemplo, 

table2

# Esta vez, sin embargo, solo necesitamos dos parámetros:
# - La columna de la que se tomarán los nombres de las variables. Aquí, es `type`.
# - La columna de la que se tomarán los valores. Aquí es `count`.

table2 %>%
  pivot_wider(names_from = type, values_from = count)


# Opcionalmente, una función aplicada al valor en cada celda de la salida.
# Por ejemplo:

warpbreaks <- as_tibble(warpbreaks[c("wool", "tension", "breaks")])
warpbreaks


warpbreaks %>%
  pivot_wider(
    names_from = wool,
    values_from = breaks,
    values_fn = mean
  )

# `pivot_longer()` hace que las tablas anchas sean más estrechas y largas; 
# `pivot_wider()` hace que las tablas largas sean más cortas y más anchas.



### Ejercicios: pivoting
"
1 - ¿Por qué `pivot_longer()` y `pivot_wider()` no son perfectamente simétricos?
  Considere detenidamente el siguiente ejemplo:
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>%
  pivot_wider(names_from = year, values_from = return) %>%
  pivot_longer(`2015`:`2016`, names_to = 'year', values_to = 'return')

(Sugerencia: observe los tipos de variables y piense en los nombres de las columnas).
`pivot_longer()` tiene un argumento `names_ptypes`, p. ej. `names_ptypes = list(year = double())`. ¿Qué hace?

2 - ¿Por qué falla este código?
  table4a %>%
  pivot_longer(c('1999', '2000'), names_to = 'year', values_to = 'cases')

3 - ¿Qué pasaría si amplías esta tabla? ¿Por qué?
  ¿Cómo podría agregar una nueva columna para identificar de manera única cada valor?

people <- tribble(
  ~name,             ~names,  ~values,
  #-----------------|--------|------
  'Phillip Woods',   'age'',       45,
  'Phillip Woods',   'height',   186,
  'Phillip Woods',   'age',       50,
  'Jessica Cordero', 'age'',       37,
  'Jessica Cordero', 'height',   156
)

4 - Ordena el tibble simple de abajo.
¿Necesitas ensancharlo o alargarlo?
¿Cuáles son las variables?

preg <- tribble(
  ~pregnant, ~male, ~female,
  'yes',     NA,    10,
  'no',      20,    12
)
"