#!/bin/bash

# HTTPS服务器
HTTP_SERVER="${HTTP_SERVER:-https://cache.wodcloud.com}"
# 平台架构
TARGET_ARCH="${TARGET_ARCH:-amd64}"

# ACS版本
ACC_VERSION="${ACC_VERSION:-v6.2.5}"

LOCAL_KERNEL=$(uname -r | head -c 3)
LOCAL_ARCH=$(uname -m)

if [ "$LOCAL_ARCH" = "x86_64" ]; then
  TARGET_ARCH="amd64"
elif [ "$(echo $LOCAL_ARCH | head -c 5)" = "armv8" ]; then
  TARGET_ARCH="arm64"
elif [ "$LOCAL_ARCH" = "aarch64" ]; then
  TARGET_ARCH="arm64"
elif [ "$(echo $LOCAL_ARCH | head -c 5)" = "ppc64" ]; then
  TARGET_ARCH="ppc64le"
elif [ "$(echo $LOCAL_ARCH | head -c 6)" = "mips64" ]; then
  TARGET_ARCH="mips64le"
elif [ "$(echo $LOCAL_ARCH | head -c 6)" = "loong" ]; then
  TARGET_ARCH="loong64"
else
  echo "This system's architecture $(LOCAL_ARCH) isn't supported"
  TARGET_ARCH="unsupported"
fi

if [ ! -f "/opt/bin/acc" ]; then
  mkdir -p /opt/bin
  curl $HTTP_SERVER/vscode/access/$ACC_VERSION/awecloud-access-client-linux-$TARGET_ARCH \
    >/opt/bin/acc-$ACC_VERSION-linux-$TARGET_ARCH
  chmod +x /opt/bin/acc-$ACC_VERSION-linux-$TARGET_ARCH
  ln -s /opt/bin/acc-$ACC_VERSION-linux-$TARGET_ARCH /opt/bin/acc
fi

if [ ! -f "/etc/systemd/system/acc.service" ]; then
  cat >>/etc/systemd/system/acc.service <<-EOF
[Unit]
Description=ACC Service

[Service]
Type=notify
Delegate=yes
KillMode=process
Restart=always
RestartSec=5

ExecStart=/opt/bin/acc -c /etc/acc/config.toml

[Install]
WantedBy=multi-user.target
EOF
fi

ACC_USER=${ACC_USER:-tmp}
ACC_LOCAL_IP=${ACC_LOCAL_IP:-127.0.0.1}
ACC_LOCAL_PORT=${ACC_LOCAL_PORT:-22}
ACC_REMOTE_PORT=${ACC_REMOTE_PORT:-10000}

mkdir -p /etc/acc/
cat >>/etc/acc/config.toml <<-EOF
serverAddr = "https://k8s.ali.wodcloud.com/awecloud/access/api"

user = "$ACC_USER"
auth.token = "ETIeTriPlAUT"

[[proxies]]
name = "ssh"
type = "tcp"
localIP = "$ACC_LOCAL_IP"
localPort = $ACC_LOCAL_PORT
remotePort = $ACC_REMOTE_PORT
EOF

systemctl daemon-reload

systemctl enable acc.service

systemctl start acc.service
