FROM alpine:3.7

RUN apk --update --no-cache add vsftpd openssl supervisor
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing telegraf
RUN openssl req -x509 -nodes -days 180 -newkey rsa:4096 -subj '/C=FR/ST=42/L=Paris/O=42/CN=42' -keyout /etc/ssl/certs/ftps.pem -out /etc/ssl/certs/ftps.pem

ADD files/vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN mkdir /var/ftp
ADD files/start.sh /start.sh
ADD files/telegraf.conf /etc/telegraf.conf
ADD files/supervisord.conf /etc/supervisord.conf
ADD files/liveness.sh /liveness.sh
RUN chmod a+x /start.sh /liveness.sh

EXPOSE 21 7000 7001 7002 7003 7004 7005
VOLUME /var/ftp
CMD ["/start.sh"]
ENTRYPOINT ["/bin/sh"]
