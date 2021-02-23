# upstream

```bash
git remote add upstream git@github.com:fatedier/frp.git

git fetch upstream

git merge v0.34.3
```

## debug

```bash
# server
docker run \
--rm \
-v /go/pkg/:/go/pkg \
-v $PWD/:/go/src/github.com/fatedier/frp \
-e PLUGIN_BINARY=awecloud-access-server \
-e PLUGIN_MAIN=cmd/frps \
-e CI_WORKSPACE=/go/src/github.com/fatedier/frp \
-w /go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/devops-go:1.15.6-buster

# client
docker run \
--rm \
-v /go/pkg/:/go/pkg \
-v $PWD/:/go/src/github.com/fatedier/frp \
-e PLUGIN_BINARY=awecloud-access-client \
-e PLUGIN_MAIN=cmd/frpc \
-e CI_WORKSPACE=/go/src/github.com/fatedier/frp \
-w /go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/devops-go:1.15.6-alpine

# client-amd64
docker run \
--rm \
-v /go/pkg/:/go/pkg \
-v $PWD/:/go/src/github.com/fatedier/frp \
-e PLUGIN_BINARY=awecloud-access-client \
-e PLUGIN_MAIN=cmd/frpc \
-e CI_WORKSPACE=/go/src/github.com/fatedier/frp \
-w /go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/devops-go:1.15.6-buster

# client-ppc64le
docker run \
--rm \
-v /go/pkg/:/go/pkg \
-v $PWD/:/go/src/github.com/fatedier/frp \
-e PLUGIN_BINARY=awecloud-access-client \
-e PLUGIN_MAIN=cmd/frpc \
-e CI_WORKSPACE=/go/src/github.com/fatedier/frp \
-e GOARCH=ppc64le \
-w /go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/devops-go:1.15.6-buster

# client-arm64
docker run \
--rm \
-v /go/pkg/:/go/pkg \
-v $PWD/:/go/src/github.com/fatedier/frp \
-e PLUGIN_BINARY=awecloud-access-client-v0.34.3-1-linux-arm64 \
-e PLUGIN_MAIN=cmd/frpc \
-e CI_WORKSPACE=/go/src/github.com/fatedier/frp \
-e GOARCH=arm64 \
-w /go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/devops-go:1.15.6-buster
```
