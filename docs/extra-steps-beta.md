# Extra Steps For Loading Beta Register checklist

## Prerequisites
This document assumes you have followed the instructions in the main README for [How to create a new register in an existing environment](../README.md#how-to-create-a-new-register-in-an-existing-environment) so that at this point going to `https://register-name.register.gov.uk/` shows `Register undefined`.

## Steps

### 1. Add credentials to managing-registers

Get the credentials from registers-pass:

`registers-pass show beta/app/mint/$register-name`

Ensure you have the `RAILS_MASTER_KEY` environment variable set:
```
export RAILS_MASTER_KEY=`registers-pass show registers/app/manager/store`
```
From your `managing-registers` checkout directory run:

`rails secrets:edit`

Add credentials for new register and save file

Commit changes to `config/secrets.yml.enc` to a branch

Raise a PR and merge to `master`

### 2. Ensure `registry-data` respository matches data to be loaded into Beta

*Note: this step may be done by a Data Analyst or a Developer. All other steps can only be done by a Developer.*
Create a pull-request ([example](https://github.com/openregister/registry-data/commit/045d7502869b9a19632f85115a90c0cfe6762b39)) in `registry-data` moving all register data associated with the register to be promoted into the `/beta` directory. This should include any new fields added to the `/field` subdirectory, a new file in the `/register` subdirectory as well as a new subdirectory for the new register itself. Merge this into `master`.

### 3. Load new records into basic registers

Follow the instructions in [Loading a new field or register](../scripts/readme.md#loading-a-new-field-or-register) and run the script for each new field associated with the register, the register itself and any new datatypes.

### 4. Run Ansible Task

Registers load a config file from S3 at start-up, this must be updated to reflect the newly created registers and fields as a prerequisite to loading data.
Run: `ansible-playbook refresh_register_field_config_in_s3.yml -e vpc=beta`

### 5. Re-deploy ORJ

openregister-java (ORJ) must be re-deployed to pick up the S3 config changes we made in the previous step. 
From the CodePipeline console click *Release Change* to re-deploy the current `master` build and complete each step of the pipeline.

### 6. Load data for new register

Make sure you have checked out the `.tsv` file containing the user entries to be loaded. Follow the steps in [Loading or updating the data for a register](../scripts/readme.md#loading-or-updating-the-data-for-a-register) making sure to enter *no* when prompted if you want to delete the existing register.