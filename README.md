# gke-bootstrap

Configure your environment in Cloud Shell.
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
