FROM alpine:3.7
RUN apk --update --no-cache add nginx openssl openssh supervisor

RUN openssl req -x509 -nodes -days 180 -newkey rsa:4096 -subj '/C=FR/ST=42/L=Paris/O=42/CN=42' -keyout /etc/ssl/certs/nginx.pem -out /etc/ssl/certs/nginx.pem
RUN ssh-keygen -A

ADD files/supervisord.conf /etc/supervisord.conf
ADD files/nginx.conf /etc/nginx/conf.d/default.conf
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
