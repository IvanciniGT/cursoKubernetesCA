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
    
------
Node
Pod
Service
Deployment
Statefulset
PVC
PV
ConfigMap
Secret
-----
ServiceAccount
Role
ClusterRole
Bind
-----
LimitRange     - Pod   
ResourceQuota  - Namespace
-----

Donde (Nodos) quiero que vayan los pods?
    Por qué me interesa esto?
        - Arquitectura del Nodo
        - SO
        - Hardware
            - +CPU
            - +RAM
            - +Graficas GPU (Tensorflow)
            - +Red 
---------------------------------------------
        - Seguridad  /  Legales
            - Cluster (Cloud) Distribuido en varias zonas geográficas
---------------------------------------------
        - Separación de entornos < Namespace 
        - 15 maquinas iguales
            Máquina 1:
                MariaDB, SQL Server, MariaDB
                99%
                Red 30%
            Maquina 2:
                Nginx, Tomcat, Weblogic

-------------------------------------------------
Atributo a nivel de POD:
    
    nodeSelector:  << Filtrar a que nodos puede ir un pod en base a LABELS
        kubernetes.io/hostname: ip-172-31-15-251
        zona: EUROPA
    
    nodeName: ip-172-31-15-251
    
POD : MI POD 
    affinity:
        podAffinity:
            required   DuringSchedulingIgnoredDuringExecution:
                - labelSelector:
                    - matchExpressions:
                        - key:  software_type
                          operator: NotIn
                          values: 
                            - mariadb
                  topologyKey:
                  
El POD MI POD se montara en cualquier NODO que tenga dentro un POD que no tenga el label: software_type: mariadb                  
                  
    Esto me asegura que MI POD no se instalará en un nodo que tenga un MariaDB? NO
        Si el nodo tiene otro POD que no tenga esa etiqueta, ahí le vale
    
                                        AFFINITY           ANTIAFFINITY
    Nodo1      mariadb      nginx          √                    X
    Nodo2      nginx                       √                    √
    Nodo3      mariadb                     X                    X
                  
POD : MI POD 
    affinity:
        podAntiAffinity:
            required   DuringSchedulingIgnoredDuringExecution:
                - labelSelector:
                    - matchExpressions:
                        - key:  software_type
                          operator: In
                          values: 
                            - mariadb
                  topologyKey:
                  
El POD MI POD se montara en cualquier NODO que no tenga dentro un POD que tenga el label: software_type: mariadb                  
                  
    Esto me asegura que MI POD no se instalará en un nodo que tenga un MariaDB? SI
                  
                  
                  
                  
                  
                  
                  
                  
                  
                  
            preferred   DuringSchedulingIgnoredDuringExecution:
        
        podAntiAffinity:
        
        nodeAffinity:
            required   DuringSchedulingIgnoredDuringExecution:
                 nodeSelectorTerms:
                    - matchExpressions:
                        - key:  ZONA
                          operator: NotIn
                          values: 
                            - EUROPA
                            - ASIA
            preferred  DuringSchedulingIgnoredDuringExecution:
                - weight: 1
                  preference: 
                    matchExpressions:
                        - key:  ZONA
                          operator: NotIn
                          values: 
                            - EUROPA
                            - ASIA
                - weight: 5
                  preference: 
                    matchExpressions:
                        - key:  ZONA
                          operator: NotIn
                          values: 
                            - CHINA
Que pasa con la HA ???


Maquina 1:


Maquina 2:


Si hay un pod que haga tal cosa, ahi no quiero poner este otro pod 
Si hay un pod que haga tal cosa, ahi quiero poner este otro pod 

-----------------------------------------------------------------------------------------------------------------
POD : MI POD 
    affinity:
        podAffinity:
            required   DuringSchedulingIgnoredDuringExecution:
                - labelSelector:
                    - matchExpressions:
                        - key:  software_type
                          operator: NotIn
                          values: 
                            - mariadb
                  topologyKey: POR DEFECTO VALE: zonageografica
                  
El POD MI POD se montara en cualquier NODO (de entre los nodos de una misma zona geografica 
    que tengan dentro un POD que no tenga el label: software_type: mariadb)
                  
    Esto me asegura que MI POD no se instalará en un nodo que tenga un MariaDB? NO
        Si el nodo tiene otro POD que no tenga esa etiqueta, ahí le vale
    
                                        AFFINITY           ANTIAFFINITY
    ZONA1: (un label del nodo)
        Nodo1      mariadb      nginx          √                    X
        Nodo2      nginx                       √                    √
    ZONA2:  (un label del nodo)
        Nodo3      mariadb                     X                    X
                  
POD : MI POD 
    affinity:
        podAntiAffinity:
            required   DuringSchedulingIgnoredDuringExecution:
                - labelSelector:
                    - matchExpressions:
                        - key:  software_type
                          operator: In
                          values: 
                            - mariadb
                  topologyKey:
                  
El POD MI POD se montara en cualquier NODO que no tenga dentro un POD que tenga el label: software_type: mariadb                  
                  
    Esto me asegura que MI POD no se instalará en un nodo que tenga un MariaDB? SI
---------------------------

CLUSTER: Nodo 1, Nodo 2, Nodo 3, Nodo 4, Nodo 5, Nodo 6

ZONA 1
    Nodo 1
    Nodo 2
ZONA 2
    Nodo 3
    Nodo 4
ZONA 3
    Nodo 5
    Nodo 6


CLIENTE 1
    Nodo 1 - version 18
    Nodo 4
    
CLIENTE 2
    Nodo 2 - version 18
    Nodo 5

CLIENTE 3
    Nodo 3
    Nodo 6
    
    
Nodo 1
Nodo 2
Nodo 4
Nodo 4 
Nodo 5
Nodo 6
    
Instala este POD (Version 17 de mi programa) en un NODO de un CLIENTE que no tenga la version 18:
    Nodo 3 o Nodo 6
    
Instala un POD (LIBRERIA) en un bnodo de un cliente que tenga la versión 18:
    Nodo1 o Nodo 2 o Nodo4 o Nodo 5