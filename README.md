# Getting started

This repository contains terraform code and adhoc ansible tasks for managing aspects of the [registers](https://registers.cloudapps.digital) infrastructure.

## Prerequisites

### [awscli](http://aws.amazon.com/cli/) and [ansible](http://www.ansible.com) installed

On OSX you can install via `virtualenv` and `pip`:

    virtualenv -p /usr/bin/python2.7 .venv
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

- There are 4 registers environments: `beta`, `alpha`, `discovery` and `test`.
- In each environment there are 2 register "groups": `basic` and `multi`.
- The `basic` group contains register, field and datatype registers.
- The `multi` group contains all other registers in that environment.

## How to create a new register in an existing environment

Step-by-step:

### 1. Add the new register to ansible configuration

Edit the `ansible/group_vars/tag_Environment_<vpc>` file and add the
register details to the `register_groups` and `register_settings` keys.

### 2. Create credentials for the new register

Create a new branch and generate credentials using the `ansible/generate_passwords.yml` playbook:

    cd ansible
    registers-pass git checkout -b create-new-register
    ansible-playbook generate_passwords.yml -e vpc=<myenv>

Check that the new password has been created and committed to the new branch, then push.
    
    registers-pass git log
    registers-pass git push -u origin create-new-register

Merge this to master then ensure your `registers-pass` is using latest master

    registers-pass git checkout master
    registers-pass git pull

### 3. Generate the application `paas-config.yaml`

The `ansible/upload_configs_to_s3.yml` file creates the application
config files (`pass-config.yaml`) required for each register in each environment.
The config files are written locally to `ansible/config/<myenv>` and
uploaded to S3 buckets. This ansible script consumes credentials via `registers-pass` and adds any 
new registers to the list of registers to be run by the application. When the application runs
it will pull the relevant `paas-config.yaml` file from S3.
If you want to test this script and not upload to S3 you can set `sync: false` in `upload_configs_to_s3.yml`. 

    cd ansible
    ansible-playbook upload_configs_to_s3.yml -e vpc=<myenv>

### 4. Add host to PaaS manifest file

Add a new `host` for the new register in the relevant openregister-java [manifest file](https://github.com/openregister/openregister-java/tree/master/deploy/manifests).
If you are creating a register that is none of register, field, or datatype, you must update the `deploy/manifests/<myenv>/multi.yml` file.

### 5. Deploy application to PaaS

Deploy the above change to the relevant environment via CodePipeline. Once complete, check you can access the new register.

    curl https://cloudapps.digital -H "Host: <myregister>.<myenv>.openregister.org"

### 6. Update terraform config

Fetch the latest `.tfvars` file from S3:

	cd aws/registers
	make pull-config -e vpc=<myenv>

Enable the register in the environment by adding the register to the
`enabled_registers` list in `environments/<myenv>.tfvars` and add an
appropriate `register` module resource in `registers.tf` (if it does not already exist).

### 7. Execute a terraform plan

You should expect terrafrom to plan to create a new Route 53 DNS record. For non-discovery registers it should also plan to create a new Pingdom availability check.

        cd aws/registers
        make plan -e vpc=<myenv>

### 8. Apply terraform changes

        cd aws/registers
        make apply -e vpc=<myenv>

### 9. Push local changes to terraform config

The terraform config file for each environment is not stored in Git but is
stored in S3. Any local changes made and applied should be pushed back to S3.
First check that the config hasn't changed since you last pulled:

        cd aws/registers
        make diff-config -e vpc=<name>

And then push if the previous task reports that the files are identical:

        make push-config -e vpc=<name>

You should now see the register at https://myregister.myenv.openregister.org.
If this is a beta register you should additionally be able to see it at https://myregister.register.gov.uk

### 10. Extra steps for beta

If you are creating a register in beta, you must follow [these additional steps](./docs/extra-steps-beta.md).

---

## How to create a register group in an existing environment

Edit `ansible/group_vars/tag_Environment_<myenv>` and add the new group to `register_groups`, 
including the register names that are part of this group.

Follow steps 2-3 above.

Create a new manifest file for [openregister-java](https://github.com/openregister/openregister-java)
at `deploy/manifests/<myenv>/<mygroup>.yml`. Add `hosts` for the registers in the new group.

Follow steps 4-9 above.

## How to create a new environment

Create a new `ansible/group_vars/tag_Environment_<vpc>` file and
customize it for the new environment.

Create a new `.tfvars` file for the environment at `aws/register/environments/<myenv>.tfvars`

You must also request a new SSL certificate in AWS Certficate Manager for the new environment. 
This certificate will require approval before it can be used. Bear in mind that only certain people 
can approve the creation of new certificates when creating a new environment.

Once approved, the ARN for the new certificate must then be added to the existing terraform configuration file as below.

`vi aws/register/environments/<myenv>.tfvars`

e.g.

    paas_cdn_certificate_arn = "arn:aws:acm:us-east-1:123456789:certificate/2f56a14e-4e61-4f03-b488-8e88d02d2146"

Then [plan and apply your terraform](#execute-a-terraform-plan) changes.

Then follow steps 1-9 above.

---

## Loading data to registers in existing phases from github

See [Loading or updating the data for a register](./scripts/readme.md#loading-or-updating-the-data-for-a-register).

# Updating the Register and Field registers

See [Loading a new field or register](./scripts/readme.md#loading-a-new-field-or-register).

## Licence

Unless stated otherwise, the codebase is released under [the MIT licence](./LICENSE).
