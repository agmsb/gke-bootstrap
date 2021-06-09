#! /bin/bash

# Set GCP Project
PROJECT_ID=agmsb-k8s

gcloud config set project $PROJECT_ID

# Set GCP Region
REGION=us-west1

# Set GCP Account
PRIMARY_ACCOUNT=$(gcloud config get-value account)

# Set VPC
VPC_NAME=gke-vpc
SUBNET_NAME=gke-vpc-subnet

# Set GKE
CLUSTER_NAME=sandbox-gke
CLUSTER_VERSION=$(gcloud beta container get-server-config --region us-west1 --format='value(validMasterVersions[0])')
MACHINE_TYPE=n1-standard-1
