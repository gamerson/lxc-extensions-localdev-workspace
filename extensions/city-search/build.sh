#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

if [[ ! -z "${EXPECTED_REF}" ]]; then
  IMAGE=${EXPECTED_REF}
fi

../../gradlew :extensions:city-search:clean

yarn install && yarn build-local

../../gradlew :extensions:city-search:buildClientExtension

cd dist

unzip -o city-search.zip

docker build -t $IMAGE .

tilt trigger "(Tiltfile)"