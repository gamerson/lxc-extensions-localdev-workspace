#!/usr/bin/env bash

set -e

cd extensions/city-search

if [ !-f "build/asset-manifest.json" ]; then
  yarn install 1>&2
  yarn build-local 1>&2
fi

../../gradlew :extensions:city-search:createClientExtensionConfig 1>&2

ytt -f ../../k8s/extension -f ./build/city-search.client-extension-config.json --data-value image="city-search" --data-value serviceId="city-search"