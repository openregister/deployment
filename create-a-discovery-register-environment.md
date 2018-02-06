# Instructions for creating discovery register environments

In these instructions, the new register to be created is called `meat-cuts`

## Prerequisites

- A GOV.UK PaaS account and access to the `openregister` organisation and `discovery` space as `SpaceDeveloper`.
- Access to the AWS console and [awscli](https://aws.amazon.com/cli/) installed (you will need to create and use an API key).
- Complete the bit at the bottom of [this section](https://github.com/openregister/credentials/#cloning-the-repo-and-setting-paths) where it says "Finally, import and validate the keys".  You might need to do this again if someone has joined or left the team.

## 1. AWS: edit the config file

Tell everyone you're creating a new register, so that you don't both do it at
the same time.

Download the latest config file from S3, which is used by the application to
know all the metadata about the register, using `./scripts/download-s3-config.sh`.

Edit your local copy of the file `vi scripts/config/paas-config.yaml`.  Copy the last register at the bottom, e.g.

```yaml
  fire-authority:
    schema: fire-authority
    enableDownloadResource: True
    enableRegisterDataDelete: True
    credentials:
      user: openregister
      password: duirVTX1Se
```

Rename the key and the `schema` to the name of the new register you want to create, and set
a new password you have created by following the [registers-pass
instructions](https://github.com/openregister/credentials/#updating-repo-adding-passwords-etc),
change the step `registers-pass generate -n os/dev/test 16` to `registers-pass
generate -n discovery/app/mint/meat-cuts 16`

Once the registers-pass pull request has been merged, pull the registers-pass
repository again and then use `registers-pass show discovery/app/mint/meat-cuts`
to show the new password.  Put it into the `paas-config.yaml` file that you are
still editing.

```yaml
  meat-cuts:
    schema: meat-cuts
    enableDownloadResource: True
    enableRegisterDataDelete: True
    credentials:
      user: openregister
      password: asdfl2349s
```

Upload the file to S3 to replace the original using `./scripts/upload-s3-config.sh`.

## 2. Cloudfoundry: add a route meat-cuts.cloudapps.digital

Log in at the command line `cf login`. The target is `openregister`.

```
cf target -s discovery
cf routes
cf map-route discovery-multi cloudapps.digital --hostname meat-cuts
cf routes
cf restart discovery-multi
```

When it restarts, it checks the config file, which is why you have to do that
first.

It will take everything down for a minute or so.

If the name has already been created, then the `cf map-route` step will fail.
Usually you should have seen it in `cf routes` first anyway, but it will also
fail if the that route exists anywhere else in the whole of PaaS. i.e. it will
fail if https://meat-cuts.cloudapps.digital has been claimed by any other user
of PaaS. So you won't necessarily be able to see it from cf routes as this only
shows routes for the current space/organisation.  We think this is unlikely to
happen, but if it does speak to a developer and they can help by giving it a
different domain via AWS.

Browse to https://meat-cuts.cloudapps.digital/.  If everything has worked,
you'll see the message `Register undefined`.

## Deployment scripts

TBC -- they need to be changed to point to `cloudapps.digital` instead of
`discovery.openregister.org`.
