```
kind create cluster --config=kind-config.yaml --name=cilium
kubectl cluster-info --context cilium

helm repo add cilium https://helm.cilium.io/

docker pull quay.io/cilium/cilium:v1.12.4
kind load docker-image quay.io/cilium/cilium:v1.12.4

helm install cilium cilium/cilium --version 1.12.4 \
   --namespace kube-system \
   --set image.pullPolicy=IfNotPresent \
   --set ipam.mode=kubernetes
   
```