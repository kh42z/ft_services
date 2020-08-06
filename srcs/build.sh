#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PREFIX="ft_services/"
eval $(minikube docker-env)
CONTAINERS=("mysql" "wordpress" "phpmyadmin" "nginx" "ftps" "influxdb" "grafana")
for CONTAINER in ${CONTAINERS[@]}; do
	NAME=${PREFIX}${CONTAINER}
	echo "Building: ${NAME}"
	docker build -t ${NAME} ${DIR}/${CONTAINER} > /dev/null
done
