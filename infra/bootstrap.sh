#!/bin/bash

source ./options.sh

cd ../cluster

gsutil cp gs://config-management-release/released/latest/config-sync-operator.yaml .

gcloud container clusters get-credentials $CLUSTER_NAME --region $REGION --project $PROJECT_ID

kubectl apply -f ./config-sync-operator.yaml

export REPO_URL=https://source.developers.google.com/p/${PROJECT_ID}/r/cs-repo

gcloud source repos create cs-repo 

gcloud source repos clone cs-repo

shopt -s extglob
mv -- !(cs-repo) cs-repo

cd cs-repo

git config --global user.email "{USER}"
git config --global user.name "Qwiklabs student"

git add .

git commit -m "Initialize config sync."

git push -u origin master

cd ../../infra

cat << EOF >> config-management.yaml
apiVersion: configmanagement.gke.io/v1
kind: ConfigManagement
metadata:
  name: config-management
spec:
  clusterName: $CLUSTER_NAME
  git:
    syncRepo: ${REPO_URL}
    syncBranch: master
    secretType: gcenode
    policyDir: "."
EOF

kubectl apply -f config-management.yaml