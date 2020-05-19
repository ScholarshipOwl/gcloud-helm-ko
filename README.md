# gcloud-helm-ko
A Dockerfile that inclues Google Cloud SDK, Helm3 and Ko, for usage in CI scenarios.

## Credentials
If a GOOGLE_CLOUD_CREDENTIALS varialbe is et - it will use that to initialize the GCP credentials.
Also, if $GCLOUD_CLUSTER, $GCLOUD_ZONE, and $GCLOUD_PROJECT are set - it will initialize the relevant GKE cluster.