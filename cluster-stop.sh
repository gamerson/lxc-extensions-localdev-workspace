#!/usr/bin/env bash

k3d cluster delete \
  --config ./k8s/k3d/config.yaml

docker network rm k3d-lxc-localdev