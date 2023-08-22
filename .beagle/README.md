# upstream

<https://github.com/fatedier/frp>

```bash
git remote add upstream git@github.com:fatedier/frp.git

git fetch upstream

git merge v0.51.0
```

## debug

```bash
# server
docker run \
--rm \
-v $PWD/:/go/src/github.com/fatedier/frp \
-e CI_WORKSPACE=/go/src/github.com/fatedier/frp \
-w /go/src/github.com/fatedier/frp \
-e PLUGIN_MAIN=cmd/frps \
-e PLUGIN_BINARY=awecloud-access-server \
-e PLUGIN_VERSION=v6.2.1 \
registry.cn-qingdao.aliyuncs.com/wod/devops-go-arch:1.20-alpine

# start server
$PWD/dist/awecloud-access-server-v6.2.1-linux-amd64 -c $PWD/.vscode/frps.ini

# client
docker run \
--rm \
-v $PWD/:/go/src/github.com/fatedier/frp \
-e CI_WORKSPACE=/go/src/github.com/fatedier/frp \
-w /go/src/github.com/fatedier/frp \
-e PLUGIN_MAIN=cmd/frpc \
-e PLUGIN_BINARY=awecloud-access-client \
-e PLUGIN_VERSION=v6.2.1 \
registry.cn-qingdao.aliyuncs.com/wod/devops-go-arch:1.20-alpine

# start client
$PWD/dist/awecloud-access-client-v6.2.1-linux-amd64 -c $PWD/.vscode/frpc.ini

# windows
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 \
go build -o $PWD/dist/awecloud-access-client-v6.2.1.exe \
cmd/frpc/main.go
```

## cache

```bash
# 构建缓存-->Golang
docker run -it --rm \
-v $PWD/:/go/src/github.com/fatedier/frp \
-w /go/src/github.com/fatedier/frp \
registry.cn-qingdao.aliyuncs.com/wod/golang:1.20-alpine \
rm -rf vendor && go mod tidy && go mod vendor

# 构建缓存-->推送缓存至服务器
docker run --rm \
  -e PLUGIN_REBUILD=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="awecloud-access" \
  -e PLUGIN_MOUNT="./.git,./vendor" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0

# 读取缓存-->将缓存从服务器拉取到本地
docker run --rm \
  -e PLUGIN_RESTORE=true \
  -e PLUGIN_ENDPOINT=$PLUGIN_ENDPOINT \
  -e PLUGIN_ACCESS_KEY=$PLUGIN_ACCESS_KEY \
  -e PLUGIN_SECRET_KEY=$PLUGIN_SECRET_KEY \
  -e DRONE_REPO_OWNER="open-beagle" \
  -e DRONE_REPO_NAME="awecloud-access" \
  -v $(pwd):$(pwd) \
  -w $(pwd) \
  registry.cn-qingdao.aliyuncs.com/wod/devops-s3-cache:1.0
```

## service

/etc/kubernetes/services/k8s-client/README.md

```bash
# install bin
mkdir -p /opt/bin
ln -s /etc/kubernetes/services/k8s-client/awecloud-access-client-v6.2.1-linux-amd64 /opt/bin/awecloud-access-client
chmod +x /etc/kubernetes/services/k8s-client/awecloud-access-client-v6.2.1-linux-amd64

# install service
systemctl enable k8s-client
systemctl start k8s-client
```

/etc/kubernetes/services/k8s-client/config.ini

```ini
[common]
user = <USER>

server_addr = <HOST>
server_port = 443
server_path = <path>
protocol = wss
token = changeit
tls_enable = true

[ssh]
type = tcp
local_ip = 127.0.0.1
local_port = 22
remote_port = <PORT>

[https]
type=https
custom_domains=<domain>
local_port=443
local_ip=127.0.0.1
```

/etc/systemd/system/k8s-client.service

```ini
[Unit]
Description=k8s-client
Wants=network.target

[Service]
Restart=always
RestartSec=10

ExecStart=/opt/bin/awecloud-access-client \
-c /etc/kubernetes/services/k8s-client/config.ini

[Install]
WantedBy=multi-user.target
```

## tags

```bash
# 新建一个Tag
git tag v0.6.2-beagle.0

# 推送一个Tag ，-f 强制更新
git push -f origin v0.6.2-beagle.0

# 删除本地Tag
git tag -d v0.6.2-beagle.0
```
