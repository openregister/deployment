#!/bin/bash

NAME=${1}

# ReCreate a policy for codedeploy
PDP="file://$(pwd)/codedeploy_policy_document.json"
RDP="file://$(pwd)/codedeploy_role_document.json"

POLICY=$(aws iam create-policy --policy-name ${NAME}_policy --policy-document ${PDP})
POLICY_ARN=$(echo $POLICY | sed -e 's/^.*\"Arn\"/\"Arn\"/g' -e 's/\"Arn\": \"\([^\"]*\)\".*$/\1/g')

ROLE=$(aws iam create-role --role-name ${NAME}_role --assume-role-policy-document ${RDP})
ROLE_NAME=$(echo $ROLE | sed -e 's/^.*\"RoleName": \"\([^\"]*\)\".*$/\1/g')

PROFILE=$(aws iam create-instance-profile --instance-profile-name ${NAME})
PROFILE_NAME=$(echo $PROFILE | sed -e 's/^.*\"InstanceProfileName": \"\([^\"]*\)\".*$/\1/g')
PROFILE_ARN=$(echo $PROFILE | sed -e 's/^.*\"Arn": \"\([^\"]*\)\".*$/\1/g')

aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn $POLICY_ARN
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
aws iam add-role-to-instance-profile --instance-profile-name $PROFILE_NAME --role-name $ROLE_NAME

echo "POLICY_ARN:$POLICY_ARN|ROLE_NAME:$ROLE_NAME|PROFILE_NAME:$PROFILE_NAME|PROFILE_ARN: $PROFILE_ARN"
