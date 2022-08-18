#!/usr/bin/env bash

set -e

cd extensions/coupondfn

cp ../../k8s/tls/ca.crt .

docker build -t $EXPECTED_REF .