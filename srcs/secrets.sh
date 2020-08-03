#!/bin/bash
echo "Enter username"
read USERNAME
echo "Enter password"
read PASSWORD
USERNAME=$(echo $USERNAME| tr -cd '[:alnum:]._-')
PASSWORD=$(echo $PASSWORD| tr -cd '[:alnum:]._-')
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
