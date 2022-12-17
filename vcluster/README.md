# https://piotrminkowski.com/2022/12/09/manage-multiple-kubernetes-clusters-with-argocd/

```
vcluster create vc1 --upgrade --connect=false \
  --distro k8s \
  -f values_1.yaml


```