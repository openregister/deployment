# Getting started

## Prerequisites

### [awscli](http://aws.amazon.com/cli/) installed

On OSX you can install via brew:

	brew install awscli

### [ansible](http://www.ansible.com) installed

On OSX you can install via brew:

	brew install ansible

# Bootstrapping

## System variables

* password store location:

		export PASSWORD_STORE_DIR=~/.register-pass

* set AWS CLI variables:

		export AWS_REGION=eu-west-1
		export AWS_SECRET_KEY_ID=xxx
		export AWS_SECRET_ACCESS_KEY_ID=xxx

* or alternatively, you can use an awscli profile instead:

		export AWS_PROFILE=registers

## Preparing a new environment

### Ansible configuration

#### defaults

`cat ansible/group_vars/all`

	registers:
	  - country
	  - datatype
	  - field
	  - public-body
	  - register

	register_domain: openregister.org
	pass_store_location: '~/.registers-pass'

#### environment overrides

> customising registers list

`vi ansible/group_vars/tag_Environment_<vpc>`

	registers:
	  - country
	  - other-register
	  - another-register

### Terraform setup

Preparing new environment

	cd aws/registers
	make config -e vpc=<myenv> -e vpc_cidr_block=<cidr_subnet>/16

## Terraforming

### Executing a plan

with basic output

	cd aws/registers
	make plan -e vpc=myenv

or with detailed plan

	cd aws/registers
	make plan -e module_depth=1 -e vpc=myenv

### Applying changes

	cd aws/registers
	make apply -e vpc=myvpc

