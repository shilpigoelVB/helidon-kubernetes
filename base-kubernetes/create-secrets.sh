#!/bin/bash
CONFDIR=$HOME/helidon-kubernetes/configurations
MGRDIR=$CONFDIR/stockmanagerconf
FRONTDIR=$CONFDIR/storefrontconf
echo Deleting existing generic secrets
echo my-docker-reg
kubectl delete secret my-docker-reg --ignore-not-found=true
echo Deleting existing store front secrets
echo sf-conf
kubectl delete secret sf-conf-secure --ignore-not-found=true
echo Deleting existing stock manager secrets
echo sm-conf
kubectl delete secret sm-conf-secure --ignore-not-found=true
echo sm-wallet-atp
kubectl delete secret sm-wallet-atp --ignore-not-found=true
echo stockmanagerdb
kubectl delete secret stockmanagerdb --ignore-not-found=true
echo Deleted secrets
echo Secrets remaining in namespace are 
kubectl get secrets
echo Creating general secrets
echo my-docker-reg
kubectl create secret docker-registry my-docker-reg --docker-server=fra.ocir.io --docker-username='tenancy-name/oracleidentitycloudservice/username' --docker-password='abcdefrghijklmnopqrstuvwxyz' --docker-email='you@email.com'
echo Creating stock manager secrets
echo stockmanagerdb
kubectl apply -f $MGRDIR/databaseConnectionSecret.yaml
echo sm-wallet-atp
kubectl create secret generic sm-wallet-atp --from-file=$MGRDIR/Wallet_ATP
echo Creating stockmanager secrets
kubectl create secret generic sm-conf-secure --from-file=$MGRDIR/confsecure
echo Creating store front secrets
kubectl create secret generic sf-conf-secure --from-file=$FRONTDIR/confsecure
echo Existing in namespace are 
kubectl get secrets

