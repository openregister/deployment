#!/bin/bash

# Set the discovery token
cp etcd.yml.template etcd.yml
curl https://discovery.etcd.io/new > discovery.token
grep "Unable to generate token" discovery.token
if [ $? != 1 ]; then
  echo Failed to generate discovery token.
  exit -1
fi
sed -i '' -e "s,#discovery: https://discovery.etcd.io/<token>,discovery: $(sed 's:/:\\/:g' discovery.token),"  etcd.yml

echo "Next steps: terraform plan"
