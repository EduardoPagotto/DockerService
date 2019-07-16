FROM alpine
LABEL MAINTAINER="Eduardo Pagotto <edupagotto@gmail.com>"
RUN  apk add --update rsyslog \
  && rm -rf /var/cache/apk/*

EXPOSE 514 514/udp
#VOLUME [ "/var/log", "/etc/rsyslog.d" ]

ENV TZ 'America/Sao_Paulo'
RUN echo $TZ > /etc/timezone

# for some reason, the apk comes built with a v5
# config file. using this one for v8:
COPY ./rsyslog.conf /etc/rsyslog.conf

ENTRYPOINT [ "rsyslogd", "-n" ]
