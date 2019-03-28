#!/bin/bash

exec 2>&1

function main() {
  build_package "consul"
  build_package "vault"
}

function build_package() {
  hab studio build $1/
  mv results/last_build.env results/${1}_last_build.env
}

main $@
