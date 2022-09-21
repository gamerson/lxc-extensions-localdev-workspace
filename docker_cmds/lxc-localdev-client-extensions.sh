#!/usr/bin/env bash

docker \
  run \
  --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /Users/greg/repos/gh/gamerson/lxc-localdev/:/repo \
  -v /Users/greg/repos/gh/gamerson/lxc-client-extensions-demo/client-extensions:/workspace/client-extensions \
  -v /Users/greg/.liferay/:/root/.liferay/ \
  lxc-localdev \
  $@