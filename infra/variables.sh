#! /bin/bash

# Set GCP Project
PROJECT_ID=$(gcloud config list project --format=flattened | awk 'FNR == 1 {print $2}')
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

# Set User
USER=$(gcloud config list account --format=flattened | awk 'FNR ==1 {print $2}')

# Set BQ Dataset
BQ_DATASET=gke_usage_metering_$(date +%s)
BQ_CONTINENT=US