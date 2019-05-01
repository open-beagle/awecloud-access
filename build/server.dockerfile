FROM {{ BASEIMAGE }}
MAINTAINER {{ AUTHOR }}
LABEL Author={{ AUTHOR }} Name={{ PROJECT }} Version={{ VERSION }}

COPY ./dist/awecloud-access-server /app/awecloud-access-server
COPY ./build/server.conf.ini /app/conf.ini

RUN chmod +x /app/awecloud-access-server

ENTRYPOINT ["/app/awecloud-access-server","-c","/app/conf.ini"]