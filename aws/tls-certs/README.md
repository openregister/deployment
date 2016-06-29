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
    
The Makefile ensures you use the correct terraform remote state.
