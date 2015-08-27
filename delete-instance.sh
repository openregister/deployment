#!/usr/bin/env bash

set -eu

usage() {
    echo "Usage: $0 instance-name"
    echo
    echo "Deletes an instance and its dependent objects"
}

if [ "$#" -ne 1 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi



INSTANCE_NAME=$1
SG=${INSTANCE_NAME}-sg
ZONE=openregister.org
DOMAIN=beta.${ZONE}
DNS_NAME=${INSTANCE_NAME}.${DOMAIN}
DNS_PROFILES="old-dns default"
TTL=300



INSTANCE_ID=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${INSTANCE_NAME} Name=instance-state-name,Values=running --query 'Reservations[0].Instances[0].InstanceId' --output text)

if [ "$INSTANCE_ID" = "None" ]; then
    echo "Couldn't find an instance tagged with Name = ${INSTANCE_NAME}"
    exit 1
fi

# remember public IP for DNS purposes
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "${INSTANCE_ID}" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)


# remove DNS records
ZONE_ID=$(aws route53 list-hosted-zones-by-name --dns-name openregister.org --query "HostedZones[0].Id" --output text)

# it's really hard to get this info via the API without parsing and
# sifting loads of JSON, so let's just make some heroic assumptions
# about TTL values
DNS_CHANGES=$(cat <<EOF
{"Changes":
  [{
    "Action":"DELETE",
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
    echo "Attempting to delete DNS record from ${DNS_PROFILE}"
    ZONE_ID=$(aws --profile "$DNS_PROFILE" route53 list-hosted-zones-by-name --dns-name "$ZONE" --query 'HostedZones[0].Id' --output text)

    aws --profile "$DNS_PROFILE" route53 change-resource-record-sets \
        --hosted-zone-id "$ZONE_ID" \
        --change-batch "$DNS_CHANGES" || true # don't bail if it fails
done

aws ec2 delete-tags --resources "${INSTANCE_ID}" --tags Key=Environment

# revoke security group ingress hardcoded for now,
MINT_DB_SG="preview-mint-db-sg"
aws ec2 revoke-security-group-ingress --group-name "$MINT_DB_SG" --protocol tcp --port 5432 --source-group "$SG"
PRESENTATION_DB_SG="preview-mint-db-sg"
aws ec2 revoke-security-group-ingress --group-name "$PRESENTATION_DB_SG" --protocol tcp --port 5432 --source-group "$SG"


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
