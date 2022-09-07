#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

../../gradlew :extensions:coupon-app:clean

yarn install && yarn build

../../gradlew :extensions:coupon-app:buildClientExtension

cd dist

DEPLOY=../../../build/docker/client-extensions

cp -f coupon-app.zip "${DEPLOY}/coupon-app.zip"