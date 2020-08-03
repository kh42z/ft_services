FROM alpine:3.7
RUN apk add --no-cache supervisor
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing grafana telegraf
ADD files/grafana.ini /etc/grafana.ini
ADD files/liveness.sh /liveness.sh
ADD files/supervisord.conf /etc/supervisord.conf
ADD files/telegraf.conf /etc/telegraf.conf
ADD files/dashboard.yaml /usr/share/grafana/conf/provisioning/dashboards/dashboards.yaml
ADD files/influxdb.yaml /usr/share/grafana/conf/provisioning/datasources/influxdb.yaml
COPY files/dashboards/* /etc/grafana/dashboards/
RUN chmod +x /liveness.sh
RUN mkdir -p /etc/grafana/dashboards/

EXPOSE 3000
ENTRYPOINT ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
