#!/usr/bin/env bash

docker \
  run \
  --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /Users/greg/repos/gh/gamerson/lxc-localdev/:/repo \
  -v /Users/greg/repos/gh/gamerson/lxc-extensions-localdev-workspace/:/workspace \
  -v /Users/greg/.gradle/:/root/.gradle/ \
  -v /Users/greg/.liferay/:/root/.liferay/ \
  --expose 10350 \
  -p 10350:10350 \
  -e DO_NOT_TRACK="1" \
  lxc-localdev \
  tilt \
  $@