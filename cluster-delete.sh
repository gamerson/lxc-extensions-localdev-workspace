#!/usr/bin/env bash

k3d cluster delete lxc-localdev

docker network rm k3d-lxc-localdev