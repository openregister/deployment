# Terraform configuration for Registers Lambdas

## Prerequisites

* [Node.js](https://nodejs.org/) v7.1.0 (note if you have a different Node version, you can use [nvm](https://github.com/creationix/nvm) to use this version for this directory)
* [Terraform](https://www.terraform.io/). You should install Terraform using the method described [here](https://github.com/openregister/deployment/blob/master/README.md#prerequisites)
* `gsed` you can install this via Homebrew: `brew install gnu-sed`
* `python3` you can install this via Homebrew: `brew install python3`
* `virtualenv` you can install this via pip3: `pip3 install virtualenv`

## Using

Run a plan:

```
make plan
```

Review and apply changes:

```
make apply
```

## Running Lambdas Locally

### Setup
Install [aws-sam-cli](https://github.com/awslabs/aws-sam-cli) in a virtual environment:

```
python3 -m venv .venv/
source .venv/bin/activate
pip install -r requirements.txt
```

The lambdas are defined in `template.yml` files in the `node` and `python` subdirectories.

### Node lambdas
Run these commands from the `deployment/aws/lambda/node` directory.

Cloudfront POST request logger:
```
sam local invoke "CloudfrontPostLoggerFunction" --event ./cloudfront-post-logger/example_request.json
```

Cache invalidator:
```
sam local invoke "CacheInvalidatorFunction" --event ./cache-invalidator/example_event.json
```

API key request logger:
```
sam local invoke CloudfrontLogAPIKeyFunction -e log-api-key-to-cloudwatch/example.json
```

Send API key to Google Analytics:
```
sam local invoke CloudfrontLogsApiKeyToGoogleAnalyticsFunction -e cloudfront-logs-api-key-to-google-analytics/examples/logs-no-key.json
```

### Python lambdas
Run these commands from the `deployment/aws/lambda/python` directory:

Request log anonymiser:
```
TARGET_BUCKET=target-bucket-name sam local invoke LogAnonymiser -e log-anonymiser/put-bucket-event.json
```

Note that the bucket to read from is defined by the event json, so edit as appropriate.