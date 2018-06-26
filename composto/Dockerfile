FROM ubuntu
MAINTAINER Eduardo Pagotto <edupagottogmail.com>
RUN apt-get update

#instalacao
RUN apt-get install -y nginx nfs-kernel-server netbase && apt-get clean

#config nginx
ADD ./configs/nginx.conf /etc/nginx/sites-enabled/default

#config nfs
ADD ./configs/exports /etc/exports

#link dos Logs do nginx
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
#EXPOSE 8080/tcp

#RUN mkdir -p /exports
#VOLUME /exports

#EXPOSE 111/udp 2049/tcp
ADD run.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/run.sh"]

#execucao 
#CMD ["nginx", "run.sh"]