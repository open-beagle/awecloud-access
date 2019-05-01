FROM {{ BASEIMAGE }}
MAINTAINER {{ AUTHOR }}
LABEL Author={{ AUTHOR }} Name={{ PROJECT }} Version={{ VERSION }}

COPY ./dist/awecloud-access-client /app/awecloud-access-client
COPY ./build/client.conf.ini /etc/awecloud/conf.ini

RUN chmod +x /app/awecloud-access-client

ENTRYPOINT ["/app/awecloud-access-client","-c","/etc/awecloud/conf.ini"]