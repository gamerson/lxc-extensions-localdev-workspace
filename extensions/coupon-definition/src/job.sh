#!/bin/bash

set -e

JOB_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "########################"
echo "JOB DIR = $JOB_DIR"

echo "########################"
echo "Mounted Config:"
find /etc/liferay/lxc/ext-init-metadata -type l -not -ipath "*/..data" -print -exec sed 's/^/    /' {} \; -exec echo "" \;
find /etc/liferay/lxc/dxp-metadata -type l -not -ipath "*/..data" -print -exec sed 's/^/    /' {} \; -exec echo "" \;

echo "########################"
DXP_HOST=$(cat /etc/liferay/lxc/dxp-metadata/com.liferay.lxc.dxp.mainDomain)
OAUTH2_CLIENTID=$(cat /etc/liferay/lxc/ext-init-metadata/coupon-definition.oauth2.headless.server.client.id)
OAUTH2_SECRET=$(cat /etc/liferay/lxc/ext-init-metadata/coupon-definition.oauth2.headless.server.client.secret)

echo "DXP_HOST: ${DXP_HOST}"
echo "OAUTH2_CLIENTID: ${OAUTH2_CLIENTID}"
echo "OAUTH2_SECRET: ${OAUTH2_SECRET}"

echo "########################"
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

process_batch() {
	echo "########################"
	echo "######### BATCH ${1}"

	local BATCH_ITEMS=$(jq -r '.items' ${1})

	ITEM_IDS=$(jq -r '[.[] | .id] | join(" ")' <<< $BATCH_ITEMS)

	# TODO: The URL '.actions.batch.href' should actually be available on any
	# resources that support batch and we should be able to fetch it without
	# manipulation aside from stripping the protocol and domain.
	local BASE_HREF=$(jq -r '.actions.create.href' ${1})
	BASE_HREF="/${BASE_HREF#*://*/}"
	echo "BASE_HREF=${BASE_HREF}"

	local RESULT=$(\
		curl \
			-s \
			-v \
			-X 'POST' \
			"https://${DXP_HOST}${BASE_HREF}/batch" \
			-H 'accept: application/json' \
			-H 'Content-Type: application/json' \
			-H "Authorization: Bearer ${ACCESS_TOKEN}" \
			-d "${BATCH_ITEMS}" \
			--cacert ../ca.crt \
			| jq -r '.')

	if [ "${RESULT}x" == "x" ]; then
		echo "An error occured"
		exit 1
	fi

	echo "RESULT=${RESULT}"

	local BATCH_EXTERNAL_REFERENCE_CODE=$(jq -r '.externalReferenceCode' <<< "$RESULT")

	local BATCH_STATUS="INITIAL"

	until [ "${BATCH_STATUS}" == "COMPLETED" ] || [ "${BATCH_STATUS}" == "FAILED" ] || [ "${BATCH_STATUS}" == "NOT_FOUND" ]; do
		RESULT=$(\
			curl \
				-s \
				-X 'GET' \
				"https://${DXP_HOST}/o/headless-batch-engine/v1.0/import-task/by-external-reference-code/${BATCH_EXTERNAL_REFERENCE_CODE}" \
				-H 'accept: application/json' \
				-H "Authorization: Bearer ${ACCESS_TOKEN}" \
				--cacert ../ca.crt \
				| jq -r '.')

		BATCH_STATUS=$(jq -r '.executeStatus//.status' <<< "$RESULT")

		echo "BATCH STATUS: ${BATCH_STATUS}"
	done

	if [ "${BATCH_STATUS}" == "COMPLETED" ] && [ "$BASE_HREF" == "/o/object-admin/v1.0/object-definitions" ]; then
		RESULT=$(\
			curl \
				-s \
				"https://${DXP_HOST}${BASE_HREF}" \
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
				"https://${DXP_HOST}$BASE_HREF/${i}/publish" \
				-H 'accept: application/json' \
				-H "Authorization: Bearer ${ACCESS_TOKEN}" \
				--cacert ../ca.crt \
				| jq -r .
			echo "PUBLISHED: ${i}"
		done
	fi
}

for i in $(find . -type f -name *.data.batch-engine.json); do
	process_batch $i
done
