#!/bin/bash

echo "register: $1"
echo "phase: $2"

echo ""
echo "Downloading $2 field-records.json"
rm -f field-records.json
curl -sS https://field.$2.openregister.org/records.json > field-records.json

echo ""
[[ -e ../$1-data ]] || echo "cloning $1-data repo"
[[ -e ../$1-data ]] || (cd .. && git clone git@github.com:openregister/$1-data.git)
echo "../$1-data repo: checkout master && pull"
cd ../$1-data && git checkout master && git fetch origin && git pull

echo ""
echo "Get credentials for $2 $1"
[[ -e ../credentials ]] || echo "cloning credentials repo"
[[ -e ../credentials ]] || (cd .. && git clone git@github.com:openregister/credentials.git)
cd ../credentials && PASSWORD=`PASSWORD_STORE_DIR=~/.registers-pass pass $2/app/mint/$1`

echo ""
echo "Serialize tsv to $1.rsf"
cd ../deployment
if [[ -e ../$1-data/data/$2/$1/$1es.tsv ]]; then
  serializer tsv field-records.json ../$1-data/data/$2/$1/$1es.tsv $1 > $1.rsf
elif [[ -e ../$1-data/data/$2/$1/$1s.tsv ]]; then
  serializer tsv field-records.json ../$1-data/data/$2/$1/$1s.tsv $1 > $1.rsf
elif [[ -e ../$1-data/data/$2/$1/$1.tsv ]]; then
  serializer tsv field-records.json ../$1-data/data/$2/$1/$1.tsv  $1 > $1.rsf
fi

echo ""
echo -n "Delete existing $1 data from $2 register? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ; then
    echo ""
    echo "Deleting $1 data from $2"
    curl -X DELETE -u openregister:$PASSWORD https://$1.$2.openregister.org/delete-register-data
fi

echo ""
echo -n "Load $1 data into $2 register? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ; then
  echo ""
  echo "Loading $1 data to $2"
  echo `cat $1.rsf | sed 's/sha256/sha-256/' | curl -X POST -u openregister:$PASSWORD --data-binary @- https://$1.$2.openregister.org/load-rsf --header "Content-Type:application/uk-gov-rsf"`
fi

echo ""
echo "Removing temporary files"
rm $1.rsf
rm field-records.json

echo ""
echo "Done!"
echo ""
