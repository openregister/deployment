#!/bin/bash
set -e

echo ""
echo "usage:   ./scripts/data-load.sh [register] [phase] [data-tsv-file optional]"
echo "example: ./scripts/data-load.sh prison     discovery"
echo "example: ./scripts/data-load.sh local-authority-eng discovery ../local-authority-data/data/local-authority-eng/local-authorities.tsv"
echo ""

REGISTER=$1
PHASE=$2
DATA_FILE_PATH=$3
echo "REGISTER: $REGISTER"
echo "PHASE: $PHASE"

if [[ -e $DATA_FILE_PATH ]]; then
  TSVFILE=$DATA_FILE_PATH
  IFS='/'
  read -ra PARTS <<< "$DATA_FILE_PATH"
  DATA_REPO=${PARTS[1]}
else
  DATA_REPO="$REGISTER-data"
  if [[ -e "../$DATA_REPO/data/$PHASE" ]]; then
    TSVFILE="../$DATA_REPO/data/$PHASE/$REGISTER/$REGISTER"
  elif [[ -e "../$DATA_REPO/data" ]]; then
    TSVFILE="../$DATA_REPO/data/$REGISTER/$REGISTER"
  fi
  if [[ -e $TSVFILE"es.tsv" ]]; then
    TSVFILE=$TSVFILE"es.tsv"
  elif [[ -e $TSVFILE"s.tsv" ]]; then
    TSVFILE=$TSVFILE"s.tsv"
  elif [[ -e $TSVFILE".tsv" ]]; then
    TSVFILE=$TSVFILE".tsv"
  fi
fi

if [[ -e $TSVFILE ]]; then
  echo "DATA_REPO: $DATA_REPO"
  echo "TSVFILE: $TSVFILE"
else
  echo ""
  echo "Exiting as data file $TSVFILE not found"
  echo ""; exit 1
fi

REGISTER_URL="https://"$REGISTER"."$PHASE".openregister.org/records"

echo ""
echo "Downloading $PHASE field-records.json"
rm -f field-records.json
curl -sS https://field.$PHASE.openregister.org/records.json > field-records.json

echo ""
[[ -e ../$DATA_REPO ]] || echo "cloning $DATA_REPO repo"
[[ -e ../$DATA_REPO ]] || (cd .. && git clone git@github.com:openregister/$DATA_REPO.git)
echo "../$DATA_REPO repo: checkout master && pull"
cd ../$DATA_REPO && git checkout master && git pull --rebase

echo ""
echo "Get credentials for $PHASE $REGISTER"
[[ -e ~/.registers-pass ]] || echo "cloning credentials repo to ~/.registers-pass"
[[ -e ~/.registers-pass ]] || (cd ~ && git clone git@github.com:openregister/credentials.git .registers-pass)
PASSWORD=`PASSWORD_STORE_DIR=~/.registers-pass pass $PHASE/app/mint/$REGISTER`
SLACK_PATH=`PASSWORD_STORE_DIR=~/.registers-pass pass services/slack/rda-team-incoming-webhook`
USERNAME=`git config --get user.name`

echo ""
echo "Serialize tsv to $REGISTER.rsf"
cd ../deployment
if [[ -e $TSVFILE ]]; then
  echo "TSVFILE: $TSVFILE"
  serializer tsv field-records.json "$TSVFILE" $REGISTER > $REGISTER.rsf
else
  echo "Exiting as data file $TSVFILE not found"; exit 1
fi

echo ""
echo -n "Delete existing $REGISTER data from $PHASE register? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ; then
    echo ""
    echo "Slack: Deleting $REGISTER data from $PHASE $REGISTER"
    curl -X POST -H 'Content-type: application/json' \
      --data "{'text':'Deleting $REGISTER data from <$REGISTER_URL|$PHASE $REGISTER> - $USERNAME'}" \
      "https://hooks.slack.com/services/$SLACK_PATH"
    echo "Deleting $REGISTER data from $PHASE $REGISTER"
    for i in `seq 1 20`; do
        curl -X DELETE -u openregister:$PASSWORD https://$REGISTER.$PHASE.openregister.org/delete-register-data
        echo " - request: $i of 20"
    done

    echo ""
    echo "Testing consistency of instances"
    for i in `seq 1 20`; do
        REGISTER_PROOF=$(curl -s https://$REGISTER.$PHASE.openregister.org/proof/register/merkle:sha-256)
        if [[ $REGISTER_PROOF != *"sha-256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"* ]]; then
            echo "Root hash from one of the instances is not empty - exiting..."
            exit 1
        fi
    done
fi

echo ""
echo -n "Load $REGISTER data into $PHASE register? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ; then
  echo ""
  echo "Loading $REGISTER data to $PHASE"
  curl -X POST -H 'Content-type: application/json' \
    --data "{'text':'Loading $REGISTER data to <$REGISTER_URL|$PHASE $REGISTER> - $USERNAME'}" \
    "https://hooks.slack.com/services/$SLACK_PATH"
  echo `cat $REGISTER.rsf | curl -X POST -u openregister:$PASSWORD --data-binary @- https://$REGISTER.$PHASE.openregister.org/load-rsf --header "Content-Type:application/uk-gov-rsf"`
fi

echo ""
echo "Removing temporary files"
rm $REGISTER.rsf
rm field-records.json

echo ""
echo "Done! To view:"
echo ""
echo "open $REGISTER_URL"
echo ""
