#!/usr/bin/env bash

set -e

ytt \
  -f ./k8s/extension_job \
  -f extensions/coupondata/coupondata.client-extension-config.json \
  --data-value cpu=200m \
  --data-value image=coupondata \
  --data-value memory=300Mi \
  --data-value serviceId=coupondata \
  --data-value-yaml initMetadata=true