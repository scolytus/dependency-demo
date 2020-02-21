#!/bin/bash

. functions.sh

inf "starting '${0}'"

set -e
set -x

for i in ./dependency-demo-spring-boot-*; do
  pushd "${i}"

  NAME="$(basename ${i})"

  inf "creating SBOM for '${NAME}'"

  ./mvnw verify

  cp target/bom.xml "../boms/${NAME}.bom.xml"

  popd
done

