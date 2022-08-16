#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

if [[ ! -z "${EXPECTED_REF}" ]]; then
  IMAGE=${EXPECTED_REF}
fi

ID=citysearch

echo "[run_local] Build the $ID PoC"

../../gradlew :extensions:citysearch:clean

yarn install && yarn build-local

for cssFile in $(jq '.entrypoints[] | select(endswith(".css"))' build/asset-manifest.json)
do
  cssFile=$(echo $cssFile | sed 's/^"static\//"/')
  cssFiles+="$cssFile,"
done

for jsFile in $(jq '.entrypoints[] | select(endswith(".js"))' build/asset-manifest.json)
do
  jsFile=$(echo $jsFile | sed 's/^"static\//"/')
  jsFiles+="$jsFile,"
done

cssFiles=$(echo $cssFiles | sed 's/,*$//')
jsFiles=$(echo $jsFiles | sed 's/,*$//')

yq -i ".citysearch.cssURLs = [$cssFiles]" client-extension.yaml
yq -i ".citysearch.urls = [$jsFiles]" client-extension.yaml

../../gradlew :extensions:citysearch:buildClientExtension

cd dist

unzip -o citysearch.zip

docker build -t $IMAGE .