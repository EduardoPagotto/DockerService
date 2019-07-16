FROM redis
LABEL MAINTAINER="Eduardo Pagotto <edupagotto@gmail.com>"

COPY redis.conf /usr/local/etc/redis.conf
CMD redis-server /usr/local/etc/redis.conf && /bin/bash

