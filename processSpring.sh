#!/bin/bash

. ./functions.sh

inf "starting '${0}'"

set -e
# set -x

DC="$(which dependency-check)"

[[ -z $DC ]] && fatal "dependency-check not found"

OUTPUT="$(mktemp -d)"
TIMESTAMP="$(getTimestamp)"

inf "Output directory: ${OUTPUT}"
inf "Timestamp:        ${TIMESTAMP}"

for i in ./dependency-demo-spring-boot-*; do
    pushd "${i}" > /dev/null

    NAME="$(basename ${i})"

    CUR_OUT="${OUTPUT}/${NAME}/clean"
    mkdir -p "${CUR_OUT}"

    inf "processing '${NAME}'"

    inf "mvn clean (${NAME})"
    ./mvnw clean  > /dev/null

    inf "run dependency check for cleaned directory (${NAME})"
    $DC -s . -o "${CUR_OUT}" -f ALL --prettyPrint -l "${CUR_OUT}/dc.log" > /dev/null
    cp "${CUR_OUT}/dependency-check-report.html" "../reports/dependency-check-report.${NAME}.${TIMESTAMP}.cli.clean.html"

    inf "mvn package verify (${NAME})"
    ./mvnw package verify > /dev/null

    CUR_OUT="${OUTPUT}/${NAME}/packaged"
    mkdir -p "${CUR_OUT}"

    inf "run dependency check for built directory (${NAME})"
    $DC -s . -o "${CUR_OUT}" -f ALL --prettyPrint -l "${CUR_OUT}/dc.log" > /dev/null
    cp "${CUR_OUT}/dependency-check-report.html" "../reports/dependency-check-report.${NAME}.${TIMESTAMP}.cli.packaged.html"

    inf "copy maven generated SBOM and report"
    cp target/bom.xml "../boms/${NAME}.bom.xml"
    cp target/site/*.spdx.rdf.xml "../boms/${NAME}.spdx" || true
    cp target/dependency-check-report.html "../reports/dependency-check-report.${NAME}.${TIMESTAMP}.html" || true

    popd  > /dev/null
done
