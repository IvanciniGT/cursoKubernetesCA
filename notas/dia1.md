# Contenedor

Entorno aislado de ejecución de procesos dentro de un sistema operativo anfitrión: LINUX

## Creación de contenedores

Desde una imagen de contenedor. Qué es una imagen de contenedor?
- Archivo ZIP con una estructura de carpetas y archivos ahí dentro
- Configuraciones / información:
    - Qué puertos usan los procesos que se ejecutan allí dentro
    - En qué directorios hay información importante
    - Que proceso es el que se va a iniciar en el contenedor por defecto

## Herramientas para gestionar contenedores

containerd - crio           >    Crear contenedores, Arrancarlos, Pararlos, Gestión básica, Gestión imágenes
docker     - podman         >    Crear imágenes de contenedores, Gestionar repositorios de imágenes
kubernetes - openshift      >    Entornos de producción basados en contenedores

## Entorno de producción:

- Alta disponibilidad:
    Capacidad de sobreponerse a eventualidades para intentar conseguir 
        una determinada cuota o tiempo de servicio.
    Redundancia: Montar un cluster:
        - Activo-pasivo. Tengo 2 copias identicas, pero solo una en funcionamiento. 
                         La otra está de backup.
        - Activo-activo. Tengo N máquinas (al menos 2), y todas funcionando simultaneamente.
                         Balanceador de carga.
- Escalabilidad
    Capacidad de ajustar el entorno (infra) a la carga del sistema.
        A veces hay que crecer en infra.
        Otras disminuir y liberar recursos.
    Montar un cluster:
        - Activo-activo. Tengo N máquinas (al menos 2), y todas funcionando simultaneamente.
                         Balanceador de carga.

# Dentro de Kubernetes/Openshift que es más común: 
    A) Cluster Activo-Activo        I
    B) Cluster Activo-Pasivo        

2 tipos de Clusters:
    - Cluster formado por las máquinas físicas donde se instala Kubernetes
        A) Cluster Activo-Activo        I
    - Cluster formado por los contenedores de mis aplicaciones
        B) Cluster Activo-Pasivo        <      
        A) Cluster Activo-Activo        I

# Qué conceptos importantes surgen en Kubernetes/Openshift:
    - Orquestación?
        Master controlando los nodos y los contenedores. Qué controla?
            - Rendimiento - Métricas
            - Estado de salud
            - Creará nuevos contenedores, los moverá de un nodo a otro
    - Gestión de red?
        Los contenedores se tiene que ver entre ellos. 
    - Control de servicios?
        Balanceo de carga
        Proxy - Descubrimiento de servicios (DNS)
    - Almacenamiento
        Los volumenes en Kubernetes van a ser en su mayor parte EXTERNOS:
            - Alta disponibilidad:
            - Escalabilidad        
    - Seguridad (Control de accesos, autenticación y autorización) - Istio, Linkerd 
    
# Balanceo de carga
    A nivel de Kubernetes / Openshift se implementa mediante 
        Reglas de NetFilter 
    
# Enrutador - Ingress 
nginx



############################################

# Objetos en Kubernetes

## Pod
Conjunto de contenedores, que :
- Tienen la misma configuración de RED:
    - Comparten IP. 
    - Las comunicaciones entre ellos se realizan mediante localhost
- Tengo garantizado que su despliegue se realiza en el mimo nodo (la misma "máquina física")

## Node
Un máquina donde se está ejecutando kubernetes, y que forma parte de un cluster

## Namespace
En entorno aislado que generamos en un cluster de kubernetes, dentro del cual crearemos cosas.
    default: Uno que se incluye siempre y que no usamos NUNCA
    kube-system: Los pods del plano de control de kubernetes

## Service

## DaemonSet

Una forma de desplegar Pods, que me asegura que de una plantilla de pod, se generan tantos pods como nodos tengo.
En cada nodo se genera, se crea un pod, basado en la plantilla que se haya configurado.

## Deployment   |
## StatfulSet   |   Colección de PODs definidos en base a una TEMPLATE de pod
## DaemonSet    |


----


    ## ReplicaSet

## ServiceAccount

## ConfigMap

############################################

# Qué compone un cluster mínimo de kubernetes?
- Un plano de control
    - Un conjunto de Pods (contenedores) que contienen las funcionalidades básicas de kubernetes.
        - DNS               - Resolución interna de servicios
        - API-manager       - Es el que recibe las peticiones del kubectl y las pasa al resto de contenedores de kubernetes
        - Proxy de red      - Montar la red virtual interna del cluster. EN TODOS LOS NODOS
        - Scheduller        - Quien decide donde se ubica un POD nuevo
        - Manager           - Este hace un montón de cosas.
        - ETCd              - Base de datos de Kubernetes
- Configuraciones


#####################
kubectl - cli de kubernetes

kubectl <verbo> <sobre_que?> --namespace kube-system
                             --all-namespaces
         get      objetos: node, namespace, pod, all
         describe
         apply -f FICHERO_YAML    -n NAMESPACE       <<<   Crear cosas en Kubernetes
         delete -f FICHERO_YAML    -n NAMESPACE      <<<   Crear cosas en Kubernetes
         logs    POD -c CONTENEDOR
         exec [-it] POD -c CONTENEDOR -- COMANDO     <<<   Ejecutar un comando dentro de un contenedor
         
         
         taint 
         
service mess --> service mesh (istio, linkerd)



####################################################
Como crear COSAS en kubernetes. Ejemplo 1. POD

Todo se crea mediante ficheros YAML.
    Todo? Hay otra manera de crear cosas en Kubernetes más allá de los ficheros YAML?
        El kubectl permite crear cosas TAMBIEN. NI DE COÑA HAGAIS ESTO !!!!! PROHIBIDO

Como son los ficheros YAML de Kubernetes
####################################################
---
kind:           Pod
apiVersion:     v1
metadata:
    name:       nginx_pod
spec:
    containers:
        - name:     nginx_contenedor
          image:    nginx:latest



#####################################################
Tipos de software :

En un contenedor no montamos aplicaciones:
Aplicación:     Tipo de software que ... está pensado para:
                    - Ser ejecutado en primer plano 
                    - Ejecutarse indefinidamente
                    - Tener interacción con un usuario (PERSONA FISICA)
***Servicio:       Tipo de software que ... está pensado para:
                    - Ser ejecutado en segundo plano
                    - Ejecutarse indefinidamente
                    - Atender preticiones de otros programas 
***Demonio:        Tipo de software que ... está pensado para:
                    - Ser ejecutado en segundo plano
                    - Ejecutarse indefinidamente
                    - Va a su bola! 
CUIDADO !!!! Scripts:        Tipo de software que ... está pensado para:
                    - Ser ejecutado en donde sea
                    - Ejecutarse de forma finita en el tiempo. 
                    - Hace sus N tareas que tenga definidas y acaba!

UN CONTENEDOR EN KUBERNETES ESTA PENSADO COMO UN ENTORNO AISLADO QUE TIENE INDEFINIDAMENTE UN PROCESO EN EJECUCION
                                                                           ---------------
                                                                           
InitContainer <<<<<< Para montar Scripts! SE EJECUTAN DE FORMA FINITA EN EL TIEMPO. ACABAN                                                                            