# gcloud-helm-ko
A Dockerfile that inclues Google Cloud SDK, Helm3 and Ko, for usage in CI scenarios.

## Credentials
If a GOOGLE_CLOUD_CREDENTIALS variable is set - it will use that to initialize the GCP credentials.

Also, you can setup the GKE environment with CLOUDSDK_CONTAINER_CLUSTER, CLOUDSDK_COMPUTE_ZONE and CLOUDSDK_CORE_PROJECT.

## How to use it in Gitlab-CI
Define in your .gitlab-ci.yaml the following variables:

```
variables:
  CLOUDSDK_COMPUTE_ZONE: {{zone}}
  CLOUDSDK_CORE_PROJECT: {{project ID}}
  CLOUDSDK_CONTAINER_CLUSTER: {{the cluster name}}
  DEPLOYMENT_NAME: {{name of the deployment}}
  KO_DOCKER_REPO: {{prefix for go containers}}
  DOCKER_REPO: {{prefix for other containers}}
  NAMESPACE: {{namespace}}

go-build:
  stage: build
  image: scholarshipowl/gcloud-helm-ko
  script: ko publish -B -t ${CI_COMMIT_SHORT_SHA} .

deploy:
  stage: deploy
  image: scholarshipowl/gcloud-helm-ko
  script: helm upgrade --install --set image.tag=${CI_COMMIT_SHORT_SHA} --namespace ${NAMESPACE} ${DEPLOYMENT_NAME} chart/
```

`go-build` would create an image for ${KO_DOCKER_REPO}/go-cmd:${CI_COMMIT_SHORT_SHA}.
`deploy` will run `helm upgrade` from the repositories chart, to ${CLOUDSDK_CONTAINER_CLUSTER} to the ${NAMESPACE}