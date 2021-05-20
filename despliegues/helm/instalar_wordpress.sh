#!/bin/bash

function install(){
    
    cat << EOF | kubectl apply -f -
---
kind: PersistentVolume
apiVersion: v1
metadata:
    name: volumen-wp-1
spec:
    capacity:
        storage: 10Gi
    accessModes:
        - ReadWriteOnce
    hostPath: 
        path: /home/ubuntu/environment/datos/wp1
        type: DirectoryOrCreate
---
kind: PersistentVolume
apiVersion: v1
metadata:
    name: volumen-wp-2
spec:
    capacity:
        storage: 10Gi
    accessModes:
        - ReadWriteOnce
    hostPath: 
        path: /home/ubuntu/environment/datos/wp2
        type: DirectoryOrCreate
---
EOF
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install mi-wordpress bitnami/wordpress \
        --namespace wordpress \
        --create-namespace \
        -f wordpress.values.yaml 
}
    

function uninstall(){
    helm uninstall mi-wordpress \
        --namespace wordpress
}
function test_install(){
    if [[ $(kubectl get pods -n wordpress | grep -c "1/1     Running") != 2 ]] 
    then
        return 1
    fi
}
while [[ $# != 0 ]]
do
    if [[ "$1" == "--install" ]]
    then
        install
        shift
    elif [[ "$1" == "--uninstall" ]]
    then
        uninstall
        shift
        exit 0
    elif [[ "$1" == "--test" ]]
    then
        test_install
        exit $?
        shift
    elif [[ "$1" == "--help" ]]
    then
        echo Parámetros admitidos: --install, --uninstall, --test
    else 
        echo Parámetro incorrecto: Se admite: --install, --uninstall, --test
        exit 1
    fi
done
