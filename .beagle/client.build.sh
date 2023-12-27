#!/bin/sh

set -ex

export CGO_ENABLED=0
LDFLAGS="-s -w"

export GOARCH=amd64
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-client-linux-${GOARCH} ./cmd/frpc

export GOARCH=arm64
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-client-linux-${GOARCH} ./cmd/frpc

export GOARCH=ppc64le
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-client-linux-${GOARCH} ./cmd/frpc

export GOARCH=mips64le
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-client-linux-${GOARCH} ./cmd/frpc

export GOARCH=loong64
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-client-linux-${GOARCH} ./cmd/frpc