# Getting started

## Prerequisites

### [awscli](http://aws.amazon.com/cli/) installed

On OSX you can install via brew:

	brew install awscli

### [ansible](http://www.ansible.com) installed

On OSX you can install via brew:

	brew install ansible

### [terraform](https://www.terraform.io) installed

On OSX you can install via brew:

	brew install terraform

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

## Preparing a new environment

### Ansible configuration

#### environment overrides

The `ansible/group_vars/all` file contains sensible defaults for your
environment.  However you will probably want to override at least the
`registers` and `register_domain` variables:

`vi ansible/group_vars/tag_Environment_<vpc>`

	registers:
	  - country
	  - other-register
	  - another-register
    
    register_domain: my-environment.openregister.org

### Terraform setup

Updating terraform module links:

	cd aws/registers
	terraform get

Preparing new environment (your CIDR block needs to be at least a `/16`):

	cd aws/registers
	make config -e vpc=<myenv> -e vpc_cidr_block=<cidr_subnet>/16

Using an existing environment

	cd aws/registers
	make pull-config -e vpc=<name>

Pushing local changes

	cd aws/registers
	make push-config -e vpc=<name>
	make push-state -e vpc=<name>

## Terraforming

### Executing a plan

with basic output

	cd aws/registers
	make plan -e vpc=myenv

or with detailed plan (optional)

	cd aws/registers
	make plan -e module_depth=1 -e vpc=myenv

### Applying changes

	cd aws/registers
	make apply -e vpc=myvpc

# Ad hoc tasks with ansible

The ansible/ directory contains some tasks for performing ad hoc
tasks.  In order to work with ansible, you'll need to do the
following:

Set up your ssh config to tunnel through the gateway:

    Host 172.xxx.* # replace with actual IP range
        ProxyCommand ssh gateway.<vpc-name>.openregister.org -W %h:%p

To run a single playbook (ping in this example):

    cd ansible
    ansible-playbook ping.yml -e vpc=<name> -f 1

(the ping command seems to timeout unless you explicitly run it
serially (`-f 1`))


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
