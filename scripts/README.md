# Deployment scripts

This directory contains two types of script: [operate test and discovery
environments](../create-a-discovery-register-environment.md) and upload data
to the Open Register Java (ORJ) application.


## Introduction

The raw data for every GDS-hosted register is in Github:
https://github.com/openregister/registry-data

The data is stored as Register Serialisation Format (RSF), a plain text
line-based format that allows encoding data and metadata in a single file.

ORJ also expects a patch encoded as RSF when receiving an update request.

Previous versions used YAML and TSV in a repository-per-register approach with
the naming convention `{register-identifier}-data`. This is now deprecated in
favour of a single repository `registry-data`.


## Phases (environments)

A register can be deployed in different environments, currently the following
exist:

* `test`: For throwaway tests. E.g. `https://country.test.openregister.org`.
* `discovery`: Private feedback phase. E.g. `https://country.cloudapps.digital`.
* `alpha`: Public feedback phase. E.g. `https://country.alpha.openregister.org`.
* `beta`: Live phase. E.g. `https://country.beta.openregister.org`.


## Setup

### Dependencies

Before attempting to use any update operation, please ensure all dependencies
are correctly installed and set up in your machine.

* [Registers Credentials set up](https://github.com/openregister/credentials).
* Python 3.
* [Pipenv](https://pipenv.readthedocs.io/en/latest/).

Install the update dependencies:

```sh
pipenv install
```

## Getting started

The quickest way to get a sense of what is possible is to check the update
help:

```
pipenv run update --help
```


## Update operations

Note that in order to get any metadata change to appear on the frontend you
will need to [update register metadata on
registers-frontend](https://github.com/openregister/registers-frontend#updating-register-metadata).


### Add data to a register

The update CLI expects a TSV or a CSV, with a header row where each value is
the exact field name (i.e. identifier) and the rest of rows the the data to
upload.

```sh
pipenv update data --rsf=../registry-data/rsf/country.rsf \
  --phase=test ./new-data.tsv
```


### Change the register title

The name of a register is immutable because it is its unique ID. But the
register can also have a human-friendly text, the title, which can be updated
as follows:

```sh
pipenv run update context --rsf=../registry-data/rsf/country.rsf \
  --phase=test title "A list of countries recognised by the UK"
```

Check the context subcommand help for more details:

```sh
pipenv run update context --help
```


### Change the register description

```sh
pipenv run update context --rsf=../registry-data/rsf/country.rsf \
  --phase=test description "A list of countries recognised by the UK"
```

Check the context subcommand help for more details:

```sh
pipenv run update context --help
```


### Change the custodian name

```sh
pipenv run update context --rsf=../registry-data/rsf/country.rsf \
  --phase=test custodian "Jane Doe"
```

Check the context subcommand help for more details:

```sh
pipenv run update context --help
```


### Change a field description

```sh
pipenv run update schema --rsf=../registry-data/rsf/country.rsf \
  --phase=test start-date "The date the country was constituted"
```

Check the context subcommand help for more details:

```sh
pipenv run update schema --help
```


## Initial load

Once you have an empty ORJ register, you can do an initial load using an RSF
file.


Assuming there is an empty register in the test environment for the
`web-colour` register you can upload the register by:


```sh
pipenv run update init --phase=test ./web-colour.rsf
```


## The Field and Register registers


Instances of ORJ serving the Field and Register Registers read yaml files
containing fields and registers from S3 on startup.

There is an Ansible task in the deployment repo to generate the files in S3
from the application. You will need to run this after reloading the metadata
RSF.


## Development

The update CLI is in the `update` python package in this directory. It is
defined as a Pipenv script in `Pipenv`.

The logic around serialising/deserialising RSF and handling patches and
registers is in the `registers` python package part of the Registers CLI (See
https://github.com/openregister/registers-cli).


If you need to change how the `update` CLI handles the `pass` CLI, ORJ or the
CLI itself, start by familiarising yourself with `update/cli.py`.
