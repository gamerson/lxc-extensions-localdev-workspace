#!/usr/bin/env bash

set -e

cd extensions/citysearch

../../gradlew clean > /dev/null 2> /dev/null

yarn install > /dev/null 2> /dev/null

yarn build-local > /dev/null 2> /dev/null

../../gradlew :extensions:citysearch:createClientExtensionConfig > /dev/null 2> /dev/null

ytt -f ../../k8s/extension -f ./build/citysearch.client-extension-config.json --data-value image=citysearch --data-value serviceId=citysearch > .citysearch.yaml

cat .citysearch.yaml