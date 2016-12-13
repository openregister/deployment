# Terraform configuration for Sumo Logic forwarders

## Prerequisites

You'll need [Node.js](https://nodejs.org/) and [Terraform](https://www.terraform.io/). You should install Terraform using the method described [here](https://github.com/openregister/deployment/blob/master/README.md#prerequisites). You can install Node.js with Homebrew:

```
brew install node
```

Sets up a Lambda task which monitors the S3 bucket that Cloudfront puts access logs in. It then anonymizes these logs and sends them to Sumo Logic.

Run a plan:

```
make plan
```

Review and apply changes:

```
make apply
```
