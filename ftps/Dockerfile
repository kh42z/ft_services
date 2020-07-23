FROM alpine:3.7

RUN apk --update --no-cache add vsftpd openssl
RUN openssl req -x509 -nodes -days 180 -newkey rsa:4096 -subj '/C=FR/ST=42/L=Paris/O=42/CN=42' -keyout /etc/ssl/certs/ftps.pem -out /etc/ssl/certs/ftps.pem

ADD files/vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN mkdir /var/ftp
ADD files/start.sh /start.sh
RUN chmod a+x /start.sh

EXPOSE 20 21 10000-10100
VOLUME /var/ftp
ENTRYPOINT ["/start.sh"]
