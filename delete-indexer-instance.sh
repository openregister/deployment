#!/usr/bin/env bash

set -eu

INSTANCE_NAME=Indexer
SG=${INSTANCE_NAME}-sg
MINT_DB_SG="preview-mint-db-sg"
PRESENTATION_DB_SG='preview-presentation-db-sg'

INSTANCE_ID=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${INSTANCE_NAME} Name=instance-state-name,Values=running --query 'Reservations[0].Instances[0].InstanceId' --output text)

if [ "$INSTANCE_ID" = "None" ]; then
    echo "Couldn't find an instance tagged with Name = ${INSTANCE_NAME}"
    exit 1
fi

# revoke security group ingress hardcoded for now,
aws ec2 revoke-security-group-ingress --group-name "$MINT_DB_SG" --protocol tcp --port 5432 --source-group "$SG"
aws ec2 revoke-security-group-ingress --group-name "$PRESENTATION_DB_SG" --protocol tcp --port 5432 --source-group "$SG"

aws ec2 delete-tags --resources "${INSTANCE_ID}" --tags Key=Name

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
aws ec2 delete-security-group --group-name "$SG"
