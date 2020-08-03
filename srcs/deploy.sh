#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
MINIKUBE_IP=$(minikube ip)
NETWORK=$(echo $MINIKUBE_IP|awk -F . '{print $1"."$2"."$3"."}')
CONTAINERS=("mysql" "wordpress" "pma" "nginx" "ftps" "influxdb" "grafana")



sed 's/{RANGE}/'${NETWORK}'100-'${NETWORK}'200/' ${DIR}/k8s/metallb.template > ${DIR}/k8s/metallb.yaml
kubectl apply -f ${DIR}/k8s/metallb.yaml

for CONTAINER in ${CONTAINERS[@]}; do
	NAME=${CONTAINER}
	if [ -f ${DIR}/${NAME}/vol.yaml ]; then
		echo "Creating vol: ${NAME}"
		kubectl create -f ${DIR}/${NAME}/vol.yaml
		kubectl create -f ${DIR}/${CONTAINER}/claim.yaml
	fi
done

sleep 10
for CONTAINER in ${CONTAINERS[@]}; do
	NAME=${CONTAINER}
	echo "Creating service: ${NAME}"
	kubectl create -f ${DIR}/${NAME}/svc.yaml
done

for CONTAINER in ${CONTAINERS[@]}; do
  EIP=$(kubectl describe svc ${CONTAINER}|grep Ingress|awk -F" " '{print $3}'|tr -d "\n ")
	if [ ${CONTAINER} == "mysql" ]
	then
		EIP=$(kubectl describe svc wordpress|grep Ingress|awk -F" " '{print $3}'|tr -d "\n ")
	fi
	NAME=${CONTAINER}
	echo "Creating deployement: ${NAME}"
	if [ -f ${DIR}/${NAME}/deploy.template ]; then
		sed 's/{EIP}/'${EIP}'/' ${DIR}/${NAME}/deploy.template > ${DIR}/${NAME}/deploy.yaml
	fi
	kubectl create -f ${DIR}/${NAME}/deploy.yaml
done
