#!/bin/bash
USER=$(whoami)

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
/bin/bash ./srcs/build.sh
/bin/bash ./srcs/secrets.sh
/bin/bash ./srcs/deploy.sh
minikube dashboard
