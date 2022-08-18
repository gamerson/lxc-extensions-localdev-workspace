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
		-d @com.liferay.object.admin.rest.dto.v1_0.ObjectDefinition/export.json \
		--cacert ../ca.crt \
		| jq -r '.')

echo "RESULT: ${RESULT}"

# PUBLISH=$(jq -r '. | if has("actions") then .actions.publish.href else false end' <<< "$RESULT")

# echo "PUBLISH: ${PUBLISH}"

# if [ "$PUBLISH" != "false" ]; then
# 	curl \
# 		-s \
# 		-X 'POST' \
# 		"${PUBLISH}" \
# 		-H 'accept: application/json' \
# 		-H "Authorization: Bearer ${ACCESS_TOKEN}" \
# 		--cacert ../ca.crt \
# 		| jq -r .
# fi
