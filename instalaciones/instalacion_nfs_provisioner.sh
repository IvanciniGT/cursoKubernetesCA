#!/bin/bash

function install(){
    helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
    
    helm install nfs-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
        --create-namespace \
        --namespace nfs-provisioner \
        --set storageClass.name=volumen-nfs \
        --set nfs.server=172.31.15.251 \
        --set nfs.path=/data/nfs
}
    

function uninstall(){
    helm uninstall nfs-provisioner \
        --namespace nfs-provisioner
}
function test_install(){
    if [[ $(kubectl get pods -n nfs-provisioner | grep -c "1/1     Running") != 1 ]] 
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
