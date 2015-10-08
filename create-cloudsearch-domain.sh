#!/usr/bin/env bash

echo "This script has all the address fields and cloud search domain name hardcoded in it, it creates address and address-high-watermark domain for address register search"
ADDRESS_DOMAIN_NAME=address

aws cloudsearch create-domain --domain-name $ADDRESS_DOMAIN_NAME

#all address register fields are hard coded here for now
aws cloudsearch define-index-field --domain-name $ADDRESS_DOMAIN_NAME --name address --type text
aws cloudsearch define-index-field --domain-name $ADDRESS_DOMAIN_NAME --name area --type text
aws cloudsearch define-index-field --domain-name $ADDRESS_DOMAIN_NAME --name country --type text
aws cloudsearch define-index-field --domain-name $ADDRESS_DOMAIN_NAME --name latitude --type text
aws cloudsearch define-index-field --domain-name $ADDRESS_DOMAIN_NAME --name locality --type text
aws cloudsearch define-index-field --domain-name $ADDRESS_DOMAIN_NAME --name longitude --type text
aws cloudsearch define-index-field --domain-name $ADDRESS_DOMAIN_NAME --name postcode  --type text
aws cloudsearch define-index-field --domain-name $ADDRESS_DOMAIN_NAME --name property  --type text
aws cloudsearch define-index-field --domain-name $ADDRESS_DOMAIN_NAME --name street  --type text
aws cloudsearch define-index-field --domain-name $ADDRESS_DOMAIN_NAME --name town --type text

#policies contains the indexer's public ip and GDS local network ip address
aws cloudsearch update-service-access-policies --domain-name $ADDRESS_DOMAIN_NAME --access-policies '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "cloudsearch:*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": [
            "52.19.148.48",
            "80.194.77.64/26"
          ]
        }
      }
    }
  ]
}'

ADDRESS_WATERMARK_DOMAIN_NAME=address-high-watermark

aws cloudsearch create-domain --domain-name $ADDRESS_WATERMARK_DOMAIN_NAME

aws cloudsearch define-index-field --domain-name $ADDRESS_WATERMARK_DOMAIN_NAME --name serial_number --type int
aws cloudsearch define-index-field --domain-name $ADDRESS_WATERMARK_DOMAIN_NAME --name document_type --type text

#policies contains the indexer's public ip and GDS local network ip address
aws cloudsearch update-service-access-policies --domain-name $ADDRESS_WATERMARK_DOMAIN_NAME --access-policies '{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "cloudsearch:*",
      "Condition": {
        "IpAddress": {
          "aws:SourceIp": [
            "52.19.148.48",
            "80.194.77.64/26"
          ]
        }
      }
    }
  ]
}'
