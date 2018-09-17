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

node_lambda_functions:=$(addprefix build/,$($(wildcard node/*)))
python_lambda_functions:=$(addprefix build/,$($(wildcard python/*)))

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

plan: configure-state $(node_lambda_functions) $(python_lambda_functions)
	terraform plan -module-depth=$(module_depth)

plan-destroy: configure-state
	terraform plan -destroy -module-depth=$(module_depth)

apply: configure-state $(node_lambda_functions) $(python_lambda_functions)
	terraform apply

destroy: configure-state
	terraform destroy

build/node/%: node/%/lambda.js node/%/package.json
	mkdir -p $(dir $@)
	npm install --production --prefix $(dir $<)

build/python/%: python/%/lambda.py
	mkdir -p $(dir $@)
	cp $< $@
	virtualenv --python=python3 $(dir $<)venv
	$(dir $<)venv/bin/pip install -r $(dir $<)requirements.txt
	cp -r $(dir $<)venv/lib/python3.6/site-packages/* $(dir $@)

clean:
	rm -rf build/
	rm -rf node/*/node_modules/
