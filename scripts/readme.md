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

- python3
- pip3
- load required packages with


    pip3 install -r requirements.txt


### Loading the data for a new register

Running the script **load-register-tsv.sh** will create an RSF file for the specified register including metadata, delete the existing
register from ORJ in the specified **phase** and load the RSF into the application.

Arguments:
- register name
- phase
- TSV file path (relative to $OPENREGISTER_ROOT)
- local or remote depending on whether register and field definitions is to be read from the local file system or a remote ORJ service.
- data directory (relative to $OPENREGISTER_ROOT) if data is not in $REGISTER-data [optional].

Examples:

    ./load-register-tsv.sh country alpha country-data/data/country/country.tsv local

### Loading a new field or register

Running the script **update-metadata-yaml.sh** will create an RSF file for the specified new field or register and load the RSF into the application.

Arguments:
- register/field name
- phase
- YAML file path (relative to $OPENREGISTER_ROOT)
- local or remote depending on whether register and field definitions is to be read from the local file system or a remote ORJ service.

Examples:

    ./update-metadata-yaml.sh field alpha registry-data/data/discovery/field/clinical-commissioning-group.yaml local
    ./update-metadata-yaml.sh register alpha registry-data/data/discovery/register/clinical-commissioning-group.yaml local

### Updating a register

Running the script **update-register-tsv.sh** will create an update RSF (**without** metadata entries) file to update the register and load the RSF into the application.

Arguments:
- register name
- phase
- TSV file path (relative to $OPENREGISTER_ROOT)
- local or remote depending on whether register and field definitions is to be read from the local file system or a remote ORJ service.
- data directory (relative to $OPENREGISTER_ROOT) if data is not in $REGISTER-data [optional].

Examples:

    ./update-register-tsv.sh local-authority-eng discovery local-authority-data/data/local-authority-eng/local-authority-eng.tsv remote local-authority-data


### Reloading the whole Register Register or Fields Register

Running the script **reload-metadata-yaml.sh** will create an RSF file for the Register Register or Fields Register including metadata, delete the existing register from ORJ in the specified **phase** and load the RSF into the application.

#### Warning

Instances of ORJ serving the Field and Register Registers read files containing fields and registers YAML from S3 on startup.

There is an Ansible task in the deployment repo to generate the files in S3 from the application. You will need to run this after
reloading the metadata RSF. 

Arguments:
- 'register' or 'field'
- phase
- local or remote depending on whether register and field definitions is to be read from the local file system or a remote ORJ service.

Examples:

    ./reload-metadata-yaml.sh field alpha local
