# Ansible playbooks #

This contains specific documentation for individual ansible playbooks
not suitable for the toplevel README.

## letsencrypt ##

To run this playbook, the [lego](https://github.com/xenolf/lego)
binary must be available on your PATH.

By default, the letsencrypt staging server will be used (suitable for
testing, but not suitable for generating trusted certificates).

Example usage:

    # generate test cert from staging
    ansible-playbook letsencrypt.yml -e vpc=beta

    # generate real cert from production
    ansible-playbook letsencrypt.yml -e vpc=beta -e staging=no
