#!/bin/bash
set -e
source ./includes/set-vars.sh
source ./includes/git-update.sh
source ./includes/slack-notify.sh
source ./includes/register-actions.sh

usage()
{
  echo "usage: ./readload-metadata-yaml.sh [field|register] [phase] [local|remote]"
}

# validation check number of args but other validation is done in python script
if [ $# -lt 3 ]; then
  echo "error: not enough arguments"
  usage
  exit 1
fi

REGISTER=$1
PHASE=$2
METADATA_SOURCE=$3
YAML="$OPENREGISTER_BASE/registry-data/data/$PHASE/$1"

update_registers_pass

update_data_repo "registry-data"

echo "converting $YAML to RSF"
if [ "$METADATA_SOURCE" = 'local' ]
then
  python3 $OPENREGISTER_BASE/deployment/scripts/rsfcreator.py $REGISTER $PHASE --yaml_dir $YAML --prepend_metadata --register_data_root $OPENREGISTER_BASE > $OPENREGISTER_BASE/tmp.rsf
else
  python3 $OPENREGISTER_BASE/deployment/scripts/rsfcreator.py $REGISTER $PHASE --yaml_dir $YAML --prepend_metadata > $OPENREGISTER_BASE/tmp.rsf
fi

PASSWORD=`PASSWORD_STORE_DIR=~/.registers-pass pass $PHASE/app/mint/$REGISTER`

delete_register $REGISTER $PHASE $PASSWORD

load_rsf $REGISTER $PHASE $PASSWORD

# rm $OPENREGISTER_BASE/tmp.rsf
