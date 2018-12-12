#!/bin/bash

exec 2>&1

. results/consul_last_build.env
export CONSUL_PACKAGE=./results/$pkg_artifact

. results/vault_last_build.env
export VAULT_PACKAGE=./results/$pkg_artifact

kitchen converge
