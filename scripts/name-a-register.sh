#!/bin/bash
set -e

usage()
{
  echo -e "usage: ./name-a-register.sh phase register description\ne.g. ./name-a-register.sh alpha country \"Countries recognised by the UK\""
}

# validation check number of args but other validation is done in python script
if [ $# -lt 3 ]; then
  echo "error: not enough arguments"
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

TIME=`date +%Y-%m-%dT%H:%M:%SZ`
JSON="{\"register-name\":\"$DESCRIPTION\"}"
SHA256=`echo -n $JSON | shasum -a 256 | head -c 64`
PASSWORD=`PASSWORD_STORE_DIR=~/.registers-pass pass $PHASE/app/mint/$REGISTER`

RSF="add-item\t$JSON\nappend-entry\tsystem\tregister-name\t$TIME\tsha-256:$SHA256"
echo "RSF - $RSF"

echo -ne "$RSF" > $OPENREGISTER_BASE/tmp.rsf

load_rsf $REGISTER $PHASE $PASSWORD

rm $OPENREGISTER_BASE/tmp.rsf
