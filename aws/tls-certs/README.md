# Terraform scripts for TLS certification management

Having used the ansible scripts in ansible/letsencrypt.yml to
provision certs and keys, these terraform scripts will upload them to
the AWS certificate manager.

## Setup

Install modules

    terraform get

Run a plan

    make plan
    
Apply the changes

    make apply
    
This will fail the first time.  This is because the CloudFront distributions are not managed by Terraform :(

The new certificate will be created but the old one will not be destroyed as it is still in use.  You then have to go into the AWS console and manually update each CloudFront distribution to use the new certificate.

Once the update is complete, you can destroy the old certificate by running `make apply` again.
