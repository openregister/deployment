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

node_lambda_functions:=$(addprefix build/,$(addsuffix .zip,$(wildcard node/*)))

pingdom_user:=$(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/pingdom | tail -n1)
pingdom_password:=$(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/pingdom | head -n1)
pingdom_key:=$(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/pingdom/api | head -n1)

performance_platform_bearer_token:=$(shell PASSWORD_STORE_DIR=~/.registers-pass pass services/performance-platform | head -n1)

# Default terraform plan -module-depth= value
module_depth:=-1

purge-remote-state-cache:
	rm -f .terraform/terraform.tfstate

configure-state: purge-remote-state-cache
	terraform init

plan: configure-state $(node_lambda_functions)
	terraform plan -module-depth=$(module_depth)

plan-destroy: configure-state
	terraform plan -destroy -module-depth=$(module_depth)

apply: configure-state $(node_lambda_functions)
	terraform apply

destroy: configure-state
	terraform destroy

build/node/%.zip: node/%/lambda.js node/%/package.json
	mkdir -p $(dir $@)
	npm install --production --prefix $(dir $<)
	cd $(dir $<); zip -r ../../$@ $(notdir $<) node_modules/

node/cloudfront-logs-api-key-to-google-analytics/lambda.js: node/cloudfront-logs-api-key-to-google-analytics/cloudwatchlogs.js
	cp $< $@

node/log-api-key-to-cloudwatch/lambda.js: node/log-api-key-to-cloudwatch/log-api-key-to-cloudwatch.js
	cp $< $@

clean:
	rm -rf build/
	rm -rf node/*/node_modules/
	rm -rf node/*/lambda.js
	rm -rf python/*/venv
	rm -rf python/*/lambda.py
