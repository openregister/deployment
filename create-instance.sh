#!/usr/bin/env bash

set -eu

usage() {
    echo "Usage: $0 <environment-name> <rds-instance-name>"
    echo ""
    echo "* Creates an EC2 instance, security group and route 53 entry for environment-name."
    echo "* Attaches IAM instance profile to the instance."
    echo "* Grants permissions for instance to access rds."
}

check_aws_profiles_exist() {
    AWS_PROFILES=$1
    for AWS_PROFILE in $AWS_PROFILES; do
        set +e
        aws --profile "$AWS_PROFILE" configure get region > /dev/null 2>/dev/null
        if [ $? -ne 0 ]; then
            echo "AWS profile ${AWS_PROFILE} not found"
            echo "Please run 'aws --profile ${AWS_PROFILE} configure' to set up this aws profile"
            exit 1
        fi
        set -e
    done
}

allow_access_to_sg_port() {
    SG=$1
    PORT=$2
    CIDR=$3
    aws ec2 authorize-security-group-ingress --group-name "$SG" --protocol tcp --port "$PORT" --cidr "$CIDR"
}

set_up_security_group() {
    SG=$1
    ENV=$2
    RESTRICTED_PORTS=$3
    PUBLIC_PORTS=$4
    DB_SG=$5

    AH=80.194.77.64/26
    ANYWHERE=0.0.0.0/0

    aws ec2 create-security-group --group-name "$SG" --description "security group for $ENV" > /dev/null
    for PORT in $RESTRICTED_PORTS; do
        allow_access_to_sg_port "$SG" "$PORT" "$AH"
    done
    for PORT in $PUBLIC_PORTS; do
        allow_access_to_sg_port "$SG" "$PORT" "$ANYWHERE"
    done

    # allow access to RDS instance
    aws ec2 authorize-security-group-ingress --group-name "$DB_SG" --protocol tcp --port 5432 --source-group "$SG"

}

create_instance_profile() {
    ROLE_NAME=$1

    aws iam create-role --role "${ROLE_NAME}" --assume-role-policy-document "{
      \"Version\": \"2012-10-17\",
      \"Statement\": [
        {
          \"Effect\": \"Allow\",
          \"Principal\": {
            \"Service\": [
              \"ec2.amazonaws.com\"
            ]
          },
          \"Action\": \"sts:AssumeRole\"
        }
      ]
    }" > /dev/null

    aws iam attach-role-policy --role-name "${ROLE_NAME}" \
        --policy-arn "arn:aws:iam::022990953738:policy/RegisterAppServer"

    aws iam put-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-name "PreviewIndexerConfigAccess" \
    --policy-document '{
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": [
                        "s3:GetObject"
                    ],
                    "Resource": [
                        "arn:aws:s3:::preview.config/indexer/indexer.properties"
                    ],
                    "Effect": "Allow"
                }
            ]
        }
    '

    aws iam put-role-policy \
    --role-name "${ROLE_NAME}" \
    --policy-name "PreviewConfigMintAccess" \
    --policy-document "{
    \"Version\": \"2012-10-17\",
    \"Statement\": [
        {
            \"Action\": [
                \"s3:GetObject\"
            ],
            \"Resource\": [
                \"arn:aws:s3:::preview.config/${ROLE_NAME}/mint/*\"
            ],
            \"Effect\": \"Allow\"
        }
    ]
}
"

    INSTANCE_PROFILE_NAME=$ROLE_NAME
    aws iam create-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}" > /dev/null

    aws iam add-role-to-instance-profile --instance-profile-name "${INSTANCE_PROFILE_NAME}" --role-name "${ROLE_NAME}"

}

create_instance() {
    ENV=$1
    SG=$2
    USER_DATA=$3
    IAM_ROLE=$4

    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id ami-a10897d6 \
        --count 1 \
        --instance-type t2.medium \
        --user-data "$USER_DATA" \
        --iam-instance-profile Name=${IAM_ROLE} \
        --security-groups "$SG" \
        --query 'Instances[0].InstanceId' \
        --output text)
    # The `Name` tag is special and shows up as the instance name column
    # in the ec2 console
    aws ec2 create-tags --resources "$INSTANCE_ID" --tags "Key=Name,Value=${ENV}" > /dev/null
    # the Environment tag controls where CodeDeploy will deploy to.
    aws ec2 create-tags --resources "$INSTANCE_ID" --tags "Key=Environment,Value=preview" > /dev/null

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
    DNS_PROFILES=$4
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

    for DNS_PROFILE in $DNS_PROFILES; do
        ZONE_ID=$(aws --profile "$DNS_PROFILE" route53 list-hosted-zones-by-name --dns-name "$ZONE" --query 'HostedZones[0].Id' --output text)

        aws --profile "$DNS_PROFILE" route53 change-resource-record-sets \
            --hosted-zone-id "$ZONE_ID" \
            --change-batch "$DNS_CHANGES"
    done
}


if [ "$#" -ne 2 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi


ENV=$1
RDS_INSTANCE_NAME=$2

INSTANCE_PROFILE_NAME=$ENV
SG=${ENV}-sg
USER_DATA_FILE=user-data.yaml
PG_PASSWORD=$(pwgen -s 20)
RESTRICTED_PORTS="22 4567"
PUBLIC_PORTS="80"
ZONE=openregister.org
DOMAIN=beta.${ZONE}
DNS_NAME=${ENV}.${DOMAIN}
DNS_PROFILES="old-dns default"
DB_SG=${RDS_INSTANCE_NAME}-db-sg

# ensure aws CLI is set up with needed profiles before continuing
check_aws_profiles_exist "$DNS_PROFILES"

create_instance_profile "$INSTANCE_PROFILE_NAME"

set_up_security_group "$SG" "$ENV" "$RESTRICTED_PORTS" "$PUBLIC_PORTS" "$DB_SG"

USER_DATA=$(sed -e "s/%PGPASSWD%/${PG_PASSWORD}/" "${USER_DATA_FILE}" | base64)

# it takes a while for the instance profile to be usable by create_instance, so pause a moment
sleep 5

PUBLIC_IP=$(create_instance "$ENV" "$SG" "$USER_DATA" "$INSTANCE_PROFILE_NAME")

create_dns_records "$DNS_NAME" "$ZONE" "$PUBLIC_IP" "$DNS_PROFILES"

echo "Instance launched at ${DNS_NAME}"

