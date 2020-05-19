#!/bin/sh

if [ ! -z "$GOOGLE_APPLICATION_CREDENTIALS" ] && [ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]
then
    gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"
    
    if [ ! -z "CLOUDSDK_CONTAINER_CLUSTER"]
    then
        gcloud container clusters get-credentials $CLOUDSDK_CONTAINER_CLUSTER
    if
else
    echo "GCP Credentials not found"
fi

exec "$@"