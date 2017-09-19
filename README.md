# Getting started

This repository contains terraform code and adhoc ansible tasks for managing aspects of the [registers](https://registers.cloudapps.digital) infrastructure.

## Prerequisites

### [awscli](http://aws.amazon.com/cli/) and [ansible](http://www.ansible.com) installed

On OSX you can install via `virtualenv` and `pip`:

    virtualenv .venv
    source .venv/bin/activate
    pip install -r ansible/requirements.txt

### [terraform](https://www.terraform.io) installed

On OSX you can install via `brew`, although you'll want to make sure you use the version defined in `aws/registers/Makefile`.

#### Terraform plugins

Install the [terraform-provider-pingdom](https://github.com/russellcardullo/terraform-provider-pingdom) plugin.

### Create an AWS access key

Log in to the AWS console, go to Identity and Access Management (IAM),
click on your user, click on "Security Credentials", and create a new
access key.

Run `aws configure` and save your access key and secret access key.
For default region, choose `eu-west-1`.  Now the aws cli will use your
access key for operations.

Create a file `aws/registers/terraform.tfvars` with the following content:

```
aws_access_key = "AKIA....."
aws_secret_key = "........."
```

This file is .gitignored and should not be checked in as it contains
secrets.  You may want to `chmod 600 terraform.tfvars` for safety too.

### System variables

* set AWS CLI variables:

		export AWS_REGION=eu-west-1
		export AWS_SECRET_KEY_ID=xxx
		export AWS_SECRET_ACCESS_KEY_ID=xxx

* or alternatively, you can use an awscli profile instead:

		export AWS_PROFILE=registers

### Set up `registers-pass`

The registers team maintains a [credentials store](https://github.com/openregister/credentials/). 
You must be able to decrypt and create passwords using the command `registers-pass`. This command
is used by some of the adhoc ansible commands required to set up register deployments. Follow 
the [instructions](https://github.com/openregister/credentials/README.md) to set this up.

# Deploying registers infrastructure

## How to create a register in an existing environment with an existing register group

Step-by-step:

### Add configuration and credentials

Edit the `ansible/group_vars/tag_Environment_<vpc>` file and add the
register details to the `register_groups` and `register_settings` keys.

Generate credentials using the `ansible/generate_passwords.yml` playbook:

    ansible-playbook generate_passwords.yml -e vpc=<myenv>

Follow the steps on [running the registers application](https://github.com/openregister/deployment#running-the-registers-application).

### Update terraform

Fetch the latest `.tfvars` file from S3:

	cd aws/registers
	make pull-config -e vpc=<myenv>

Enable the register in the environment by adding the register to the
`enabled_registers` list in `environments/<myenv>.tfvars` and add an
appropriate `register` module resource in `registers.tf`. Pay close attention
to the `load_balancer` argument which specifies which register group the
register is part of.

Then [plan and apply your terraform](#terraforming) code.

## How to create a register group in an existing environment

- Duplicate an existing `register_group_*.tf` configuration and edit appropriately.
- Specify the `group_instance_count` in `environments/<myenv>.tfvars`.

Additionally, by creating a new register group, you will need to create a new 
database and user, per environment. To do this:
- Update application config files by running `ansible/upload_configs_to_s3.yml` playbook.
- Create a new database using `ansible/create_databases.yml` playbook.
- Generate credentials via the `ansible/generate_passwords.yml` playbook

Then [plan and apply your terraform](#terraforming) code.

## How to create a new environment

Step by step:

### Add configuration and credentials

Create a new `ansible/group_vars/tag_Environment_<vpc>` file and
customize it for the new environment.

Generate credentials using the `ansible/generate_passwords.yml` playbook:

    ansible-playbook generate_passwords.yml -e vpc=<myenv>
    
### Set up and run terraform

Create a new `.tfvars` file for the environment:

    ansible-playbook configure_terraform.yml -e vpc=<myenv>

You must also request a new SSL certificate in AWS Certficate Manager for the new environment. 
This certificate will require approval before it can be used. Bear in mind that only certain people 
can approve the creation of new certificates when creating a new environment.

Once approved, the ARN for the new certificate must then be added to the existing terraform configuration file as below.

`vi aws/register/environments/<myenv>.tfvars`

	elb_certificate_arn = "arn:aws:acm:eu-west-1:022990953738:certificate/<abcde>"

Then run terraform (see next section).

## Terraforming

### Executing a plan

	cd aws/registers
	make plan -e vpc=<myenv>

### Applying changes

	cd aws/registers
	make apply -e vpc=<myenv>

### Pushing local changes to terraform config

The terraform config file for each environment is not stored in Git but is
stored in S3. Any local changes made and applied should be pushed back to S3.
First check that the config hasn't changed since you last pulled:

	cd aws/registers
	make diff-config -e vpc=<name>

And then push if the previous task reports that the files are identical:

	make push-config -e vpc=<name>

# Running the registers application

## Start the registers application

### Generate application config

#### config.yaml

The `ansible/upload_configs_to_s3.yml` file creates the application 
config files required for each register in each environment.
The config files are written locally to `ansible/config/<myenv>` and
uploaded to S3 buckets.

	cd ansible
	ansible-playbook upload_configs_to_s3.yml -e vpc=<myenv>

#### registers and fields configuration

There are files `registers.yaml` and `fields.yaml` which need to be
created/updated for each environment in the S3 bucket for that
environment.  Make any required changes to the
[registry-data](https://github.com/openregister/registry-data)
repository, load this data into the register register and field
register for that environment, and use this ansible command to
create/update the config files from the registers:

	cd ansible
	ansible-playbook refresh_register_field_config_in_s3.yml -e vpc=<myenv>

### Create databases

The `ansible/create_databases.yml` file creates the database, creates users and grants permissions 
to users for any register group in an environment that does not have the database set up.

	cd ansible
	ansible-playbook create_databases.yml -e vpc=<myenv>

### Deploy registers application

Deploy the registers application using CodeDeploy.

# Extra steps for creating a new Beta register

Ignore these if you are creating a register in an environment other than Beta.

## SSL certificates

### Create the certificate

Create a new SSL certificate using LetsEncrypt that includes <myregister>.register.gov.uk as an alternative domain.
Create the new certificate using the `ansible/letsencrypt.yml` using the [instructions](ansible/README.md)

### Upload the new certificate to IAM

Upload the new certificate to IAM using terraform. Follow the instructions [here](aws/tls-certs/README.md).

### Rotate SSL certificate for CloudFront distributions

Each Beta register has a CloudFront distribution. These will be using the old certificate (without the `<myregister>.register.gov.uk` 
alternative domain). You need to update the certificate for each of the CloudFront distributions. Do this by updating `cdn_configuration.certificate_id` in `aws/registers/environments/beta.tfvars`. Then apply the changes using terraform.

	cd aws/registers
	make plan -e vpc=beta
	make apply -e vpc=beta

### Delete the old certificate

Rerun `make apply` at `aws/tls-certs` (as mentioned in the instructions [here](aws/tls-certs/README.md)) 
to delete the old certificate from IAM.

### Rotate SSL certificate for API Gateway

Use the AWS API Gateway console to rotate the SSL certificate. 
The AWS Console for API Gateway has changed recently and it is only possible to use certificates stored 
in AWS Certificate Manager in the US East (N. Virginia) `us-east-1` for a Custom Domain Name. Using
the Certificate Manager console (in the US East (N. Virginia) region) reimport the certificate with domain
name `register.gov.uk`. 

# Data loading via HTTP

## When promoting a register from alpha -> beta (or discovery -> alpha)

When promoting a register to a new phase we must make sure we copy the exact data
that was approved in the previous phase. I.e. if promoting from alpha to beta, we must
copy the data via RSF from the alpha register to the new beta register.

	curl https://{register}.alpha.openregister.org/download-rsf | curl -X POST @- -u user:pswd https://{register}.alpha.openregister.org/load-rsf --header "Content-Type:application/uk-gov-rsf"

However, new field and register register data must be loaded from github using the scripts below.

## Loading data to registers in existing phases from github

To reload data into existing register via HTTP, you can run this script passing
the register name and the phase name, you will be prompted if you want to delete
data and if you want to load data, eg:

    ./scripts/data-load.sh prison discovery

The script looks in parent directory for a data repo, changes it to master
branch, and git pulls to ensure master data is used. Script assumes data is in
../[register]-data/data/[phase]/[register].tsv file. For example:
../prison-data/data/discovery/prison.tsv

To load a register entry into the `register` register, you can run this script
passing the register name, you will be prompted if you want to load data. For
example:

    ./scripts/register-load.sh prison discovery

To load a field entry into the `field` register, you can run this script
passing the field name, you will be prompted if you want to load data. For
example:

    ./scripts/field-load.sh start-date discovery

These last two scripts look for the yaml configuration of the register or field
in the `registry-data` repository.

