# upstream

```bash
git remote add upstream git@github.com:fatedier/frp.git

git fetch upstream

git merge v0.37.1
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
registry.cn-qingdao.aliyuncs.com/wod/devops-go-arch:1.17.3-alpine

# client
docker run \
--rm \
-v /go/pkg/:/go/pkg \
-v $PWD/:/go/src/github.com/fatedier/frp \
-e PLUGIN_BINARY=awecloud-access-client \
-e PLUGIN_MAIN=cmd/frpc \
-e CI_WORKSPACE=/go/src/github.com/fatedier/frp \
-w /go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/devops-go-arch:1.17.3-alpine

# windows
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 \
go build -o $PWD/dist/awecloud-access-client.exe \
cmd/frpc/main.go
```
