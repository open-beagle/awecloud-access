ARG BASE

FROM $BASE
LABEL maintainer={{AUTHOR}} version={{VERSION}}

COPY ./dist/awecloud-access-server /app/awecloud-access-server
COPY ./build/server.conf.ini /etc/awecloud/conf.ini

RUN chmod +x /app/awecloud-access-server

ENTRYPOINT ["/app/awecloud-access-server","-c","/etc/awecloud/conf.ini"]