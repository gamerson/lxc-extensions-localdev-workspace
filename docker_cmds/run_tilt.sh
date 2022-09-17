#!/usr/bin/env bash

docker \
  run \
  --rm \
  --name lxc-localdev-runner \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /Users/greg/repos/gh/gamerson/lxc-localdev/:/repo \
  -v /Users/greg/repos/gh/gamerson/lxc-extensions-localdev-workspace/:/workspace \
  --expose 10350 \
  -p 10350:10350 \
  lxc-localdev \
  tilt \
  $@