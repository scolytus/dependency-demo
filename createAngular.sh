#!/bin/bash

. configuration.sh
. functions.sh

inf "starting '${0}'"

# set -e
# set -x

which npm > /dev/null           || fatal "can't find 'npm'"
which ng > /dev/null            || fatal "can't find 'ng'"
which cyclonedx-bom > /dev/null || fatal "can't find 'cyclonedx-bom'"

DATE=$(date +%Y%m%d)
NAME="angular${DATE}"

inf "checking directories"

[[ -d "${NAME}" ]] && fatal "directory '${NAME}' already exists"
[[ -d "./boms" ]] || mkdir "./boms"

inf "creating new Angular project '${NAME}'"

yes '' | ng new "${NAME}"

pushd "${NAME}"

cyclonedx-bom    -o "../boms/${NAME}.bom"
cyclonedx-bom -d -o "../boms/${NAME}_deps.bom"

npm list > "../boms/${NAME}.npm_list.txt"

popd

inf "Creating project '${NAME}'"
createProject "${NAME}"

inf "Uploading SBOM for project '${NAME}'"
uploadBOM "boms/${NAME}_deps.bom" "$(cat "boms/${NAME}.uuid")"

