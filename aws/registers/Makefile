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
	diff-config \
	push-state

ifndef vpc
  $(error You must pass -e vpc=<name> switch)
endif

# Default AWS region
export AWS_DEFAULT_REGION:=eu-west-1

# RDS master passwords
export TF_VAR_openregister_database_master_password:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass $(vpc)/rds/openregister/master), $(error "Couldn't get RDS master password from pass"))

# Pingdom
export TF_VAR_pingdom_user:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/pingdom | tail -n 1), $(error "Couldn't get Pingdom username"))
export TF_VAR_pingdom_password:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/pingdom | head -n 1), $(error "Couldn't get Pingdom password"))
export TF_VAR_pingdom_api_key:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/pingdom/api | head -n 1), $(error "Couldn't get Pingdom API key"))

# Sumo Logic
export TF_VAR_sumologic_key:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/sumologic/$(vpc)/app-logs | tail -n 1), $(error "Couldn't get Sumo Logic key"))

# InfluxCloud
export TF_VAR_influxdb_password:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/influxcloud/telegraf | tail -n 1), $(error "Couldn't get InfluxCloud password"))

# Logit
export TF_VAR_logit_stack_id:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/logit | head -n 1), $(error "Couldn't get Logit stack id"))

# Required minimum to terraform
defaults:=-var-file=environments/$(vpc).tfvars

# Default terraform plan -module-depth= value
module_depth:=-1

# TODO should also reject defined-but-blank variable
ifndef TF_VAR_openregister_database_master_password
  $(error TF_VAR_openregister_database_master_password variable is required)
endif

purge-remote-state-cache:
	rm -f backend.tf
	rm -f .terraform/terraform.tfstate

configure-state: purge-remote-state-cache
	# Hack to make 0.8->0.9 upgrade easy. We should move to using Terraform State
	# Environments(?).
	#
	# https://www.terraform.io/docs/state/environments.html
	sed -e 's/{{environment}}/$(vpc)/' backend.tf.tmpl > backend.tf
	terraform init

pull-config:
	aws s3 cp s3://registers-terraform-config/$(vpc).tfvars environments/$(vpc).tfvars

push-config:
	aws s3 cp environments/$(vpc).tfvars s3://registers-terraform-config

diff-config:
	bash -c "diff --unified --report-identical-files environments/$(vpc).tfvars <(aws s3 cp s3://registers-terraform-config/$(vpc).tfvars -); exit 0"

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
