#!/usr/bin/env bash

APPLICATION_NAME=$1
DEPLOYMENT_GROUP_NAME=$2
BUCKET_NAME=$3
ENVIRONMENT=$4

CODE_DEPLOYER_ROLE_ARN=arn:aws:iam::022990953738:role/code-deploy-role


createApplication(){
    APPLICATION_ID=$(aws deploy create-application \
                        --application-name $APPLICATION_NAME \
                        --output text)

    echo "$APPLICATION_ID"
}

createDeploymentGroup(){
    INSTANCE_TAG_FILTERS="Key=AppServer,Value=${ENVIRONMENT}-register,Type=KEY_AND_VALUE"

    DEPLOYMENT_GROUP_ID=$(aws deploy create-deployment-group \
            --application-name $APPLICATION_NAME \
            --deployment-group-name $DEPLOYMENT_GROUP_NAME \
            --deployment-config-name CodeDeployDefault.AllAtOnce \
            --ec2-tag-filters ${INSTANCE_TAG_FILTERS} \
            --service-role-arn ${CODE_DEPLOYER_ROLE_ARN} \
            --output text)

    echo "$DEPLOYMENT_GROUP_ID"
}

createBucket(){
    aws s3 mb s3://${BUCKET_NAME} --region=eu-west-1
}


usage() {
    echo "Usage: $0 application-name deployment-group-name s3-bucket-name environment(prod|preview)"
    echo
    echo "Creates an application with deployment group at code-deploy"
}

if [ "$#" -ne 4 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi

runScript(){
    APPLICATION_ID=$(createApplication)
    echo "Created application with id $APPLICATION_ID"

    DEPLOYMENT_GROUP_ID=$(createDeploymentGroup)
    echo "Created Deployment group with id $DEPLOYMENT_GROUP_ID"

    createBucket
}

deleteAllResources(){
    echo "Cleaning up all resources"

    echo "Deleting application $APPLICATION_NAME"
    aws deploy delete-application --application-name $APPLICATION_NAME
    aws s3 rb s3://$BUCKET_NAME --force
}

runScript
#deleteAllResources
