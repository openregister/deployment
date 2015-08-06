#!/usr/bin/env bash

APPLICATION_NAME=$1
DEPLOYMENT_GROUP_NAME=$2
INSTANCE_PROFILE_NAME=$3
INSTANCE_NAMES=$4
BUCKET_NAME=$5


fetchInstanceProfile(){
    CODE_DEPLOYER_PROFILE_ARN=$(aws iam get-instance-profile \
                                --instance-profile-name $INSTANCE_PROFILE_NAME \
                                --query InstanceProfile.Roles[0].Arn \
                                --output text)

    echo "$CODE_DEPLOYER_PROFILE_ARN"
}


createApplication(){
    APPLICATION_ID=$(aws deploy create-application \
                        --application-name $APPLICATION_NAME \
                        --output text)

    echo "$APPLICATION_ID"
}

createDeploymentGroup(){
    CODE_DEPLOYER_PROFILE_ARN=$1
    INSTANCE_TAG_FILTERS=""
    for instance_name in `echo "$INSTANCE_NAMES" | tr "," " "`; do  INSTANCE_TAG_FILTERS="${INSTANCE_TAG_FILTERS} Key=Name,Value=${instance_name},Type=KEY_AND_VALUE"; done

    DEPLOYMENT_GROUP_ID=$(aws deploy create-deployment-group \
            --application-name $APPLICATION_NAME \
            --deployment-group-name $DEPLOYMENT_GROUP_NAME \
            --deployment-config-name CodeDeployDefault.AllAtOnce \
            --ec2-tag-filters ${INSTANCE_TAG_FILTERS} \
            --service-role-arn ${CODE_DEPLOYER_PROFILE_ARN} \
            --output text)

    echo "$DEPLOYMENT_GROUP_ID"
}

createBucket(){
    CODE_DEPLOYER_PROFILE_ARN=$1

    aws s3 mb s3://${BUCKET_NAME} --region=eu-west-1
}


usage() {
    echo "Usage: ./setup-code-deploy-application.sh $1 application-name $2 deployment-group-name $3 instance-propfile-name $4 comma-separated-instance-names $5 s3-bucket-name"
    echo
    echo "Creates an application with deployment group at code-deploy"
}

if [ "$#" -ne 5 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi

runScript(){
    CODE_DEPLOYER_PROFILE_ARN=$(fetchInstanceProfile)
    echo "Retreived instance profile arn $CODE_DEPLOYER_PROFILE_ARN"

    APPLICATION_ID=$(createApplication)
    echo "Created application with id $APPLICATION_ID"

    DEPLOYMENT_GROUP_ID=$(createDeploymentGroup "$CODE_DEPLOYER_PROFILE_ARN")
    echo "Created Deployment group with id $DEPLOYMENT_GROUP_ID"

    createBucket "$CODE_DEPLOYER_PROFILE_ARN"
}

deleteAllResources(){
    echo "Cleaning up all resources"

    echo "Deleting application $APPLICATION_NAME"
    aws deploy delete-application --application-name $APPLICATION_NAME
    aws s3 rb s3://$BUCKET_NAME --force
}

runScript
#deleteAllResources
