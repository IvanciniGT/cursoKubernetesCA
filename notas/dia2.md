Instalacion:
- MariaDB       - Contenedor   <   Pod
- Wordpress 1   - Contenedor   <   Pod
- Wordpress 2   - Contenedor   <   Pod
- Wordpress 3a  - Contenedor   <   Pod
- Wordpress 3b  - Contenedor   <   Pod
    - WORDPRESS_DB_HOST = IP_MARIADB
        - localhost, siempre y cuando fuera el mismo pod
                     pero en nuestro caso no es.      

$ kubectl describe pod mariadb >>> IP_MARIADB
    RUINA !!!! NUNCA JAMÁS

No tengo garantia que la IP no vaya a cambiar...
De hecho CAMBIARÁ ! en cuanto se recree el POD, por parte de Kubernetes, o mia.
Eso ocurrirá? Si. Motivos:
    - Que se caiga, y haya que ponerlo en marcha de nuevo.
    - Que por carga decida moverlo a otro sitio
    - Que lo quiera actualizar yo. Pej. a una nueva versión de MariaDB

Que es mover un pod?
    Destruit el que tenemos y crear uno nuevo, quee tendrá nueva IP.
    
SERVICIOS:
Qué es un servicio dentro de Kubernetes?
- Nos da un nombre DNS, asociado a una IP cuasiestática, 
  para poder acceder a un puerto de uno o varios POD, aplicando técnicas de balanceo de carga.
- Permite la comunicación entre pods y con clientes externos.

Cualquier comunicación que haga con un puerto que haya abierto un proceso que este corriendo
en un contenedor dentro de un pod que esté en mi cluster de Kubernetes la realizaré
SIEMPRE a través de un servicio.

SERVICIO:
    
    IP (nombre DNS) + colección de puertos
                                            > IP + puerto de un pod 1
                                            > IP + puerto de un pod 2

Cuantos puerto tengo en este escenario:
    - Puerto del servicio   |
    - Puerto del pod        |  Tienen que ser iguales? NO

CARACTERISTICAS DE UN SERVICIO
    NAME
    TYPE            ClusterIP*, LoadBalancer, NodePort
    CLUSTER-IP
    EXTERNAL-IP
    PORT(S)
    
Tipos de servicio:
    ClusterIP:   <<<<<<<<<<<<<<<
        IP (nombre DNS) + colección de puertos con redirecciones a pods
                                            - IP + puerto de un pod 1
                                            - IP + puerto de un pod 2
        Qué limitación le veis a este tipo de servicio?
            Como es su IP? De la red privada de kubernetes.
                Quíen puede acceder a ello? Solo los que estén en la misma red.
            Tengo un nombre de servicio. Quien lo resuelve?
                El DNS interno de Kubernetes.
                Quien puede acceder a ese DNS? los de dentro del cluster.
    -------- Los de abajo están pensados para ser accedidos desde fuera del cluster.
    NodePort = ClusterIP, que además:   NO TIENEN SENTIDO, solo para juagr, probar.
        Se abre en CADA NODO del cluster un puerto (30000-32XXX), en su red pública,
        con una redirección al servicio interno.
    LoadBalancer = NodePort, que además:
        Abre en una IP de la red de fuera del cluster un puerto que también reenvia a los pods
            al servicio interno
        Limitación: Alguien que me dé IPs. Y eso a priori no lo hace Kubernetes.
                                                 --------
                    Esa funcionalidad la implementan por defecto los clouds en sus servicios de kubernetes.
                    
                    Hay un deployment que se puede hacer en un kubernetes on premisses: METALLB
                    Esto permite usar servicios de tipo LoadBalancer en clusters propios.


Ingress: Un objeto dentro de Kubernetes que me permitirá acceder desde fuera a 
servicios internos del cluster.   <<<<<<<<

Qué es un cloud (computing) ? Computación en la nube
    Conjunto de servicios (relacionados con el mundo IT) que ofrece un proveedor a través de Internet.
    Dentro de un cloud se ofrecen muchos tipos de servicios:
        - IaaS
        - PaaS
        - SaaS
        
------------------------
Nodo1   : 30030 > pod nginx:80
    Pod nginx
Nodo2   : 30030 > pod nginx:80
Nodo3   : 30030 > pod nginx:80

Balanceador de carga (externo al cluster)
nginx > IP Nodo1: 30030
      > IP Nodo2: 30031
      > IP Nodo3: 30032

--------------------------

Colección de PODs definidos en base a una TEMPLATE de pod:

Deployment:
    Plantilla de POD + Número de replicas que quiero tener en el cluster
    Aquí las copias de los pods no tienen identidad propia:
        Cada vez que se genera una copia de un pod, esa copia tiene un nombre nuevo, aleatorio
            Ese nombre tiene un prefijo (que se saca del nombre de la plantilla)
StatfulSet:
    Plantilla de POD + Número de replicas que quiero tener en el cluster
    Aquí las copias de los pods SI tienen identidad propia
        Los nombres de los pods, tendrán dos partes:
            prefijo(igual que arriba)
            Un numero secuencial
        Cuando un pod se cae, o mueve, o recrea, se leanta otro en su lugar con el mismo nombre (ID)
            >>> Se le asocian exactamente las mismas caratceristicas que al pod anterior, con el que compartia nombre:
                - Volumenes que tuviera el pod anterior
DaemonSet:
    Plantilla de POD + Nada, porque automaticamente Kubernetes genera una copia en cada nodo

---------------------------------------------
VOLUMEN?
Qué es un volumen en kubernetes?
Un punto de montaje en el FileSystem del contenedor que apunta a algo que está fuera del contenedor:
    - Un NFS
    - Un fichero que esté en el host
    - Un volumen que tengo alquilado en un cloud (como Amazon, o GCloud)
    - Un trozo de la memoria RAM del host
    - Secret
    - ConfigMap
Para que sirve un volumen:
    - Persistencia de datos ante recreaciones de un contenedor....
    - Inyectar datos a un contenedor
    - Compartir datos entre contenedores de un pod

Tengo un contenedor en ejecución. El contenedor se cae, y necesito levantarlo de nuevo (restart).
    Pierdo los datos que hubiera modificado? En ningun caso,
Donde está el problema ? Si necesito recrear el contenedor

PVC: Persistent Volume Claim
Petición de un Persistent Volume
    - Cuanto espacio quiero
    - Quien puede acceder a parte de mi a ese volumen 
    - Algunas indicaciones adicionales:
        - Calidad
        - Redundancia
        - Velocidad

PV: Persistent Volume
Un volumen que no se elimina cuando el pod se cae.
--------
Que permiten los pvc y los pv?
Separar quien hace cada cosa... Son responsabilidades diferentes

Quién necesita (pide) un volumen? Qué perfil?
    Desarrollador

Quién me provee del volumen a mi que el soy el desarrollador?
    El administrador del cluster de Kubernetes
        Decide con quien contrato