```
kind create cluster --config=kind.yaml --name=k8s
kubectl get pods -ns -A -o wide
kubectl cluster-info --context k8s
kind delete clusters k8s

helm repo add bitnami https://charts.bitnami.com/bitnami

## LoadBalancer
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml
kubectl wait --namespace metallb-system --for=condition=ready pod --selector=app=metallb --timeout=90s

## Ingress NGINX
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

cd ch03

kubectl create ns argocd
kubens argocd
kustomize build kustomize-installation | kubectl apply -f-

kustomize build argo-app | kubectl apply -f-

kubectl port-forward service/argocd-server -n argocd 8080:443
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

kubectl apply -f argocd-app.yaml -n argocd

argocd login localhost:8080
mDH-5AqvroDPSiJq

docker container inspect k8s-control-plane --format '{{ .NetworkSettings.Networks.kind.IPAddress }}'
172.18.0.8

kubectl run hello --expose --image nginxdemos/hello:plain-text --port 80
kubectl create --filename ingress.yaml

curl hello.boriphuth.trueddns.com

```