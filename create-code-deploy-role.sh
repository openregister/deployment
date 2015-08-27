#!/usr/bin/env bash


ROLE_NAME=code-deploy-role
AWS_CODE_DEPLOY_ROLE_POLICY_ARN="arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"


usage() {
    echo "Usage: $0"
    echo
    echo "Creates a role $ROLE_NAME with permissions to act as the service role"
    echo "in a CodeDeploy deployment group"
}

if [ "$#" -ne 0 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi

runScript(){
    echo "Creating role $ROLE_NAME"
    aws iam create-role --role "${ROLE_NAME}" --assume-role-policy-document "{
      \"Version\": \"2012-10-17\",
      \"Statement\": [
        {
          \"Effect\": \"Allow\",
          \"Principal\": {
            \"Service\": [
              \"codedeploy.eu-west-1.amazonaws.com\"
            ]
          },
          \"Action\": \"sts:AssumeRole\"
        }
      ]
    }"

    echo "Attaching policy $AWS_CODE_DEPLOY_ROLE_POLICY_ARN to $ROLE_NAME"
    aws iam attach-role-policy \
        --role-name "${ROLE_NAME}" \
        --policy-arn "${AWS_CODE_DEPLOY_ROLE_POLICY_ARN}"

}

deleteAllResources(){
    echo "Cleaning up all resources"
    echo "Detaching policy ${AWS_CODE_DEPLOY_ROLE_POLICY_ARN}"
    aws iam detach-role-policy --role-name "${ROLE_NAME}" --policy-arn "${AWS_CODE_DEPLOY_ROLE_POLICY_ARN}"

    echo "Deleting Role ${ROLE_NAME}"
    aws iam delete-role --role-name "${ROLE_NAME}"
}

runScript
#deleteAllResources
