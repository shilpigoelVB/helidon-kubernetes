#!/bin/bash
echo creating tls secret
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=nginxsvc/O=nginxsvc"
kubectl create secret tls tls-secret --key tls.key --cert tls.crt
./setupClusterIPServices.sh
./setupIngress.sh
./create-secrets.sh
./create-configmaps.sh
cd ..
./deploy.sh
