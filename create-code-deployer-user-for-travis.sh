#!/usr/bin/env bash


usage() {
    echo "Usage: ./create-code-deployer-user-for-travis.sh $1 user-name"
    echo
    echo "Creates an user with required permission to deploy code by travis"
}

if [ "$#" -ne 1 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi


USER_NAME=$1
AWS_CODE_DEPLOY_FULLACCESS_POLICY_ARN="arn:aws:iam::aws:policy/AWSCodeDeployFullAccess"

runScript(){
    echo "Creating user $USER_NAME"
    aws iam create-user --user-name $USER_NAME

    echo "Attaching user policy $AWS_CODE_DEPLOY_FULLACCESS_POLICY_ARN to user $USER_NAME"
    aws iam attach-user-policy --user-name $USER_NAME --policy-arn $AWS_CODE_DEPLOY_FULLACCESS_POLICY_ARN

    echo "Putting user policy to allow travis to access buckets"
    aws iam put-user-policy  \
    --user-name $USER_NAME  \
    --policy-name "S3_Bucket_Policy_For_Travis"  \
    --policy-document "{
        \"Version\": \"2012-10-17\",
        \"Statement\": [
            {
                \"Sid\": \"Stmt1438793257000\",
                \"Effect\": \"Allow\",
                \"Action\": [
                    \"s3:Put*\",
                    \"s3:Get*\",
                    \"s3:List*\"
                ],
                \"Resource\": [
                    \"arn:aws:s3:::presentation.app.artifacts/*\",
                    \"arn:aws:s3:::mint.app.artifacts/*\"
                ]
            }
        ]
    }"
}

deleteAllResources(){
    echo "Cleaning up all resources"

    echo "Detaching user policy $AWS_CODE_DEPLOY_FULLACCESS_POLICY_ARN from user $USER_NAME"
    aws iam detach-user-policy --user-name $USER_NAME --policy-arn $AWS_CODE_DEPLOY_FULLACCESS_POLICY_ARN

    echo "Deleting user policy S3_Bucket_Policy_For_Travis from user $USER_NAME"
    aws iam delete-user-policy --user-name $USER_NAME --policy-name "S3_Bucket_Policy_For_Travis"

    echo "Deleting user $USER_NAME"
    aws iam delete-user --user-name $USER_NAME
}

runScript
#deleteAllResources
