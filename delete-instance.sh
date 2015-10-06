#!/usr/bin/env bash

set -eu

usage() {
    echo "Usage: $0 instance-name env"
    echo
    echo "Deletes an instance and its dependent objects from the given environment"
}

if [ "$#" -ne 2 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi



INSTANCE_NAME=$1
ENV=$2
SG=${ENV}-${INSTANCE_NAME}
SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${SG}  --query 'SecurityGroups[0].GroupId' --output text)

ZONE=openregister.org

case $ENV in
    preview)
        DOMAIN=preview.${ZONE}
        ;;
    prod)
        # eventually this will be plain ${ZONE} once we start
        # switching the alpha off
        DOMAIN=prod.${ZONE}
        ;;
    *)
        echo "Unrecognized environment: $ENV"
        usage; exit 1
        ;;
esac


DNS_NAME=${INSTANCE_NAME}.${DOMAIN}
TTL=300


INSTANCE_ID=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${INSTANCE_NAME} Name=tag:Environment,Values=${ENV} Name=instance-state-name,Values=running --query 'Reservations[0].Instances[0].InstanceId' --output text)

if [ "$INSTANCE_ID" = "None" ]; then
    echo "Couldn't find an instance tagged with Name = ${INSTANCE_NAME} and Environment = ${ENV}"
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

echo "Attempting to delete DNS record"
ZONE_ID=$(aws route53 list-hosted-zones-by-name --dns-name "$ZONE" --query 'HostedZones[0].Id' --output text)

aws route53 change-resource-record-sets \
    --hosted-zone-id "$ZONE_ID" \
    --change-batch "$DNS_CHANGES" || true # don't bail if it fails

# revoke security group ingress hardcoded for now
MINT_DB_SG="${ENV}-mint-db-sg"
MINT_SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${MINT_DB_SG}  --query 'SecurityGroups[0].GroupId' --output text)
aws ec2 revoke-security-group-ingress --group-id "$MINT_SG_ID" --protocol tcp --port 5432 --source-group "$SG_ID"
PRESENTATION_DB_SG="${ENV}-presentation-db-sg"
PRESENTATION_SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${PRESENTATION_DB_SG}  --query 'SecurityGroups[0].GroupId' --output text)
aws ec2 revoke-security-group-ingress --group-id "$PRESENTATION_SG_ID" --protocol tcp --port 5432 --source-group "$SG_ID"


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
