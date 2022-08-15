#!/usr/bin/env bash

set -e

HOST_ALIASES="['dxp','able-theme-css','couponpdf','uscities']"

ytt -f ./k8s/k3d --data-value-yaml "hostAliases=$HOST_ALIASES" > .cluster_config.yaml

k3d cluster create \
  --config .cluster_config.yaml \
  --registry-create registry.localdev.me:5000 \
  --wait

kubectl config use-context k3d-lxc-localdev
kubectl config set-context --current --namespace=default

kubectl create secret generic localdev-tls-secret \
  --from-file=tls.crt=./k8s/tls/localdev.me.crt \
  --from-file=tls.key=./k8s/tls/localdev.me.key  \
  --namespace default

kubectl create \
  -f ./k8s/k3d/rbac.yaml

echo "Cluster is ready.  Run 'tilt up' to deploy DXP and extensions"