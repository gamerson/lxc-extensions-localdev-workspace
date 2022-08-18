#!/bin/bash

JOB_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "JOB DIR = $JOB_DIR"

echo "================================"
echo "========= DATA FILES ==========="
echo "================================"

find . -type f -name *.json -exec echo "{} contains:" \; -exec cat {} \; -exec echo "" \;

tree /etc/liferay/lxc/ext-init-metadata

tree /etc/liferay/lxc/dxp-metadata

DXP_HOST=$(cat /etc/liferay/lxc/dxp-metadata/com.liferay.lxc.dxp.mainDomain)
OAUTH2_CLIENTID=$(cat /etc/liferay/lxc/ext-init-metadata/coupondfn.oauth2.headless.server.client.id)
OAUTH2_SECRET=$(cat /etc/liferay/lxc/ext-init-metadata/coupondfn.oauth2.headless.server.client.secret)

echo "DXP_HOST: ${DXP_HOST}"
echo "OAUTH2_CLIENTID: ${OAUTH2_CLIENTID}"
echo "OAUTH2_SECRET: ${OAUTH2_SECRET}"

ACCESS_TOKEN=$(\
	curl \
		-s \
		-X POST \
		"https://${DXP_HOST}/o/oauth2/token" \
		-H 'Content-type: application/x-www-form-urlencoded' \
		-d "grant_type=client_credentials&client_id=${OAUTH2_CLIENTID}&client_secret=${OAUTH2_SECRET}" \
		--cacert ../ca.crt \
		| jq -r .access_token)

echo "ACCESS_TOKEN: ${ACCESS_TOKEN}"

RESULT=$(
	curl \
		-v \
		-s \
		-X 'POST' \
		"https://${DXP_HOST}/o/object-admin/v1.0/object-definitions/batch" \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-H "Authorization: Bearer ${ACCESS_TOKEN}" \
		-d @export.json \
		--cacert ../ca.crt \
		| jq -r '.')

echo "BATCH: ${RESULT}"

BATCH_EXTERNAL_REFERENCE_CODE=$(jq -r '.externalReferenceCode' <<< "$RESULT")

until [ \
	"$(
		curl \
			-v \
			-s \
			-X 'GET' \
			"https://${DXP_HOST}/o/headless-batch-engine/v1.0/import-task/by-external-reference-code/${BATCH_EXTERNAL_REFERENCE_CODE}" \
			-H 'accept: application/json' \
			-H "Authorization: Bearer ${ACCESS_TOKEN}" \
			--cacert ../ca.crt \
			| jq -r '.executeStatus')" \
	!= "COMPLETED" ]
do
  sleep 1
done

RESULT=$(
	curl \
		-v \
		-s \
		"https://${DXP_HOST}/o/object-admin/v1.0/object-definitions" \
		-H 'accept: application/json' \
		-H 'Content-Type: application/json' \
		-H "Authorization: Bearer ${ACCESS_TOKEN}" \
		--cacert ../ca.crt \
		| jq -r '.')

echo "GET: ${RESULT}"

PUBLISH=$(jq -r '[.items[].id] | join(" ")' <<< "$RESULT")

echo "PUBLISH: ${PUBLISH}"

for i in $PUBLISH; do
	curl \
		-s \
		-X 'POST' \
		"https://${DXP_HOST}/o/object-admin/v1.0/object-definitions/${i}/publish" \
		-H 'accept: application/json' \
		-H "Authorization: Bearer ${ACCESS_TOKEN}" \
		--cacert ../ca.crt \
		| jq -r .
done
