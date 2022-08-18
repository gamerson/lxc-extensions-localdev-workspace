#!/usr/bin/env bash

set -e

ytt \
  -f ./k8s/extension_job \
  -f extensions/coupondfn/coupondfn.client-extension-config.json \
  --data-value cpu=200m \
  --data-value image=coupondfn \
  --data-value memory=300Mi \
  --data-value serviceId=coupondfn \
  --data-value-yaml initMetadata=true