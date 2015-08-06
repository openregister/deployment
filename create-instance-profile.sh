#!/bin/bash

NAME=${1}

# ReCreate a policy for codedeploy
PDP="file://$(pwd)/codedeploy_policy_document.json"
RDP="file://$(pwd)/codedeploy_role_document.json"

POLICY_ARN=$(aws iam create-policy --policy-name ${NAME}_policy --policy-document ${PDP} --query Policy.Arn --output text)
echo "POLICY_ARN: $POLICY_ARN"

ROLE=$(aws iam create-role --role-name ${NAME}_role --assume-role-policy-document ${RDP})
ROLE_NAME=$(aws iam get-role --role-name ${NAME}_role --query "Role.RoleName" --output text)
echo "ROLE_NAME: $ROLE_NAME"

PROFILE=$(aws iam create-instance-profile --instance-profile-name ${NAME})
PROFILE_NAME=$(aws iam get-instance-profile --instance-profile-name ${NAME} --query "InstanceProfile.InstanceProfileName" --output text)
PROFILE_ARN=$(aws iam get-instance-profile --instance-profile-name ${NAME} --query "InstanceProfile.Arn" --output text)

aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn $POLICY_ARN
aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
aws iam add-role-to-instance-profile --instance-profile-name $PROFILE_NAME --role-name $ROLE_NAME

echo "POLICY_ARN:$POLICY_ARN|ROLE_NAME:$ROLE_NAME|PROFILE_NAME:$PROFILE_NAME|PROFILE_ARN: $PROFILE_ARN"
