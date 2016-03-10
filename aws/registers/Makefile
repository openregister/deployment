.PHONY: all \
	apply \
	check-variables \
	check-for-local-state \
	config \
	configure-state \
	destroy \
	plan \
	plan-destroy \
	purge-remote-state-cache \
	pull-config \
	push-config \
	push-state

# Default AWS region
export AWS_DEFAULT_REGION=eu-west-1

# RDS master passwords
export TF_VAR_presentation_database_master_password=$(shell pass $(vpc)/rds/presentation/master)
export TF_VAR_mint_database_master_password=$(shell pass $(vpc)/rds/mint/master)

# Required minimum to terraform
defaults=-var-file=environments/$(vpc).tfvars

# Default terraform plan -module-depth= value
module_depth=-1

# We don't want any local state being pushed when remote state is
# configured, so refuse to run if it exists.
check-for-local-state: 
	@test ! -f terraform.tfstate || exit 1

check-variables:
ifndef vpc
  $(error You must pass -e vpc=<name> switch)
endif

ifndef TF_VAR_presentation_database_master_password
  $(error TF_VAR_presentation_database_master_password variable is required)
endif

ifndef TF_VAR_mint_database_master_password
  $(error TF_VAR_mint_database_master_password variable is required)
endif

purge-remote-state-cache: 
	rm -rf .terraform/terraform.tfstate

configure-state: check-variables check-for-local-state purge-remote-state-cache
	terraform remote config \
          -backend=S3 \
          -backend-config="bucket=registers-terraform-state" \
          -backend-config="encrypt=true" \
          -backend-config="key=$(vpc).tfstate" \
          -backend-config="region=$(AWS_DEFAULT_REGION)"

pull-config:
	aws s3 cp s3://registers-terraform-config/$(vpc).tfvars environments/$(vpc).tfvars

push-config:
	aws s3 cp environments/$(vpc).tfvars s3://registers-terraform-config

push-state:
	terraform remote push

plan: configure-state
	terraform plan $(defaults) -module-depth=$(module_depth)

plan-destroy: configure-state
	terraform plan -destroy $(defaults) -module-depth=$(module_depth)

apply: configure-state
	terraform apply $(defaults)

destroy: configure-state
	terraform destroy $(defaults)

config:
	cd ../../ansible && ansible-playbook generate_passwords.yml \
	  -e vpc=$(vpc)

	cd ../../ansible && ansible-playbook configure_terraform.yml \
	  -e vpc=$(vpc)
