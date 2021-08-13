# Visualización: Ejercicicos 2 - Mapear elementos estéticos --------------------------------------------

# 1. ¿Qué hay de malo con este código?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
# 2. ¿Qué variables de mpg son categóricas? ¿Qué variables de mpg son continuas? ¿Cómo puedes saber esta información cuando corres mpg?
# 3. Mapea una variable continua para color, tamaño y forma
# qué hace la estética "stroke" pista: utiliza ?geom_point
# 4. qué pasa si en lugar de poner una variable ponemos una condición, ej: aes(color = displ < 5)




"
Soluciones:
1. El argumento color = 'azul' se incluye dentro del argumento de mapeo y, como tal, 
   se trata como una estética, que es un mapeo entre una variable y un valor. 
   
   En la expresión, color = 'azul', 'azul' se interpreta como una variable categórica
    que solo toma un único valor 'azul'. Si esto es confuso, considere cómo color = 1:234
    y color = 1 son interpretados por aes().

El siguiente código produce el resultado esperado:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), colour = 'blue')

2. La siguiente lista contiene las variables categóricas en mpg:
manufacturer
model
trans
drv
fl
class

La siguiente lista contiene las variables continuas en mpg:
displ
year
cyl
cty
hwy

En el marco de datos impreso, los corchetes en ángulo en la parte superior de cada
columna proporcionan el tipo de cada variable.

3. La variable cty, millas por galón de autopista de la ciudad, es una variable continua.
ggplot(mpg, aes(x = displ, y = hwy, colour = cty)) +
  geom_point()
  
En lugar de usar colores discretos, la variable continua usa una escala que varía de un 
color azul claro a oscuro.

ggplot(mpg, aes(x = displ, y = hwy, size = cty)) +
  geom_point()
  
4.  La estética también se puede asignar a expresiones como displ <5. 
La función ggplot() se comporta como si se hubiera agregado una variable temporal 
a los datos con valores iguales al resultado de la expresión. En este caso, el
resultado de displ <5 es una variable lógica que toma valores de TRUE o FALSE.

Esto también explica por qué, en el ejercicio 3.3.1, la expresión color = 'azul'
creó una variable categórica con una sola categoría: 'azul'.

ggplot(mpg, aes(x = displ, y = hwy, colour = displ < 5)) +
  geom_point()
"
