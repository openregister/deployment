.PHONY: configure-state \
	purge-remote-state-cache \
	destroy \
	plan \
	plan-destroy \
	apply

# Default terraform plan -module-depth= value
module_depth:=-1

purge-remote-state-cache:
	rm -f .terraform/terraform.tfstate

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
