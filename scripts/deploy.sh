#!/usr/bin/env bash

DEPLOY_ENV="nah"

if [[ "$CODEBUILD_WEBHOOK_TRIGGER" == "branch/main" ]]; then
    DEPLOY_ENV="staging"
fi

if [[ "$CODEBUILD_WEBHOOK_TRIGGER" == "tag/"* ]]; then
    DEPLOY_ENV="production"
fi

if [[ "$DEPLOY_ENV" != "nah" ]]; then
    # Deploy queues
    aws --region us-east-2 deploy create-deployment \
        --application-name joe-$DEPLOY_ENV-deploy-app \
        --deployment-group-name "joe-$DEPLOY_ENV-queue-deploy-group" \
        --description "Deploying trigger $CODEBUILD_WEBHOOK_TRIGGER" \
        --s3-location "bucket=cloudcasts-artifacts,bundleType=zip,key=$CODEBUILD_RESOLVED_SOURCE_VERSION.zip"

    # Deploy web servers
    aws --region us-east-2 deploy create-deployment \
        --application-name joe-$DEPLOY_ENV-deploy-app \
        --deployment-group-name "joe-$DEPLOY_ENV-http-deploy-group" \
        --description "Deploying trigger $CODEBUILD_WEBHOOK_TRIGGER" \
        --s3-location "bucket=joe-artifacts,bundleType=zip,key=$CODEBUILD_RESOLVED_SOURCE_VERSION.zip"
fi
