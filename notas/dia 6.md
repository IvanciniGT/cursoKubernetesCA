# HELM:

0a- Leer el fichero values.yaml, Chart.yaml
0b- Generar una estructura de datos en memoria RAM, que yo puedo consultar para acceder a:
        - Todos los datos del fichero values.yaml
        - Todos los datos del fichero Chart.yaml
        - Todos los datos referentes al despliegue que estoy haciendo
        - Datos del cluster de kubernetes en que instalo

1- Tomar todos los ficheros .yaml que existan dentro de la carpeta templates y cualquier subcarpeta dentro
2- Los lee, los procesa cambiando placeholders
3- Los junta todos en uno solo


----
Datos utilizables desde un placeholder:
 $ sería el equivalente a root / de un filesystem . La primera barra que aparece en el path
 . sería el equivalente al / que escribimos en un path de un filesystem
La esctructura de datos que genera HELM para utilizar dentro del CHART va a incluir
    $.Values            Aqui están todos los datos definidos en el fichero values.yaml... y más   ------      /Values
    $.Chart             Aqui estan los datos del fichero Chart.yaml                               ------      /Chart
    $.Release           Aqui están los datos del despliegue que voy haciendo                      ------      /Release
    $.Capabilities      Aqui estan los datos del cluster
    $.Files             Permite acceder a otros fichero (NO.yaml) que tenga definidos dentro de la carpeta templates
    $.Template          Aqui puedo obtener información del template que estoy procesando en un momento dado
---

Cuando estoy procesando un determinado fichero YAML de lo de las templates:
    1 - Siempre me encuentro en un determinado CONTEXTO ~Como si fuera la carpeta en la que me encuentro dentro de un FileSystem:
        .
        $PWD
    2 - Por defecto siemrpe me encuentro dentro de $, en el raiz

kubectl get secret SECRET_NAME -n NAMESPACE -o jsonpath={.data.ELASTIC_PASSWORD} | base64 --decode