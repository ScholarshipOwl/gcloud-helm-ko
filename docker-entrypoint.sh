#!/bin/bash

if [ ! -z "$GOOGLE_APPLICATION_CREDENTIALS" ]
then
    gcloud auth activate-service-account --key-file="${GOOGLE_APPLICATION_CREDENTIALS}"

    if [ ! -z "$GCLOUD_CLUSTER" ] && [ ! -z "$GCLOUD_ZONE" ] && [ ! -z "$GCLOUD_PROJECT" ]
    then
        gcloud container clusters get-credentials ${GCLOUD_CLUSTER} --zone ${GCLOUD_ZONE} --project ${GCLOUD_PROJECT}
    fi
else
    echo "Not found GCP Credentials"
fi

exec "$@"