.PHONY: clean \
	all \
	check-for-local-state \
	configure-state \
	destroy \
	plan \
	plan-destroy \
	push-state

export expected_terraform_version=v0.7
export actual_terraform_version=$(shell terraform version | head -n 1 | cut -f2 -d" " | cut -d"." -f1,2)

export expected_node_version=v7.1.0
export actual_node_version=$(shell node --version | head -n 1)

ifneq ($(expected_terraform_version), $(actual_terraform_version))
  $(error Expected terraform version $(expected_terraform_version).x, but saw $(actual_terraform_version).x)
endif

ifneq ($(expected_node_version), $(actual_node_version))
	$(error Expected node version $(expected_node_version), but saw $(actual_node_version))
endif

lambda_functions=$(addprefix build/,$(addsuffix .zip,$(wildcard lambda/*)))

sumologic_cloudfront_key=$(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/sumologic/cloudfront-logs)
sumologic_cloudtrail_key=$(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/sumologic/cloudtrail-logs)

# Default terraform plan -module-depth= value
module_depth=-1

# We don't want any local state being pushed when remote state is
# configured, so refuse to run if it exists.
check-for-local-state:
	@test ! -f terraform.tfstate || true

configure-state: check-for-local-state
	terraform remote config \
          -backend=S3 \
          -backend-config="bucket=registers-cloudfront-terraform-state" \
          -backend-config="encrypt=true" \
          -backend-config="key=cloudfront.tfstate" \
          -backend-config="region=eu-west-1"

plan: configure-state $(lambda_functions)
	terraform plan -module-depth=$(module_depth)

plan-destroy: configure-state
	terraform plan -destroy -module-depth=$(module_depth)

apply: configure-state $(lambda_functions)
	terraform apply

destroy: configure-state
	terraform destroy

build/lambda/%.zip: lambda/%/lambda.js lambda/%/package.json
	mkdir -p $(dir $@)
	npm install --production --prefix $(dir $<)
	cd $(dir $<); zip -r ../../$@ $(notdir $<) node_modules/

lambda/cloudfront-s3-logs-to-sumologic/lambda.js: lambda/cloudfront-s3-logs-to-sumologic/cloudfront.js
	sed -e 's/<XXXX>/$(sumologic_cloudfront_key)/' $< > $@


lambda/cloudtrail-s3-logs-to-sumologic/lambda.js: lambda/cloudtrail-s3-logs-to-sumologic/cloudtrail.js
	sed -e 's/<XXXX>/$(sumologic_cloudtrail_key)/' $< > $@

clean:
	rm -rf build/
	rm -rf lambda/*/node_modules/
	rm -rf lambda/*/lambda.js
