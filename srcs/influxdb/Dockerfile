FROM alpine:latest
RUN apk add --no-cache influxdb supervisor
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing influxdb telegraf

ADD files/liveness.sh /liveness.sh
ADD files/supervisord.conf /etc/supervisord.conf
ADD files/telegraf.conf /etc/telegraf.conf
ADD files/influxdb.conf /etc/influxdb.conf

RUN chmod +x /liveness.sh
EXPOSE 8086
VOLUME /var/lib/influxdb
ENTRYPOINT ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
