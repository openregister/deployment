#!/bin/bash

set -eu

usage() {
    echo "Usage: $0 <register-name> <environment> <optional-data-file-location> <optional-data-file-type>"
    echo ""
    echo "Launches a register in given environment with the provided name"
    echo "You must have setup credential repository on your machine before running the script"
    echo "You must run this script from deployment repository"
}


if [ "$#" -lt 2 ]; then
    echo "Wrong number of arguments"
    usage; exit
fi


REGISTER_NAME=$1
ENV=$2

BUCKET_NAME=openregister.$ENV.config

REGISTER_DB_NAME=${REGISTER_NAME//-/_}

CURRENT_WORKING_DIR=`pwd`

CONFIG_FILE_DIRECTORY=${CURRENT_WORKING_DIR}/register-configurations

INDEXER_CONFIG_LOCATION=/tmp/indexer.properties

export PASSWORD_STORE_DIR=~/.registers-pass

function createDatabaseAndUsers(){
  cd $PASSWORD_STORE_DIR

  BRANCH_NAME=adding_password_for_${ENV}_${REGISTER_NAME}

  pass git checkout -b $BRANCH_NAME

  sh create-mint-users.sh ${REGISTER_DB_NAME} ${ENV}

  pass git push origin $BRANCH_NAME
}


function prepareRegisterConfiguration(){

  cd $CURRENT_WORKING_DIR

  case $ENV in
      preview)
          RDS_MINT_END_POINT=preview-mint.ckm2jre98w8b.eu-west-1.rds.amazonaws.com
          RDS_PRESENTATION_END_POINT=preview-presentation.ckm2jre98w8b.eu-west-1.rds.amazonaws.com
          ;;
      prod)
          RDS_MINT_END_POINT=prod-mint.ckm2jre98w8b.eu-west-1.rds.amazonaws.com
          RDS_PRESENTATION_END_POINT=prod-presentation.ckm2jre98w8b.eu-west-1.rds.amazonaws.com
          ;;
      *)
          echo "Unrecognized environment: $ENV"
          usage; exit 1
          ;;
  esac

  MINT_USER_PASSWORD=`pass ${ENV}/rds/mint/${REGISTER_DB_NAME}`
  READ_ONLY_MINT_USER_PASSWORD=`pass ${ENV}/rds/mint/${REGISTER_DB_NAME}_readonly`
  PRESENTATION_USER_PASSWORD=`pass ${ENV}/rds/presentation/${REGISTER_DB_NAME}`
  READ_ONLY_PRESENTATION_USER_PASSWORD=`pass ${ENV}/rds/presentation/${REGISTER_DB_NAME}_readonly`


  REGISTER_CONFIG_DIRECTORY=$CONFIG_FILE_DIRECTORY/$REGISTER_NAME

  MINT_CONFIG_DIRECTORY=$REGISTER_CONFIG_DIRECTORY/mint

  PRESENTATION_CONFIG_DIRECTORY=$REGISTER_CONFIG_DIRECTORY/presentation

  mkdir -p $CONFIG_FILE_DIRECTORY $REGISTER_CONFIG_DIRECTORY $MINT_CONFIG_DIRECTORY $PRESENTATION_CONFIG_DIRECTORY


echo "database:
  driverClass: org.postgresql.Driver
  url: jdbc:postgresql://$RDS_MINT_END_POINT:5432/$REGISTER_DB_NAME
  user: $REGISTER_DB_NAME
  password: $MINT_USER_PASSWORD

  #db connection properties
  initialSize: 1
  minSize: 1
  maxSize: 4

  properties:
    charSet: UTF-8

server:
  applicationConnectors:
  - type: http
    port: 4567
" > $MINT_CONFIG_DIRECTORY/mint-config.yaml



echo "server:
  registerDefaultExceptionMappers: false

database:
  driverClass: org.postgresql.Driver
  url: jdbc:postgresql://$RDS_PRESENTATION_END_POINT:5432/$REGISTER_DB_NAME
  user: ${REGISTER_DB_NAME}_readonly
  password: ${READ_ONLY_PRESENTATION_USER_PASSWORD}

  #db connection properties
  initialSize: 1
  minSize: 1
  maxSize: 4

  properties:
    charSet: UTF-8
" > $PRESENTATION_CONFIG_DIRECTORY/config.yaml

  #Removing indexer/properties first so that we always use the file downloaded from s3
  rm -f $INDEXER_CONFIG_LOCATION

  aws s3 cp s3://$BUCKET_NAME/indexer/indexer.properties $INDEXER_CONFIG_LOCATION

  #Confirm that the file is successfuly downloaded from s3
  if [ ! -f $INDEXER_CONFIG_LOCATION ]; then
    exit 1
  fi

  echo "$REGISTER_NAME.source.postgres.db.connectionString=jdbc:postgresql://$RDS_MINT_END_POINT:5432/${REGISTER_DB_NAME}?user=${REGISTER_DB_NAME}_readonly&password=${READ_ONLY_MINT_USER_PASSWORD}" >> $INDEXER_CONFIG_LOCATION
  echo "$REGISTER_NAME.destination.postgres.db.connectionString=jdbc:postgresql://$RDS_PRESENTATION_END_POINT:5432/${REGISTER_DB_NAME}?user=${REGISTER_DB_NAME}&password=${PRESENTATION_USER_PASSWORD}" >> $INDEXER_CONFIG_LOCATION
}

