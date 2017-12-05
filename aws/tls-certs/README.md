# Terraform scripts for TLS certification management

Having used the ansible scripts in ansible/letsencrypt.yml to
provision certs and keys, these terraform scripts will upload them to
the AWS certificate manager.

## Setup

Ensure you are in correct directory

    cd aws/tls-certs

Install modules

    terraform get

Run a plan

    make plan
    
Apply the changes

    make apply
    
This will fail the first time.  This is because the CloudFront distributions are not managed by Terraform :(

The new certificate will be created but the old one will not be destroyed as it is still in use.  

Make a note of the new Certificate ID, as you will need this for the next step, you can find this by running `aws iam list-server-certificates` and finding the item with latest `UploadDate`.

Now continue to [Rotate SSL certificate for CloudFront distributions](https://github.com/openregister/deployment#rotate-ssl-certificate-for-cloudfront-distributions)
