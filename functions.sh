
fatal() {
  output "[FATAL] ${1}"
  exit -1
}

inf() {
  output "[INFO ] ${1}"
}

output() {
  echo "[$(date +%Y%m%d-%H%M%S)] ${1}"
}

checkJQ() {
  which jq > /dev/null || fatal "can't find 'jq'"
}

createProject() {
  checkJQ

  RESPONSE=$(curl -v -X "PUT" "${DT_HOST}/api/v1/project" \
     -H 'Content-Type: application/json' \
     -H "X-API-Key: ${DT_KEY}" \
     -d "{\"name\":\"${1}\"}")

  UUID=$(echo "${RESPONSE}" | jq -r '.uuid' 2> /dev/null || true)

  [[ -z "${UUID}" ]] && fatal "could not create '${1}'"

  echo "${UUID}" > "boms/${1}.uuid"
  echo "${UUID}"
}

uploadBOM() {
  FILE=$(mktemp)
  UUID="${2}"
  cat > "${FILE}" <<__HERE__
{
  "project": "${UUID}",
  "bom": "$(cat ${1} |base64 -w 0 -)"
}
__HERE__

  curl -X "PUT" "${DT_HOST}/api/v1/bom" \
       -H 'Content-Type: application/json' \
       -H "X-API-Key: ${DT_KEY}" \
       -d @"${FILE}"
}

