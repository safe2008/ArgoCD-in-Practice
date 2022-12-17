#!/bin/bash

set -eu -o pipefail

echo "+ setup argocd project"
kubectl apply -f 0_default_proj.yaml

echo "+ setup prometheus monitoring"
cd 1_prometheus
./setup.sh
cd ..

echo "+ setup grafana"
kubectl apply -n argocd -f 2_grafana_app.yaml

echo "+ setup falco"
kubectl apply -n argocd -f 3_falco_app.yaml

echo "+ setup falco sidekick service monitor"
kubectl apply -n monitoring -f 4_falcosidekick_servicemonitor.yaml
