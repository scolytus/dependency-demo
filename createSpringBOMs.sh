#!/bin/bash

. ./functions.sh

inf "starting '${0}'"

set -e
set -x

TIMESTAMP=$(date +%Y%m%d-%H%M%S)

for i in ./dependency-demo-spring-boot-*; do
  pushd "${i}"

  NAME="$(basename ${i})"

  inf "creating SBOM for '${NAME}'"

  ./mvnw verify

  cp target/bom.xml "../boms/${NAME}.bom.xml"

  cp target/site/*.spdx "../boms/${NAME}.spdx" || true

  cp target/dependency-check-report.html "../reports/dependency-check-report.${NAME}.${TIMESTAMP}.html" || true

  popd
done

