#!/bin/sh

set -ex

export CGO_ENABLED=0
export BUILD_VERSION=${BUILD_VERSION:-v6.2.9}
LDFLAGS="-s -w -X github.com/fatedier/frp/pkg/util/version.version=${BUILD_VERSION}"

export GOARCH=amd64
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-server-${BUILD_VERSION}-linux-${GOARCH} ./cmd/frps

export GOARCH=arm64
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-server-${BUILD_VERSION}-linux-${GOARCH} ./cmd/frps
