.PHONY: all \
	apply \
	check-variables \
	check-for-local-state \
	config \
	configure-state \
	destroy \
	plan \
	plan-destroy \
	pull-config \
	push-config \
	diff-config \
	push-state

ifndef vpc
  $(error You must pass -e vpc=<name> switch)
endif

# Default AWS region
export AWS_DEFAULT_REGION:=eu-west-1

# Pingdom
export TF_VAR_pingdom_user:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/pingdom | tail -n 1), $(error "Couldn't get Pingdom username"))
export TF_VAR_pingdom_password:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/pingdom | head -n 1), $(error "Couldn't get Pingdom password"))
export TF_VAR_pingdom_api_key:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/pingdom/api | head -n 1), $(error "Couldn't get Pingdom API key"))

# Viewer Request Lambda@Edge version number
export TF_VAR_api_key_to_cloudfront_logs_version_number:=$(or $(shell (cd ../lambda/ && terraform output api_key_to_cloudfront_logs_version_number) | sed 1q), $(error "Couldn't get API Key Lambda@Edge version number"))

# Origin Request Lambda@Edge version number
export TF_VAR_cloudfront_post_logger_version_number:=$(or $(shell (cd ../lambda/ && terraform output cloudfront_post_logger_version_number) | sed 1q), $(error "Couldn't get cloudfront_post_logger Lambda@Edge version number"))

# Required minimum to terraform
defaults:=-var-file=environments/$(vpc).tfvars

# Default terraform plan -module-depth= value
module_depth:=-1

configure-state:
	terraform init
	terraform workspace select $(vpc) || terraform workspace new $(vpc)

pull-config:
	aws s3 cp s3://registers-terraform-config/$(vpc).tfvars environments/$(vpc).tfvars

push-config:
	aws s3 cp environments/$(vpc).tfvars s3://registers-terraform-config

diff-config:
	bash -c "diff --unified --report-identical-files environments/$(vpc).tfvars <(aws s3 cp s3://registers-terraform-config/$(vpc).tfvars -); exit 0"

plan: configure-state
	terraform plan $(defaults) -module-depth=$(module_depth)

validate: 
	terraform validate $(defaults) 

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
