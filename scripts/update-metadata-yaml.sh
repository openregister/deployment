#!/bin/bash
set -e
OPENREGISTER_BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
echo "OPENREGISTER_BASE - $OPENREGISTER_BASE"

source "$OPENREGISTER_BASE/deployment/scripts/includes/set-vars.sh"
source "$OPENREGISTER_BASE/deployment/scripts/includes/git-update.sh"
source "$OPENREGISTER_BASE/deployment/scripts/includes/register-actions.sh"

usage()
{
  echo "usage: ./update-metadata-yaml.sh [register|field|datatype] [phase] [yaml file relative to root] [local|remote] [non-basic register]" 
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
NON_BASIC_REGISTER=$5

update_registers_pass

update_data_repo 'registry-data' 

echo "converting $YAML to RSF"
if [ "$METADATA_SOURCE" = 'local' ]
then
  python3 $OPENREGISTER_BASE/deployment/scripts/rsfcreator.py $REGISTER $PHASE --yaml $YAML --include_user_data --register_data_root $OPENREGISTER_BASE > $OPENREGISTER_BASE/tmp.rsf
else
  python3 $OPENREGISTER_BASE/deployment/scripts/rsfcreator.py $REGISTER $PHASE --yaml $YAML --include_user_data > $OPENREGISTER_BASE/tmp.rsf
fi

if [ -n "$NON_BASIC_REGISTER" ]; then
  ruby system_field_text_update.rb $OPENREGISTER_BASE/tmp.rsf
  PASSWORD=`PASSWORD_STORE_DIR=~/.registers-pass pass $PHASE/app/mint/$NON_BASIC_REGISTER`
  load_rsf $NON_BASIC_REGISTER $PHASE $PASSWORD
else
  PASSWORD=`PASSWORD_STORE_DIR=~/.registers-pass pass $PHASE/app/mint/$REGISTER`
  load_rsf $REGISTER $PHASE $PASSWORD
fi

rm $OPENREGISTER_BASE/tmp.rsf
