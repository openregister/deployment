# Getting started

## Prerequisites

### [awscli](http://aws.amazon.com/cli/) installed

On OSX you can install via brew:

	brew install awscli

### [ansible](http://www.ansible.com) installed

On OSX you can install via brew:

	brew install ansible

### [terraform](https://www.terraform.io) 0.7 installed

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

## Preparing a new environment or register

A combination of the below steps are required if creating a new environment, 
creating a new register or adding an existing register to an existing environment for the first time.

### Ansible configuration environment overrides

The `ansible/group_vars/all` file contains sensible defaults for your
environment.  However you will probably want to override at least the
`registers` and `register_domain` variables:

`vi ansible/group_vars/tag_Environment_<vpc>`

	registers:
	  - country
	  - other-register
	  - another-register
    
    register_domain: my-environment.openregister.org

### Generate credentials

The `ansible/generate_passwords.yml` file generates passwords for new
registers in the [credentials](https://github.com/openregister/credentials) repository.

	registers-pass git checkout -b new-passwords
	cd ansible
	ansible-playbook generate_passwords.yml -e vpc=<myenv>

### Terraform config for a register

This is only required when creating a brand new register that
doesn’t already exist in any environment.
The `ansible/generate_terraform_register.yml` file creates the terraform
configuration files `aws/registers/register_<myregister>.tf` required to
configure a single register (across all environments).

	cd ansible
	ansible-playbook generate_terraform_register.yml -e registers='["register1","register2",...]'

Set the default instance count for the new register. This is the 
default number of instances of this register for all environments:

`vi aws/registers/variables.tf`

	variable "instance_count" {
	  default = {
	    “country” = 0
	    “other-register” = 0
	    “another-register” = 0
	  }
	}

### Terraform config for an environment

#### if creating a brand new environment:

The `ansible/configure_terraform.yml` file creates the terraform
configuration file `aws/registers/environments/<myenv>.tfvars` 
required to configure a single environment (your CIDR block needs to be
at least a `/16`).

	cd ansible
	ansible-playbook configure_terraform.yml -e vpc=<myenv> -e vpc_cidr_block=<cidr_subnet>/16

You must also request a new SSL certificate in AWS Certficate Manager for the new environment. 
This certificate will require approval before it can be used. Bear in mind that only certain people 
can approve the creation of new certificates when creating a new environment.

Once approved, the ARN for the new certificate must then be added to the existing terraform configuration file as below.

`vi aws/register/environments/<myenv>.tfvars`

	elb_certificate_arn = "arn:aws:acm:eu-west-1:022990953738:certificate/<abcde>"

#### if using an existing environment:

This downloads the latest configuration file for an existing environment
from S3 to `aws/registers/environments/<myenv>.tfvars` locally.

	cd aws/registers
	make pull-config -e vpc=<myenv>

#### terraform config environment overrides:

If creating a register in an environment, override the
instance count for the register in that environment.

`vi aws/registers/environments/<myenv>.tfvars`

	# instance_count
	instance_count = {
      # ... other registers
      country = 1
      other-register = 1
      another-register = 1
      # ... other registers
    }

### Update terraform module links

Skip this if you have not created any new `.tf` or `.tfvars` files.

	cd aws/registers
	terraform get

## Terraforming

### Executing a plan

	cd aws/registers
	make plan -e vpc=<myenv>

### Applying changes

	cd aws/registers
	make apply -e vpc=<myenv>

### Pushing local changes to terraform config

The terraform config and state files for each environment are not stored in Git but are
stored in S3. Any local changes made and applied should be pushed back to S3.

	cd aws/registers
	make push-config -e vpc=<name>
	make push-state -e vpc=<name>

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

## Data loading

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
    
Alternatively, you can provide specify an array of registers to load:

`cat registers-to-load.yaml`

	registers:
	  - country
	  - territory
	  - uk

And then run:

	cd ansible
	ansible-playbook mint_data.yml \
		-e vpc=<name> \
		-e @registers-to-load.yaml
	
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
