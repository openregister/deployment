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
