#!/bin/sh

# Workaround for GitLab ENTRYPOINT double execution (issue: 1380)
[ -f /tmp/gitlab-runner.lock ] && exit || >/tmp/gitlab-runner.lock

# If we have a GOOGLE_APPLICATION_CREDENTIALS file defined - activate it
if [ ! -z "$GOOGLE_APPLICATION_CREDENTIALS" ]
then
    if [ ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]
    then
        FILENAME=$(tempfile).json
        printenv GOOGLE_APPLICATION_CREDENTIALS > "$FILENAME"
        GOOGLE_APPLICATION_CREDENTIALS="$FILENAME"
    fi
    gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
    
    if [ ! -z "CLOUDSDK_CONTAINER_CLUSTER" ]
    then
        gcloud container clusters get-credentials $CLOUDSDK_CONTAINER_CLUSTER
    fi
else
    echo "GCP Credentials not found"
fi

exec "$@"