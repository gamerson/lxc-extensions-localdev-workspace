#!/usr/bin/env bash

set -e

./gradlew :extensions:citysearch:clean :extensions:citysearch:createClientExtensionConfig > /dev/null 2> /dev/null

ytt -f k8s/extension -f extensions/citysearch/build/citysearch.client-extension-config.json --data-value image=citysearch --data-value serviceId=citysearch