#!/usr/bin/env bash



usage() {
    echo "Usage: $0 role-name environment"
    echo
    echo "Creates an instance-profile with role and its permission for code deploy"
}

if [ "$#" -ne 2 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi

ROLE_NAME=$1
INSTANCE_PROFILE_NAME=$1
ENV=$2

CONFIG_BUCKET=openregister.${ENV}.config

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
}" > /dev/null

aws iam attach-role-policy --role-name "${ROLE_NAME}" \
    --policy-arn "arn:aws:iam::022990953738:policy/RegisterAppServer"

aws iam put-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-name "${ENV}ConfigAccess" \
    --policy-document "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
        {
            \"Action\": [
                \"s3:GetObject\"
            ],
            \"Resource\": [
                \"arn:aws:s3:::${CONFIG_BUCKET}/${ROLE_NAME}/mint/*\",
                \"arn:aws:s3:::${CONFIG_BUCKET}/${ROLE_NAME}/presentation/*\"
            ],
            \"Effect\": \"Allow\"
        }
    ]
}"

aws iam create-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}" > /dev/null

aws iam add-role-to-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}" --role-name "${ROLE_NAME}"