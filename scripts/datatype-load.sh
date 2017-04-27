#!/bin/bash
set -e

echo "usage: ./scripts/datatype-load.sh [datatype] [phase]"
echo ""

DATATYPE=$1
PHASE=$2
echo "datatype: $DATATYPE"
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
PASSWORD=`PASSWORD_STORE_DIR=~/.registers-pass pass $PHASE/app/mint/datatype`

cd ../deployment

echo ""
echo "Downloading $PHASE field-records.json"
rm -f field-records.json
curl -sS https://field.$PHASE.openregister.org/records.json > field-records.json

echo ""
echo "Serialize datatype config yaml to $DATATYPE.rsf"
mkdir -p ./tmp
cp ../registry-data/data/$PHASE/datatype/$DATATYPE.yaml ./tmp
serializer yaml field-records.json tmp datatype -excludeRootHash > $DATATYPE.rsf

echo ""
echo -n "Load $DATATYPE data into $PHASE datatype register? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ; then
  echo ""
  echo "Loading $DATATYPE configuration to $PHASE datatype register"
  echo `cat $DATATYPE.rsf | curl -X POST -u openregister:$PASSWORD --data-binary @- https://datatype.$PHASE.openregister.org/load-rsf --header "Content-Type:application/uk-gov-rsf"`
fi

echo ""
echo "Removing temporary files"
rm -f tmp/*.yaml
rm -f $DATATYPE.rsf
rm -f field-records.json

echo ""
echo "Done!"
echo ""
