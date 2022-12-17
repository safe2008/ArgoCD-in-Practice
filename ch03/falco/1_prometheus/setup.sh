#!/bin/bash

set -eu -o pipefail
set -x

kubectl apply -f 0_namespaces.yaml
for m in $(find ./1_crds -name '*.yaml'); do kubectl replace --force -f $m; done
sleep 30
for m in $(find ./2_manifests -name '*.yaml'); do kubectl replace --force -f $m; done
