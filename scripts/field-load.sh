#!/bin/bash
set -e

echo "usage: ./scripts/field-load.sh [field] [phase]"
echo ""

FIELD=$1
PHASE=$2
echo "field: $FIELD"
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
PASSWORD=`PASSWORD_STORE_DIR=~/.registers-pass pass $PHASE/app/mint/field`

cd ../deployment

echo ""
echo "Downloading $PHASE field-records.json"
rm -f field-records.json
curl -sS https://field.$PHASE.openregister.org/records.json > field-records.json

echo ""
echo "Serialize field config tsv to $FIELD.rsf"
mkdir -p ./tmp
cp ../registry-data/data/$PHASE/field/$FIELD.yaml ./tmp
serializer yaml field-records.json tmp field -excludeRootHash > $FIELD.rsf

echo ""
echo -n "Load $FIELD data into $PHASE field register? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ; then
  echo ""
  echo "Loading $FIELD configuration to $PHASE field register"
  echo `cat $FIELD.rsf | curl -X POST -u openregister:$PASSWORD --data-binary @- https://field.$PHASE.openregister.org/load-rsf --header "Content-Type:application/uk-gov-rsf"`
fi

echo ""
echo "Removing temporary files"
rm tmp/$FIELD.rsf
rm $FIELD.rsf
rm field-records.json

echo ""
echo "Done!"
echo ""
