#! /bin/bash

source ./variables.sh

gcloud config set project $PROJECT_ID

printf "\n Creating GCP Service Account for GKE \n"

gcloud iam service-accounts create cs-node \
  --display-name=cs-node

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member "serviceAccount:cs-node@$PROJECT_ID.iam.gserviceaccount.com" \
  --role roles/logging.logWriter

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member "serviceAccount:cs-node@$PROJECT_ID.iam.gserviceaccount.com" \
  --role roles/monitoring.metricWriter

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member "serviceAccount:cs-node@$PROJECT_ID.iam.gserviceaccount.com" \
  --role roles/monitoring.viewer

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member "serviceAccount:cs-node@$PROJECT_ID.iam.gserviceaccount.com" \
  --role roles/source.reader

printf "\n Creating Google VPC \n"

sleep 3

cat << EOM

Currently Running:

$ gcloud compute networks create $VPC_NAME \
    --project=$PROJECT_ID \
    --subnet-mode=custom

EOM

gcloud compute networks create $VPC_NAME \
    --project=$PROJECT_ID \
    --subnet-mode=custom

printf "\n Creating Cluster Subnet with Pod and Service Secondary Ranges \n"

sleep 3

cat << EOM

Currently Running:

$ gcloud compute networks subnets create $SUBNET_NAME \
    --project=$PROJECT_ID \
    --region=$REGION \
    --network=$VPC_NAME \
    --range=10.4.0.0/22 \
    --secondary-range=pod-net=10.0.0.0/14,svc-net=10.4.4.0/22

EOM

gcloud compute networks subnets create $SUBNET_NAME \
    --project=$PROJECT_ID \
    --region=$REGION \
    --network=$VPC_NAME \
    --range=10.4.0.0/22 \
    --secondary-range=pod-net=10.0.0.0/14,svc-net=10.4.4.0/22

printf "\n Creating GKE Cluster in $REGION \n"

sleep 3

cat << EOM

Currently Running:


$ gcloud container clusters create $CLUSTER_NAME \
    --project=$PROJECT_ID \
    --cluster-version=$CLUSTER_VERSION \
    --enable-ip-alias \
    --network=$VPC_NAME \
    --subnetwork=$SUBNET_NAME \
    --cluster-secondary-range-name=pod-net \
    --services-secondary-range-name=svc-net \
    --region=$REGION \
    --num-nodes=2 \
    --machine-type=$MACHINE_TYPE \
    --enable-autoscaling \
    --min-nodes=1 \
    --max-nodes=3 \
    --enable-autoprovisioning \
    --min-cpu 1 --max-cpu 15 \
    --min-memory 1 --max-memory 100 \
    --enable-autorepair \
    --enable-autoupgrade \
    --enable-binauthz \
    --enable-intra-node-visibility \
    --enable-vertical-pod-autoscaling \
    --enable-stackdriver-kubernetes \
    --enable-dataplane-v2 \
    --max-surge-upgrade=2 \
    --addons=HorizontalPodAutoscaling,NodeLocalDNS,GcePersistentDiskCsiDriver

This will create a GKE Cluster with the following properties:
    Regional Cluster that spans 3 zones in the region $REGION. 
    The Kubernetes Control Plane will be replicated across 3 zones.
    IP Aliases are enabled.
    Single Node Pool with 3 $MACHINE_TYPE VMs.
    Cluster Autoscaling is enabled.
    Node Auto-Provisioning is enabled.
    Node Auto-Repair is enabled.
    Node Auto-Upgrade is enabled.
    Cloud Operations is enabled.
    Binary Authorization is enabled.
    Dataplane v2 via eBPF is enabled.
    Network Policy is enabled.
    VPC Flow Logs are enabled.
    Surge Upgrades are enabled.
    NodeLocalDNSCache is enabled.
    Persistent Disk CSI Driver is enabled.
    HPA, VPA, and MPA are enabled.
    
EOM

gcloud container clusters create $CLUSTER_NAME \
    --project=$PROJECT_ID \
    --cluster-version=$CLUSTER_VERSION \
    --enable-ip-alias \
    --network=$VPC_NAME \
    --subnetwork=$SUBNET_NAME \
    --cluster-secondary-range-name=pod-net \
    --services-secondary-range-name=svc-net \
    --region=$REGION \
    --num-nodes=2 \
    --machine-type=$MACHINE_TYPE \
    --enable-autoscaling \
    --min-nodes=1 \
    --max-nodes=3 \
    --enable-autoprovisioning \
    --min-cpu 1 --max-cpu 15 \
    --min-memory 1 --max-memory 100 \
    --enable-autorepair \
    --enable-autoupgrade \
    --enable-binauthz \
    --enable-intra-node-visibility \
    --enable-vertical-pod-autoscaling \
    --enable-stackdriver-kubernetes \
    --enable-dataplane-v2 \
    --max-surge-upgrade=2 \
    --scopes=cloud-source-repos-ro \
    --service-account "cs-node@$PROJECT_ID.iam.gserviceaccount.com" \
    --addons=HorizontalPodAutoscaling,NodeLocalDNS,GcePersistentDiskCsiDriver

printf "\n We should be done here. TTFN! \n"