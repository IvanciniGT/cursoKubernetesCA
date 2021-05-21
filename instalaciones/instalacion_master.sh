# Requisitos

# R1: docker
# R1.1: docker configurado no con groups-> systemd
systemctl status docker
sudo vim /lib/systemd/system/docker.service
## Añadir --exec-opt native.cgroupdriver=systemd en dockerd al arrancar servicio de docker
# Recargar el servicio y reiniciarlo
sudo systemctl daemon-reload
sudo systemctl restart docker

# R2: Descativar Swapping en el SO
sudo swapoff -a # Desactiva solo ahora
# Comprobar con: free
sudo vim /etc/fstab # Desactivarlo permanentemente
#
# Pasos
# Paso 1: Alta del repo de kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo touch /etc/apt/sources.list.d/kubernetes.list
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update

# Paso 2: Instalar kubeadm
sudo apt-get install kubeadm -y
kubeadm version # comprobar la instalación

# Paso 3: Crear cluster con kubeadm
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
# Me salen del comando anterior:
# Configurar mi usuario
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Ya tenemos disponible kubectl  

# Montar una red
#kubectl apply -f [podnetwork].yaml with one of the options listed at:
#  https://kubernetes.io/docs/concepts/cluster-administration/addons/
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Juntar nuevos nodos al cluster
kubeadm join 172.31.8.183:6443 --token s0xdad.kmuq7psv9rtaz2jd \
    --discovery-token-ca-cert-hash sha256:1239c23581b68f7bcaab4183eb1a71e9fd4c685605a5217695d462e77f445e5f 
    
# Activar autocompletado para kubernetes: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

# Para JUGAR y poder instalar cosas en el nodo maestro:
kubectl taint nodes --all node-role.kubernetes.io/master-
# EN PROD NOOOOOOO !!!!!!!!!