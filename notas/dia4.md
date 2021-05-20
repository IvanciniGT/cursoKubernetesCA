Helm - Charts




--------------

Pod
    initContainers:  (Secuencialmente)  >>> SCRIPTS
                (Preparar el terreno) - (Prerequisitos)
                               VVVV
                              VOLUMENES
                              ISTIO
                              
        1   Preparador de Plugins
                VOL PLUGINS /plugins
                VOL WP /var/www/html
        2
        3
    containers:       (En paralelo)     >>>> SERVICIOS Y DEMONIOS
        4       MariaDB
        5       Wordpress
                    VOL WP /var/www/html
        6
PVC -> PV        
VOL WP
VOL PLUGINS

Plugins:
    /var/www/html/wp-content/plugins   <<< VOL PERSISTENTE : PLUGINS
    
-----------------------------------

resources:
  limits: 
    memory: 1512Mi   <<<<<<<<<<<<<<     Si hay hueco, se le dejará ir tomando memoria
                                        hasta ese límite.
                                        Al llegar al límite? 
                                            Kubernetes cruje el pod 
    cpu: 600m
  requests:
    memory: 512Mi    <<<<<<<<<<<<<<     Se garantiza esa cantidad de memoria
    cpu: 300m
----------------------------------    
Quien toma en cuenta ese dato? Scheduller  Para ver en que Nodo le pone


Nodo 1
    No tengo comprometidos 600 Mbs <<<<<
Nodo 2
    No tengo comprometidos 300 Mb
    
    
-------------------------------

Resource Quotas - Limitar lo que un desarrollador puede pedir a nivel de Namespace
    Namespace lo asocio a una APP/Entorno
Limit Ranges    - Limitar lo que un desarrollador puede pedir a nivel de POD
    Aprovechamiento/Optimización de los recursos
    Limita el que un pod no se vuelva loco

App1: 2 Pods (escalando) de 3 Gbs
    6Gbs 3x2
    
Nodo 1 - 4 Gb
Nodo 2 - 4 Gb
Nodo 3 - 4 Gb

-----
RAM EN UN SOFTWARE <<<  Proceso
    - Una copia del programa se sube a RAM  <<< Eso crece con el tiempo?
        Podria pero poco
    - Threads - Stack de Metodos de threads  <<< Eso ocupa muy poco
    - Datos que va generando o descagando un programa para uso puntual
        Se crean y se destruyen . El tamaño de esto depende:
            - Complejidad del programa
            - Número de usuarios (hilos-threads)
      Sea mucho o poco... es constante y proporcional al numero de usuarios.
      Buffers
    - Caches  Hasta cuanto crece? <<<<<
-------
NFS

Pod
Service Account
Role
    mirar pvc
    crear pv y delete