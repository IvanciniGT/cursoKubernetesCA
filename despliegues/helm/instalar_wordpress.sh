#!/bin/bash

function install(){
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm install miWordpress bitnami/wordpress \
        --namespace wordpress \
        --create-namespace \
        -f wordpress.values.yaml
}
    

function uninstall(){
    helm uninstall miWordpress \
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
