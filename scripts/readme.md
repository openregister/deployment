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

    ./load-register-tsv.sh country alpha country-data/data/country/country.tsv all local "Jo Doe"

### Loading a new field or register

Running the script **update-metadata-yaml.sh** will create an RSF file for the specified new field or register and load the RSF into the application.

Arguments:
- register/field
- phase
- YAML file path (relative to $OPENREGISTER_ROOT)
- local or remote depending on whether register and field definitions is to be read from the local file system or a remote ORJ service.

Examples:

    ./update-metadata-yaml.sh field alpha registry-data/data/discovery/field/clinical-commissioning-group.yaml local
    ./update-metadata-yaml.sh register alpha registry-data/data/discovery/register/clinical-commissioning-group.yaml local


### Loading or updating the Register Register or Field Register

Running the script **load-metadata-yaml.sh** will create an RSF file for the Register Register or Fields Register, of either system, user or all data, optionally delete the existing register from ORJ in the specified **phase** and load the RSF into the application.

Arguments:
- 'register' or 'field'
- phase
- `system`, `user` or `all`, depending on the type of data to be loaded
- local or remote depending on whether register and field definitions is to be read from the local file system or a remote ORJ service

Examples:

    ./load-metadata-yaml.sh field alpha all local "Jo Doe"

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

### Changing the description of a register

There is a script in `scripts/update_descriptions.py` to generate RSF to change the description of a register. This currently assumes that the register is in beta.

Run this using:

```
register=jobcentre-district
new_description='bla bla bla bla bla bla'

python update_descriptions.py $register $new_description > ${register}_update.rsf
```

Then load the RSF using:

```
./rsf-load.sh "https://${register}.beta.openregister.org" openregister `register-pass beta/app/mint/$register` < ${register}_update.rsf
```

This will update the API explorer, but at the time of writing, registers frontend won't automatically pick up the description, because system entries are not included in incremental updates.

### Python tests

There are some unit tests for the python script and some test data. To run them:

    cd scripts
    python3 -m unittest rsfcreator_test
