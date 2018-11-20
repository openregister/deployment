#!/bin/bash
set -e

usage()
{
  echo -e "usage: ./delete-register.sh register phase\n N.B. this will only work on non-beta registers \n e.g. ./delete-register.sh country test"
}

if [ $# -ne 2 ]; then
  echo "error: incorrect number of arguments"
  usage
  exit 1
fi

source "./includes/register-actions.sh"
REGISTER=$1
PHASE=$2
PASSWORD=`PASSWORD_STORE_DIR=~/.registers-pass pass $PHASE/app/mint/$REGISTER`
delete_register $REGISTER $PHASE $PASSWORD
