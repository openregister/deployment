.PHONY: all \
	check-for-local-state \
	configure-state \
	destroy \
	plan \
	plan-destroy

export expected_terraform_version:=v0.8
export actual_terraform_version:=$(shell terraform version | head -n 1 | cut -f2 -d" " | cut -d"." -f1,2)

ifneq ($(expected_terraform_version), $(actual_terraform_version))
  $(error Expected terraform version $(expected_terraform_version).x, but saw $(actual_terraform_version).x)
endif

export TF_VAR_central_cloudtrail_bucket_name:=$(or $(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/central-cloudtrail-bucket-name | tail -n 1), $(error "Couldn't get central cloudtrail bucket name"))

# Default terraform plan -module-depth= value
module_depth:=-1

# We don't want any local state being pushed when remote state is
# configured, so refuse to run if it exists.
check-for-local-state:
	@test ! -f terraform.tfstate || true

configure-state: check-for-local-state
	terraform remote config \
          -backend=S3 \
          -backend-config="bucket=registers-cloudtrail-terraform-state" \
          -backend-config="encrypt=true" \
          -backend-config="key=cloudtrail.tfstate" \
          -backend-config="region=eu-west-1"

plan: configure-state
	terraform plan -module-depth=$(module_depth)

plan-destroy: configure-state
	terraform plan -destroy -module-depth=$(module_depth)

apply: configure-state
	terraform apply

destroy: configure-state
	terraform destroy
