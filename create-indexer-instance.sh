#!/usr/bin/env bash

set -eu

INSTANCE_NAME=indexer

INSTANCE_PROFILE_NAME=indexer-instance-profile

SG=${INSTANCE_NAME}-sg

#mint rds security group
MINT_DB_SG='preview-mint-db-sg'

USER_DATA_FILE=user-data.yaml
USER_DATA=$(cat "$USER_DATA_FILE" | base64)

set_up_security_group() {
    CIDR=80.194.77.64/26

    echo "Creating security group $SG"
    SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name "$SG" --description "security group for $INSTANCE_NAME" --query 'GroupId' --output text)

    echo "Authorizing security group $SG to ssh on instance from local network"
    aws ec2 authorize-security-group-ingress --group-name "$SG" --protocol tcp --port 22 --cidr "$CIDR"

    echo "Tagging security group"
    aws ec2 create-tags --resources "$SECURITY_GROUP_ID" --tags "Key=Name,Value=${INSTANCE_NAME}-sg" > /dev/null

    echo "Allow access to mint RDS instance"
    aws ec2 authorize-security-group-ingress --group-name "$MINT_DB_SG" --protocol tcp --port 5432 --source-group "$SG"

}

create_instance() {

    echo "Creating instance $INSTANCE_NAME"
    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id ami-a10897d6 \
        --count 1 \
        --instance-type t2.micro \
        --user-data "$USER_DATA" \
        --iam-instance-profile Name=${INSTANCE_PROFILE_NAME} \
        --security-groups "$SG" \
        --query 'Instances[0].InstanceId' \
        --output text)

    echo "Tagging instance"
    aws ec2 create-tags --resources "$INSTANCE_ID" --tags "Key=Name,Value=${INSTANCE_NAME}" > /dev/null
}

set_up_security_group
create_instance
