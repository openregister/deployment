#!/bin/bash

NAME=${1}

aws iam remove-role-from-instance-profile \
	--instance-profile-name ${NAME} \
	--role-name ${NAME}_role

POLICY_ARN=$(aws iam list-policies --scope Local | \
	grep ${NAME}_policy | \
	grep \"Arn\" | \
	sed -e 's/^[^"]*\"Arn\": \"\([^"]*\).*$/\1/g')

aws iam detach-role-policy --role-name ${NAME}_role --policy-arn ${POLICY_ARN}
aws iam detach-role-policy --role-name ${NAME}_role --policy-arn "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"

aws iam delete-policy --policy-arn ${POLICY_ARN}

aws iam delete-role --role-name ${NAME}_role

aws iam delete-instance-profile --instance-profile-name ${NAME}
