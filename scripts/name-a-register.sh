#!/bin/bash
set -eu
set -o pipefail

usage()
{
  printf "usage: ./name-a-register.sh phase register description\ne.g. ./name-a-register.sh alpha country \"Countries recognised by the UK\""
}

# validation check number of args but other validation is done in python script
if [ $# -ne 2 ]; then
  echo "error: incorrect number of arguments"
  usage
  exit 1
fi

PHASE=$1
REGISTER=$2
DESCRIPTION=$3
echo "PHASE - $PHASE"
echo "REGISTER - $REGISTER"
echo "DESCRIPTION - $DESCRIPTION"

OPENREGISTER_BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
echo "OPENREGISTER_BASE - $OPENREGISTER_BASE"
source "$OPENREGISTER_BASE/deployment/scripts/includes/register-actions.sh"
PASSWORD_STORE_DIR=${PASSWORD_STORE_DIR:-~/.registers-pass}
PASSWORD=`pass $PHASE/app/mint/$REGISTER`

RSF=`python3 generate-system-key-rsf.py register-name "$DESCRIPTION"`
echo "RSF - $RSF"

echo -ne "$RSF" > $OPENREGISTER_BASE/tmp.rsf

load_rsf $REGISTER $PHASE $PASSWORD

rm $OPENREGISTER_BASE/tmp.rsf
