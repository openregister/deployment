#!/usr/bin/env bash

set -eu

ENV=$1
SG=${ENV}-sg
USER_DATA_FILE=user-data.yaml
PG_PASSWORD=$(pwgen -s 20)
PORTS="22 80 4567"

aws ec2 create-security-group --group-name "$SG" --description "security group for $ENV" > /dev/null
for PORT in $PORTS; do
    aws ec2 authorize-security-group-ingress --group-name "$SG" --protocol tcp --port "$PORT" --cidr 80.194.77.90/32
    aws ec2 authorize-security-group-ingress --group-name "$SG" --protocol tcp --port "$PORT" --cidr 80.194.77.100/32
done

USER_DATA=$(sed -e "s/%PGPASSWD%/${PG_PASSWORD}/" ${USER_DATA_FILE} | base64)

INSTANCE_ID=$(aws ec2 run-instances \
    --image-id ami-a10897d6 \
    --count 1 \
    --instance-type t2.medium \
    --user-data "${USER_DATA}" \
    --security-groups "$SG" \
    --query 'Instances[0].InstanceId' \
    | tr -d '"')

# the instance won't immediately exist; this retry loop keeps trying
# until we get the public ip or we've tried 5 times.
PUBLIC_IP=
tries=0
until [ $tries -ge 5 ]; do
    sleep 5
    echo -n .
    PUBLIC_IP=$(aws ec2 describe-instances \
        --instance-ids "${INSTANCE_ID}" \
        --query 'Reservations[0].Instances[0].PublicIpAddress' \
        | tr -d '"')
    [ -n "$PUBLIC_IP" ] && break
    tries=$[$tries+1]
done

# The `Name` tag is special and shows up as the instance name column
# in the ec2 console
aws ec2 create-tags --resources "$INSTANCE_ID" --tags "Key=Name,Value=${ENV}"

echo "Instance launched at ${PUBLIC_IP}"
