# PaaS Redirects

This directory contains code and config for redirecting traffic from one 
domain to another via a static site app running on PaaS as per [these steps](https://docs.cloud.service.gov.uk/#redirecting-all-traffic).

There are 3 separate applications for the following redirects.

## `www` redirects

The [www-redirect-config](www-redirect-config) directory contains config for 2 redirects.

- [registers.cloudapps.digital](https://registers.cloudapps.digital) to [www.registers.service.gov.uk](https://www.registers.service.gov.uk)
- [registers.service.gov.uk](https://registers.service.gov.uk) to [www.registers.service.gov.uk](https://www.registers.service.gov.uk)

```
cd www-redirect-config

cf target -o openregister -s prod
cf push
```

## `docs` redirects

The [docs-redirect-config](docs-redirect-config) directory contains config for 1 redirect.

- [registers-docs.cloudapps.digital](https://registers-docs.cloudapps.digital) to [docs.registers.service.gov.uk](https://docs.registers.service.gov.uk)

```
cd docs-redirect-config

cf target -o openregister -s docs
cf push
```

## `manage` redirects

The [manage-redirect-config](manage-redirect-config) directory contains config for 1 redirect.

- [managing-registers.cloudapps.digital](https://managing-registers.cloudapps.digital) to [manage.registers.service.gov.uk](https://manage.registers.service.gov.uk)

```
cd manage-redirect-config

cf target -o openregister -s prod
cf push
``` 
