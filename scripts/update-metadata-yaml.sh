#!/bin/bash
set -e
source ./includes/set-vars.sh
source ./includes/git-update.sh
source ./includes/slack-notify.sh
source ./includes/register-actions.sh

usage()
{
  echo "usage: ./update-metadata-yaml.sh [register|field] [phase] [yaml file relative to root] [local|remote]" 
}

# validation check number of args but other validation is done in python script
if [ $# -lt 4 ]; then
  echo "error: not enough arguments"
  usage
  exit 1
fi

REGISTER=$1
PHASE=$2
YAML="$OPENREGISTER_BASE/$3"
METADATA_SOURCE=$4

update_registers_pass

update_data_repo 'registry-data' 

echo "converting $YAML to RSF"
if [ "$METADATA_SOURCE" = 'local' ]
then
  python3 $OPENREGISTER_BASE/deployment/scripts/rsfcreator.py $REGISTER $PHASE --yaml $YAML --register_data_root $OPENREGISTER_BASE > $OPENREGISTER_BASE/tmp.rsf
else
  python3 $OPENREGISTER_BASE/deployment/scripts/rsfcreator.py $REGISTER $PHASE --yaml $YAML > $OPENREGISTER_BASE/tmp.rsf
fi

PASSWORD=`PASSWORD_STORE_DIR=~/.registers-pass pass $PHASE/app/mint/$REGISTER`

load_rsf $REGISTER $PHASE $PASSWORD

# rm $OPENREGISTER_BASE/tmp.rsf