function loadConfigurationToS3(){
  cd $CURRENT_WORKING_DIR
  aws s3 sync $CONFIG_FILE_DIRECTORY s3://$BUCKET_NAME
  aws s3 cp $INDEXER_CONFIG_LOCATION s3://$BUCKET_NAME/indexer/indexer.properties
  rm -f $INDEXER_CONFIG_LOCATION
}

function createEC2RegisterInstance(){
  cd $CURRENT_WORKING_DIR
  sh create-instance.sh $REGISTER_NAME $ENV
}

# run code deploy command to deploy the last artifact of an app in the given environment
function deployApp(){
  APP=$1
  DEPLOYMENT_GROUP_NAME=$2
  KEY=`aws deploy list-application-revisions --application-name ${APP}-app --sort-by registerTime --s-3-key-prefix ${APP}-master --s-3-bucket ${APP}.app.artifacts --sort-order descending --output text --query revisions[0].s3Location.key`
  ETAG=`aws deploy list-application-revisions --application-name ${APP}-app --sort-by registerTime --s-3-key-prefix ${APP}-master --s-3-bucket ${APP}.app.artifacts --sort-order descending --output text --query revisions[0].s3Location.eTag`

    case $ETAG in
        None)
            APP_DEPLOYMENT_ID=`aws deploy create-deployment  \
              --application-name ${APP}-app  \
              --deployment-group-name $ENV  \
              --deployment-config-name CodeDeployDefault.AllAtOnce \
              --output text \
              --query deploymentId \
              --revision "{
              \"revisionType\": \"S3\",
              \"s3Location\": {
                \"bucket\": \"${APP}.app.artifacts\",
                \"key\": \"$KEY\",
                \"bundleType\": \"zip\"
              }
            }"`
            ;;
        *)
            ETAG=`echo $ETAG | sed -e 's/"//g'`
            APP_DEPLOYMENT_ID=`aws deploy create-deployment  \
              --application-name ${APP}-app  \
              --deployment-group-name $ENV  \
              --deployment-config-name CodeDeployDefault.AllAtOnce \
              --output text \
              --query deploymentId \
              --revision "{
              \"revisionType\": \"S3\",
              \"s3Location\": {
                \"bucket\": \"${APP}.app.artifacts\",
                \"key\": \"$KEY\",
                \"bundleType\": \"zip\",
                \"eTag\": \"$ETAG\"
              }
            }"`
            ;;
    esac

  DEPLOYMENT_IN_PROGRESS="1"

  while [ $DEPLOYMENT_IN_PROGRESS -gt "0" ]; do
    echo "waiting 10 more seconds for deployments to complete"
    sleep 10s
    DEPLOYMENT_IN_PROGRESS=`aws deploy get-deployment --deployment-id $APP_DEPLOYMENT_ID --output text --query deploymentInfo.deploymentOverview.InProgress`
  done

  DEPLOYMENT_RESULT=`aws deploy get-deployment --deployment-id $APP_DEPLOYMENT_ID --output text --query deploymentInfo.deploymentOverview.Failed`

  if [ $DEPLOYMENT_RESULT -ne "0" ]; then
      echo "Deployment to ${APP} failed"
      exit 1
  else
      echo "Deployment to ${APP} completed successfully"
  fi
}

function grantReadOnlyUserAccess(){
  cd $PASSWORD_STORE_DIR

  sh grant-access-to-read-only-users.sh ${REGISTER_DB_NAME} ${ENV}
}

function loadRegisterData(){
  DATA_FILE_LOCATION=$1
  DATA_FILE_TYPE=$2

  cd $CURRENT_WORKING_DIR/../mint

  LOAD_DATA_RESULT_FILE=/tmp/loadDataResult.txt

  ./gradlew bulkLoad -PmintUrl=http://${REGISTER_NAME}.${ENV}.openregister.org:4567/load  -Ptype=${DATA_FILE_TYPE} -Pdatafile=${DATA_FILE_LOCATION} > $LOAD_DATA_RESULT_FILE

  BUILD_RESULT=`cat $LOAD_DATA_RESULT_FILE | grep 'BUILD SUCCESSFUL'`

  if [ "$BUILD_RESULT" != "BUILD SUCCESSFUL" ]; then
      echo "Loading data operation failed"
      exit 1;
  fi

}

createDatabaseAndUsers
prepareRegisterConfiguration
loadConfigurationToS3
createEC2RegisterInstance

deployApp mint $ENV
grantReadOnlyUserAccess

if [ "$#" -eq 4 ]; then
    DATA_FILE_LOCATION=$3
    DATA_FILE_TYPE=$4
    loadRegisterData ${DATA_FILE_LOCATION} ${DATA_FILE_TYPE}
fi

deployApp indexer $ENV
grantReadOnlyUserAccess
deployApp presentation $ENV



rm -rf $CONFIG_FILE_DIRECTORY
