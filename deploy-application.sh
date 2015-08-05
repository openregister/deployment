#!/usr/bin/env bash

APPLICATION_NAME=$1
DEPLOYMENT_GROUP_NAME=$2
BUCKET_NAME=$3
BUNDLE_NAME=$4

usage() {
    echo "This script first runs 'aws deploy push' command which creates the deployable bundle and pushes it to s3 bucket."
    echo "Deployable bundle zip contains all the files from the current directory so must run this script from the deploy directory."
    echo "secondly it creates a deployment which fetches bundle from s3 and deploys using the deployment group configuration"
    echo
    echo "Usage: ./setup-code-deploy-application.sh $1 application-name $2 deployment-group-name $3 s3-bucket-name $4 bundle-name"
    echo
}

if [ "$#" -ne 4 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi

aws deploy push \
  --application-name $APPLICATION_NAME \
  --s3-location s3://$BUCKET_NAME/$BUNDLE_NAME.zip \
  --ignore-hidden-files



aws deploy create-deployment \
  --application-name $APPLICATION_NAME \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --deployment-group-name $DEPLOYMENT_GROUP_NAME \
  --s3-location bucket=$BUCKET_NAME,bundleType=zip,key=$BUNDLE_NAME.zip
