#!/usr/bin/env bash

ROLE_NAME=indexer-instance-role
INSTANCE_PROFILE_NAME=indexer-instance-profile

runScript(){
    echo "Creating role $ROLE_NAME"
    aws iam create-role --role "${ROLE_NAME}" --assume-role-policy-document "{
      \"Version\": \"2012-10-17\",
      \"Statement\": [
        {
          \"Effect\": \"Allow\",
          \"Principal\": {
            \"Service\": [
              \"codedeploy.eu-west-1.amazonaws.com\",
              \"ec2.amazonaws.com\"
            ]
          },
          \"Action\": \"sts:AssumeRole\"
        }
      ]
    }"

    echo "putting policy CodeDeployAgentPolicy to $ROLE_NAME"
    aws iam put-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-name "CodeDeployAgentPolicy" \
    --policy-document "{
        \"Version\": \"2012-10-17\",
        \"Statement\": [
            {
                \"Action\": [
                    \"s3:Get*\",
                    \"s3:List*\"
                ],
                \"Effect\": \"Allow\",
                \"Resource\": \"arn:aws:s3:::aws-codedeploy-eu-west-1/*\"
            }
        ]
    }"

    echo "putting policy IndexerBucketPolicy to $ROLE_NAME"
    aws iam put-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-name "DeployableArtifactBucketsPolicy" \
    --policy-document "{
        \"Version\": \"2012-10-17\",
        \"Statement\": [
            {
                \"Action\": [
                    \"s3:*\"
                ],
                \"Effect\": \"Allow\",
                \"Resource\": [
                    \"arn:aws:s3:::indexer.app.artifacts/*\"
                ]
            }
        ]
    }"

    echo "putting policy IndexerConfigAccess to $ROLE_NAME"
    aws iam put-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-name "IndexerConfigAccess" \
    --policy-document '{
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": [
                        "s3:GetObject"
                    ],
                    "Resource": [
                        "arn:aws:s3:::preview.config/indexer/indexer.properties"
                    ],
                    "Effect": "Allow"
                }
            ]
        }
    '

    echo "Create instance profile with name INSTANCE_PROFILE_NAME"
    aws iam create-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}"

    echo "adding role to instance profile"
    aws iam add-role-to-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}" --role-name "${ROLE_NAME}"

}

deleteAllResources(){
    echo "Cleaning up all resources"
    echo "Deleting role policy CodeDeployAgentPolicy"
    aws iam delete-role-policy --role-name "${ROLE_NAME}" --policy-name "CodeDeployAgentPolicy"

    echo "Deleting role policy IndexerBucketPolicy"
    aws iam delete-role-policy --role-name "${ROLE_NAME}" --policy-name "IndexerBucketPolicy"

    echo "Deleting role policy IndexerConfigAccess"
    aws iam delete-role-policy --role-name "${ROLE_NAME}" --policy-name "IndexerConfigAccess"

    echo "Deleting role from instance profile"
    aws iam remove-role-from-instance-profile --instance-profile-name "${ROLE_NAME}" --role-name "${ROLE_NAME}"

    echo "Deleting instance profile ${INSTANCE_PROFILE_NAME}"
    aws iam delete-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}"

    echo "Deleting Role ${ROLE_NAME}"
    aws iam delete-role --role-name "${ROLE_NAME}"
}

runScript
#deleteAllResources
