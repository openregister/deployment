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
If you are creating a register that is none of register, field, or datatype, you must update the manifests/<myenv>/multi.yml file.

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
If this is a beta register you will not see it at https://myregister.register.gov.uk until you follow step 10.

### 10. Extra steps for beta

If you are creating a register in beta, you must follow [these additional steps](#extra-steps-for-creating-a-new-beta-register).

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

Create a new `.tfvars` file for the environment:

    ansible-playbook configure_terraform.yml -e vpc=<myenv>

You must also request a new SSL certificate in AWS Certficate Manager for the new environment. 
This certificate will require approval before it can be used. Bear in mind that only certain people 
can approve the creation of new certificates when creating a new environment.

Once approved, the ARN for the new certificate must then be added to the existing terraform configuration file as below.

`vi aws/register/environments/<myenv>.tfvars`

	elb_certificate_arn = "arn:aws:acm:eu-west-1:022990953738:certificate/<abcde>"

Then [plan and apply your terraform](#execute-a-terraform-plan) changes.

Then follow steps 1-9 above.

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

Use the AWS CLI to rotate the SSL certificate.

Get the Certificate ARN by running. 
`aws acm list-certificates --region us-east-1`
and copy the ARN for `register.gov.uk`

Go to the root of `deployment` and run:
```
aws acm import-certificate --certificate file://${PWD}/tls-certs/beta/certificates/register.gov.uk.pem_00  --certificate-chain file://${PWD}//tls-certs/beta/certificates/register.gov.uk.pem_01 --private-key file://${PWD}/tls-certs/beta/certificates/register.gov.uk.key --certificate-arn arn:some-value --region us-east-1
```
replacing `arn:some-value` with the ARN from the previous step.

## Add credentials to managing-registers

Get the credentials from `registers-pass`
`registers-pass show beta/app/mint/$register-name`

Ensure you have the `RAILS_MASTER_KEY` environment variable set:
```
export RAILS_MASTER_KEY=`registers-pass show registers/app/manager/store`
```


From your `managing-registers` checkout directory run:
`rails secrets:edit`

Add credentials for new register

Commit changes to `config/secrets.yml.enc` to a branch

Raise a PR and merge to `master`

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

## Licence

Unless stated otherwise, the codebase is released under [the MIT licence](./LICENSE).
