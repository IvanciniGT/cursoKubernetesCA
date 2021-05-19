Pod?
Conjunto de contenedores:
- Misma IP
- Mismo host

Contenedor?
Entorno aislado dentro de un SO Linux donde se ejecutan 1 o más procesos.
El proceso principal que se ejecuta dentro de un contenedor se define 
en el atributo COMMAND (IMAGEN > Contenedor)

DOCKER, KUBERNETES, OPENSHIFT >>>> PONE EN MARCHA UN CONTENEDOR:
    Para ponerlo en marcha, que hace?
        Lanza un proceso de tipo runc -> lanza un proceso, 
                                        que es el definido en el COMMAND
    Una vez puesto en marcha un contenedor, que hacen estas herramientas?
        Monitorizar que estén en ejecución, quienes?
            Al proceso principal que se ha lanzado
    Si ese proceso acaba, que ocurre?
        Se considera un error: Reiniciar, recrear....
        
Nodo17
    Taint: AppWeb - Efecto: NoSchedule
    
Nevegador Chrome: Entrar con certificado no válido. Escribir: thisisunsafe


------
Monitorización:
ELK:
    - ElasticSearch:                        Base de datos
    - Kibana:                               Interfaz gráfica para explotar la información
    - Logstash (fluentd, filebeat, kafka)   Scrapper... El que captura los datos

En Kubernetes, cual es el sistema de monitorización más utilizado? 
    - Prometheus:                           Base de datos
    - Grafana:                              Interfaz gráfica para explotar la información
    - Metrics-server                        Scrapper... El que captura los datos






