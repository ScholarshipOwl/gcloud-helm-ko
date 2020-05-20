# gcloud-helm-ko
A Dockerfile that inclues Google Cloud SDK, Helm3 and Ko, for usage in CI scenarios.

## Credentials
If a GOOGLE_CLOUD_CREDENTIALS varialbe is et - it will use that to initialize the GCP credentials.

Also, you can setup the GKE environment with CLOUDSDK_CONTAINER_CLUSTER, CLOUDSDK_COMPUTE_ZONE and CLOUDSDK_CORE_PROJECT.