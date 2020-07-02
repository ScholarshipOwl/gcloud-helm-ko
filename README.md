# gcloud-helm-ko
A Dockerfile that inclues Google Cloud SDK, Helm3 and Ko, for usage in CI scenarios.

## Credentials
If a `GOOGLE_APPLICATION_CREDENTIALS` variable is set - it will use that to initialize the GCP credentials.

Also, you can setup the GKE environment with `CLOUDSDK_CONTAINER_CLUSTER`, `CLOUDSDK_COMPUTE_ZONE` and `CLOUDSDK_CORE_PROJECT`.

## How to use it in Gitlab-CI
Define in your `.gitlab-ci.yaml` the following variables:

```yaml
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
  script: 
    # In k8s runner there is a bug that entrypoint is overriden so we need to launch it manualy.
    # If you running on any other runner you can remove it
    # See: https://gitlab.com/gitlab-org/gitlab-runner/-/issues/4125
    - /docker-entrypoint.sh

    # Run helm deployment
    - helm upgrade ${DEPLOYMENT_NAME} chart/
      --install
      --set image.tag=${CI_COMMIT_SHORT_SHA}
      --namespace ${NAMESPACE}
```

`go-build` would create an image for `${KO_DOCKER_REPO}/go-cmd:${CI_COMMIT_SHORT_SHA}`.

`deploy` will run `helm upgrade` from the repositories chart, to `${CLOUDSDK_CONTAINER_CLUSTER}` to the `${NAMESPACE}`

## Helmfile
Image includes [helmfile](https://github.com/roboll/helmfile) utility for more advanced Helm charts deployments.

Read documentation how to create `helmfile.yaml`, so your deploy stage will looks like this:
```yaml
deploy:
  stage: deploy
  image: scholarshipowl/gcloud-helm-ko
  script:
    - helmfile -e prod apply
      --set imageTag=${CI_COMMIT_SHORT_SHA}
```
