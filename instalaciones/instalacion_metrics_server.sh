#!/bin/bash

function install(){
    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
}
    
function insecureInstall(){
    curl -L -s https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml | \
    sed "s/secure-port=4443/secure-port=4443\n        - --kubelet-insecure-tls/" | \
    kubectl apply -f -
}
    
function uninstall(){
    kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
}
    
function patchSecurityRules(){
    kubectl patch deployment metrics-server -n kube-system --type=json -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
}
function test_install(){
    if [[ $(kubectl get pods -n kube-system | grep metrics-server | grep -c "1/1     Running") != 1 ]] 
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
    elif [[ "$1" == "--patch-security-rules" ]]
    then
        patchSecurityRules
        shift
    elif [[ "$1" == "--insecure-install" ]]
    then
        insecureInstall
        shift
    elif [[ "$1" == "--test" ]]
    then
        test_install
        exit $?
        shift
    elif [[ "$1" == "--help" ]]
    then
        echo Parámetros admitidos: --install, --uninstall, --patch-security-rules
    else 
        echo Parámetro incorrecto: Se admite: --install, --uninstall, --patch-security-rules
        exit 1
    fi
done


#args del contenedor
#    --kubelet-insecure-tls
    
#Alternativa básica: 
#    1 - Descargar el fichero YAML, añadir el parametro y luego hacer el apply
#    2 - kubectl edit   NO.... Esta para jugar... probar...
#    3 - kubectl patch   Esta esta guay... siempre y cuando, el parametro que queramos modificar sea modificable.
    