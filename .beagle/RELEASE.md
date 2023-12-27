# release

awecloud-access 更新的版本说明

## v6.2.5 - v0.6.2-beagle.5

升级至v0.53.2

```bash
git merge v0.53.2
```

## v6.2.4 - v0.6.2-beagle.4

去掉 frp 日志中的frps与frpc字符串
升级至v0.52.3

```bash
git merge v0.52.3
```

## v6.2.3 - v0.6.2-beagle.3

将 frp 升级至 v0.51.3

```bash
git merge v0.51.3
```

## v6.2.0 - v0.6.2-beagle.0

将 frp 升级至 v0.51.0

```bash
git merge v0.51.0
```

## v6.1.0 - v0.6.1-beagle.0

将 frp 升级至 v0.49.0

```bash
git merge v0.49.0
```

### 对 Client 进行身份验证

frps 服务器配置，对身份验证的超时与检核方式进行控制

```ini
[common]
# 每次客户端和服务端进行心跳链接时，进行身份验证. 默认值为 false.
authenticate_heartbeats = false

# 每次客户端新建端口和服务通道时，进行身份验证. 默认值为 false.
authenticate_new_work_conns = false
```

1. Token 身份验证 【默认配置】

使用静态 Token 进行身份验证

frps 服务器配置

```ini
[common]
authentication_method = token
token = changeit
```

frpc 客户端配置

```ini
[common]
authentication_method = token
token = changeit
```

2. OIDC 身份验证

使用 OpenID Connect 技术进行身份验证

frps 服务器配置

```ini
# frps.ini
[common]
authentication_method = oidc
oidc_issuer = https://example-oidc-issuer.com/
oidc_audience = https://oidc-audience.com/.default
```

frpc 客户端配置

```ini
# frpc.ini
[common]
authentication_method = oidc
oidc_client_id = 98692467-37de-409a-9fac-bb2585826f18 # Replace with OIDC client ID
oidc_client_secret = oidc_secret
oidc_audience = https://oidc-audience.com/.default
oidc_token_endpoint_url = https://example-oidc-endpoint.com/oauth2/v2.0/token
```

### 对隧道进行加密和压缩

默认此功能时关闭的，若有需要可以自行打开

```ini
# frpc.ini
[ssh]
type = tcp
local_port = 22
remote_port = 6000
use_encryption = true
use_compression = true
```

## v6.0.1 - v0.6.0-beagle.1

将 frp 升级至 v0.44.0

```bash
git merge v0.44.0
```
