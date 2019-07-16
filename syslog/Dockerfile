FROM balabit/syslog-ng:latest
LABEL MAINTAINER="Eduardo Pagotto <edupagotto@gmail.com>"

ADD syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

EXPOSE 514/udp
EXPOSE 601/tcp
EXPOSE 6514/tcp

ENTRYPOINT ["/usr/sbin/syslog-ng", "-F"]