```
kind create cluster --config=kind.yaml --name=k8s
kubectl get pods -ns -A -o wide
kubectl cluster-info --context k8s
kind delete clusters kind-k8s

helm repo  add argo https://argoproj.github.io/argo-helm
kubectl create ns  argocd
helm install argo -n argocd argo/argo-cd

kubectl port-forward service/ch02-argocd-server -n argocd 8080:443
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

kubectl apply -f argo-app/

argocd login localhost:8080
mDH-5AqvroDPSiJq
```