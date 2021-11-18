#!/bin/bash -f

export SETTINGS=$HOME/hk8sLabsSettings

if [ -f $SETTINGS ]
  then
    echo Loading existing settings information
    source $SETTINGS
  else 
    echo No existing settings cannot contiue
    exit 10
fi

if [ -z $USER_INITIALS ]
then
  echo Your initials have not been set, you need to run the get-initials.sh script before you can run thie script
  exit 1
fi


if [ -z $COMPARTMENT_OCID ]
then
  echo Your COMPARTMENT_OCID has not been set, you need to run the compartment-setup.sh before you can run this script
  exit 2
fi


# We've been given an COMPARTMENT_OCID, let's check if it's there, if so assume it's been configured already
COMPARTMENT_NAME=`oci iam compartment get  --compartment-id $COMPARTMENT_OCID | jq -j '.data.name'`

if [ -z $COMPARTMENT_NAME ]
then
  echo The provided COMPARTMENT_OCID or $COMPARTMENT_OCID cant be located, please check you have set the correct value in $SETTINGS
  exit 99
else
  echo Operating in compartment $COMPARTMENT_NAME
fi

if [ -z OKE_OCID ]
then
  OKENAME="$USER_INITIALS"lab
  echo Checking for cluster $OKENAME
  OKE_OCID=`oci ce cluster list --name $OKENAME --compartment-id $COMPARTMENT_OCID | jq -j '.data[0].id'`
  if [ -z $OKE_OCID ]
  then
    echo NEED TO DO THE CLUSTER CREATION HERE
    echo FOR NOW PLEASE CREATE A CLUSTER NAMES $OKENAME BY HAND IN COMPARTMENT $COMPARTMENT_NAME
  else
    echo Located existing cluster named $OKENAME in $COMPARTMENT_NAME
    echo OKE_OCID=$OKE_OCID >> $SETTINGS
  fi
  echo Downloading the kube config file
  KUBECONF=$HOME/.kube/config
  oci ce cluster create-kubeconfig --cluster-id $OKE_OCID --file $KUBECONF --region $OCI_REGION --token-version 2.0.0  --kube-endpoint PUBLIC_ENDPOINT
  # chmod to be on the safe side sometimes things can have the wront permissions which caused helm to issue warnings
  chmod 600 $KUBECONF
  echo Renaming context
  # the oci command sets the latest cluster as the default, let's rename it to one so it fits in with the rest of the lab instructions
  CURRENT_CONTEXT=`kubectl config current-context`
  kubectl config rename-context $CURRENT_CONTEXT one

else
  OKENAME=`oci ce cluster get --cluster-id $OKE_OCID | jq -j '.data.name'`
  if [ -z $OKENAME ] 
  then
    echo Cannot locate a cluster with the specified OCID of $OKE_OCID
    echo Please check that the value of OKE_OCID in $SETTINGS is correct if nor remove or replace it
    exit 5
  else
    echo Located cluster named $OKENAME using OCID $OKE_OCID
    echo You are assumed to have downloaded the $HOME/kube/config file either by hand or using this script
    echo You are assumed to have updated the kubernetes configuration to set this cluster as the default either by hand or using this script
    echo You are assumed to have set the name for this clusters context in the config to be \"one\" either by hand or using this script
  fi
fi