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

## https://dnsmichi.at/2022/03/11/new-zsh-theme-on-macos-powerlevel10k/
## https://piotrminkowski.com/2021/10/25/kubernetes-multicluster-with-kind-and-cilium/

kind delete clusters c1
kind delete clusters c2

kind create cluster --name c1 --config kind-c1-config.yaml 
kind create cluster --name c2 --config kind-c2-config.yaml

kubectl config use-context kind-c1

helm repo add cilium https://helm.cilium.io/
helm repo update

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

cilium status --wait
cilium connectivity test

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
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/main/config/manifests/metallb-native.yaml
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl get pod -n metallb-system


Enable Cilium Multicluster on Kubernetes
cilium clustermesh enable --context kind-c1 \
   --service-type LoadBalancer \
   --create-ca
cilium clustermesh status --context kind-c1 --wait

cilium clustermesh enable --context kind-c2 \
   --service-type LoadBalancer \
   --create-ca
cilium clustermesh status --context kind-c2 --wait

cilium clustermesh connect --context kind-c1 \
   --destination-context kind-c2

cilium clustermesh status --context kind-c1 --wait

cilium clustermesh status --context kind-c1 --wait
cilium connectivity test --context kind-c1 --multi-cluster kind-c2


```