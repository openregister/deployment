# Instructions for creating discovery register environments

In these instructions, the new register to be created is called `meat-cuts`

## 1. AWS: edit the config file

Tell everyone you're creating a new register, so that you don't both do it at
the same time.

Log into AWS https://openregister.signin.aws.amazon.com/console

Go to the [S3 bucket](https://s3.console.aws.amazon.com/s3/buckets/openregister.discovery.config/?region=us-east-2&tab=overview)
or browse to `Services > Storage > S3 > openregister.discovery.config`

Download this
[file](https://s3.console.aws.amazon.com/s3/object/openregister.discovery.config/multi/openregister/paas-config.yaml?region=us-east-2&tab=overview)
(`/multi/openregister/paas-config.yaml`), which is used by the application to
know all the metadata about the register.

Edit the file.  Copy the last register at the bottom, e.g.

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

Save the file with the same name `paas-config.yaml`

Upload the file to AWS to replace the original.

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

If the name has already been created, then the `cf map-route` step will fail,
but you should have seen it in `cf routes` first anyway.

Browse to https://meat-cuts.cloudapps.digital/.  If everything has worked,
you'll see the message `Register undefined`.

## Deployment scripts

TBC -- they need to be changed to point to `cloudapps.digital` instead of
`discovery.openregister.org`.
