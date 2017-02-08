.PHONY: all \
	apply \
	check-for-local-state \
	configure-state \
	destroy \
	plan \
	plan-destroy \
	purge-remote-state-cache \
	push-state

# Default AWS region
export AWS_DEFAULT_REGION=eu-west-1

export expected_terraform_version=v0.8
export actual_terraform_version=$(shell terraform version | head -n 1 | cut -f2 -d" " | cut -d"." -f1,2)

ifneq ($(expected_terraform_version), $(actual_terraform_version))
  $(error Expected terraform version $(expected_terraform_version).x, but saw $(actual_terraform_version).x)
endif

# Default terraform plan -module-depth= value
module_depth=-1

# We don't want any local state being pushed when remote state is
# configured, so refuse to run if it exists.
check-for-local-state: 
	@test ! -f terraform.tfstate || true

purge-remote-state-cache: 
	rm -rf .terraform/terraform.tfstate

configure-state: check-for-local-state purge-remote-state-cache
	terraform remote config \
          -backend=S3 \
          -backend-config="bucket=registers-certs-terraform-state" \
          -backend-config="encrypt=true" \
          -backend-config="key=tls-certs.tfstate" \
          -backend-config="region=$(AWS_DEFAULT_REGION)"

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
