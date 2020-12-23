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
-v $PWD/:/go/src/github.com/fatedier/frp \
-e PLUGIN_BINARY=awecloud-access-server \
-e PLUGIN_MAIN=cmd/frps \
-e CI_WORKSPACE=/go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/devops-go:1.13.10-stretch

# client
docker run \
--rm \
-v $PWD/:/go/src/github.com/fatedier/frp \
-e PLUGIN_BINARY=awecloud-access-client \
-e PLUGIN_MAIN=cmd/frpc \
-e CI_WORKSPACE=/go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/devops-go:1.13.10-alpine3.11
```
