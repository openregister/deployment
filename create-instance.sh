#!/usr/bin/env bash

set -eu

usage() {
    echo "Usage: $0 <register-name> <environment>"
    echo ""
    echo "* Creates an EC2 instance, security group and route 53 entry for register-name"
    echo "  in the given environment."
    echo "* Attaches IAM instance profile to the instance."
    echo "* Grants permissions for instance to access rds."
}


if [ "$#" -ne 2 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi


REGISTER=$1
ENV=$2
INSTANCE_PROFILE_NAME=${ENV}-${REGISTER}

SG=${ENV}-${REGISTER}
USER_DATA_FILE=user-data.yaml
RESTRICTED_PORTS="22 4567"
PUBLIC_PORTS="80"
ZONE=openregister.org
MINT_DB_SG=${ENV}-mint-db-sg
PRESENTATION_DB_SG=${ENV}-presentation-db-sg

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

DNS_NAME=${REGISTER}.${DOMAIN}

MINT_SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${MINT_DB_SG}  --query 'SecurityGroups[0].GroupId' --output text)
PRESENTATION_SG_ID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=${PRESENTATION_DB_SG}  --query 'SecurityGroups[0].GroupId' --output text)

VPC_ID=$(aws ec2 describe-vpcs --filter Name=tag:Name,Values=${ENV} --query 'Vpcs[0].VpcId' --output text)
# There are multiple subnets but we don't actually care which one we use
SUBNET_ID=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=${VPC_ID} --query 'Subnets[0].SubnetId' --output text)


allow_access_to_sg_port() {
    PORT=$1
    CIDR=$2
    aws ec2 authorize-security-group-ingress --group-id "$SG_ID" --protocol tcp --port "$PORT" --cidr "$CIDR"
}

set_up_security_group() {
    RESTRICTED_PORTS=$1
    PUBLIC_PORTS=$2

    AH=80.194.77.64/26
    ANYWHERE=0.0.0.0/0

    SG_ID=$(aws ec2 create-security-group --group-name "$SG" --vpc-id "$VPC_ID" --description "security group for $REGISTER" --query 'GroupId' --output text)
    for PORT in $RESTRICTED_PORTS; do
        allow_access_to_sg_port "$PORT" "$AH"
    done
    for PORT in $PUBLIC_PORTS; do
        allow_access_to_sg_port  "$PORT" "$ANYWHERE"
    done

    # allow access to RDS instances
    aws ec2 authorize-security-group-ingress --group-id "$MINT_SG_ID" --protocol tcp --port 5432 --source-group "$SG_ID"
    aws ec2 authorize-security-group-ingress --group-id "$PRESENTATION_SG_ID" --protocol tcp --port 5432 --source-group "$SG_ID"

}

create_instance() {
    USER_DATA=$1

    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id ami-a10897d6 \
        --count 1 \
        --instance-type t2.micro \
        --user-data "$USER_DATA" \
        --iam-instance-profile Name=${INSTANCE_PROFILE_NAME} \
        --subnet-id "$SUBNET_ID" \
        --associate-public-ip-address \
        --security-group-ids "$SG_ID" \
        --query 'Instances[0].InstanceId' \
        --output text)
    # The `Name` tag is special and shows up as the instance name column
    # in the ec2 console
    aws ec2 create-tags --resources "$INSTANCE_ID" --tags "Key=Name,Value=${REGISTER}" > /dev/null
    # the Environment tag controls where CodeDeploy will deploy to.
    aws ec2 create-tags --resources "$INSTANCE_ID" --tags "Key=Environment,Value=${ENV}" > /dev/null

    tries=0
    PUBLIC_IP=
    # the instance won't immediately exist; this retry loop keeps trying
    # until we get the public ip or we've tried 5 times.
    until [ $tries -ge 5 ]; do
        sleep 5
        PUBLIC_IP=$(aws ec2 describe-instances \
            --instance-ids "${INSTANCE_ID}" \
            --query 'Reservations[0].Instances[0].PublicIpAddress' \
            --output text)
        [ -n "$PUBLIC_IP" ] && break
        tries=$[$tries+1]
    done
    if [ -z "$PUBLIC_IP" ]; then
        echo "Timed out waiting for instance $INSTANCE_ID to appear"
        exit 1
    fi
    echo $PUBLIC_IP
}

create_dns_records() {
    DNS_NAME=$1
    ZONE=$2
    PUBLIC_IP=$3
    TTL=300

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

    ZONE_ID=$(aws route53 list-hosted-zones-by-name --dns-name "$ZONE" --query 'HostedZones[0].Id' --output text)

    aws route53 change-resource-record-sets \
        --hosted-zone-id "$ZONE_ID" \
        --change-batch "$DNS_CHANGES"
}

./create-appserver-instance-profile.sh "$INSTANCE_PROFILE_NAME"

set_up_security_group "$RESTRICTED_PORTS" "$PUBLIC_PORTS"

USER_DATA=$(cat "${USER_DATA_FILE}" | base64)

# it takes a while for the instance profile to be usable by create_instance, so pause a moment
sleep 5

PUBLIC_IP=$(create_instance "$USER_DATA")

create_dns_records "$DNS_NAME" "$ZONE" "$PUBLIC_IP"

echo "Instance launched at ${DNS_NAME}"

