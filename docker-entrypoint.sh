#!/bin/bash

# Workaround for GitLab ENTRYPOINT double execution (issue: 1380)
[ -f /tmp/gitlab-runner.lock ] && exit || >/tmp/gitlab-runner.lock

# If we have a GOOGLE_APPLICATION_CREDENTIALS file defined - activate it
if [ ! -z "$GOOGLE_APPLICATION_CREDENTIALS" ]
then
    # If the variable isn't a file path, but the actual contents of the file - drop it into a temporary file
    if [ ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]
    then
        FILENAME=$(tempfile).json
        printenv GOOGLE_APPLICATION_CREDENTIALS > "$FILENAME"
        export GOOGLE_APPLICATION_CREDENTIALS="$FILENAME"
    fi
    gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
    
    if [ ! -z "$CLOUDSDK_CONTAINER_CLUSTER" ]
    then
        gcloud container clusters get-credentials $CLOUDSDK_CONTAINER_CLUSTER
        docker-credential-gcr configure-docker
    fi
else
    echo "GCP Credentials not found"
fi

exec "$@"
