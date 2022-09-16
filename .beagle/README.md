# upstream

github.com/fatedier/frp

```bash
git remote add upstream git@github.com:fatedier/frp.git

git fetch upstream

git merge v0.44.0
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
-w /go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/devops-go-arch:1.17-alpine

# start server
$PWD/dist/awecloud-access-server-linux-amd64 -c $PWD/.vscode/frps.ini

# client
docker run \
--rm \
-v $PWD/:/go/src/github.com/fatedier/frp \
-e PLUGIN_BINARY=awecloud-access-client \
-e PLUGIN_MAIN=cmd/frpc \
-e CI_WORKSPACE=/go/src/github.com/fatedier/frp \
-w /go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/devops-go-arch:1.17-alpine

# start client
$PWD/dist/awecloud-access-client-linux-amd64 -c $PWD/.vscode/frpc.ini

# windows
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 \
go build -o $PWD/dist/awecloud-access-client.exe \
cmd/frpc/main.go
```

## cache

```bash
# 构建缓存-->Golang
docker run -it --rm \
-v $GOPATH/pkg/:/go/pkg \
-v $PWD/:/go/src/github.com/fatedier/frp \
-w /go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.17-alpine \
rm -rf vendor && go mod tidy && go mod vendor

# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="cloud" \
  -e DRONE_REPO_NAME="awecloud-access" \
  -e DRONE_COMMIT_BRANCH="dev" \
  -e PLUGIN_MOUNT="./vendor" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="cloud" \
  -e DRONE_REPO_NAME="awecloud-access" \
  -e DRONE_COMMIT_BRANCH="dev" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```

## mengkzhaoyun/awecloud-access

```bash
git remote add mkstream git@github.com:mengkzhaoyun/awecloud-access.git

git push mkstream -f

# 新建一个Tag
git tag v0.6.0-beagle

# 推送一个Tag ，-f 强制更新
git push -f mkstream v0.6.0-beagle

# 删除本地Tag
git tag -d v0.6.0-beagle
```

```yaml
require (
github.com/fatedier/frp v0.43.0
)

replace github.com/fatedier/frp => github.com/mengkzhaoyun/awecloud-access v0.6.0-beagle
```
