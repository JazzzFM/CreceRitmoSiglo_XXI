# Introducción ------------------------------------------------------------
"
En esta sección vamos a utilizar **quanteda**, 
que es un paquete R para administrar y analizar datos textuales.

Mientras que el uso de Quanteda requiere conocimiento de la programación 
en R, su API está diseñada para permitir un análisis potente y eficiente
con un mínimo de pasos.

Al enfatizar el diseño constante, además, **quanteta** reduce las barreras
para aprender y utilizar el análisis de texto NLP y cuantitativo.
"

### Instalación
"
Normalmente este paquete lo podemos descargar desde el CRAN
"

install.packages("quanteda")

"
O para la última versión de desarrollo:

DevTools requerido para instalar Quanteda desde GitHub
"

devtools::install_github("quanteda/cuantda")


### Paquetes adicionales recomendados:
"
Los siguientes paquetes funcionan bien con quanteda 
o lo complementan y por eso recomendamos que también los instales:
 
* **readtext**: una manera sencilla de leer data de texto casi con
                cualquier formato con R,.

* **spacyr**: NLP usando la librería spaCy, incluyendo etiquetado 
              part-of-speech, entity recognition y dependency parsing.

* **quanteda.corpora**: data textual adicional para uso con quanteda.
"

devtools::install_github("quanteda/quanteda.corpora")

"
* **LIWCalike**: Una implementación en R del abordaje de análisis de texto 
                Linguistic Inquiry and Word Count.
"

devtools::install_github("kbenoit/quanteda.dictionaries")

"
Debido a que esto compila un código fuente de C ++ y FORTRAN, 
deberás haber instalado los compiladores apropiados para construir 
la versión de desarrollo.

**quanteda** tiene un simple y poderoso paquete adicional para
cargar textos: `readtext`.

La función principal en este paquete, `readtext()`, 
toma un archivo:
  
* archivos de texto (.txt);
* archivos de valores separados por comas (.csv);
* data en formato XML;
* data del API de Facebook API, en formato JSON;
* data de la API de Twitter, en formato JSON; y
* data en formato JSON en general.

El comando constructor de corpus llamado `corpus()` funciona directamente sobre:
  
* Un vector de objetos de tipo character, 
* Un objeto corpus `VCorpus` del paquete `tm`.
* Un data.frame que contenga una columna de texto 
"

## Creando un Corpus
"
Primero se debe cargar la librería:
"  

library(quanteda)


### Construyendo un corpus de un vector de tipo character
"
El caso más simple sería crear un corpus de un vector de textos 
que ya estén en la memoria en R. 

Si ya se disponen de textos en este formato es posible llamar a la
función de constructor de corpus directamente. 

Es posible demostrarlo en el objeto de tipo character integrado de
los textos sobre políticas de inmigración extraídos de los manifiestos
de partidos políticos compitiendo en la elección del Reino Unido en 2010
(llamado `data_char_ukimmig2010`).
"

corp_uk <- corpus(data_char_ukimmig2010) # construir un nuevo corpus de los textos
summary(corp_uk)

"
Si quisiéramos, también podríamos incorporar también a este corpus algunas
variables a nivel documento – lo que quanteda llama `docvars`.

Esto lo hacemos utilizando la función de R llamada `names()` para obtener
los nombres del vector de tipo character de `data_char_ukimmig2010` y 
asignárselos a una variable de documento (`docvar`).
"

docvars(corp_uk, "Party") <- names(data_char_ukimmig2010)
docvars(corp_uk, "Year") <- 2010
summary(corp_uk)

### Cómo funciona un corpus de quanteda: Principios del Corpus
"
Un corpus está diseñado para ser una “librería” original de documentos 
que han sido convertidos a formato plano, 

Tenemos un nombre especial para meta-data a nivel de documento: `docvars`. 
Estas son variables o características que describen atributos de cada documento.

