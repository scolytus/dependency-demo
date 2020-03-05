#!/bin/bash

# set -e
# set -x

SUDO=""
if [ "$EUID" -ne 0 ]; then
  SUDO="sudo --"
fi

pushd "$(mktemp -d)" &> /dev/null

$SUDO /bin/bash -c "yes '' | npm install -g @angular/cli &> /dev/null"

popd &> /dev/null

if [ "$EUID" -ne 0 ]; then
  sudo -k
fi

