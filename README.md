# Getting started

## Prerequisites

### [awscli](http://aws.amazon.com/cli/) and [ansible](http://www.ansible.com) installed

On OSX you can install via `virtualenv` and `pip`:

    virtualenv .venv
    source .venv/bin/activate
    pip install -r ansible/requirements.txt

### [terraform](https://www.terraform.io) installed

On OSX you can install via `brew`, although you'll want to make sure you use the version defined in `aws/registers/Makefile`.

# Ad hoc tasks with ansible

The ansible/ directory contains some tasks for performing ad hoc
tasks.  In order to work with ansible, you'll need to do the
following:

Set up your ssh config to tunnel through the gateway:

    Host 172.xxx.* *.<vpc-name>.openregister # replace with actual IP range and VPC name
        ProxyCommand ssh gateway.<vpc-name>.openregister.org -W %h:%p

To run a single playbook (ping in this example):

    cd ansible
    ansible-playbook ping.yml -e vpc=<name> -f 1

(the ping command seems to timeout unless you explicitly run it
serially (`-f 1`))

# Bootstrapping

## Create an AWS access key

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

## System variables

* set AWS CLI variables:

		export AWS_REGION=eu-west-1
		export AWS_SECRET_KEY_ID=xxx
		export AWS_SECRET_ACCESS_KEY_ID=xxx

* or alternatively, you can use an awscli profile instead:

		export AWS_PROFILE=registers

## How to create a register in an existing environment with an existing register group

Step-by-step:

### Add configuration and credentials

Edit the `ansible/group_vars/tag_Environment_<vpc>` file and add the
register details to the `register_groups` and `register_settings` keys.

Generate credentials using the `ansible/generate_passwords.yml` playbook:

    ansible-playbook generate_passwords.yml -e vpc=<myenv>

[Regenerate application configuration for the register group which will host the new regsister](https://github.com/openregister/deployment#generate-application-config).
    
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
to users for any register in an environment that does not have the database set up.

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
alternative domain). Using the AWS CloudFront console, change each of the existing Beta CloudFront 
distributions to use the new certificate.

### Delete the old certificate

Rerun `make apply` at `aws/tls-certs` (as mentioned in the instructions [here](aws/tls-certs/README.md)) 
to delete the old certificate from IAM.

### Rotate SSL certificate for API Gateway

Use the AWS API Gateway console to rotate the SSL certificate. 
Go to Custom Domain Names then select the custom domain name called `register.gov.uk` and use the Rotate button to
add the new SSL certificate.

## Create CloudFront distribution

Create a CloudFront distribution for the new register. It should have an origin of `<myregister>.beta.openregister.org` and an alternate domain name of `<myregister>.register.gov.uk`.

## Create DNS record

Use the AWS Route53 console to create a new DNS record for `<myregister>.register.gov.uk` and ensure the Alias Target matches
the CloudFront distribution for `<myregister>.register.gov.uk`.

# Data loading

### Prerequisites

To load data, first make sure you have a recently-build [loader.jar](https://github.com/openregister/loader) available:

    pushd ../loader
    ./gradlew build
    popd
    
### Adding new data sets (if required)

	cd ansible
	vi roles/service_data/vars/data-sources.yml
    
### Executing a data load

Then run the playbook:

    cd ansible
    ansible-playbook mint_data.yml \
    	-e vpc=<name> \
    	-e registers=<name>
    
Alternatively, you can provide specify an array of registers to load by passing a JSON array to the `registers` variable:

    ansible-playbook mint_data.yml \
    	-e vpc=<name> \
    	-e registers='["country","territory","uk"]'

Or finally, import all registers defined for selected environment:

	cd ansible
	ansible-playbook mint_data.yml \
		-e vpc=<name> \
		-e @group_vars/tag_Environment_alpha

If your remote username is different (set in `.ssh/config`) you can set additional parameter `use_local_username` to false forcing ansible to use `.ssh/config`:

	cd ansible
	ansible-playbook mint_data.yml \
		-e vpc=<name> \
		-e registers=<name> \
		-e use_local_username=false