Un corpus está diseñado para ser un contenedor de textos más o menos estático en
lo que respecta a su procesamiento y análisis. 

Para extraer texto de un corpus, es posible utilizar el extractor llamado `texts()`.
"

texts(data_corpus_inaugural)[2]

"
Para obtener la data resumida de textos de un corpus, se puede llamar al método
`summary()` definido para un corpus.
"

library(quanteda.textmodels)

data(data_corpus_irishbudget2010, package = "quanteda.textmodels")
summary(data_corpus_irishbudget2010)

"
Se puede guardar el output del comando summary como un data frame y graficar
algunos estadísticos descriptivos con esta información:
"  

tokeninfo <- summary(data_corpus_inaugural)

if (require(ggplot2))

ggplot(data = tokeninfo, aes(x = Year, y = Tokens, group = 1)) +
  geom_line() +
  geom_point() +
  scale_x_continuous(labels = c(seq(1789, 2017, 12)), breaks = seq(1789, 2017, 12)) +
  theme_bw()

# El discurso inaugural más largo: William Henry Harrison
tokeninfo[which.max(tokeninfo$Tokens), ]



### Ejercicios 
"
* 1 - `data_char_ukimmig2010` es un vector de caracteres con nombre y consta de
      secciones de los manifiestos electorales británicos sobre inmigración y asilo, 
      crea e imprime un copus de esto:
  
corp_immig <- corpus(____, docvars = data.frame(___ = names(_____)))
print(____)

* 2 - Se tiene el siguiente corpus:

corp <- data_corpus_inaugural

Puede acceder a variables individuales a nivel de documento utilizando
el operador `$`. Por ejemplo usando `corp$Year`, otra forma es usando 
`docvars`, si deseas extraer elementos individuales de las variables del
documento, puede especificarlo con el parámetro `field`:
  
