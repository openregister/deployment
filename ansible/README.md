# Ansible playbooks #

This contains specific documentation for individual ansible playbooks
not suitable for the toplevel README.

## letsencrypt ##

To run this playbook, the [lego](https://github.com/xenolf/lego)
binary must be available on your PATH.

NOTE - until https://github.com/xenolf/lego/issues/362 is resolved you will 
need to make sure your lego binary includes this change https://github.com/xenolf/lego/pull/357. 
Until there is a new release of lego it might be necessary to install it from source.

By default, the letsencrypt staging server will be used (suitable for
testing, but not suitable for generating trusted certificates).

Example usage:

    # generate test cert from staging
    ansible-playbook letsencrypt.yml -e vpc=beta

    # generate real cert from production
    ansible-playbook letsencrypt.yml -e vpc=beta -e staging=no
    
The certificate will be put in tls-certs/${VPC}/certificates.  It can
then be uploaded with the terraform scripts in aws/tls-certs.

It can take quite some time to provision the certificates.  You can
follow progress of the lego client in `../tls-certs/${VPC}/lego.log`.


## Remove users ##

Use script `remove-users.yml` to remove user from an environment. 
Add user to be removed in the users list in the file `remove-users.yml` 
and then run command: 

`ansible-playbook remove-users.yml -e vpc=<vpcname>`
