#!/bin/bash
set -eu
set -o pipefail

usage()
{
  echo -e "usage: ./update-custodian.sh phase register custodian\ne.g. ./update-custodian.sh alpha country \"Jane Doe\""
}

# validation check number of args but other validation is done in python script
if [ $# -lt 3 ]; then
  echo "error: not enough arguments"
  usage
  exit 1
fi

PHASE=$1
REGISTER=$2
CUSTODIAN=$3
echo "PHASE - $PHASE"
echo "REGISTER - $REGISTER"
echo "CUSTODIAN - $CUSTODIAN"

OPENREGISTER_BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
echo "OPENREGISTER_BASE - $OPENREGISTER_BASE"
source "$OPENREGISTER_BASE/deployment/scripts/includes/register-actions.sh"
PASSWORD_STORE_DIR=${PASSWORD_STORE_DIR:-~/.registers-pass}
PASSWORD=`pass $PHASE/app/mint/$REGISTER`

RSF=`python3 generate-system-key-rsf.py custodian "$CUSTODIAN"`
echo "RSF - $RSF"

echo -ne "$RSF" > $OPENREGISTER_BASE/tmp.rsf

load_rsf $REGISTER $PHASE $PASSWORD

rm $OPENREGISTER_BASE/tmp.rsf
