#!/bin/sh

set -ex

export CGO_ENABLED=0
LDFLAGS="-s -w"

export GOARCH=amd64
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-server-linux-${GOARCH} ./cmd/frps

export GOARCH=arm64
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-server-linux-${GOARCH} ./cmd/frps

export GOARCH=ppc64le
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-server-linux-${GOARCH} ./cmd/frps

export GOARCH=mips64le
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-server-linux-${GOARCH} ./cmd/frps

export GOARCH=loong64
go build -trimpath -ldflags "${LDFLAGS}" -o ./release/awecloud-access-server-linux-${GOARCH} ./cmd/frps