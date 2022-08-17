#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

if [[ ! -z "${EXPECTED_REF}" ]]; then
  IMAGE=${EXPECTED_REF}
fi

../../gradlew :extensions:citysearch:clean

yarn install && yarn build-local

../../gradlew :extensions:citysearch:buildClientExtension

ytt -f ../../k8s/extension -f ./build/citysearch.client-extension-config.json --data-value image=citysearch --data-value serviceId=citysearch > .citysearch.yaml

cd dist

unzip -o citysearch.zip

docker build -t $IMAGE .