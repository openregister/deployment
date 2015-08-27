#!/usr/bin/env bash


ROLE_NAME=indexer-instance-role
INSTANCE_PROFILE_NAME=indexer-instance-profile

echo "Cleaning up all resources"

echo "Detachin role policy RegisterAppServer"
aws iam detach-role-policy --role-name "${ROLE_NAME}" --policy-arn "arn:aws:iam::022990953738:policy/RegisterAppServer"

echo "Deleting role policy IndexerConfigAccess"
aws iam delete-role-policy --role-name "${ROLE_NAME}" --policy-name "IndexerConfigAccess"

echo "Deleting role from instance profile"
aws iam remove-role-from-instance-profile --instance-profile-name "${ROLE_NAME}" --role-name "${ROLE_NAME}"

echo "Deleting instance profile ${INSTANCE_PROFILE_NAME}"
aws iam delete-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}"

echo "Deleting Role ${ROLE_NAME}"
aws iam delete-role --role-name "${ROLE_NAME}"
