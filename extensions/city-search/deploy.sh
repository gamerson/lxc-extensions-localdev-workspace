#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

../../gradlew :extensions:city-search:clean

yarn install && yarn build-local

../../gradlew :extensions:city-search:buildClientExtension

cd dist

DEPLOY=../../../build/docker/client-extensions/

cp -f city-search.zip "${DEPLOY}city-search.zip"
