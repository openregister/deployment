#!/usr/bin/env bash

usage() {
    echo "Usage: $0 environment"
    echo
    echo "Creates an instance-profile for the indexer in a given environment"
}

if [ "$#" -ne 1 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi

ENV=$1
ROLE_NAME=indexer-instance-role
INSTANCE_PROFILE_NAME=indexer-instance-profile


CONFIG_BUCKET=openregister.${ENV}.config

echo "Creating role $ROLE_NAME"
aws iam create-role --role "${ROLE_NAME}" --assume-role-policy-document "{
  \"Version\": \"2012-10-17\",
  \"Statement\": [
    {
      \"Effect\": \"Allow\",
      \"Principal\": {
        \"Service\": [
          \"ec2.amazonaws.com\"
        ]
      },
      \"Action\": \"sts:AssumeRole\"
    }
  ]
}"

aws iam attach-role-policy --role-name "${ROLE_NAME}" \
--policy-arn "arn:aws:iam::022990953738:policy/RegisterAppServer"

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
                    "arn:aws:s3:::${CONFIG_BUCKET}/indexer/indexer.properties"
                ],
                "Effect": "Allow"
            }
        ]
    }
'

echo "Create instance profile with name $INSTANCE_PROFILE_NAME"
aws iam create-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}"

echo "adding role to instance profile"
aws iam add-role-to-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}" --role-name "${ROLE_NAME}"

