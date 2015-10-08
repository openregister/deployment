#!/usr/bin/env bash

set -eu

usage() {
    echo "Usage: $0 <vpc-name>"
    echo ""
    echo "* Creates an EC2 indexer instance in the given VPC."
}


if [ "$#" -ne 1 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi

VPC=$1

INSTANCE_NAME=indexer

INSTANCE_PROFILE_NAME=indexer-instance-profile

SG=${VPC}-${INSTANCE_NAME}-sg

MINT_DB_SG=$VPC-mint-db-sg
PRESENTATION_DB_SG=$VPC-presentation-db-sg

VPC_ID=$(aws ec2 describe-vpcs --filter Name=tag:Name,Values=${VPC} --query 'Vpcs[0].VpcId' --output text)
MINT_DB_SG_ID=$(aws ec2 describe-security-groups --filter Name=vpc-id,Values=${VPC_ID} Name=group-name,Values=$MINT_DB_SG --query 'SecurityGroups[0].GroupId' --output text)
PRESENTATION_DB_SG_ID=$(aws ec2 describe-security-groups --filter Name=vpc-id,Values=${VPC_ID} Name=group-name,Values=$PRESENTATION_DB_SG --query 'SecurityGroups[0].GroupId' --output text)
# There are multiple subnets but we don't actually care which one we use
SUBNET_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=${VPC_ID} --query 'Subnets[0].SubnetId' --output text)

USER_DATA_FILE=user-data.yaml
USER_DATA=$(cat "$USER_DATA_FILE" | base64)

set_up_security_group() {
    CIDR=80.194.77.64/26

    echo "Creating security group $SG"
    SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name "$SG" --vpc-id "$VPC_ID" --description "$VPC $INSTANCE_NAME" --query 'GroupId' --output text)

    echo "Authorizing security group $SG to ssh on instance from local network"
    aws ec2 authorize-security-group-ingress --group-id "$SECURITY_GROUP_ID" --protocol tcp --port 22 --cidr "$CIDR"

    echo "Tagging security group"
    aws ec2 create-tags --resources "$SECURITY_GROUP_ID" --tags "Key=Name,Value=${SG}" > /dev/null

    echo "Allow access to mint RDS instance"
    aws ec2 authorize-security-group-ingress --group-id "$MINT_DB_SG_ID" --protocol tcp --port 5432 --source-group "$SECURITY_GROUP_ID"

    echo "Allow access to presentation RDS instance"
    aws ec2 authorize-security-group-ingress --group-id "$PRESENTATION_DB_SG_ID" --protocol tcp --port 5432 --source-group "$SECURITY_GROUP_ID"
}

create_instance() {

    echo "Creating instance $INSTANCE_NAME"
    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id ami-a10897d6 \
        --count 1 \
        --instance-type t2.micro \
        --user-data "$USER_DATA" \
        --iam-instance-profile Name=${INSTANCE_PROFILE_NAME} \
        --subnet-id "$SUBNET_ID" \
        --security-group-ids "$SECURITY_GROUP_ID" \
        --query 'Instances[0].InstanceId' \
        --output text)

    echo "Tagging instance"
    aws ec2 create-tags --resources "$INSTANCE_ID" --tags "Key=Name,Value=${INSTANCE_NAME}" > /dev/null
    aws ec2 create-tags --resources "$INSTANCE_ID" --tags "Key=Environment,Value=${VPC}" > /dev/null
    aws ec2 create-tags --resources "$INSTANCE_ID" --tags "Key=AppServer,Value=${VPC}-indexer" > /dev/null
}

set_up_security_group
create_instance
