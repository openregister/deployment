### Introduction

The raw data for registers is in github. Mostly its in the form of TSV but some is in the form of Yaml files.
We assume you have checked out the relevant Git repos into **[some path]/openregister/** which we will refer to as
**$OPENREGISTER_ROOT**

Data is loaded into the Open Register java application in a special format called Register Serialization Form (RSF)

### Register and Fields definitions

These metadata registers are in the **registry-data** repo in a directory structure like this:

    $ROOT/openregister/registry-data/data/$PHASE/register/

    $ROOT/openregister/registry-data/data/$PHASE/field/

where $PHASE is test, discovery, alpha or beta

Within those directories the definitions of individual fields or registers are in separate YAML files.

This repo also contains files like

    $ROOT/openregister/registry-data/data/$PHASE/$REGISTER/meta.yaml

These contain additional metadata about the register. Each key corresponds to system entries stored in the register, for example "register-name".

We intend to keep this github repository in sync with the actual registers until we have a way to archive register data. You can check that the data matches up by running

    GITHUB_OAUTH_TOKEN=<github personal access token> python3 validate_metadata.py

(the github token is used to avoid rate limits)

### Register data

Mostly the register data can be found in a file at this location:

    $ROOT/openregister/$REGISTER-data/data/$PHASE/$REG.tsv

However the naming of the files is not completely consistent.

### Prerequisites

- the **pass** application must be installed and you must have the required GPG key to access
  the credentails in the regesters-pass repo
- python3
- pip3
- load required packages with


    pip3 install -r requirements.txt


### Loading or updating the data for a register

Running the script **load-register-tsv.sh** will create an RSF file for the specified register, of either system, user or all data, optionally delete the existing
register from ORJ in the specified **phase** and load the RSF into the application.

Arguments:
- register name
- phase
- TSV file path (relative to $OPENREGISTER_ROOT)
- `system`, `user` or `all`, depending on the type of data to be loaded
- local or remote depending on whether register and field definitions is to be read from the local file system or a remote ORJ service.
- data directory (relative to $OPENREGISTER_ROOT) if data is not in $REGISTER-data [optional].

Examples:

    ./load-register-tsv.sh country alpha country-data/data/country/country.tsv all local .

### Loading a new field, register or datatype

Running the script **update-metadata-yaml.sh** will create an RSF file for the specified new field or register and load the RSF into the application.

Arguments:
- basic register to be updated one of `field`, `datatype` or `register`
- phase
- YAML file path (relative to $OPENREGISTER_ROOT)
- local or remote depending on whether register and field definitions is to be read from the local file system or a remote ORJ service.

Examples:

    ./update-metadata-yaml.sh field beta registry-data/data/beta/field/clinical-commissioning-group.yaml local
    ./update-metadata-yaml.sh register beta registry-data/data/beta/register/clinical-commissioning-group.yaml local


### Re-loading the field, register and datatype registers

Running the script **load-metadata-yaml.sh** will create an RSF file for the field, register or datatype register, of either system, user or all data, optionally delete the existing register from ORJ in the specified **phase** and load the RSF into the application.

Arguments:
- `register`, `field` or `datatype` depending on the register to be updated
- phase
- `system`, `user` or `all`, depending on the type of data to be loaded
- local or remote depending on whether register and field definitions is to be read from the local file system or a remote ORJ service

Examples:

    ./load-metadata-yaml.sh field alpha all local 

    #### Warning

    Instances of ORJ serving the Field and Register Registers read files containing fields and registers YAML from S3 on startup.

    There is an Ansible task in the deployment repo to generate the files in S3 from the application. You will need to run this after reloading the metadata RSF.

### Naming a register with a human-friendly name

The name of a register is immutable because it is its unique ID.  But the
register can also have a human-readable name, or 'register-name' defined in
`registry-data/data/{phase}/{register}/meta.yaml`.  You can also set/change it
with the `scripts/name-a-register.sh` script.

```sh
./name-a-register.sh alpha country "A list of countries recognised by the UK"
```

Note: in order to get this change to appear on the frontend you will need to [update register metadata on registers-frontend](https://github.com/openregister/registers-frontend#updating-register-metadata) 

### Changing the description of a register

There is a script in `scripts/update_descriptions.py` to generate RSF to change the description of a register.

Run this using:

```
register=jobcentre-district
desc='bla bla bla bla bla bla'

python3 update_descriptions.py $register $desc
```

Then check that the RSF looks correct.

To actually load the RSF, pipe the output to `rsf-load.sh`:

```
python3 update_descriptions.py $register $desc | ./rsf-load.sh "https://${register}.beta.openregister.org" openregister `registers-pass beta/app/mint/$register` < ${register}_update.rsf
```

This example assumes that the register is in beta.

Note: in order to get this change to appear on the frontend you will need to [update register metadata on registers-frontend](https://github.com/openregister/registers-frontend#updating-register-metadata) 

#### Changing both the register name and description

You can change the name and description of a register in one step:

```
register=country
name="Country register"
desc="British English names of all countries currently recognised by the UK government"

# Preview the generated RSF
python3 update_name_and_description.py "$register" "$name" "$desc"

# Load the RSF
python3 update_name_and_description.py "$register" "$name" "$desc" | ./rsf-load.sh "https://${register}.beta.openregister.org" openregister `registers-pass beta/app/mint/$register`
```

Note: in order to get this change to appear on the frontend you will need to [update register metadata on registers-frontend](https://github.com/openregister/registers-frontend#updating-register-metadata) 

#### Adding new user entries to a Beta register
* Prepare a TSV file containing only user entries to be added
* Assuming the TSV file is called `update.tsv` and is in `$OPENREGISTER_ROOT` and register to be updated is `country` run:  
```
./load-register-tsv.sh country beta update.tsv user local .
```
* When prompted if you want to *Delete existing register data* enter `n`

### Python tests

There are some unit tests for the python script and some test data. To run them:

    cd scripts
    python3 -m unittest rsfcreator_test