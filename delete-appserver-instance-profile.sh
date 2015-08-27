#!/usr/bin/env bash



usage() {
    echo "Usage: $0 role-name"
    echo
    echo "Deletes an instance profile created by create-appserver-instance-profile.sh"
}

if [ "$#" -ne 1 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi

ROLE_NAME=$1
INSTANCE_PROFILE_NAME=$1

aws iam delete-role-policy --role-name "${ROLE_NAME}" --policy-name "PreviewConfigMintAccess"
aws iam delete-role-policy --role-name "${ROLE_NAME}" --policy-name "PreviewIndexerConfigAccess"
aws iam detach-role-policy --role-name "${ROLE_NAME}" --policy-arn "arn:aws:iam::022990953738:policy/RegisterAppServer"

aws iam remove-role-from-instance-profile --instance-profile-name "${ROLE_NAME}" --role-name "${ROLE_NAME}"

aws iam delete-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}"

aws iam delete-role --role-name "${ROLE_NAME}"

