ARG BASE

FROM $BASE

ARG AUTHOR
ARG VERSION
LABEL maintainer=$AUTHOR version=$VERSION

ARG TARGETOS
ARG TARGETARCH

ENV BIND_SOCKET_PATH=/awecloud/access/api

COPY ./dist/awecloud-access-server-$TARGETOS-$TARGETARCH /app/awecloud-access-server
COPY ./build/server.conf.ini /etc/awecloud/conf.ini

ENTRYPOINT ["/app/awecloud-access-server","-c","/etc/awecloud/conf.ini"]