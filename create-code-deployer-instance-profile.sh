#!/usr/bin/env bash



usage() {
    echo "Usage: ./create-code-deployer-instance-profile.sh $1 role-name"
    echo
    echo "Creates an instance-profile with role and its permission for code deploy"
}

if [ "$#" -ne 1 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi

ROLE_NAME=$1
INSTANCE_PROFILE_NAME=$1
AWS_CODE_DEPLOY_ROLE_POLICY_ARN="arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"

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

    echo "Attaching policy $AWS_CODE_DEPLOY_ROLE_POLICY_ARN to $ROLE_NAME"
    aws iam attach-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-arn "${AWS_CODE_DEPLOY_ROLE_POLICY_ARN}"


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

    echo "putting policy DeployableArtifactBucketsPolicy to $ROLE_NAME"
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
                    \"arn:aws:s3:::presentation.app.artifacts/*\",
                    \"arn:aws:s3:::mint.app.artifacts/*\",
                    \"arn:aws:s3:::indexer.app.artifacts/*\"
                ]
            }
        ]
    }"

    echo "putting policy PreviewConfigMintAccess to $ROLE_NAME"
    aws iam put-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-name "PreviewConfigMintAccess" \
    --policy-document "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
        {
            \"Action\": [
                \"s3:GetObject\"
            ],
            \"Resource\": [
                \"arn:aws:s3:::preview.config/${ROLE_NAME}/mint/*\"
            ],
            \"Effect\": \"Allow\"
        }
    ]
}
"

    echo "putting policy DescribeTags to $ROLE_NAME"
    aws iam put-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-name "DescribeTags" \
    --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:DescribeTags"
            ],
            "Effect": "Allow",
            "Resource": ["*"]
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

    echo "Deleting role policy DeployableArtifactBucketsPolicy"
    aws iam delete-role-policy --role-name "${ROLE_NAME}" --policy-name "DeployableArtifactBucketsPolicy"

    echo "Deleting role policy PreviewConfigMintAccess"
    aws iam delete-role-policy --role-name "${ROLE_NAME}" --policy-name "PreviewConfigMintAccess"

    echo "Detaching policy arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
    aws iam detach-role-policy --role-name "${ROLE_NAME}" --policy-arn "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"

    echo "Deleting role from instance profile"
    aws iam remove-role-from-instance-profile --instance-profile-name "${ROLE_NAME}" --role-name "${ROLE_NAME}"

    echo "Deleting instance profile ${INSTANCE_PROFILE_NAME}"
    aws iam delete-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}"

    echo "Deleting Role ${ROLE_NAME}"
    aws iam delete-role --role-name "${ROLE_NAME}"
}

runScript
#deleteAllResources
