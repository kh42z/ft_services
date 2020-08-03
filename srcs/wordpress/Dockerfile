FROM alpine:latest
ARG SHARE=/var/www/
RUN apk --update --no-cache add nginx supervisor php7-fpm php7-mcrypt  php7-openssl php7-json php7-dom php7-pdo php7-zip php7-bcmath php7-gd php7-odbc php7-pdo_mysql  php7-iconv php7-curl php7-session php7-mysqli openssl
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing telegraf

RUN openssl req -x509 -nodes -days 180 -newkey rsa:4096 -subj '/C=FR/ST=42/L=Paris/O=42/CN=42' -keyout /etc/ssl/certs/nginx.pem -out /etc/ssl/certs/nginx.pem
RUN wget --quiet https://wordpress.org/latest.tar.gz -O wp.tgz && tar xzf wp.tgz -C ${SHARE} && rm -f wp.tgz && chown -R nobody:nobody ${SHARE}/wordpress
ADD files/supervisord.conf /etc/supervisord.conf
ADD files/www.conf /etc/php7/php-fpm.d/www.conf
ADD files/wp-config.php ${SHARE}/wordpress/wp-config.php
ADD files/nginx.conf /etc/nginx/conf.d/default.conf
ADD files/liveness.sh /liveness.sh
ADD files/telegraf.conf /etc/telegraf.conf
RUN chmod +x /liveness.sh

EXPOSE 5050
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
