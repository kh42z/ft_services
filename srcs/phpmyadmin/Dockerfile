FROM alpine:3.7
ARG SHARE=/var/www/
RUN apk --update --no-cache add nginx supervisor php7-fpm php7-mcrypt  php7-openssl php7-json php7-dom php7-pdo php7-zip php7-bcmath php7-gd php7-odbc php7-pdo_mysql  php7-iconv php7-curl php7-session php7-mysqli openssl php7-mbstring
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing telegraf

RUN openssl req -x509 -nodes -days 180 -newkey rsa:4096 -subj '/C=FR/ST=42/L=Paris/O=42/CN=42' -keyout /etc/ssl/certs/nginx.pem -out /etc/ssl/certs/nginx.pem

RUN wget --quiet https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz -O pma.tgz && tar xzf pma.tgz -C ${SHARE} && mv ${SHARE}/phpMyAdmin-* ${SHARE}/phpMyAdmin && rm -f pma.tgz && chown -R nobody:nobody ${SHARE}

ADD files/supervisord.conf /etc/supervisord.conf
ADD files/www.conf /etc/php7/php-fpm.d/www.conf
ADD files/config.inc.php ${SHARE}/phpMyAdmin/config.inc.php
ADD files/nginx.conf /etc/nginx/conf.d/default.conf
ADD files/liveness.sh /liveness.sh
ADD files/telegraf.conf /etc/telegraf.conf
RUN chmod +x /liveness.sh

EXPOSE 5000
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
