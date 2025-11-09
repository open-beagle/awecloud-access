ARG BASE=alpine:3

FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
ARG VERSION=v6.2.9
ARG TARGETOS
ARG TARGETARCH
LABEL maintainer=$AUTHOR version=$VERSION

COPY ./release/awecloud-access-client-$VERSION-$TARGETOS-$TARGETARCH /app/awecloud-access-client
COPY ./build/client.conf.ini /etc/awecloud/conf.ini

ENTRYPOINT ["/app/awecloud-access-client","-c","/etc/awecloud/conf.ini"]