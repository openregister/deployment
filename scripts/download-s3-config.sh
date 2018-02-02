#!/bin/bash
SCRIPT_HOME="$( dirname "${BASH_SOURCE[0]}" )"
aws s3 cp s3://openregister.discovery.config/multi/openregister/paas-config.yaml "$SCRIPT_HOME/config/paas-config.yaml"
