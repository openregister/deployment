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
