#!/bin/bash
set -e

echo "usage: ./scripts/registry-load.sh [register] [phase]"
echo ""

REGISTER=$1
PHASE=$2
echo "register: $REGISTER"
echo "phase: $PHASE"

echo ""
[[ -e ../registry-data ]] || echo "cloning registry-data repo"
[[ -e ../registry-data ]] || (cd .. && git clone git@github.com:openregister/registry-data.git)
echo "../registry-data repo: checkout master && pull"
cd ../registry-data && git checkout master && git pull --rebase

echo ""
echo "Get credentials for $PHASE registry data"
[[ -e ~/.registers-pass ]] || echo "cloning credentials repo to ~/.registers-pass"
[[ -e ~/.registers-pass ]] || (cd ~ && git clone git@github.com:openregister/credentials.git .registers-pass)
PASSWORD=`PASSWORD_STORE_DIR=~/.registers-pass pass $PHASE/app/mint/register`

cd ../deployment

echo ""
echo "Downloading $PHASE field-records.json"
rm -f field-records.json
curl -sS https://field.$PHASE.openregister.org/records.json > field-records.json

echo ""
echo "Serialize register config tsv to $REGISTER.rsf"
mkdir -p ./tmp
cp ../registry-data/data/$PHASE/register/$REGISTER.yaml ./tmp
echo "serializer yaml field-records.json tmp $REGISTER > $REGISTER.rsf"
serializer yaml field-records.json tmp register -excludeRootHash > $REGISTER.rsf

echo ""
echo -n "Load $REGISTER data into $PHASE register register? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ; then
  echo ""
  echo "Loading $REGISTER configuration to $PHASE register register"
  echo `cat $REGISTER.rsf | curl -X POST -u openregister:$PASSWORD --data-binary @- https://register.$PHASE.openregister.org/load-rsf --header "Content-Type:application/uk-gov-rsf"`
fi

echo ""
echo "Removing temporary files"
rm tmp/$REGISTER.yaml
rm $REGISTER.rsf
rm field-records.json

echo ""
echo "Done!"
echo ""
