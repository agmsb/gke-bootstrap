#! /bin/bash

set -o nounset
set -o errexit
set -o pipefail

source ./options.sh

printf "\n We're sorry to see you go. \n"

sleep 2 

printf "\n Validating GCP Project \n"

gcloud config set project $PROJECT_ID

printf "\n Deleting GKE Cluster $CLUSTER_NAME \n"

cat << EOM

Currently running:

gcloud container clusters delete $CLUSTER_NAME --region=$REGION

EOM

gcloud container clusters delete $CLUSTER_NAME --region=$REGION

printf "\n Deleting Cluster Subnet $SUBNET_NAME \n"

cat << EOM

Currently running:

gcloud container networks subnets delete $SUBNET_NAME --region=$REGION

EOM

gcloud compute networks subnets delete $SUBNET_NAME --region=$REGION

printf "\n Deleting VPC $VPC_NAME \n"

cat << EOM

Currently running:

gcloud compute networks delete $VPC_NAME

EOM

gcloud compute networks delete $VPC_NAME

printf "\n We should be all done here. Thanks for trying GKE out! \n"