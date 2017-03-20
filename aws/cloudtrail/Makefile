.PHONY: all \
	configure-state \
	destroy \
	plan \
	plan-destroy

export TF_VAR_central_cloudtrail_bucket_name:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/central-cloudtrail-bucket-name | tail -n 1), $(error "Couldn't get central cloudtrail bucket name"))

# Default terraform plan -module-depth= value
module_depth:=-1

purge-remote-state-cache:
	rm -r .terraform/terraform.tfstate

configure-state: purge-remote-state-cache
	terraform init

plan: configure-state
	terraform plan -module-depth=$(module_depth)

plan-destroy: configure-state
	terraform plan -destroy -module-depth=$(module_depth)

apply: configure-state
	terraform apply

destroy: configure-state
	terraform destroy
