#!/bin/bash

. ./configuration.sh
. ./functions.sh

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

inf "updating ng command"

./updateNgCli.sh

inf "creating new Angular project '${NAME}'"

CURRENT_LOG="$(mktemp -d)/${NAME}.log"

yes '' | ng new "${NAME}" &> "${CURRENT_LOG}"

inf "npm log can be found: ${CURRENT_LOG}"

[[ -d "${NAME}" ]] || fatal "Something went wrong - directory not created"

pushd "${NAME}" &> /dev/null

inf "creating SBOMs"

cyclonedx-bom    -o "../boms/${NAME}.bom.xml"
cyclonedx-bom -d -o "../boms/${NAME}_deps.bom.xml"

inf "creating NPM list"

npm list > "../boms/${NAME}.npm_list.txt"

popd &> /dev/null

inf "Creating DT project '${NAME}'"
createProject "${NAME}"

inf "Uploading SBOM for project '${NAME}' to DT"
uploadBOM "boms/${NAME}_deps.bom.xml" "$(cat "boms/${NAME}.uuid")"

inf "DONE"

