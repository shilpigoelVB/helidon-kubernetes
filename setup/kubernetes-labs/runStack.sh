#!/bin/bash
if [ $# -ne 2 ]
  then
    echo "Missing arguments, you must provide the name of the namespace to use and the External IP address of the ingress controller service in that order"
    exit -1
fi
read -p "Have you downloaded the DB wallet, updated the database connection, and updated the stockmager-config.yaml with the name of your store ? " 
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "OK, please make sure you have got the DB wallet, updated the db connection settings with the connection name and updated the stockmanager-config.yaml with the name of your store"
    exit 1
fi
read -p "Have you created the root CA  " 
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo OK, exiting, please create the root CA
    exit 1
fi

echo Please check the output to make sure that the right context is selected as the default below
kubectl config get-contexts
read -p "Is the right cluster selected ? " 
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo OK, exiting
    exit 1
fi
read -p "Ready to delete any existing namespace $1 and setup the new stack using $2 as the external IP ? " 
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo OK, exiting
    exit 1
fi

bash ./executeRunStack.sh $1 $2