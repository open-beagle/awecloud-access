ARG BASE

FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
ARG VERSION=v6.2.9
LABEL maintainer=$AUTHOR version=$VERSION

ARG TARGETOS=linux
ARG TARGETARCH=amd64

COPY ./release/awecloud-access-client-$VERSION-$TARGETOS-$TARGETARCH /app/awecloud-access-client
COPY ./build/client.conf.ini /etc/awecloud/conf.ini

ENTRYPOINT ["/app/awecloud-access-client","-c","/etc/awecloud/conf.ini"]