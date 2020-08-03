FROM alpine:3.7
RUN apk -v --no-cache add mariadb mariadb-client supervisor bash
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing telegraf
RUN mkdir /run/mysqld && chown mysql: /run/mysqld

ADD files/permissions.sql /opt/permissions.sql
ADD files/import.sh /import.sh
ADD files/init.sh /init.sh
ADD files/my.cnf /etc/my.cnf.d/network.cnf
ADD files/telegraf.conf /etc/telegraf.conf
ADD files/liveness.sh /liveness.sh
ADD files/wp.sql /opt/wp.sql
ADD files/supervisord.conf /etc/supervisord.conf

RUN chmod +x /init.sh /import.sh /liveness.sh
EXPOSE 3306
VOLUME ["/var/lib/mysql"]
CMD ["/bin/bash","-c","/init.sh"]