docvars(corp, ___ = "___")
"""

## Manejo de corpus

### Juntando dos objetos de corpus
"
El operador `+` provee un método simple para concatenar dos objetos corpus. 
"

corp1 <- corpus(data_corpus_inaugural[1:5])
corp2 <- corpus(data_corpus_inaugural[53:58])
corp3 <- corp1 + corp2
summary(corp3)


### Armando subsets dentro de objetos corpus
"
Hay un método de la función `corpus_subset()` definida por objetos
corpus, donde un nuevo corpus puede ser extraído en base a condiciones
lógicas aplicadas a `docvars`:
"

summary(corpus_subset(data_corpus_inaugural, Year > 1990))


summary(corpus_subset(data_corpus_inaugural, President == "Adams"))

### Explorando textos de corpus
"
La función `kwic` (**keywords-in-context**) realiza una búsqueda de una palabra y
permite visualizar los contextos en los que aparece:
"

kwic(data_corpus_inaugural, pattern = "terror")

kwic(data_corpus_inaugural, pattern = "terror", valuetype = "regex")

kwic(data_corpus_inaugural, pattern = "communist*")

"
En el summary de arriba, las variables **Year** (año) y **President** (presidente)
son variables asociadas a cada documento. 

Es posible acceder a dichas variables con la función `docvars()`
"

head(docvars(data_corpus_inaugural))


### Ejercicios
"
* 1 - Para el siguiente texto devuelve una lista de una palabra clave 'secure*',
además con el tipo de coincidencia de patrones: 'glob' para expresiones comodín
de estilo 'glob', con la cantidad de palabras de contexto que se mostrarán alrededor
de la palabra clave sean 3.

toks <- tokens(data_corpus_inaugural[1:8])
kwic(toks, pattern = "____", valuetype = "___", window = ___)

* 2 - Se tiene el siguiente dataframe:
  
dat <- data.frame(letter_factor = factor(rep(letters[1:3], each = 2)),
                  some_ints = 1L:6L,
                  some_text = paste0('Este es un texto numérico ', 1:6, '.'),
                  stringsAsFactors = FALSE,
                  row.names = paste0('fromDf_', 1:6))
dat


* Construye un corpus de este dataframe y después haz un resumen del mismo.

corpus(___, text_field = "___",
          meta = list(source = "_____")) %>% 
  summary()
"

## Extraer atributos de corpus
"
Para realizar análisis estadísticos tales como document `scaling`, 
es necesario extraer una matriz asociando valores de ciertos atributos
con cada documento. 

En quanteda, se utiliza la función `dfm` para producir dicha matriz.
`dfm`, por sus siglas en inglés **document-feature matrix** o 
matriz documento-atributo en español, siempre se refiere a los documentos 
como filas y a los atributos como columnas.

Se denominan **atributos** en vez de términos porque los atributos son más
generales que los términos: pueden ser definidos como términos crudos,
`términos stemmed`, términos de partes de discurso, términos luego de la
remoción de las **stopwords** o una clase de diccionario al que pertenece
un término.
"

### Convirtiendo textos en tokens
"
Para convertir un texto en tokens de manera simple, quanteda provee un poderoso
comando denominado `tokens()`. 

El comando `tokens()` es deliberadamente conservador, es decir, que no remueve
nada del texto excepto que se le especifique explícitamente que lo haga.
"

txt <- c(text1 = "Esto es $ 10 en 999 formas diferentes,\n arriba y abajo; ¡izquierda y derecha!",
         text2 = "@kenbenoit trabajando: en #quanteda 2day\t4ever, http://textasdata.com?page=123.")

tokens(txt)

tokens(txt, remove_numbers = TRUE,  remove_punct = TRUE)

tokens(txt, remove_numbers = FALSE, remove_punct = TRUE)

tokens(txt, remove_numbers = FALSE, remove_punct = FALSE)


tokens(txt, remove_numbers = FALSE, remove_punct = FALSE, remove_separators = FALSE)

"
También existe la opción de convertir en token los caracteres:
"

tokens("Great website: http://textasdata.com?page=123.", what = "character")

tokens("Great website: http://textasdata.com?page=123.", what = "character",
       remove_separators = FALSE)

"
y las oraciones:
" 

tokens(c("dijo Kurt Vongeut; solo los idiotas usan punto y coma.",
         "Hoy es jueves en Canberra: es ayer en Londres",
         "En el caso de que no puedas ir con ellos, ¿quieres ir con nosotros?"),
       what = "sentence")

### Construyendo una matriz de documentos y atributos
"
Convertir los textos en tokens es una opción intermedia y la mayoría 
querrán directamente construir la matriz de documentos y atributos.

Para hacer esto existe la función de navaja suiza llamada `dfm()`

A diferencia del enfoque conservador de `tokens()`, la función `dfm()`
aplica ciertas opciones por default, como `tolower()` – una función 
separada para transformar textos a minúsculas – y remueve puntuación. 

"

corp_inaug_post1990 <- corpus_subset(data_corpus_inaugural, Year > 1990)

# hacer un dfm
dfmat_inaug_post1990 <- tokens(corp_inaug_post1990) %>%
  dfm()

dfmat_inaug_post1990[, 1:5]

"
Otras opciones para incluyen remover las stopwords y realizar stemming de los tokens.
"

# hacer un dfm, eliminando palabras vacías y aplicando derivaciones

dfmat_inaug_post1990 <- dfm(dfmat_inaug_post1990,
                            remove = stopwords("english"),
                            stem = TRUE, remove_punct = TRUE)

dfmat_inaug_post1990[, 1:5]

"
La opción `remove` provee una lista de tokens a ser ignorados.

La mayoría de los usuarios proveerán una lista de `stop words`
predefinidas para varios idiomas, accediendo a través de la función `stopwords()`:
" 

head(stopwords("en"), 20)

head(stopwords("es"), 20)

head(stopwords("ru"), 10)

head(stopwords("ar", source = "misc"), 10)


### Visualizando la matriz de documentos y atributos
"
El `dfm` puede ser inspeccionado en el panel de **Environment** en 
Rstudio o llamando la función View en R. Llamando la función plot en
un `dfm` se presentará una nube de palabras usando el paquete wordcloud package
"

dfmat_uk <- dfm(data_char_ukimmig2010, remove = stopwords("english"), remove_punct = TRUE)
dfmat_uk

"
Para acceder a la lista de los atributos más frecuentes 
es posible utilizar `topfeatures()`:
"

topfeatures(dfmat_uk, 20) # 20 palabras más frecuentes

"
Para un objeto `dfm` se puede graficar una nube de palabras usando 
`textplot_wordcloud()`.

Esta función pasa argumentos a `wordcloud()` del paquete wordcloud
y puede embellecer el gráfico usando los mismos argumentos:
"  

set.seed(100)
library("quanteda.textplots")
textplot_wordcloud(dfmat_uk, min_freq = 6, random_order = FALSE,
                   rotation = .25,
                   colors = RColorBrewer::brewer.pal(8, "Dark2"))


### Agrupando palabras por diccionario o clase de equivalencia
"
Para algunas aplicaciones se tiene conocimiento previo del conjunto de palabras
que son indicativas de rasgos que quisiéramos medir. 

Por ejemplo, una lista general de palabras positivas puede indicar sentimiento 
positivo

En estos casos, a veces es útil tratar estos grupos 

Del corpus original seleccionamos los presidentes desde Clinton:
"  

corp_inaug_post1991 <- corpus_subset(data_corpus_inaugural, Year > 1991)

"
Ahora definimos un diccionario de muestra:
"

dict <- dictionary(list(terror = c("terrorism", "terrorists", "threat"),
                        economy = c("jobs", "business", "grow", "work")))

"
Se puede usar el diccionario cuando creamos el dfm:
"

dfmat_inaug_post1991_dict <- dfm(corp_inaug_post1991, dictionary = dict)

dfmat_inaug_post1991_dict


### Ejercicios 
"
* 1 - Se tiene la siguiente keyword-in-context:
  
kw <- kwic(tokens(data_char_sampletext, remove_separators = FALSE),
           pattern = 'econom*', separator = '')
           
* ¿Cómo lo podrías transformar a un `corpus` y posteriormente haz un resumen?
  
corpus(___, split_context = ___) %>% 
  summary()

* 2 - Se tiene el siguiente documento tokenizado:
  
set.seed(123)
toks <- tokens(data_corpus_inaugural[1:6])
toks

* Toma una muestra aleatoria de documentos del tamaño especificado del corpus de tamaño 10 con remplazo:
  
tokens_sample(____, size = ____, replace = ____)

* 3 - Construye una matriz de características de documento dispersa, a partir del siguiente corpus y filtra después del año **1980**:
  
data_corpus_inaugural %>%
  corpus_subset(____) %>%
  tokens() %>% 
  dfm()
"

## Análisis Típicos

### Similitudes entre textos

dfmat_inaug_post1980 <- dfm(corpus_subset(data_corpus_inaugural, Year > 1980),
                            remove = stopwords("english"), stem = TRUE, remove_punct = TRUE)


library("quanteda.textstats")
tstat_obama <- textstat_simil(dfmat_inaug_post1980,
                              dfmat_inaug_post1980[c("2009-Obama", "2013-Obama"), ],
                              margin = "documents", method = "cosine")
tstat_obama

"
Se puede utilizar estas distancias para graficar un dendrograma, 
armando clusters por presidente:
"

data_corpus_sotu <- read_rds("data_corpus_sotu.rds")

dfmat_sotu <- dfm(corpus_subset(data_corpus_sotu, Date > as.Date("1980-01-01")),
                  stem = TRUE, remove_punct = TRUE,
                  remove = stopwords("english"))


dfmat_sotu <- dfm_trim(dfmat_sotu, min_termfreq = 5, min_docfreq = 3)

# agrupamiento jerárquico: obtenga distancias en dfm normalizado
tstat_dist <- textstat_dist(dfm_weight(dfmat_sotu, scheme = "prop"))

# agrupamiento jerárquico del objeto de distancia
pres_cluster <- hclust(as.dist(tstat_dist))

# etiqueta con nombres de documentos
pres_cluster$labels <- docnames(dfmat_sotu)

# trazar como un dendrograma
plot(pres_cluster, xlab = "", sub = "",
     main = "Distancia euclidiana en frecuencia de token normalizada")

"
También se puede observar similitudes de los términos:
"

tstat_sim <- textstat_simil(dfmat_sotu, dfmat_sotu[, c("fair", "health", "terror")],
                            method = "cosine", margin = "features")
lapply(as.list(tstat_sim), head, 10)


### Escalamiento de posiciones de documentos
"
Aquí realizamos una demostración de escalamiento de documentos unsupervised
comparado con el modelo **wordfish**:
"

library("quanteda.textmodels")
dfmat_ire <- dfm(data_corpus_irishbudget2010)

tmod_wf <- textmodel_wordfish(dfmat_ire, dir = c(2, 1))

# trazar las estimaciones de Wordfish por partido
textplot_scale1d(tmod_wf, groups = docvars(dfmat_ire, "party"))


quanteda hace muy sencillo ajustar topic models también. Por ejemplo:
  
dfmat_ire2 <- dfm(data_corpus_irishbudget2010,
                  remove_punct = TRUE, remove_numbers = TRUE,
                  remove = stopwords("english"))


dfmat_ire2 <- dfm_trim(dfmat_ire2, min_termfreq = 4, max_docfreq = 10)
dfmat_ire2


set.seed(100)
if (require(topicmodels)) {
  my_lda_fit20 <- LDA(convert(dfmat_ire2, to = "topicmodels"), k = 20)
  get_terms(my_lda_fit20, 5)
}


### Visualizacion de Textos
"
Construir la matriz de co-ocurrencia de características
"

examplefcm <- tokens(data_corpus_irishbudget2010, remove_punct = TRUE) %>%
  
  tokens_tolower() %>%
  tokens_remove(stopwords("english"), padding = FALSE) %>%
  fcm(context = "window", window = 5, tri = FALSE)

"
Elije 30 características de más frecuencia 
"

topfeats <- names(topfeatures(examplefcm, 30))

"
Seleccione solo las 30 características principales, trace la red
"

set.seed(100)
textplot_network(fcm_select(examplefcm, topfeats), min_freq = 0.8)


### Ejercicios 
"
* 1 - Se tiene la siguiente matriz

set.seed(10)
dfmat1 <- dfm(corpus_subset(data_corpus_inaugural, President == 'Obama'),
              remove = stopwords('english'), remove_punct = TRUE) %>%
  dfm_trim(min_termfreq = 3)

¿Cómo harías una nube de palabras para que a menor frecuencia cambie de color? 
  
textplot_wordcloud(____, rotation = 0.25, 
  color = rev(RColorBrewer::brewer.pal(___, ____)))


* 2 - ¿Cómo podrías realizar una nube de palabras por tema? Realiza el corpus subset dividiendo por los presidentes Obama y Trump.

dfmat2 <- dfm(corpus_subset(data_corpus_inaugural,
  President %in% c("___", "____")),
  remove = stopwords("____"), remove_punct = TRUE, groups = "____") %>%
  dfm_trim(min_termfreq = ___)

textplot_wordcloud(dfmat2, ____ = TRUE,
                   max_words = ___, color = c("___", "___"))
"

## Análisis Estadístico 


### Analisis de Frecuencia Simple

corp_tweets <- read_rds("data_corpus_sampletweets.rds")

"
Analizamos los hashtags más frecuentes aplicando `tokens_keep(pattern = '# *')`
antes de crear un DFM.
"

toks_tweets <- tokens(corp_tweets, remove_punct = TRUE) %>% 
  tokens_keep(pattern = "#*")
dfmat_tweets <- dfm(toks_tweets)

tstat_freq <- textstat_frequency(dfmat_tweets, n = 5, groups = lang)
head(tstat_freq, 20)

"
También puede trazar las frecuencias de los hashtags de Twitter fácilmente
usando `ggplot()`.
"

dfmat_tweets %>% 
  textstat_frequency(n = 15) %>% 
  ggplot(aes(x = reorder(feature, frequency), y = frequency)) +
  geom_point() +
  coord_flip() +
  labs(x = NULL, y = "Frequency") +
  theme_minimal()

"
Alternativamente, puede crear una nube de palabras con los 100 hashtags más comunes.
"

set.seed(132)
textplot_wordcloud(dfmat_tweets, max_words = 100)

"
Finalmente, es posible comparar diferentes grupos dentro de un Wordcloud.

Primero creamos una variable ficticia que indica si un tweet se publicó 
en inglés o en otro idioma. Luego, comparamos los hashtags más frecuentes
de tweets en inglés y en otros idiomas.
"

corp_tweets$dummy_english <- factor(ifelse(corp_tweets$lang == "English", 
                                           "English", "Not English"))

# tokenizar textos
toks_tweets <- tokens(corp_tweets)

# crear un dfm agrupado y comparar grupos
dfmat_corp_language <- dfm(toks_tweets) %>% 
  dfm_keep(pattern = "#*") %>% 
  dfm_group(groups = dummy_english)

# crear nube de palabras
set.seed(132) # set seed for reproducibility
textplot_wordcloud(dfmat_corp_language, comparison = TRUE, max_words = 200)


### Diversidad Lexica
"
`textstat_lexdiv()` calcula varias medidas de diversidad léxica en función 
del número de tipos únicos de tokens y la longitud de un documento.
"

toks_inaug <- tokens(data_corpus_inaugural)
dfmat_inaug <- dfm(toks_inaug, remove = stopwords("en"))


tstat_lexdiv <- textstat_lexdiv(dfmat_inaug)
tail(tstat_lexdiv, 5)


plot(tstat_lexdiv$TTR, type = "l", xaxt = "n", xlab = NULL, ylab = "TTR")
grid()
axis(1, at = seq_len(nrow(tstat_lexdiv)), labels = dfmat_inaug$President)

### Análisis de Frecuencias Relativas (keyness)
"
Las palabras clave es una puntuación de asociación firmada de dos por dos
implementada originalmente en WordSmith para identificar palabras frecuentes 
en documentos en un grupo objetivo y de referencia.

Calcular la keyness, una puntuación para las características que ocurren de
manera diferente en las diferentes categorías.
"

# comparar términos anteriores a la posguerra utilizando agrupaciones
period <- ifelse(docvars(data_corpus_inaugural, "Year") < 1945, "pre-war", "post-war")
dfmat1 <- dfm(data_corpus_inaugural, groups = period)
head(dfmat1) # asegúrese de que 'posguerra' esté en la primera fila

"
Con `textstat_keyness()`, puedes comparar frecuencias de palabras entre documentos
de referencia y de destino.

En este ejemplo, los documentos de destino son artículos de noticias publicados en
2016 y los documentos de referencia son los publicados en 2012-2015. 

Usamos el paquete **lubridate** para recuperar el año de publicación de un artículo.
"

require(quanteda.textplots)

dfmat2 <- dfm(data_corpus_inaugural)
head(textstat_keyness(dfmat2, docvars(data_corpus_inaugural, "Year") >= 1945), 10)


dfmat3 <- dfm(corpus_subset(data_corpus_inaugural, period == "post-war"))

textstat_keyness(dfmat3, target = "2017-Trump") %>% 
  textplot_keyness()
