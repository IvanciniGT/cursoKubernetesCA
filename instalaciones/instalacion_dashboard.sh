#!/bin/bash

function install(){
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
}
    
function uninstall(){
    kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
    kubectl delete sa/admin-user -n kubernetes-dashboard
    kubectl delete ClusterRoleBinding admin-user -n kubernetes-dashboard
}
    
function createUser(){
    cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOF
    
    cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF
}
function getPassword(){
    echo Token de acceso:
    echo
    kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"
    echo
    
}

while [[ $# != 0 ]]
do
    if [[ "$1" == "--install" ]]
    then
        install
        createUser
        shift
    elif [[ "$1" == "--get-password" ]]
    then
        getPassword
        shift
    elif [[ "$1" == "--uninstall" ]]
    then
        uninstall
        shift
    else 
        echo Parametro incorrecto: Se admite: --install, --get-password, --uninstall
        exit 1
    fi
done