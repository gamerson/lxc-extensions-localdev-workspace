#!/usr/bin/env bash

docker \
  run \
  --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /Users/greg/repos/gh/gamerson/lxc-localdev/:/repo \
  -v /Users/greg/repos/gh/gamerson/lxc-extensions-localdev-workspace/:/workspace \
  lxc-localdev \
  /repo/scripts/cluster-delete.sh