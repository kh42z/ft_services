#!/bin/bash
SHELL=$(readlink /proc/$$/exe)
if [ ${SHELL} != "/bin/bash" ]
then
	echo "please execute ./setup.sh or /bin/bash ./setup.sh"
	exit
fi
USER=$(whoami)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/srcs"
CONTAINERS=("mysql" "wordpress" "phpmyadmin" "nginx" "ftps" "influxdb" "grafana")

if [ $(nproc) -lt 2 ]
	then
	echo "FT_SERVICES requires 2 cpus at least"
	exit
fi
MEM=$(awk '/^MemTotal:/{print $2}' /proc/meminfo)
if [ $MEM -lt 3062431 ]
	then
	echo "FT_SERVICES requires 3G of memory at least"
	exit
fi
if ! id -nG "$USER" | grep -qw "docker"
	then
    echo "FT_SERVICES requires $USER to have access to docker"
	echo run "sudo usermod -aG docker ${USER}"
	echo and relog "su - ${USER}"
	exit
fi
sudo minikube delete
sudo chown -R user42:user42 ~/.minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
sudo mv minikube /usr/local/bin/
minikube start --vm-driver=docker
minikube addons enable metallb

## SECRETS.SH
echo "Enter username"
read USERNAME
echo "Enter password"
read PASSWORD
USERNAME=$(echo $USERNAME| tr -cd '[:alnum:].')
PASSWORD=$(echo $PASSWORD| tr -cd '[:alnum:].')
if [ ${#USERNAME} -lt 4 ]; then
	echo "Username too short"
	USERNAME="default"
fi
if [ ${#PASSWORD} -lt 4 ]; then
	echo "Password too short"
	PASSWORD="default"
fi
echo "Defaut login is $USERNAME:$PASSWORD"
kubectl create secret generic ft-user --from-literal=username="$USERNAME" --from-literal=password="$PASSWORD"


## BUILD.SH
PREFIX="ft_services/"
eval $(minikube docker-env)

for CONTAINER in ${CONTAINERS[@]}; do
	NAME=${PREFIX}${CONTAINER}
	echo "Building: ${NAME}"
	docker build -t ${NAME} ${DIR}/${CONTAINER} > /dev/null
done

## DEPLOY.SH
MINIKUBE_IP=$(minikube ip)
NETWORK=$(echo $MINIKUBE_IP|awk -F . '{print $1"."$2"."$3"."}')

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

sleep 5
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

### DASHBOARD
minikube dashboard
