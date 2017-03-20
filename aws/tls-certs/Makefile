.PHONY: all \
	apply \
	configure-state \
	destroy \
	plan \
	plan-destroy \
	purge-remote-state-cache

# Default AWS region
export AWS_DEFAULT_REGION:=eu-west-1

# Default terraform plan -module-depth= value
module_depth:=-1

purge-remote-state-cache:
	rm -f .terraform/terraform.tfstate

configure-state: purge-remote-state-cache
	terraform init

plan: configure-state
	terraform plan $(defaults) -module-depth=$(module_depth)

plan-destroy: configure-state
	terraform plan -destroy $(defaults) -module-depth=$(module_depth)

apply: configure-state
	terraform apply $(defaults)

destroy: configure-state
	terraform destroy $(defaults)
