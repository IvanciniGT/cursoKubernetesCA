Kubernetes
-----------
Pods
    Conjunto de Contenedores que :
        - IP
        - Misma nodo del cluster
    Procesos en ejecución
        - Puerto comunicaciones entrantes
    
2 Pods puedencomunicarse directamnete, sin nada mas de por medio?
    En principio no hacer un servicio para que 2 pods se puedan comunicar.
        Que problema tengo en este caso? Accedo a través de IP (1 no la conozco a priori, 2 puede cambiar)

Para resolver el problema creamos un servicio:
    - Balanceo de Carga
    - Resolución de nombre (DNS)
    
Tipos de servicio:
    - ClusterIP
        Comunicaciones Internas
    - NodePort
        Comunicaciones externas:
            Puerto (+30000) que abria en TODOS los nodos del cluster
            Que me hace falta adicionalmente ? UN LOAD BALANCER
                *|-  Nodo1       -|   Kernel SO (Reglas NetFilter)
                 |       Pod 1a  -|
                *|-  Nodo2       -|   Kernel SO (Reglas NetFilter)
                 |       Pod 1b  -|
            C1---|-  LB    
    - Load Balancer

Alternativa 1 para exponer un Puerto de uno o varios Pods:
    - Un servicio NodePort+LB(mio)   o    Un servicio LoadBalancer
Alternativa 2:
    - Un ingress: Un proxy reverso + LoadBalancer:
        - nginX        < Proceso en ejecución
        - traffic      < Proceso en ejecución
        - HAProxy      < Proceso en ejecución
        - Apache       < Proceso en ejecución
        
                *|-  Nodo1        -|   Kernel SO (Reglas NetFilter)
                 |       Pod 1a   -|
                *|-  Nodo2        -|   Kernel SO (Reglas NetFilter)
                 |       Pod 1b   -|
            C1---|       Pod NginX-|
                 |          ^^     |
                 |       Pod Cont--|
                 |   Servicio LB
              LB-|     *Servicio NodePort

Que ventajas me da que el NginX sea un POD?
    Toda la gestion del proceso la hace Kubernetes
    
Controlador en Kubernetes

Despliegue dentro del cluster:
    Pod
    
    
    

#                               Clave privada
#      CA1         https        Certificado (Clave publica + CA1) Quien tiene que ser la CA1 (Una entiodad certificadora PUBLICA DE CONFIANZA)
#   Cliente 1--- SECURIZADA ---> nginx ---- https           ------> Wordpress
#                                                                  HTTPS
#                                CA2                               CERTIFICADO (Clave Publica + CA2 / CA Privada)
#   Cliente 2                                                         Clave Privada
#                                           Tipo de HTTPS: mTLS
#                               CERTIFICADO (Clave Provada + CA2)
#                               Clave Privada
#   Usuario+Contraseña
#                                                                   Desarrollador <<<< Imagen de Contenedor

# Comunicaciones: INFRAESTRUCTURA

# ISTIO / Linkerd


Cluster Kubernetes
                         BBDD                                  Namespace 2                  NS3
    Nodo1               MariaDB (172.31.8.128)         <<    Wordpress (172.31.10.125)      WP x
                          ^^^
    Nodo2               MariaDB (172.31.8.129)
    
    
Los namespace sirven para?
Separación la ejecución de Pods.... y de todo....
    Basicamente esto se traduce en que yo puedo tener 2 pods, cm, secrets, servicios... lo que sea
    con el mismo nombre en 2 namespaces diferentes.
    
    Puede el Pod1 hablar con el Pod2? SI, cómo?
        Nombre de servicio o vía IP
        
    Puede el Pod3 hablar con el Pod2? Sin problema ninguno

Esto es una RUINA !!!!!
Cualquier persona con acceso al cluster, que instale dentro un pod con:
    un sniffer de red
    suplantador de algo 

¿Que comunicaciones admito que se produzcan?
Firewall?
    Reglas de transporte que son utilizadas por un "Agente" para canalizar las comunicaciones una red
    
En vuestro ordendor teneis un firwewall? SI
    Windows FW
    Linux FW
        ufw
        firewalld
        
--------
Dentro de kubernetes tenemos los NetWork Policies   >>>   INFRAESTRUCTURA
Un conjunto de reglas de firewall para decidir que comunicaciones se pueden realizar y cuales no.


----------
Backup de BBDD
Alternativa 1: Todo dentro de Kubernetes
    - Job (que es un POD que acaba): Hace el backup
    - CronJob

Alternativa 2: kubectl exec PODBBDD -n BBDD -- mysqldump
    TOKEN DE ACCESO CNOO EL QUE TE CONECTAS
    
---------
50 microservicios en un cluster de kubernetes....
    Welcome to Hell !!!!
    
Service mess !!!  Follón de servicios pero muy gordo: RUINA !!!!
        VVVV
Service mesh     <<<<<     Red de servicios

ISTIO / linkerd => 
    Gestión de las comunicaciones de red
    Ingress
    

POD:
    Conjunto de conteendores:
        - Misma red
        - Misma maquina

ISTIO > Inyectar en cada Pod, (1 Contenedor+ 1 InitContainer)
    Pod Wordpress   ----   Puerto: 80
                            ^^^
        1 Init container: Cambiar las reglar de netFilter del host
            Toda peticion que se realice al puerto 80 sea redirigida al contenedor ENVOY
        1 contenedor: WORDPRESS
                        ^^^
        1 contenedor: Proxy (envoy)
    
    TODO POD dentro de Kubernetes, lleva adosado ese PROXY PROPIO.
    
TODAS las comunicaciones entre PODS quien las gestiona? LOS PROXIES   >>>>> MAN IN THE MIDDLE

POD Wordpress                       POD MariaDB
    Contenedor Wordpress   >>>>>>>   Contenedor Mariadb

POD Wordpress                       POD MariaDB
    Contenedor Wordpress             Contenedor Mariadb
        VVVVV                           ^^^^^^            Se realizan a que nivel: Localhost
    Contenedor proxy    >>>HTTPS>>>  Contenedor de Proxy
        Certificado                     Certificado
        Clave privada                   Clave provada
        CA                              CA   >>> PRIVADA DE ISTIO
        
        
Cuando creas un Deployment en automático se monta un replicaSet
Un replicaset sirve dentro de kuberntes para mantener siempre el numero adecuado de replicas de un pod



chart 
deployment kibana
servicio
ingress
configmap
secret

  kibana:
    image: docker.elastic.co/kibana/kibana:7.7.0
    container_name: kibana
    ports:
        vvv
      - 8082:5601
    environment:
      ELASTICSEARCH_HOSTS: "http://coordinador1:9200"   |
      SERVER_NAME: "kibana"                             > Configmap
      SERVER_HOST: "kibana"                             |
      ELASTICSEARCH_USERNAME: "elastic"             |
      ELASTICSEARCH_PASSWORD: "password"            |  Secret