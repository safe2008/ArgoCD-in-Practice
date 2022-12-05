```
kind create cluster --config=kind-config.yaml --name=k8s-cilium
kubectl cluster-info --context k8s-cilium

helm repo add cilium https://helm.cilium.io/

docker pull quay.io/cilium/cilium:v1.12.4
kind load docker-image quay.io/cilium/cilium:v1.12.4

helm install cilium cilium/cilium --version 1.12.4 \
   --namespace kube-system \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes

## https://piotrminkowski.com/2021/10/25/kubernetes-multicluster-with-kind-and-cilium/

kind delete clusters c1
kind delete clusters c2

kind create cluster --name c1 --config kind-c1-config.yaml 
kind create cluster --name c2 --config kind-c2-config.yaml

kubectl config use-context kind-c1

helm repo add cilium https://helm.cilium.io/

helm install cilium cilium/cilium --version 1.12.4 \
   --namespace kube-system \
   --set nodeinit.enabled=true \
   --set kubeProxyReplacement=partial \
   --set hostServices.enabled=false \
   --set externalIPs.enabled=true \
   --set nodePort.enabled=true \
   --set hostPort.enabled=true \
   --set cluster.name=c1 \
   --set cluster.id=1

kubectl config use-context kind-c2
helm install cilium cilium/cilium --version 1.12.4 \
   --namespace kube-system \
   --set nodeinit.enabled=true \
   --set kubeProxyReplacement=partial \
   --set hostServices.enabled=false \
   --set externalIPs.enabled=true \
   --set nodePort.enabled=true \
   --set hostPort.enabled=true \
   --set cluster.name=c2 \
   --set cluster.id=2

## Install MetalLB on Kind
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/namespace.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/master/manifests/metallb.yaml
kubectl get pod -n metallb-system

```