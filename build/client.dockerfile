ARG BASE

FROM $BASE

ARG AUTHOR
ARG VERSION
LABEL maintainer=$AUTHOR version=$VERSION

ARG TARGETOS
ARG TARGETARCH

COPY ./dist/awecloud-access-client-$TARGETOS-$TARGETARCH /app/awecloud-access-client
COPY ./build/client.conf.ini /etc/awecloud/conf.ini

RUN chmod +x /app/awecloud-access-client

ENTRYPOINT ["/app/awecloud-access-client","-c","/etc/awecloud/conf.ini"]