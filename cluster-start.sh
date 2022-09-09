#!/usr/bin/env bash

set -e

HOST_ALIASES="['dxp', 'vi']"

ytt -f ./k8s/k3d --data-value-yaml "hostAliases=$HOST_ALIASES" > .cluster_config.yaml

k3d cluster create \
  --config .cluster_config.yaml \
  --registry-create registry.localdev.me:5000 \
  --wait

kubectl config use-context k3d-lxc-localdev
kubectl config set-context --current --namespace=default

SA_STATUS="0"

until [ "${SA_STATUS}" == "1" ]; do
	SA_STATUS=$(kubectl get sa -o json | jq -r '.items | length')

	echo "SA_STATUS: ${SA_STATUS}"
done

kubectl create -f ./k8s/k3d/token.yaml
kubectl create -f ./k8s/k3d/rbac.yaml

kubectl create secret generic localdev-tls-secret \
  --from-file=tls.crt=./k8s/tls/localdev.me.crt \
  --from-file=tls.key=./k8s/tls/localdev.me.key  \
  --namespace default

DOCKER_HOST_ADDRESS=""

until [ "${DOCKER_HOST_ADDRESS}" != "" ]; do
	DOCKER_HOST_ADDRESS=$(kubectl get cm coredns --namespace kube-system -o jsonpath='{.data.NodeHosts}' | grep host.k3d.internal | awk '{print $1}')

	echo "DOCKER_HOST_ADDRESS: ${DOCKER_HOST_ADDRESS}"
done

ytt \
	-f k8s/dxp_endpoint \
	--data-value "dockerHostAddress=${DOCKER_HOST_ADDRESS}" \
	--data-value "virtualInstanceId=dxp.localdev.me"

echo "Cluster is ready.  Run 'tilt up' to deploy DXP and extensions"