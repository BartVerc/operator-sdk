#!/usr/bin/env bash

set -eux

source hack/lib/test_lib.sh
source hack/lib/image_lib.sh

ROOTDIR="$(pwd)"
TMPDIR="$(mktemp -d)"
trap_add 'rm -rf $TMPDIR' EXIT

# build scorecard test image
WD="$(dirname "$(pwd)")"
GOOS=linux CGO_ENABLED=0 \
  go build \
  -gcflags "all=-trimpath=${WD}" \
  -asmflags "all=-trimpath=${WD}" \
  -o $TMPDIR/custom-scorecard-tests \
  images/custom-scorecard-tests/cmd/test/main.go

# Build base image
pushd $TMPDIR
cp -r $ROOTDIR/images/custom-scorecard-tests/bin .
docker build -f $ROOTDIR/images/custom-scorecard-tests/Dockerfile -t $1 .
popd
