#!/usr/bin/env bash

set -eu

ENV=$1
SIZE_GB=5 # in Gb
INSTANCE_CLASS=db.t2.micro
DB_SG=${ENV}-db-sg
PG_USER=postgres
PG_PASSWORD=$(pwgen -s 20)

DB_SG_ID=$(aws ec2 create-security-group --group-name "$DB_SG" --description "RDS for $ENV" --query GroupId --output text)

aws rds create-db-instance \
    --db-instance-identifier "$ENV" \
    --allocated-storage "$SIZE_GB" \
    --db-instance-class "$INSTANCE_CLASS" \
    --no-publicly-accessible \
    --engine postgres \
    --engine-version 9.4.1 \
    --master-username "$PG_USER" \
    --master-user-password "$PG_PASSWORD" \
    --vpc-security-group-ids "$DB_SG_ID" \
    --no-multi-az

echo "instance ${ENV} created. master creds are user:${PG_USER}, password:${PG_PASSWORD}"
