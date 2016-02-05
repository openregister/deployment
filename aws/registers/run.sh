#!/bin/bash

set -e

action="$1"
vpc="${TF_VPC:-$2}"

usage() {
cat <<EOT
Usage: $0 <action> <environment>

Actions:
  apply
  destroy
  plan

System Variables:
  TF_VPC=<environment>
  
EOT
exit 1
}

[ -z $action ] && usage
[ -z $vpc ] && usage

export PASSWORD_STORE_DIR=~/.registers-pass/
export TF_VAR_presentation_database_master_password=$(pass ${vpc}/rds/presentation/master)
export TF_VAR_mint_database_master_password=$(pass ${vpc}/rds/mint/master)

echo "Selected VPC: ${vpc}"

terraform $action -var-file=environments/${vpc}.tfvars -state=states/${vpc}.tfstate
