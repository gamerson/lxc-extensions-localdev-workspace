#!/usr/bin/env bash

set -e

./gradlew :extensions:able-theme-css:createClientExtensionConfig 1>&2

ytt -f k8s/extension -f extensions/able-theme-css/build/able-theme-css.client-extension-config.json --data-value image=able-theme-css --data-value serviceId=able-theme-css