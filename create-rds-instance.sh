#!/usr/bin/env bash

set -eu

usage() {
    echo "Usage: $0 <instance-name> <vpc-name>"
    echo ""
    echo "* Creates an RDS instance and security group in VPC vpc-name."
}

if [ "$#" -ne 2 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi

NAME=$1
VPC=$2
INSTANCE_NAME=${VPC}-${NAME}
SIZE_GB=5 # in Gb
INSTANCE_CLASS=db.t2.micro
DB_SG=${INSTANCE_NAME}-db-sg
PG_USER=postgres
PG_PASSWORD=$(pwgen -s 20)
REGION=eu-west-1
ACCOUNT_NUMBER=022990953738

VPC_ID=$(aws ec2 describe-vpcs --filter Name=tag:Name,Values=${VPC} --query 'Vpcs[0].VpcId' --output text)

DB_SG_ID=$(aws ec2 create-security-group --group-name "$DB_SG" --vpc-id "$VPC_ID" --description "$VPC $NAME RDS" --query GroupId --output text)

case $VPC in
      prod)
          MULTI_AZ=true
          BACKUP_RETENTION_PERIOD=14
          ;;
      *)
          MULTI_AZ=false
	  BACKUP_RETENTION_PERIOD=1
          ;;
esac

aws rds create-db-instance \
    --db-instance-identifier "$INSTANCE_NAME" \
    --db-parameter-group-name "postgresrdsgroup-9-5-2" \
    --allocated-storage "$SIZE_GB" \
    --db-instance-class "$INSTANCE_CLASS" \
    --multi-az "$MULTI_AZ" \
    --backup-retention-period "$BACKUP_RETENTION_PERIOD" \
    --no-publicly-accessible \
    --engine postgres \
    --engine-version 9.5.2 \
    --master-username "$PG_USER" \
    --master-user-password "$PG_PASSWORD" \
    --db-subnet-group-name "$VPC" \
    --vpc-security-group-ids "$DB_SG_ID"

aws rds add-tags-to-resource --resource-name=arn:aws:rds:${REGION}:${ACCOUNT_NUMBER}:db:${INSTANCE_NAME} --tags Key=Environment,Value=${VPC} --region "$REGION"

echo "instance ${INSTANCE_NAME} created in ${VPC}. master creds are user:${PG_USER}, password:${PG_PASSWORD}"
