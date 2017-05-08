.PHONY: clean \
	all \
	check-for-local-state \
	configure-state \
	destroy \
	plan \
	plan-destroy

export expected_node_version:=v7.1.0
export actual_node_version:=$(shell node --version | head -n 1)

ifneq ($(expected_node_version), $(actual_node_version))
	$(error Expected node version $(expected_node_version), but saw $(actual_node_version))
endif

python_lambda_functions:=$(addprefix build/,$(addsuffix .zip,$(wildcard lambda/python/*)))
node_lambda_functions:=$(addprefix build/,$(addsuffix .zip,$(wildcard lambda/node/*)))

sumologic_cloudfront_key:=$(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/sumologic/cloudfront-logs)
sumologic_cloudtrail_key:=$(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/sumologic/cloudtrail-logs)

statuscake_username:=$(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/statuscake/api | tail -n1)
statuscake_key:=$(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/statuscake/api | head -n1)

performance_platform_bearer_token:=$(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/performance-platform | head -n1)

# Default terraform plan -module-depth= value
module_depth:=-1

purge-remote-state-cache:
	rm -f .terraform/terraform.tfstate

configure-state: purge-remote-state-cache
	terraform init

plan: configure-state $(python_lambda_functions) $(node_lambda_functions)
	terraform plan -module-depth=$(module_depth)

plan-destroy: configure-state
	terraform plan -destroy -module-depth=$(module_depth)

apply: configure-state $(python_lambda_functions) $(node_lambda_functions)
	terraform apply

destroy: configure-state
	terraform destroy

build/lambda/node/%.zip: lambda/node/%/lambda.js lambda/node/%/package.json
	mkdir -p $(dir $@)
	npm install --production --prefix $(dir $<)
	cd $(dir $<); zip -r ../../../$@ $(notdir $<) node_modules/

build/lambda/python/%.zip: lambda/python/%/lambda.py
	mkdir -p $(dir $@)
	virtualenv --python=python3 $(dir $<)venv
	$(dir $<)venv/bin/pip install -r $(dir $<)requirements.txt
	cd $(dir $<); zip ../../../$@ $(notdir $<)
	cd $(dir $<)venv/lib/python3.6/site-packages; zip -r ../../../../../../../$@ ./

lambda/node/cloudfront-s3-logs-to-sumologic/lambda.js: lambda/node/cloudfront-s3-logs-to-sumologic/cloudfront.js
	sed -e 's/<XXXX>/$(sumologic_cloudfront_key)/' $< > $@

lambda/node/cloudtrail-s3-logs-to-sumologic/lambda.js: lambda/node/cloudtrail-s3-logs-to-sumologic/cloudtrail.js
	sed -e 's/<XXXX>/$(sumologic_cloudtrail_key)/' $< > $@

lambda/python/statuscake-to-performance-platform/lambda.py: lambda/python/statuscake-to-performance-platform/performance_platform.py
	cp $< $@
	gsed -i 's/dummy_key/$(statuscake_key)/' $@
	gsed -i 's/dummy_username/$(statuscake_username)/' $@
	gsed -i 's/dummy_bearer/$(performance_platform_bearer_token)/' $@

clean:
	rm -rf build/
	rm -rf lambda/node/*/node_modules/
	rm -rf lambda/node/*/lambda.js
	rm -rf lambda/python/*/venv
	rm -rf lambda/python/*/lambda.py
