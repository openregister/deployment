#!/usr/bin/env bash

set -eu

ENV=$1
SG=${ENV}-sg
USER_DATA_FILE=user-data.yaml
PG_PASSWORD=$(pwgen -s 20)
PORTS="22 4567"
ZONE=openregister.org
DOMAIN=beta.${ZONE}
DNS_NAME=${ENV}.${DOMAIN}
DNS_PROFILES="old-dns default"
TTL=300

# ensure aws CLI is set up with needed profiles
for DNS_PROFILE in $DNS_PROFILES; do
    set +e
    aws --profile "$DNS_PROFILE" configure get region > /dev/null 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "Please run 'aws --profile ${DNS_PROFILE} configure' to set up this aws profile"
        exit 1
    fi
    set -e
done

aws ec2 create-security-group --group-name "$SG" --description "security group for $ENV" > /dev/null
for PORT in $PORTS; do
    aws ec2 authorize-security-group-ingress --group-name "$SG" --protocol tcp --port "$PORT" --cidr 80.194.77.64/26
done
# allow port 80 from anywhere
aws ec2 authorize-security-group-ingress --group-name "$SG" --protocol tcp --port 80 --cidr 0.0.0.0/0

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
        --output text)
    [ -n "$PUBLIC_IP" ] && break
    tries=$[$tries+1]
done

# The `Name` tag is special and shows up as the instance name column
# in the ec2 console
aws ec2 create-tags --resources "$INSTANCE_ID" --tags "Key=Name,Value=${ENV}"

DNS_CHANGES=$(cat <<EOF
{"Changes":
  [{
    "Action":"CREATE",
    "ResourceRecordSet":{
      "Name":"${DNS_NAME}",
      "Type":"A",
      "ResourceRecords":[{"Value":"${PUBLIC_IP}"}],
      "TTL":${TTL}
    }
  }]
}
EOF
)

for DNS_PROFILE in $DNS_PROFILES; do
    ZONE_ID=$(aws --profile "$DNS_PROFILE" route53 list-hosted-zones-by-name --dns-name "$ZONE" --query 'HostedZones[0].Id' --output text)

    aws --profile "$DNS_PROFILE" route53 change-resource-record-sets \
        --hosted-zone-id "$ZONE_ID" \
        --change-batch "$DNS_CHANGES"
done

echo "Instance launched at ${DNS_NAME}"
