Nodo1 - Master
Nodo4
---------------
Nodo2 - Master
Nodo3




RACK     Nodo 1* Nodo 5*  Nodo 2
RACK     Nodo 3*  Nodo 4 (switch rack se va de baretas)

Que cada master monta su propio cluster 

BRAIN SPLIT 



------------------------------

√ 1 Dashboard
√ Provisionador NFS
    2     - Servidor nfs
    3     - Provisionador
√ 4 Metricas
√ 5 Deployment Apache
------------------------------
Prometheus / Grafana

ElasticSearch         <<<<<<<
Kibana
APACHE
    FILEBEAT




Cluster 
    Nodo1
    Nodo2 
    Nodo3 
    

Casa
    kubectl >>>>> Cluster (POD Apache < apache.yaml)
    
-------------------------------------------------------------
ElasticSearch

1 Nodo1 - Maestro
2 Nodo2 - data - Lucene >> HDD   < VOLUMEN
3 Nodo3 - coordinador    < Comunicacion con el cliente final (explotar los datos)
4 Nodo4 - ingesta        < Comunicacion con los ingestadores

Statefulset


5 Kibana  < Deployment

? Servicios
    Kibana > NodePort
    Elastic?
        coordinadores ClusterIP
        ingesta       ClusterIP
        maestro       ClusterIP
Apache 
    Filebeat >>>> Elasticsearch > Ingesta
    

---------------------------------------------
CLUSTER DE ES
    Tipos de nodos:
        Maestros:
            Pod
        Data:
            Statfulset > n Pod. Siendo n el numero de replicas
        Coordinadores:
            Pod
        Ingesta:
            Pod
Servicios:
    Maestro
    Coordinacion?
        Los pods que tienen el tipo coordinador? npi. 2, 10, 37000
        
        
CLUSTER DE KUBERNETES
Nodo 1 - es-ready=yes
Nodo 2 - es-ready=yes
Nodo 3 - es-ready=yes
Nodo 4
...
Nodo 50


-----------------------------
---
Nodo1-Kubernetes
Nodo2-Kubernetes
    POD: maestro-statefulset-0
        cluster.initial_master_nodes=maestro-statefulset-0,maestro-statefulset-1,maestro-statefulset-2
Nodo3-Kubernetes
    POD: maestro-statefulset-1
        cluster.initial_master_nodes=maestro-statefulset-0,maestro-statefulset-1,maestro-statefulset-2
Nodo4-Kubernetes
    POD: maestro-statefulset-2
        cluster.initial_master_nodes=maestro-statefulset-0,maestro-statefulset-1,maestro-statefulset-2
Nodo5-Kubernetes


