## Getting Started Using Kind
```
kind create cluster --config=kind-config.yaml --name=k8s
kubectl cluster-info --context kind-k8s
kind delete clusters k8s

helm repo add cilium https://helm.cilium.io/
helm repo update

docker pull quay.io/cilium/cilium:v1.12.4
kind load docker-image quay.io/cilium/cilium:v1.12.4

helm install cilium cilium/cilium --version 1.12.4  --namespace kube-system  --set image.pullPolicy=IfNotPresent --set ipam.mode=kubernetes

CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/master/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "arm64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/$CILIUM_CLI_VERSION/cilium-darwin-$CLI_ARCH.tar.gz{,.sha256sum}
shasum -a 256 -c cilium-darwin-$CLI_ARCH.tar.gz.sha256sum
sudo tar xzvfC cilium-darwin-$CLI_ARCH.tar.gz /usr/local/bin
rm cilium-darwin-$CLI_ARCH.tar.gz{,.sha256sum}

cilium status --wait
cilium connectivity test
## Enable Hubble in Cilium
cilium hubble enable
helm upgrade cilium cilium/cilium --version 1.12.4 \
   --namespace kube-system \
   --reuse-values \
   --set hubble.relay.enabled=true \
   --set hubble.ui.enabled=true

export HUBBLE_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/hubble/master/stable.txt)
HUBBLE_ARCH=amd64
if [ "$(uname -m)" = "arm64" ]; then HUBBLE_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/hubble/releases/download/$HUBBLE_VERSION/hubble-darwin-$HUBBLE_ARCH.tar.gz{,.sha256sum}
shasum -a 256 -c hubble-darwin-$HUBBLE_ARCH.tar.gz.sha256sum
sudo tar xzvfC hubble-darwin-$HUBBLE_ARCH.tar.gz /usr/local/bin
rm hubble-darwin-${HUBBLE_ARCH}.tar.gz{,.sha256sum}
cilium hubble port-forward&
hubble status


# Cluster Mesh

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

# https://www.middlewareinventory.com/blog/kubectl-cp-example/
##  copy a file from local to pod
```
kubectl cp /<path-to-your-file>/<file-name> <pod-name>:<fully-qualified-file-name> -c <container-name>

kubectl cp sonar-application-9.2.4.50792.jar sonarqube-sonarqube-0:/opt/sonarqube/lib/sonar-application-9.2.4.50792.jar -c sonarqube
kubectl cp sonarlint-license-plugin-9.2.4.50792-all.jar sonarqube-sonarqube-0:/opt/sonarqube/lib/sonarlint/sonarlint-license-plugin-9.2.4.50792-all.jar -c sonarqube

kubectl exec -it 
```
## copy a file from the pod to local
```
kubectl cp <pod-name>:<fully-qualified-file-name> /<path-to-your-file>/<file-name> -c <container-name>

```