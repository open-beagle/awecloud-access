ARG BASE

FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
ARG VERSION=v6.2.9
LABEL maintainer=$AUTHOR version=$VERSION

ARG TARGETOS=linux
ARG TARGETARCH=amd64

ENV BIND_SOCKET_PATH=/awecloud/access/api

COPY ./release/awecloud-access-server-$VERSION-$TARGETOS-$TARGETARCH /app/awecloud-access-server
COPY ./build/server.conf.ini /etc/awecloud/conf.ini

ENTRYPOINT ["/app/awecloud-access-server","-c","/etc/awecloud/conf.ini"]