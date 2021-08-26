# gke-bootstrap

## Overview
This is a repo for bootstrapping a sandbox multi-tenant GKE cluster.

## Requirements and Setup

This requires a GCP project and a user configured with the below IAM permissions:
* IAM Admin
* Kubernetes Engine Admin
* Network Admin
* BigQuery Admin

Configure your environment in [Cloud Shell](https://cloud.google.com/shell).
```
gcloud init
```

Create the GKE environment.
```
cd infra && ./create.sh
```

Bootstrap the cluster with Config Sync.
```
./bootstrap.sh
```

## TODO
* Expand on README for walkthrough.
* Deploy sample applications to tenant namespaces.