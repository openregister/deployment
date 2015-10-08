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
SG=${VPC}-${INSTANCE_NAME}-sg
MINT_DB_SG="${VPC}-mint-db-sg"
PRESENTATION_DB_SG="${VPC}-presentation-db-sg"

INSTANCE_ID=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${INSTANCE_NAME} Name=instance-state-name,Values=running Name=tag:Environment,Values=${VPC} --query 'Reservations[0].Instances[0].InstanceId' --output text)

if [ "$INSTANCE_ID" = "None" ]; then
    echo "Couldn't find an instance tagged with Name = ${INSTANCE_NAME}"
    exit 1
fi

VPC_ID=$(aws ec2 describe-vpcs --filter Name=tag:Name,Values=${VPC} --query 'Vpcs[0].VpcId' --output text)
SG_ID=$(aws ec2 describe-security-groups --filter Name=vpc-id,Values=${VPC_ID} Name=group-name,Values=$SG --query 'SecurityGroups[0].GroupId' --output text)
MINT_DB_SG_ID=$(aws ec2 describe-security-groups --filter Name=vpc-id,Values=${VPC_ID} Name=group-name,Values=$MINT_DB_SG --query 'SecurityGroups[0].GroupId' --output text)
PRESENTATION_DB_SG_ID=$(aws ec2 describe-security-groups --filter Name=vpc-id,Values=${VPC_ID} Name=group-name,Values=$PRESENTATION_DB_SG --query 'SecurityGroups[0].GroupId' --output text)

aws ec2 revoke-security-group-ingress --group-id "$MINT_DB_SG_ID" --protocol tcp --port 5432 --source-group "$SG_ID"
aws ec2 revoke-security-group-ingress --group-id "$PRESENTATION_DB_SG_ID" --protocol tcp --port 5432 --source-group "$SG_ID"

# terminate instance
aws ec2 terminate-instances --instance-ids "$INSTANCE_ID" > /dev/null

# wait until instance is terminated
tries=0
until [ $tries -ge 10 ]; do
    sleep 5
    echo -n .
    STATE=$(aws ec2 describe-instances \
        --instance-ids "${INSTANCE_ID}" \
        --query 'Reservations[0].Instances[0].State.Name' \
        --output text)
    [ "$STATE" = "terminated" ] && break
    tries=$[$tries+1]
done

# delete security group
aws ec2 delete-security-group --group-id "$SG_ID"

